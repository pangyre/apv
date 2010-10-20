;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

(global-set-key (kbd "C-c q") 'auto-fill-mode)

(setq make-backup-files nil) 
(setq-default ispell-program-name "aspell")


;; Set Function Keys
(global-set-key [(alt a)] 'mark-whole-buffer)
(global-set-key (quote [kp-f1]) (quote beginning-of-buffer))
(global-set-key (quote [kp-f2]) (quote end-of-buffer))
(global-set-key (quote [kp-f3]) (quote find-file))
(global-set-key (quote [kp-f4]) (quote undo))
(global-set-key "\M-1" 'perl-mode)
(global-set-key "\M-2" 'text-mode)
(global-set-key "\M-3" 'script-blank)
(global-set-key "\M-4" 'subroutine-blank)
(global-set-key "\M-5" 'find-file)
(global-set-key "\M-6" 'save-buffers-kill-emacs)
(global-set-key "\M-7" 'ispell-buffer)
(global-set-key "\M-8" 'space-search-replace)
(global-set-key "\M-*" 'space-search-replace-two)
(global-set-key "\M-9" 'perl-package-blank)
(global-set-key "\M-g" 'goto-line)

;; (global-set-key "\M-p" 'C-x C-u M-| perltidy)


(setq inhibit-startup-message t)
; C-h F for some faq

; a little key binding for Perl
(add-hook 'perl-mode-hook
          (function (lambda ()
		            ; never use tabs for indentation...
		            (setq tab-width 8)
			          (setq-default indent-tabs-mode nil)
                      )))

; use automatic line wrapping in text mode...
(add-hook 'text-mode-hook
          '(lambda ()
             (auto-fill-mode 1)
             ))
(setq default-major-mode 'text-mode)

; kill french spacing
(setq sentence-end-double-space nil)

;;----------------------------------------------
(load "minibuffer-tab" t t)
;; Crank cperl up to the max (all options on)
(custom-set-variables
     '(cperl-indent-level 4)
     '(cperl-continued-statement-offset 4)
     '(cperl-tab-always-indent t)
     '(indent-tabs-mode nil)
)
;; (setq cperl-hairy t)

;; Number of keystrokes and seconds between autosaves
(setq auto-save-interval 1000)
(setq auto-save-timeout 960)

(setq completion-ignored-extensions '("~"))

;; Scroll window this many lines when the cursor moves above or below screen
(setq scroll-step 1)

;;SPACE SEARCH REPLACE -----------------------------------------------
(defun space-search-replace ()
  "search out 3 or more new lines and replace it leaving point in orig
  spot"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t\r\f]*\n[ \t\r\f]*\n[\t\r\f]*\n\n+"
                   nil t)
                         (replace-match "\n\n\n" nil nil))))
;;SPACE SEARCH REPLACE 2 ---------------------------------------------
(defun space-search-replace-two ()
  "search out 3 or more new lines and replace it leaving point in orig
  spot"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t\r\f]*\n[ \t\r\f]*\n[\t\r\f]*\n\n+"
                   nil t)
                         (replace-match "\n\n" nil nil))))
;;--------------------------------------------------------------------
(define-skeleton script-blank
  "Insert a blank script."
  nil
  "#!/usr/bin/env perl
use warnings;
use strict;

use CGI qw(:standard);
use Moose;
use namespace::autoclean;

use Carp;
use JSON;
use XML::LibXML;
use WWW::Mechanize;
use HTML::TokeParser;
use Path::Class;
use URI;
use YAML;
use HTML::Entities;
use URI::Escape;

#---------------------------------------------------------------------"
\n
\n
_
\n
\n
"exit 0;

#  Subroutines
#---------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

__DATA__
"
  )
;;--------------------------------------------------------------------
(define-skeleton subroutine-blank
  "Insert a blank sub."
  nil
  "#---------------------------------------------------------------------"
"sub " _ " {"
\n
\n
\n
\n
"}"
  )

;;--------------------------------------------------------------------
(define-skeleton perl-package-blank
  "Insert a blank sub."
  nil
 "#---------------------------------------------------------------------"
\n
"package " _ ";"
\n
"#---------------------------------------------------------------------"
\n
"$VERSION = \'0.01\';"
\n
"use warnings;"
\n
"use strict;"
\n
"use Carp;"
\n
"1;"
\n
\n
"=pod\n\n=head1 Name\n\n\n=head1 Synopsis\n\n=head1 Copyright\n\n\n\n=cut"
)

(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(case-fold-search t)
 '(current-language-environment "English")
 '(global-font-lock-mode t nil (font-lock))
 '(show-paren-mode t nil (paren))
 '(text-mode-hook (quote (turn-on-auto-fill (lambda nil (auto-fill-mode 1)) text-mode-hook-identify)))
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 )


(setq mac-command-key-is-meta t) ;; nil for option key
;; (set-keyboard-coding-system 'mac-roman)


(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq file-name-coding-system  'utf-8)

