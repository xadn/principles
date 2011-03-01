; Andy Niccolai 2/7/2011
; Advanced Scheme Assignment
; Principles of Programming Languages

; Usage: (keywordSearch "<keyword>" articles)

; This follows the format suggested by Dr Rader for the assigment.

(define (createSearch keyword) (lambda (article) (member keyword (getKeywords article))))

(define (applySearchFn searchFn . args) 
  (lambda x
    (apply searchFn (append args x))))

(define (doSearch keyword articles)
  (let* ((searchFn (createSearch keyword))
         (mappableSearchFn (applySearchFn searchFn)))
    (map mappableSearchFn articles)))
    
(define (selectTitles titles results articles)
  (cond ((null? results) titles)
        ((not (equal? #f (car results))) (selectTitles (append titles (list (getTitle (car articles)))) (cdr results) (cdr articles)))
        (else (selectTitles titles (cdr results) (cdr articles)))))

; same as above but the "if" is nested inside of the recursive call to selectTitles... why not?
(define (selectTitles2 titles results articles)
  (if (null? results) titles 
      (selectTitles (if (equal? #f (car results)) titles (append titles (list (getTitle (car articles))))) (cdr results) (cdr articles))))

(define (keywordSearch keyword articles)
  (display (selectTitles '() (doSearch keyword articles) articles)))

(define (getTitle article) (car article))

(define (getAuthors article) (nth article 1))
         
(define (getKeywords article) (nth article 2))

(define articles '(
     ((Test-Driven Learning: Intrinsic Integration of Testing into the CS/SE Curriculum)
      ((David Jansen)(Hossein Saiedian))
      ("Test-driven learning" "test-driven development" "extreme programming" "pedagogy" "CS1"))
     ((Process Improvement of Peer Code Review and Behavior Analysis of its Participants)
      ((WANG Yan-qing) (LI Yi-jun) (Michael Collins) (LIU Pei-jie))
      ("peer code review" "behavior analysis" "software quality assurance" 
        "computer science education" "software engineering"))
     ((Computer Games as Motivation for Design Patterns)
      ((Paul V. Gestwicki))
      ("Design Patterns" "Games" "Pedagogy" "Java"))
     ((Killer "Killer Examples" for Design Patterns)
      ((Carl Alphonce) (Michael Caspersen) (Adrienne Decker))
      ("Object-orientation" "Design Patterns"))
     ((Test-First Java Concurrency for the Classroom)
      ((Mathias Ricken)(Robert Cartwright))
      ("CS education" "Java" "JUnit" "unit testing" "concurrent programming"
       "tools" "software engineering"))
     ((Teaching Design Patterns in CS1: a Closed Laboratory Sequence
                based on the Game of Life)
      ((Michael Wick))
      ("Design Patterns" "Game of Life" "CS1" "Laboratory"))
   ))
