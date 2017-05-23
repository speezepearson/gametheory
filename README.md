For example:

```racket
    > (require "prisoners.rkt")
    > defectbot
    ''defect
    > clone-cooperator
    '(if (equal? self partner) 'cooperate 'defect)
    > (make-family-friendly clone-cooperator)
    '(if (and (>= (length partner) 3) (equal? (take self 3) (take partner 3)))
       'cooperate
       (if (equal? self partner) 'cooperate 'defect))
    > (define player-names '(defectbot cooperatebot clone-cooperator (make-family-friendly defectbot) (make-family-friendly clone-cooperator)))
    > (for [(pn1 player-names)]
        (printf "~a  " (~a pn1 #:width 40))
        (for [(pn2 player-names)]
          (printf "~a " (if (equal? (first (run (eval pn1) (eval pn2))) 'cooperate) "C" ".")))
        (printf "~n"))
    
    defectbot                                 . . . . .
    cooperatebot                              C C C C C
    clone-cooperator                          . . C . .
    (make-family-friendly defectbot)          . . . C C
    (make-family-friendly clone-cooperator)   . . . C C
```
