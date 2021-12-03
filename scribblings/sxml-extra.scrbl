#lang scribble/manual
@require[@for-label[sxml/extra-utils
                    sxml
                    racket/base
                    racket/contract]]

@title{SXML Misc Utilities}
@author{kurinoku}

@defmodule[sxml/extra-utils]

A module that has some sxml functions that might be of use

@defproc[(sxml:text* [node-or-nodeset (or node nodeset?)])
         string]{
  Like @racket[sxml:text] but it retrieves all string contents from a node,
  in depth first post order.
  }

@defproc[(sxpath1
          [path (or/c list? string?)]
          [ns-bindings (listof (cons/c symbol? string?)) '()])
         (-> (or/c node nodeset?) (or/c node #f))]{
  Like @racket[sxpath] but it returns the first element it finds on a breadth first search or it returns @racket[#f].
  }

@deftogether[(
@defproc[(sxpath*
          [path (or/c list? string?)]
          [doc (or/c node nodeset?)]
          [ns-bindings (listof (cons/c symbol? string?)) '()])
         nodeset?]
@defproc[(sxpath1*
          [path (or/c list? string?)]
          [doc (or/c node nodeset?)]
          [ns-bindings (listof (cons/c symbol? string?)) '()])
         (or/c node #f)])]{
  Equivalent to @racket[ ((proc path ns-bindings) doc)  ] where @racket[proc] is either @racket[sxpath] or @racket[sxpath1].
                }
  
                                             