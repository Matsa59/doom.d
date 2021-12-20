;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-


;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Alexandre Lepretre"
      user-mail-address "alexandre.lprtr@gmail.com")
(tool-bar-mode -1)
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
(setq doom-font (font-spec :family "Hasklig" :size 16 :weight 'normal))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-horizon)

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

(exec-path-from-shell-initialize)

;; projectile configuration
(setq projectile-project-search-path '("~/Code/drakkar"))

;; reducing lags
;; (setq auto-window-vscroll nil)

;; (setq doom-modeline-enable-word-count nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(use-package! web-mode
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.html\\.eex\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\.leex\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode)))

(eval-after-load 'web-mode
  '(add-hook 'web-mode-hook
             (lambda ()
               (if (string-match-p "eex" (file-name-extension buffer-file-name))
                   (setq web-mode-code-indent-offset 4)
                 (setq web-mode-code-indent-offset 2)))))

(defun format-eex ()
  "Format eex buffer using eexbeautifier."
  (when (and (eq major-mode 'web-mode) (string-match-p "eex" (file-name-extension buffer-file-name)))
    (shell-command-to-string (format "eexbeautifier %s" buffer-file-name))))

(add-hook 'after-save-hook #'format-eex)

;; For magit-forge, uncomment the next line
;; (setq auth-sources '("~/.authinfo.gpg"))

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



(when (or window-system (daemonp))
  (setq default-frame-alist '(
                              (width . 120)
                              (height . 40)
                              (top . 0)
                              (left . 0)
 ))
)

;;
;; org-mode
;;
(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "DONE(d)"))))

(use-package! org
  :bind
  (:map evil-normal-state-map
   ("t" . org-todo)))

;;
;; Elixir config
;;
(setq exec-path (append exec-path '("~/Code/elixir/elixir-ls/release")))

(add-hook 'elixir-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'elixir-format nil t)))

;;
;; Gerkhin major mode
;;
(use-package! feature-mode
  :init
  (setq feature-default-language "en")
  (add-to-list 'auto-mode-alist '("\\.feature\\'" . feature-mode)))

;; change color of string more than 120 characters
(require 'whitespace)
(setq whitespace-line-column 120) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)

(global-whitespace-mode +1)

(setq ispell-dictionary "en")

;;
;; Cucstom loads
;;

(load! "bindings")
(load! "joseph-single-dired")

;;
;; Dap mode
;;
(load! "elixir-dap")
(require 'dap-elixir-custom)

(dap-ui-mode)
(dap-mode)

(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq lsp-file-watch-threshold 5000)
