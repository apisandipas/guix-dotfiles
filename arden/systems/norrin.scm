(define-module (arden systems norrin)
  #:use-module (arden utils)
  #:use-module (arden systems)
  #:use-module (arden features display)
  #:use-module (rde features system)
  #:use-module (rde features fontutils)
  #:use-module (dwl-guile home-service)
  #:use-module (gnu packages fonts)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices))

;; (define %mapped-devices
;;   (list
;;    (mapped-device
;;     (source
;;      (uuid "367c5fe8-0388-49ad-9c88-04bcfe62c7b9"))
;;     (target "cryptroot")
;;     (type luks-device-mapping))))

(define-public %system-features
  (list
   (feature-host-info
    #:host-name "norrin"
    #:timezone %arden-timezone
    #:locale %arden-locale)
   (feature-bootloader
    #:bootloader-configuration
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets '("/boot/efi"))
     (keyboard-layout %arden-keyboard-layout)))
   (feature-fonts
    #:font-monospace (font "Iosevka" #:size 11 #:weight 'regular)
    #:font-packages (list font-iosevka font-fira-mono))
   (feature-file-systems
    ;; #:mapped-devices %mapped-devices
    #:file-systems
    (list
     (file-system
      (mount-point "/boot/efi")
      (device (file-system-label "EFI_PART"))
      (type "vfat"))
     (file-system
      (mount-point "/home")
      (device
       (file-system-label "home_partition"))
      (type "ext4"))
     (file-system
      (mount-point "/")
      (device
       (file-system-label "root_partition"))
      (type "ext4"))))
   (feature-dwl-guile-monitor-config
    #:monitors
    (list
     (dwl-monitor-rule
      (name "eDP-1")
      (x 0)
      (y 0)
      (width 1920)
      (height 1080)
      (refresh-rate 60)
      (adaptive-sync? #t))
     ))))
