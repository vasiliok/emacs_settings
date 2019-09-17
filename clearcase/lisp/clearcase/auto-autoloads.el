;;; DO NOT MODIFY THIS FILE
(if (featurep 'clearcase-autoloads) (error "Already loaded"))

;;;### (autoloads nil "_pkg" "clearcase/_pkg.el")

(package-provide 'clearcase :version 1.12 :author-version "/main/laptop/165" :type 'regular)

;;;***

;;;### (autoloads (clearcase-unintegrate clearcase-integrate) "clearcase" "clearcase/clearcase.el")

(defalias 'clearcase-install 'clearcase-integrate)

(autoload 'clearcase-integrate "clearcase" "\
Enable ClearCase integration" t nil)

(autoload 'clearcase-unintegrate "clearcase" "\
Disable ClearCase integration" t nil)

;;;***

(provide 'clearcase-autoloads)
