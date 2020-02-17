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
         (w-gdb (split-window w-source (floor(* 0.9 (window-body-height)))
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
    (set-window-buffer w-source c-buffer)
    ))
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

(use-package evil
  :ensure t
  :demand t
  ;; :defer 1 ;; don't block emacs when starting, load evil immediately after startup
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-search-module 'evil-search)
  :config
  (loop for (mode . state) in '((inferior-emacs-lisp-mode . emacs)
                                (dashboard-mode . emacs)
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
  (evil-mode 1))

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
  (evil-goggles-mode))

;; like vim-surround
(use-package evil-surround
  :ensure t
  :demand t
  :config
  (global-evil-surround-mode 1))


;; * operator in vusual mode
(use-package evil-visualstar
  :ensure t
  :bind (:map evil-visual-state-map
         ("*" . evil-visualstar/begin-search-forward)
         ("#" . evil-visualstar/begin-search-backward)))


(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;;; `General':
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
  (general-def 'normal
    "[c" 'diff-hl-previous-hunk
    "]c" 'diff-hl-next-hunk
    "ge" 'dired-sidebar-toggle-sidebar
    "gt" 'lsp-ui-imenu
    "gcc" 'comment-line)
  (general-def 'normal 'override
    "C-p" 'evil-jump-forward)

  (general-def 'visual
    "gc" 'comment-dwim)

  (setq lsp-ui-doc-enable nil)
  (general-def
    :states 'normal
    :keymaps'prog-mode-map
    "K" 'lsp-ui-doc-glance)
  (general-def
    :states 'visual
    :keymaps'prog-mode-map
    "=" 'lsp-format-region)
  (my-leader-def
   :states 'normal
   :keymaps 'prog-mode-map
   "=" 'lsp-format-buffer)

  ;; ** Global Keybindings
  (my-leader-def
   :keymaps 'normal
   "SPC" 'counsel-M-x

   "t" 'youdao-dictionary-search-at-point

   "rg" 'counsel-projectile-rg
   "gi" 'magit-status

   "wh" 'evil-window-left
   "wl" 'evil-window-right
   "wj" 'evil-window-down
   "wk" 'evil-window-up

   "hc" 'evil-ex-nohighlight

   "b" 'ivy-switch-buffer
   "s" 'save-buffer
   "q" 'evil-quit
   "Q" 'evil-quit-all

   "d" 'counsel-dired
   "f" 'counsel-find-file
   "pf" 'counsel-projectile-find-file)

  (my-leader-def
   :keymaps 'dired-sidebar-mode-map
   "wh" 'evil-window-left
   "wl" 'evil-window-right
   "wj" 'evil-window-down
   "wk" 'evil-window-up)

  (my-leader-def
   :keymaps 'dashboard-mode-map
   "f" 'counsel-find-file
   "q" 'evil-quit)

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
