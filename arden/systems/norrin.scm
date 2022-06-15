(define-module (engstrand systems norrin)
  #:use-module (engstrand utils)
  #:use-module (engstrand systems)
  #:use-module (engstrand features display)
  #:use-module (rde features system)
  #:use-module (dwl-guile home-service)
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
    #:timezone %engstrand-timezone
    #:locale %engstrand-locale)
   (feature-bootloader
    #:bootloader-configuration
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets '("/boot/efi"))
     (keyboard-layout %engstrand-keyboard-layout)))
   (feature-file-systems
    ;; #:mapped-devices %mapped-devices
    #:file-systems
    (list
     (file-system
      (mount-point "/boot/efi")
      (device (uuid "1A1B-7B25" 'fat32))
      (type "vfat"))
     (file-system
      (mount-point "/home")
      (device
       (file-system-label "root_partition"))
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
      (name "DP-1")
      (x 0)
      (y 0)
      (rotate 'right)
      (width 1920)
      (height 1440)
      (refresh-rate 60)
      (adaptive-sync? #t))
     (dwl-monitor-rule
      (name "DP-2")
      (x 3000)
      (y 0)
      (width 1920)
      (height 1080)
      (refresh-rate 60)
      (adaptive-sync? #t))
     (dwl-monitor-rule
      (name "HDMI-1")
      (x 1920)
      (y -200)
      (rotate 'left)
      (width 1920)
      (height 1440)
      (refresh-rate 60)
      (adaptive-sync? #t))))))
