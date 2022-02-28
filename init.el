;; emacs settings
(setq inhibit-startup-message t) ; disable startup message
(setq use-dialog-box nil) ; disable window dialog boxes

(setq backup-directory-alist '(("" . "~/.cache/emacs/backup"))) ; backup file dir
(setq auto-save-file-name-transforms
		`((".*" "~/.cache/emacs/autosave" t))) ; auto-save file dir

;; emacs ui settings
(scroll-bar-mode 0) ; disable scroll-bar
(tool-bar-mode 0)	 ; disable tool-bar
(tooltip-mode 0)	; disable tooltips
(menu-bar-mode 0)	 ; disable menu-bar

;; editor settings
(column-number-mode t)
(global-display-line-numbers-mode t) ; turn on line numbers
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width-start 3)
(setq display-line-numbers-grow-only t)
(setq-default indicate-empty-lines t) ; indicates empty lines at end of buffer
(global-hl-line-mode t) ; highlight cursor line
(electric-pair-mode t) ; auto-paring for parenthesis
(set-face-attribute 'hl-line nil :inherit nil :background "gray6")
(visual-line-mode t) ; wrap line breaks nicely on whitespace
(show-paren-mode t) ; matches and highlights parentheses
(setq show-paren-delay 0)
(blink-cursor-mode 0) ; no cursor blinking
(setq x-stretch-cursor t) ; make cursor stretch large characters such as tabs

(load-theme 'material-light t)
(set-cursor-color "#e16a98")

;; default major mode
(setq default-major-mode 'text-mode)

;; show dired on emacs startup
(add-hook 'after-init-hook #'dired-jump)

(defun rmh/set-margins ()
	"Set margins in current buffer."
	(setq left-margin-width 100)
	(setq right-margin-width 100))

(add-hook 'text-mode-hook 'rmh/set-margins)

;; font
(set-face-attribute 'default nil :font "SauceCodePro Nerd Font Mono-14")

;; packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/"))) ; archives

(package-initialize)
(unless package-archive-contents ; refresh packages
	(package-refresh-contents))
(unless (package-installed-p 'use-package) ; install 'use-package' if not installed
	(package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ; make sure all packages are downloaded and installed before running them

(use-package rainbow-delimiters
	:hook (prog-mode . rainbow-delimiters-mode)) ; rainbow layered parens in programming mode

(use-package which-key
	:init
	(which-key-mode)
	:diminish which-key-mode
	:config
	(setq which-key-idle-delay 0.3))

(use-package ivy
	:diminish
	:bind (("C-s" . swiper)
		 :map ivy-minibuffer-map
		 ("TAB" . ivy-alt-done))
	:config
	(ivy-mode 1))
;; (setq ivy-initial-inputs-alist nil)) ; removes '^' from ivy input list

(use-package ivy-rich
	:after ivy
	:init
	(ivy-rich-mode 1))

(use-package counsel
	:bind (("C-M-j" . 'counsel-switch-buffer) ; TODO: set switching buffer to something
		 :map minibuffer-local-map
		 ("C-r" . 'counsel-minibuffer-history))
	:custom
	(counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
	:config
	(counsel-mode 1))

(use-package helpful
	:commands (helpful-callable helpful-variable helpful-command helpful-key)
	:custom
	(counsel-describe-function-function #'helpful-callable)
	(counsel-describe-variable-function #'helpful-variable)
	:bind
	([remap describe-function] . counsel-describe-function)
	([remap describe-command] . helpful-command)
	([remap describe-variable] . counsel-describe-variable)
	([remap describe-key] . helpful-key))

(use-package undo-tree
	:config
	(global-undo-tree-mode))

;(use-package perfect-margin ; auto centers every window
;	:custom
;	(perfect-margin-visible-width 120)
;	:config
;	;; enable perfect-mode
;	(perfect-margin-mode t))

(use-package evil
	:init
	(setq evil-want-keybinding t)
	(setq evil-want-keybinding nil)
	(setq evil-want-fine-undo t) ; make REPLACE one undo operation
	:config
	(evil-mode 1)
	:bind (:map evil-normal-state-map
			("u" . 'undo-tree-undo)
			("C-r" . 'undo-tree-redo)))

(use-package dired
	:ensure nil
	:commands (dired dired-jump)
	:custom ((dired-listing-switches "-lavh")))

;; custom emacs variable settings
;; window
(setq window-min-width 80) ; one 1980s terminal size is the minimum size of window we want
(setq window-min-height 8) ; minimum 8 lines high

;; shell
(setq shell-file-name "zsh")		 ; use correct shell (zsh)
(setq shell-command-switch "-ic")	; needed to pickup contents of $HOME/.zshrc

;; LIB FUNCTIONS
;; comment/uncomment a line/region of code
(defun rmh/comment-or-uncomment-region-or-line ()
	"Comments or uncomments the region or the current line if there's no active region."
	(interactive)
	(let (beg end)
		(if (region-active-p)
			(setq beg (region-beginning) end (region-end))
			(setq beg (line-beginning-position) end (line-end-position)))
		(comment-or-uncomment-region beg end)))

;; kill window and buffer
(defun rmh/kill-window-and-buffer ()
	"Closes window (if not last in frame) and kills the buffer displayed in window."
	(interactive)
	(kill-current-buffer)
	(delete-window))

;; CUSTOM MODES

;; TABS
(setq default-tab-width 8)

;; KEYMPAS
;; file commands
(defvar rmh/file-command-map
	(let ((map (make-sparse-keymap)))
		(define-key map (kbd "r") 'counsel-recentf)
		(define-key map (kbd "f") 'find-file)
		(define-key map (kbd "j") 'counsel-file-jump)
		(define-key map (kbd "d") 'dired-jump)
		map)
	"Keymap for file commands.")

;; shell commands
(defvar rmh/shell-command-map
	(let ((map (make-sparse-keymap)))
		(define-key map (kbd "s") 'shell)
		(define-key map (kbd "r") 'shell-command)
		(define-key map (kbd "R") 'shell-comman-on-region)
		map)
	"Keymap for shell commands.")

;; KEYBINDS
;; global
(global-set-key (kbd "C-#") 'rmh/comment-or-uncomment-region-or-line)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; make <escape> quit prompts

;; dired
(define-key dired-mode-map (kbd "i") 'dired-maybe-insert-subdir)
(define-key dired-mode-map (kbd "j") 'dired-next-line)
(define-key dired-mode-map (kbd "k") 'dired-previous-line)

;; evil modes
(evil-define-key 'normal 'global (kbd "SPC h") help-map)
(evil-define-key 'normal 'global (kbd "SPC f") rmh/file-command-map)
(evil-define-key 'normal 'global (kbd "SPC s") rmh/shell-command-map)
;; window
(windmove-default-keybindings)
(evil-define-key 'normal 'global (kbd "C-l") 'windmove-right)
(evil-define-key 'normal 'global (kbd "C-h") 'windmove-left)
(evil-define-key 'normal 'global (kbd "C-k") 'windmove-up)
(evil-define-key 'normal 'global (kbd "C-j") 'windmove-down)
(evil-define-key 'normal 'global (kbd "C-w") 'rmh/kill-window-and-buffer)
(evil-define-key 'normal 'global (kbd "C-S-k") 'enlarge-window)
(evil-define-key 'normal 'global (kbd "C-S-j") 'shrink-window)
(evil-define-key 'normal 'global (kbd "C-S-l") 'enlarge-window-horizontally)
(evil-define-key 'normal 'global (kbd "C-S-h") 'shrink-window-horizontally)
(evil-define-key 'normal 'global (kbd "C-S-w") 'delete-other-windows)
(evil-define-key 'normal 'global (kbd "SPC wb") 'balance-windows)
(evil-define-key 'normal 'global (kbd "SPC wss") 'split-window-right)
(evil-define-key 'normal 'global (kbd "SPC wsv") 'split-window-right)
(evil-define-key 'normal 'global (kbd "SPC wsh") 'split-window-below)
;; buffer navigation
(evil-define-key 'normal 'global (kbd "SPC bb") 'switch-to-buffer)
(evil-define-key 'normal 'global (kbd "SPC bk") 'kill-current-buffer)
(evil-define-key 'normal 'global (kbd "SPC bl") 'ibuffer)
(evil-define-key 'normal 'global (kbd "SPC bn") 'rename-buffer)
(evil-define-key 'normal 'global (kbd "SPC bs") 'save-buffer)
(evil-define-key 'normal 'global (kbd "C-n") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "C-m") 'next-buffer)
;; theme
(evil-define-key 'normal 'global (kbd "SPC tt") 'counsel-load-theme)
;; elisp evaluation
(evil-define-key 'normal 'global (kbd "SPC e") 'eval-last-sexp)
(evil-define-key 'normal 'global (kbd "SPC SPC") 'counsel-M-x)
;; macros
(evil-define-key 'normal 'global (kbd "SPC qq") 'kbd-macro-query)
(evil-define-key 'normal 'global (kbd "SPC qe") 'kmacro-edit-macro)

;; MODES CONFIG
;; elisp
(defun rmh/emacs-lisp-mode-settings ()
	(setq tab-width 4)
	(setq lisp-indent-offset 4))
(add-hook 'emacs-lisp-mode-hook 'rmh/emacs-lisp-mode-settings)

;; CUSTOM MINOR MODES
(add-hook 'isearch-mode-end-hook 'recenter-top-bottom)
(defun rmh/center-point-in-window (&rest _)
	(recenter))

(define-minor-mode rmh/natural-scroll-mode
	"Minor mode to always center point in the window for easy and smooth scrolling."
	nil
	:global t

	(if rmh/natural-scroll-mode
		(progn
			(advice-add 'next-line :after #'rmh/center-point-in-window)
			(advice-add 'previous-line :after #'rmh/center-point-in-window)
			(advice-add 'forward-line :after #'rmh/center-point-in-window)
			(advice-add 'isearch-forward :after #'rmh/center-point-in-window)
			(advice-add 'end-of-buffer :after #'rmh/center-point-in-window))
		(advice-remove 'next-line #'rmh/center-point-in-window)
		(advice-remove 'previous-line #'rmh/center-point-in-window)
		(advice-remove 'forward-line #'rmh/center-point-in-window)
		(advice-add 'isearch-forward #'rmh/center-point-in-window)
		(advice-remove 'end-of-buffer #'rmh/center-point-in-window)))
(rmh/natural-scroll-mode 1)
;; (advice-add 'evil-search-next :after #'evil-center-line)
;; (advice-add 'evil-search-previous :after #'evil-center-line)
;; (advice-add 'evil-search-forward :after #'evil-center-line)
;; (advice-add 'evil-search-backward :after #'evil-center-line)
