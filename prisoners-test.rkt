#lang racket/base

(require rackunit "prisoners.rkt")
(check-equal? (run defectbot defectbot) '(defect defect))
(check-equal? (run defectbot cooperatebot) '(defect cooperate))

(check-equal? (run (make-family-friendly defectbot)
                   (make-family-friendly cooperatebot))
              '(cooperate cooperate))
