export PATH="$coreutils/bin:$gcc/bin"
mkdir -p $out/bin
g++ -o $out/bin/getwsname $src
chmod +x $out/bin/getwsname
