;;; deymstifycpp.el --- C++ Macro Expander for Emacs  
;; 
;; Demystifycpp resurrects functionality that used to work out of the box for 
;; Emacs C mode: preprocssor macro expansion. 
;;
;; The problem of macro expansion has resurfaced in modern C++ due to limitations
;; with  meta-programming in C++. Although frowned uopon in general use because of
;; issues inherent to macro hygene and type safety, pre-processor macros
;; are seeing a resurgance in their popularity in C++ meta programming where 
;; they are used to compensate for the inherent limitations of template parameterization 
;; (STL) as a meta programming tool. Pre-processor macros allow arbitraty textual
;; transformations, hence may be used, in a very limited way, to similar effect as Lisp macros.
;;
;; A classic example are the many macros in BOOST, for example BOOST_AUTO_TEST_CASE
;;
;; Pre-processor expansion is provided natively by C++ compilers, yet the listing of header
;; #includes usually yields multiple thousands of lines of output for even
;; the tiniest C++ code examples, which makes sensible code navigation nearly impossible.
;; Demystifycpp solves this by truncating includes and presenting a read only buffer
;; with all macros expanded directly in the editor. 
;;
;;
;; Copyright (C) 2010,2014 Christoph A. Kohlhepp, all rights reserved.
;; Email chrisk at manx dot net
;; http://www.linkedin.com/in/chriskohlhepp
;;
;; Licensed under the GNU General Public License.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;;
;; To install this package, put this file somewhere in your
;; Emacs load path. In my case this is ~/.emacs/includes.
;;
;; Somewhere in your .emacs add the following line
;;
;;      (require 'demystifycpp)
;;      
;; Override demystifycpp-opts-hook to provide generic or file specific
;; options to be passed to g++, such as include path
;;
;; (defun demystifycpp-opts-hook (file)
;;   "-I /opt/local/include")
;;
;; Invoke cpp-demystify in C++ buffer 
;;
;; Error messages appear in *Messages* buffer
;;
;; Creates auxilliary buffer with earmuffs surrounding buffer name
;; So main.cpp would be decoded to *main.cpp*
;;

;;========================
;; Customization Group
;;========================
(defgroup demystifycpp  nil
  "C++ Preprocessor Macro Expander"
)

(defcustom cpp-macro-expander  "/usr/bin/g++ -std=c++11 -E -C" 
  "C++ macro expander - please use -C or equivalent to preserve comments."
  :type 'string
  :group 'demystifycpp)

(defcustom truncate-includes  t
  "Austomatically truncate includes"
  :group 'deymstifycpp
  :type 'boolean)


(defun cpp-demystify ()
  "Function to expand C++ preprocessor macros on source code buffer.
   Creates auxilliary buffer with earmuffs surrounding buffer name"
  (interactive)

  (if (eq major-mode 'c++-mode)
      (let* ((cpp-file-name (buffer-file-name)) 
             (cpp-buffer (buffer-name))
             (temp-buffer (concat "*" cpp-buffer "*"))
             (opts "")
             (cmd nil) 
             (start-position (point-min))
             (end-position nil))
        
        (if (fboundp 'demystifycpp-opts-hook) 
            (setq opts (funcall 'demystifycpp-opts-hook cpp-file-name))) 

        (setq cmd (concat cpp-macro-expander " " opts " " cpp-file-name))

        (with-output-to-temp-buffer temp-buffer
          (message cmd)
          (shell-command cmd temp-buffer "*Messages*") ; error messages appear in *Messages*
          (pop-to-buffer temp-buffer)
          (if truncate-includes 
              (progn
                (while (search-forward cpp-file-name nil t) 
                  (if (< (length (thing-at-point 'line)) (* 2 (length cpp-file-name)))
                     (setq end-position (point))))

                (if end-position 
                    (progn (delete-region start-position end-position)
                           (goto-char (point-min)) ; skip first line
                           (search-forward "\n" nil t)
                           (delete-region (point-min) (point))
                           (goto-char (point-min)) ; follow open lexical scope with newline
                           (while (re-search-forward "{ " nil t) (replace-match "{\n "))
                           (goto-char (point-min)) ; follow semicolon with newline
                           (while (re-search-forward "; " nil t) (replace-match ";\n "))))))

          (call-interactively 'c++-mode) ; apply c++ mode formatting
          (indent-region (point-min) (point-max)))) ; indent canonically
      (message "cpp-macro-expand only works on C++ files")))


(provide 'demystifycpp)

