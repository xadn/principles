(define (start)
  (begin
    (display "Game option 1 or 2? ")
    (if (eq? (read) 1) (nim 1 '(1 2 5 7))
        (nim 1 '(4 3 5)) )
  ))

(define (nim player sticks)
  (begin
    (newline)
    (display "Turn for player: ")
    (display player)
    (newline)
    (display "Row 1:")
    (printRows 1 sticks)
    (display "Enter row: ")
    (let ((row (read)))
     (display "Enter num sticks: ")
      (let ((num (read)))
        (if (<= row (length sticks))
             (let ((newSticks (reverse (removeSticks row num (reverse sticks)))))
               (if (validNum newSticks)
                   (cond
                     ((win newSticks) (begin (display "Player ") (display player) (display " wins!")))
                     (else (nim (+ 1 (modulo player 2)) newSticks))
            )(error player sticks)
             ))
            (error player sticks)
            )))))

(define (error player sticks)
  (begin
                   (display "Invalid input, try again")
                   (newline)
                    (nim player sticks)))

(define (validNum sticks)
  (cond
    ((eq? (length sticks) 0) #t)
    ((< (car sticks) 0) #f)
    (else (validNum (cdr sticks)))
    ))
    

(define (win sticks)
  (cond
    ((eq? (length sticks) 0) #t)
    ((eq? (car sticks) 0) (win (cdr sticks)))
    (else #f)
    ))

(define (removeSticks row num sticks)
  (cond
    ((eq? row (length sticks)) (append (list (- (car sticks) num)) (cdr sticks)))
    (else (append (list (car sticks)) (removeSticks row num (cdr sticks))))
    ))
  
(define (printRows label sticks)
  (cond
    ((and (eq? (car sticks) 0) (null? (cdr sticks))) 
     (newline)
     )
    ((eq? (car sticks) 0) (begin 
                            (newline) 
                            (display "Row ") (display (+ label 1)) (display ":") 
                            (printRows (+ label 1) (cdr sticks)))
                          )
    ((> (car sticks) 0) (begin 
                          (display " X") 
                          (printRows label (append (list (- (car sticks) 1)) (cdr sticks))))
                        )
    ))