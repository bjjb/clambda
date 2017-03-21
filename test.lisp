(let ((sock (socket-connect 19191)))
  (format sock "(+ 11 31)")
  (format t "~&~D~%" (read sock)))
