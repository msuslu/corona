(in-package :corona-test)

;;; Test suites

(def-suite corona)
(in-suite corona)

(test testing-environment
  (finishes
    (ensure-directories-exist +tmp-dir+))
  (is-true
   #+corona-testing t #-corona-testing nil)
  (is (equal corona.files:+corona-directory+
             (asdf:system-relative-pathname :corona #p"t/corona-files/"))))

(test start-box-server
  (finishes
    (setf *server-handler*
          (clack:clackup +server+ :port +server-port+))))

(test create-fake-files
  (finishes
    (loop for file in +tarball-file-list+ do
      (make-fake-file file)))
  (finishes
    (make-tarball +tarball-path+
                  +tarball-file-list+))
  (finishes
    (loop for file in +tarball-file-list+ do
      (delete-file file))))

(test download-box
  (is-false
   (corona.cloud:local-box-p +box+))
  (is-true
   (corona.cloud:download-and-extract-box +box+)))

(test clean-up
  (finishes
    (clack:stop *server-handler*))
  (finishes
    (cl-fad:delete-directory-and-files +tmp-dir+))
  (finishes
    (cl-fad:delete-directory-and-files corona.files:+corona-directory+)))

(run! 'corona)

(remove :corona-testing *features*)
