PROGRAM GETSHORT;

USES DOS;

  TYPE
    STR21 = STRING [21];
    STR115 = STRING [115];
    RESTYPE = (LT, EQ, GT);

  CONST
    BL = ' ';
    MAXSHORT = 6900;

  VAR
    XL_DAS : STRING [255];
    INP, OUT : TEXT;
    I, CURSHORT : INTEGER;
    HCOUNT, ACOUNT : LONGINT;
    FNAME : STRING [12];
    LINE, LINE0, HEADER, HEADER0, TOKEN : STR115;
    HEADER_FL : BOOLEAN;
    SHORTADJS : ARRAY [1..MAXSHORT] OF STR21;
    CLASSTR : STRING [3];
    P : INTEGER;
    GENDCH : CHAR;


  PROCEDURE COMPARE_TOK (TOK1, TOK2 : STRING;
          (*===========*)VAR RESULT : RESTYPE);
  BEGIN
    IF TOK1 < TOK2
      THEN RESULT := LT
      ELSE
        IF TOK1 > TOK2
          THEN RESULT := GT
          ELSE RESULT := EQ;
  END;


   FUNCTION IS_SHORT (TOKEN : STR21) : BOOLEAN;
          (*========*)
     VAR
       I, LOW, HIGH, MID : WORD;
       FOUND : BOOLEAN;
       RES : RESTYPE;

   BEGIN
     LOW := 1;
     HIGH := CURSHORT;
     FOUND := FALSE;

     WHILE (HIGH >= LOW) AND NOT FOUND DO
       BEGIN
         MID := (HIGH + LOW) DIV 2;
         COMPARE_TOK (TOKEN, SHORTADJS [MID], RES);
         CASE RES OF
           LT : HIGH := MID - 1;
           EQ : FOUND := TRUE;
           GT : LOW := MID + 1;
         END;
       END;
     IS_SHORT := FOUND;
   END;

BEGIN

  ASSIGN (INP, 'SHORTADJ.COD');
  RESET (INP);
  CURSHORT := 0;
  REPEAT
    INC (CURSHORT);
    READLN (INP, LINE0);
    SHORTADJS [CURSHORT] := COPY (LINE0, 14, LENGTH(LINE0)-13);
  UNTIL EOF (INP) OR (CURSHORT = MAXSHORT);
  CLOSE (INP);

  HCOUNT := 0;
  ACOUNT := 0;

  ASSIGN (OUT, 'SHORTS.COD');
  REWRITE (OUT);

  FOR I := 0 TO 88 DO
    BEGIN
      FNAME := 'MAGN' + CHR (ORD ('0') + I DIV 10) +
        CHR (ORD ('0') + I MOD 10) + '.COD';
      WRITELN ('  FILE ', I : 2, ' BEING PROCESSED');
      ASSIGN (INP, FNAME);
      RESET (INP);

      REPEAT
        READLN (INP, LINE);
        WHILE (COPY (LINE, 1, 3 ) <> '+ 1') AND NOT EOF (INP) DO
          READLN (INP, LINE);

        HEADER := COPY (LINE, 17, LENGTH (LINE) - 16);
        P := POS ('<', HEADER);
        IF P > 0
          THEN HEADER := COPY (HEADER, 1, P - 1);
        GENDCH := HEADER [2];
        HEADER0 := COPY (HEADER, 4, LENGTH (HEADER) - 3);
        HEADER_FL := TRUE;
        READLN (INP, LINE);

        WHILE (LINE [1] <> '+') AND NOT EOF (INP) DO
          BEGIN
            TOKEN := COPY (LINE, 15, LENGTH (LINE) - 14); {?12}
            CLASSTR := COPY (LINE, 6, 2);
            IF (HEADER0 <> 'ÑÄ') AND (HEADER0 <> 'çÖí')
              AND (HEADER0 <> 'ëèÄëàÅé')
              AND IS_SHORT (TOKEN) AND (LINE [1] <> '\') AND (LINE [1] <> '/')
              AND ((GENDCH <> '3')
              OR (TOKEN <> 'ïéêéòàâ') AND (TOKEN <> 'èãéïéâ')
              AND (TOKEN <> 'èéãçõâ1')
              AND (TOKEN <> 'íêìÑçõâ') AND (TOKEN <> 'íüÜÖãõâ'))
              THEN
                BEGIN
                  IF HEADER_FL
                    THEN
                      BEGIN
                        INC (HCOUNT);
                        WRITELN (OUT, {'+', 1:2, HCOUNT+1:6, 
                          BL,} HEADER); (* DM *)
                        HEADER_FL := FALSE;
                      END;
                  INC (ACOUNT);
                  WRITELN (OUT, {'-', 3:2, HCOUNT+1:6,} 
                    BL, BL, TOKEN); (* DM *)
                END;
            READLN (INP, LINE);
          END;
      UNTIL EOF (INP);
      CLOSE (INP);
    END;
  FLUSH (OUT);

  WRITELN ('FILE SHORTS.COD OUTPUT WITH');
  WRITELN (HCOUNT : 6, ' NOUNS');
  WRITELN (ACOUNT : 6, ' ADJECTIVES');
END.
