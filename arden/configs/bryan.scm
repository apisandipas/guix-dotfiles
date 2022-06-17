(define-module (arden configs bryan)
  #:use-module (rde features)
  #:use-module (rde features ssh)
  #:use-module (rde features base)
  #:use-module (rde features gnupg)
  #:use-module (gnu services)
  #:use-module (gnu services databases)
  #:use-module (gnu home-services ssh) ;; rde home-service
  #:use-module (arden utils)
  #:use-module (arden configs)
  #:use-module (arden features xorg)
  #:use-module (arden features sync)
  #:use-module (arden features utils)
  #:use-module (arden features state)
  #:use-module (arden features emacs)
  #:use-module (arden features browsers)
  #:use-module (arden features virtualization)
  #:use-module (arden features wayland))

(define-public %user-features
  (append
   (list
    (feature-user-info
     #:user-name "bryan"
     #:full-name "Bryan Paronto"
     #:email "bryan@cablecar.digital")
    (feature-gnupg
     #:gpg-primary-key "7ADC2A21674DA808BF72EC481447CBC3E2E68A6A"
     ;;; consider changing this out for emacs pinentry? idk just a thought
     #:pinentry-flavor 'gtk2
     #:gpg-smart-card? #f)
    (feature-virtualization)
    (feature-qutebrowser)
    (feature-fonts
    #:font-monospace (font "Iosevka" #:size 11 #:weight 'regular)
    #:font-packages (list font-iosevka font-fira-mono))
    (feature-firefox
     #:default-browser? #t)
    (feature-kdeconnect))))
