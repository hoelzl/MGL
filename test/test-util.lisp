(in-package :mgl-test)

(defun test-make-n-gram-mappee ()
  (assert (equal (let ((r ()))
                   (map nil (make-n-gram-mappee (lambda (x)
                                                  (push x r))
                                                3)
                        '(0 1 2 3))
                   (reverse r))
                 '((0 1 2) (1 2 3)))))

(defun test-break-seq ()
  (assert (equal (mgl-util:break-seq '(2 3) '(0 1 2 3 4 5 6 7 8 9))
                 '((0 1 2 3) (4 5 6 7 8 9))))
  (assert (equal (mgl-util:break-seq '(2 3) '(0))
                 '(() (0)))))

(defun test-stratified-split ()
  (assert (equal (stratified-split '(2 3) '(0 1 2 3 4 5 6 7 8 9) :key #'evenp)
                 '((0 2 1 3) (4 6 8 5 7 9))))
  (assert (equal (stratified-split '(2 3) '(0 1 2 3 4) :key #'evenp)
                 '((0) (2 4 1 3)))))

(defun test-log-likelihood-ratio ()
  (assert (= 1.2785435
             (binomial-log-likelihood-ratio 3 7 2 11)
             (binomial-log-likelihood-ratio 4 7 9 11)
             (multinomial-log-likelihood-ratio #(3 4) #(2 9)))))

(defun test-running-stat ()
  (let ((stat (make-instance 'running-stat))
        (list ()))
    (dotimes (i 100)
      (let ((x (random 10d0)))
        (add-to-running-stat x stat)
        (push x list)))
    (assert (< (- (running-stat-mean stat)
                  (alexandria:mean list))
               0.00001))
    (assert (< (- (running-stat-variance stat)
                  (alexandria:variance list :biased nil))
               0.00001))))

(defun test-util ()
  (test-make-n-gram-mappee)
  (test-break-seq)
  (test-stratified-split)
  (test-log-likelihood-ratio)
  (test-copy)
  (test-confusion-matrix)
  (test-running-stat))
