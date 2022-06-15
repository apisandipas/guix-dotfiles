;; This module is responsible for configuring an operating system,
;; i.e. kernel, microcode, hostname, keyboard layout, etc.
;;
;; Base packages, services and other features should be defined in
;; arden/configs, or in one of the custom configs at arden/configs/.
(define-module (arden systems)
  #:use-module (rde features)
  #:use-module (rde features base)
  #:use-module (rde features system)
  #:use-module (rde features keyboard)
  #:use-module (gnu system)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system file-systems)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:export (
            %arden-timezone
            %arden-locale
            %arden-kernel-arguments
            %arden-keyboard-layout
            %arden-initial-os
            %arden-system-base-features

            %arden-timezone
            %arden-locale
            %arden-kernel-arguments
            %arden-keyboard-layout
            %arden-initial-os
            %arden-system-base-features
            ))


(define-public %arden-timezone "America/Chicago")
(define-public %arden-locale "en_US.utf8")

(define-public %arden-kernel-arguments
  (list "modprobe.blacklist=pcspkr,snd_pcsp"
        "quiet"))

(define-public %arden-keyboard-layout
  (keyboard-layout "us,se"
                   #:options
                   '("caps:ctrl")))

(define-public %arden-initial-os
  (operating-system
   (host-name "arden")
   (locale  %arden-locale)
   (timezone  %arden-timezone)
   (kernel linux)
   (firmware (list linux-firmware))
   (initrd microcode-initrd)
   (kernel-arguments %arden-kernel-arguments)
   (keyboard-layout %arden-keyboard-layout)
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))
   (services '())
   (file-systems %base-file-systems)
   (issue "This is the GNU/Linux+Arden system. Welcome.\n")))

(define-public %arden-system-base-features
  (list
   (feature-keyboard
    #:keyboard-layout %arden-keyboard-layout)))




