
;; Emacs Integration for the eclipse exporter.

(defvar eclipse-exporter-program
  nil
  "The path to eclipse exporter program.")

(setq eclipse-exporter-program (expand-file-name "~/Workspace/eclipse-fake/eclipse-fake.sh"))

;;;###autoload
(defun eclipse-export-project (path)
  (interactive "fProject-dir: ")
  (setq path (expand-file-name path))
  (let* ((program-path eclipse-exporter-program)
         (path (expand-file-name path))
         (output-buffer (get-buffer-create "*Async Shell Command*"))
         (process-environment (cons (concat "NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=" path)
                                    process-environment))
         (process (start-process "eclipse-exporter"
                                 output-buffer
                                 program-path)))

    (message program-path)
    (let ((show-win (split-window-vertically)))
      (set-window-buffer show-win output-buffer))))

(provide 'eclipse-exporter)
