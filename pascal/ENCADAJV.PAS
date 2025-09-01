PROGRAM ENCADJV;

USES DOS, CLASTABL, INITVER4;

  VAR XL_DAS, BUF : STRING [255];

  TYPE
    STR115 = STRING [115];
    STR6 = STRING [6];
    STR5 = STRING [5];
    STR2 = STRING [2];
    STR4 = STRING [4];
    STR15 = STRING [15];
    STATUS = (ZERO, SUB, VERB, ADJ, ADV);
    VSTAGE = (ANY, BASHOM, BASNHM, NBASIC);
    RESTYPE=(LT,EQ,GT);

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    BL = ' ';
    MAXVERB = 22000;
    VSTAG_NAME : ARRAY [VSTAGE] OF STR6 = 
      ('ANY   ','BASHOM','BASNHM','NBASIC');
    PARTMAX = 80;
    SUFS : ARRAY [1..53] OF STRING [4] =
      ('›‰', 'ˆ‰', 'Ž‰', 'ˆ‰‘Ÿ', '€Ÿ', 'ŸŸ', '€Ÿ‘Ÿ', 'Ž…', '……',
      '……‘Ÿ', '›…', 'ˆ…', 'ˆ…‘Ÿ', 'œŸ', 'œ…', 'œˆ', 'ŽŸ', 'Žˆ',
      '€˜', '€˜€', '€˜…', '€˜ˆ', 'ˆ', 'ˆ€', 'ˆŽ', 'ˆ›',
      '…‘œ', '‘Ÿ', '‘…', 'Ž’', '‚', '‚€', '‚Ž', '‚›',
      '›€', '›Ž', 'ˆ', '€Œ', '€Œ€', '€ŒŽ', '€Œˆ', '€', 'Ž', '…',
      '…œ', 'Ÿ', '…', '…‰', 'ˆ', '›', '€', 'Ž', '››');

  VAR
    CLASS, CL, CL2, P, P0 : INTEGER; 
    I{, J, STYL} : INTEGER;
    INP, OUT, OUT1 : TEXT;
    LINE, TOKEN : STR115;
    AMTADJ, AMTV, LINENUM, VERB_REACHED : INTEGER;
    GND : GENDER;
    NMB :NUMBER;
    CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ‹žŽ‰ *)
    CLA0018 : ARRAY [1..57] OF STR15;  (* ‘“•Ž‰ *)
    CLA0107 : ARRAY [1..IYMAX] OF STR15; (* ”€‡€ˆ‰ *)
{   USECOUNT : ARRAY [1..5] OF WORD;
    USACH : CHAR;}
    VSTG : VSTAGE;
    VSTAG_CNT : ARRAY [VSTAGE] OF INTEGER;
    VERBSTR : ARRAY [1..MAXVERB] OF STR115;   { basic verb strings }

{ Compare two strings }
PROCEDURE COMPARE_TOK (TOK1,TOK2:STRING;
        (*===========*)VAR RESULT:RESTYPE);
BEGIN
  IF TOK1 < TOK2
    THEN RESULT := LT
    ELSE
      IF TOK1 > TOK2
        THEN RESULT := GT
        ELSE RESULT := EQ;
END;

{ Initialization of basic verbs array }
PROCEDURE FILL_BASE_VERBS;
        (*===============*)
VAR
  I : INTEGER;
  INP : TEXT;
BEGIN
  ASSIGN (INP, 'BASICSV.LST');
  RESET (INP);
  I := 0;
  REPEAT
    READLN (INP, VERBSTR [I]);
    INC(I);
  UNTIL EOF(INP) OR (I = MAXVERB);
  VERB_REACHED := I;
  CLOSE (INP);
  WRITELN ('BASVERBS are ', VERB_REACHED);
END;

{ TOKEN is among basic verbs }
FUNCTION IN_BASIC_VERBS (TOKEN : STR115) : BOOLEAN;
        {==============} 
VAR
  LOW, HIGH, MID : INTEGER;
  FOUND : BOOLEAN;
  RES : RESTYPE;
BEGIN
  FOUND := FALSE;
  LOW := 1;
  HIGH := VERB_REACHED;
  WHILE (HIGH >= LOW) AND NOT FOUND DO
    BEGIN
      MID := (HIGH + LOW) DIV 2;
      COMPARE_TOK (TOKEN, VERBSTR [MID], RES);
      CASE RES OF
        LT : HIGH := MID - 1;
        EQ : FOUND := TRUE;
        GT : LOW := MID + 1;
      END;
    END;
  IN_BASIC_VERBS := FOUND;
END;

  { Classify verb to VERBCL }
PROCEDURE CLASSIFY_VERB (VTOK : STR115;
         {=============} VAR VERBCL : INTEGER);
  VAR
    L : INTEGER;
    TMPV : STR115;
    VALID : BOOLEAN;
    NOM : CHAR;
BEGIN
  L := LENGTH (VTOK);
  IF (POS (VTOK [L], '123456') > 0)
    THEN 
      BEGIN
        TMPV := COPY (VTOK, 1, L-1);
        NOM := VTOK [L];
      END
    ELSE
      BEGIN
        TMPV := VTOK;
        NOM := BL;
      END;

  IF (NOM = BL)
    THEN
      BEGIN
        IF IN_BASIC_VERBS (VTOK)
          THEN VSTG := BASNHM
          ELSE 
            BEGIN
              VSTG := NBASIC;
              IF VTOK <> '‚…‘’ˆ' 
                THEN WRITELN (OUT1, VTOK);
            END;
        INC (VSTAG_CNT[VSTG]);
        IF IN_BASIC_VERBS (VTOK + '1') AND (TMPV <> '‚…‘’ˆ')
          THEN WRITELN ('ERROR: Supply ', VTOK, 
            ' with homo number in line ', LINENUM);
     END
       ELSE
         IF IN_BASIC_VERBS (VTOK)
           THEN 
             BEGIN
               VSTG := BASHOM;
               INC (VSTAG_CNT[VSTG]);
             END
           ELSE WRITELN ('ERROR: Insert ', VTOK, 
            ' in line ', LINENUM, ' to BASICSV');

  IF POS ('… ', TMPV) = 1
    THEN TMPV := COPY (TMPV, 4, LENGTH (TMPV)-3);
  VALID := TRUE;

  IF ((TMPV = '„Ž•“’œ') OR (TMPV='‡€€•“’œ')) AND (NOM = '2')
    OR (TMPV = '‘„Ž•“’œ')
    THEN VERBCL := 10
  ELSE IF ((TMPV='Ž‹…’œ') OR (TMPV='‡€Ž‹…’œ')) AND (NOM = '3')
    THEN VERBCL := 41
  ELSE IF (TMPV='‘†€’œ') AND (NOM = '2')
    THEN VERBCL := 169
  ELSE IF (TMPV='‘…‡€’œ') AND (NOM = '2')
    THEN VERBCL := 3
  ELSE IF ((TMPV='ˆ‘€’œ') OR (TMPV='€ˆ‘€’œ')) AND (NOM = '3')
    THEN VERBCL := 3
  ELSE INITVERBCL (TMPV, VERBCL, VALID);

  IF NOT VALID AND (TMPV <> '‚…‘’ˆ') AND (TMPV <> '›’œ')
    THEN WRITELN (' ERROR: Dubious verb ', TMPV, ' in line ', LINENUM); 
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
    8..10, 15, 21, 25, 29, 33, 36, 40, 43, 47 : GEND := NEUT;
    11..13, 16, 18, 22, 26, 34, 37, 41, 44, 49 :
      BEGIN GEND := COMN; NUMB := PLUR; END;
  END;

  L := LENGTH (STEM);
  LAST := STEM [L];

  CASE FLEX_NUM OF
    0 : CLASS := 0;
    1 : (* -›‰ *)
      CASE LAST OF
        '' :
          IF STEM [L-1] = ''
            THEN CLASS := 1
          ELSE IF (POS (STEM [L-1], SONOR) > 0)
            THEN CLASS := 9
            ELSE CLASS := 2;
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
         OR (STEM = '€’') OR (STEM = '†…') OR (STEM = 'ˆ“„') 
         OR (STEM = 'Š“Š“˜Š') OR (STEM = '‹€‘’Ž—Š') OR (STEM = '€')
         OR (STEM = 'Œ€Œ') OR (STEM = 'Œ€Œ…œŠ') OR (STEM = 'Œ€’“˜Š')
         OR (STEM = 'Œ€’›˜Š') OR (STEM = 'Œ€’…') OR (STEM = 'Œ“†')
         OR (STEM = '‘…‘’') OR (STEM = '‘“Š') OR (STEM = '‘“—Š') 
         OR (STEM = '‘’€“•') OR (STEM = '™“Š') OR (STEM = '„Ÿ„') 
         OR (STEM = '’…’') OR (STEM = '’…’Š') OR (STEM = '’ˆ˜Š')
         OR (STEM = '˜€€˜Š') OR (STEM = '^˜…ŒŸŠ') OR (STEM = '”ˆ‹œŠ')
         OR (STEM = '„…„“˜Š') OR (STEM = '…‚…‘’Š')
           THEN CLASS := 17
           ELSE CLASS := 0;
    27..29 : (* -…‘œ/-‘Ÿ/-‘… *)
      IF (STEM = '‚')
        THEN CLASS := 15
        ELSE CLASS := 0;
    30,42,43 :  (* -Ž’/-€/-Ž *)
      IF (STEM = '’')
        THEN CLASS := 13
      ELSE IF (STEM = '’')
        THEN CLASS := 14
        ELSE CLASS := 0;
    31..34 : (* -‚/-‚€/-‚Ž/-‚› *)
      IF (STEM = '^•ˆ‘’Ž') OR (STEM = '€‚ƒˆ…')
      OR (STEM = '€„Ž') OR (STEM = '€ˆ€‹Ž')
      OR (STEM = '€„€ŒŽ') OR (STEM = '€’ŽŽ')
      OR (STEM = '€•ˆŒ…„Ž') OR (STEM = '€•ˆ‹‹…‘Ž')
      OR (STEM = '€‰…‘Ž') OR (STEM = 'ˆŠ”Ž„Ž') 
      OR (STEM = '€’Ž') OR (STEM = '…’Ž‹…’Ž')
      OR (STEM = '“‹…') OR (STEM = '^€…–…')
      OR (STEM = '^‚Ž‹œ’…Ž') OR (STEM = '^‚€‹’€‘€Ž')
      OR (STEM = '^‚€‹œ“ƒˆ…') OR (STEM = '‚Ž‹œ’Ž')
      OR (STEM = '‚ŽŽŽ')
      OR (STEM = 'ƒ€‰ŒŽŽ') OR (STEM = 'ƒ€‹…Ž')
      OR (STEM = '^ƒ€ˆ€‹Ž') OR (STEM = 'ƒ€“‘‘Ž')
      OR (STEM = 'ƒ…€Š‹Ž') OR (STEM = 'ƒ…Ž‘’€’Ž')
      OR (STEM = 'ƒ…Š“‹…‘Ž') OR (STEM = '^ƒ…Š“‹…‘Ž')
      OR (STEM = 'ƒŽ„ˆ…') OR (STEM = 'ƒ‹€“…Ž')
      OR (STEM = '„…Š€’Ž') OR (STEM = '^„€’Ž') OR (STEM = '„€ŒŽŠ‹Ž') 
      OR (STEM = '„…„Ž')  OR (STEM = '„€ŠŽŽ')
      OR (STEM = '…‚Š‹ˆ„Ž') OR (STEM = 'Š…‘€…')
      OR (STEM = 'Š€ˆŽ') OR (STEM = 'ŠŽ™……')
      OR (STEM = '^Š…‰–…Ž') OR (STEM = 'ŠŽŠŽ„ˆ‹Ž')
      OR (STEM = '‹€‹€‘Ž') OR (STEM = '‹“ŠŠ“‹Ž')
      OR (STEM = '……‚Š‹ˆ„Ž') OR (STEM = '…’“Ž')
      OR (STEM = 'Ž’–Ž') OR (STEM = 'Ž…')
      OR (STEM = 'ˆ”€ƒŽŽ') OR (STEM = 'ŽŠ“‘’Ž')
      OR (STEM = 'ˆŽ') OR (STEM = 'ˆŒ€Ž')
      OR (STEM = '‘€Œ‘ŽŽ') OR (STEM = '‘ˆ‡ˆ”Ž')
      OR (STEM = '‘”ˆŠ‘Ž') OR (STEM = '‘Ž‹ŽŒŽŽ')
      OR (STEM = '‘›Ž') OR (STEM = '’€’€‹Ž')
      OR (STEM = '’Žˆ—…‹‹ˆ…') OR (STEM = '”€‹‹Žˆ…')
      OR (STEM = '•€ŒŽ') OR (STEM = '—…’Ž') 
      OR (STEM = '‡ŽŽ')
        THEN CLASS := 18
        ELSE CLASS := 0;
{!} 35,36 : (* -€/-Ž *)
      IF (STEM = 'Ž„')
        THEN CLASS := 16
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
    44 : (* -… *)
      IF (STEM = '’')
        THEN CLASS := 13
        ELSE CLASS := 0;
    45,46,47 : (* -…œ/-Ÿ/-… *)
      IF (STEM = 'ƒŽ‘Ž„')
        THEN CLASS := 21
        ELSE CLASS := 0;
    48 : (* -…‰ *)
      IF (STEM = '—') OR (STEM = 'ˆ—') OR (STEM = 'ŠŽ…-—')
        THEN CLASS := 20
        ELSE CLASS := 0;
    49 : (* -ˆ *)
      IF (STEM = '’')
        THEN CLASS := 14
{!}     ELSE CLASS := 0;
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
      N, P : INTEGER;
      STEM, TKN : STR115;

  BEGIN
    CLASS := 0;
    IF (POS ('… ', TOKEN) = 1) OR (POS ('ˆ ', TOKEN) = 1)
      OR (POS ('ˆ ', TOKEN) = 1) OR (POS ('ˆ‹ˆ ', TOKEN) = 1)
      THEN
        BEGIN
          P := POS (BL, TOKEN);
          TKN := COPY (TOKEN, P+1, LENGTH (TOKEN) - P);
        END
      ELSE TKN := TOKEN;

    IF LENGTH (TKN) < 3
      THEN EXIT;

    DEFINE_SUFS (TKN, N);
    IF N > 0
      THEN
        BEGIN
          STEM := COPY (TKN, 1, LENGTH (TKN) - LENGTH (SUFS [N]));
          CLASSADJ (STEM, N, CLASS, GEND, NUMB);
        END;
  END;

BEGIN      (* MAIN *)
     (* ˆˆ–ˆ€‹ˆ‡€–ˆŸ ……Œ…›• *)
  FILL_BASE_VERBS;

  AMTADJ := 0;
  AMTV := 0;
{  FOR J := 1 TO 5 DO
    USECOUNT [J] := 0;}
  LINENUM := 0;

  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' THEN
    XL_DAS := '../DAS/';

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

  WRITELN ('ADJVRB.TXT BEING PROCESSED');
  ASSIGN (INP, 'ADJVERB.TXT');
  RESET (INP);

  ASSIGN (OUT, 'ADJVERB.COD');
  REWRITE (OUT);

  ASSIGN (OUT1, 'VERBYADJ.LST');
  REWRITE (OUT1);

    (* Main cycle *)
  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);

    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN (' ERROR: Final blank in line ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;

    IF (LINE [1] <> BL)
      THEN   (* Adjective as group header *)
        BEGIN
          INC (AMTADJ);
          INITADJCL (LINE, CL, GND, NMB);
          WRITELN (OUT, '+ 3', CL : 4, '255' : 4,
            {'0' : 2, '0' : 2, '0' : 2,} BL, LINE);
        END
      ELSE           (* Verb as group component *)
        BEGIN
          INC (AMTV);

        {  USACH := LINE [2];
          STYL := POS (USACH, 'sqpm*');
          IF (USACH <> BL) AND (STYL = 0)
            THEN
              BEGIN
                WRITELN ('WRONG USAGE LABEL IN LINE ', LINE);
                HALT;
              END
           ELSE IF STYL > 0
             THEN INC (USECOUNT [STYL]);}

          LINE := COPY (LINE, 3, LENGTH (LINE) - 2);

          P0 := POS (BL, LINE);
          P := POS (BL, COPY (LINE, 4, LENGTH(LINE) - 3));
          IF (P0 = 0) OR (POS ('… ', LINE) = 1) OR (POS ('€ ', LINE) = 1)
            THEN
              BEGIN
                TOKEN := LINE;
                CL2 := 255;
                IF (POS ('€ ', LINE) = 1)
                  THEN WRITELN ('ERROR: Correct € to … in line ', LINENUM);
              END
          ELSE IF (P0 = 5) AND (LENGTH(LINE) > 6)
            THEN
              BEGIN
                TOKEN := COPY (LINE, 1, 4);
                CL2 := 0;
              END
          ELSE IF P > 1
            THEN
              BEGIN
                TOKEN := COPY (LINE, 1, P+2);
                CL2 := 0;
              END
          ELSE 
            BEGIN
              TOKEN := COPY (LINE, 1, P+2);
              CL2 := 0;
              WRITELN ('ERROR: Unknown situation in line ', LINENUM);
            END;

          CLASSIFY_VERB (TOKEN, CLASS);

          WRITELN (OUT, '- 2', CLASS : 4, CL2 : 4,
            {'0' : 2, '0' : 2, STYL : 2,} BL, LINE);
        END;
  UNTIL EOF (INP);

  FLUSH (OUT);
  FLUSH (OUT1);

  WRITELN (AMTADJ : 5, ' GROUPS HEADED BY ADJECTIVES');
  WRITELN (AMTV : 5,  ' ADJECTIVE-VERB COLLOCATIONS');
  WRITELN ('MEAN GROUP SIZE = ', AMTV / AMTADJ : 4 : 1);
  WRITELN ('== VERBS DISTRIBUTE TO: ');
   FOR VSTG := BASHOM TO NBASIC DO
     WRITELN (BL : 4, VSTAG_NAME[VSTG] : 5, ' = ', VSTAG_CNT [VSTG] : 5);
  WRITELN ('FILES ADJVERB.COD AND VERBYADJ.LST OUTPUT');

{  WRITELN;
  WRITELN (USECOUNT [1] : 3, ' SPECIALS');
  WRITELN (USECOUNT [2] : 3, ' COLLOQUIALS');
  WRITELN (USECOUNT [3] : 3, ' INDECENTS');
  WRITELN (USECOUNT [5] : 3, ' FORBIDDENS');}
END.
