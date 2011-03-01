(define (start)
  (begin
    (display "Game option 1 or 2? ")
    (humanMove 1 (if (eq? (read) 1) '(7 5 2 1) '(5 3 4)))))

(define (humanMove player sticks)
  (begin
    (display (string-append "\nPlayer's turn:\n" (rowToX sticks)))
    (NIM player sticks 
         (begin (display "Enter row: ") (read))
         (begin (display "Enter num sticks: ") (read)))))

(define (smartComputer player sticks remRow remNum)
     (cond
       ((inKernel (removeSticks remRow remNum sticks))
        (begin (display "kernel OK!")
        (NIM player sticks remRow remNum)))
       ((>= remNum (nth sticks (- (length sticks) remRow)))
             (begin (display "row++")
        (smartComputer player sticks (+ remRow 1) 0)))
       (else
        (begin (display "num++")
        (smartComputer player sticks remRow (+ remNum 1))))
       )
     )

(define (dumbComputer player sticks remRow remNum)
  (let ((randRow (random (length sticks))))
    (if (> (nth sticks randRow) 0)
    (let ((randNum (random (nth sticks randRow))))
          (if (<= randNum (nth sticks randRow))
              (NIM player sticks randRow randNum)
              (dumbComputer player sticks remRow remNum)))
    (dumbComputer player sticks remRow remNum))))
  
(define (inKernel sticks)
  (if (eq? 0 (listXor sticks)) #t #f))

(define (listXor sticks)
  (if (> (length sticks) 0)
      (bitwise-xor (car sticks) (listXor (cdr sticks))) 0))

(define (NIM player sticks remRow remNum)
             (let ((newSticks (removeSticks remRow remNum sticks)))
               (if (and (validNum newSticks) (<= remRow (length sticks)))
                   (if (win newSticks)
                       ; Win conditions met
                       (begin (display "\nComputer wins!\n"))
                       ; Else, keep playing
                       ; if player 1, call computerMove, else call humanMove
                       (if (= 1 player)
                            (dumbComputer (modulo (+ 1 player) 2) newSticks 1 0)
                            (humanMove (modulo (+ 1 player) 2) newSticks)))
                   (error player sticks))))

(define (error player sticks)
  (begin
    (display "Invalid input, try again\n")
    (humanMove player sticks)))

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
(define (removeSticks row num sticks)
  (if (eq? row (length sticks))
      (append (list (- (car sticks) num)) (cdr sticks))
      (append (list (car sticks)) (removeSticks row num (cdr sticks)))))

; Print each X in the row
(define (numToX num)
  (if (> num 0)
      (string-append "X" (numToX (- num 1))) ""))

; Print each row
(define (rowToX sticks)
    (if (> (length sticks) 0)
        (string-append "Row " (number->string (length sticks)) ": " (numToX (car sticks)) "\n" (rowToX (cdr sticks))) ""))