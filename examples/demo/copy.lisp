;; Copyright (c) 2026 Marin Atanasov Nikolov <dnaeon@gmail.com>
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:
;;
;;  1. Redistributions of source code must retain the above copyright
;;     notice, this list of conditions and the following disclaimer
;;     in this position and unchanged.
;;  2. Redistributions in binary form must reproduce the above copyright
;;     notice, this list of conditions and the following disclaimer in the
;;     documentation and/or other materials provided with the distribution.
;;
;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
;; IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
;; OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
;; IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
;; NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
;; THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package :clingon.demo)

(defun copy/options ()
  "Returns the options for the `copy' command"
  (list
   (clingon:make-option :flag
                        :short-name #\f
                        :long-name "force"
                        :description "overwrite destination if it exists"
                        :key :force)))

(defun copy/handler (cmd)
  "Handler for the `copy' command"
  (let ((source (pathname (clingon:getopt cmd :source)))
        (dest (pathname (clingon:getopt cmd :dest)))
        (force (clingon:getopt cmd :force)))
    (when (and (probe-file dest) (not force))
      (format *error-output* "~&Destination ~A already exists. Use --force to overwrite.~%" dest)
      (clingon:exit 1))
    (uiop:copy-file source dest)
    (format t "~A -> ~A~%" source dest)))

(defun copy/command ()
  "Creates a new command which demonstrates named positional arguments"
  (clingon:make-command
   :name "copy"
   :aliases '("cp")
   :description "copy a file to a destination"
   :handler #'copy/handler
   :options (copy/options)
   :arguments (list
               (clingon:make-argument :name "source"
                                      :description "source file to copy"
                                      :key :source
                                      :required t)
               (clingon:make-argument :name "dest"
                                      :description "destination path"
                                      :key :dest
                                      :required t))
   :examples '(("Copy a file to a new location:" .
                "clingon-demo copy foo.txt bar.txt")
               ("Copy with force overwrite:" .
                "clingon-demo copy --force foo.txt bar.txt"))))
