;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File name: ` ~/.emacs '
;;; ---------------------
;;;
;;; If you need your own personal ~/.emacs
;;; please make a copy of this file
;;; an placein your changes and/or extension.
;;;
;;; Copyright (c) 1997-2002 SuSE Gmbh Nuernberg, Germany.
;;;
;;; Author: Werner Fink, <feedback@suse.de> 1997,98,99,2002
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Test of Emacs derivates
;;; -----------------------
(if (string-match "XEmacs\\|Lucid" emacs-version)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; XEmacs
  ;;; ------
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (progn
     (if (file-readable-p "~/.xemacs/init.el")
        (load "~/.xemacs/init.el" nil t))
  )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GNU-Emacs
  ;;; ---------
  ;;; load ~/.gnu-emacs or, if not exists /etc/skel/.gnu-emacs
  ;;; For a description and the settings see /etc/skel/.gnu-emacs
  ;;;   ... for your private ~/.gnu-emacs your are on your one.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (file-readable-p "~/.gnu-emacs")
      (load "~/.gnu-emacs" nil t)
    (if (file-readable-p "/etc/skel/.gnu-emacs")
	(load "/etc/skel/.gnu-emacs" nil t)))

  ;; Custom Settings
  ;; ===============
  ;; To avoid any trouble with the customization system of GNU emacs
  ;; we set the default file ~/.gnu-emacs-custom
  (setq custom-file "~/.gnu-emacs-custom")
  (load "~/.gnu-emacs-custom" t t)
;;;
)
;;;

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;;; Auto Indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;(setq inferior-lisp-program "/usr/bin/clisp") ; your Lisp system
;(add-to-list 'load-path "~/devel/slime/")  ; your SLIME directory
;(require 'slime)
;(slime-setup '(slime-fancy))
;(slime-setup '(slime-repl))

;(add-hook 'slime-mode-hook
;	  (lambda ()
;	    (unless (slime-connected-p)
;	      (save-excursion (slime)))))

;(setq slime-net-coding-system :utf-8-unix)
;(setq slime-lisp-implementations
;           '((clisp ("/usr/bin/clisp") :coding-system utf-8-unix)))

(load "/data/dev/haskell/haskell-mode-2.8.0/haskell-site-file")
(load "/data/dev/haskell/haskell-mode-2.8.0/browse-apropos-url")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(define-key haskell-mode-map (kbd "C-x C-s") 'haskell-mode-save-buffer)
(add-to-list 'align-rules-list
	     '(haskell-types
	       (regexp . "\\(\\s-+\\)\\(::\\|∷\\)\\s-+")
	       (modes quote (haskell-mode literate-haskell-mode))))
(add-to-list 'align-rules-list
	     '(haskell-assignment
	       (regexp . "\\(\\s-+\\)=\\s-+")
	       (modes quote (haskell-mode literate-haskell-mode))))
(add-to-list 'align-rules-list
	     '(haskell-arrows
	       (regexp . "\\(\\s-+\\)\\(->\\|→\\)\\s-+")
	       (modes quote (haskell-mode literate-haskell-mode))))
(add-to-list 'align-rules-list
	     '(haskell-left-arrows
	       (regexp . "\\(\\s-+\\)\\(<-\\|←\\)\\s-+")
	       (modes quote (haskell-mode literate-haskell-mode))))
(global-set-key (kbd "M-a") 'align-regexp)

(load-file "~/devel/cedet-1.1/common/cedet.el")
(global-ede-mode 1)
(semantic-load-enable-code-helpers)
(global-srecode-minor-mode 1)
(global-semantic-idle-local-symbol-highlight-mode 1)
(global-semantic-idle-completions-mode 1)
(global-semantic-show-unmatched-syntax-mode 1)
;(load "/usr/local/share/emacs/site-lisp/sml-mode/sml-mode-startup")
;(setenv "PATH" (concat "/usr/share/smlnj/bin:" (getenv "PATH")))
;(setq exec-path (cons "/usr/share/smlnj/bin" exec-path))


(semantic-load-enable-code-helpers)

(semantic-load-enable-gaudy-code-helpers)

(semantic-load-enable-excessive-code-helpers)

(require 'semantic-ia)

;(semantic-ia-complete-symbol-menu)

(define-key your-mode-map-here "." 'semantic-complete-self-insert)
; directory to put various el files into
; (add-to-list 'load-path "/usr/share/emacs/includes")

(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

; loads ruby mode when a .rb file is opened.
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

(add-hook 'ruby-mode-hook
          (lambda()
            (add-hook 'local-write-file-hooks
                      '(lambda()
                         (save-excursion
                           (untabify (point-min) (point-max))
                           (delete-trailing-whitespace)
                           )))
            (set (make-local-variable 'indent-tabs-mode) 'nil)
            (set (make-local-variable 'tab-width) 2)
            (imenu-add-to-menubar "IMENU")
            (define-key ruby-mode-map "\C-m" 'newline-and-indent)
            (require 'ruby-electric)
            (ruby-electric-mode t)
            ))

; directory to put various el files into
; (add-to-list 'load-path "/usr/share/emacs/includes")

(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)

; loads ruby mode when a .rb file is opened.
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

(add-hook 'ruby-mode-hook
          (lambda()
            (add-hook 'local-write-file-hooks
                      '(lambda()
                         (save-excursion
                           (untabify (point-min) (point-max))
                           (delete-trailing-whitespace)
                           )))
            (set (make-local-variable 'indent-tabs-mode) 'nil)
            (set (make-local-variable 'tab-width) 2)
            (imenu-add-to-menubar "IMENU")
            (define-key ruby-mode-map "\C-m" 'newline-and-indent)
            (require 'ruby-electric)
            (ruby-electric-mode t)
            ))

(line-number-mode 1)


;(add-to-list 'load-path "/home/rialmat/emacs-w3m")
;(setq load-path  (cons "/usr/local/share/emacs/site-lisp/w3m" load-path))

;(load-library "w3m")

;(load-file "/usr/share/emacs/site-lisp/w3m/w3m-load.el")
(require 'w3m-load)
;(require 'mime-w3m)
;(require 'w3m-e21)
;(provide 'w3m-e23)
;(require 'mime-w3m)

;; w3m
;load & init 
(autoload 'w3m "w3m" "interface for w3m on emacs" t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(autoload 'w3m-search "w3m-search" "Search words using emacs-w3m." t)

;settings
(setq w3m-use-cookies t)
(setq w3m-home-page "http://www.google.com")


(setq w3m-default-display-inline-image t) 
(setq w3m-default-toggle-inline-images t)
(setq w3m-use-favicon nil)
(setq w3m-command-arguments '("-cookie" "-F"))


(setq browse-url-browser-function 'w3m-browse-url)
;; optional keyboard short-cut
(global-set-key "\C-xm" 'browse-url-at-point)
(setq w3m-use-cookies t)


;(load "/home/rialmat/study/OpenCourses/University of Washington/Programming Languages/sml-mode-5.0/sml-mode-startup")
(setenv "PATH" (concat "/usr/share/smlnj/bin:" (getenv "PATH")))
(setq exec-path (cons "/usr/share/smlnj/bin" exec-path))
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/sml-mode")
(autoload 'sml-mode "sml-mode" "Major mode for editing SML." t)
(autoload 'run-sml "sml-proc" "Run an inferior SML process." t)
(add-to-list 'auto-mode-alist '("\\.\\(sml\\|sig\\)\\'" . sml-mode))
