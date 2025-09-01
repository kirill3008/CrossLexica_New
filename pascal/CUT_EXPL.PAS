PROGRAM CUT_EXPL;
VAR
  INP, OUT : TEXT;
  LINE, PREV, POST : STRING [115];
  P : LONGINT;

BEGIN
  ASSIGN (INP, 'BASIC0.LST');
  RESET (INP);

  ASSIGN (OUT, 'BASICS.LST');
  REWRITE (OUT);
  PREV := '';

  REPEAT
    READLN (INP, LINE);
    P := POS ('<', LINE);
    IF P > 0
      THEN LINE := COPY(LINE,1,P-1);
    IF LINE = PREV
      THEN
        BEGIN
          WRITELN ('Repeated: ', LINE);
        END;
    PREV := LINE;
    WRITELN (OUT, LINE);
  UNTIL EOF (INP);
  FLUSH (OUT);
  WRITELN ('BASICS.LST IS READY');
END.