;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-


;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Alexandre Lepretre"
      user-mail-address "alexandre.lepretre@wapitea.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Source Code Pro" :size 14 :weight 'semi-light))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; projectile configuration
(setq projectile-project-search-path '("~/Documents/Programmation/elixir/wapixir/" "~/Documents/Programmation/elixir"))


(use-package! alchemist
  :hook (elixir-mode . alchemist-mode)
  :config
  (set-lookup-handlers! 'elixir-mode
    :definition #'alchemist-goto-definition-at-point
    :documentation #'alchemist-help-search-at-point)
  (set-eval-handler! 'elixir-mode #'alchemist-eval-region)
  (set-repl-handler! 'elixir-mode #'alchemist-iex-project-run)
  (setq alchemist-mix-env "dev")
  (setq alchemist-hooks-compile-on-save t)
  (map! :map elixir-mode-map :nv "m" alchemist-mode-keymap)
  (setq lsp-enable-file-watchers nil))

;; (use-package! rust-mode
;;   :config
;;   (setq rust-format-on-save t))

;; (use-package! rustic
;;   :config
;;   (setq rustic-lsp-server 'rls)
;;   (setq rustic-format-on-save t))

;; (use-package! flycheck
;;   :ensure t
;;   :init (global-flycheck-mode))

;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package! lsp-mode
  :commands lsp
  :ensure t
  :diminish lsp-mode
  :config
  (setq lsp-enable-file-watchers nil)
  :hook
  (elixir-mode . lsp)
  :init
  (add-to-list 'exec-path "~/elixir-ls/release/language_server.sh"))

(defvar lsp-elixir--config-options (make-hash-table))

(add-hook 'lsp-after-initialize-hook
          (lambda ()
            (lsp--set-configuration `(:elixirLS, lsp-elixir--config-options))))


(after! lsp-ui
  (setq lsp-ui-doc-max-height 13
        lsp-ui-doc-max-width 80
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-position 'bottom
        lsp-ui-doc-use-webkit nil
        lsp-ui-flycheck-enable t
        lsp-ui-imenu-kind-position 'left
        lsp-ui-sideline-code-actions-prefix "💡"
        ;; fix for completing candidates not showing after “Enum.”:
        company-lsp-match-candidate-predicate #'company-lsp-match-candidate-prefix
        ))

;; web mode + beautify

;(use-package! web-beautify
;  :hook
;  (web-mode . web-beautify))

(use-package! web-mode
  :init
  (setq web-mode-markup-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.html\\.eex\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\.leex\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  ;(setq web-mode-engines-alist
  ;      '(("erb" . "\\.html\\.eex\\'")
  ;       ("erb" . "\\.html.leex\\'"))))

  )

(eval-after-load 'web-mode
  '(add-hook 'web-mode-hook
             (lambda ()
               (add-hook 'before-save-hook 'web-mode-buffer-indent t t))))

(setq auth-sources '("~/.authinfo"))
;; (with-eval-after-load 'forge
;;  (setq forge-topic-list-columns
;;      '(("#" 5 t (:right-align t) number nil)
;;        nil
;;        ("Title" 60 t nil title  nil)
;;        ("State" 6 t nil state nil)
        ;; ("Marks" 8 t nil marks nil)
        ;; ("Labels" 8 t nil labels nil)
        ;; ("Assignees" 10 t nil assignees nil)
;;        ("Updated" 10 t nill updated nil)))
;; )

(with-eval-after-load 'forge
  (setq forge-topic-list-columns
    ;; '(("#" 5 forge-topic-list-sort-by-number (:right-align t) number nil)
      '(("#" 15 
        (lambda (a b) 
          (string> (read (aref (cadr a) 0))
            (read (aref (cadr b) 0))))
        (:right-align t) state nil)
        ("id" 6 t nil number nil)
        ("Title" 100 t nil title)
        ;; ("Marks" 8 t nil marks nil)
        ;; ("Labels" 8 t nil labels nil)
        ;; ("Assignees" 10 t nil assignees nil)
        ("Updated" 10 t nill updated nil))))

(add-hook 'elixir-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'elixir-format nil t)))

;; OPTIONAL: If you prefer to grab symbols rather than words, use
;; `evil-multiedit-match-symbol-and-next` (or prev).
(use-package! evil-multiedit
  :bind
  (:map evil-visual-state-map
   ("R" . evil-multiedit-match-all)
   ("s-d" . evil-multiedit-match-and-next)
   ("s-D" . evil-multiedit-match-and-prev))
  (:map evil-normal-state-map
   ("s-d" . evil-multiedit-match-and-next)
   ("s-D" . evil-multiedit-match-and-prev))
  (:map evil-insert-state-map
   ("s-d" . evil-multiedit-toggle-marker-here))
  (:map evil-multiedit-state-map
   ("RET" . evil-multiedit-toggle-or-restrict-region)
   ("C-n" . evil-multiedit-next)
   ("C-p" . evil-multiedit-prev)
   ("s-c" . evil-multiedit-restore)) ;; not useful as expected
  (:map evil-motion-state-map
   ("RET" . evil-multiedit-toggle-or-restrict-region))
  (:map evil-multiedit-insert-state-map
   ("C-n" . evil-multiedit-next)
   ("C-p" . evil-multiedit-prev)))


(use-package! multi-term
  :config
  (setq multi-term-program "/bin/zsh")
  :bind
  (:map evil-normal-state-map
   ("s-!" . multi-term)))

(load! "bindings")

(load! "joseph-single-dired")

(when (or window-system (daemonp))
  (setq default-frame-alist '(
                              (width . 210)
                              (height . 50)
                              (top . 250)
                              (left . 300)
 ))
)
