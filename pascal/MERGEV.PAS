PROGRAM MERGEV;

TYPE
  RESTYPE = (LT,EQ,GT);
VAR
  LINE1, LINE2, TOK1, TOK2 : STRING [80];
  INP1, INP2, OUT : TEXT;
  COUNT : INTEGER;
  RES : RESTYPE;

PROCEDURE COMPARE_TOK (TOK1,TOK2 : STRING;
        (*===========*)VAR RESULT : RESTYPE);
BEGIN
  IF TOK1 < TOK2
    THEN RESULT:=LT
    ELSE
      IF TOK1 > TOK2
        THEN RESULT:=GT
        ELSE RESULT:=EQ;
END;

BEGIN
  ASSIGN (INP1, 'VERSTAT.STS');
  RESET (INP1);
  ASSIGN (INP2, 'VERSTAT2.STS');
  RESET (INP2);
  ASSIGN (OUT, 'BASICSV.LST');
  REWRITE (OUT);

  COUNT := 0;

  READLN (INP1, LINE1);
  TOK1 := COPY (LINE1, 6, LENGTH(LINE1)-5);
  READLN (INP2, LINE2);
  TOK2 := COPY (LINE2, 6, LENGTH(LINE2)-5);

  REPEAT
    COMPARE_TOK (TOK1, TOK2, RES);
    CASE RES OF
      LT: 
        BEGIN
          WRITELN (OUT, TOK1);
          INC (COUNT);
          IF NOT EOF(INP1)
           THEN 
             BEGIN
               READLN (INP1, LINE1);
               TOK1 := COPY (LINE1, 6, LENGTH(LINE1)-5);
             END;
        END;
      EQ: 
        BEGIN
          WRITELN (OUT, TOK1);
          INC (COUNT);
          IF NOT EOF(INP1)
            THEN 
              BEGIN
                READLN (INP1, LINE1);
                TOK1 := COPY (LINE1, 6, LENGTH(LINE1)-5);
              END;
          IF NOT EOF(INP2)
           THEN 
             BEGIN
               READLN (INP2, LINE2);
               TOK2 := COPY (LINE2, 6, LENGTH(LINE2)-5);
             END;
        END;
      GT: 
        BEGIN
          WRITELN (OUT, TOK2);
          INC (COUNT);
          IF NOT EOF(INP2)
           THEN 
             BEGIN
               READLN (INP2, LINE2);
               TOK2 := COPY (LINE2, 6, LENGTH(LINE2)-5);
             END;
        END;
    END;
  UNTIL EOF(INP1) AND EOF(INP2);
  FLUSH (OUT);
  WRITELN (COUNT, ' VERBS IN BASICSV.LST');
END.
