;;; ~/.doom.d/binding.el -*- lexical-binding: t; -*-

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))

;;
;; alchemist - elixir
;;

(map! :after elixir-mode
      :leader
      :map elixir-mode-map
      ;; (:prefix "a" . "Alchemist")
      :desc "Start or go to IEx session"
      "a i" #'alchemist-iex-project-run)
