;; Helper functions for resolving XDG paths.

(defun xdg/env-or-default-as-directory (name)
	"Returns the value from the environment variable NAME, or builds one following XDG, as an absolute directory path."
	(cl-flet ((getenv-home-concat (dir) (concat (file-name-as-directory (getenv "HOME")) dir)))
		(let* ((value (getenv name))
					 (directory (if value
													value
												(cond ((string-equal name "XDG_CACHE_HOME") (getenv-home-concat ".cache"))
															((string-equal name "XDG_CONFIG_HOME") (getenv-home-concat ".config"))
															(t (error (format "No value set for environment variable '%s'." name))))))
					 )
			(file-name-as-directory directory))))

(defvar xdg/cache (concat (xdg/env-or-default-as-directory "XDG_CACHE_HOME") "emacs"))
(defvar xdg/config (concat (xdg/env-or-default-as-directory "XDG_CONFIG_HOME") "emacs"))

(defun xdg/concat (directory name)
	"Return the absolute path of NAME under DIRECTORY."
	(let* ((directory (file-name-as-directory directory))
				 (path (convert-standard-filename (concat directory name))))
		(make-directory (file-name-directory path) t)
		path))

(defun xdg/concat-cache (name)
	"Return the absolute path of NAME under XDG cache directory."
	(xdg/concat xdg/cache name))
(defun xdg/concat-config (name)
	"Return the absolute path of NAME under XDG config directory."
	(xdg/concat xdg/config name))
