;; -------------------------------------------------
;; Load custom.el
;; -------------------------------------------------

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; -------------------------------------------------
;; Prefix Keymaps
;; -------------------------------------------------

(defvar jf-emacs (make-sparse-keymap))
(defvar vuejs-map (make-sparse-keymap))
(defvar ha-map (make-sparse-keymap))
(defvar term-map (make-sparse-keymap))
;;(defvar html-map (make-sparse-keymap))

(define-key global-map (kbd "C-c e") jf-emacs)
(define-key global-map (kbd "C-c v") vuejs-map)
(define-key global-map (kbd "C-c f") ha-map)
(define-key global-map (kbd "C-c t") term-map)
;;(define-key global-map (kbd "C-c h") html-map)

;; -------------------------------------------------
;; Main Keybindings
;; -------------------------------------------------

(global-set-key (kbd "C-p") 'copy-line-below)

(global-set-key (kbd "M-<f1>") 'copy-word-below)
(global-set-key (kbd "M-<f2>") 'rwebmode)
(global-set-key (kbd "<M-S-f2>") 'web-mode-element-close)
(global-set-key (kbd "<M-f3>") 'selecttemplates)
(global-set-key (kbd "<M-S-f3>") 'list-colors-display)
(global-set-key (kbd "<M-f4>") 'listkeybinds)
(global-set-key (kbd "<M-S-f4>") 'killdirs)
(global-set-key (kbd "<M-f5>") 'insert-vue-sfc-skeleton)
(global-set-key (kbd "<M-f6>") 'eval-last-sexp)
(global-set-key (kbd "<M-S-f7>") 'ctimedate)

;; -------------------------------------------------
;; Prefix Maps
;; -------------------------------------------------

(define-key jf-emacs (kbd "b") 'my-bookmark-files-by-extension)
(define-key jf-emacs (kbd "d") 'my-display-color-sequence)
(define-key jf-emacs (kbd "f") 'search-files-by-regex)
(define-key jf-emacs (kbd "c") 'show-custom-global-keys)

(define-key vuejs-map (kbd "t") 'load-vuetemplate)

(define-key ha-map (kbd "b") 'get-haskell-scratch)
(define-key ha-map (kbd "s") 'haskell-send-region-to-vterm)

(define-key term-map (kbd "t") 'eat)

;; -------------------------------------------------
;; Alt Bindings
;; -------------------------------------------------

(global-set-key (kbd "C-f") 'grep)
(global-set-key (kbd "M-1") 'dropprog)
(global-set-key (kbd "M-a") 'list-last-minibuffer-commands)
(global-set-key (kbd "M-2") 'dropweb)
(global-set-key (kbd "M-3") 'dropdoc)
(global-set-key (kbd "M-s") 'cu-jump-to-function)
(global-set-key (kbd "M-4") 'info)
(global-set-key (kbd "M-5") 'cgrep3)
(global-set-key (kbd "M-6") 'describe-bindings)
(global-set-key (kbd "M-7") 'ielm)
(global-set-key (kbd "M-8") 'copy-lines-below)
(global-set-key (kbd "M-9") 'copy-region-below)
(global-set-key (kbd "M-0") 'org-info)

(global-set-key (kbd "M-o M-e") 'org-entities-help)
(global-set-key (kbd "M-o M-i") 'toggle-input-method)
(global-set-key (kbd "M-o M-s") 'set-input-method)
(global-set-key (kbd "M-o M-d") 'describe-input-method)
(global-set-key (kbd "M-o M-t") 'org-table-create-or-convert-from-region)
(global-set-key (kbd "M-o M-l") 'find-library)
(global-set-key (kbd "M-o M-n") 'Info-search)
(global-set-key (kbd "M-o M-p") 'export-installed-packages-to-org)
(global-set-key (kbd "M-o M-a") 'insert-org-html-export-block)
(global-set-key (kbd "M-o M-b") 'org-bulletify-region)
(global-set-key (kbd "M-o M-c") 'org-load-template)
(global-set-key (kbd "M-o M-v") 'org-load-template-vue)
(global-set-key (kbd "M-o M-w") 'alpinetemplate)
(global-set-key (kbd "M-o M-h") 'my-org-export-to-custom-html)
(global-set-key (kbd "M-o M-u") 'my-org-export-to-vue-html)

(global-set-key (kbd "C-c r")
                (lambda ()
                  (interactive)
                  (set-input-method "russian-computer")))

(global-set-key (kbd "C-c C-r") 'elixir-repl)
(global-set-key (kbd "C-c C-c C-t") 'alpinetemplate)

;; -------------------------------------------------
;; Function Keys
;; -------------------------------------------------

(global-set-key [f1] 'save-buffer)
(global-set-key [C-f1] 'crux-rename-file-and-buffer)
(global-set-key [f2] 'other-window)
(global-set-key [C-f2] 'emacs-index-search)
(global-set-key [S-f2] 'grep)
(global-set-key [f3] 'comment-region)
(global-set-key [C-f3] 'uncomment-region)
(global-set-key [f4] 'bookmark-set)
(global-set-key [C-f4] 'bookmark-jump)
(global-set-key [S-f4] 'list-bookmarks)
(global-set-key [f5] 'my-grep4)
(global-set-key [C-f5] 'filesearch)
(global-set-key [S-f5] 'rgc)
(global-set-key [f6] 'kill-buffer)
(global-set-key [C-f6] 'kill-some-buffers)
(global-set-key [S-f6] 'crux-kill-other-buffers)
(global-set-key [f7] 'find-file)
(global-set-key [C-f7] (lambda () (interactive) (load-file "~/.emacs")))
(global-set-key [S-f7] (lambda () (interactive) (find-file "~/.emacs")))
(global-set-key [f8] 'copy-to-register)
(global-set-key [C-f8] #'cut-to-register)
(global-set-key [S-f8] 'insert-register)
(global-set-key [f9] 'undo)
(global-set-key [C-f9] 'describe-key)
(global-set-key [S-f9] 'describe-function)
(global-set-key [f10] 'search-and-replace-current-dir)
(global-set-key [S-f10] 'search-and-replace)
(global-set-key [C-f10] 'customize-themes)
(global-set-key [C-f11] 'text-scale-increase)
(global-set-key [C-f12] 'text-scale-decrease)

;; -------------------------------------------------
;; Extra
;; -------------------------------------------------

(global-set-key
 (kbd "C-d")
 (lambda ()
   (interactive)
   (execute-kbd-macro (kbd "C-s def RET"))))

(defvar my-themes
  '(modus-operandi-deuteranopia
    modus-vivendi
    doom-dracula
    doom-one)
  "List of themes to cycle through.")
