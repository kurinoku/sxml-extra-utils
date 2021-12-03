#lang racket/base

(require racket/string
         sxml)

(provide sxml:text*
         sxpath1
         sxpath*
         sxpath1*)

(module+ test
  (require rackunit))

;; post order depth first
(define (sxml:text* n)
  (cond
    [(string? n) n]
    [else (string-join (map sxml:text* (sxml:content n)) "")]))

(module+ test
  (check-equal?
   (sxml:text* `(div (@ (name "a"))
                     " test "
                     (div (div "for ") "dear")
                     " U"))
   " test for dear U"))

(define (sxpath->sxpath1 sxpath [name 'sxpath1])
  (define (sxpath1 path [ns-bindings '()])
    (define select (sxpath path ns-bindings))
    (lambda (n)
      (let ([v (select n)])
        (if (null? v)
            #f
            (list-ref v 0)))))

  (procedure-rename sxpath1 name))

(define sxpath1 (sxpath->sxpath1 sxpath 'sxpath1))

(module+ test
  ;; breadth first traversal
  (check-equal?
   ((sxpath1 "//div") '(*TOP* (body (a (div (@ (id "hello")))) (div (@ (id "abc"))))))
   '(div (@ (id "abc"))))

  (check-equal?
   ((sxpath1 "//div") '(*TOP* (body (span "no divs") (a (@ (id "abc"))))))
   #f))
   

(define (selector->instant-selector sxpath [name 'instant:sxpath])
  (procedure-rename
   (lambda (path doc [ns-bindings '()])
     ((sxpath path ns-bindings) doc))
   name))

(define sxpath1* (selector->instant-selector sxpath1 'sxpath1*)) 
(define sxpath* (selector->instant-selector sxpath 'sxpath*)) 


                     

