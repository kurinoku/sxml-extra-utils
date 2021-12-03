#lang info
(define collection "sxml")
(define deps '("sxml"
               "base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib" ))
(define scribblings '(("scribblings/sxml-extra.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(kurinoku))
(define license '(MIT))
