#lang racket

(provide (all-defined-out))

; stolen from https://stackoverflow.com/questions/20778926/mysterious-racket-error-define-unbound-identifier-also-no-app-syntax-trans
; tldr: eval is weird
(define limited-eval
  (let ((ns (make-base-namespace)))
    (parameterize ((current-namespace ns))
      (namespace-require 'racket))
    (lambda (expr) (eval expr ns))))

(define (run p1 p2)
  (list ((limited-eval `(lambda (self partner) ,p1)) p1 p2)
        ((limited-eval `(lambda (self partner) ,p2)) p2 p1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Define some simple players

; always defect
(define defectbot
  ''defect)
; always cooperate
(define cooperatebot
  ''cooperate)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Define some players with more sophisticated behavior

; cooperate with self, defect on everyone else
(define clone-cooperator
  '(if (equal? self partner)
       'cooperate
       'defect))

; wrap a player to make it always defect against defectbot
(define (make-defect-against-defectbot player)
  `(if (equal? partner ,defectbot)
       'defect
       ,player))

; wrap a player to make it defect against partners who can't model it
; (sneaky tricks like (symbol->string "partner") aren't caught)
(define (make-predict-simple-opponents player)
  `(if (member 'partner (flatten partner))
       ,player
       'defect))

; This function wraps a player to produce a "family-friendly" player
;  (i.e. a player which will cooperate with other family-friendly players)
; with the original player's behavior for non-family-friendly partners.
(define (make-family-friendly player)
  `(if (and (>= (length partner) 3)
            (equal? (take self 3)
                    (take partner 3)))
       'cooperate
       ,player))

