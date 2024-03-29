;;; config.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun my/display-startup-time ()
	(message "Emacs loaded %d packages in %s with %d garbage collections."
					 (length package-activated-list)
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
(setq use-package-always-defer nil)
(setq use-package-verbose nil)

(use-package no-littering)

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

(defun my/set-frame-transparency (frame)
	(set-frame-parameter frame 'alpha my/frame-transparency))

(add-to-list 'after-make-frame-functions #'my/set-frame-transparency)
(my/set-frame-transparency (selected-frame))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons
	:defer t)

(use-package doom-themes
	:defer t
	:init (load-theme 'doom-palenight t))

(use-package doom-modeline
	:init (doom-modeline-mode 1)
	:custom
	(doom-modeline-height 15)
	(doom-modeline-lsp t)
	(doom-modeline-buffer-file-name-style 'truncate-except-project))

(use-package ivy
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
	:config
	(ivy-mode 1)
	:custom
	(ivy-wrap t)
	(ivy-use-virtual-buffers t))

(use-package counsel
	:bind
	("M-x" . 'counsel-M-x)
	("C-x b" . 'counsel-switch-buffer)
	:config (counsel-mode 1))

(use-package ivy-rich
	:defer 1
	:after (ivy counsel)
	:config (ivy-rich-mode 1))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(use-package undo-tree
	:after evil
	:config
	(global-undo-tree-mode 1))

(use-package evil
	:init
	(setq evil-want-integration t)
	(setq evil-want-keybinding nil)
	(setq evil-want-C-u-scroll t)
	(setq evil-undo-system 'undo-tree)
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
	:after (evil)
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

(use-package general
	:after evil
	:config
	(general-evil-setup t)
	(general-create-definer my/leader-key-def
		:keymaps '(normal insert visual emacs)
		:prefix "SPC"
		:global-prefix "C-SPC")
	(my/leader-key-def
		"fde" '(lambda () (interactive) (find-file (expand-file-name my/config)))))

(use-package which-key
	:defer 1
	:config
	(which-key-mode)
	(setq which-key-idle-delay 0.3))

;; Higlighting indentation
(use-package highlight-indent-guides
	:hook
	(prog-mode . highlight-indent-guides-mode)
	(markdown-mode . highlight-indent-guides-mode)
	:custom (highlight-indent-guides-method 'character))

;; Automatically clean whitespace
(use-package ws-butler
	:defer 1
	:config
	(ws-butler-global-mode 1))

(defun my/org-mode-setup ()
	(visual-line-mode 1))

(defun my/search-org-files ()
	(interactive)
	(counsel-rg "" my/org-directory nil "Search org-directory: "))

(defun my/org-agenda-dashboard ()
	(interactive)
	(org-agenda nil "n"))

(use-package org
	:commands
	(org-capture
	 org-agenda
	 my/search-org-files
	 my/org-agenda-dashboard)
	:hook
	(org-mode . my/org-mode-setup)
	:config
	(require 'org-tempo)
	:custom
	(org-directory my/org-directory)
	(org-startup-folded 'nofold)
	(org-src-tab-acts-natively t)
	(org-catch-invisible-edits 'smart))

(with-eval-after-load 'org
	(org-babel-do-load-languages
	 'org-babel-load-languages '(
															 (emacs-lisp . t)
															 (scheme . t)
															 )))

(with-eval-after-load 'org
	(defun my/org-add-structure-template (alias language)
		(add-to-list 'org-structure-template-alist `(,alias . ,(format "src %s" language))))

	(my/org-add-structure-template "sh" "shell")
	(my/org-add-structure-template "el" "emacs-lisp")
	(my/org-add-structure-template "py" "python")
	(my/org-add-structure-template "sc" "scheme")
	(my/org-add-structure-template "json" "json")
	(my/org-add-structure-template "yaml" "yaml"))

(with-eval-after-load 'org
	(setq
	 org-default-notes-files my/org-notes
	 org-agenda-start-with-log-mode t
	 org-log-done 'time
	 org-log-into-drawer t
	 org-agenda-files (directory-files-recursively org-directory "\\.org$")
	 org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))
	 org-todo-keyword-faces '(("IN-PROGRESS" . (:foreground "orange red" :weight bold))
														("WAITING" . (:foreground "HotPink2" :weight bold)))
	 org-priority-default ?C
	 ))

(with-eval-after-load 'org
	(setq org-agenda-custom-commands
				'(("n" "Dashboard - combines agenda and notes"
					 ((agenda "" ((org-deadline-warning-days 7)))
						(tags-todo "+PRIORITY=\"A\""
											 ((org-agenda-overriding-header "High Priority")))
						(todo "WAITING"
									((org-agenda-text-search-extra-files nil)))
						(todo "IN-PROGRESS"
									((org-agenda-text-search-extra-files nil)))
						(tags-todo "+PRIORITY=\"B\"|+PRIORITY=\"C\""
											 ((org-agenda-text-search-extra-files nil))))
					 ))
				))

(use-package evil-org
	:hook
	(org-mode . evil-org-mode)
	(org-agenda-mode . evil-org-mode)
	:config
	(require 'evil-org-agenda)
	(evil-org-agenda-set-keys))

(my/leader-key-def
	"o"   '(:ignore t :which-key "org mode")
	"oa"  '(my/org-agenda-dashboard :which-key "agenda")
	"on"  '(my/org-agenda-dashboard :which-key "dashboard")
	"os"  '(my/search-org-files :which-key "search")
	"oc"  '(org-capture t :which-key "capture")
	;; "on"  '(org-toggle-narrow-to-subtree :which-key "toggle narrow")
	"ot"  '(org-todo-list :which-key "todos"))

(use-package doct
	:defer t)

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

(defun my/org-capture-open-frame (frame-name)
	"Run org-capture in its own frame."
	(interactive)
	(require 'cl-lib)
	(setq capture/frame-name frame-name)
	(select-frame-by-name frame-name)
	(set-frame-parameter (selected-frame) 'alpha 100)
	(delete-other-windows)
	(cl-letf (((symbol-function 'switch-to-buffer-other-window) #'switch-to-buffer))
		(condition-case err
				(org-capture)
			;; "q" signals (error "Abort") in 'org-capture'
			;; delete the newly created frame in this scenario.
			(user-error (when (string= (cadr err) "Abort")
										(delete-frame))))))

(defun my/org-capture-delete-frame (&rest _)
	"Delete frame with its name frame-parameter set to 'capture'."
	(if (equal capture/frame-name (frame-parameter nil 'name))
			(delete-frame)))
(advice-add 'org-capture-finalize :after #'my/org-capture-delete-frame)

;; Automatically tangle .org config file .el file on save
(defun my/org-babel-tangle-config ()
	(when (string-equal (buffer-file-name)
											(expand-file-name my/config))
		;; Dynamic scoping to the rescue
		(let ((org-confirm-babel-evaluate nil))
			(org-babel-tangle))
		))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config
																							'run-at-end
																							'only-in-org-mode)))

(defun org-insert-clipboard-image (&optional file)
  (interactive "F")
  (shell-command (concat (format "xclip -selection clipboard -t image/png -o > %s.png " file) file))
  (insert (concat "[[" file ".png" "]]"))
  (org-display-inline-images))

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

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)

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

(my/leader-key-def
 "e"   '(:ignore t :which-key "eval")
 "eb"  '(eval-buffer :which-key "eval buffer"))

(my/leader-key-def
 :keymaps '(visual)
 "er" '(eval-region :which-key "eval region"))

(use-package markdown-mode
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

(use-package rustic
	:ensure
	:bind (:map rustic-mode-map
							("M-j" . lsp-ui-imenu)
							("M-?" . lsp-find-references)
							("C-c C-c l" . flycheck-list-errors)
							("C-c C-c a" . lsp-execute-code-action)
							("C-c C-c r" . lsp-rename)
							("C-c C-c q" . lsp-workspace-restart)
							("C-c C-c Q" . lsp-workspace-shutdown)
							("C-c C-c s" . lsp-rust-analyzer-status))
	:config
	;; uncomment for less flashiness
	;; (setq lsp-eldoc-hook nil)
	;; (setq lsp-enable-symbol-highlighting nil)
	;; (setq lsp-signature-auto-activate nil)

	;; comment to disable rustfmt on save
	(setq rustic-format-on-save t)
	(add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
	custom:
	(lsp-rust-analyzer-cargo-watch-command "clippy")
	(lsp-rust-analyzer-server-display-inlay-hints t))

(defun rk/rustic-mode-hook ()
	;; so that run C-c C-c C-r works without having to confirm, but don't try to
	;; save rust buffers that are not file visiting. Once
	;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
	;; no longer be necessary.
	(when buffer-file-name
		(setq-local buffer-save-without-query t)))

(use-package geiser-mit
	:defer t
	:custom
	(geiser-default-implementation 'mit)
	(geiser-mit-binary "scheme"))

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
	:bind-keymap
	("C-c p" . projectile-command-map)
	:config
	(setq projectile-switch-project-action #'projectile-dired
				projectile-project-search-path my/projects
				projectile-sort-order 'access-time)
	(projectile-mode)
	:custom
	(projectile-completion-system 'ivy)
	(projectile-enable-caching t))

	(with-eval-after-load 'projectile
		(projectile-discover-projects-in-directory my/projects-root)
		(projectile-discover-projects-in-directory my/org-directory))

	(use-package counsel-projectile
		:after (counsel projectile)
		:config (counsel-projectile-mode 1))

(use-package magit
	:commands (magit-status magit-get-current-branch)
	:custom
	(magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package plantuml-mode
	:defer t
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

(use-package flycheck
	:hook (lsp-mode . flycheck-mode))

(use-package smartparens
	:hook
	(org-mode . smartparens-mode)
	(prog-mode . smartparens-mode))

(use-package rainbow-delimiters
	:hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons-dired
 :defer t
 :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired
	:ensure nil
	:defer t
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
