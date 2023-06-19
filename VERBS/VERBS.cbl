      *----------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VERBS.
       AUTHOR. AYSU ÖNER.
       DATE-WRITTEN. 12-06-2023.
       DATE-COMPILED. 12-06-2023.
      *----------------------------------
       DATA DIVISION.
         WORKING-STORAGE SECTION.
      *>numbers we will perform operations on
       01 NUM1 PIC 9(9) VALUE 10.
       01 NUM2 PIC 9(9) VALUE 10.
       01 NUM3 PIC 9(9) VALUE 100.
       01 NUM4 PIC 9(9) VALUE 15.

      *> variables we will use to store results
       01 NUMC      PIC 9(9).
       01 RES-DIV   PIC 9(3).
       01 RES-MOD   PIC 9(3).
       01 RES-MULT  PIC 9(3).
       01 RES-SUB   PIC 9(3).
       01 RES-ADD   PIC 9(3).
       01 RES-MOV   PIC 9(3).
      *----------------------------------
       PROCEDURE DIVISION.
         MAIN-PROCEDURE SECTION.
      *> compute num1 times num2 and store result in numc
           COMPUTE NUMC = (NUM1 * NUM2).
      *> divide num3 by num4 and store result in res-div and res-mod
		         DIVIDE NUM3 BY NUM4 GIVING RES-DIV REMAINDER RES-MOD.
      *> multiply num3 by num4 storing result in res-mult
		         MULTIPLY NUM3 BY NUM4 GIVING RES-MULT.
      *>subtract num3 from num4 store result in res-sub
		         SUBTRACT num3 FROM num4 GIVING RES-SUB.
      *> add num3 to num4 and store result in res-add
		         ADD num3 TO num4 GIVING RES-ADD.
      *> the pointer from num3 to
		         MOVE NUM3 TO RES-MOV.
      *> reinitilize num1
		         INITIALIZE NUM1.
      *> reinitilize num2 but replace numeric data with 12345
		         INITIALIZE NUM2 REPLACING NUMERIC DATA BY 12345.

		         DISPLAY "NUMC:" NUMC.
               DISPLAY "RES-DIV:" RES-DIV.
               DISPLAY "RES-MOD:" RES-MOD.
               DISPLAY "RES-MULT:" RES-MULT.
               DISPLAY "RES-SUB:" RES-SUB.
               DISPLAY "RES-ADD:" RES-ADD.
               DISPLAY "RES-MOV:" RES-MOV.
               DISPLAY "REINITIALIZED NUM1: " NUM1.
               DISPLAY "REINITIALIZED NUM2: " NUM2.
           STOP RUN.
       END PROGRAM VERBS.
