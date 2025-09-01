PROGRAM TOTREES2;

  CONST
    BL = ' ';
    DUMMY = '';
    PS = '1';
  VAR
    N, COUNTH, COUNTT : LONGINT;
    INP , OUT, OUT1 : TEXT;    
    LINE, HEAD0, HEAD, TAIL : STRING [160];

BEGIN
  ASSIGN (INP, 'HYPAIRS2.TXT');
  RESET (INP);
  WRITELN ('  File HYPAIRS2.TXT being processed');
 
  ASSIGN (OUT, 'COHYPS.TXT');
  REWRITE (OUT);
  ASSIGN (OUT1, 'COBUSH2.TXT');
  REWRITE (OUT1);
  COUNTH := 0;
  COUNTT := 0;
  HEAD0 := DUMMY;

  REPEAT
    READLN (INP, LINE);
    N := POS (BL+PS+BL, LINE);
    HEAD := COPY (LINE, 1, N-1);
    IF HEAD <> HEAD0
      THEN
        BEGIN
          WRITELN (OUT, '+ '+PS+BL, HEAD);
          WRITELN (OUT1, HEAD);
          INC (COUNTH);
          HEAD0 := HEAD;
        END;
    TAIL := COPY (LINE, N+3, LENGTH(LINE)-N-2);
    WRITELN (OUT, '- ' + PS + BL, TAIL);
    WRITELN (OUT1, BL+BL, TAIL);
    INC (COUNTT);
  UNTIL EOF (INP);
  FLUSH (OUT);
  FLUSH (OUT1);

  WRITELN ('  Files ', 'COHYPS.TXT and COBUSH2.TXT contain:');
  WRITELN (COUNTH:6, ' head vocables');
  WRITELN (COUNTT:6, ' cohyps');
  WRITELN (COUNTT/COUNTH:6:2, ' cohyps/head');
END.
