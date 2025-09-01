PROGRAM LONGCLAS;


USES DOS, CLASTABL;

  VAR XL_DAS : STRING [255];

  TYPE
    STR110 = STRING [110];

  CONST
    HYP = '-';
    BL = ' ';
    UP = '9';
    DUMMY = '';

  VAR
    INP, OUT, OUT1, OUT_A, OUT_G : TEXT;
    INDX : ARRAY [1..6] OF CHAR;
    SEPR : ARRAY [1..6] OF CHAR;
    CLSS : ARRAY [1..6] OF INTEGER;
    TOKEN : ARRAY [1..6] OF STR110;
    LINE, LINE1, TAIL : STR110;
    NUM : ARRAY [1..6] OF NUMBER;
    GND : ARRAY [1..6] OF GENDER; 
    NUMCH, GENCH, CH : CHAR;
    I, J, P, L, COUNT : INTEGER;
    ANCL, ANCL1, DEANCL : INTEGER;
    VAL : BOOLEAN;
    ANM : ANIMA;

  { CLASS is animable to ANIMCL }
  FUNCTION CAN_BE_ANIMATED (CLASS : INTEGER;
         (*===============*)VAR ANIMCL : INTEGER) : BOOLEAN;
    VAR
      LOW, HIGH, MID : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    ANIMCL := 0;
    LOW := 1;
    HIGH := MAXANIM;
    FOUND := FALSE;
    WHILE (HIGH >= LOW) AND NOT FOUND DO
      BEGIN
        MID := (HIGH + LOW) DIV 2;
        IF CLASS < FORANIM [MID].CL1
          THEN HIGH := MID - 1
        ELSE IF CLASS = FORANIM [MID].CL1
          THEN FOUND := TRUE
          ELSE LOW := MID + 1;
      END;
    CAN_BE_ANIMATED := FOUND;
    IF FOUND
      THEN ANIMCL := FORANIM [MID].CL2;
  END;

{ CLASS has its DEANIMCL analogue }
FUNCTION CAN_BE_DEANIMATED (CLASS : INTEGER;
        {=================} VAR DEANIMCL : INTEGER) : BOOLEAN;
VAR
  I : INTEGER;
  FOUND : BOOLEAN;
BEGIN
  DEANIMCL := CLASS;
  I := 0;
  FOUND := FALSE;
  REPEAT
    INC(I); 
    FOUND := (CLASS = FORANIM [I].CL2);
  UNTIL (I = MAXANIM) OR FOUND;
  CAN_BE_DEANIMATED := FOUND;
  IF FOUND
    THEN DEANIMCL := FORANIM [I].CL1;
END;

{ PART is animable noun }
FUNCTION ANIMABLE (PART : STR110) : BOOLEAN;
        {========}
CONST
  AMT2 = 58;
  FINS2 : ARRAY [1..AMT2] OF STRING [15] =
('€ƒ…’','€ƒ…’›',
'…„›…','…‹›…','…‘’Ž‹ŠŽ‚›…','‹ˆ‡Šˆ…','Žƒ€’›…',
  'Ž…‚ˆŠˆ','ŽŠ‘…','ŽŠ‘…›','Ž‹œ›…','›Šˆ',
'‚…„ŽŒ›‰','‚…„“™ˆ‰','‚ˆŽ‚€’›…','‚Ž…›…',
'ƒŽ‹Ž‚“˜Šˆ','ƒŽ‘“„€‘’‚…›…',
'„ˆ‹ŽŒ€’','„ˆ‹ŽŒ€’›','„Ž‡Ž›…','„“ƒŽ‰',
'†ˆ‚Ž’›…','‡‚…‡„›','‡€ŠŽŒ›…','ˆ‡‚…‘’›…','ˆŽ‰',
'Š€‡€Šˆ','ŠŽ›…','ŠŽ—…›†Šˆ','ŠŽ˜Šˆ','ŠŽ‘’“Š’Ž',
'‹ˆ–€','ŒŽ‹Ž„›…','…‡€ŠŽŒ›…','…‘Ž‘Ž›…',
'Ž™…‘’‚…›…','Ž…€’Ž','Ž…€’Ž›',
'Ž€Ž™…›…','Ž‚…†„…›…','Ž‚…†„…›‰',
  'Ž„Ž›…','…„…†€™ˆ…','Ž—ˆ…',
'…„€Š’Ž','Ž„›…',
'‘Œ…’›…','‘Œ…’›‰','‘“’ˆŠˆ','‘’€›…',
'’Ž‹ŠŽ‚›…','“Žƒˆ…','“ƒ…’…›…',
'—€‘Ž‚Ž‰','—‹…',
'˜ˆ˜Šˆ','˜’€’‘Šˆ…');
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  I := 0;
  FOUND := FALSE;
  REPEAT
    INC(I);
    FOUND := (PART = FINS2 [I])
  UNTIL FOUND OR (I = AMT2);
  ANIMABLE := FOUND;
END;

BEGIN
  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' THEN
    XL_DAS := '../DAS/';

  ASSIGN (INP, XL_DAS+'TOOLONG.DAS');
  RESET (INP);
  WRITELN ('  FILE ', 'TOOLONG.DAS', ' BEING PROCESSED');
 
  ASSIGN (OUT, 'TOOLONG.COD');
  REWRITE (OUT); 
  ASSIGN (OUT1, 'NTOOLONG.CPP');
  REWRITE (OUT1);
  ASSIGN (OUT_A, 'TLV_ACC.TXT');
  REWRITE (OUT_A);
  ASSIGN (OUT_G, 'TLV_GEN.TXT');
  REWRITE (OUT_G);
  COUNT := 0;

  WRITELN (OUT1, '// CrossLexica Version 2020');
  WRITELN (OUT1, '// List of superlong noun collocations');
  WRITELN (OUT1, '// with corresponding morpho-classes of their');
  WRITELN (OUT1, '// constituents and separators between thems');
  WRITELN (OUT1, 'NTLong =');
  WRITELN (OUT1, '{');

  REPEAT
    FOR I := 1 TO 6 DO
      CLSS [I] := 255;
    FOR I := 1 TO 6 DO
      TOKEN [I] := DUMMY;
    FOR I := 1 TO 6 DO
      NUM [I] := UNKN;
    FOR I := 1 TO 6 DO
      GND [I] := NONE;

    INC (COUNT);

    FOR I := 1 TO 6 DO
      BEGIN
        READ (INP, INDX[I], SEPR[I]);
        IF (INDX[I] <> '0') AND (INDX[I] <> '1') AND (INDX[I] <> UP)
          OR (I = 1) AND (INDX[I] = UP)
          OR (I > 1) AND (INDX[I] <> UP) AND (INDX[I-1] = UP)
          THEN 
            BEGIN
              WRITELN ('ERROR: Wrong indexes at line ', COUNT);
              HALT;
            END;
        IF (SEPR[I] <> BL) AND (SEPR[I] <> '-') AND (SEPR[I] <> ',') 
          THEN 
            BEGIN
              WRITELN ('ERROR: Wrong separators at line ', COUNT);
              HALT;
            END;
      END;

    READ (INP, NUMCH, CH, GENCH, CH);
    IF NOT ((NUMCH = '1') AND ('1' <= GENCH) AND (GENCH <= '3')
      OR (NUMCH = '2') AND (GENCH = '4'))
      THEN
        BEGIN
          WRITELN ('ERROR: Wrong nums or gens at line ', COUNT);
          HALT;
        END; 
 
    READLN (INP, LINE);
    IF LINE[LENGTH(LINE)] = BL
      THEN
        BEGIN
          WRITELN ('ERROR: Wrong blank(s) at end of line ', COUNT);
          HALT;
        END; 

    I := 1;
    TAIL := LINE;
    WHILE (I <= 6) AND (INDX [I] <> UP) AND (TAIL <> DUMMY) DO
      BEGIN
        P := POS (SEPR[I], TAIL);
        IF P > 0
          THEN 
            BEGIN
              TOKEN[I] := COPY(TAIL,1,P-1);
              IF SEPR[I] <> ','
                THEN TAIL := COPY(TAIL, P+1, LENGTH(TAIL)-P)
                ELSE TAIL := COPY(TAIL, P+2, LENGTH(TAIL)-P-1);
            END
          ELSE 
            BEGIN
              TOKEN[I] := TAIL;
              TAIL := DUMMY;
            END;

        IF INDX [I] = '0'
          THEN CLSS [I] := 0
        ELSE IF (TOKEN[I] = '^€Œ€„') 
          AND (TOKEN[I-1] = '^ˆ•')
          THEN
            BEGIN 
              CLSS [I] := 2;
              CLSS [I-1] := 2;
            END            
        ELSE IF (TOKEN[I] = '€Šˆ') OR (TOKEN[I] = 'ˆ‘Šˆ') 
          OR (TOKEN[I] = '…‹Šˆ') 
          THEN CLSS [I] := 37
        ELSE IF TOKEN[I] = '†“—Šˆ'
          THEN CLSS [I] := 38
        ELSE IF TOKEN[I] = '˜ˆ˜Šˆ'
          THEN CLSS [I] := 44
        ELSE IF TOKEN[I] = '‚ˆ€'
          THEN CLSS [I] := 12
        ELSE IF (I > 1) AND (TOKEN[I] = 'Ž„ˆ') AND (TOKEN[I-1] = 'Š€Š')
          THEN CLSS [I] := 143
        ELSE IF (I > 1) AND (TOKEN[I] = '‚‘…') AND (TOKEN[I-1] = 'Ž—’ˆ')
          THEN CLSS [I] := 163
        ELSE IF (TOKEN[I] = 'Š€†„›‰') OR (TOKEN[I] = '‚‘’…—›‰') 
          OR (TOKEN[I] = 'Ž……—›‰')
          THEN CLSS [I] := 61
        ELSE IF (TOKEN[I] = '‚Ž‡ŒŽ†Ž…') OR (TOKEN[I] = '…‚Ž‡ŒŽ†Ž…')
          THEN CLSS [I] := 22
        ELSE IF (TOKEN[I] = '‚‘’…—›…') OR (TOKEN[I] = 'Ž……—›…')
          THEN CLSS [I] := 26
        ELSE IF TOKEN[I] = 'ŒŽŸ'
          THEN CLSS [I] := 135
        ELSE IF TOKEN[I] = '€›'
          THEN CLSS [I] := 90
        ELSE IF TOKEN[I] = 'ŠŽŒ€'
          THEN CLSS [I] := 10
        ELSE IF TOKEN[I] = '^‹Ž„Ž'
          THEN CLSS [I] := 2
        ELSE IF (TOKEN[I] = '’Ž›') OR (TOKEN[I] = 'ŽŠ…€›')
          OR (TOKEN[I] = '‹ž‘›') OR (TOKEN[I] = 'Œˆ“‘›')
          OR (TOKEN[I] = '•Ž„›') OR (TOKEN[I] = '‚›•Ž„›')
          THEN CLSS [I] := 86
        ELSE IF (TOKEN[I] = '—‹…›')
          OR (TOKEN[I] = 'ŠŽ…‘Ž„…’›')
          THEN CLSS [I] := 87
        ELSE IF (TOKEN[I] = '^‚‹€„ˆŒˆ')
          OR (TOKEN[I] = '^ˆ‹') 
          THEN CLSS [I] := 2
        ELSE IF (TOKEN[I] = 'Ž’˜…‹œˆŠ') 
          AND (TOKEN[I-1] = '€Š')
          THEN
            BEGIN
              CLSS[I] := 2; 
              CLSS[I-1] := 2;
            END            
        ELSE IF (I>1)
          AND ((TOKEN[I] = '…‡ˆ„…’')
            OR (TOKEN[I] = '—…ŒˆŽ')) 
          AND ((CLSS[I-1] = 317) OR (CLSS[1] = 317))
          THEN
            BEGIN
              CLSS[I] := 2; 
              CLSS[I-1] := 314;
              CLSS[1] := 314;
            END            
        ELSE IF (TOKEN[I] = '^Šˆ…‚‘Šˆ‰') 
          AND (TOKEN[I-1] = '^Œˆ’ŽŽ‹ˆ’')
          THEN
            BEGIN 
              CLSS [I] := 128;
              CLSS [I-1] := 2;
            END            
        ELSE IF (TOKEN[I] = '^‘Œˆ’‘Ž›')
          AND (TOKEN[I-1] = '^ˆ’…') 
          THEN
            BEGIN 
              CLSS [I-1] := 2;
              CLSS [I] := 87;
            END            
        ELSE IF (TOKEN[I] = '“‘‘Šˆ…') 
          AND ((LINE = '“‘‘Šˆ… ˆ ‘Ž‚…’‘Šˆ… €Š’…›')
            OR (LINE = '“‘‘Šˆ… ˆ ‘Ž‚…’‘Šˆ… €Š’ˆ‘›'))
          THEN CLSS [I] := 27
        ELSE IF (TOKEN[I] = '“‘‘Šˆ‰') 
          AND (LINE = '“‘‘Šˆ‰ ˆ €Œ…ˆŠ€‘Šˆ‰ ˆ‘€’…‹œ')
          THEN CLSS [I] := 128
        ELSE IF (TOKEN[I] = '^ŒŽ‘ŠŽ‚‘Šˆ‰') 
          AND (TOKEN[I-1] = '^€’ˆ€•')
          THEN CLSS [I] := 128
        ELSE IF (TOKEN[I] = 'Ž‘’') 
          AND (TOKEN[I-1] = '^Ž†„…‘’‚…‘Šˆ‰')
          THEN
            BEGIN
              CLSS [I] := 1; 
              CLSS [I-1] := 127;
            END            
        ELSE IF (TOKEN[I] = '‡‚…‡„›') AND (I > 1) 
          AND (TOKEN[I-1] = '„“ƒˆ…')
          THEN
            BEGIN
              CLSS [I-1] := 118;
              CLSS [I] := 90;
            END	            
        ELSE IF (TOKEN[I] = '‹…’') AND (I > 1)
          THEN CLSS [I] := 238

        ELSE IF (INDX[1] = '1') AND (TOKEN[1] = '‚‘…')
          THEN
            BEGIN
              IF (LINE = '‚‘… 24 —€‘€')
                OR (LINE = '‚‘… ‡€ ˆ Ž’ˆ‚') 
                OR (LINE = '‚‘… ŒŽŸ ˆ ŽŠ…€›') 
                OR (LINE = '‚‘… ‹ž‘› ˆ Œˆ“‘›')
                OR (LINE = '‚‘… •Ž„› ˆ ‚›•Ž„›')
                THEN CLSS [1] := 169
              ELSE IF (LINE = '‚‘… …‡ ˆ‘Š‹ž—…ˆŸ')
                OR (LINE = '‚‘… ‚Œ…‘’… ˆ Š€†„›‰ ‚ Ž’„…‹œŽ‘’ˆ')
                OR (LINE = '‚‘… ‚‘’…—›… ˆ Ž……—›…')
                OR (LINE = '‚‘… „Ž …„ˆŽƒŽ')
                OR (LINE = '‚‘… „Ž Ž„ŽƒŽ')
                OR (LINE = '‚‘… ˆ Š€†„›‰')
                OR (LINE = '‚‘… ˆ‹ˆ Ž—’ˆ ‚‘…')
                OR (LINE = '‚‘… Š€Š Ž„ˆ')
                OR (LINE = '‚‘… ŠŽŒ“ … ‹…œ')
                OR (LINE = '‚‘… Ž’ Œ€‹€ „Ž ‚…‹ˆŠ€')
                OR (LINE = '‚‘… ŽƒŽ‹Ž‚Ž')
                OR (LINE = '‚‘… Ž„Ÿ„')
                OR (LINE = '‚‘… ‘ Œ€‹€ „Ž ‚…‹ˆŠ€')
                THEN CLSS [1] := 163
              ELSE IF (LINE = '‚‘… …‡ ˆ‡šŸ’œŸ')
                OR (LINE = '‚‘… …‡ Œ€‹ŽƒŽ')
                OR (LINE = '‚‘… …‡ Ž‘’€’Š€')
                OR (LINE = '‚‘… ‚Ž‡ŒŽ†Ž… ˆ …‚Ž‡ŒŽ†Ž…')
                OR (LINE = '‚‘… „Ž Ž‘’€’Š€')
                OR (LINE = '‚‘… —’Ž “ƒŽ„Ž')
                THEN CLSS [1] := 20;
            END
        ELSE 
          BEGIN
            INITSUBCL (TOKEN[I], CLSS[I], VAL, NUM[I], GND[I], ANM); 

            IF (I > 1) AND (SEPR[I-1] = HYP) AND (ANM = YES)  
              AND CAN_BE_ANIMATED (CLSS[I-1], ANCL)
              AND CAN_BE_DEANIMATED (CLSS[I], DEANCL)
              THEN CLSS[I] := DEANCL
              ELSE
                BEGIN
                  IF (ANM = YES) AND (I > 1) 
                    AND (NUM[I-1] = NUM[I]) AND (GND[I-1] = GND[I])
                    AND CAN_BE_ANIMATED (CLSS[I-1], ANCL)
                    THEN CLSS[I-1] := ANCL;
                  IF (ANM = YES) AND (I > 2) AND (TOKEN[I-1] <> 'ˆ') 
                    AND (NUM[I-2] = NUM[I]) AND (GND[I-2] = GND[I])
                    AND CAN_BE_ANIMATED (CLSS[I-2], ANCL)
                    THEN CLSS[I-2] := ANCL;
                  IF ANIMABLE (TOKEN [I]) 
                    THEN 
                      BEGIN
                        IF CAN_BE_ANIMATED (CLSS[I], ANCL)
                          THEN CLSS[I] := ANCL;
                        IF (I > 1) 
                          AND (NUM[I-1] = NUM[I]) AND (GND[I-1] = GND[I])
                          AND CAN_BE_ANIMATED (CLSS[I-1], ANCL1)
                         THEN CLSS[I-1] := ANCL1;
                       END;
                END;
            IF ((LINE = '„ŽŒ€˜ˆ… ˆ „ˆŠˆ… †ˆ‚Ž’›…') 
              OR (LINE = '€Ž—ˆ… ˆ Ž‘‹“†ˆ‚€ž™ˆ‰ …‘Ž€‹')
              OR (LINE = '€Ž—ˆ‰ ˆ Ž”‘Žž‡›‰ ‹ˆ„…')
              OR (LINE = '“‘‘Šˆ… ˆ ‘Ž‚…’‘Šˆ… €Š’…›')
              OR (LINE = '“—›… ˆ „ˆŠˆ… ‡‚…ˆ')
              OR (LINE = '‘‹“†…›… ˆ Žˆ‘ŠŽ‚›… ‘Ž€Šˆ')
              OR (LINE = '“—…›‰ ˆ Žƒ€ˆ‡€’Ž €“Šˆ'))
              AND (I = 1) AND CAN_BE_ANIMATED (CLSS[I], ANCL)
              THEN CLSS[I] := ANCL;
            IF (LINE = '—’Ž Ž„ˆ —’Ž „“ƒŽ‰') AND ((I = 2) OR (I = 4)) 
              AND CAN_BE_ANIMATED (CLSS[I], ANCL)
              THEN CLSS[I] := ANCL;
            IF (LINE = '—…‹Ž‚…Š … Ž•Ž†ˆ‰ € „“ƒˆ•') AND (I = 3) 
              AND CAN_BE_ANIMATED (CLSS[I], ANCL)
              THEN CLSS[I] := ANCL;
            IF (TOKEN[I] = '—‹…›') AND ((COPY(TAIL,1,7) = 'Šˆ€†€')
              OR (COPY(TAIL,1,10) = '…‡ˆ„ˆ“Œ€')
              OR (COPY(TAIL,1,9) = '€‚‹…ˆŸ')
              OR (COPY(TAIL,1,2) = 'ˆ '))
              THEN CLSS [I] := 87;
            IF (TOKEN[I] = '—‹…') AND (TAIL <> '')
              THEN CLSS [I] := 2;
          END;
        INC (I);
      END; 

    WRITE (OUT_A, 'ACC: ');
    WRITE (OUT_G, 'GEN: ');
    I := 1;
    WHILE (I <= 6) AND (TOKEN[I] <> DUMMY) DO
      BEGIN
        L := LENGTH (TOKEN[I]);
        WRITE (OUT_A, COPY (TOKEN[I], 1, L-LENGTH(FINALS[CLSS[I],NOM])) 
            + FINALS [CLSS[I], ACC] + SEPR [I]);
        WRITE (OUT_G, COPY (TOKEN[I], 1, L-LENGTH(FINALS[CLSS[I],NOM])) 
            + FINALS [CLSS[I], GEN] + SEPR [I]);
        INC (I);
      END; 
    WRITELN (OUT_A);
    WRITELN (OUT_G);

    FOR J := 1 TO 6 DO
      WRITE (OUT, CLSS [J] : 3, SEPR [J]);
    WRITELN (OUT, NUMCH, BL, GENCH, BL, LINE);

    L := LENGTH (LINE);
    LINE1 := '';
    I := 0;
    REPEAT
      INC(I);
      IF (LINE [I] = '^') THEN 
        BEGIN INC(I); LINE1 := LINE1 + LINE [I]; END
      ELSE IF ('A' <= LINE [I]) AND (LINE [I] <= 'Z')
        THEN LINE1 := LINE1 + CHR (ORD (LINE[I]) + 32)
      ELSE IF ('€' <= LINE [I]) AND (LINE [I] <= '')
        THEN LINE1 := LINE1 + CHR (ORD (LINE[I]) + 32)
      ELSE IF ('' <= LINE [I]) AND (LINE [I] <= 'Ÿ')
        THEN LINE1 := LINE1 + CHR (ORD (LINE[I]) + 80)
        ELSE LINE1 := LINE1 + LINE [I];
    UNTIL (I = L);

    WRITE (OUT1, '{{');
    FOR J := 1 TO 5 DO
      WRITE (OUT1, '{', CLSS [J] : 3, ',"', SEPR [J], '"},');
    WRITE (OUT1, '{', CLSS [6] : 3, ',"', SEPR [6], '"}},');
    IF EOF(INP)
      THEN WRITELN (OUT1, ' "', LINE1, '"}')
      ELSE WRITELN (OUT1, ' "', LINE1, '"},');

  UNTIL EOF(INP);

  WRITELN (OUT1, '}');

  FLUSH (OUT);
  FLUSH (OUT1);
  FLUSH (OUT_A);
  FLUSH (OUT_G);
  WRITELN (COUNT, ' LINES IN FILE TOOLONG.TXT');
  WRITELN ('FILES TOOLONG.COD, NTOOLONG.PCC, TST_ACC.TXT AND TST_GEN OUTPUT');
END.
