PROGRAM STATVER;
  CONST
    BL = ' ';
  TYPE
    NAMETYPE = STRING [40];
    REF = ^NODE;
    NODE =
      RECORD
        CNT : INTEGER;
        KEY : NAMETYPE;
        LEFT, RIGHT : REF;
      END;
  VAR
    J, I : INTEGER;
    LINE : STRING [100];
    INP, OUT : TEXT;
    ROOT : REF;
    COUNT : LONGINT;
    TOKEN : NAMETYPE;

  PROCEDURE ALLOC_IN_TREE (TOKEN : NAMETYPE;
                           VAR CURROOT : REF);
    VAR
      NEWNODE : REF;
  BEGIN
    IF CURROOT = NIL
      THEN
        BEGIN
          NEW (NEWNODE);
          WITH NEWNODE^ DO
            BEGIN
              KEY := TOKEN;
              CNT := 1;
              LEFT := NIL;
              RIGHT := NIL;
            END;
          CURROOT := NEWNODE;
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
          WRITELN (OUT, CNT : 4, BL, KEY);
          PRINTTREE (RIGHT);
        END;
  END;

BEGIN
  ROOT := NIL;
  COUNT := 0;

  WRITELN ('  FILE OPFUNC.COD BEING PROCESSED');
  ASSIGN (INP, 'OPFUNC.COD');
  RESET (INP);

  REPEAT
    READLN (INP, LINE);
    TOKEN := COPY (LINE, 11, LENGTH (LINE) - 10);
    ALLOC_IN_TREE (TOKEN, ROOT);
  UNTIL EOF (INP);

  ASSIGN (OUT, 'VERSTAT.STS');
  REWRITE (OUT);
  PRINTTREE (ROOT);
  FLUSH (OUT);
  WRITELN (COUNT, ' VERBS IN VERSTAT.STS');
END.
