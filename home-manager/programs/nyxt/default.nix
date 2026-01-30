{ config, pkgs, lib, ... }:

{
  programs.nyxt = {
    enable = true;
    config = ''
      (in-package #:nyxt-user)

      (defvar *my-keyscheme-map*
        (define-keyscheme-map "my-base" ()
          nyxt/keyscheme:vi-normal
          (list
            "g b" (lambda-command switch-buffer*
                      nil
                    (switch-buffer :current-is-last-p
                                   t))
            "h" 'switch-buffer-previous
            "l" 'switch-buffer-next
            "f" 'nyxt/mode/hint:follow-hint
            "F" 'nyxt/mode/hint:follow-hint-new-buffer
            "j" 'nyxt/mode/document:scroll-down
            "k" 'nyxt/mode/document:scroll-up
            "b" 'nyxt/mode/history:history-backwards
            ":" 'execute-command
            "/" 'nyxt/mode/search-buffer:search-buffer
            "r" 'reload-buffer
            )))

      (define-configuration base-mode
        ((keyscheme-map *my-keyscheme-map*)))

      (define-configuration nyxt/mode/vi:vi-normal-mode
        ((keyscheme-map *my-keyscheme-map*)))

      (define-configuration web-buffer
        ((certificate-exceptions '("nyxt.atlas.engineer"))
         (default-modes (append '(nyxt/mode/vi:vi-normal-mode) %slot-default%))))

      ;; (defvar *my-search-engines*
      ;;   (list
      ;;    (make-instance 'search-engine
      ;;                   :name "Google"
      ;;                   :shortcut "goo"
      ;;                   #+nyxt-4 :control-url #+nyxt-3 :search-url
      ;;                   "https://duckduckgo.com/?q=~a")
      ;;    (make-instance 'search-engine
      ;;                   :name "MDN"
      ;;                   :shortcut "mdn"
      ;;                   #+nyxt-4 :control-url #+nyxt-3 :search-url
      ;;                   "https://developer.mozilla.org/en-US/search?q=~a")))

      (define-configuration browser
        ((restore-session-on-startup-p nil)
         (default-new-buffer-url (quri:uri "https://nyxt.atlas.engineer/documentation#keybinding-configuration"))

         (external-editor-program "hx")
         #+nyxt-4
         (search-engine-suggestions-p nil)
         #+nyxt-4
         (search-engines (append %slot-default% *my-search-engines*))
         ;; Sets the font for the Nyxt UI (not for webpages).
         (theme (make-instance 'theme:theme
                               :font-family "Iosevka"
                               :monospace-font-family "Iosevka"))
         ;; Whether code sent to the socket gets executed.  You must understand the
         ;; risks before enabling this: a privileged user with access to your system
         ;; can then take control of the browser and execute arbitrary code under your
         ;; user profile.
         ;; (remote-execution-p t)
         ))

    '';
  };
}
