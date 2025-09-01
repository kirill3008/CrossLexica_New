PROGRAM STATSUB3;
  CONST
    BL = ' ';
  {TYPE
    NAMETYPE = STRING [33];}
  VAR
    FNAME : STRING [12];
    J, P : INTEGER;
    PARTAMT : INTEGER;
    LINE, HEADER : STRING [95];
    INP, OUT : TEXT;
    COUNT, TOTCOUNT : LONGINT;
    {TOKEN : NAMETYPE;}

BEGIN
  ASSIGN (OUT, 'SUBSTAT3.STS');
  REWRITE (OUT);
  COUNT := 0;
  TOTCOUNT := 0;

  FOR J := 0 TO 88 DO
    BEGIN
      FNAME := 'MAGN' + CHR (ORD ('0') + J DIV 10) +
        CHR (ORD ('0') + J MOD 10) + '.COD';
      WRITELN ('  FILE ', FNAME, ' BEING PROCESSED');
      ASSIGN (INP, FNAME);
      RESET (INP);
      PARTAMT := 0;
      HEADER := '';

      REPEAT
        READLN (INP, LINE);
        IF COPY (LINE, 1, 3) = '+ 1'
          THEN
            BEGIN
              INC (COUNT);
              IF PARTAMT > 0
                THEN
                  BEGIN
                    WRITELN (OUT, PARTAMT : 4, BL, HEADER);
                    TOTCOUNT := TOTCOUNT + PARTAMT;
                    PARTAMT := 0;
                  END;
              HEADER := COPY (LINE, 17, LENGTH (LINE) - 16);
              P := POS ('<', HEADER);
              IF P > 0
                THEN HEADER := COPY (HEADER, 1, P - 1);
            END
        ELSE IF (COPY (LINE, 1, 3) = '- 3')
          AND (COPY (LINE, 15, LENGTH (LINE) - 14) <> '‘€Œ›‰')
          THEN
            BEGIN
              INC (PARTAMT);
              IF EOF (INP)
                THEN
                  BEGIN
                    WRITELN (OUT, PARTAMT : 4, BL, HEADER);
                    TOTCOUNT := TOTCOUNT + PARTAMT;
                    PARTAMT := 0;
                  END;
           END;
      UNTIL EOF (INP);
      CLOSE (INP);
  END;

  FLUSH (OUT);
  WRITELN (COUNT, ' NOUNS IN SUBSTAT3.STS');
  WRITELN (TOTCOUNT, ' COLLOCATIONS TOTALLY');
  WRITELN (TOTCOUNT / COUNT : 5 : 2, ' ADJS/NOUN');
END.
