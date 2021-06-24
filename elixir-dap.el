;;; elixir-dap.el -*- lexical-binding: t; -*-

(require 'dap-mode)

(defun dap-elixir--populate-start-debug-file-args (conf)
  "Populate CONF with the required arguments."
  (-> conf
      (dap--put-if-absent :dap-server-path '("debugger.sh"))
      (dap--put-if-absent :type "mix_task")
      (dap--put-if-absent :name "mix test")
      (dap--put-if-absent :request "launch")
      (dap--put-if-absent :task "test")
      (dap--put-if-absent :taskArgs (list "--trace"))
      (dap--put-if-absent :projectDir (lsp-find-session-folder (lsp-session) (buffer-file-name)))
      (dap--put-if-absent :cwd (lsp-find-session-folder (lsp-session) (buffer-file-name)))
      (dap--put-if-absent :requireFiles (list
                                         "test/**/test_helper.exs"
                                         "test/**/*_test.exs"))))

(defun dap-elixir--populate-start-file-args (conf)
  "Start a dev debug mode on iex"
  (-> conf
      (dap--put-if-absent :dap-server-path '("debugger.sh"))
      (dap--put-if-absent :type "mix_run")
      (dap--put-if-absent :name "ism")
      (dap--put-if-absent :request "launch")
      (dap--put-if-absent :task "run")
      (dap--put-if-absent :taskArgs (list "--no-halt"))
      (dap--put-if-absent :excludeModules (list "Bcrypt.Base"))
      (dap--put-if-absent :projectDir (lsp-find-session-folder (lsp-session) (buffer-file-name)))
      (dap--put-if-absent :cwd (lsp-find-session-folder (lsp-session) (buffer-file-name)))))

(dap-register-debug-provider "ElixirDebug" 'dap-elixir--populate-start-debug-file-args)
(dap-register-debug-provider "Elixir" 'dap-elixir--populate-start-file-args)
(dap-register-debug-template "Elixir Test"
                             (list :type "ElixirDebug"
                                   :cwd nil
                                   :request "launch"
                                   :program nil
                                   :name "Elixir::Run"))
(dap-register-debug-template "Elixir Run"
                             (list :type "Elixir"
                                   :cwd nil
                                   :request "launch"
                                   :program nil
                                   :name "Elixir::Run"))

(provide 'dap-elixir-custom)
