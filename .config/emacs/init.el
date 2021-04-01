(defvar my/frame-transparency '(90 . 90))
(defvar my/default-font "Fira Code Retina")
(defvar my/default-font-size 125)
(defvar my/projects-root "~/Projects/")
(defvar my/projects '("~/Projects/" "~/Projects/00_learning/"))
(defvar my/config "~/.config/emacs/README.org")

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun my/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'my/display-startup-time)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(setq use-package-verbose t)

(use-package no-littering
  :demand t)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(scroll-bar-mode -1)	; Disable visible scrollbar
(tool-bar-mode -1)		; Disable the toolbar
(tooltip-mode -1)		; Disable tooptips
(set-fringe-mode 10)	; Give some breathing room
(menu-bar-mode -1)		; Disable the menu bar

(setq visible-bell t)	; Set up the visible bell

(set-frame-parameter (selected-frame) 'alpha my/frame-transparency)
(set-face-attribute 'default nil :font my/default-font :height my/default-font-size)

(column-number-mode t)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(defun my/disable-display-line-numbers ()
  (display-line-numbers-mode 0))

(dolist (mode '(treemacs-mode-hook
                term-mode-hook
                shell-mode-hook))
  (add-hook mode #'my/disable-display-line-numbers))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons
  :demand t)

(use-package doom-themes
  :demand t
  :init (load-theme 'doom-palenight t))

(use-package doom-modeline
  :demand t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package ivy
  :demand t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ;; ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config (ivy-mode 1))

;; (use-package ivy-rich
;;   :demand t
;;   :after ivy
;;   :init (ivy-rich-mode 1))

;; (use-package counsel
;;   :demand t
;;   :bind (("C-x b" . 'counsel-switch-buffer)
;;          :map minibuffer-local-map
;;          ("C-r" . 'counsel-minibuffer-history))
;;   :config (counsel-mode 1))

(use-package which-key
  :defer 0
  :demand t
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

;; (use-package helpful
;;   :commands (helpful-callable helpful-variable helpful-command helpful-key)
;;   :custom ((counsel-describe-function-function #'helpful-callable)
;;            (counsel-describe-variable-function #'helpful-variable))
;;   :bind (([remap describe-function] . counsel-describe-function)
;;          ([remap describe-command] . helpful-command)
;;          ([remap describe-variable] . counsel-describe-variable)
;;          ([remap describe-key] . helpful-key)))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) 

(use-package general
  :after evil
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my/leader-keys
   "fde" '(lambda () (interactive) (find-file (expand-file-name my/config)))))

(use-package evil
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :demand t
  :after (evil general)
  :config
  (evil-collection-init))

;; Disable arrow keys in normal and visual modes
(defun my/dont-arrow-me-bro ()
  (interactive)
  (message "Arrow keys are bad, you know?"))
(define-key evil-normal-state-map (kbd "<left>") 'my/dont-arrow-me-bro)
(define-key evil-normal-state-map (kbd "<right>") 'my/dont-arrow-me-bro)
(define-key evil-normal-state-map (kbd "<down>") 'my/dont-arrow-me-bro)
(define-key evil-normal-state-map (kbd "<up>") 'my/dont-arrow-me-bro)
(evil-global-set-key 'motion (kbd "<left>") 'my/dont-arrow-me-bro)
(evil-global-set-key 'motion (kbd "<right>") 'my/dont-arrow-me-bro)
(evil-global-set-key 'motion (kbd "<down>") 'my/dont-arrow-me-bro)
(evil-global-set-key 'motion (kbd "<up>") 'my/dont-arrow-me-bro)

;; toggling comment symbols
(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; Tab width
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; Use tabs for indentation
(setq-default indent-tabs-mode)

;; Automatically clean whitespace
(use-package ws-butler
  :demand t
  :hook ((text-mode . ws-butler-mode)
         (org-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

(defun my/org-mode-setup ()
  (visual-line-mode 1))

(use-package org
  :commands (org-capture org-agenda)
  :hook (org-mode . my/org-mode-setup)
  :custom ((org-agent-start-with-log-mode t)
           (org-log-done 'time)
           (org-log-into-drawer t)))

(with-eval-after-load 'org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh". "src shell"))
  (add-to-list 'org-structure-template-alist '("el". "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py". "src python")))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t))))

;; Automatically tangle README.org as init.el on save
(defun my/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name my/config))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))
    ))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config)))

(defun my/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . my/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

;; (use-package lsp-ui
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :custom
;;   (lsp-ui-doc-position 'bottom))

;; (use-package lsp-treemacs
;;   :after lsp)

;; (use-package lsp-ivy
;;   :after lsp)

(use-package dap-mode
  :commands dap-debug dap-debug-last dap-debug-recent)

(use-package python-mode
  :hook (python-mode . lsp-deferred)
  :custom
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(add-hook 'python-mode-hook
          (lambda () (add-hook 'before-save-hook #'lsp-format-buffer nil 'local)))

;; (use-package company
;;   :after lsp-mode
;;   :hook (lsp-mode . company-mode)
;;   :bind
;;   (:map company-active-map ("<tab>" . company-complete-selection))
;;   (:map lsp-mode-map ("<tab>" . company-indent-or-complete-common))
;;   :custom
;;   (company-minimum-prefix-length 1)
;;   (company-idle-delay 0.0))

;; (use-package company-box
;;   :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p my/projects-root)
    (setq projectile-project-search-path my/projects))
  (setq projectile-switch-project-action #'projectile-dired))

;; (use-package counsel-projectile
;;   :after projectile
;;   :config (counsel-projectile-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash"))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
