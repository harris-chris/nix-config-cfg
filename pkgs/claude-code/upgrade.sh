#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NIX="$SCRIPT_DIR/package.nix"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [OPTIONS] [VERSION]"
    echo ""
    echo "Updates claude-code to the specified version (or latest if not specified)."
    echo ""
    echo "Options:"
    echo "  --skip-final-build    Skip the final build test (faster)"
    echo "  --build-timeout SECS  Set build timeout in seconds (default: 600)"
    echo ""
    echo "Examples:"
    echo "  $0                        # Update to latest version"
    echo "  $0 1.0.60                 # Update to specific version"
    echo "  $0 --skip-final-build     # Update to latest, skip final test"
    echo "  $0 --build-timeout 900 1.0.60  # 15 minute timeout"
    echo ""
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

get_latest_version() {
    log_info "Fetching latest claude-code version..."
    
    if command -v npm >/dev/null 2>&1; then
        npm view @anthropic-ai/claude-code version
    else
        log_info "npm not found, using nix-shell..."
        nix-shell -p nodePackages.npm --run "npm view @anthropic-ai/claude-code version"
    fi
}

get_source_hash() {
    local version="$1"
    local url="https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz"
    
    log_info "Fetching source hash for version $version..."
    local hash
    hash=$(nix-prefetch-url "$url" 2>/dev/null)
    # nix-prefetch-url outputs hash first, then "path is ..." message
    hash=$(echo "$hash" | head -n1)
    if [[ -n "$hash" && "$hash" != "path is"* ]]; then
        echo "$hash"
    else
        log_error "Failed to fetch source hash. Got: $hash"
        return 1
    fi
}

update_package_nix() {
    local version="$1"
    local source_hash="$2"
    
    log_info "Updating package.nix with version $version..."
    
    # Update version
    sed -i "s/version = \"[^\"]*\";/version = \"$version\";/" "$PACKAGE_NIX"
    
    # Update source hash (using | as delimiter since hash might contain /)
    sed -i "s|hash = \"[^\"]*\";|hash = \"$source_hash\";|" "$PACKAGE_NIX"
    
    # Set npmDepsHash to fakeHash temporarily
    sed -i "s/npmDepsHash = \"[^\"]*\";/npmDepsHash = lib.fakeHash;/" "$PACKAGE_NIX"
}

update_package_lock() {
    local version="$1"
    
    log_info "Updating package-lock.json..."
    
    if command -v npm >/dev/null 2>&1; then
        cd "$SCRIPT_DIR"
        npm i --package-lock-only "@anthropic-ai/claude-code@$version"
        # Clean up package.json if it was created
        [ -f package.json ] && rm -f package.json
    else
        log_warn "npm not available, using nix-shell..."
        nix-shell -p nodePackages.npm --run "cd '$SCRIPT_DIR' && npm i --package-lock-only '@anthropic-ai/claude-code@$version' && rm -f package.json"
    fi
}

get_npm_deps_hash() {
    local timeout="$1"
    log_info "Building to get npmDepsHash (timeout: ${timeout}s)..."
    log_info "Build output will be shown below..."
    
    # Create temporary file to capture stderr while showing output
    local temp_file=$(mktemp)
    local exit_code=0
    
    # Run the build command, showing output in real-time and capturing stderr
    if timeout "$timeout" nix build .#homeConfigurations.chris.activationPackage 2> >(tee "$temp_file" >&2); then
        log_error "Build succeeded unexpectedly. npmDepsHash might already be correct."
        rm -f "$temp_file"
        return 1
    else
        exit_code=$?
        if [[ $exit_code -eq 124 ]]; then
            log_error "Build timed out after ${timeout} seconds. Try increasing --build-timeout"
            rm -f "$temp_file"
            return 1
        fi
        
        # Extract the hash from the captured stderr
        local hash
        hash=$(grep -o "got:.*sha256-[A-Za-z0-9+/=]*" "$temp_file" | sed 's/got:[[:space:]]*//')
        rm -f "$temp_file"
        
        if [[ -n "$hash" ]]; then
            echo "$hash"
        else
            log_error "Could not extract npmDepsHash from build output"
            return 1
        fi
    fi
}

update_npm_deps_hash() {
    local hash="$1"
    
    log_info "Updating npmDepsHash to $hash..."
    sed -i "s/npmDepsHash = lib.fakeHash;/npmDepsHash = \"$hash\";/" "$PACKAGE_NIX"
}

test_build() {
    local timeout="$1"
    log_info "Testing final build (timeout: ${timeout}s)..."
    log_info "Build output will be shown below..."
    
    if timeout "$timeout" nix build .#homeConfigurations.chris.activationPackage; then
        log_success "Build successful!"
        return 0
    else
        local exit_code=$?
        if [[ $exit_code -eq 124 ]]; then
            log_error "Final build timed out after ${timeout} seconds"
            log_warn "The upgrade may still be successful. Try building manually:"
            log_warn "  nix build .#homeConfigurations.chris.activationPackage"
            return 1
        else
            log_error "Build failed!"
            return 1
        fi
    fi
}

main() {
    local target_version=""
    local skip_final_build=false
    local build_timeout=600  # 10 minutes default
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                print_usage
                exit 0
                ;;
            --skip-final-build)
                skip_final_build=true
                shift
                ;;
            --build-timeout)
                if [[ -n "${2:-}" ]] && [[ "$2" =~ ^[0-9]+$ ]]; then
                    build_timeout="$2"
                    shift 2
                else
                    log_error "Invalid timeout value. Must be a number."
                    exit 1
                fi
                ;;
            -*)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
            *)
                if [[ -z "$target_version" ]]; then
                    target_version="$1"
                else
                    log_error "Too many arguments"
                    print_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # If no version specified, get latest
    if [[ -z "$target_version" ]]; then
        target_version=$(get_latest_version)
    fi
    
    log_info "Upgrading claude-code to version $target_version"
    
    # Get current version
    local current_version
    current_version=$(grep 'version = ' "$PACKAGE_NIX" | sed 's/.*version = "\([^"]*\)".*/\1/')
    log_info "Current version: $current_version"
    
    if [[ "$current_version" == "$target_version" ]]; then
        log_warn "Already at version $target_version"
        exit 0
    fi
    
    # Create backup
    local backup_file="${PACKAGE_NIX}.backup.$(date +%Y%m%d%H%M%S)"
    cp "$PACKAGE_NIX" "$backup_file"
    log_info "Created backup: $backup_file"
    
    # Step 1: Get source hash
    local source_hash
    if ! source_hash=$(get_source_hash "$target_version"); then
        log_error "Failed to get source hash"
        exit 1
    fi
    source_hash=$(nix hash convert --hash-algo sha256 --to sri "$source_hash")
    
    # Step 2: Update package.nix with new version and source hash
    update_package_nix "$target_version" "$source_hash"
    
    # Step 3: Update package-lock.json
    if ! update_package_lock "$target_version"; then
        log_error "Failed to update package-lock.json"
        mv "$backup_file" "$PACKAGE_NIX"
        exit 1
    fi
    
    # Step 4: Get npmDepsHash
    local npm_deps_hash
    if ! npm_deps_hash=$(get_npm_deps_hash "$build_timeout"); then
        log_error "Failed to get npmDepsHash"
        mv "$backup_file" "$PACKAGE_NIX"
        exit 1
    fi
    
    # Step 5: Update npmDepsHash
    update_npm_deps_hash "$npm_deps_hash"
    
    # Step 6: Test final build (optional)
    if [[ "$skip_final_build" == "false" ]]; then
        if ! test_build "$build_timeout"; then
            log_warn "Final build test failed, but upgrade may still be successful"
            log_info "You can test manually with: nix build .#homeConfigurations.chris.activationPackage"
            # Don't restore backup on final build failure - the upgrade is probably fine
        fi
    else
        log_info "Skipping final build test as requested"
        log_info "You can test manually with: nix build .#homeConfigurations.chris.activationPackage"
    fi
    
    # Clean up backup on success
    rm "$backup_file"
    
    log_success "Successfully upgraded claude-code to version $target_version"
    log_info "You can now apply the changes with:"
    log_info "  ./result/activate"
}

# Change to repo root
cd "$(dirname "$(dirname "$SCRIPT_DIR")")"

main "$@"