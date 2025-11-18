(require 'nox)

(dolist (hook (list
                'js-mode-hook
                'rust-mode-hook
                'python-mode-hook
                'ruby-mode-hook
                'java-mode-hook
                'sh-mode-hook
                'php-mode-hook
                'c-mode-common-hook
                'c-mode-hook
                'c++-mode-hook
                'haskell-mode-hook
                ))
  (add-hook hook '(lambda () (nox-ensure))))
(add-to-list 'nox-server-programs '((c++-mode c-mode) "clangd"))

(setq grip-github-user "jkunlin")
(setq grip-github-password "3ec892f4aea0f9aec2aa066465fb39644af8fc49")
(setq grip-preview-use-webkit nil)

;; (advice-remove #'show-paren-function #'show-paren-off-screen)

(setq scroll-margin 2)

;; ----------------------`evil'----------------------------------
(use-package evil
  :ensure t
  :demand t
  ;; :defer 1 ;; don't block emacs when starting, load evil immediately after startup
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-search-module 'evil-search)
  (setq evil-want-Y-yank-to-eol t)
  :config
  (loop for (mode . state) in '((inferior-emacs-lisp-mode . emacs)
                                 (nrepl-mode . insert)
                                 (pylookup-mode . emacs)
                                 (comint-mode . normal)
                                 (shell-mode . insert)
                                 (git-commit-mode . insert)
                                 (git-rebase-mode . emacs)
                                 (term-mode . emacs)
                                 (help-mode . emacs)
                                 (helm-grep-mode . emacs)
                                 (grep-mode . emacs)
                                 (bc-menu-mode . emacs)
                                 (magit-branch-manager-mode . emacs)
                                 (rdictcc-buffer-mode . emacs)
                                 (dired-mode . emacs)
                                 (wdired-mode . normal))
    do (evil-set-initial-state mode state))
  (evil-mode 1)
  (with-eval-after-load 'evil
    ;; (defalias 'forward-evil-word 'forward-evil-symbol)
    ;; make evil-search-word look for symbol rather than word boundaries
    (setq-default evil-symbol-word-search t)))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-escape
  :init
  (evil-escape-mode)
  :after evil
  :ensure t
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.15))

;; visual hints while editing
(use-package evil-goggles
  :ensure t
  :demand t
  :config
  (evil-goggles-mode)
  :init
  (setq evil-goggles-enable-delete nil)
  (setq evil-goggles-enable-change nil)
  (setq evil-goggles-enable-indent nil)
  ;; (setq evil-goggles-enable-yank nil)
  (setq evil-goggles-enable-join nil)
  (setq evil-goggles-enable-fill-and-move nil)
  (setq evil-goggles-enable-paste nil)
  (setq evil-goggles-enable-shift nil)
  (setq evil-goggles-enable-surround nil)
  (setq evil-goggles-enable-commentary nil)
  (setq evil-goggles-enable-nerd-commenter nil)
  (setq evil-goggles-enable-replace-with-register nil)
  (setq evil-goggles-enable-set-marker nil)
  (setq evil-goggles-enable-undo nil)
  (setq evil-goggles-enable-redo nil)
  (setq evil-goggles-enable-record-macro nil))

;; like vim-surround
(use-package evil-surround
  :ensure t
  :demand t
  :config
  (global-evil-surround-mode 1))


;; * operator in visual mode
(use-package evil-visualstar
  :ensure t
  :bind (:map evil-visual-state-map
          ("*" . evil-visualstar/begin-search-forward)
          ("#" . evil-visualstar/begin-search-backward)))

(use-package evil-easymotion
  :ensure t)

;; vdiff
(use-package vdiff
  :config
  (evil-define-key 'normal vdiff-mode-map "," vdiff-mode-prefix-map))

(use-package vdiff-magit
  :config
  (define-key magit-mode-map "e" 'vdiff-magit-dwim)
  (define-key magit-mode-map "E" 'vdiff-magit)
  (transient-suffix-put 'magit-dispatch "e" :description "vdiff (dwim)")
  (transient-suffix-put 'magit-dispatch "e" :command 'vdiff-magit-dwim)
  (transient-suffix-put 'magit-dispatch "E" :description "vdiff")
  (transient-suffix-put 'magit-dispatch "E" :command 'vdiff-magit))

(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
    (lambda ()
      (unless (file-remote-p default-directory)
        (auto-revert-mode))))
  :config
  (setq dired-sidebar-theme 'nerd)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;; ----------------------`eglot'----------------------------------
;; child frame help
(use-package eldoc-box
  :commands (eldoc-box-eglot-help-at-point))

;; clangd
;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))

;; ccls has a fuzzy matching algorithm to order candidates according to your query. You may want to disable client-side sorting
(setq company-transformers nil)

;; eglot uses builtin project.el to detect the project root. If you want to use projectile
(defun projectile-project-find-function (dir)
  (let* ((root (projectile-project-root dir)))
    (and root (cons 'transient root))))
(with-eval-after-load 'project
  (add-to-list 'project-find-functions 'projectile-project-find-function))

;; Use help window to display hierarchies
(defun eglot-ccls-inheritance-hierarchy (&optional derived)
  "Show inheritance hierarchy for the thing at point.
If DERIVED is non-nil (interactively, with prefix argument), show
the children of class at point."
  (interactive "P")
  (if-let* ((res (jsonrpc-request
                   (eglot--current-server-or-lose)
                   :$ccls/inheritance
                   (append (eglot--TextDocumentPositionParams)
                     `(:derived ,(if derived t :json-false))
                     '(:levels 100) '(:hierarchy t))))
             (tree (list (cons 0 res))))
    (with-help-window "*ccls inheritance*"
      (with-current-buffer standard-output
        (while tree
          (pcase-let ((`(,depth . ,node) (pop tree)))
            (cl-destructuring-bind (&key uri range) (plist-get node :location)
              (insert (make-string depth ?\ ) (plist-get node :name) "\n")
              (make-text-button (+ (point-at-bol 0) depth) (point-at-eol 0)
                'action (lambda (_arg)
                          (interactive)
                          (find-file (eglot--uri-to-path uri))
                          (goto-char (car (eglot--range-region range)))))
              (cl-loop for child across (plist-get node :children)
                do (push (cons (1+ depth) child) tree)))))))
    (eglot--error "Hierarchy unavailable")))



(use-package ggtags)


;; ----------------------`General'----------------------------------
;; This is a whole framework for binding keys in a really nice and consistent
;; manner.
(use-package general
  :demand t
  :config
  ;; * Prefix Keybindings
  (general-create-definer my-leader-def
    :prefix "SPC")
  (general-create-definer my-local-leader-def
    :prefix "SPC m")

  ;; * Global Keybindings
  (general-def
    "M-o" 'ace-window)
  (general-def 'normal
    "[c" 'diff-hl-previous-hunk
    "]c" 'diff-hl-next-hunk
    "[d" 'previous-error
    "]d" 'next-error
    "ge" 'dired-sidebar-toggle-sidebar
    "gt" 'ggtags-find-tag-regexp
    "gcc" 'comment-line)
  (general-def 'normal 'override
    "C-p" 'evil-jump-forward)

  (general-def 'visual
    "gc" 'comment-dwim)

  (evil-define-key 'normal 'global
    ;; select the previously pasted text
    "gp" "`[v`]"
    ;; run the macro in the q register
    "Q" "@q")

  (with-eval-after-load 'cc-mode
    (setq c-mode-common-hook nil)
    (ggtags-mode 1)
    (add-hook 'c-mode-common-hook (lambda () (setq c-basic-offset 2))))
  (which-func-mode 1)
  (eval-after-load "which-func"
    '(setq which-func-modes '(java-mode c-mode c++-mode org-mode)))
  (setq lsp-ui-doc-enable nil)

  (general-def
    :states 'normal
    :keymaps'prog-mode-map
    ;; "K" 'lsp-ui-doc-glance
    ;; "K" 'eldoc-box-eglot-help-at-point
    "K" 'nox-show-doc
    "gd" 'xref-find-definitions
    "gr" 'xref-find-references)
  (general-def
    :states 'visual
    :keymaps'prog-mode-map
    "=" 'nox-format)
  (my-leader-def
    :states 'normal
    :keymaps 'prog-mode-map
    "=" 'nox-format-buffer
    "a" 'ff-find-other-file)

  ;; ** Global Keybindings
  (my-leader-def
    :keymaps 'normal
    "SPC" 'counsel-M-x
    "2" 'make-frame

    "t" 'youdao-dictionary-search-at-point

    "rg" 'counsel-projectile-rg
    "gi" 'magit-status

    "hc" 'evil-ex-nohighlight

    "b" 'ivy-switch-buffer
    "s" 'save-buffer
    "q" 'evil-quit
    "Q" 'evil-quit-all

    "d" 'counsel-dired
    "f" 'counsel-fzf
    "rf" 'counsel-recentf
    "pf" 'counsel-projectile-find-file
    "mh" 'evilem-motion-backward-WORD-begin
    "mj" 'evilem-motion-next-line
    "mk" 'evilem-motion-previous-line
    "ml" 'evilem-motion-forward-WORD-begin)
  ;; "m" 'ace-pinyin-dwim)
  (my-leader-def
    :keymaps 'visual
    "mh" 'evilem-motion-backward-WORD-begin
    "mj" 'evilem-motion-next-line
    "mk" 'evilem-motion-previous-line
    "ml" 'evilem-motion-forward-WORD-begin)

  ;; ;; to prevent your leader keybindings from ever being overridden (e.g. an evil
  ;; ;; package may bind "SPC"), use :keymaps 'override
  ;; (my-leader-def
  ;;   :states 'normal
  ;;   :keymaps 'override
  ;;   "f" 'find-file)

  ;; ;; ** Mode Keybindings
  ;; (my-local-leader-def
  ;;   :states 'normal
  ;;   :keymaps 'org-mode-map
  ;;   "y" 'org-store-link
  ;;   "p" 'org-insert-link
  ;;   ;; ...
  ;;   )
  )

(setq yas-snippet-dirs (append yas-snippet-dirs
                         '("~/.emacs.d/snippets")))


;; ----------------------`gdb'----------------------------------
(setq gdb-mi-decode-strings 1) ;; no-ASCII directory name
(setq gdb-many-windows nil)

(defun set-gdb-layout(&optional c-buffer)
  (if (not c-buffer)
    (setq c-buffer (window-buffer (selected-window)))) ;; save current buffer

  ;; from http://stackoverflow.com/q/39762833/846686
  (set-window-dedicated-p (selected-window) nil) ;; unset dedicate state if needed
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows) ;; clean all

  (let* (
          (w-source (selected-window)) ;; left top
          (w-io (split-window w-source nil 'right)) ;; right bottom
          (w-locals (split-window w-io (floor(* 0.3 (window-body-height))) 'above)) ;; right middle bottom
          (w-stack (split-window w-locals nil 'above)) ;; right middle top
          (w-breakpoints (split-window w-stack nil 'above)) ;; right top
          (w-gdb (split-window w-source (floor(* 0.8 (window-body-height)))
                   'below)) ;; left bottom
          )
    (set-window-buffer w-io (gdb-get-buffer-create 'gdb-inferior-io))
    (set-window-dedicated-p w-io t)
    (set-window-buffer w-breakpoints (gdb-get-buffer-create 'gdb-breakpoints-buffer))
    (set-window-dedicated-p w-breakpoints t)
    (set-window-buffer w-locals (gdb-get-buffer-create 'gdb-locals-buffer))
    (set-window-dedicated-p w-locals t)
    (set-window-buffer w-stack (gdb-get-buffer-create 'gdb-stack-buffer))
    (set-window-dedicated-p w-stack t)

    (set-window-buffer w-gdb gud-comint-buffer)

    (select-window w-source)
    (set-window-buffer w-source c-buffer)))
(defadvice gdb (around args activate)
  "Change the way to gdb works."
  (setq global-config-editing (current-window-configuration)) ;; to restore: (set-window-configuration c-editing)
  (let (
         (c-buffer (window-buffer (selected-window))) ;; save current buffer
         )
    ad-do-it
    (set-gdb-layout c-buffer))
  )
(defadvice gdb-reset (around args activate)
  "Change the way to gdb exit."
  ad-do-it
  (set-window-configuration global-config-editing))



;; (use-package evil
;;              :ensure t
;;              :defer .1 ;; don't block emacs when starting, load evil immediately after startup
;;              :init
;;              (setq evil-want-integration nil) ;; required by evil-collection
;;              ; (setq evil-want-keybinding nil) ;; required by evil-collection
;;              (setq evil-search-module 'evil-search)
;;              (setq evil-ex-complete-emacs-commands nil)
;;              (setq evil-vsplit-window-right t) ;; like vim's 'splitright'
;;              (setq evil-split-window-below t) ;; like vim's 'splitbelow'
;;              (setq evil-shift-round nil)
;;              (setq evil-want-C-u-scroll t)
;;              :config
;;              (evil-mode)
;;              )
;;
;; ;; vim-like keybindings everywhere in emacs
;; (use-package evil-collection
;;              :after evil
;;              :ensure t
;;              :config
;;              (evil-collection-init))
;;
;; gl and gL operators, like vim-lion   ;
;; (use-package evil-lion
;;              :ensure t
;;              :bind (:map evil-normal-state-map
;;                          ("g l " . evil-lion-left)
;;                          ("g L " . evil-lion-right)
;;                          :map evil-visual-state-map
;;                          ("g l " . evil-lion-left)
;;                          ("g L " . evil-lion-right)))
;;
;; ;; gc operator, like vim-commentary
;; (use-package evil-commentary
;;              :ensure t
;;              :bind (:map evil-normal-state-map
;;                          ("gc" . evil-commentary)))
;;
;; ;; gx operator, like vim-exchange
;; ;; NOTE using cx like vim-exchange is possible but not as straightforward
;; (use-package evil-exchange
;;              :ensure t
;;              :bind (:map evil-normal-state-map
;;                          ("gx" . evil-exchange)
;;                          ("gX" . evil-exchange-cancel)))
;;
;; ;; gr operator, like vim's ReplaceWithRegister
;; (use-package evil-replace-with-register
;;              :ensure t
;;              :bind (:map evil-normal-state-map
;;                          ("gr" . evil-replace-with-register)
;;                          :map evil-visual-state-map
;;                          ("gr" . evil-replace-with-register)))
;;
;;
;; ;; ex commands, which a vim user is likely to be familiar with
;; (use-package evil-expat
;;              :ensure t
;;              :defer t)
;;
;;
;;
;; (use-package neotree
;;   :ensure t
;;   :defer t
;;   :config
;;   (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
