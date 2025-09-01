PROGRAM NAMESAP;

USES DOS, CLASTABL;

  TYPE
    STR5 = STRING [5];

  CONST
    BL = ' ';
    US = '_';
    HY = '-';
    QU = '"';
    BIB = ' ˆ ';

  VAR
    INP, OUT : TEXT;
    LINE, TOKH, TOK1, TOK2 : STR115;
    L, PU, PB, PI : INTEGER;
    LINENUM, HNUM, NNUM : INTEGER;
    CLASH1, CLASH2, CLAS1, CLAS2 : INTEGER;
    VALH, VAL1, VAL2 : BOOLEAN;
    ANMH, ANM1, ANM2 : ANIMA;
    GNDH, GND1, GND2 : GENDER;
    NUMH, NUM1, NUM2 : NUMBER;


BEGIN      (* MAIN *)
  ASSIGN (INP, 'NAMESAP.TXT');
  RESET (INP);
  WRITELN ('NAMESAP.TXT BEING PROCESSED');

  ASSIGN (OUT, 'NAMESAP.COD');
  REWRITE (OUT);

  LINENUM := 0;
  HNUM := 0;
  NNUM := 0;

  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);

    WHILE (LINE [LENGTH(LINE)] = BL) DO
      BEGIN
        WRITELN (' ERROR: UNNECESSARY FINAL BLANK IN LINE ',
          LINENUM);
        LINE := COPY (LINE, 1, LENGTH(LINE)-1);
      END;

    IF LINE[1] <> BL
      THEN  (* ‡€ƒŽ‹Ž‚ŽŠ *)
        BEGIN
          INC (HNUM);
          PB := POS (BL, LINE);
          IF PB = 0
            THEN
              BEGIN
                L := LENGTH (LINE);
                IF POS (LINE[L], '123456') > 0
                  THEN TOKH := COPY (LINE, 1, L-1)
                  ELSE TOKH := LINE;
                INITSUBCL (TOKH, CLASH1, VALH, NUMH, GNDH, ANMH);
                CLASH2 := 255;
              END
            ELSE
              BEGIN
                TOK1 := COPY (LINE, 1, PB-1);
                TOK2 := COPY (LINE, PB+1, L-PB);
                INITSUBCL (TOK1, CLASH1, VALH, NUMH, GNDH, ANMH);
                IF (TOK2 = 'Œ…‘Ÿ–')
                  THEN INITSUBCL (TOK2, CLASH2, VALH, NUMH, GNDH, ANMH)
                  ELSE CLASH2 := 0;                  
              END;
          WRITELN (OUT, '+ 1', CLASH1 : 4, CLASH2 : 4, BL, ORD(NUMH),
            BL, ORD(GNDH), BL, LINE);
        END
      ELSE (* Ž—……„Ž… €‡‚€ˆ… *)
        BEGIN
          INC (NNUM);
          LINE := COPY (LINE, 3, LENGTH(LINE)-2);
          L := LENGTH (LINE);
          IF LINE[1] = QU
            THEN
              BEGIN
                CLAS1 := 0;
                CLAS2 := 255;
                NUM1 := NUMH;
                GND1 := GNDH;
              END
          ELSE
            BEGIN
              PU := POS (US, LINE);
              IF PU > 0
                THEN
                  BEGIN
                    TOK1 := COPY (LINE, 1, PU-1);
                    TOK2 := COPY (LINE, PU+1, L-PU);
                    INITSUBCL (TOK1, CLAS1, VAL1, NUM1, GND1, ANM1);
                    INITSUBCL (TOK2, CLAS2, VAL2, NUM2, GND2, ANM2);
                    LINE[PU] := HY;
                 END
              ELSE
                BEGIN
                  PI := POS (BIB, LINE);
                  IF PI > 0
                    THEN
                      BEGIN
                        TOK1 := COPY (LINE, 1, PI-1);
                        TOK2 := COPY (LINE, PI+3, L-PI-2);
                        INITSUBCL (TOK1, CLAS1, VAL1, NUM1, GND1, ANM1);
                        INITSUBCL (TOK2, CLAS2, VAL2, NUM2, GND2, ANM2);
                      END
                   ELSE
                     BEGIN
                       PB := POS (BL, LINE);
                       IF PB > 0
                         THEN
                           BEGIN
                             TOK1 := COPY (LINE, 1, PB-1);
                             TOK2 := COPY (LINE, PB+1, L-PI);
                             INITSUBCL (TOK1, CLAS1, VAL1, NUM1, GND1, ANM1);
                             INITSUBCL (TOK2, CLAS2, VAL2, NUM2, GND2, ANM2);
                           END
                        ELSE
                          BEGIN
                            L := LENGTH (LINE);
                            IF POS (LINE[L], '123456') > 0
                              THEN TOK1 := COPY (LINE, 1, L-1)
                              ELSE TOK1 := LINE;
                            INITSUBCL (TOK1, CLAS1, VAL1, NUM1, GND1, ANM1);
                            CLAS2 := 255;
                          END
                     END;
                END;
            END;
          WRITELN (OUT, '- 1', CLAS1 : 4, CLAS2 : 4, BL, ORD(NUM1),
            BL, ORD(GND1), BL, LINE); 
        END;
  UNTIL EOF (INP);

  CLOSE (INP);
  FLUSH (OUT);

  WRITELN ('FILE NAMESAP.COD OUTPUT');
  WRITELN ('NUMBER OF HEADS  = ', HNUM:4);
  WRITELN ('NUMBER OF COLOCS = ', NNUM:4);
  WRITELN ('MEAN COLOCS/HEAD = ', NNUM/HNUM:4:1);
END.