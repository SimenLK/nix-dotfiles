;; Configure package.el to include MELPA.
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;; Ensure that use-package is installed.
;;
;; If use-package isn't already installed, it's extremely likely that this is a
;; fresh installation! So we'll want to update the package repository and
;; install use-package before loading the literate configuration.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file "~/.emacs.d/configuration.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yard-mode yaml-mode which-key wgrep web-mode use-package tuareg solarized-theme smex slim-mode scss-mode scala-mode sbt-mode rust-mode ruby-end rspec-mode rainbow-delimiters python-mode py-autopep8 projectile-rails powerthesaurus paredit org-plus-contrib org-bullets multi-term moody minions merlin key-chord htmlize helpful haskell-mode haml-mode graphviz-dot-mode go-errcheck gnuplot git-timemachine fsharp-mode forge flycheck-package flx evil-surround evil-org evil-magit evil-collection engine-mode elpy dumb-jump dotnet dired-open dired-hide-dotfiles diff-hl deft deadgrep counsel company-jedi company-go company-coq coffee-mode chruby auto-compile))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t nil))))
