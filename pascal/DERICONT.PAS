PROGRAM DERICONT;

USES DOS, CLASTABL, NOUNTHRU, INITVER4;

  VAR XL_DAS, BUF : STRING [255];

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    BL2 = '  ';
    SUFS : ARRAY [1..53] OF STR4 =
      ('›‰', 'ˆ‰', 'Ž‰', 'ˆ‰‘Ÿ', '€Ÿ', 'ŸŸ', '€Ÿ‘Ÿ', 'Ž…', '……',
      '……‘Ÿ', '›…', 'ˆ…', 'ˆ…‘Ÿ', 'œŸ', 'œ…', 'œˆ', 'ŽŸ', 'Žˆ',
      '€˜', '€˜€', '€˜…', '€˜ˆ', 'ˆ', 'ˆ€', 'ˆŽ', 'ˆ›',
      '…‘œ', '‘Ÿ', '‘…', 'Ž’', '‚', '‚€', '‚Ž', '‚›',
      '›€', '›Ž', 'ˆ', '€Œ', '€Œ€', '€ŒŽ', '€Œˆ', '€', 'Ž', 
      '…', '…œ', 'Ÿ', '…', '…‰', 'ˆ', '›', '€', 'Ž', '››');
    ADVS : ARRAY [1..12] OF STR9 =
       ('“„“—ˆ', '„…‹€Ÿ', 'ˆŒ…Ÿ', '€•Ž„Ÿ‘œ',
        '‘„…‹€‚', '‘Ž‚…˜ˆ‚', '‘Ž‚…˜€Ÿ', '‘Ž‡„€‚',
        '‘Ž‡„€‚€Ÿ', '‘’€‚', '‘’€Ž‚Ÿ‘œ', 'Ÿ‚‹ŸŸ‘œ');
    STAG_NAME : ARRAY [STAGE] OF STR6 = 
    ('UNRZD ','BASIC ','VLONG ','SINGLE','HYPHD ', 
     'DBLZR ','ZPRT2 ','NZPRT2','CONJD ');

  TYPE
    STATUS = (ZERO, SUB, VERB, ADJ, ADV);
    STR15 = STRING [15];

  VAR
    I, L, K, P, L2, PU : INTEGER;
    TOTAL, SUPER, LINENUM : LONGINT;
    CLASS, CLASS2, CLS1, CLS2, SHRTCLS1, SHRTCLS2 : INTEGER;
    NCOUNT, CURNUM : INTEGER;
    INP, OUT, OUT_YM, OUT_OM, OUT_OY : TEXT;
    LINE, COMMENT, NOUN : STR115;
    INIT, FIN2 : STR2;
    COUNT, TCOUNT : ARRAY [STATUS] OF INTEGER;
    CURSTAT, ST : STATUS;
    HEADER, TAIL, TOKEN, TOK1, TOK2 : STR115;
    VALID, FOUND, DOUBLE_KEY, INVERSE_KEY, DONE : BOOLEAN;
    NUMB, NUM0 : NUMBER;
    GEND, GND0 : GENDER;

    CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ‹žŽ‰ *)
    CLA0018 : ARRAY [1..XOYMAX] OF STR15;  (* ‘“•Ž‰ *)
    CLA0107 : ARRAY [1..IYMAX] OF STR15; (* ”€‡€ˆ‰ *)
    
    NOM : CHAR;
    STG : STAGE;
    STAG_CNT : ARRAY [STAGE] OF INTEGER;
    TAKEIT : BOOLEAN;


  FUNCTION COMPARATIV (TOKEN : STR115) : BOOLEAN;
         (*==========*)
    CONST
      MAX = 36;
      COMPAR : ARRAY [1..MAX] OF STR15 =
('…„……','‹ˆ†…','Žƒ€—…','Ž„……',
'‚…†‹ˆ‚……','‚›˜…','ƒ‹“……','ƒ“™…',
'„€‹œ˜…','„‹ˆ……','ŠŽŽ—…','‹…‚……','‹“—˜…','ˆ†…',
'Ž-›‘’ŽŒ“','Ž-ƒŽŽ„‘ŠŽŒ“','Ž-ŒŽ‘ŠŽŒ“',
'Ž-ŒŽŸ–Šˆ','Ž-Ž‚ŽŒ“','Ž-‘’€ŽŒ“','Ž‹ˆ†…','Ž‚‘ž„“',
'Ž‚›˜…','Ž„€‹œ˜…','Ž—ˆ™…','€‚……','Ž‘’Ž……',
'Ž™…','‘ˆ‹œ……','‘‹€……','‘‹Ž†……',
'“†…','“Œ……','•“†…','—ˆ™…','˜ˆ…');
    VAR
      I : INTEGER;

  BEGIN
    I := 0;
    REPEAT
      INC (I);
    UNTIL (TOKEN <= COMPAR [I]) OR (I = MAX);
    COMPARATIV := (TOKEN = COMPAR [I]);
  END;

{ Tests if TOKEN is single short-formed adjective 
                       like „Ž‹†… or €„…•Ž…Š }
  PROCEDURE TRY_SINGLE_SHORT (TOKEN : STR115;
          (*================*)VAR SHRCLS : INTEGER);
  CONST
    MAX1 = 14;
    SHRTS1 : ARRAY [1..MAX1] OF 
      RECORD
        TOK : STR10;
        CLS : INTEGER;
      END =
(* 1*)((TOK:'‚…‹ˆŠ'      ; CLS: 2),
(* 2*) (TOK:'‚Ž‹…'      ; CLS: 4),
(* 3*) (TOK:'ƒŽ€‡„'     ; CLS: 1),
(* 4*) (TOK:'„Ž‹†…'     ; CLS: 3),
(* 4*) (TOK:'‹ž'        ; CLS: 1),
(* 6*) (TOK:'Œ€‹'        ; CLS: 1),
(* 7*) (TOK:'ŒŽ‹Ž„'      ; CLS: 1),
(* 8*) (TOK:'€Œ……'    ; CLS: 7),
(* 9*) (TOK:'…‚…‹ˆŠ'    ; CLS: 2),
(*10*) (TOK:'Ž„ˆ'       ; CLS: 6),
(*11*) (TOK:'Ž„ˆ1'      ; CLS: 6),
(*12*) (TOK:'Ž‹…•Ž…Š' ; CLS: 5),
(*13*) (TOK:'Ž‹…˜……Š' ; CLS: 5),
(*14*) (TOK:'€„'        ; CLS: 1));

    MAX2 = 13;
 SHRT_STEMS : ARRAY [1..MAX2] OF STR8 =
('Ž‹œ','›‘’','‚…‘…‹','ƒŽ‹Ž„','ƒ“‘’','ƒŸ‡',
 'ŒŽ‹Ž„','Ž„ˆ','Ž‹','€„','•ˆ’','•Ž‹Ž„','—ˆ‘’');

  VAR
      I, L : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    L := LENGTH(TOKEN);
    SHRCLS := 0;
    FOUND := FALSE;
    I := 0;
    IF L < 8
      THEN
        BEGIN
          REPEAT
            INC (I);
            FOUND := (TOKEN = SHRTS1[I].TOK ) 
          UNTIL FOUND OR (I = MAX1);
          IF FOUND
            THEN SHRCLS := SHRTS1[I].CLS
        END
      ELSE
        BEGIN
          REPEAT
            INC (I);
            FOUND := (TOKEN = SHRT_STEMS[I] + '…˜……Š')
              OR (TOKEN = SHRT_STEMS[I] + '…•Ž…Š');
          UNTIL FOUND OR (I = MAX2);
          IF FOUND
            THEN SHRCLS := 5;
        END;
  END;


{ Adjectives with endings Ž‚/Ž‚€/Ž‚Ž/Ž‚› or …‚/…‚€/…‚/…‚› }
FUNCTION IN_OV_OVA (STEM : STR115) : BOOLEAN;
       (*=========*)
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;

CONST
  OVMAX = 103;
  ST : ARRAY [1..OVMAX] OF STRING [20] =
('€…‹…','€‚ƒˆ…','€„Ž','^€ˆ—ŠŽ','€ˆ€‹Ž','€„€ŒŽ',
'€„Ž','€’ŽŽ','€…„Ž','€ˆ‘’Ž’…‹…','€•ˆŒ…„Ž',
'€•ˆ‹‹…‘Ž','€•ˆ‹‹Ž','€‰…‘Ž','^€…–…','^…ˆƒŽ',
'€’›…','…’Ž‹…’Ž','ˆŠ”Ž„Ž','ŽƒŽ','€’Ž','“‹…',
'^‚€‹œ“ƒˆ…','^‚€‹’€‘€Ž','‚…ƒˆ‹ˆ…','‚ˆ‹‹ˆ‡ˆ…',
  '‚Ž‹œ’Ž','^‚Ž‹œ’…Ž','‚ŽŽŽ',
'ƒ€‰ŒŽŽ','ƒ€‹…Ž','ƒ€Œˆ‹œ’ŽŽ','^ƒ€ˆ€‹Ž','ƒ€“‘‘Ž',
  'ƒ…€Š‹Ž','ƒ…Ž‘’€’Ž','ƒ…Š“‹…‘Ž','^ƒ…Š“‹…‘Ž',
  'ƒŽŒ…Ž','ƒŽ„ˆ…','ƒŽ‘“„€…','^ƒ“„‡ŽŽ','ƒ‹€“…Ž',
'„…Š€’Ž','^„€ˆ‹Ž','^„€’Ž','„€’Ž','„€ŒŽŠ‹Ž',
  '„…„Ž','„ˆŽ”€’Ž','„“•Ž','„ŽŠŽ‹“ŒŽ','„€ŠŽŽ',
'…‚Š‹ˆ„Ž','…‚‘’€•ˆ…',
'Š…‘€…','Š€ˆŽ','^Š€‰Œ€Ž','ŠŽˆŽ‹ˆ‘Ž','ŠŽ™……',
  '^Š…‰–…Ž','ŠŽŠŽ„ˆ‹Ž','^Š“‹ˆŠŽ',
'‹€‹€‘Ž','‹“ŠŠ“‹Ž','^Œ€ƒ…‹‹€Ž','Œ€Œ€…','Œ€Š‘Ž',
'……‚Š‹ˆ„Ž','…’“Ž','Ž…','Ž’–Ž',
'€•ˆŽŽ','ˆŽ','ˆ”€ƒŽŽ','‹…ŒŸˆŠŽ','ŽŽ',
  '…„‘…„€’…‹…','ŽŠ“‘’Ž','ŽŒ…’……',
'ˆŒ€Ž',
'‘€Œ‘ŽŽ','‘ˆ‡ˆ”Ž','‘ˆ‹œ‚ˆ…','‘Ž‹ŽŒŽŽ','^‘Ž‹ŽŒŽŽ',
  '‘”ˆŠ‘Ž','‘›Ž',
'’€’€‹Ž','’Žˆ—…‹‹ˆ…','”€‹‹Žˆ…','^”ˆ‹ˆŽ',
'•€ŒŽ','•€“‘„Ž”Ž','•ˆ‘’Ž','^•ˆ‘’Ž','–€…','—…’Ž',
'„ˆŽ','‡ŽŽ','‰‹…Ž','^‰”…‹…','Ž‹Ž');

BEGIN
  FOUND:=FALSE; 
  I:=0;
  REPEAT 
    INC(I); 
    FOUND := (ST[I] = STEM);
  UNTIL FOUND OR (I = OVMAX);
  IN_OV_OVA := FOUND;
END;

FUNCTION IS_HYPHBLOCK (TOKEN : STR115) : BOOLEAN;
       (*============*)
BEGIN
  IS_HYPHBLOCK :=
(TOKEN = 'Š€ŠŽ‰-’') OR (TOKEN = 'Š€ŠŽ‰-‹ˆ') OR
(TOKEN = 'Š€ŠŽ‰-ˆ“„œ') OR
(TOKEN = 'Š€Š€Ÿ-’') OR (TOKEN = 'Š€Š€Ÿ-‹ˆ') OR
(TOKEN = 'Š€ŠŽ‰-ˆ“„œ') OR
(TOKEN = 'Š€Šˆ…-’') OR (TOKEN = 'Š€Šˆ…-‹ˆ') OR
(TOKEN = 'Š€ŠŽ‰-ˆ“„œ');
END;

PROCEDURE DEFINE_SUFS (TOKEN : STR115;
        (*===========*)VAR NUM : INTEGER);
  VAR
    I, L : INTEGER;
    FOUND : BOOLEAN;
    FLEX : STR5;
BEGIN
  NUM := 0;
  FOUND := FALSE;
  L := LENGTH (TOKEN);
  I := 0;
  REPEAT
    INC (I);
    FLEX := COPY (TOKEN, L - LENGTH (SUFS [I]) + 1, LENGTH (SUFS [I]));
    FOUND := (SUFS [I] = FLEX);
  UNTIL FOUND OR (I = 53);
  IF FOUND
    THEN NUM := I;
END;

PROCEDURE CLASSADJ (STEM : STR115;
        (*========*)FLEX_NUM : INTEGER;
                    VAR CLASS : INTEGER;
                    VAR GEND : GENDER;
                    VAR NUMB : NUMBER);
VAR
  LAST : CHAR;
  L, P : INTEGER;
  LOW, HIGH, MID : INTEGER;
  FOUND : BOOLEAN;
  RES : RESTYPE;
BEGIN
  CLASS := 0;
  P := POS ('-', STEM);
  IF (P > 0)
    THEN
      IF IS_HYPHBLOCK (STEM)
        THEN
          BEGIN
            CLASS := 5;
            IF COPY (STEM, P - 2, 2) = 'ˆ‰'
              THEN
            BEGIN GEND := MASC;NUMB := SING;END
              ELSE IF COPY (STEM, P - 2, 2) = '€Ÿ'
              THEN
            BEGIN GEND := FEM;NUMB := SING;END
              ELSE IF COPY (STEM, P - 2, 2) = 'Ž…'
              THEN
            BEGIN GEND := NEUT;NUMB := SING;END
              ELSE
            BEGIN GEND := COMN;NUMB := PLUR;END;
              EXIT;
            END
        ELSE IF (COPY (STEM, 1, P) = 'Ž-')
          OR (COPY (STEM, P + 1, LENGTH (STEM) - P) = '’')
          THEN
        BEGIN GEND := NONE;NUMB := UNKN;CLASS := 0;EXIT;END
          ELSE STEM := COPY (STEM, P + 1, LENGTH (STEM) - P);
  NUMB := SING;
  CASE FLEX_NUM OF
    0 : GEND := NONE;
    1..4, 19, 23, 27, 30, 31, 38, 45, 48 : GEND := MASC;
    5..7, 14, 17, 20, 24, 28, 32, 35, 39, 42, 46 : GEND := FEM;
    8..10, 15, 21, 25, 29, 33, 36, 40, 43, 44, 47 : GEND := NEUT;
    11..13, 16, 18, 22, 26, 34, 37, 41, 49 :
      BEGIN GEND := COMN; NUMB := PLUR; END;
  END;

  L := LENGTH (STEM);
  LAST := STEM [L];

  CASE FLEX_NUM OF
    0 : CLASS := 0;
    1 : (* -›‰ *)
      CASE LAST OF
        '' :
          IF (COPY (STEM, L-2, 3) = '‹œ') OR 
            (COPY (STEM, L-1, 2) = '‰') 
            THEN CLASS := 2
          ELSE IF STEM [L-1] = ''
            THEN CLASS := 1
          ELSE IF (POS (STEM [L-1], SONOR) > 0)
            THEN CLASS := 9
            ELSE CLASS := 1;
        '’','„','‚','Œ','‹','','','','‘','–','‡' : CLASS := 9;
        ELSE CLASS := 0;
      END;
    2 : (* -ˆ‰ *)
      BEGIN
        LOW := 1;
        HIGH := IYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*”€‡€ˆ‰>*) COMPARE_TOK (STEM, CLA0107 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 7
          ELSE
            IF LAST = ''
              THEN
                IF (POS (STEM [L-1], '‚„†ˆ‰Œ’•˜œ') > 0)
                  THEN CLASS := 8
                  ELSE CLASS := 0
            ELSE IF (STEM = 'Š€')
              OR (STEM = '„‹ˆŽ˜…') OR (STEM = 'ŠŽŽ’ŠŽ˜…')
               THEN CLASS := 8
            ELSE IF POS (LAST, LABIA) > 0
              THEN CLASS := 10
            ELSE IF (POS (LAST, AFFR) > 0)
              THEN CLASS := 3
              ELSE CLASS := 0;
      END;
    3 : (* -Ž‰ *)
      IF (STEM = '‘‚') OR (STEM = '’‚') OR (STEM = 'Œ')
        THEN CLASS := 11
      ELSE IF (STEM = 'ŒŽŠŽ‚Š') OR (STEM = 'ˆ’Ž—Š')
        OR (STEM = '“ƒŽ‚Š') OR (LAST = '–') OR (STEM = '‘‹')
        OR (STEM = '‘’') OR (STEM = '‡€‘’') OR (STEM = '‘’')
        OR (STEM = '–…')
        THEN CLASS := 0
      ELSE IF POS (LAST, LABIA + AFFR) > 0
        THEN CLASS := 5
        ELSE CLASS := 4;
    4, 7, 10, 13 : (* -ˆ‰‘Ÿ/-€Ÿ‘Ÿ/-……‘Ÿ/-ˆ…‘Ÿ *)
      CLASS := 6;
    5 : (* -€Ÿ *)
      BEGIN
        LOW := 1;
        HIGH := OYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*‹ž€Ÿ>*)  COMPARE_TOK (STEM, CLASS17 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 4
          ELSE
            CASE LAST OF
              'ƒ', 'Š', '•', '˜', '™', '—', '†' :
                BEGIN
                  LOW := 1;
                  HIGH := XOYMAX;
                  FOUND := FALSE;
                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                    BEGIN
                      MID := (HIGH + LOW) DIV 2;
(*‘“•€Ÿ/Ž‹œ˜€Ÿ*)     COMPARE_TOK (STEM, CLA0018 [MID], RES);
                      CASE RES OF
                        LT : HIGH := MID - 1;
                        EQ : FOUND := TRUE;
                        GT : LOW := MID + 1;
                      END;
                    END;
                  IF FOUND
                    THEN CLASS := 5
                    ELSE
                      IF (POS (LAST, LABIA) > 0)
                        THEN CLASS := 10
                        ELSE CLASS := 3;
                END;
              '' :
                IF STEM [L-1] = ''
                  THEN CLASS := 1
                  ELSE IF (POS (STEM [L-1], SONOR) > 0)
                    THEN CLASS := 9
                    ELSE CLASS := 2;
              '’','„','‚','Œ','‹','','','','‘','–','‡' : CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    6 : (* -ŸŸ *)
      IF (LAST = '') OR (LAST = '…') OR (STEM = 'Š€')
        THEN CLASS := 8
        ELSE CLASS := 0;
    8 : (* -Ž… *)
      IF (STEM = '‘‚') OR (STEM = '’‚') OR (STEM = 'Œ')
        THEN CLASS := 11
        ELSE
          CASE LAST OF
            'ƒ', 'Š', '•', '˜', '™', '—', '†' :
              BEGIN
                LOW := 1;
                HIGH := XOYMAX;
                FOUND := FALSE;
                WHILE (HIGH >= LOW) AND NOT FOUND DO
                  BEGIN
                    MID := (HIGH + LOW) DIV 2;
(*‘“•Ž…/Ž‹œ˜Ž…>*)  COMPARE_TOK (STEM, CLA0018 [MID], RES);
                    CASE RES OF
                      LT : HIGH := MID - 1;
                      EQ : FOUND := TRUE;
                      GT : LOW := MID + 1;
                    END;
                  END;
                IF FOUND
                  THEN CLASS := 5
                  ELSE
                    IF (POS (LAST, LABIA) > 0)
                      THEN CLASS := 10
                      ELSE CLASS := 0;
              END;
            '','’','„','‚','Œ','‹','','','','‘','–','‡':
              BEGIN
                LOW := 1;
                HIGH := OYMAX;
                FOUND := FALSE;
                WHILE (HIGH >= LOW) AND NOT FOUND DO
                  BEGIN
                    MID := (HIGH + LOW) DIV 2;
 (*‹žŽ…>*)         COMPARE_TOK (STEM, CLASS17 [MID], RES);
                    CASE RES OF
                      LT : HIGH := MID - 1;
                      EQ : FOUND := TRUE;
                      GT : LOW := MID + 1;
                    END;
                  END;
                IF FOUND
                  THEN CLASS := 4
                  ELSE
                    IF LAST = ''
                      THEN
                        IF STEM [L-1] = ''
                          THEN CLASS := 1
                      ELSE IF (POS (STEM [L-1], SONOR) > 0)
                        THEN CLASS := 9
                      ELSE CLASS := 2
                      ELSE
                        CLASS := 9;
              END;
            ELSE CLASS := 0;
          END;
    9 : (* -…… *)
      IF LAST = ''
        THEN
          IF (POS (STEM [L-1], '‚„†ˆ‰Œ’•˜œ') > 0)
            THEN CLASS := 8
            ELSE CLASS := 0
     ELSE IF (LAST = '…') OR (STEM = 'Š€')
        THEN CLASS := 8
        ELSE
          IF POS (LAST, AFFR) > 0
            THEN CLASS := 3
            ELSE CLASS := 0;
    11 : (* -›… *)
      BEGIN
        LOW := 1;
        HIGH := OYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*‹ž›…>*)  COMPARE_TOK (STEM, CLASS17 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 4
          ELSE
            CASE LAST OF
              '' :
                IF STEM [L-1] = ''
                  THEN CLASS := 1
                ELSE IF (POS (STEM [L-1], SONOR) > 0)
                  THEN CLASS := 9
                  ELSE CLASS := 2;
              '’','„','‚','Œ','‹','','','','‘','–','‡' :
                CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    12 : (* -ˆ… *)
      BEGIN
        LOW := 1;
        HIGH := XOYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*‘“•ˆ…/Ž‹œ˜ˆ…*)COMPARE_TOK (STEM, CLA0018 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 5
          ELSE
            IF LAST = ''
              THEN
                IF (POS (STEM [L-1], '‚„†ˆ‰Œ’•˜œ') > 0)
                  THEN CLASS := 8
                  ELSE CLASS := 0
            ELSE IF (STEM = 'Š€') OR (LAST = '…')
              THEN CLASS := 8
              ELSE
                IF (POS (LAST, LABIA) > 0)
                  THEN CLASS := 10
                ELSE
                  IF (POS (LAST, AFFR) > 0) AND (STEM <> '‚…‹ˆ—')
                    THEN CLASS := 3
                    ELSE CLASS := 0;
      END;
    14, 15, 16 : (* -œŸ/-œ…/-œˆ *)
      IF (STEM = '—') OR (STEM = 'ˆ—') OR (STEM = 'ŠŽ…-—')
        THEN CLASS := 20
        ELSE
      BEGIN
        LOW := 1;
        HIGH := IYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*”€‡€œŸ>*)COMPARE_TOK (STEM, CLA0107 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 7
          ELSE CLASS := 0;
      END;
    17, 18 : (* -ŽŸ/-Žˆ *)
      IF (STEM = '‘‚') OR (STEM = '’‚') OR (STEM = 'Œ')
        THEN CLASS := 11
        ELSE CLASS := 0;
    19..22 : (* -€˜/-€˜€/-€˜…/-€˜ˆ *)
      IF (STEM = '') OR (STEM = '‚')
        THEN CLASS := 12
        ELSE CLASS := 0;
    23..26 : (* -ˆ/-ˆ€/-ˆŽ/-ˆ› *)
      IF (STEM = 'Ž„')
        THEN CLASS := 16
        ELSE
      IF (STEM = '€ž’') OR (STEM = '€ˆ€„') OR (STEM = '€“˜Š')
        OR (STEM = '€’') OR (STEM = '‚…„œŒ')  OR (STEM = 'ˆ“„') 
        OR (STEM = '„…„“˜Š') OR (STEM = '„Ž—…') OR (STEM = '„Ž—Š') 
        OR (STEM = '„Ÿ„') OR (STEM = '„Ÿ„…œŠ')OR (STEM = '†…') 
        OR (STEM = 'ŠŽ˜Š') OR (STEM = 'Š“Š“˜Š') OR (STEM = '‹€‘’Ž—Š') 
        OR (STEM = '…‚…‘’') OR (STEM = '…‚…‘’Š')OR (STEM = '€')
        OR (STEM = 'Œ€Œ') OR (STEM = 'Œ€Œ…œŠ') OR (STEM = 'Œ€’“˜Š')
        OR (STEM = 'Œ€’›˜Š') OR (STEM = 'Œ€’…') OR (STEM = 'Œ“†')
        OR (STEM = '‘…‘’') OR (STEM = '‘“Š') OR (STEM = '‘“—Š') 
        OR (STEM = '‘’€“•') OR (STEM = '™“Š') OR (STEM = '„Ÿ„') 
        OR (STEM = '’…’') OR (STEM = '’…’Š') OR (STEM = '’ˆ˜Š')
        OR (STEM = '˜€€˜Š') OR (STEM = '^˜…ŒŸŠ') OR (STEM = '”ˆ‹œŠ')
          THEN CLASS := 17
          ELSE CLASS := 0;
    27..29 : (* -…‘œ/-‘Ÿ/-‘… *)
      IF (STEM = '‚')
        THEN CLASS := 15
        ELSE CLASS := 0;
    30,51,52 :  (* -Ž’/-€/-Ž *)
      IF (STEM = '’')
        THEN CLASS := 13
      ELSE IF (STEM = '’')
        THEN CLASS := 14
        ELSE CLASS := 0;
    31..34 : (* -‚/-‚€/-‚Ž/-‚› *)
      IF IN_OV_OVA (STEM)
        THEN CLASS := 18
        ELSE CLASS := 0;
    37 : (* -ˆ *)
      IF (STEM = 'Ž„')
        THEN CLASS := 16
      ELSE IF (STEM = 'ƒŽ‘Ž„')
        THEN CLASS := 21
        ELSE CLASS := 0;
    38..41 : (* -€Œ/-€Œ€/-€ŒŽ/-€Œˆ *)
      IF (STEM = '‘')
        THEN CLASS := 19
        ELSE CLASS := 0;
    42,43 : (* -€/-Ž *)
      IF (STEM = 'Ž„')
        THEN CLASS := 16
        ELSE CLASS := 0;
    44,45,46 : (* -…/-…œ/-Ÿ *)
      IF (STEM = 'ƒŽ‘Ž„')
        THEN CLASS := 21
        ELSE CLASS := 0;
    47 : (* -… *)
      IF (STEM = '’')
        THEN CLASS := 13
        ELSE CLASS := 0;
    48 : (* -…‰ *)
      IF (STEM = '—') OR (STEM = 'ˆ—') 
        OR (STEM = 'ŠŽ…-—')
        THEN CLASS := 20
        ELSE CLASS := 0;
    49 : (* -ˆ *)
      IF (STEM = '’')
        THEN CLASS := 14
        ELSE CLASS := 0;
    35,36,50,53 : (* -›/-›€/-›Ž/-›› *)
      IF (STEM = 'Š“ˆ–') OR (STEM = '‹…ŒŸˆ–') 
        OR (STEM = 'ŠŽ›‹ˆ–') OR (STEM = 'ŠŽŒˆ‹ˆ–')
        OR (STEM = '’Žˆ–')  
        THEN CLASS := 23
        ELSE CLASS := 0;
  END;

  IF CLASS = 0
    THEN
      BEGIN
        GEND := NONE;
        NUMB := UNKN;
      END;
END;


  PROCEDURE INITADJCL (TOKEN : STR115;
          (*=========*)VAR CLASS : INTEGER;
                       VAR GEND : GENDER;
                       VAR NUMB : NUMBER);
    VAR
      N : INTEGER;
      STEM : STR115;

  BEGIN
    CLASS := 0;
    DEFINE_SUFS (TOKEN, N);
    IF N > 0
      THEN
        BEGIN
          STEM := COPY (TOKEN, 1, LENGTH (TOKEN) - LENGTH (SUFS [N]));
          CLASSADJ (STEM, N, CLASS, GEND, NUMB);
        END;
  END;

  FUNCTION PSEUDOADJ (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      MAX = 4;
      PSEUDOS : ARRAY [1..MAX] OF STRING [18] =
  ('‚›CŽŠŽƒŽ Š€—…‘’‚€','‚’ŽŽ‰ ‘’……ˆ',
   '…‚Ž‰ ‘’……ˆ','…—€‹œŽ‰ €ŒŸ’ˆ');
    VAR
      I : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (TOKEN = PSEUDOS[I]);
    UNTIL FOUND OR (I = MAX);
    PSEUDOADJ := FOUND;
  END;

  FUNCTION ISINS (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      INSFIN : ARRAY [1..6] OF STR2 =
        ('ŽŒ','…Œ','Ž‰','…‰','œž','Œˆ');
    VAR
      I, L, L1 : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    L := LENGTH (TOKEN);
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      L1 := LENGTH (INSFIN [I]);
      FOUND := (INSFIN [I] = COPY (TOKEN, L-L1+1, L1));
    UNTIL FOUND OR (I = 6);
    ISINS := FOUND;
  END;


  FUNCTION ISGEN (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      MAX = 12;
      GENFIN : ARRAY [1..MAX] OF STR2 =
        ('€','Ÿ','›','ˆ','‰','ƒŽ','Ž‚','…‚','›•','ˆ•','ŽŠ','…Š');
    VAR
      I, L, L1 : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    L := LENGTH (TOKEN);
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      L1 := LENGTH (GENFIN [I]);
      FOUND := (GENFIN [I] = COPY (TOKEN, L-L1+1, L1));
    UNTIL FOUND OR (I = MAX);
    ISGEN := FOUND
      AND (TOKEN <> 'Ž‘’€Ž‚Š€') AND (TOKEN <> '‹Ž‡€')
      AND (TOKEN <> '‚›‹€’›') AND (TOKEN <> '‘‹“—€ˆ')
      AND (TOKEN <> '‚‡Ž‘›') AND (TOKEN <> '‘’ˆ‹ˆ')
      AND (TOKEN <> 'ˆ‘’“Œ…’›') AND (TOKEN <> '€‘€Œ‹ˆ')
      AND (TOKEN <> 'Œ€˜“’›') AND (TOKEN <> 'Ž‹…‡ˆ')
      AND (TOKEN <> 'Žƒ€›') AND (TOKEN <> 'ˆ’…‚€‹›')
      AND (TOKEN <> '‚ˆ€') AND (TOKEN <> '€‚€')
      AND (TOKEN <> '’…•ˆŠ€') AND (TOKEN <> '“‘’€Ž‚Š€')
      AND (TOKEN <> '€‘’€') AND (TOKEN <> 'Ž’…‡›')
      AND (TOKEN <> '“‹ˆŠ€') AND (TOKEN <> '€’ˆ‘’›')
      AND (TOKEN <> '…”ŽŒ€') AND (TOKEN <> '”Ž„›')
      AND (TOKEN <> 'ƒ€ŒŽ’€') AND (TOKEN <> '†€›')
      AND (TOKEN <> 'Ž—€’ŽŠ') AND (TOKEN <> '•‹ŽœŸ')
      AND (TOKEN <> 'ˆ‡„…‹ˆŸ') AND (TOKEN <> '‡€Ž‹…‚€ˆŸ')
      AND (TOKEN <> 'Ž„“Š–ˆŸ') AND (TOKEN <> 'Žˆ‡‚…„…ˆŸ')
      AND (TOKEN <> '‘ŽŠ') AND (TOKEN <> '’ŽŠ')
      AND (TOKEN <> '^˜’€’›') AND (TOKEN <> '“Œ€ƒˆ')
      AND (TOKEN <> 'ŽŸ„›') AND (TOKEN <> 'Š€—…‘’‚€')
      AND (TOKEN <> '—…‹Ž‚…Š') AND (TOKEN <> '‹ž„ˆ')
      AND (TOKEN <> 'Œ€’…ˆ€‹›') AND (TOKEN <> '—ˆ‘‹€')
      AND (TOKEN <> 'ŒŽ–ˆˆ');
  END;


  FUNCTION SIMGEN (TOKEN : STR115) : BOOLEAN;
         (*======*)
    CONST
      GENFIN1 : ARRAY [1..6] OF STR2 =
   ('ƒŽ','Ž‰','…‰','›•','ˆ•','…•');
    VAR
      I : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (POS (GENFIN1 [I] + BL, TOKEN) > 0);
    UNTIL FOUND OR (I = 6);
    SIMGEN := FOUND;
  END;


  FUNCTION INCLUDES_PREPOS (TOKEN : STR115) : BOOLEAN;
         (*===============*)
    CONST
      MAX = 24;
      PREPOS : ARRAY [1..MAX] OF STRING [6] =
    ('‚','‚Ž','‚ŽŠ“ƒ','‚›˜…','‘','‘Ž','€','ˆ‡','…‡','Ž’','Ž','Ž','Š€Š',
    'Š','ŠŽ','„Ž','„‹Ÿ','‡€','Ž’ˆ‚','‘…„ˆ','ˆ†…','Ž„','ˆ','“');

    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := COPY (TOKEN, 1, LENGTH (PREPOS [I]) + 1) = PREPOS [I] + BL;
    UNTIL FOUND OR (I = MAX);
    INCLUDES_PREPOS := FOUND;
  END;


  FUNCTION IS_ADV_ADJ (TOKEN : STR115) : BOOLEAN;
         (*==========*)
    CONST
      MAX = 48;
      ADV_ADJ : ARRAY [1..MAX] OF STR15 =
('‚ŽŠ','‚ˆ‡','‚ˆ‡“','‚‚…•“','‚‹…‚Ž','‚Œ…‘’…',
'‚“’ˆ','‚“’œ','‚Ž‚…ŒŸ','‚……„','‚€‚Ž','‚Ž‡œ',
'„€‹œ˜…','…™…','ˆ‡“’ˆ','ˆŒ…Ž','‹…‚……','‹ˆ˜œ',
'€‚…•','€„‚Ž…','€…„ˆ…','€‡€„','€Š€“…','€“†ˆ',
'Ž‹ˆ‡Ž‘’ˆ','Ž‚‘ž„“','Ž‚›˜…','Ž„€‹œ˜…',
'Ž…‚Ž‹…','Ž‹Ž‘’œž','Ž‘……„ˆ…','Ž—ˆ™…','Ž‘’Ž',
'Ž‚Ž','‘ŽŠ“','‘‚…•“','C‡€„ˆ','‘‹…‚€','‘ˆ„Ÿ',
'‘ˆ‡“','‘€“†ˆ','‘ˆ‡“','‘Ž‚‘…Œ','‘……„ˆ','‘€‚€',
'’Ž‹œŠŽ','—ˆ™…','Ÿ‚Ž');
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;
  BEGIN
    I := 0;
    FOUND := FALSE;
    REPEAT
      INC (I);
      FOUND := (TOKEN = ADV_ADJ[I]);
    UNTIL FOUND OR (I = MAX);
    IS_ADV_ADJ := FOUND;
  END;

   (* …‘’œ ‹ˆ “ „€ŽƒŽ Š‹€‘‘€ Ž„“˜…‚‹…›‰ €€‹Žƒ ˆ Š€ŠŽ‰? *)
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
{ ELSE WRITELN ('WRONG INANIMATE CLASS: ', CLASS);}
END;


BEGIN      (* MAIN *)
  GLOBAL_INIT;

  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' THEN
    XL_DAS := '../DAS/';

  FOR ST := ZERO TO ADV DO
    BEGIN
      COUNT [ST] := 0;
      TCOUNT [ST] := 0;
    END;
  HEADER := DUMMY;
  CURNUM := 0;
  SUPER := 0;
  FOR STG := UNRZD TO CONJD DO
    STAG_CNT [STG] := 0;

  ASSIGN (INP, XL_DAS+'CLASS17.DAS');
  RESET (INP);
  FOR I := 1 TO OYMAX DO
    READLN (INP, CLASS17 [I]);
  READLN (INP, BUF);
  IF BUF <> 'XL_EOF' THEN
    RUNERROR (255);
  CLOSE (INP);

  ASSIGN (INP, XL_DAS+'CLA0018.DAS');
  RESET (INP);
  FOR I := 1 TO XOYMAX DO
    READLN (INP, CLA0018 [I]);
  READLN (INP, BUF);
  IF BUF <> 'XL_EOF' THEN
    RUNERROR (254);
  CLOSE (INP);

  ASSIGN (INP, XL_DAS+'CLA0107.DAS');
  RESET (INP);
  FOR I := 1 TO IYMAX DO
    READLN (INP, CLA0107 [I]);
  READLN (INP, BUF);
  IF BUF <> 'XL_EOF' THEN
    RUNERROR (253);
  CLOSE (INP);

  ASSIGN (INP, 'DERIVAT.TXT');
  RESET (INP);

  ASSIGN (OUT, 'DERIV.COD');
  REWRITE (OUT);

  ASSIGN (OUT_YM, 'BE_YM.TXT');
  REWRITE (OUT_YM);

  ASSIGN (OUT_OM, 'BE_OM.TXT');
  REWRITE (OUT_OM);

  ASSIGN (OUT_OY, 'BE_OY.TXT');
  REWRITE (OUT_OY);

{  ASSIGN (OUT1, 'DER1.TXT');
  REWRITE (OUT1);

  ASSIGN (OUT2, 'DER2.TXT');
  REWRITE (OUT2);

  ASSIGN (OUT3, 'DER3.TXT');
  REWRITE (OUT3);

  ASSIGN (OUT4, 'DER4.TXT');
  REWRITE (OUT4); }

  LINENUM := 0;
  CURSTAT := ZERO;
  CURNUM := 0;
  TAKEIT := FALSE;

  REPEAT
    INC (LINENUM);
    READLN (INP, LINE);
    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN ('ERROR: Unnecessary final blank at line ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;
    IF (LINE = DUMMY)
      THEN
        BEGIN
          WRITELN ('ERROR: Empty line ', LINENUM);
          HALT;
        END;
    IF (LENGTH (LINE) < 4)
      THEN
        BEGIN
          IF (LINE <> 'ye') AND (LINE <> 'no')
            THEN
              BEGIN
                WRITELN ('ERROR: Wrong group starter at line ', LINENUM);
                HALT;
              END
            ELSE IF (LINE = 'ye')
              THEN TAKEIT := TRUE
              ELSE TAKEIT := FALSE;
          IF (CURSTAT <> ADV) AND (LINENUM > 1)
            THEN WRITELN ('ERROR: False label at line ', LINENUM);
          CURSTAT := ZERO;
          IF CURNUM > 0
            THEN INC (SUPER, (CURNUM - 1) * CURNUM);
          CURNUM := 0;
        END
      ELSE
        BEGIN
          INC (CURNUM);
          INIT := COPY (LINE, 1, 2);
          CASE CURSTAT OF
            ZERO: IF INIT = 'Su'
                    THEN
                      BEGIN
                        CURSTAT := SUB;
                        HEADER := COPY (LINE, 4, LENGTH (LINE) - 3);
                        NCOUNT := 0;
                      END
                    ELSE
                      IF INIT <> BL2
                        THEN WRITELN ('ERROR1: False label sequence at line ',
                          LINENUM);
            SUB : IF INIT = 'Ve'
                    THEN CURSTAT := VERB
              {}  ELSE IF INIT = 'Aj'
                    THEN CURSTAT := ADJ   {}
                    ELSE
                      IF INIT <> BL2
                        THEN WRITELN ('ERROR2: False label sequence at line ',
                          LINENUM);
            VERB: IF INIT = 'Aj'
                    THEN CURSTAT := ADJ
                    ELSE
                      IF INIT <> BL2
                        THEN WRITELN ('ERROR3: False label sequence at line ',
                          LINENUM);
            ADJ : IF INIT = 'Av'
                    THEN CURSTAT := ADV
                    ELSE
                      IF INIT <> BL2
                        THEN WRITELN ('ERROR4: False label sequence at line ',
                          LINENUM);
            ADV : IF INIT <> BL2
                    THEN WRITELN ('ERROR5: False label sequence at line ',
                      LINENUM);
          END;
          IF EOF (INP)
            THEN INC (SUPER, (CURNUM - 1) * CURNUM);
        END;
    INC (COUNT [CURSTAT]);

    IF CURSTAT <> ZERO
      THEN
        BEGIN
          NOM := BL;
          TAIL := COPY (LINE, 4, LENGTH (LINE) - 3);
          P := POS ('<', TAIL);                            (* DM *)
          IF P > 0                                         (* DM *)
            THEN                                           (* DM *)
              BEGIN                                        (* DM *)
                COMMENT := COPY(TAIL,P,LENGTH(TAIL)-P+1);  (* DM *)
                TAIL := COPY(TAIL,1,P-1);                  (* DM *)
              END                                          (* DM *)
            ELSE COMMENT := '';                            (* DM *)
          P := POS ('1', TAIL) + POS ('2', TAIL) + POS ('3', TAIL)
            + POS ('4', TAIL) + POS ('5', TAIL) + POS ('6', TAIL);
          IF P > 0
            THEN
              BEGIN
                NOM := TAIL [P];
                TAIL := COPY (TAIL, 1, P - 1);
              END;

          CLASS := 0;
          DOUBLE_KEY := FALSE;
          INVERSE_KEY := FALSE;
        END;

    CASE CURSTAT OF
      
      SUB :
        BEGIN
          INC (NCOUNT);
          IF NOM <> BL
            THEN TAIL := TAIL + NOM;
          PARSENOUN (TAIL, NOUN, CLS1, CLS2, NUM0, GND0, STG);
          TAIL := NOUN;
          INC (STAG_CNT [STG]);
        END;
      
      VERB:
        BEGIN
          TOKEN := TAIL;
          P := POS (BL, TOKEN);
          IF (P > 0) AND (COPY (TOKEN, 1, P-1) = '…')
             THEN TOKEN := COPY (TOKEN, P+1, LENGTH(TOKEN)-3);

          P := POS (BL, TOKEN);
          IF (P > 0)
            THEN
              BEGIN
                TOK1 := COPY (TOKEN, 1, P-1);
                DOUBLE_KEY := TRUE;
              END
            ELSE
              BEGIN
                TOK1 := TOKEN;
                DOUBLE_KEY := FALSE;
              END;

          INITVERBCL (TOK1, CLASS, VALID);
          IF (TOK1 = 'Ž‹…’œ') AND (NOM = '3')
            THEN CLASS := 41;
          IF NOT VALID
            THEN WRITELN ('ERROR: DOUBTFUL VERB ', TOKEN, 
              ' IN LINE ', LINENUM);
          INC (TCOUNT [VERB], ORD (VALID));

          IF (P > 0) AND (TOK1 = '›’œ') 
            THEN 
              BEGIN
                FIN2 := COPY (TOKEN, LENGTH(TOKEN)-1, 2);
                IF (FIN2 = '›Œ') OR (FIN2 = 'ˆŒ')
                  THEN WRITELN (OUT_YM, TOKEN)
                ELSE IF (FIN2 = 'ŽŒ') OR (FIN2 = '…Œ')
                  THEN WRITELN (OUT_OM, TOKEN)
                ELSE IF (FIN2 = 'Ž‰') OR (FIN2 = '…‰')
                  THEN WRITELN (OUT_OY, TOKEN);
              END;
        END;
      
      ADJ :
        BEGIN
          TOKEN := TAIL;
          L := LENGTH(TOKEN);
          DONE := FALSE;
          CLS1 := 0; 
          CLS2 := 0;
          SHRTCLS1 := 0; 
          SHRTCLS2 := 0;
          
          P := POS (BL, TOKEN);
          IF (P = 0)
            THEN  { TOKEN doesn't contain blanks, but maybe underscore }
              BEGIN
                PU := POS ('_', TOKEN);
                IF (PU = 0)
                  THEN   { TOKEN doesn't contain underscore sign }
                    BEGIN
                      TRY_SINGLE_SHORT (TOKEN, SHRTCLS1);
                      IF SHRTCLS1 > 0
                        THEN 
                          BEGIN
                            CLS2 := 255;
                            DONE := TRUE;
                          END;
                      IF NOT DONE
                        THEN 
                          IF IS_ADV_ADJ(TOKEN) OR COMPARATIV(TOKEN) 
                            OR (COPY(TOKEN, 1, 3) = 'Ž-') 
                            OR (TOKEN = 'Ž‹ˆ‡Ž‘’ˆ')
                            THEN 
                              BEGIN
                                CLS2 := 255;
                                DONE := TRUE;
                              END;
                      IF NOT DONE
                        THEN
                          BEGIN
                            INITADJCL (TOKEN, CLS1, GEND, NUMB);
                            CLS2 := 255;
                            DONE := TRUE;
                          END;
                      IF NOT DONE
                        THEN
                          BEGIN
                            WRITELN ('ERROR: Dubious adjective ', TOKEN);
                            HALT;
                          END;        
                    END
                  ELSE   { TOKEN contains underscore sign }
                    BEGIN
                      TOK1 := COPY(TOKEN, 1, PU-1);
                      TOK2 := COPY(TOKEN, PU+1, L-PU);
                       
                      TRY_SINGLE_SHORT (TOK1, SHRTCLS1);
                      TRY_SINGLE_SHORT (TOK2, SHRTCLS2);
                    
                      IF ((SHRTCLS1 > 0) OR (COPY(TOKEN, PU-2, 2) = '›Œ'))
                        AND (SHRTCLS2 > 0)
                        THEN
                          BEGIN
                            CLS2 := 255;
                            TOKEN[PU] := '-';
                            DONE := TRUE;
                          END;
                      IF NOT DONE
                        THEN
                          BEGIN
                            INITADJCL (TOK1, CLS1, GEND, NUMB);
                            INITADJCL (TOK2, CLS2, GEND, NUMB);
                            TOKEN[PU] := '-';
                            DONE := TRUE;
                          END;
                      IF {DONE AND ((CLS1 = 0) OR (CLS2 = 0)) OR} NOT DONE
                        THEN
                          BEGIN
                            WRITELN ('ERROR: Dubious adjective ', TOKEN);
                          {  HALT; }
                          END;        
                    END;
              END
            ELSE   { TOKEN includea at least one blank }
              BEGIN
                IF PSEUDOADJ (TOKEN) OR
                  INCLUDES_PREPOS (TOKEN)
                  OR SIMGEN (TOKEN)
                  THEN
                    BEGIN
                      CLS2 := 255;
                      DONE := TRUE;
                    END;
                IF NOT DONE
                  THEN
                    BEGIN
                      TOK1 := COPY(TOKEN, 1, P-1);
                      TOK2 := COPY(TOKEN, P+1, L-P);
                      INITADJCL (TOK1, CLS1, GEND, NUMB);
                      INITADJCL (TOK2, CLS2, GEND , NUMB);

                      IF NOT DONE AND (CLS1 > 0) 
                        AND ((COPY(TOK2, LENGTH(TOK2)-1, 2) = 'Ž‰') 
                          OR (TOK2 = '€„‚Ž…'))
                        THEN
                          BEGIN
                             CLS2 := 0;
                             DONE := TRUE;
                          END;
                      IF NOT DONE AND (TOK1 = '…')
                        THEN
                          BEGIN
                             CLS1 := CLS2;
                             CLS2 := 255;
                             DONE := TRUE;
                          END;
                      IF NOT DONE AND 
                        (((CLS1 > 0) AND (CLS2 = 0)) OR
                        ((CLS1 = 0) AND (CLS2 > 0)))
                        THEN DONE := TRUE;
                    END;

                IF NOT DONE
                  THEN
                    BEGIN
                      WRITELN ('ERROR: Dubious adjective ', TOKEN);
                    END;
              END;              
          INC (TCOUNT [ADJ]);
        END;
      
      ADV :
        BEGIN
          FOUND := FALSE;
          K := 0;
          REPEAT
            INC (K);
            L2 := LENGTH (ADVS [K]);
            FOUND := (ADVS [K] + BL = COPY (TAIL, 1, L2 + 1));
          UNTIL FOUND OR (K = 12);
          DOUBLE_KEY := FOUND;
        END; 

      ELSE ; 

    END;  (* CASE CURSTAT *)

    IF (CURSTAT <> ZERO) AND (TAIL <> DUMMY)
      THEN
        BEGIN
          WRITE (OUT, ORD (CURSTAT));
          CASE CURSTAT OF
            SUB :
              BEGIN
                {IF TAKEIT THEN WRITELN (OUT1, TAIL);}
                WRITELN (OUT, CLS1:4, CLS2:4, ORD(NUM0):2, ORD(GND0):2, 
                  BL, TAIL);
              END;
            VERB :
              BEGIN
                {IF TAKEIT THEN WRITELN (OUT2, TAIL);}
                IF DOUBLE_KEY
                  THEN
                    IF INVERSE_KEY
                      THEN WRITE (OUT, {CLASS2} '0' : 4, CLASS:4)
                      ELSE WRITE (OUT, CLASS : 4, '0' : 4)
                  ELSE WRITE (OUT, CLASS : 4, '255' : 4);
                WRITE (OUT, ORD (NUMB) * ORD (CURSTAT = SUB) : 2,
                  ORD (GEND) * ORD (CURSTAT = SUB) : 2, BL, TAIL);
                IF NOM <> BL
                  THEN WRITELN (OUT, NOM)
                  ELSE WRITELN (OUT);
              END;
            ADJ :
              BEGIN
                {IF TAKEIT THEN WRITELN (OUT3, TAIL);}
                WRITE (OUT, CLS1 : 4, CLS2 : 4, 
                  SHRTCLS1 : 2, SHRTCLS2 : 2, BL, TOKEN);
                IF NOM <> BL
                  THEN WRITELN (OUT, NOM)
                  ELSE WRITELN (OUT);
              END;
            ADV :
              BEGIN
                {IF TAKEIT THEN WRITELN (OUT4, TAIL);}
                WRITE (OUT, '0' : 4);
                IF DOUBLE_KEY
                  THEN WRITE (OUT, '0' : 4)
                  ELSE WRITE (OUT, '255' : 4);
                WRITE (OUT, '0' : 2, '0' : 2, BL, TAIL);
                IF NOM <> BL
                  THEN WRITELN (OUT, NOM)
                  ELSE WRITELN (OUT);
              END;
          END;  (* CASE *)
        END;
  UNTIL EOF (INP);

  CLOSE (INP);

  FLUSH (OUT);
  FLUSH (OUT_YM);
  FLUSH (OUT_OM);
  FLUSH (OUT_OY);

  WRITELN ('File DERIV.COD output');

  TOTAL := COUNT [SUB] + COUNT [VERB] + COUNT [ADJ] + COUNT [ADV];
  WRITELN ('==      NUMBER OF GROUPS = ', COUNT [ZERO]:5);
  WRITELN ('   TOTAL DERIVATE NUMBER = ', TOTAL);
  WRITELN ('       MEAN GROUP LENGTH = ', TOTAL / COUNT [ZERO] : 5 : 2);
  WRITELN ('  DERIVATE LINKS TOTAL = ', SUPER : 6);
{ WRITELN ('== NOUNS FOUND IN: ');
  FOR STG := UNRZD TO CONJD DO
    IF STAG_CNT [STG] > 0
      THEN WRITELN (BL : 4, STAG_NAME[STG] : 6, 
        ' = ', STAG_CNT [STG] : 6);
  WRITELN ('NUMBER OF NOUNS = ', COUNT [SUB]);
  WRITELN ('NUMBER OF VERBS = ', COUNT [VERB]);
  WRITELN ('NUMBER OF ADJECTIVES = ', COUNT [ADJ]);
  WRITELN ('NUMBER OF ADVERBS = ', COUNT [ADV]);  }
END.
