{ config, pkgs, lib, ... }:

{
  programs.nyxt = {
    enable = true;
    config = ''
      (in-package #:nyxt-user)

      ;; Keyboard defaults similar to qutebrowser
      (define-configuration buffer
        ((default-modes
          (pushnew 'nyxt/mode/emacs:emacs-mode %slot-value%))))

      ;; Key bindings similar to qutebrowser
      (define-configuration base-mode
        ((keyscheme-map
          (define-keyscheme-map "custom" (list :import %slot-value%)
            nyxt/keyscheme:cua
            (list
             ;; Follow links
             "f" 'nyxt/mode/hint:follow-hint
             "F" 'nyxt/mode/hint:follow-hint-new-buffer

             ;; Tab navigation
             "C-h" 'nyxt/mode/history:history-backwards
             "C-l" 'nyxt/mode/history:history-forwards
             "h" 'switch-buffer-previous
             "l" 'switch-buffer-next
             "b" 'nyxt/mode/history:history-backwards

             ;; Reload
             "R" 'reload-current-buffer

             ;; History
             "H" 'nyxt/mode/history:history-backwards

             ;; Search
             "M-n" 'nyxt/mode/search-buffer:search-buffer-previous)))))
    '';
  };
}
