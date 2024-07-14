;;; org-plantuml-mindmap.el --- create mindmap quickly. -*- lexical-binding: t -*-

(defgroup org-plantuml-mindmap nil
  "Quick creation of mindmaps"
  :group 'convenience)

(defcustom org-plantuml-mindmap-result-type "string"
  "Result type of org-plantuml-mindmap"
  :type 'string
  :group 'org-plantuml-mindmap)

(defcustom org-plantuml-mindmap-folder ""
  "If non-nil, create a folder for the PlantUML mind map files."
  :type 'string
  :group 'org-plantuml-mindmap)

(defun org-plantuml-mindmap--formatted-timestamp ()
  "Return the current date and time as a formatted string: YEAR-MONTH-DAY_HOUR-MINUTE_mindmap."
  (let ((timestamp (format-time-string "%Y-%m-%d_%H-%M")))
    (concat timestamp "_mindmap")))

(defun org-plantuml-mindmap-result ()
  "Check the value of `org-plantuml-mindmap-folder` and set `org-plantuml-mindmap-create' accordingly"
  (let (org-plantuml-mindmap-folder-name)
    (cond ((string= org-plantuml-mindmap-result-type "svg")
           (concat " :file " org-plantuml-mindmap-folder (org-plantuml-mindmap--formatted-timestamp) ".svg"))
          (t
           (message "Wrong `org-plantuml-mindmap-result'")))))

(defun org-plantuml-mindmap-create ()
  "Create a PlantUML mind map code block from the current Org buffer."
  (interactive)
  (let ((mind-map-code ""))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^\\(*+ [^\\n]*\\)$" nil t)
        (setq mind-map-code (concat mind-map-code
                                    (match-string 1) "\n"))
        (forward-line 1)))
    (setq mind-map-code (replace-regexp-in-string "^[*]" ",*" mind-map-code))
    (setq mind-map-code (replace-regexp-in-string "^[[:blank:]\n]*" "" mind-map-code))

    (let ((folder org-plantuml-mindmap-folder))
      (unless (file-directory-p folder)
        (make-directory folder t))
      folder)

    (insert (concat "#+BEGIN_SRC plantuml" (org-plantuml-mindmap-result) "\n"))
    (insert (format "@startmindmap\n%s@endmindmap" mind-map-code))
    (insert "\n#+END_SRC")))

(provide 'org-plantuml-mindmap)
