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

(set-fringe-mode 30) ; window padding left
(global-hl-line-mode 1) ; highlight cursor line
(set-face-attribute 'hl-line nil :inherit nil :background "gray6")
(visual-line-mode 1) ; wrap line breaks nicely on whitespace
(show-paren-mode 1) ; matches and highlights parentheses
(setq show-paren-delay 0)
(blink-cursor-mode 0) ; no cursor blinking

;; font
(set-face-attribute 'default nil :font "DejaVu Sans Mono-14")

;; packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/"))) ; archives

(package-initialize)
(unless package-archive-contents ; refresh packages
  (package-refresh-contents))
(unless (package-installed-p 'use-package) ; install 'use-package' if not installed
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ; make sure all packages are downloaded and installed before running them

(use-package material-theme
  :config
  (load-theme 'material t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ; rainbow layered parans in programming mode

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

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer) ; TODO: set switching buffer to something else
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

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-fine-undo t)
  :config
  (evil-mode 1))

(defun evil-center-line (&rest _) ; make evil center line on line move e.g. nnoremap j jzz)
  (evil-scroll-line-to-center nil))
(advice-add 'evil-line-move :after #'evil-center-line)
(advice-add 'evil-search-next :after #'evil-center-line)
(advice-add 'evil-search-previous :after #'evil-center-line)
(advice-add 'evil-search-forward :after #'evil-center-line)
(advice-add 'evil-search-backward :after #'evil-center-line)

;; Keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; make <escape> quit prompts

;; editor settings
(column-number-mode)
(global-display-line-numbers-mode t) ; turn on line numbers
