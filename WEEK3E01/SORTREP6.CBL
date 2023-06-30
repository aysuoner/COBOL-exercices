      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
       PROGRAM-ID.    SORTREP6.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  25/06/2023.
       DATE-COMPILED. 30/06/2023.
      *------------------------------
       ENVIRONMENT DIVISION.
      *------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE   ASSIGN TO  IDXFILE
                             ORGANIZATION INDEXED
                             ACCESS     RANDOM
                             RECORD KEY IDX-KEY
                             STATUS     IDX-ST.
           SELECT INP-FILE   ASSIGN TO  INPFILE
                             STATUS     INP-ST.
           SELECT PRINT-LINE ASSIGN TO  PRTLINE
                             STATUS     PRT-ST.
      *------------------------------
        DATA DIVISION.
      *------------------------------
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05 PRINT-ID       PIC 9(05).
           05 SPACE-X1       PIC X(02).
           05 PRINT-DVZ      PIC 9(03).
           05 SPACE-X2       PIC X(02).
           05 PRINT-FULLN    PIC X(30).
           05 PRINT-BRTHDAY  PIC 9(08).
           05 SPACE-X3       PIC X(02).
           05 PRINT-TUTAR    PIC 9(13)V99.
      *****
       FD  IDX-FILE.
       01  IDX-REC.
           05 IDX-KEY.
              10  IDX-ID    PIC 9(05) COMP-3.
              10  IDX-DVZ   PIC 9(03) COMP.
           05 IDX-FULLN     PIC X(30).
           05 IDX-JUL       PIC 9(07) COMP-3.
           05 IDX-TUTAR     PIC 9(13)V99 COMP-3.
      *****
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
           05 INP-ID        PIC 9(05) COMP-3.
           05 INP-DVZ       PIC 9(03) COMP.
      *****
       WORKING-STORAGE SECTION.
       01  EXIT-FLAG            PIC X(01) VALUE 'N'.
       01  FILE-FLAGS.
           05 PRT-ST            PIC 9(02).
              88 PRT-SUCCESS    VALUE 00 97.
           05 INP-ST            PIC 9(02).
              88 INP-EOF        VALUE 10.
              88 INP-SUCCESS    VALUE 00 97.
           05 IDX-ST            PIC 9(02).
              88 IDX-SUCCESS    VALUE 00 97.
       01  WS-DATE.
           05 WS-GR-DATE       PIC 9(08) COMP-3.
           05 WS-INT-DATE      PIC 9(07) COMP-3.
      *------------------------------
        PROCEDURE DIVISION.
      *------------------------------
       FILE-OPEN.
           OPEN INPUT IDX-FILE
           OPEN INPUT INP-FILE
           OPEN OUTPUT PRINT-LINE.
       FILE-OPEN-END. EXIT.
      *-------
       FILE-OPEN-CONTROL.
           IF (NOT PRT-SUCCESS OR NOT INP-SUCCESS OR NOT IDX-SUCCESS)
             DISPLAY 'FILE CANNOT OPEN'
             DISPLAY 'PRT-ST: ' PRT-ST
             DISPLAY 'INP-ST: ' INP-ST
             DISPLAY 'IDX-ST: ' IDX-ST
             MOVE 'Y' TO EXIT-FLAG
             MOVE 99 TO RETURN-CODE
             PERFORM PROGRAM-EXIT
           END-IF.
       FILE-OPEN-CONTROL-END. EXIT.
      *-------
       READ-NEXT-RECORD.
           PERFORM READ-INP-ASSING-KEY
           PERFORM UNTIL INP-EOF
              PERFORM READ-IDX-FIND-KEY
              PERFORM READ-INP-ASSING-KEY
           END-PERFORM
           MOVE 'Y' TO EXIT-FLAG
           MOVE 00 TO RETURN-CODE
           PERFORM PROGRAM-EXIT.
       READ-NEXT-RECORD-END. EXIT.
      *----
       READ-INP-ASSING-KEY.
           READ INP-FILE
           MOVE INP-ID  TO IDX-ID
           MOVE INP-DVZ TO IDX-DVZ
           MOVE INP-REC TO IDX-KEY.
       READ-INP-ASSING-KEY-END. EXIT.
      *----
       READ-IDX-FIND-KEY.
           READ IDX-FILE KEY IS IDX-KEY
              INVALID KEY
                 DISPLAY "Record Undefined: " INP-ID INP-DVZ
              NOT INVALID KEY
                 PERFORM WRITE-RECORD.
       READ-IDX-FIND-KEY-END. EXIT.
      *----
       WRITE-RECORD.
           COMPUTE WS-INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-JUL)
           COMPUTE WS-GR-DATE = FUNCTION DATE-OF-INTEGER(WS-INT-DATE)
           MOVE IDX-ID       TO PRINT-ID
           MOVE IDX-DVZ      TO PRINT-DVZ
           MOVE IDX-FULLN    TO PRINT-FULLN
           MOVE IDX-TUTAR    TO PRINT-TUTAR
           MOVE WS-GR-DATE   TO PRINT-BRTHDAY
           MOVE SPACES       TO SPACE-X1
           MOVE SPACES       TO SPACE-X2
           MOVE SPACES       TO SPACE-X3
           WRITE PRINT-REC
           INITIALIZE PRINT-REC.
       WRITE-RECORD-EXIT. EXIT.
      *----
       PROGRAM-EXIT.
           IF EXIT-FLAG = 'Y' THEN
               CLOSE IDX-FILE
               CLOSE INP-FILE
               CLOSE PRINT-LINE
               STOP RUN
           END-IF.
      *----
