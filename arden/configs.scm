(define-module (arden configs)
  #:use-module (guix gexp)
  #:use-module (gnu packages fonts)
  #:use-module (rde features)
  #:use-module (rde features xdg)
  #:use-module (rde features ssh)
  #:use-module (rde features base)
  #:use-module (rde features linux)
  #:use-module (rde features fontutils)
  #:use-module (rde features version-control)
  #:use-module (dwl-guile patches)
  #:use-module (dwl-guile home-service)
  #:use-module (dtao-guile home-service)
  #:use-module (arden utils)
  #:use-module (arden systems)
  #:use-module (arden features nix)
  #:use-module (arden features base)
  #:use-module (arden features audio)
  #:use-module (arden features utils)
  #:use-module (arden features video)
  #:use-module (arden features state)
  #:use-module (arden features shells)
  #:use-module (arden features neovim)
  #:use-module (arden features wayland)
  #:use-module (arden features documents)
  #:use-module (arden features statusbar)
  #:export (
            %arden-base-system-packages
            %arden-base-home-packages
            %arden-base-features))

;; This module is responsible for creating the rde config.
;; It will define all the different base system services.
;;
;; Operating system configuration should be done in arden/systems.scm,
;; and computer specific settings in each corresponding file in arden/systems/.
;;
;; TODO: Add feature for setting custom groups (preferrably directly in features).
;;       This is required by certain services, e.g. virtualization.

(define %arden-base-system-packages
  (pkgs '("git" "nss-certs")))

;; Move some of the packages to separate features?
(define %arden-base-home-packages
  (pkgs '("curl" "htop" "ncurses"
          "hicolor-icon-theme" "adwaita-icon-theme" "gnome-themes-standard")))

;; Dynamically create a configuration that can be reproduced
;; without having the correct environment variables set.
;; This is required for some commands to work, e.g. guix pull.
(define (make-entrypoint)
  (scheme-file "entrypoint.scm"
               #~(begin
                   (use-modules (arden reconfigure))
                   (make-config #:user #$(getenv "RDE_USER")
                                #:system #$(gethostname)))))

(define %arden-base-features
  (list
   (feature-base-services
    #:guix-substitute-urls (list "https://substitutes.nonguix.org")
    #:guix-authorized-keys (list (local-file "files/nonguix-signing-key.pub")))
   (feature-desktop-services)
   (feature-switch-to-tty-on-boot)
   ;; TODO: Move to systems/*.scm?
   (feature-hidpi
    #:console-font (file-append font-terminus "/share/consolefonts/ter-120b"))
   (feature-git
    #:sign-commits? #t)
   (feature-fonts
    #:font-packages (list font-jetbrains-mono font-iosevka-aile)
    #:font-monospace (font "JetBrains Mono" #:size 13)
    #:font-sans (font "Iosevka Aile" #:size 13)
    #:font-serif (font "Iosevka Aile" #:size 13))
   (feature-pipewire)
   (feature-pulseaudio-control)
   (feature-backlight)
   (feature-zsh)
   (feature-ssh)
   (feature-xdg
    #:xdg-user-directories-configuration
    (home-xdg-user-directories-configuration
     (download "$HOME/downloads")
     (documents "$HOME/documents")
     (pictures "$HOME/images")
     (music "$HOME/music")
     (videos "$HOME/videos")
     (publicshare "$HOME")
     (templates "$HOME")
     (desktop "$HOME")))
   (feature-base-packages
    #:system-packages %arden-base-system-packages
    #:home-packages %arden-base-home-packages)
   ;; (feature-state-git
   ;;   #:repos
   ;;   `(("arden-config/utils" .
   ;;      "git@github.com:arden-config/utils.git")
   ;;     ("arden-config/home-dwl-service" .
   ;;      "git@github.com:arden-config/home-dwl-service.git")
   ;;     ("arden-config/farg" .
   ;;      "git@github.com:arden-config/farg.git")))
   (feature-dotfiles
    #:dotfiles
    `(("aliasrc" ,(local-file "files/aliasrc"))
      ("inputrc" ,(local-file "files/inputrc"))
      ("nix-channels" ,(local-file "files/nix-channels"))
      ("config/guix/channels.scm" ,(local-file "channels.scm"))
      ("config/guix/config.scm" ,(make-entrypoint))
      ("config/dunst/dunstrc" ,(local-file "files/config/dunst/dunstrc"))
      ("config/nvim/init.vim" ,(local-file "files/config/nvim/init.vim"))
      ("config/nvim/autoload/plug.vim" ,(local-file "files/config/nvim/autoload/plug.vim"))
      ("config/picom/picom.conf" ,(local-file "files/config/picom/picom.conf"))))
   (feature-nix)
   (feature-mpv)
   (feature-obs)
   (feature-imv)
   (feature-neovim)
   (feature-zathura)
   (feature-wayland-bemenu)
   (feature-wayland-bemenu-power)
   (feature-wayland-foot)
   (feature-wayland-mako)
   (feature-wayland-wlsunset)
   (feature-wayland-screenshot)
   (feature-wayland-swaylock)
   (feature-statusbar-dtao-guile)
   (feature-wayland-dwl-guile
    #:dwl-guile-configuration
    (home-dwl-guile-configuration
     (patches %arden-dwl-guile-patches)
     (config %arden-dwl-guile-config)))))
