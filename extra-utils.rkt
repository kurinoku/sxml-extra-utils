#lang racket/base

(require racket/string
         sxml)

(provide sxml:text*
         sxpath1
         sxpath*
         sxpath1*

         node-has-classes?
         node-has-class?)

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

; this came up while trying to understand the sxml lib
; if you put a procedure it expects two arguments
; I believe it has to do with ns-bindings in sxpath
; but it's called var-bindings in the place it's called
; so I don't really know
(define (wrap-for-sxpath-splicing f [who #f])
  (define (proc node [_unused '()])
    (f node))

  (if who
      (procedure-rename proc who)
      proc))

(define (node-has-classes? class-lst)
  (define new-class-lst
    (map
     (lambda (c) (if (symbol? c) (symbol->string c) c))
     class-lst))
  (define f
    (sxml:filter
     (node-join (sxpath '(@ class))
                (select-kids
                 (lambda (class-list/string)
                   (let ([class-list (string-split class-list/string)])
                     (for*/and ([c (in-list new-class-lst)])
                       (for/or ([cls (in-list class-list)])
                         (equal? cls c)))))))))
  
  (wrap-for-sxpath-splicing f 'node-has-classes?))

(module+ test
  
  (check-equal?
   ((node-join (sxpath '(//))
               (node-reduce (sxpath '(div))
                            (node-has-classes? '("mt-2" "mb-2"))))
    '(body
      (div (@ (class "mt-2 mb-2")))
      (div (|@| (class "mt-2")))
      (div (@ (class "mt-2 mb-2 p-1")))))
   '((div (@ (class "mt-2 mb-2")))
     (div (@ (class "mt-2 mb-2 p-1")))))
  
  (check-equal?
   ((sxpath `(// div ,(node-has-classes? '("mt-2" "mb-2"))))
    '(body
      (div (@ (class "mt-2 mb-2")))
      (div (|@| (class "mt-2")))
      (div (@ (class "mt-2 mb-2 p-1")))))
   '((div (@ (class "mt-2 mb-2")))
     (div (@ (class "mt-2 mb-2 p-1")))))
  )

(define (node-has-class? class) (node-has-classes? (list class)))
