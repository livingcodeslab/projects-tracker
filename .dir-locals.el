((nil
  . ((eval
      . (let* ((project-dir
                (directory-file-name
                 (or (locate-dominating-file default-directory ".git")
                     default-directory)))
               (capture-file (concat project-dir "/captured-todos.org")))
          (setq living-codes-lab-agenda-files
                (directory-files-recursively project-dir "^.*\.org$"))
          (dolist (element living-codes-lab-agenda-files nil)
            ;; update the org-agenda-files:
            ;; - Add any orgmode file in the repo to list of agenda files
            (unless (member element org-agenda-files)
              (add-to-list 'org-agenda-files element)))

          (unless (and (boundp 'living-codes-lab-settings-loaded)
                       living-codes-lab-settings-loaded)
            (setq
             org-refile-targets
             (append org-refile-targets '((living-codes-lab-agenda-files :maxlevel . 9))))
            (setq
             ;; update the org capture templates
             org-capture-templates
             (append org-capture-templates
                     `(("l" "Living Codes Labs: Captures")
                       ("lt" "Living Codes Labs: Tasks"
                        entry (file+headline ,capture-file "Captured")
                        "**** TODO %^{TASKNAME} :livingcodeslab:%^G\n %a\n\n")
                       ("lo" "Living Codes Labs: Orders"
                        entry (file+headline ,capture-file "Orders")
                        "**** ORDER %^{ORDERNAME} :livingcodeslab:orders:%^G\n :PROPERTIES:\n :LINK: %^{LINK}\n :QUANTITY: %^{QUANTITY}\n :UNITS: %^{UNITS}\n :END:\n\n"))))
            (setq
             ;; update the org TODO keywords
             org-todo-keywords
             (append org-todo-keywords
                     '((sequence "TODO" "INPROGRESS" "WAITING" "|" "DONE")
                       (sequence "ORDER" "ORDERED" "SHIPPING" "DELAYED" "|" "RECEIVED"))))
            ;; ==== Add things to evaluate before this line ====
            ;; Set flag: this should be last thing in this eval
            (setq living-codes-lab-settings-loaded t)))))))
