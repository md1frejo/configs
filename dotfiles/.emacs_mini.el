;; Minimal UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; No line highlight
(global-hl-line-mode -1)

;; Packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(dolist (pkg '(vertico marginalia corfu embark))
  (unless (package-installed-p pkg)
    (package-refresh-contents)
    (package-install pkg)))

(vertico-mode)
(marginalia-mode)
(global-corfu-mode)

(global-set-key (kbd "C-.") 'embark-act)
