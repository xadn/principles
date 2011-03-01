(define (start)
  (begin
    (display "Game option 1 or 2? ")
    (humanMove (if (eq? (read) 1) '(1 2 5 7) '(4 3 5)))))

(define (humanMove sticks)
  (begin
    (display (string-append "\nPlayer's turn:\n" (rowToX sticks 0)))
    (removeSticks sticks
         (begin (display "Enter row: ") (read))
         (begin (display "Enter num sticks: ") (read)))))

;(define (computerMove sticks))
        
(define (inKernel sticks)
  (if (eq? 0 (listXor sticks)) #t #f))

(define (listXor sticks)
  (if (> (length sticks) 0)
      (bitwise-xor (car sticks) (listXor (cdr sticks))) 0))

(define (NIM player sticks)
             (let ((newSticks (removeSticks sticks remRow remNum )))
               (if (and (validNum newSticks) (<= remRow (length sticks)))
                   (if (win newSticks)
                       ; Win conditions met
                       (begin (display "\nComputer wins!\n"))
                       ; Else, keep playing
                       ; if player 1, call computerMove, else call humanMove
                       (if (= 1 player)
                            (computerMove (modulo (+ 1 player) 2) newSticks 1 0)
                            (humanMove (modulo (+ 1 player) 2) newSticks)))
                   (error player sticks))))

(define (error sticks)
  (begin
    (display "Invalid input, try again\n")
    (humanMove sticks)))

(define (validNum sticks)
  (cond
    ((eq? (length sticks) 0) #t)
    ((< (car sticks) 0) #f)
    (else (validNum (cdr sticks)))))
    
; Return TRUE if win conditions have been met, else FALSE
(define (win sticks)
  (cond
    ; If there are no rows, return TRUE
    ((eq? (length sticks) 0) #t) 
    ; If the first row is 0, remove it and check again...
    ((eq? (car sticks) 0) (win (cdr sticks)))
    ; If the first row is non-0, return FALSES
    (else #f)))

; Remove remove num sticks from sticks as specified by row
(define (removeSticks sticks row num)
  (cond
    ((= (length sticks) 0)
     (error sticks))
    ((= row 0)
      (append (list (- (car sticks) num)) (cdr sticks)))
      (else
      (append (list (car sticks)) (removeSticks (- row 1) num (cdr sticks))))))

; Print each X in the row
(define (numToX num)
  (if (> num 0)
      (string-append "X" (numToX (- num 1))) ""))

; Print each row
(define (rowToX sticks startingRow)
    (if (> (length sticks) 0)
        (string-append "Row " (number->string startingRow) ": " (numToX (car sticks)) "\n" (rowToX (cdr sticks) (+ startingRow 1))) ""))