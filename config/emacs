(setq user-full-name "Dmitriy Khomitskiy"
      user-mail-address "dmitriy@khomitskiy.com")

;; These functions are useful. Activate them.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; fix alt key
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil))

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep all backup and auto-save files in one directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; UTF-8 please
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top
(setq-default indent-tabs-mode nil)

;; Turn off the blinking cursor
(blink-cursor-mode -1)

(setq-default indent-tabs-mode nil)
(setq-default indicate-empty-lines t)

;; Don't count two spaces after a period as the end of a sentence.
;; Just one space is needed.
(setq sentence-end-double-space nil)

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

(show-paren-mode t)

(column-number-mode t)

(global-visual-line-mode)
;; (diminish 'visual-line-mode)

;; general modes
(ido-mode 1)
(setq ido-enable-flex-matching t)

;; remove splash screen
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

(setq uniquify-buffer-name-style 'forward)

;; -i gets alias definitions from .bash_profile
(setq shell-command-switch "-ic")

;; Visible bell:
;(setq visible-bell t)
;; Turn off bell completely:
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq package-enable-at-startup nil)
(require 'package)
;; install melpa package manager
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)



;; no suspends
(global-unset-key (kbd "C-z"))


;; THEMES
(defun disable-active-themes ()
  "Disables any currently active themes listed in `custom-enabled-themes'."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))


;; Use IDO for searching
(use-package ido
  :init
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode t)
  (use-package ido-vertical-mode
    :ensure t
    :defer t
    :init 
    ; Use more space in the mini buffer
    (ido-vertical-mode 1)
    ;remember buffers opened in previous sessions
    (setq ido-use-virtual-buffers t)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)))


;; which key is helpful to describe which key to use
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; Shell pop on C-c t
(use-package shell-pop
  :ensure t
  :bind ("C-c t" . shell-pop)
  :init
  (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell))))))

;; Small helper to scrape text from shell output
(defun get-shell-output (cmd)
  (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string cmd)))

;; quick run allows a quick execution of code
;; run with shift-q
(use-package quickrun
  :defer 10
  :ensure t
  :bind ("s-q" . quickrun))

;; node js
(use-package js2-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-jsx-mode))
  :config
  (setq js2-basic-offset 2) ; Use two spaces for indentation
  (setq js2-strict-missing-semi-warning nil); Don't enforce semicolons
  )

;; Better imenu
(use-package js2-refactor
  :ensure t
  :init
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  )

;; flycheck
(use-package eslint-fix
  :ensure t
  :init
  (eval-after-load 'js2-mode
    '(add-hook 'js2-mode-hook 
               (lambda () 
                 (add-hook 'after-save-hook 
                           (lambda ()
                             (eslint-fix)
                             ;(revert-buffer nil t)
                             ))
                 (flycheck-mode))))
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (jedi python-mode minimap markdown-mode tide web-mode eslint-fix which-key use-package shell-pop quickrun js2-refactor ido-vertical-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; WEBMODE
(use-package web-mode
  :ensure t
  :init
  (require 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                (setup-tide-mode))))
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  )


;; type script
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))
(use-package tide
  :ensure t
  :config
  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)
  ;; formats the buffer before saving
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  ;; format options
  (setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))
  )


;; MARKDOWN
(use-package markdown-mode
  :ensure t
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . orgtbl-mode)
         ("\\.md\\'"       . orgtbl-mode))
)

;; Convert Org-mode table to Github Flavored Markdown
;; https://gist.github.com/yryozo/5807243
;; http://stackoverflow.com/questions/14275122/editing-markdown-pipe-tables-in-emacs#20912535
;;  
;; <!-- 
;; #+ORGTBL: SEND $1 orgtbl-to-gfm
;; | $0 | 
;; -->

(defun orgtbl-to-gfm (table params)
  "Convert the Orgtbl mode TABLE to GitHub Flavored Markdown."
  (let* ((alignment (mapconcat (lambda (x) (if x "|--:" "|---"))
                               org-table-last-alignment ""))
         (params2
          (list
           :splice t
	   :hline (concat alignment "|")
           :lstart "| " :lend " |" :sep " | ")))
    (orgtbl-to-generic table (org-combine-plists params2 params))))


;; Minimap
(use-package minimap
  :ensure t
  :init
  ;(minimap-mode)
  )

;; ********** Python *************
(use-package python-mode
  :defer t
  :ensure t
  :init
  ;; Configure flymake for Python
  (when (load "flymake" t)
    (defun flymake-pylint-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "epylint" (list local-file))))
    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.py\\'" flymake-pylint-init)))
  ;; Set as a minor mode for Python
  (add-hook 'python-mode-hook '(lambda () (flymake-mode)))
  ;; To avoid having to mouse hover for the error message, 
  ;; these functions make flymake error messages appear in the minibuffer
  (defun show-fly-err-at-point ()
    "If the cursor is sitting on a flymake error, display the message in the minibuffer"
    (require 'cl)
    (interactive)
    (let ((line-no (line-number-at-pos)))
      (dolist (elem flymake-err-info)
        (if (eq (car elem) line-no)
            (let ((err (car (second elem))))
              (message "%s" (flymake-ler-text err))))))))

(add-hook 'post-command-hook 'show-fly-err-at-point)
(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t))
