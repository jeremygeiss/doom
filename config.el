;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
;;

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-city-lights)
;;(setq doom-theme 'doom-dark+)
;;(setq doom-theme 'doom-moonlight)
;;(setq doom-theme 'doom-solarized-dark)
;;(setq doom-theme 'doom-solarized-light)
(setq doom-theme 'doom-sourcerer)
;;(setq doom-theme 'doom-tomorrow-night)
;;(setq doom-theme 'doom-tomorrow-day)

(global-visual-line-mode 1)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/Dropbox/Org/todo.org")))

(after! org (setq org-hide-emphasis-markers t))

(after! org (setq org-startup-indented t ))

;;(after! org (setq org-insert-heading-respect-content nil))

(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))

(defun org-ask-location ()
  (let* ((org-refile-targets '((nil :maxlevel . 9)))
         (hd (condition-case nil
                 (car (org-refile-get-location "Headline" nil t))
               (error (car org-refile-history)))))
    (goto-char (point-min))
    (outline-next-heading)
    (if (re-search-forward
         (format org-complex-heading-regexp-format (regexp-quote hd))
         nil t)
        (goto-char (point-at-bol))
      (goto-char (point-max))
      (or (bolp) (insert "\n"))
      (insert "\n* " hd "\n")))
    (end-of-line))

  (after! org
    (add-to-list 'org-capture-templates
          '("b" "Bible Journal" entry
             (file+datetree "~/Dropbox/notes/bible_journal.org")
             (file "~/Dropbox/org/org-templates/bible_journal.orgcaptmpl"))
           )
    (add-to-list 'org-capture-templates
           '("j" "Journal" entry
             (file+datetree "~/Dropbox/notes/journal.org")
             (file "~/Dropbox/org/org-templates/journal.orgcaptmpl"))
           )
    (add-to-list 'org-capture-templates
            '("r" "Reading Note" plain
             (file+function "~/Dropbox/notes/20210321093756-reading_notes.org" org-ask-location)
             (file "~/Dropbox/org/org-templates/reading.orgcaptmpl"))
            )
    (add-to-list 'org-capture-templates
            '("i" "Inbox capture" plain
             (file "~/Dropbox/notes/Inbox.org")
             ;;"\n* %U %^{Title}\n %?")
             (file "~/Dropbox/org/org-templates/inbox.orgcaptmpl"))
            )
    (add-to-list 'org-capture-templates
            '("w" "writing notebook" plain
             (file "~/Dropbox/notes/20201025114743-writers_notebook.org")
             ;;"\n* %U %^{Title}\n %?")
             (file "~/Dropbox/org/org-templates/inbox.orgcaptmpl"))
            )
    )

(setq org-roam-directory "~/Dropbox/notes")

(setq insert-esv-crossway-api-key "INSERT-YOUR-API-KEY")
(setq insert-esv-include-short-copyright 'true)
(setq insert-esv-include-verse-numbers 'true)
(setq insert-esv-include-headings 'true)
;;keybindings SPC a e 'insert-esv-passage'
(map! :leader
      (:prefix-map ("a" . "applications")
        :desc "Insert ESV Passage" "e" #'insert-esv-passage))

;;keybindings SPC a w 'writeroom-mode'
(map! :leader
      (:prefix-map ("a" . "applications")
        :desc "Writeroom Mode" "w" #'writeroom-mode));;)
