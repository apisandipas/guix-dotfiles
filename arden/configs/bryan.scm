(define-module (engstrand configs bryan)
  #:use-module (rde features)
  #:use-module (rde features ssh)
  #:use-module (rde features base)
  #:use-module (rde features gnupg)
  #:use-module (gnu services)
  #:use-module (gnu services databases)
  #:use-module (gnu home-services ssh) ;; rde home-service
  #:use-module (engstrand utils)
  #:use-module (engstrand configs)
  #:use-module (engstrand features xorg)
  #:use-module (engstrand features sync)
  #:use-module (engstrand features utils)
  #:use-module (engstrand features state)
  #:use-module (engstrand features emacs)
  #:use-module (engstrand features browsers)
  #:use-module (engstrand features virtualization)
  #:use-module (engstrand features wayland))

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
    (feature-firefox
     #:default-browser? #t)
    (feature-kdeconnect))
   %engstrand-emacs-base-features))
