#lang info
(define collection "sxml")
(define deps '("sxml"
               "base"
               "static-rename"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib" ))
(define scribblings '(("scribblings/sxml-extra.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.1.0")
(define pkg-authors '(kurinoku))
(define license '(MIT))
