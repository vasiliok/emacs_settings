;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       ;;(proto (if no-ssl "http" "https"))
       (proto "http")
       )
  
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks.bmkp")
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(package-selected-packages
   (quote
    (flycheck-pycheckers jedi-core jedi smart-mode-line cmake-mode helm-rtags company-rtags frame-tag realgud company-jedi company helm-projectile neotree projectile ace-window helm-gtags helm)))
 '(whitespace-style
   (quote
    (face trailing tabs spaces lines newline empty indentation space-after-tab space-before-tab space-mark tab-mark newline-mark))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(whitespace-space ((t (:background "black" :foreground "white"))))
;; '(whitespace-tab ((t (:background "black" :foreground "lightgray")))))
(require 'helm)
(require 'helm-config)
(require 'projectile)
(require 'frame-tag)
(frame-tag-mode 1)
(setq ac-auto-start nil)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

;; Set key bindings
(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

(defun xah-new-empty-buffer ()
  "Create a new empty buffer.
  New buffer will be named “untitled” or “untitled<2>”, “untitled<3>”, etc.
  It returns the buffer (for elisp programing).
  URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
  Version 2017-11-01"
  (interactive)
  (let (($buf (generate-new-buffer "untitled")))
    (switch-to-buffer $buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)
    $buf
    ))

(global-set-key (kbd "<f7>") 'xah-new-empty-buffer)
(global-set-key (kbd "<f5>") 'linum-mode)
(global-set-key (kbd "<f6>") 'whitespace-mode)

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name))
)

(setq initial-major-mode (quote text-mode))
(menu-bar-mode -1)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)


(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)
(helm-mode 1)
;; (desktop-save-mode 1)

(require 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)

(global-set-key (kbd "C-<up>") 'comint-previous-input)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:background "black" :foreground "lightgray"))))
 '(whitespace-tab ((t (:background "color-246" :foreground "lightgray")))))

(defun switch-on-whitespace-lineno ()
  "todo docs"
  (interactive)
  (linum-mode 1)
  (whitespace-mode·1)	
)

(add-hook 'makefile-gmake-mode 'switch-on-whitespace-lineno)
(sml/setup)
(setq sml/theme 'dark)
(add-to-list 'sml/replacer-regexp-list '("^~/ob10161/" ":10161:") t)

(add-to-list 'load-path "~/.emacs.d/bookmark-plus" "~/.emacs.d/realgud-master")
(load "bookmark+.el")
(load "~/.emacs.d/realgud-master/realgud.el")

;;(require 'rtags)
;;(setq rtags-path "/export/home/valeshec/src/rtags.build/bin")

(require 'company)

(require 'company-jedi)
(defun python-hook-setup ()
  "Python hook setup"
  (interactive)
  (message "python-mode-hook")
  (jedi:setup)
  (linum-mode)
)

(add-hook 'python-mode-hook 'python-hook-setup)

(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-to-list 'company-backends 'company-jedi)

;;(setq rtags-completions-enabled t)
;;(push 'company-rtags company-backends)
;;(global-company-mode)
;;(define-key c-mode-base-map (kbd "<C-t>") (function company-complete))


;;(require 'helm-rtags)
;;(setq rtags-use-helm t)
;;(setq rtags-display-result-backend 'helm)
(put 'upcase-region 'disabled nil)


(progn
  (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark )))
  (setq whitespace-display-mappings
    '(
      (space-mark 32 [183] [46])
      (newline-mark 10 [182 10])
      (tab-mark 9 [9655 9] [92 9]))
))

(defun after-init-fun ()
  (define-key global-map [C-home] 'beginning-of-buffer)
  (define-key global-map [C-end] 'end-of-buffer)
  (define-key global-map [home] 'beginning-of-line)
  (define-key global-map [end] 'end-of-line)
)
(add-hook 'after-init-hook 'after-init-fun)

(define-key global-map "\M-[1~" 'beginning-of-line)
(define-key global-map [select] 'end-of-line)

(setq tab-width 2)
  
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )
