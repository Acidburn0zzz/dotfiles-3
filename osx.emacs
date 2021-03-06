(require 'package)
(require 'dabbrev)

;(setq debug-on-error t)

(global-set-key "\C-xt" 'shell)
(global-set-key "\C-x\C-e" 'compile)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\M-w" 'copy-region-as-kill)
(global-set-key "\M-j" 'fill-paragraph)
(global-set-key (kbd "C-S-w") 'kill-region)
(global-set-key "\C-x\C-w" 'kill-region)
(global-set-key "\M-u" 'undo)
(global-set-key "\C-]"          'delete-indentation)
(global-set-key "\M-q" 'query-replace)
(global-set-key "\C-xl" 'goto-line)
(global-set-key "\M-j" 'fill-paragraph)
(global-set-key "\M-\\" 'delete-horizontal-space)
(global-set-key "\C-z" 'scroll-down)
(global-set-key "\C-h" 'next-error)
(global-set-key "\C-c\C-u" 'uncomment-region)
(global-set-key "\C-c\C-c" 'comment-region)
(global-set-key "\C-x\C-u" 'erase-buffer)
(global-set-key "\C-x\C-l" 'goto-line)
(global-set-key "\C-xO" 'other-frame)

(global-set-key (kbd "C-c c") 'pbcopy)
(global-set-key (kbd "C-c v") 'pbpaste)
(global-set-key (kbd "C-c x") 'pbcut)

(global-set-key "\M-c" nil)

(setq default-major-mode 'lisp-interaction-mode)
(setq compile-command "make -k")
(setq compilation-read-command nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (go-guru go-mode go-autocomplete exec-path-from-shell)))
 '(send-mail-function nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :height 160 :foundry "PT Mono"))))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background dark)) (:foreground "yellow")))))

(put 'erase-buffer 'disabled nil)

(tool-bar-mode -1)

(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "https://marmalade-repo.org/packages/") t)

(setq compilation-always-kill t)
(setq compilation-scroll-output t)

(cond 
 ((eq window-system 'ns) ; macosx
  ;; Invoke login shells, so that .profile or .bash_profile is read
  (setq shell-command-switch "-lc")))

(setq explicit-bash-args '("--login" "-i"))
(put 'downcase-region 'disabled t)
(put 'upcase-region 'disabled t)

(defun pbcopy ()
  (interactive)
  (call-process-region (point) (mark) "pbcopy")
  (setq deactivate-mark t))

(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

(defun pbcut ()
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))

(package-initialize)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "GOPATH")
(exec-path-from-shell-copy-env "GOROOT")

(defun my-go-mode-hook()
  (auto-complete-mode 1)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark))

(require 'go-guru)
(add-hook 'go-mode-hook 'my-go-mode-hook)
;(add-hook 'go-mode-hook 'go-guru-hl-identifier-mode)

(with-eval-after-load 'go-mode
   (require 'go-autocomplete))

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

(setq initial-buffer-choice t)
(setq inhibit-startup-screen t)

(setq default-directory (concat (getenv "GOPATH") "/src/"))

(defun my-startup-hook()
  ;; (let ((wd (concat (getenv "GOPATH") "/src/"))
  ;; 	(buf (get-buffer-create "*Tmp*")))
  ;;   (save-excursion
  ;;     (set-buffer buf)
  ;;     (setq default-directory wd)
  ;;     (cd wd))
  (shell))
  ;; )

(add-hook 'emacs-startup-hook 'my-startup-hook)

(defun my-c-setup ()
   (c-set-offset 'innamespace [0]))
(add-hook 'c++-mode-hook 'my-c-setup)

(setq frame-title-format (list "%b - " (upcase (let ((path (getenv "GOPATH")))
						 (save-match-data
						   (string-match "/\\([^/]+\\)/go" path)
						   (match-string 1 path))))))

(add-to-list 'auto-mode-alist '("\\.yaml\\'" . conf-mode))
