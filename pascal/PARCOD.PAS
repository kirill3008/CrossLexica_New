PROGRAM PARCOD;

USES DOS, CLASTABL, INITVER4;

  VAR XL_DAS, BUF : STRING [255];

  TYPE
    STATUS = (ZERO, SUB, VERB, ADJ, ADV);
    STR2 = STRING [2];
    STR4 = STRING [4];
    STR15 = STRING [15];

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    MAXVERB = 22000;

    PARTMAX = 400;
    MAXBSN = 42000; { Increased !!! }

    SUFS : ARRAY [1..53] OF STRING [4] =
      ('›‰', 'ˆ‰', 'Ž‰', 'ˆ‰‘Ÿ', '€Ÿ', 'ŸŸ', '€Ÿ‘Ÿ', 'Ž…', '……',
      '……‘Ÿ', '›…', 'ˆ…', 'ˆ…‘Ÿ', 'œŸ', 'œ…', 'œˆ', 'ŽŸ', 'Žˆ',
      '€˜', '€˜€', '€˜…', '€˜ˆ', 'ˆ', 'ˆ€', 'ˆŽ', 'ˆ›',
      '…‘œ', '‘Ÿ', '‘…', 'Ž’', '‚', '‚€', '‚Ž', '‚›',
      '›€', '›Ž', 'ˆ', '€Œ', '€Œ€', '€ŒŽ', '€Œˆ', '€', 'Ž', 
      '…', '…œ', 'Ÿ', '…', '…‰', 'ˆ', '›', '€', 'Ž', '››');

  VAR
    I, J : INTEGER;
    SUPER, SUPER_POS, LINENUM, TOTAL, TOTAL_WOHOM : LONGINT;
    INP , OUT, OUT1, OUT2 : TEXT;
    FIRST : CHAR;
    LINE, TK, TKN9 : STR115;
    COUNT : ARRAY [STATUS] OF LONGINT;
    PREVHEAD : STR115;

    CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ‹žŽ‰ *)
    CLA0018 : ARRAY [1..XOYMAX] OF STR15;  (* ‘“•Ž‰ *)
    CLA0107 : ARRAY [1..IYMAX] OF STR15; (* ”€‡€ˆ‰ *)

    BSNCLS : ARRAY [1..MAXBSN, 1..2] OF INTEGER;{ basic noun classes }
    BSNPAR : ARRAY [1..MAXBSN, 1..2] OF INTEGER;{ basic noun numbs and gends }
    BSNSTR : ARRAY [1..MAXBSN] OF STR115;     { basic noun strings }
    BN_REACHED : LONGINT;

    PART_ARR : ARRAY [0..PARTMAX] OF
      RECORD
        STS : STATUS;
        LIN : STR115;
        LIN1: STR115;
        LIN2: STR115;
        TKN : STR115;
        CLS : INTEGER;
        CLS2: INTEGER;
        NUMB : NUMBER;
        GEND : GENDER;
        ANIM : ANIMA;
        NOM  : CHAR;
      END;
   PARTAMT : LONGINT;
   ST : STATUS;
   THEREISLAT : BOOLEAN;


{ Initialization of basic nouns array }
PROCEDURE FILL_BASE_NOUNS;
        (*===============*)
VAR
  ERC1, ERC2 : INTEGER;
  I : LONGINT;
  LINE : STR115;
  INP : TEXT;
BEGIN
  ASSIGN (INP, 'BASICS.LST');
  RESET (INP);
  I := 0;
  REPEAT
    READLN (INP, LINE);
    INC(I);
    VAL (COPY(LINE,2,4), BSNCLS [I,1], ERC1);
    VAL (COPY(LINE,6,4), BSNCLS [I,2], ERC2);
    IF ERC1 + ERC2 > 0
      THEN WRITELN ('Conversion error at line ', I, ' of BASICS.LST');
    BSNPAR [I,1] := ORD(LINE [11]) - ORD('0');
    BSNPAR [I,2] := ORD(LINE [13]) - ORD('0');
    BSNSTR [I] := COPY (LINE, 15, LENGTH(LINE)-14);
  UNTIL EOF(INP) OR (I = MAXBSN);
  BN_REACHED := I;
  CLOSE (INP);
  writeln ('BASICS are ', BN_REACHED);
END;

{ TOKEN is among basic nouns }
FUNCTION IN_BASIC_NOUNS (TOKEN : STR115;
        {==============} VAR CLS1, CLS2 : INTEGER;
                         VAR NUMR : NUMBER;
                         VAR GNDR : GENDER) : BOOLEAN;
VAR
  LOW, HIGH, MID : LONGINT;
  FOUND : BOOLEAN;
  RES : RESTYPE;
BEGIN
  NUMR := UNKN;
  GNDR := NONE;
  CLS1 := 255;
  CLS2 := 255;
  FOUND := FALSE;
  LOW := 1;
  HIGH := BN_REACHED;
  WHILE (HIGH >= LOW) AND NOT FOUND DO
    BEGIN
      MID := (HIGH + LOW) DIV 2;
      COMPARE_TOK (TOKEN, BSNSTR [MID], RES);
      CASE RES OF
        LT : HIGH := MID - 1;
        EQ : FOUND := TRUE;
        GT : LOW := MID + 1;
      END;
    END;
  IF FOUND
    THEN
      BEGIN
        CLS1 := BSNCLS [MID,1];
        CLS2 := BSNCLS [MID,2];
        NUMR := NUMBER (BSNPAR [MID,1]);
        GNDR := GENDER (BSNPAR [MID,2]);
      END;
 IN_BASIC_NOUNS := FOUND;
END;

  PROCEDURE INIT_ARR;
          (*========*)
    VAR
      I : INTEGER;
  BEGIN
    PARTAMT := -1;
    FOR I := 0 TO PARTMAX DO
      WITH PART_ARR [I] DO
        BEGIN
          STS := ZERO;
          LIN := DUMMY;
          LIN1 := DUMMY;
          LIN2 := DUMMY;
          TKN := DUMMY;
          CLS := 0;
          CLS2 := 255;
          NUMB := UNKN;
          GEND := NONE;
          ANIM := IND;
          NOM  := BL;
        END;
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
        '–' : CLASS := 22;
        '’','„','‚','Œ','‹','','','','‘','‡' : CLASS := 9;
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
              '–' : CLASS := 22;
              '’','„','‚','Œ','‹','','','','‘','‡' : CLASS := 9;
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
     ELSE IF (LAST = '–')
        THEN CLASS := 22
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


  FUNCTION ISGEN (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      GENFIN : ARRAY [1..14] OF STR2 =
        ('€','Ÿ','›','ˆ','Ž‚','…‚','…‰','ƒŽ','›•','ˆ•','…•','Ž‰','ŽŠ','…Š');
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
    UNTIL FOUND OR (I = 14);
    ISGEN := FOUND;
  END;


  FUNCTION ISINS (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      INSFIN : ARRAY [1..6] OF STR2 =
        ('Œˆ','›Œ','ŽŒ','ˆŒ','Ž‰','œž');
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


  FUNCTION HAS_ADV_PREPOS (TOKEN : STR115) : BOOLEAN;
         (*==============*)
    CONST
      PREPOSIT : ARRAY [1..56] OF STRING [10] =
        ('…‡','‹€ƒŽ„€Ÿ','ŽŠ','Ž‹……','‚','‚ˆ‡ˆ','‚…','‚“’ˆ','‚“’œ',
        '‚Ž','‚ŽŠ“ƒ','‚Ž’','‚‘…','‚‘…ƒŽ','‚‘‹…„‘’‚ˆ…','ƒ„…','„‚€','„‹Ÿ',
        '„Ž','…™…','‡€','ˆ‡-Ž„','ˆ‡“’ˆ','Š€Š','ŠŽƒ„€','Š‘’€’ˆ','Š“„€',
        'Œ…†„“','€','ˆŠ€ŠŽ‰','ˆ—…ƒŽ','Ž„ˆ','Ž’','Ž’Š“„€','Ž',
        'Ž‚›˜…Ž‰','Ž„','Ž‡€„ˆ','Ž‘‹…','“’…Œ','ˆ','Ž','Ž’ˆ‚',
        '‘','‘‡€„ˆ','‘‹…‚€','‘€“†ˆ','‘Ž','‘Žƒ‹€‘Ž','‘……„ˆ','‘€‚€',
        '’€Š','’ˆ','•Ž’œ','—…ƒŽ','—’Ž');
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := COPY (TOKEN, 1, LENGTH (PREPOSIT [I]) + 1) = PREPOSIT [I] + BL;
    UNTIL FOUND OR (I = 56);
    HAS_ADV_PREPOS := FOUND;
  END;


  FUNCTION MAYBE_ADJ (TOKEN : STR115;
         (*=========*)VAR GEND : GENDER) : BOOLEAN;
    VAR
      CLASS : INTEGER;
      NUMB : NUMBER;

  BEGIN
    GEND := NONE;
    INITADJCL (TOKEN, CLASS, GEND, NUMB);
    MAYBE_ADJ := (CLASS > 0);
  END;


  FUNCTION MEETS_GEND (TOKEN : STR115;
         (*==========*)ADJ_GEND : GENDER) : BOOLEAN;
    VAR
      CH : CHAR;

  BEGIN
    CH := TOKEN [LENGTH (TOKEN)];
    CASE ADJ_GEND OF
      MASC : MEETS_GEND := (POS (CH, '‚„‡‰‹Œ‘’”–œ'+ AFFR + LABIA) > 0);
      FEM :  MEETS_GEND := (POS (CH, '€Ÿœ') > 0);
      NEUT : MEETS_GEND := (POS (CH, 'Ž…') > 0)
               OR (TOKEN = '‚…ŒŸ') OR (TOKEN = 'ˆŒŸ');
      COMN : MEETS_GEND := (POS (CH, '›ˆ€Ÿ') > 0);
      ELSE MEETS_GEND := FALSE;
    END;
  END;


  FUNCTION HAS_LINK (TOKEN : STR115) : BOOLEAN;
         (*========*)
    CONST
      LINKS : ARRAY [1..6] OF STRING [4] =
        ('‚Ž','„€','„“ƒ','‡€','…','Ž');

    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (POS (BL + LINKS [I] + BL, TOKEN) > 0);
    UNTIL FOUND OR (I = 6);
    HAS_LINK := FOUND;
  END;


  FUNCTION IS_ADVERB (TOKEN : STR115) : BOOLEAN;
         (*=========*)
    CONST
      ADVERBS : ARRAY [1..73] OF STR115 =
        ('€”€‘','‚‹ˆ‡ˆ','‚‚…•','‚„€‹ˆ','‚„‚Ž…Œ','‚„Ž‚Ž‹œ','‚„“ƒ',
        '‚‡€„','‚…‘œŒ€','‚Š€’–…','‚ˆ‡','‚‡€Œ…','‚Ž‚œ','‚ŽŠ“ƒ','‚Ž…Šˆ',
        '‚……„','‚ˆ’›Š','‚Ž‡œ','‚‘…ƒ„€','‚‘…œ…‡','‚‘ŠŽ‹œ‡œ','‚‘‹…„',
        '‚‘‹“•','‚’ˆ„ŽŽƒ€','„‚€†„›','„Ž‹Ž‰','„ŽŒ€','‡€€ˆ€’€','‡„…‘œ',
        'ˆ‡„€‹…Š€','ˆ‡„€‹ˆ','ˆŽƒ„€','ˆ‘Ž„‚Ž‹œ','ˆ‘Ž„’ˆ˜Š€','Š€‰…',
        'Š…‘’-€Š…‘’','‹ˆ˜œ','‹“—˜…','ŒˆˆŒ“Œ','ŒŽ‹—€','€‚…Š',
        '€‚‘…ƒ„€','€‡€„','€Š…‘’','€Ž“Œ','€ŸŒˆŠ','€’Ž™€Š',
        '€Ž“Œ','€“ƒ€„','ˆŠ€Š','Ž’Š“„€','Ž—…œ','ŽŠ€','ŽŽ‹€Œ',
        '…†„…','Ž—œ','“‘’œ','‘€ŒŽ’…ŠŽŒ','‘‹…‚€','‘Ž‚€','‘Ž‚‘…Œ',
        '‘…˜€','‘‹Ž˜œ','‘€‚€','‘ž„€','’€Š','’€Œ','’……œ','’…’-€-’…’',
        '’ˆ†„›','’“„€','’“’','•‚€’ˆ’');
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (TOKEN = ADVERBS [I]);
    UNTIL FOUND OR (I = 73);
    IS_ADVERB := FOUND;
  END;


  FUNCTION IS_HYBLOC0 (TOKEN : STR115;
         (*============*)SAMPLE : STR115) : BOOLEAN;

  BEGIN
    IS_HYBLOC0 := (TOKEN = 'ŠŽ…-' + SAMPLE) OR
      (TOKEN = SAMPLE + '-’Ž') OR (TOKEN = SAMPLE + '-‹ˆŽ')
      OR (TOKEN = SAMPLE + '-ˆ“„œ');
  END;

    (* ‚›„€…’ Ž‡ˆ–ˆž Ž‘‹…„…ƒŽ Ž…‹€ ‚ TOKEN *)
  FUNCTION LAST_BLANK_POS (TOKEN : STRING) : INTEGER;
         (*==============*)
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := LENGTH (TOKEN) + 1;
    REPEAT
      DEC (I);
      FOUND := (TOKEN [I] = BL);
    UNTIL FOUND OR (I = 1);
    IF FOUND
      THEN LAST_BLANK_POS := I
      ELSE LAST_BLANK_POS := 0;
  END;


  PROCEDURE MAKE_ARR;
          (*========*)
    VAR
      I, P : INTEGER;
      J : INTEGER;
      TOK1, TOK2 : STR115;
      ALL_ADJ, ALL_VERB, ALL_SUB, VALID, DONE, ADV_LIKE: BOOLEAN;
      LAB : STRING [2];

  BEGIN
    DONE := FALSE;

    FOR I := 0 TO PARTAMT DO
      WITH PART_ARR [I] DO
        BEGIN
          P := POS ('<', LIN);
          IF P > 0
            THEN
              BEGIN
                LAB := COPY (LIN, P+1, 2);
                TKN := COPY (LIN, 1, P-1);
              END
            ELSE TKN := LIN;

          IF (I = 0)
            THEN
              IF P > 0
                THEN
                  BEGIN
                    IF (LAB = 'Su')
                      THEN STS := SUB
                    ELSE IF (LAB = 'Ve')
                      THEN STS := VERB
                    ELSE IF (LAB = 'Aj')
                      THEN STS := ADJ
                    ELSE IF (LAB = 'Av')
                      THEN STS := ADV;
                  END
            ELSE
              IF PART_ARR [0].STS <> ZERO
                THEN STS := PART_ARR [0].STS;

          P := POS ('1', TKN) + POS ('2', TKN) + POS ('3', TKN)
            + POS ('4', TKN) + POS ('5', TKN) + POS ('6', TKN);
          IF P > 0
            THEN
              BEGIN
                NOM := TKN [P];
                TKN := COPY (TKN, 1, P - 1);
              END;
        END;

    IF (PART_ARR [0].STS <> ZERO)
      THEN
        CASE PART_ARR [0].STS OF
          SUB :
            BEGIN
              FOR I := 0 TO PARTAMT DO
                WITH PART_ARR [I] DO
                  BEGIN
                    STS := SUB;
                    IF NOM <> BL
                      THEN TKN9 := TKN + NOM
                      ELSE TKN9 := TKN;
                    IF IN_BASIC_NOUNS (TKN9, CLS, CLS2, NUMB, GEND)
                      THEN
                        BEGIN
                          VALID := TRUE;
                        END
                      ELSE INITSUBCL (TKN, CLS, VALID, NUMB, GEND, ANIM);
                    CLS2 := 255;
                    INC (COUNT [SUB]);
                  END;
            END;
          VERB:
            FOR I := 0 TO PARTAMT DO
              WITH PART_ARR [I] DO
                BEGIN
                  STS := VERB;
                  INITVERBCL (TKN, CLS, VALID);
                  IF NOT VALID
                    THEN WRITELN ('ERROR: WRONG VERB AT ', LIN);
                  CLS2 := 255;
                  INC (COUNT [VERB]);
                END;
          ADJ :
            FOR I := 0 TO PARTAMT DO
              WITH PART_ARR [I] DO
                BEGIN
                  STS := ADJ;
                  INITADJCL (TKN, CLS, GEND, NUMB);
                  IF (CLS = 0)
                    THEN WRITELN ('ERROR: WRONG ADJECTIVE AT ', LIN);
                  CLS2 := 255;
                  INC (COUNT [ADJ]);
                END;
          ADV :
            FOR I := 0 TO PARTAMT DO
              WITH PART_ARR [I] DO
                BEGIN
                  STS := ADV;
                  CLS := 0;
                  CLS2 := 255;
                  INC (COUNT [ADV]);
                END;
        END
      ELSE

        BEGIN
          ALL_VERB := TRUE;
          FOR J := 0 TO PARTAMT DO
            WITH PART_ARR [J] DO
              BEGIN
                INITVERBCL (TKN, CLS, VALID);
                CLS2 := 255;
                ALL_VERB := ALL_VERB AND VALID;
              END;
          DONE := ALL_VERB;

          IF DONE
            THEN
              BEGIN
                FOR I := 0 TO PARTAMT DO
                  PART_ARR [I].STS := VERB;
                INC (COUNT [VERB], PARTAMT + 1);
              END
            ELSE
              BEGIN
                ALL_ADJ := TRUE;
                FOR J := 0 TO PARTAMT DO
                  WITH PART_ARR [J] DO
                    BEGIN
                      TOK1 := TKN;
                      TOK2 := DUMMY;
                      CLS2 := 255;
                      INITADJCL (TOK1, CLS, GEND, NUMB);
                      ALL_ADJ := ALL_ADJ AND ((LENGTH (TOK1) >= 4)
                        AND (CLS > 0) AND (GEND = MASC)
                        OR (J > 0 ) AND ((CLS = 0)
                        OR HAS_ADV_PREPOS (LIN) OR (TOK2 <> DUMMY)
                        AND ISGEN (TOK1) AND (ISGEN (TOK2) OR (CLS2 = 0)))
                        OR (TOK1 = '’Ž’') OR (TOK1 = '’Ž’') OR (TOK1 = '‚…‘œ'));
                    END;

                DONE := ALL_ADJ;
                IF DONE
                  THEN
                    FOR I := 0 TO PARTAMT DO
                      WITH PART_ARR [I] DO
                        BEGIN
                          IF (I > 0) AND (HAS_ADV_PREPOS (LIN) OR (CLS = 0)
                            OR ISGEN (TOK1) AND (ISGEN (TOK2) OR (CLS2 = 0))
                            OR (CLS = 0) AND (CLS2 = 0))
                            THEN CLS := 0;
                          STS := ADJ;
                          INC (COUNT [ADJ]);
                        END;
              END;

          IF NOT DONE
            THEN
              BEGIN
                ALL_SUB := TRUE;
                ADV_LIKE := TRUE;
                J := -1;
                REPEAT
                  INC (J);
                  WITH PART_ARR [J] DO
                    BEGIN
                      IF NOM <> BL
                        THEN TKN9 := TKN + NOM
                        ELSE TKN9 := TKN;
                      IF IN_BASIC_NOUNS (TKN9, CLS, CLS2, NUMB, GEND)
                        THEN
                          BEGIN
                            VALID := TRUE;
                          END
                        ELSE INITSUBCL (TKN, CLS, VALID, NUMB, GEND, ANIM);
                      ALL_SUB := ALL_SUB AND ((CLS > 0) OR VALID);
                      ADV_LIKE := ADV_LIKE AND
                        (COPY (TKN, LENGTH (TKN) - 3, 4) <> 'Ž‘’œ')
                        AND (IS_ADVERB (TKN) OR ISINS (TKN) OR
                        (COPY (TKN, 1, 3) = 'Ž-') OR
                        (COPY (TKN, LENGTH (TKN) - 1, 2) = '“ž') OR
                        (COPY (TKN, LENGTH (TKN) - 1, 2) = '€Ÿ') OR
                        (COPY (TKN, LENGTH (TKN) - 1, 2) = 'ŸŸ') OR
                        (COPY (TKN, LENGTH (TKN) - 1, 2) = '“Ÿ') OR
                        (COPY (TKN, LENGTH (TKN) - 1, 2) = 'ˆ‚')
                        AND (POS (TKN [LENGTH (TKN) - 3], 'Š–') = 0) OR
                        (COPY (TKN, LENGTH (TKN) - 2, 3) = 'Ÿ‘œ') OR
                        (COPY (TKN, LENGTH (TKN) - 2, 3) = 'ˆ‘œ') OR
                        (COPY (TKN, LENGTH (TKN) - 2, 3) = '€…’') OR
                        (COPY (TKN, LENGTH (TKN) - 3, 4) = '‘Šˆ') OR
                        (COPY (TKN, LENGTH (TKN) - 3, 4) = '‘Šˆ') OR
                        (COPY (TKN, LENGTH (TKN) - 3, 4) = '’‘Šˆ') OR
                        (COPY (TKN, LENGTH (TKN) - 4, 5) = '—…‘Šˆ') OR
                        (COPY (TKN, LENGTH (TKN) - 4, 5) = '‹œ‘Šˆ') OR
                        (COPY (TKN, LENGTH (TKN) - 4, 5) = '†…‘Šˆ') OR
                        (CLS = 0) AND (TKN <> '˜Ž‘‘…') AND
                        (COPY (TKN, LENGTH (TKN) - 5, 6) <> '€’…‹œ…')
                        OR (CLS = 18) AND (TKN <> '˜ˆ’œ…')
                        AND (TKN <> '€œ…')
                        OR (COPY (TKN, LENGTH (TKN) - 1, 2) = '™…')
                        AND (POS(TKN [LENGTH (TKN)-2], '€ŸŽž“') > 0)
                        OR (CLS = 16) AND (TKN <> '„…‹Ž')
                        AND (TKN <> '…Š‹Ž') AND (TKN <> 'ŠŽ‹…‘ˆŠŽ') AND
                        (COPY (TKN, LENGTH (TKN) - 3, 4) <> '‘’‚Ž')
                        OR (CLS = 21) OR (CLS = 22) OR (CLS = 24)
                        OR (CLS = 30) OR (CLS = 37)
                        OR (CLS = 59) AND (TKN <> '‘“•Ž‚…‰')
                        OR (CLS = 74) AND (TKN <> 'ƒŽ„›Ÿ')
                        AND (TKN <> '€€–…Ÿ')
                        OR (CLS = 68) AND
                        (COPY (TKN, LENGTH (TKN) - 2, 3) <> '…‹œ')
                        AND (COPY (TKN, LENGTH (TKN) - 2, 3) <> 'Ž‹œ')
                        AND (COPY (TKN, LENGTH (TKN) - 2, 3) <> '€œ'));
                        CLS2 := 255;
                    END;
                UNTIL NOT ALL_SUB OR (J = PARTAMT);

                DONE := ALL_SUB AND NOT ADV_LIKE;
                IF DONE
                  THEN
                    BEGIN
                      FOR I := 0 TO PARTAMT DO
                        WITH PART_ARR [I] DO
                          BEGIN
                            STS := SUB;
                            IF (PART_ARR [0].TKN = 'Ž„ˆ’…‹ˆ') AND (I > 0)
                              THEN
                                BEGIN
                                  GEND := COMN;
                                  NUMB := PLUR;
                                END;
                          END;
                      INC (COUNT [SUB], PARTAMT + 1);
                    END;
              END;

          IF NOT DONE
            THEN
              BEGIN
                FOR I := 0 TO PARTAMT DO
                  WITH PART_ARR [I] DO
                    BEGIN
                      STS := ADV;
                      CLS := 0;
                      CLS2 := 255;
                      NUMB := UNKN;
                      GEND := NONE;
                    END;
                INC (COUNT [ADV], PARTAMT + 1);
              END;
        END;
  END;


  PROCEDURE OUT_ARR;
          (*=======*)
    VAR
      I, C_SU_M, C_SU_F, C_SU_N, C_SU_C, 
        C_VE, C_AJ, WOHOM, L : INTEGER;
      LA, LA_1, LA_2, LA_3 : CHAR;
      REFL : BOOLEAN;
  BEGIN
    C_SU_M := 0;
    C_SU_F := 0;
    C_SU_N := 0;
    C_SU_C := 0;
    C_VE := 0;
    C_AJ := 0;
    WOHOM := 0;
    FOR I := 0 TO PARTAMT DO
      WITH PART_ARR [I] DO
        BEGIN
          IF POS (LIN [LENGTH(LIN)], '23456') = 0
            THEN
              BEGIN
                INC (WOHOM);
                CASE STS OF
                  SUB:
                    CASE GEND OF
                      MASC: INC (C_SU_M);
                      FEM:  INC (C_SU_F);
                      NEUT: INC (C_SU_N);
                      COMN: INC (C_SU_C);
                    END;
                  VERB: INC(C_VE) ;
                  ADJ:  INC(C_AJ);
                  ADV: ;
                END;
              END;
          IF I = 0
            THEN BEGIN WRITE (OUT, '+'); WRITE (OUT1, '+'); WRITE (OUT2, '+'); END
            ELSE BEGIN WRITE (OUT, '-'); WRITE (OUT1, '-'); WRITE (OUT2, '-'); END;
          IF (POS ('<Su', LIN) > 0) OR (POS ('<Ve', LIN) > 0)
            OR (POS ('<Aj', LIN) > 0) OR  (POS ('<Av', LIN) > 0)
            THEN 
              BEGIN
                LIN := COPY (LIN, 1, LENGTH (LIN) - 3);
                LIN1 := COPY (LIN1, 1, LENGTH (LIN1) - 3);
              END;
          WRITELN (OUT, ORD(STS) : 2, CLS : 4, CLS2 : 4,
            ORD (NUMB) * ORD (STS = SUB) : 2,
            ORD (GEND) * ORD (STS = SUB) : 2, BL, LIN);

          L :=  LENGTH (LIN1); 
          LA := LIN1 [L]; 
          LA_1 := LIN1 [L-1]; 
          LA_2 := LIN1 [L-2];                 
          LA_3 := LIN1 [L-3];
          REFL := (LA_2 = '-') AND (LA_1 = '‘') OR
            (LA_3 = '-') AND (LA_2 = '‘') AND (POS (LA,'123456') > 0);
          IF STS = SUB
            THEN
              BEGIN 
                WRITELN (OUT1, '1':2, ORD(NUMB):2, ORD(GEND):2, BL, LIN1);
                WRITELN (OUT2, '1':2, CLS : 4, CLS2 : 4,
                  ORD(NUMB):2, ORD(GEND):2, BL, LIN1);
              END
            ELSE
              BEGIN 
                WRITELN (OUT1, ORD(STS):2, ORD(REFL):2, '0':2, BL, LIN1);
                WRITELN (OUT2, ORD(STS):2, CLS : 4, CLS2 : 4, 
                  ORD(REFL):2, '0':2, BL, LIN1);
              END;
        END;
    SUPER := SUPER + (PARTAMT+1)*PARTAMT;
    SUPER_POS := SUPER_POS + ((C_SU_M-1)*C_SU_M) DIV 2  
      + ((C_SU_F-1)*C_SU_F) DIV 2 + ((C_SU_N-1)*C_SU_N) DIV 2 
      + ((C_SU_C-1)*C_SU_C) DIV 2 + ((C_VE-1)*C_VE) DIV 2 
      + ((C_AJ-1)*C_AJ) DIV 2;
    TOTAL_WOHOM := TOTAL_WOHOM + WOHOM;
  END;

  FUNCTION CLEANED (INSTR : STR115) : STR115;
         (*=======*)
    VAR
      I : INTEGER;
      OUTSTR : STR115;
  BEGIN
    OUTSTR := DUMMY;
    I := 0;
    REPEAT
      INC (I);
      IF POS (INSTR [I], '-+*') = 0
        THEN OUTSTR := OUTSTR + INSTR [I];
    UNTIL (I = LENGTH (INSTR));
    CLEANED := OUTSTR;
  END;

BEGIN      (* MAIN *)
  FILL_BASE_NOUNS;

  FOR ST := ZERO TO ADV DO
    COUNT [ST] := 0;
  PREVHEAD := DUMMY;
  SUPER := 0;
  SUPER_POS := 0;
  TOTAL_WOHOM := 0;

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

  ASSIGN (OUT, 'PARON.COD');
  REWRITE (OUT);
  ASSIGN (OUT1, 'PARON1.COD');
  REWRITE (OUT1);
  ASSIGN (OUT2, 'PARON2.COD');
  REWRITE (OUT2);
  
  WRITELN ('FILE PARONYM.TXT BEING PROCESSED');
  ASSIGN (INP, 'PARONYM.TXT');
  RESET (INP);
  LINENUM := 0;
  INIT_ARR;

  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);
    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN ('ERROR: UNNECESSARY FINAL BLANK IN LINE ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;
    THEREISLAT := FALSE;
    J := 0;
    REPEAT
      INC (J);
      THEREISLAT := ('A' <= LINE [J]) AND (LINE [J] <= 'Z');
    UNTIL (LINE [J] = '<') OR THEREISLAT OR (J >= LENGTH (LINE));
    IF THEREISLAT
      THEN WRITELN ('ERROR: LATIN LETTER IN LINE ', LINENUM);

    FIRST := LINE [1];
    IF (('€' <= FIRST ) AND (FIRST <= 'Ÿ')) OR (POS (FIRST, '-+*') > 0)
      THEN (* „ŽŒˆ€’€ *)
        BEGIN
          IF PREVHEAD > CLEANED (LINE)
            THEN
              BEGIN
                WRITELN ('ERROR: GROUP HEADS DISORDER AT LINE ', LINENUM);
                RUNERROR (250);
              END
            ELSE PREVHEAD := CLEANED (LINE);
          IF PARTAMT > 0
            THEN
              BEGIN
                MAKE_ARR;
                OUT_ARR;
                INIT_ARR;
              END;
          INC (PARTAMT);
          INC (COUNT [ZERO]);
          PART_ARR [PARTAMT].LIN := CLEANED (LINE);
          PART_ARR [PARTAMT].LIN1 := LINE;
        END
      ELSE (* Ž›—›‰ €ŽˆŒ *)
        BEGIN
          INC (PARTAMT);
          WITH PART_ARR [PARTAMT] DO
            BEGIN
              IF (FIRST <> BL)
                THEN WRITELN ('ERROR: DUBIOUS LABLE AT LINE ', LINENUM);
              TK := COPY (LINE, 3, LENGTH (LINE) - 2);
              LIN := CLEANED (TK);
              LIN1 := TK;
              LIN2 := TK;
              IF LIN < PART_ARR [PARTAMT-1].LIN
                THEN
                  BEGIN
                    WRITELN ('ERROR: SUBORDIN DISORDER AT LINE ',
                      LINENUM);
                    RUNERROR (250);
                 END;
            END;
          IF EOF (INP)
            THEN
              BEGIN
                MAKE_ARR;
                OUT_ARR;
              END;
        END;
  UNTIL EOF (INP);
  FLUSH (OUT);
  FLUSH (OUT1);
  FLUSH (OUT2);

  TOTAL := COUNT [SUB] + COUNT [VERB] + COUNT [ADJ] + COUNT [ADV];
  WRITELN (' TOTAL PARONYM NUMBER = ', TOTAL : 5);
  WRITELN ('  AND AMONG THEM:');
  WRITELN ('         NOUNS = ', COUNT [SUB] / TOTAL * 100 :4:1, '%');
  WRITELN ('         VERBS = ', COUNT [VERB] / TOTAL * 100 :4:1, '%');
  WRITELN ('    ADJECTIVES = ', COUNT [ADJ] / TOTAL * 100 :4:1, '%');
  WRITELN ('       ADVERBS = ', COUNT [ADV] / TOTAL * 100 :4:1, '%');
  WRITELN ('     NUMBER OF GROUPS = ', COUNT [ZERO]);
  WRITELN ('    MEAN GROUP LENGTH = ', TOTAL / COUNT [ZERO] : 4 : 2);
  WRITELN ('UNILATERAL LINKS OF PARONYMS  = ', SUPER : 6);
  WRITELN ('AVERAGE LINK NUMBER PER GROUP = ', SUPER / COUNT [ZERO] : 5 : 1);
{ WRITELN;
  WRITELN ('PARONYMS W/O HOMONYMS = ', TOTAL_WOHOM : 5);
  WRITELN ('     NUMBER OF GROUPS = ', COUNT [ZERO]);
  WRITELN ('GROUP LENGTH W/O HOMS = ', TOTAL_WOHOM / COUNT [ZERO] : 4 : 2);
  WRITELN ('PAIRS TO BE COMPARED  = ', SUPER_POS : 6); }
  WRITELN ('FILES PARON.COD, PARON1.COD, PARON2.COD ARE OUTPUT');
END.
