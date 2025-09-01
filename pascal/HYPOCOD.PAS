PROGRAM HYPOCOD;

USES DOS, CLASTABL, NOUNTHRU;

  VAR
    P, Q, L : INTEGER;
    LINENUM : INTEGER;
    GCOUNT, HCOUNT, COUNT : INTEGER;
    INP, OUT, OUT1 : TEXT;
    LINE, HEADER, HEADER0, TAIL, NOUN, TMP, TMP1 : STR115;
    NUM0 : NUMBER;
    GND0 : GENDER;
    NOMH, NOM : CHAR;
    CLS1, CLS2 : INTEGER;
    ST, STG : STAGE;
    STAG_CNT : ARRAY [STAGE] OF INTEGER;
    DOWN : BOOLEAN;
  CONST
    TAB = #009;
    STAG_NAME : ARRAY [STAGE] OF STR6 = 
    ('UNRZD ','BASIC ','VLONG ','SINGLE','HYPHD ', 
     'DBLZR ','ZPRT2 ','NZPRT2','CONJD ');

BEGIN      (* MAIN *)
  GLOBAL_INIT;

  HEADER := DUMMY;
  GCOUNT := 0;
  HCOUNT := 0;

  ASSIGN (OUT, 'HYPONYM.COD');
  REWRITE (OUT);

  ASSIGN (OUT1, 'MAGN_1.DAT');
  REWRITE (OUT1);

  ASSIGN (INP, 'HYPONYM.TXT');
  RESET (INP);

  LINENUM := 0;
  FOR ST := UNRZD TO CONJD DO
    STAG_CNT [ST] := 0;

  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);
    IF (LINE [LENGTH(LINE)] = BL) OR (POS(TAB,LINE) > 0)
      THEN
        BEGIN
          WRITELN ('ERROR: Wrong blank(s) in line ', LINENUM);
          HALT;
        END;
    NOM := BL;

         { Line forming }
    IF (LINE [1] <> BL)
      THEN
        BEGIN
          INC (GCOUNT);
          COUNT := 0;
          Q := POS (LINE [LENGTH(LINE)], '123456');
          IF Q > 0
            THEN
              BEGIN
                HEADER := COPY (LINE, 1, LENGTH(LINE)-1);
                NOM := LINE [LENGTH(LINE)];
                NOMH := NOM;
              END
            ELSE
              BEGIN
                HEADER := LINE;
                NOMH := BL;
              END;
          HEADER0 := HEADER;
          DOWN := FALSE;
          TAIL := LINE;
        END
      ELSE
        BEGIN
          INC (HCOUNT);
          DOWN := TRUE;
          L := LENGTH(LINE);
          Q := POS (LINE [L], '123456');
          IF Q > 0
            THEN TAIL := LINE
            ELSE
              BEGIN
                P := POS ('~', LINE);
                IF P > 0
                  THEN
                    BEGIN
                      INC (COUNT);
                      IF COUNT = 1
                        THEN
                          IF NOMH <> BL
                            THEN WRITELN (OUT1, HEADER, NOMH)
                            ELSE WRITELN (OUT1, HEADER);
                      TMP := COPY (LINE, 1, P - 2);
                      TMP[2] := '&';
                      TMP1 := COPY (LINE, 3, P - 6);
                      IF (TMP1 = '…‹') OR (TMP1 = 'Ž…‚') 
                        OR (TMP1 = '“Œ€†') OR (TMP1 = 'ƒ€‡Ž‚')
                        OR (TMP1 = 'ƒŽ‹Ž‚') OR (TMP1 = '„“˜…‚') 
                        OR (TMP1 = '†…‹…‡') OR (TMP1 = '†…‹’') 
                        OR (TMP1 = '‡…‹…') 
                        OR (TMP1 = 'Š€‘') OR (TMP1 = 'Š…ŒŽ‚')
                        OR (TMP1 = 'Šˆ‚') OR (TMP1 = '‹…ƒŠ') 
                        OR (TMP1 = '‹ˆŽ‚') OR (TMP1 = 'Œ…‹Š') 
                        OR (TMP1 = 'Œ…’ˆ—…‘Š') OR (TMP1 = '€’“€‹œ')
                        OR (TMP1 = 'ŸŒ') OR (TMP1 = '‘€‹€’') 
                        OR (TMP1 = '‘€‹œ') OR (TMP1 = '‘…')
                        OR (TMP1 = '‘“•') OR (TMP1 = '’…’') 
                        OR (TMP1 = '’…Œ') OR (TMP1 = '’Ž‹‘’') 
                        OR (TMP1 = '’ŽŠ') OR (TMP1 = '’…•ˆ—…‘Š') 
                        OR (TMP1 = '’Ÿ†…‹') OR (TMP1 = '’…€’€‹œ') 
                        OR (TMP1 = '“ƒŽ‹œ')
                        OR (TMP1 = '—…') OR (TMP1 = '…‘’…‘’‚…') 
                        THEN WRITELN (OUT1, TMP, '1')
                      ELSE IF (TMP1 = 'ŸŒ')
                        THEN
                          IF HEADER = '€„…†'
                            THEN WRITELN (OUT1, TMP, '2')
                            ELSE WRITELN (OUT1, TMP, '1')
                      ELSE IF (TMP1 = '‡€™ˆ’') OR (TMP1 = '‡Ž‹Ž’') 
                        OR (TMP1 = 'Š…ŒŽ‚') OR (TMP1 = 'Ž’ˆ–€’…‹œ') 
                        OR (TMP1 = 'Ž‹Ž‚') OR (TMP1 = 'Ž‹Ž†ˆ’…‹œ') 
                        OR (TMP1 = 'Ž‘’') OR (TMP1 = '…˜€ž™') 
                        OR (TMP1 = '‘…„…—') OR (TMP1 = '‘‹Ž†')
                        OR (TMP1 = '‘›') OR (TMP1 = '—€‘Ž‚') 
                        THEN WRITELN (OUT1, TMP, '2')
                      ELSE IF (TMP1 = 'Š…Š') OR (TMP1 = '•Ž‹Ž„') 
                        OR (TMP1 = '’‚…„')
                        THEN WRITELN (OUT1, TMP, '3')
                      ELSE IF (TMP1 = '‘’€˜')
                        THEN
                          IF (HEADER = '‚Ž‡€‘’')
                            THEN WRITELN (OUT1, TMP, '2')
                            ELSE WRITELN (OUT1, TMP, '1')
                      ELSE IF (TMP1 = '‡Ž‹Ž’') 
                        THEN
                          IF (HEADER = '‚Ž‡€‘’')
                            THEN WRITELN (OUT1, TMP, '3')
                            ELSE WRITELN (OUT1, TMP, '2')
                      ELSE IF (TMP1 = 'Ÿ‡›ŠŽ‚') AND (HEADER = 'ŠŽ‹€‘€')
                        THEN WRITELN (OUT1, ' &Ÿ‡›ŠŽ‚ Ÿ')
                      ELSE IF (TMP1 = '‹ˆ—') AND (HEADER = 'Ž’‚…’‘’‚…Ž‘’œ')
                        THEN WRITELN (OUT1, ' &‹ˆ— Ÿ')
                      ELSE IF (TMP1 = '‘Ž‹Ÿ') AND (HEADER = 'Šˆ‘‹Ž’€')
                        THEN WRITELN (OUT1, ' &‘Ž‹Ÿ Ÿ')
                      ELSE WRITELN (OUT1, TMP);
                      TAIL := COPY (LINE, 1 , P - 1) + HEADER;
                    END
                  ELSE TAIL := LINE;
              END;

          TAIL := COPY (TAIL, 3, LENGTH (TAIL) - 2);
        END;

        { TAIL classification }
    IF DOWN AND (HEADER0 = '‘‹Ž‚Ž_€€‡ˆ’')
      THEN
        BEGIN
          NOUN := TAIL; CLS1 := 0; CLS2 := 255;
        END
      ELSE PARSENOUN (TAIL, NOUN, CLS1, CLS2, NUM0, GND0, STG);
    INC (STAG_CNT [STG]);

        { Line output }
    IF LINE [1] <> BL
      THEN WRITELN (OUT, '+ 1', CLS1:4, CLS2:4, 
        ORD(NUM0):2, ORD(GND0):2, BL, NOUN)
      ELSE WRITELN (OUT, '- 1', CLS1:4, CLS2:4, 
        ORD(NUM0):2, ORD(GND0):2, BL, NOUN);

  UNTIL EOF (INP);

  FLUSH (OUT);
  FLUSH (OUT1);
  WRITELN ('FILES "HYPONYM.COD" AND "MAGN_1.DAT" ARE OUTPUT');

  WRITELN ('NUMBER OF HYPERONYMS = ', GCOUNT : 5);
  WRITELN ('  NUMBER OF HYPONYMS = ', HCOUNT);
  WRITELN ('   MEAN GROUP LENGTH = ', HCOUNT / GCOUNT : 5 : 2);
  WRITELN ('   TOTAL LINK NUMBER = ', HCOUNT * 2);

 { WRITELN (' == NOUNS FOUND IN: ');
  FOR STG := UNRZD TO CONJD DO
    IF STAG_CNT [STG] > 0
      THEN WRITELN (BL : 4, STAG_NAME[STG] : 6, 
        ' = ', STAG_CNT [STG] : 6);}
END.
