#lang scribble/manual
@require[scribble/eval
         @for-label[sxml/extra-utils
                    sxml
                    racket/base
                    racket/string
                    racket/contract]]

@title{SXML Misc Utilities}
@author{kurinoku}

@(begin
   (define the-eval (make-base-eval))
   (the-eval `(begin (require sxml
                              sxml/extra-utils
                              racket/pretty
                              racket/string)
                     (current-print pretty-print-handler))))

@defmodule[sxml/extra-utils]

A module that has some sxml functions that might be of use

@defproc[(sxml:text* [node-or-nodeset (or _node nodeset?)])
         string]{
  Like @racket[sxml:text] but it retrieves all string contents from a node,
  in depth first post order, which is likely the rendered order and the expected one.

  Consider the following

  @interaction[#:eval the-eval
    (define tree
      '(body
        (div "a ")
        (div
         (div "string ")
         "in "
         (div (span "or") "der"))))
    (string-join ((sxpath "//text()") tree) "")
    (sxml:text tree)
    (sxml:text* tree)
     ]
  }

@defproc[(sxpath1
          [path (or/c list? string?)]
          [ns-bindings (listof (cons/c symbol? string?)) '()])
         (-> (or/c _node nodeset?) (or/c _node #f))]{
  Like @racket[sxpath] but it returns the first element it finds on a breadth first search or it returns @racket[#f].
  }

@deftogether[(
@defproc[(sxpath*
          [path (or/c list? string?)]
          [doc (or/c _node nodeset?)]
          [ns-bindings (listof (cons/c symbol? string?)) '()])
         nodeset?]
@defproc[(sxpath1*
          [path (or/c list? string?)]
          [doc (or/c _node nodeset?)]
          [ns-bindings (listof (cons/c symbol? string?)) '()])
         (or/c _node #f)])]{
  Equivalent to @racket[ ((_proc path ns-bindings) doc)  ] where @racket[_proc] is either @racket[sxpath] or @racket[sxpath1] respectively.
                }

@defproc[(node-has-classes? [class-lst (listof (or/c string? symbol?))]) sxml-converter]{
  Behaves likes @racket[sxml:filter], filters nodes by the elements of its class attribute,
  the class attribute is made into a list by means of @racket[string-split].

  
  All classes in the list must be present in the node to match.
  
  Some examples found in the test suite.
  @interaction[#:eval the-eval
    (define tree
      '(body
        (div (|@| (class "mt-2 mb-2")))
        (div (|@| (class "mt-2")))
        (div (|@| (class "mt-2 mb-2 p-1")))))
               
    ((node-join
      (sxpath '(//))
      (node-reduce
       (sxpath '(div))
       (node-has-classes? '("mt-2" "mb-2"))))
    tree)

   ((sxpath
     `(// div
          ,(node-has-classes? '("mt-2" "mb-2"))))
    tree)

   ((sxpath
     `(// (div
           (,(node-has-classes? '("mt-2" "mb-2"))))))
    tree)
    ]
  }

@defproc[(node-has-class? [class (or/c string? symbol?)]) sxml-converter]{
  Like @racket[node-has-class?], but for only one class.
}
  
                                             