;;; Directory Local Variables
;;; For more information see Emacs manual: Per-Directory Local Variables

((verilog-mode . ((yura/verilog-buffer-style . uvm)
                  (eval add-hook
                        'before-save-hook
                        #'yura/verilog-add-or-overwrite-identifiers nil :local))))
