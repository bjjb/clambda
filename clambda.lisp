(defun λ (&optional (port 19191) (bind "0.0.0.0"))
  "Listens for S-expressions on the given port and address, reads the input
  from connecting sockets, evaluates them, and prints them back onto the
  socket."
  (let ((srv (socket-server port :interface bind)))
    (format t "~&Waiting for a connection on ~S:~D~%"
            (socket-server-host srv) (socket-server-port srv))
    (unwind-protect
      (loop
        (with-open-stream (sock (socket-accept srv))
          (multiple-value-bind (host port) (socket-stream-local sock)
            (format t "~&Connection: ~S:~D~%" host port))
          (loop
            (when (eq :eof (socket-status (cons sock :input))) (return))
            (print (eval (read sock)) sock) ; the core
            (loop :for c = (read-char-no-hang sock nil nil) :while c)
            (terpri sock))))
      (socket-server-close srv)
      (format t "~&Goodbye~%"))))

(λ)
