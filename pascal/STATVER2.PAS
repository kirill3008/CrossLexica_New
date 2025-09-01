PROGRAM STATVER2;
  CONST
    BL           = ' ';
    BufSize      = 100;
    NameTypeSize = 60;
  TYPE
    NAMETYPE = STRING [NameTypeSize];
    REF = ^NODE;
    NODE =
      RECORD
        CNT : INTEGER;
        KEY : NAMETYPE;
        LEFT, RIGHT : REF;
      END;
  VAR
    LINE : STRING [BufSize];
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

  WRITELN ('  FILE SUBJS.COD BEING PROCESSED');
  ASSIGN (INP, 'SUBJS.COD');
  RESET (INP);

  REPEAT
    READLN (INP, LINE);

    if (LENGTH (LINE) > BufSize)
      then
        begin
          writeln ('ERROR: Too long input line <', LINE, '>');
          halt;
        end;
    if (LENGTH (LINE) - 18 < 1)
      then
        begin
          writeln ('ERROR: Too short input line <', LINE, '>');
          halt;
        end;
    if (LENGTH (LINE) - 18 > NameTypeSize)
      then
        begin
          writeln ('ERROR: Too long token in input line ', LINE);
          halt;
        end;

    IF (LINE [1] = '-') AND (LINE [9] = '2')
      THEN
        BEGIN
          TOKEN := COPY (LINE, 18 + 1, LENGTH (LINE) - 18);
          ALLOC_IN_TREE (TOKEN, ROOT);
        END;
  UNTIL EOF (INP);

  ASSIGN (OUT, 'VERSTAT2.STS');
  REWRITE (OUT);
  PRINTTREE (ROOT);
  FLUSH (OUT);
  WRITELN (COUNT : 5, ' VERBS IN VERSTAT2.STS');
END.
