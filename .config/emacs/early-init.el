;;; early-init.el --- Early Init File -*- lexical-binding: t -*-

;; Allow loading from the package cache
(setq package-quickstart t)

;; No startup screen
(setq inhibit-startup-screen t)

(scroll-bar-mode -1)	; Disable visible scrollbar
(tool-bar-mode -1)		; Disable the toolbar
(tooltip-mode -1)		; Disable tooptips
(set-fringe-mode 10)	; Give some breathing room
(menu-bar-mode -1)		; Disable the menu bar

;;; early-init.el ends here
