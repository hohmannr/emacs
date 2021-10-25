;; emacs settings
(setq inhibit-startup-message t) ; disable startup message
(setq use-dialog-box nil) ; disable window dialog boxes

(setq backup-directory-alist '(("" . "~/.cache/emacs/backup"))) ; backup file dir
(setq auto-save-file-name-transforms
      `((".*" "~/.cache/emacs/autosave" t))) ; auto-save file dir

;; emacs ui settings
(scroll-bar-mode -1) ; disable scroll-bar
(tool-bar-mode -1)   ; disable tool-bar
(tooltip-mode -1)    ; disable tooltips
(menu-bar-mode -1)   ; disable menu-bar

(global-hl-line-mode 1) ; highlight cursor line
(set-face-attribute 'hl-line nil :inherit nil :background "gray6")
(visual-line-mode 1) ; wrap line breaks nicely on whitespace
(show-paren-mode 1) ; matches and highlights parentheses
(setq show-paren-delay 0)
(blink-cursor-mode 0) ; no cursor blinking

(defun my-set-margins ()
  "Set margins in current buffer."
  (setq left-margin-width 100)
  (setq right-margin-width 100))

(add-hook 'text-mode-hook 'my-set-margins)

;; font
(set-face-attribute 'default nil :font "SauceCodePro Nerd Font Mono-13")

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

(use-package nano-theme
  :config
  (load-theme 'nano-light t))

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
;  (setq ivy-initial-inputs-alist nil)) ; removes '^' from ivy input list

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
;  :custom
;  (perfect-margin-visible-width 120)
;  :config
;  ;; enable perfect-mode
;  (perfect-margin-mode t))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
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

(defun evil-center-line (&rest _) ; make evil center line on line move e.g. nnoremap j jzz
  (evil-scroll-line-to-center nil))
(advice-add 'evil-line-move :after #'evil-center-line)
(advice-add 'evil-search-next :after #'evil-center-line)
(advice-add 'evil-search-previous :after #'evil-center-line)
(advice-add 'evil-search-forward :after #'evil-center-line)
(advice-add 'evil-search-backward :after #'evil-center-line)
(advice-add 'evil-goto-line :after #'evil-center-line)

;; keybindings
;; global
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; make <escape> quit prompts
;; window
(windmove-default-keybindings)
(evil-define-key 'normal 'global (kbd "C-l") 'windmove-right)
(evil-define-key 'normal 'global (kbd "C-h") 'windmove-left)
(evil-define-key 'normal 'global (kbd "C-k") 'windmove-up)
(evil-define-key 'normal 'global (kbd "C-j") 'windmove-down)
(evil-define-key 'normal 'global (kbd "C-w") 'delete-window)
(evil-define-key 'normal 'global (kbd "C-S-k") 'enlarge-window)
(evil-define-key 'normal 'global (kbd "C-S-l") 'shrink-window)
(evil-define-key 'normal 'global (kbd "C-S-h") 'shrink-window-horizontally)
(evil-define-key 'normal 'global (kbd "C-S-k") 'shrink-window-horizontally)
(evil-define-key 'normal 'global (kbd "C-S-w") 'delete-other-windows)
(evil-define-key 'normal 'global (kbd "SPC wb") 'balance-windows)
(evil-define-key 'normal 'global (kbd "SPC wss") 'split-window-right)
(evil-define-key 'normal 'global (kbd "SPC wsv") 'split-window-right)
(evil-define-key 'normal 'global (kbd "SPC wsh") 'split-window-below)
;; help bindings
(evil-define-key 'normal 'global (kbd "SPC ha") 'counsel-apropos)
(evil-define-key 'normal 'global (kbd "SPC hk") 'helpful-key)
(evil-define-key 'normal 'global (kbd "SPC hn") 'view-emacs-news)
(evil-define-key 'normal 'global (kbd "SPC hv") 'helpful-variable)
(evil-define-key 'normal 'global (kbd "SPC hp") 'finder-by-keyword)
(evil-define-key 'normal 'global (kbd "SPC hP") 'describe-package)
(evil-define-key 'normal 'global (kbd "SPC hf") 'counsel-describe-function)
;; file navigation
(evil-define-key 'normal 'global (kbd "SPC fr") 'counsel-recentf)
(evil-define-key 'normal 'global (kbd "SPC ff") 'find-file)
(evil-define-key 'normal 'global (kbd "SPC fj") 'counsel-file-jump)
(evil-define-key 'normal 'global (kbd "SPC fs") 'dired-jump)
;; buffer navigation
(evil-define-key 'normal 'global (kbd "SPC bb") 'switch-to-buffer)
(evil-define-key 'normal 'global (kbd "SPC bk") 'kill-buffer)
(evil-define-key 'normal 'global (kbd "SPC bl") 'ibuffer)
(evil-define-key 'normal 'global (kbd "C-n") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "C-m") 'next-buffer)
;; theme
(evil-define-key 'normal 'global (kbd "SPC tt") 'counsel-load-theme)
;; elisp evaluation
(evil-define-key 'normal 'global (kbd "SPC e") 'eval-last-sexp)
(evil-define-key 'normal 'global (kbd "SPC SPC") 'counsel-M-x)
;; save
(evil-define-key 'normal 'global (kbd "SPC s") 'save-buffer)

;; editor settings
(column-number-mode t)
(global-display-line-numbers-mode t) ; turn on line numbers
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-width-start 4)
(setq display-line-numbers-grow-only t)
(setq-default indicate-empty-lines t) ; indicates empty lines at end of buffer

;; erc custom connection to libera
(defun erc-connect-to-libera ()
  (interactive)
  (setq passwd (read-passwd "Password: "))
<<<<<<< HEAD
  (erc-tls :server "irc.libera.chat" :port 6697 :nick "akiosakuro" :password passwd))

