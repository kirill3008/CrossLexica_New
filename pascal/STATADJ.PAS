PROGRAM STATADJ;
  CONST
    BL = ' ';
  TYPE
    NAMETYPE = STRING [50];
    REF = ^NODE;
    NODE =
      RECORD
        CNT : LONGINT;
        KEY : NAMETYPE;
        LEFT, RIGHT : REF;
      END;
  VAR
    FNAME : STRING [12];
    LINE : STRING [72];
    INP, OUT : TEXT;
    ROOT : REF;
    COUNT, TOTCOUNT, J, NUM_IN_FILE : LONGINT;
    TOKEN : NAMETYPE;

  PROCEDURE ALLOC_IN_TREE (TOKEN : NAMETYPE;
                           VAR CURROOT : REF);
  BEGIN
    IF CURROOT = NIL
      THEN
        BEGIN
          NEW (CURROOT);
          WITH CURROOT^ DO
            BEGIN
              KEY := TOKEN;
              CNT := 1;
              LEFT := NIL;
              RIGHT := NIL;
            END;
        END
      ELSE WITH CURROOT^ DO
        IF TOKEN = KEY
          THEN INC (CNT)
        ELSE IF TOKEN < KEY
          THEN ALLOC_IN_TREE (TOKEN, LEFT)
          ELSE ALLOC_IN_TREE (TOKEN, RIGHT);
  END;


  PROCEDURE PRINTTREE (T : REF);
  BEGIN
    IF T <> NIL
      THEN WITH T^ DO
        BEGIN
          PRINTTREE (LEFT);
          INC (COUNT);
          TOTCOUNT := TOTCOUNT + CNT;
          WRITELN (OUT, CNT : 4, BL, KEY);
          PRINTTREE (RIGHT);
        END;
  END;

BEGIN
  ROOT := NIL;
  COUNT := 0;
  TOTCOUNT := 0;
  ASSIGN (OUT, 'ADJSTAT.STS');
  REWRITE (OUT);

  FOR J := {-1} 0 TO 88 DO
    BEGIN
      {IF J = -1
        THEN FNAME := 'MAGN_1.COD'
        ELSE}
      FNAME := 'MAGN' + CHR (ORD ('0') + J DIV 10) +
          CHR (ORD ('0') + J MOD 10) + '.COD';
      WRITELN ('FILE ', FNAME, ' PROCESSED');
      ASSIGN (INP, FNAME);
      RESET (INP);
      NUM_IN_FILE := 0;

      REPEAT
        READLN (INP, LINE);
        TOKEN := COPY (LINE, 15, LENGTH (LINE) - {12}14);
        IF (TOKEN = '') OR (TOKEN = '  ')
          THEN
            BEGIN
              WRITELN (FNAME, 'ENPTY TOKEN AT ', NUM_IN_FILE);
              HALT;
            END;
        IF (LINE [3] = '3') AND (LINE [1] <> '+') {AND SUITED}
          THEN ALLOC_IN_TREE (TOKEN, ROOT);
      UNTIL EOF (INP);
      CLOSE (INP);
    END;

  PRINTTREE (ROOT);

  FLUSH (OUT);
  WRITELN (BL, COUNT, ' ADJECTIVES IN ADJSTAT.TST');
  WRITELN (TOTCOUNT, ' COLLOCATIONS TOTAL');
  WRITELN (BL, TOTCOUNT / COUNT : 5 : 2, ' NOUNS/ADJ');
END.
