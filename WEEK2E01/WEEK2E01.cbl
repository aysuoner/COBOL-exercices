      *------------------------------
       IDENTIFICATION DIVISION.
      *------------------------------
       PROGRAM-ID.    BDAYCALC.
       AUTHOR.        AYSU ONER.
       DATE-WRITTEN.  20/06/2023.
       DATE-COMPILED. 21/06/2023.
      *------------------------------
       ENVIRONMENT DIVISION.
      *------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE
                             STATUS    PRT-ST.
           SELECT ACCT-REC   ASSIGN TO ACCTREC
                             STATUS    ACCT-ST.
      *------------------------------
        DATA DIVISION.
      *------------------------------
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  PRINT-SEQ       PIC X(04).
           05  PRINT-NAME      PIC X(16).
           05  PRINT-LASTN     PIC X(15).
           05  PRINT-BRTHDAY   PIC 9(08).
           05  PRINT-TODAY     PIC 9(08).
           05  PRINT-FARK      PIC 9(08).
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05  ACCT-SEQ        PIC X(04).
           05  ACCT-NAME       PIC X(16).
           05  ACCT-LASTN      PIC X(15).
           05  ACCT-BRTHDAY    PIC 9(07).
           05  ACCT-TODAY      PIC 9(08).
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05 PRT-ST           PIC 9(02).
              88 PRT-SUCCESS   VALUE 00 97.
           05 ACCT-ST          PIC 9(02).
              88 ACCT-EOF      VALUE 10.
              88 ACCT-SUCCESS  VALUE 00 97.
           05 WS-INT-D         PIC 9(08).
           05 WS-INT-T         PIC 9(08).
      *------------------------------
        PROCEDURE DIVISION.
      *------------------------------
       0000-MAIN.
           PERFORM H100-OPEN-FILES.
           PERFORM H200-PROCESS UNTIL ACCT-EOF.
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
           READ        ACCT-REC.
       H100-END. EXIT.

       H200-PROCESS.
           COMPUTE WS-INT-D = FUNCTION INTEGER-OF-DAY(ACCT-BRTHDAY)
           COMPUTE WS-INT-T = FUNCTION INTEGER-OF-DATE(ACCT-TODAY)
           INITIALIZE PRINT-REC
            MOVE ACCT-SEQ       TO PRINT-SEQ
            MOVE ACCT-NAME      TO PRINT-NAME
            MOVE ACCT-LASTN     TO PRINT-LASTN
            MOVE ACCT-BRTHDAY     TO PRINT-BRTHDAY
            MOVE ACCT-TODAY     TO PRINT-TODAY
            COMPUTE PRINT-FARK = WS-INT-T - WS-INT-D
            WRITE PRINT-REC.
            READ ACCT-REC.
       H200-END. EXIT.
	
       H300-CLOSE-FILES.
           CLOSE ACCT-REC
                 PRINT-LINE.
       H300-END. EXIT.
	
       H999-PROGRAM-EXIT.
           PERFORM H300-CLOSE-FILES.
           STOP RUN.
       H999-END. EXIT.
