;;; config.el -*- lexical-binding: t; -*-

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
(setq use-package-verbose nil)

(use-package no-littering
	:demand t)

(setq auto-save-file-name-transforms
			`((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(defvar my/frame-transparency '(90 . 90))
(defvar my/default-font "Fira Code Retina")
(defvar my/default-font-size 125)
(defvar my/config (expand-file-name "~/.config/emacs/config.org"))
(defvar my/org-directory (file-name-as-directory "~/Documents/org"))
(defvar my/org-notes (concat my/org-directory "notes.org"))
(defvar my/bookmarks (concat (expand-file-name "~/.config/") "bookmarks.txt"))
(defvar my/projects-root "~/Projects/")
(defvar my/projects '("~/Documents/org" "~/Projects" "~/Projects/00_learning"))

(setq-default
 indent-tabs-mode t										 ; Use tabs to indent
 tab-width 2)													 ; Set width for tabs

(setq-default
 cursor-in-non-selected-windows nil		 ; Hide the cursor in inactive windows
 cursor-type '(hbar . 2)							 ; Underline-shaped cursor
 custom-unlispify-menu-entries nil		 ; Prefer kebab-case for titles
 custom-unlispify-tag-names nil				 ; Prefer kebab-case for symbols
 delete-by-moving-to-trash t					 ; Delete files to trash
 fill-column 80												 ; Set width for automatic line breaks
 gc-cons-threshold (* 8 1024 1024)		 ; We're not using Game Boys anymore
 help-window-select t									 ; Focus new help windows when opened
 uniquify-buffer-name-style 'forward	 ; Uniquify buffer names
 window-combination-resize t					 ; Resize windows proportionally
 x-stretch-cursor t)									 ; Stretch cursor to the glyph width

(setq
 evil-want-fine-undo t									; By default while in insert all changes are one big blob. Be more granular
 auto-save-default t										; Auto... save...
 auto-save-list-file-prefix nil)				; Prevent tracking for auto-saves

(blink-cursor-mode 0)									 ; Prefer a still cursor
(fset 'yes-or-no-p 'y-or-n-p)					 ; Replace yes/no prompts with y/n
(global-subword-mode 1)								 ; Iterate through CamelCase words
(set-default-coding-systems 'utf-8)		 ; Default to utf-8 encoding

(setq-default custom-file null-device)

(add-function
 :after after-focus-change-function
 (defun my/garbage-collect-maybe ()
	 (unless (frame-focus-state) (garbage-collect))))

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
(use-package all-the-icons)

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

(use-package ivy-rich
	:after ivy
	:init (ivy-rich-mode 1))

(use-package counsel
	:bind
	("M-x" . 'counsel-M-x)
	("C-x b" . 'counsel-switch-buffer)
	:config (counsel-mode 1))

(use-package which-key
	:defer 1
	:demand t
	:diminish which-key-mode
	:config
	(which-key-mode)
	(setq which-key-idle-delay 0.3))

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

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
	:after evil
	:config
	(general-create-definer my/leader-key-def
		:keymaps '(normal insert visual emacs)
		:prefix "SPC"
		:global-prefix "C-SPC")
	(my/leader-key-def
		"fde" '(lambda () (interactive) (find-file (expand-file-name my/config)))))

(use-package evil
	:demand t
	:init
	(setq evil-want-integration t)
	(setq evil-want-keybinding nil)
	(setq evil-want-C-u-scroll t)
	(setq-default evil-shift-width tab-width)
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

(with-eval-after-load 'evil
	(setq evil-vsplit-window-right t
				evil-split-window-below t)
	(advice-add 'evil-window-split :after 'counsel-switch-buffer)
	(advice-add 'evil-window-vsplit :after 'counsel-switch-buffer))

;; Higlighting indentation
(use-package highlight-indent-guides
	:hook
	(prog-mode . highlight-indent-guides-mode)
	(markdown-mode . highlight-indent-guides-mode)
	:custom (highlight-indent-guides-method 'character))

;; Automatically clean whitespace
(use-package ws-butler
	:defer 1
	:demand t
	:config
	(ws-butler-global-mode 1))

(defun my/org-mode-setup ()
	(visual-line-mode 1))

(defun my/search-org-files ()
	(interactive)
	(counsel-rg "" my/org-directory nil "Search org-directory: "))

(use-package org
	:commands
	(org-capture
	 org-agenda
	 my/search-org-files)
	:hook (org-mode . my/org-mode-setup)
	:custom
	(org-directory my/org-directory)
	(org-default-notes-files my/org-notes)
	(org-startup-folded 'nofold)
	(org-catch-invisible-edits 'smart)
	(org-agenda-start-with-log-mode t)
	(org-log-done 'time)
	(org-log-into-drawer t)
	(org-agenda-files (directory-files-recursively org-directory "\\.org$"))
	(org-todo-keywords
	 '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))))

(with-eval-after-load 'org
	(require 'org-tempo)
	(add-to-list 'org-structure-template-alist '("sh". "src shell"))
	(add-to-list 'org-structure-template-alist '("el". "src emacs-lisp"))
	(add-to-list 'org-structure-template-alist '("py". "src python"))
	(add-to-list 'org-structure-template-alist '("json". "src json"))
	(add-to-list 'org-structure-template-alist '("yaml" . "src yaml")))

(with-eval-after-load 'org
	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((emacs-lisp . t))))

;; (with-eval-after-load 'org
;; 	 (defun my/org-path (path)
;; 		 (expand-file-name path org-directory))
;; 	 (setq org-default-notes-file (my/org-path "Inbox.org"))
;; 	 (setq org-agenda-custom-commands
;; 				 `(("d" "Dashboard"
;; 						((agenda "" ((org-deadline-warning-days 7)))
;; 						 (tags-todo "+PRIORITY=\"A\""
;; 												((org-agenda-overriding-header "High Priority")))
;; 						 (tags-todo "+followup" ((org-agenda-overriding-header "Needs Follow Up")))
;; 						 (todo "IN-PROGRESS"
;; 									 (org-agenda-max-todos nil))
;; 						(todo "WAITING"
;; 									(org-agenda-max-todos nil))
;; 						(todo "TODO"
;; 									(org-agenda-files '(,(my/org-path "Inbox.org")))
;; 									(org-agenda-text-search-extra-files nil)))))))

(use-package evil-org
	:after org
	:hook
	(org-mode . evil-org-mode)
	(org-agenda-mode . evil-org-mode)
	:config
	(require 'evil-org-agenda)
	(evil-org-agenda-set-keys))

(my/leader-key-def
	"o"   '(:ignore t :which-key "org mode")
	"os"  '(my/search-org-files :which-key "search")
	"oa"  '(org-agenda :which-key "status")
	"oc"  '(org-capture t :which-key "capture")
	"on"  '(org-toggle-narrow-to-subtree :which-key "toggle narrow")
	"ot"  '(org-todo-list :which-key "todos"))

(use-package doct)

(with-eval-after-load 'org
	(setq org-capture-templates
				(doct `(("Task" :keys "t"
								 :icon ("checklist" :set "octicon" :color "green")
								 :file my/org-notes
								 :prepend nil
								 :headline "Tasks"
								 :type entry
								 :template ("* TODO %?"
														"%i %a"))
								("Note" :keys "n"
								 :icon ("sticky-note-o" :set "faicon" :color "green")
								 :file my/org-notes
								 :prepend t
								 :headline "Notes"
								 :type entry
								 :template ("* %?"
														"%i %a"))
								("Bookmark" :keys "b"
								 :file my/bookmarks
								 :prepend nil
								 :type plain
								 :template ("%?	| "))))))

(defun my/org-capture-delete-frame (&rest _)
	"Delete frame with its name frame-parameter set to 'capture'."
	(if (equal "capture" (frame-parameter nil 'name))
			(delete-frame)))
(advice-add 'org-capture-finalize :after #'my/org-capture-delete-frame)

(defun my/org-capture-open-frame ()
	"Run org-capture in its own frame."
	(interactive)
	(require 'cl-lib)
	(select-frame-by-name "capture")
	(delete-other-windows)
	(cl-letf (((symbol-function 'switch-to-buffer-other-window) #'switch-to-buffer))
		(condition-case err
				(org-capture)
			;; "q" signals (error "Abort") in 'org-capture'
			;; delete the newly created frame in this scenario.
			(user-error (when (string= (cadr err) "Abort")
										(delete-frame))))))

;; Automatically tangle .org config file .el file on save
(defun my/org-babel-tangle-config ()
	(when (string-equal (buffer-file-name)
											(expand-file-name my/config))
		;; Dynamic scoping to the rescue
		(let ((org-confirm-babel-evaluate nil))
			(org-babel-tangle))
		))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config)))

(use-package dap-mode
	:commands dap-debug dap-debug-last dap-debug-recent)

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

(use-package lsp-ui
	:hook (lsp-mode . lsp-ui-mode)
	:custom
	(lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
	:after lsp)

;; (use-package lsp-ivy
;;		:after lsp)

;; ;; Create a buffer-local hook to run lsp-format-buffer on save, only when we enable prog-mode.
;; (add-hook 'prog-mode-hook
;;						(lambda () (add-hook 'before-save-hook #'lsp-format-buffer nil 'local)))

(use-package elixir-mode
	:hook
	(elixir-mode . lsp-deferred)
	:init
	(add-to-list 'exec-path "/usr/lib/elixir-ls")
	:config
	(require 'dap-elixir)
	(setq lsp-file-watch-ignored-directories
				(append lsp-file-watch-ignored-directories
								'("[/\\\\]deps\\'"
									"[/\\\\]_build\\'"
									"[/\\\\].elixir_ls\\'"))))

;; Create a buffer-local hook to run elixir-format on save, only when we enable elixir-mode.
(add-hook 'elixir-mode-hook
					(lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

(use-package markdown-mode
	:ensure t
	:mode (("\\.md\\'" . markdown-mode)
				 ("\\.markdown\\'" . markdown-mode)
				 ("README\\.md\\'" . gfm-mode))
	:init (setq markdown-command "multimarkdown"))

(use-package python-mode
	:hook (python-mode . lsp-deferred)
	:custom
	(dap-python-debugger 'debugpy)
	:config
	(require 'dap-python))

(use-package blacken
	:after python-mode
	:hook (python-mode . blacken-mode))

(use-package py-isort
	:after python-mode
	:hook (
				 ;; (python-mode . pyvenv-mode)
				 (before-save . py-isort-before-save)))

(use-package company
	:after lsp-mode
	:hook (lsp-mode . company-mode)
	:custom
	(company-minimum-prefix-length 1)
	(company-selection-wrap-around t)
	(company-show-numbers nil)
	(company-tooltip-align-annotations 't)
	(company-idle-delay 0))

(use-package company-box
	:after company
	:hook (company-mode . company-box-mode))

(use-package projectile
	:diminish projectile-mode
	:config (projectile-mode)
	:bind-keymap
	("C-c p" . projectile-command-map)
	:custom
	(projectile-completion-system 'ivy)
	(projectile-enable-caching t)
	:init
	(setq projectile-switch-project-action #'projectile-dired
				projectile-project-search-path my/projects
				projectile-sort-order 'access-time))

(with-eval-after-load 'projectile
	(projectile-discover-projects-in-directory my/projects-root)
	(projectile-discover-projects-in-directory my/org-directory))

(use-package counsel-projectile
	:after projectile
	:config (counsel-projectile-mode 1))

(use-package magit
	:commands (magit-status magit-get-current-branch)
	:custom
	(magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package plantuml-mode
	:custom
	(plantunl-server-url nil)
	(plantuml-default-exec-mode 'executable)
	(plantuml-executable-path "/usr/bin/plantuml")
	(plantuml-output-type "png"))

(add-to-list 'auto-mode-alist
						 '("\\.puml\\'" . plantuml-mode)
						 '("\\.plantuml\\'" . plantuml-mode))

(with-eval-after-load 'org
	(require 'org-tempo)
	(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
	(add-to-list 'org-structure-template-alist '("puml". "src plantuml")))

(use-package flycheck-plantuml
	:after plantuml-mode)

(with-eval-after-load 'plantuml-mode
	(require 'flycheck-plantuml)
	(flycheck-plantuml-setup))

(use-package smartparens
	:hook
	(org-mode . smartparens-mode)
	(prog-mode . smartparens-mode))

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
