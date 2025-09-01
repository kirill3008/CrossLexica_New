PROGRAM ENCPART2;

USES DOS, CLASTABL;

  TYPE
    STR15 = STRING [15];

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    GAP = 24;

    MAXPART = 750;
    SUFS : ARRAY [1..53] OF STRING [4] =
      ('›‰', '‰', '‰', '‰‘', '€', '', '€‘', '…', '……',
      '……‘', '›…', '…', '…‘', '', '…', '', '', '',
      '€', '€€', '€…', '€', '', '€', '', '›',
      '…‘', '‘', '‘…', '’', '‚', '‚€', '‚', '‚›',
      '›€', '›', '', '€', '€€', '€', '€', '€', '', 
      '…', '…', '', '…', '…‰', '', '›', '€', '', '››');

  VAR
    XL_DAS, BUF : STRING [255];
{FILENO,} CLASS, SUBCL, CL, ANIMSUBCL, 
  IDIOM, STYL, P, L, J : INTEGER;
AMT0, AMT11, AMT12, AMT13, AMT14, AMT15, AMT2, AMT,
  I, PARTAMT : INTEGER;
INP, INP1, OUT, OUT2, OUT3 : TEXT;
FIRST, USACH, CH : CHAR;
USECOUNT: ARRAY [1..5] OF WORD;
LINE, LINE1, LINE2, TOK, TOK1, TOK3, TOKEN, HEADLINE : STR115; {!}
FNAME, FNAMEOUT{, FNAMEOUT1}, FIN, FIN1 : STRING [12];
HEADER, HEADER1, SUBHEAD{, VERB, TOK1, TOK2} : STR115; {!}
VALID, SUBVAL, NG_CHANGE, DOUBLE_FL, FL_REVERS,
THERE_IS_I, THERE_IS_H : BOOLEAN;
PARS : ARRAY [0..4] OF INTEGER;
NMB, {NUMB,} NUMB0, SUBNUMB : NUMBER;
(* gender implied by the verb *)
(* gender of the noun *) 
GND, {GEND,} GEND0, SUBGEND, ADJ_GEND : GENDER;
{ANIM,} ANIM0, SUBANIM : ANIMA;
LINENUM, TOTAL, GRNUM : LONGINT;
CAS_WO_PREP : ARRAY [0..7] OF LONGINT;
PREPO : ARRAY [8..MAXPREP29] OF LONGINT;
PREPOTOTAL, WOPREPTOTAL : LONGINT;

CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ‹‰ *)
CLA0018 : ARRAY [1..57] OF STR15;  (* ‘“•‰ *)
CLA0107 : ARRAY [1..IYMAX] OF STR15; (* ”€‡€‰ *)

PARTARR : ARRAY [1..MAXPART] OF
  RECORD
    NEG  : BOOLEAN;     (* ‡€ €—€‹ƒ "… " *)
    TOKN : STR115;       (* —€‘’…/‹€ƒ€’…‹… *)
    SOBN : INTEGER;     (* … ‘’“– ‘ "‘…/‘‰" *)
    ONLYDOT : INTEGER;  (* ‡€ …†“’. ‹ …—. ƒ’— *)
    GCAS : INTEGER;     (* … ™…ƒ €„…†€ *)
    ADJCLS : INTEGER;     (* ‹€‘‘ —€‘’/‹€ƒ€’…‹ƒ *)
    FLEX : STR10;       (* —€… *)
    FLX1 : STR10;       (* „“ƒ… —€… *)
    IDI  : INTEGER;     (* ‡€ ”ƒ“€‹‘’ *)
    STY  : INTEGER;     (* ‡€ €‡ƒ‚‘’ *)
  END;

CONST NOGCAS=255; { GCAS NOT ASSIGNED }

  PROCEDURE DEFINE_SUFS (TOKEN : STR115;
        (*=============*)VAR NUM : INTEGER);
    VAR
      I, L : INTEGER;
      FOUND : BOOLEAN;
      FLEX : STR10;

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

FUNCTION IS_HYPHBLOCK (TOKEN : STR115) : BOOLEAN;
       (*============*)
BEGIN
  IS_HYPHBLOCK :=
(TOKEN = '€‰-’') OR (TOKEN = '€‰-‹') OR
(TOKEN = '€‰-“„') OR
(TOKEN = '€€-’') OR (TOKEN = '€€-‹') OR
(TOKEN = '€‰-“„') OR
(TOKEN = '€…-’') OR (TOKEN = '€…-‹') OR
(TOKEN = '€‰-“„');
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
            IF COPY (STEM, P - 2, 2) = '‰'
              THEN
            BEGIN GEND := MASC;NUMB := SING;END
              ELSE IF COPY (STEM, P - 2, 2) = '€'
              THEN
            BEGIN GEND := FEM;NUMB := SING;END
              ELSE IF COPY (STEM, P - 2, 2) = '…'
              THEN
            BEGIN GEND := NEUT;NUMB := SING;END
              ELSE
            BEGIN GEND := COMN;NUMB := PLUR;END;
              EXIT;
            END
        ELSE IF (COPY (STEM, 1, P) = '-')
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
          IF (COPY (STEM, L-2, 3) = '‹') OR 
            (COPY (STEM, L-1, 2) = '‰') 
            THEN CLASS := 2
          ELSE IF STEM [L-1] = ''
            THEN CLASS := 1
          ELSE IF STEM [L-1] = ''
            THEN CLASS := 1
          ELSE IF (POS (STEM [L-1], SONOR) > 0)
            THEN CLASS := 9
            ELSE CLASS := 1;
        '’','„','‚','','‹','','','','‘','–','‡' : CLASS := 9;
        ELSE CLASS := 0;
      END;
    2 : (* -‰ *)
      BEGIN
        LOW := 1;
        HIGH := IYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*”€‡€‰>*) COMPARE_TOK (STEM, CLA0107 [MID], RES);
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
                IF (POS (STEM [L-1], '‚„†‰’•') > 0)
                  THEN CLASS := 8
                  ELSE CLASS := 0
            ELSE IF (STEM = '€')
               THEN CLASS := 8
            ELSE IF POS (LAST, LABIA) > 0
              THEN CLASS := 10
            ELSE IF (POS (LAST, AFFR) > 0)
              THEN CLASS := 3
              ELSE CLASS := 0;
      END;
    3 : (* -‰ *)
      IF (STEM = '‘‚') OR (STEM = '’‚') OR (STEM = '')
        THEN CLASS := 11
      ELSE IF (STEM = '‚') OR (STEM = '’—')
        OR (STEM = '“ƒ‚') OR (LAST = '–') OR (STEM = '‘‹')
        OR (STEM = '‘’') OR (STEM = '‡€‘’') OR (STEM = '‘’')
        OR (STEM = '–…')
        THEN CLASS := 0
      ELSE IF POS (LAST, LABIA + AFFR) > 0
        THEN CLASS := 5
        ELSE CLASS := 4;
    4, 7, 10, 13 : (* -‰‘/-€‘/-……‘/-…‘ *)
      CLASS := 6;
    5 : (* -€ *)
      BEGIN
        LOW := 1;
        HIGH := OYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*‹€>*)  COMPARE_TOK (STEM, CLASS17 [MID], RES);
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
              'ƒ', '', '•', '', '™', '—', '†' :
                BEGIN
                  LOW := 1;
                  HIGH := XOYMAX;
                  FOUND := FALSE;
                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                    BEGIN
                      MID := (HIGH + LOW) DIV 2;
(*‘“•€/‹€*)     COMPARE_TOK (STEM, CLA0018 [MID], RES);
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
              '’','„','‚','','‹','','','','‘','–','‡' : CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    6 : (* - *)
      IF (LAST = '') OR (LAST = '…') OR (STEM = '€')
        THEN CLASS := 8
        ELSE CLASS := 0;
    8 : (* -… *)
      IF (STEM = '‘‚') OR (STEM = '’‚') OR (STEM = '')
        THEN CLASS := 11
        ELSE
          CASE LAST OF
            'ƒ', '', '•', '', '™', '—', '†' :
              BEGIN
                LOW := 1;
                HIGH := XOYMAX;
                FOUND := FALSE;
                WHILE (HIGH >= LOW) AND NOT FOUND DO
                  BEGIN
                    MID := (HIGH + LOW) DIV 2;
(*‘“•…/‹…>*)  COMPARE_TOK (STEM, CLA0018 [MID], RES);
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
            '','’','„','‚','','‹','','','','‘','–','‡':
              BEGIN
                LOW := 1;
                HIGH := OYMAX;
                FOUND := FALSE;
                WHILE (HIGH >= LOW) AND NOT FOUND DO
                  BEGIN
                    MID := (HIGH + LOW) DIV 2;
 (*‹…>*)         COMPARE_TOK (STEM, CLASS17 [MID], RES);
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
          IF (POS (STEM [L-1], '‚„†‰’•') > 0)
            THEN CLASS := 8
            ELSE CLASS := 0
     ELSE IF (LAST = '…') OR (STEM = '€')
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
(*‹›…>*)  COMPARE_TOK (STEM, CLASS17 [MID], RES);
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
              '’','„','‚','','‹','','','','‘','–','‡' :
                CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    12 : (* -… *)
      BEGIN
        LOW := 1;
        HIGH := XOYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*‘“•…/‹…*)COMPARE_TOK (STEM, CLA0018 [MID], RES);
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
                IF (POS (STEM [L-1], '‚„†‰’•') > 0)
                  THEN CLASS := 8
                  ELSE CLASS := 0
            ELSE IF (STEM = '€') OR (LAST = '…')
              THEN CLASS := 8
              ELSE
                IF (POS (LAST, LABIA) > 0)
                  THEN CLASS := 10
                ELSE
                  IF (POS (LAST, AFFR) > 0) AND (STEM <> '‚…‹—')
                    THEN CLASS := 3
                    ELSE CLASS := 0;
      END;
    14, 15, 16 : (* -/-…/- *)
      IF (STEM = '—') OR (STEM = '—') OR (STEM = '…-—')
        THEN CLASS := 20
        ELSE
      BEGIN
        LOW := 1;
        HIGH := IYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*”€‡€>*)COMPARE_TOK (STEM, CLA0107 [MID], RES);
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
    17, 18 : (* -/- *)
      IF (STEM = '‘‚') OR (STEM = '’‚') OR (STEM = '')
        THEN CLASS := 11
        ELSE CLASS := 0;
    19..22 : (* -€/-€€/-€…/-€ *)
      IF (STEM = '') OR (STEM = '‚')
        THEN CLASS := 12
        ELSE CLASS := 0;
     23..26 : (* -/-€/-/-› *)
       IF (STEM = '„')
         THEN CLASS := 16
         ELSE
       IF (STEM = '€’') OR (STEM = '€€„') OR (STEM = '€“')
         OR (STEM = '€’') OR (STEM = '†…') OR (STEM = '“„')
         OR (STEM = '““') OR (STEM = '‹€‘’—') OR (STEM = '€')
         OR (STEM = '€') OR (STEM = '€…') OR (STEM = '€’“')
         OR (STEM = '€’›') OR (STEM = '€’…') OR (STEM = '“†')
         OR (STEM = '‘…‘’') OR (STEM = '‘“') OR (STEM = '‘“—')
         OR (STEM = '‘’€“•') OR (STEM = '™“') OR (STEM = '„„')
         OR (STEM = '’…’') OR (STEM = '’…’') OR (STEM = '’')
         OR (STEM = '€€') OR (STEM = '^…') OR (STEM = '”‹')
         OR (STEM = '„…„“') OR (STEM = '…‚…‘’')
           THEN CLASS := 17
           ELSE CLASS := 0;
    27..29 : (* -…‘/-‘/-‘… *)
      IF (STEM = '‚')
        THEN CLASS := 15
        ELSE CLASS := 0;
    30,42,43 :  (* -’/-€/- *)
      IF (STEM = '’')
        THEN CLASS := 13
      ELSE IF (STEM = '’')
        THEN CLASS := 14
        ELSE CLASS := 0;
    31..34 : (* -‚/-‚€/-‚/-‚› *)
      IF (STEM = '^•‘’') OR (STEM = '€‚ƒ…')
      OR (STEM = '€„') OR (STEM = '€€‹')
      OR (STEM = '€„€') OR (STEM = '€’')
      OR (STEM = '€•…„') OR (STEM = '€•‹‹…‘')
      OR (STEM = '€‰…‘') OR (STEM = '”„')
      OR (STEM = '€’') OR (STEM = '…’‹…’')
      OR (STEM = '“‹…') OR (STEM = '^€…–…')
      OR (STEM = '^‚‹’…') OR (STEM = '^‚€‹’€‘€')
      OR (STEM = '^‚€‹“ƒ…') OR (STEM = '‚‹’')
      OR (STEM = '‚')
      OR (STEM = 'ƒ€‰') OR (STEM = 'ƒ€‹…')
      OR (STEM = '^ƒ€€‹') OR (STEM = 'ƒ€“‘‘')
      OR (STEM = 'ƒ…€‹') OR (STEM = 'ƒ…‘’€’')
      OR (STEM = 'ƒ…“‹…‘') OR (STEM = '^ƒ…“‹…‘')
      OR (STEM = 'ƒ„…') OR (STEM = 'ƒ‹€“…')
      OR (STEM = '„…€’') OR (STEM = '^„€’') OR (STEM = '„€‹')
      OR (STEM = '„…„')  OR (STEM = '„€')
      OR (STEM = '…‚‹„') OR (STEM = '…‘€…')
      OR (STEM = '€') OR (STEM = '™……')
      OR (STEM = '^…‰–…') OR (STEM = '„‹')
      OR (STEM = '‹€‹€‘') OR (STEM = '‹““‹')
      OR (STEM = '……‚‹„') OR (STEM = '…’“')
      OR (STEM = '’–') OR (STEM = '…')
      OR (STEM = '”€ƒ') OR (STEM = '“‘’')
      OR (STEM = '') OR (STEM = '€')
      OR (STEM = '‘€‘') OR (STEM = '‘‡”')
      OR (STEM = '‘”‘') OR (STEM = '‘‹')
      OR (STEM = '‘›') OR (STEM = '’€’€‹')
      OR (STEM = '’—…‹‹…') OR (STEM = '”€‹‹…')
      OR (STEM = '•€') OR (STEM = '—…’')
      OR (STEM = '‡')
        THEN CLASS := 18
        ELSE CLASS := 0;
{!} 35,36 : (* -€/- *)
      IF (STEM = '„')
        THEN CLASS := 16
        ELSE CLASS := 0;
    37 : (* - *)
      IF (STEM = '„')
        THEN CLASS := 16
      ELSE IF (STEM = 'ƒ‘„')
        THEN CLASS := 21
        ELSE CLASS := 0;
    38..41 : (* -€/-€€/-€/-€ *)
      IF (STEM = '‘')
        THEN CLASS := 19
        ELSE CLASS := 0;
    44 : (* -… *)
      IF (STEM = '’')
        THEN CLASS := 13
        ELSE CLASS := 0;
    45,46,47 : (* -…/-/-… *)
      IF (STEM = 'ƒ‘„')
        THEN CLASS := 21
        ELSE CLASS := 0;
    48 : (* -…‰ *)
      IF (STEM = '—') OR (STEM = '—') OR (STEM = '…-—')
        THEN CLASS := 20
        ELSE CLASS := 0;
    49 : (* - *)
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
    IF (POS ('… ', TOKEN) = 1) OR (POS (' ', TOKEN) = 1)
      OR (POS (' ', TOKEN) = 1) OR (POS ('‹ ', TOKEN) = 1)
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
          IF CLASS = 0
            THEN
              BEGIN
                WRITELN (FNAME, ' ERROR: Wrong adjective ', STEM);
                HALT;
              END;
        END;
  END;

PROCEDURE INIT_ARRAY;
        (*==========*)
  VAR I : WORD;
BEGIN
  FOR I := 1 TO MAXPART DO
    WITH PARTARR [I] DO
      BEGIN
        NEG  := FALSE;
        TOKN := DUMMY;
        SOBN := 0;
        ONLYDOT := 0;
        GCAS := NOGCAS;
        ADJCLS := 0;
        FLEX := DUMMY;
        FLX1 := DUMMY;
        IDI := 0;
        STY := 0;
      END;
 END;

FUNCTION HAS0CL (TOKEN : STR115): BOOLEAN;
       (*======*) 
  CONST
    ZERO_TOKS : ARRAY [1..19] OF STR115 =
('‚…‹','‚…‘','‚…‹‚€’','‚‹…','ƒ€‡„','„‹†…','‹',
'€‹','€‹‚€’','€„…','€……','…‚…‹','€‘‹›€',
'„','„…•…','„………','€„','€„…•…','€„………');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;

BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = ZERO_TOKS [I])
  UNTIL FOUND OR (I = 19);
  HAS0CL := FOUND;
END;

FUNCTION HASFIN (TOKEN : STR115;
       (*======*)FINAL : STR5) : BOOLEAN;
  VAR L : INTEGER;
BEGIN
  L := LENGTH (FINAL);
  HASFIN := COPY (TOKEN, LENGTH (TOKEN) - L + 1, L) = FINAL;
END;

PROCEDURE CODE_LINE (NUM : WORD;
        (*=========*)LINE : STR115);
  VAR
    LINE1 : STR115;
    I, P, P1, LOW, HIGH, MID : INTEGER;
    FOUND, FOUND1 : BOOLEAN;
    RESULT : RESTYPE;
    SOBSTR, PREPSTR, FLEXSTR : STR115;
    TMP : STR5;

BEGIN
  LINE1 := COPY (LINE, 3, LENGTH (LINE) - 2);
  WITH PARTARR [NUM] DO
    BEGIN
(* ‘‚€‚€… ‡€—…‰ „€’—‘’  “’…’…‹‘’ *)
      IDI := IDIOM;
      STY := STYL;
      ADJCLS := CL;

(* ’„…‹…… ‡€‚…€™…ƒ ƒ’— (…‘‹  …‘’) *)
      IF COPY (LINE1, LENGTH (LINE1) - 3, 4) = ' ...'
        THEN
          BEGIN
            ONLYDOT := 4;
            LINE1 := COPY (LINE1, 1, LENGTH (LINE1) - 4);
          END;

(* ’„…‹…… —€‘’–› "…" *)
      NEG := POS (NE, LINE1) = 1;
      IF NEG
        THEN LINE1 := COPY (LINE1, 4, LENGTH (LINE) - 3);
      P := POS (BL, LINE1);
      TOKN := COPY (LINE1, 1, P - 1);
      LINE1 := COPY (LINE1, P + 1, LENGTH (LINE1) - P);

(* ‚›„…‹…… ‘‹‚‘—…’€… ‘ "‘…/‘……/‘‰" *)
      P := POS ('‘', LINE1) + POS ('‘…', LINE1);
      IF P = 0
        THEN SOBN := 0
        ELSE
          BEGIN
            REPEAT
              INC (P);
            UNTIL (LINE1 [P] = BL);

            SOBSTR := COPY (LINE1, 1, P - 1);
            LINE1 := COPY (LINE1, P + 1, LENGTH (LINE1) - P);

            FOUND1 := FALSE;
            I := 0;
            REPEAT 
              INC(I); 
              FOUND1 := (SOBSTR = SOBOJ [I]);
            UNTIL FOUND1 OR (I = 48);

            IF FOUND1
              THEN SOBN := I
              ELSE WRITELN (FNAME, ' ERROR: WRONG REFLEXIVE AT: ',
                HEADER, '=>', LINE);
          END;

(* ‚›„…‹…… —€‘’–› "…/" ‹ ƒ’— *)
      IF POS (NE, LINE1) = 1
        THEN ONLYDOT := 1
      ELSE IF POS (NI, LINE1) = 1
        THEN ONLYDOT := 2
      ELSE IF POS (DOTS, LINE1) = 1
        THEN
          IF ONLYDOT = 4
            THEN WRITELN (FNAME, ' ERROR: DOUBLE DOTS AT ', LINE)
            ELSE ONLYDOT := 3;
      IF (ONLYDOT > 0) AND (ONLYDOT < 4)
        THEN
          IF ONLYDOT < 3
            THEN LINE1 := COPY (LINE1, 4, LENGTH (LINE1) - 3)
            ELSE LINE1 := COPY (LINE1, 5, LENGTH (LINE1) - 4);

(* ‚›„…‹…… …„‹ƒ€, ‘’ƒ ‹ ‘‹†ƒ *)
      GCAS := 0; (* ……„ „€‹…‰…‰ €’‰ *)
      P := POS ('~', LINE1);
      IF P = 0
        THEN
          BEGIN
            WRITELN (FNAME, ' ERROR: LACK OF TILDE AT ', HEADER, '=>', LINE);
            EXIT;
          END;
{}
      PREPSTR := COPY (LINE1, 1, P-2);
IF PREPSTR > DUMMY
  THEN
    BEGIN
      LOW := 8;
      HIGH := MAXPREP;
      FOUND := FALSE;

      WHILE (HIGH >= LOW) AND NOT FOUND DO
        BEGIN
          MID := (HIGH + LOW) DIV 2;
          COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
          CASE RESULT OF
            LT : HIGH := MID - 1;
            EQ : FOUND := TRUE;
            GT : LOW := MID + 1;
          END;
        END;

      IF FOUND
        THEN
          BEGIN
            GCAS := MID;
            INC (PREPO [MID]);
         END
      ELSE
        BEGIN
          LOW := MAXPREP + 4;
          HIGH := MAXPREP2;
          FOUND := FALSE;

          WHILE (HIGH >= LOW) AND NOT FOUND DO
            BEGIN
              MID := (HIGH + LOW) DIV 2;
              COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
              CASE RESULT OF
                LT : HIGH := MID - 1;
                EQ : FOUND := TRUE;
                GT : LOW := MID + 1;
              END;
            END;

          IF FOUND
            THEN
              BEGIN
                GCAS := MID;
                INC (PREPO [MID]);
              END
          ELSE
            BEGIN
              LOW := MAXPREP2 + 1;
              HIGH := MAXPREP3;
              FOUND := FALSE;

              WHILE (HIGH >= LOW) AND NOT FOUND DO
                BEGIN
                  MID := (HIGH + LOW) DIV 2;
                  COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
                  CASE RESULT OF
                    LT : HIGH := MID - 1;
                    EQ : FOUND := TRUE;
                    GT : LOW := MID + 1;
                  END;
               END;
           
              IF FOUND
                THEN
                  BEGIN
                    GCAS := MID;
                    INC (PREPO [MID]);
                  END
              ELSE
                BEGIN
                  LOW := MAXPREP3 + 1;
                  HIGH := MAXPREP4;
                  FOUND := FALSE;

                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                    BEGIN
                      MID := (HIGH + LOW) DIV 2;
                      COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
                      CASE RESULT OF
                        LT : HIGH := MID - 1;
                        EQ : FOUND := TRUE;
                        GT : LOW := MID + 1;
                      END;
                    END;

                  IF FOUND
                    THEN
                      BEGIN
                        GCAS := MID;
                        INC (PREPO [MID]);
                      END
                  ELSE
                    BEGIN
                      LOW := MAXPREP4 + 1;
                      HIGH := MAXPREP5;
                      FOUND := FALSE;

                      WHILE (HIGH >= LOW) AND NOT FOUND DO
                        BEGIN
                          MID := (HIGH + LOW) DIV 2;
                          COMPARE_TOK (PREPSTR, 
                            PREPOS [MID].PRP, RESULT);
                          CASE RESULT OF
                            LT : HIGH := MID - 1;
                            EQ : FOUND := TRUE;
                            GT : LOW := MID + 1;
                          END;
                        END;

                      IF FOUND
                        THEN
                          BEGIN
                            GCAS := MID;
                            INC (PREPO [MID]);
                          END
                      ELSE
                        BEGIN
                          LOW := MAXPREP5 + 1;
                          HIGH := MAXPREP6;
                          FOUND := FALSE;
        
                          WHILE (HIGH >= LOW) AND NOT FOUND DO
                            BEGIN
                              MID := (HIGH + LOW) DIV 2;
                              COMPARE_TOK (PREPSTR, 
                                PREPOS [MID].PRP, RESULT);
                              CASE RESULT OF
                                LT : HIGH := MID - 1;
                                EQ : FOUND := TRUE;
                                GT : LOW := MID + 1;
                              END;
                            END;

                          IF FOUND
                            THEN
                              BEGIN
                                GCAS := MID;
                                INC (PREPO [MID]);
                              END
                          ELSE
                            BEGIN
                              LOW := MAXPREP6 + 1;
                              HIGH := MAXPREP7;
                              FOUND := FALSE;

                              WHILE (HIGH >= LOW) AND NOT FOUND DO
                                BEGIN
                                  MID := (HIGH + LOW) DIV 2;
                                  COMPARE_TOK (PREPSTR, 
                                    PREPOS [MID].PRP, RESULT);
                                  CASE RESULT OF
                                    LT : HIGH := MID - 1;
                                    EQ : FOUND := TRUE;
                                    GT : LOW := MID + 1;
                                  END;
                                END;

                              IF FOUND
                                THEN
                                  BEGIN
                                    GCAS := MID;
                                    INC (PREPO [MID]);
                                  END
                              ELSE
                                BEGIN
                                  LOW := MAXPREP7 + 1;
                                  HIGH := MAXPREP8;
                                  FOUND := FALSE;

                                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                                    BEGIN
                                      MID := (HIGH + LOW) DIV 2;
                                        COMPARE_TOK (PREPSTR, 
                                      PREPOS [MID].PRP, RESULT);
                                      CASE RESULT OF
                                        LT : HIGH := MID - 1;
                                        EQ : FOUND := TRUE;
                                        GT : LOW := MID + 1;
                                      END;
                                    END;
                                
                                  IF FOUND
                                    THEN
                                      BEGIN
                                        GCAS := MID;
                                        INC (PREPO [MID]);
                                      END
                                  ELSE
                                    BEGIN
                                      LOW := MAXPREP8 + 1;
                                      HIGH := MAXPREP9;
                                      FOUND := FALSE;

                                      WHILE (HIGH >= LOW) AND NOT FOUND DO
                                        BEGIN
                                          MID := (HIGH + LOW) DIV 2;
                                          COMPARE_TOK (PREPSTR, 
                                            PREPOS [MID].PRP, RESULT);
                                          CASE RESULT OF
                                            LT : HIGH := MID - 1;
                                            EQ : FOUND := TRUE;
                                            GT : LOW := MID + 1;
                                          END;
                                        END;
           
                                      IF FOUND
                                        THEN
                                          BEGIN
                                            GCAS := MID;
                                            INC (PREPO [MID]);
                                          END
                                      ELSE
                                        BEGIN
                                          LOW := MAXPREP9 + 1;
                                          HIGH := MAXPREP10;
                                          FOUND := FALSE;

                                          WHILE (HIGH >= LOW) AND NOT FOUND DO
                                            BEGIN
                                              MID := (HIGH + LOW) DIV 2;
                                              COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
                                              CASE RESULT OF
                                                LT : HIGH := MID - 1;
                                                EQ : FOUND := TRUE;
                                                GT : LOW := MID + 1;
                                              END;
                                            END;

                                          IF FOUND
                                            THEN
                                              BEGIN
                                                GCAS := MID;
                                                INC (PREPO [MID]);
                                              END
                                          ELSE
                                            BEGIN
                                              LOW := MAXPREP10 + 1;
                                              HIGH := MAXPREP11;
                                              FOUND := FALSE;

                                              WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                BEGIN
                                                  MID := (HIGH + LOW) DIV 2;
                                                  COMPARE_TOK (PREPSTR, 
                                                    PREPOS [MID].PRP, RESULT);
                                                  CASE RESULT OF
                                                    LT : HIGH := MID - 1;
                                                    EQ : FOUND := TRUE;
                                                    GT : LOW := MID + 1;
                                                  END;
                                                END;
                                              
                                              IF FOUND
                                                THEN
                                                  BEGIN
                                                    GCAS := MID;
                                                    INC (PREPO [MID]);
                                                  END
                                              ELSE
                                                BEGIN
                                                  LOW := MAXPREP11 + 1;
                                                  HIGH := MAXPREP12;
                                                  FOUND := FALSE;

                                                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                    BEGIN
                                                      MID := (HIGH + LOW) DIV 2;
                                                      COMPARE_TOK (PREPSTR, 
                                                        PREPOS [MID].PRP, RESULT);
                                                      CASE RESULT OF
                                                        LT : HIGH := MID - 1;
                                                        EQ : FOUND := TRUE;
                                                        GT : LOW := MID + 1;
                                                      END;
                                                    END;

                                                  IF FOUND
                                                    THEN
                                                      BEGIN
                                                        GCAS := MID;
                                                        INC (PREPO [MID]);
                                                      END
                                                  ELSE
                                                    BEGIN
                                                      LOW := MAXPREP12 + 1;
                                                      HIGH := MAXPREP13;
                                                      FOUND := FALSE;
                                    
                                                      WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                        BEGIN
                                                          MID := (HIGH + LOW) DIV 2;
                                                          COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
                                                          CASE RESULT OF
                                                            LT : HIGH := MID - 1;
                                                            EQ : FOUND := TRUE;
                                                            GT : LOW := MID + 1;
                                                          END;
                                                        END;

                                                      IF FOUND
                                                        THEN
                                                          BEGIN
                                                            GCAS := MID;
                                                            INC (PREPO [MID]);
                                                          END
                                                      ELSE
{---------------------------------------------------}
                        BEGIN
                          LOW := MAXPREP13 + 1;
                          HIGH := MAXPREP14;
                          FOUND := FALSE;
                        
                          WHILE (HIGH >= LOW) AND NOT FOUND DO
                            BEGIN
                              MID := (HIGH + LOW) DIV 2;
                              COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
                              CASE RESULT OF
                                LT : HIGH := MID - 1;
                                EQ : FOUND := TRUE;
                                GT : LOW := MID + 1;
                              END;
                            END;

                          IF FOUND
                            THEN
                              BEGIN
                                GCAS := MID;
                                INC (PREPO [MID]);
                              END
                          ELSE
                            BEGIN
                              LOW := MAXPREP14 + 1;
                              HIGH := MAXPREP15;
                              FOUND := FALSE;
                           
                              WHILE (HIGH >= LOW) AND NOT FOUND DO
                                BEGIN
                                  MID := (HIGH + LOW) DIV 2;
                                  COMPARE_TOK (PREPSTR, PREPOS [MID].PRP, RESULT);
                                  CASE RESULT OF
                                    LT : HIGH := MID - 1;
                                    EQ : FOUND := TRUE;
                                    GT : LOW := MID + 1;
                                  END;
                                END;

                              IF FOUND
                                THEN
                                  BEGIN
                                    GCAS := MID;
                                    INC (PREPO [MID]);
                                  END
                              ELSE
                                BEGIN
                                  LOW := MAXPREP15 + 1;
                                  HIGH := MAXPREP16;
                                  FOUND := FALSE;
                                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                                  BEGIN
                                    MID := (HIGH + LOW) DIV 2;
                                    COMPARE_TOK (PREPSTR, 
                                      PREPOS [MID].PRP, RESULT);
                                    CASE RESULT OF
                                      LT : HIGH := MID - 1;
                                      EQ : FOUND := TRUE;
                                      GT : LOW := MID + 1;
                                    END;
                                  END;

                                  IF FOUND
                                    THEN
                                      BEGIN
                                        GCAS := MID;
                                        INC (PREPO [MID]);
                                      END
                                  ELSE
                                    BEGIN
                                      LOW := MAXPREP16 + 1;
                                      HIGH := MAXPREP17;
                                      FOUND := FALSE;
                                      WHILE (HIGH >= LOW) AND NOT FOUND DO
                                      BEGIN
                                        MID := (HIGH + LOW) DIV 2;
                                        COMPARE_TOK (PREPSTR, 
                                        PREPOS [MID].PRP, RESULT);
                                        CASE RESULT OF
                                          LT : HIGH := MID - 1;
                                          EQ : FOUND := TRUE;
                                          GT : LOW := MID + 1;
                                        END;
                                      END;

                                      IF FOUND
                                        THEN
                                          BEGIN
                                            GCAS := MID;
                                            INC (PREPO [MID]);
                                          END
                                      ELSE
                                        BEGIN
                                          LOW := MAXPREP17 + 1;
                                          HIGH := MAXPREP18;
                                          FOUND := FALSE;
                                          WHILE (HIGH >= LOW) AND NOT FOUND DO
                                          BEGIN
                                            MID := (HIGH + LOW) DIV 2;
                                            COMPARE_TOK (PREPSTR, 
                                            PREPOS [MID].PRP, RESULT);
                                            CASE RESULT OF
                                              LT : HIGH := MID - 1;
                                              EQ : FOUND := TRUE;
                                              GT : LOW := MID + 1;
                                            END;
                                          END;

                                          IF FOUND
                                            THEN
                                              BEGIN
                                                GCAS := MID;
                                                INC (PREPO [MID]);
                                              END
                                          ELSE 
                                            BEGIN
                                              LOW := MAXPREP18 + 1;
                                              HIGH := MAXPREP19;
                                              FOUND := FALSE;
                                              WHILE (HIGH >= LOW) AND NOT FOUND DO
                                              BEGIN
                                                MID := (HIGH + LOW) DIV 2;
                                                COMPARE_TOK (PREPSTR, 
                                                PREPOS [MID].PRP, RESULT);
                                                CASE RESULT OF
                                                  LT : HIGH := MID - 1;
                                                  EQ : FOUND := TRUE;
                                                  GT : LOW := MID + 1;
                                                END;
                                              END;
      
                                              IF FOUND
                                                THEN
                                                  BEGIN
                                                    GCAS := MID;
                                                    INC (PREPO [MID]);
                                                  END
                                              ELSE 
                                                BEGIN
                                                  LOW := MAXPREP19 + 1;
                                                  HIGH := MAXPREP20;
                                                  FOUND := FALSE;
                                                                                                           WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                  BEGIN
                                                    MID := (HIGH + LOW) DIV 2;
                                                    COMPARE_TOK (PREPSTR, 
                                                    PREPOS [MID].PRP, RESULT);
                                                    CASE RESULT OF
                                                      LT : HIGH := MID - 1;
                                                      EQ : FOUND := TRUE;
                                                      GT : LOW := MID + 1;
                                                    END;
                                                  END;
                                                
                                                  IF FOUND
                                                    THEN
                                                      BEGIN
                                                        GCAS := MID;
                                                        INC (PREPO [MID]);
                                                      END
                                                  ELSE
                                                    BEGIN
                                                      LOW := MAXPREP20 + 1;
                                                      HIGH := 
                                                      MAXPREP21;
                                                      FOUND := FALSE;
                                                      WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                      BEGIN
                                                        MID := (HIGH + LOW) DIV 2;
                                                        COMPARE_TOK (PREPSTR, 
                                                          PREPOS [MID].PRP, RESULT);
                                                        CASE RESULT OF
                                                          LT : HIGH := MID - 1;
                                                          EQ : FOUND := TRUE;
                                                          GT : LOW := MID + 1;
                                                        END;
                                                      END;
                                                
                                                      IF FOUND
                                                        THEN
                                                          BEGIN
                                                            GCAS := MID;
                                                            INC (PREPO [MID]);
                                                          END
                                                      ELSE
                                                        BEGIN
                                                          LOW := MAXPREP21 + 1;
                                                          HIGH := MAXPREP22;
                                                          FOUND := FALSE;
                                                          WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                            BEGIN
                                                              MID := (HIGH + LOW) DIV 2;
                                                              COMPARE_TOK (PREPSTR, 
                                                                PREPOS [MID].PRP, RESULT);
                                                              CASE RESULT OF
                                                                LT : HIGH := MID - 1;
                                                                EQ : FOUND := TRUE;
                                                                GT : LOW := MID + 1;
                                                              END;
                                                            END;
                                                          
                                                     {------------}         
                                                          IF FOUND
                                                            THEN
                                                              BEGIN
                                                                GCAS := MID;
                                                                INC (PREPO [MID]);
                                                              END
                                                          ELSE
                                                            BEGIN
                                                              LOW := MAXPREP22 + 1;
                                                              HIGH := MAXPREP23;
                                                              FOUND := FALSE;
                                                              WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                BEGIN
                                                                  MID := (HIGH + LOW) DIV 2;
                                                                  COMPARE_TOK (PREPSTR, 
                                                                  PREPOS [MID].PRP, RESULT);
                                                                  CASE RESULT OF
                                                                    LT : HIGH := MID - 1;
                                                                    EQ : FOUND := TRUE;
                                                                    GT : LOW := MID + 1;
                                                                  END;
                                                                END;
                                                         
                                                              IF FOUND
                                                                THEN
                                                                  BEGIN
                                                                    GCAS := MID;
                                                                    INC (PREPO [MID]);
                                                                  END
                                                              ELSE
                                                                BEGIN
                                                                  LOW := MAXPREP23 + 1;
                                                                  HIGH := MAXPREP24;
                                                                  FOUND := FALSE;
                                                                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                    BEGIN
                                                                      MID := (HIGH + LOW) DIV 2;
                                                                      COMPARE_TOK (PREPSTR, 
                                                                      PREPOS [MID].PRP, RESULT);
                                                                      CASE RESULT OF
                                                                        LT : HIGH := MID - 1;
                                                                        EQ : FOUND := TRUE;
                                                                        GT : LOW := MID + 1;
                                                                      END;
                                                                    END;
                                                                  
                                                                  IF FOUND
                                                                     THEN
                                                                       BEGIN
                                                                         GCAS := MID;
                                                                         INC (PREPO [MID]);
                                                                       END
                                                                  ELSE
                                                                    BEGIN
                                                                      LOW := MAXPREP24 + 1;
                                                                      HIGH := MAXPREP25;
                                                                      FOUND := FALSE;
                                                                      WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                        BEGIN
                                                                          MID := (HIGH + LOW) DIV 2;
                                                                          COMPARE_TOK (PREPSTR, 
                                                                          PREPOS [MID].PRP, RESULT);
                                                                          CASE RESULT OF
                                                                            LT : HIGH := MID - 1;
                                                                            EQ : FOUND := TRUE;
                                                                            GT : LOW := MID + 1;
                                                                          END;
                                                                        END;
                                                            
                                                                      IF FOUND                                 
                                                                        THEN                                   
                                                                          BEGIN                                
                                                                            GCAS := MID;                       
                                                                            INC (PREPO [MID]);                 
                                                                          END                                  
                                                                      ELSE                                     
                                                                        BEGIN                                 
                                                                          LOW := MAXPREP25 + 1;               
                                                                          HIGH := MAXPREP26;                  
                                                                          FOUND := FALSE;                     
                                                                          WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                            BEGIN                             
                                                                              MID := (HIGH + LOW) DIV 2;      
                                                                              COMPARE_TOK (PREPSTR,           
                                                                              PREPOS [MID].PRP, RESULT);      
                                                                              CASE RESULT OF                  
                                                                                LT : HIGH := MID - 1;         
                                                                                EQ : FOUND := TRUE;           
                                                                                GT : LOW := MID + 1;          
                                                                              END;                            
                                                                            END;                              
                                                                                                               
                                                                          IF FOUND                                 
                                                                            THEN                                   
                                                                              BEGIN                                
                                                                                GCAS := MID;                       
                                                                                INC (PREPO [MID]);                 
                                                                              END                                  
                                                                          ELSE                                     
                                                                            BEGIN                                 
                                                                              LOW := MAXPREP26 + 1;               
                                                                              HIGH := MAXPREP27;                  
                                                                              FOUND := FALSE;                     
                                                                              WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                                BEGIN                             
                                                                                  MID := (HIGH + LOW) DIV 2;      
                                                                                  COMPARE_TOK (PREPSTR,           
                                                                                  PREPOS [MID].PRP, RESULT);      
                                                                                  CASE RESULT OF                  
                                                                                    LT : HIGH := MID - 1;         
                                                                                    EQ : FOUND := TRUE;           
                                                                                    GT : LOW := MID + 1;          
                                                                                  END;                            
                                                                                END;                              
                                                                  
                                                                               IF FOUND                                 
                                                                                 THEN                                   
                                                                                   BEGIN                                
                                                                                     GCAS := MID;                       
                                                                                     INC (PREPO [MID]);                 
                                                                                   END                                  
                                                                               ELSE                                     
                                                                                 BEGIN                                 
                                                                                   LOW := MAXPREP27 + 1;               
                                                                                   HIGH := MAXPREP28;                  
                                                                                   FOUND := FALSE;                     
                                                                                   WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                                     BEGIN                             
                                                                                       MID := (HIGH + LOW) DIV 2;      
                                                                                       COMPARE_TOK (PREPSTR,           
                                                                                       PREPOS [MID].PRP, RESULT);      
                                                                                       CASE RESULT OF                  
                                                                                         LT : HIGH := MID - 1;         
                                                                                         EQ : FOUND := TRUE;           
                                                                                         GT : LOW := MID + 1;          
                                                                                       END;                            
                                                                                     END;                              
                                                                            
                                                                                   IF FOUND                                 
                                                                                     THEN                                   
                                                                                       BEGIN                                
                                                                                         GCAS := MID;                       
                                                                                         INC (PREPO [MID]);                 
                                                                                       END                                  
                                                                                   ELSE                                     
                                                                                     BEGIN                                 
                                                                                       LOW := MAXPREP28 + 1;               
                                                                                       HIGH := MAXPREP29;                  
                                                                                       FOUND := FALSE;                     
                                                                                       WHILE (HIGH >= LOW) AND NOT FOUND DO
                                                                                         BEGIN                             
                                                                                           MID := (HIGH + LOW) DIV 2;      
                                                                                           COMPARE_TOK (PREPSTR,           
                                                                                           PREPOS [MID].PRP, RESULT);      
                                                                                           CASE RESULT OF                  
                                                                                             LT : HIGH := MID - 1;         
                                                                                             EQ : FOUND := TRUE;           
                                                                                             GT : LOW := MID + 1;          
                                                                                           END;                            
                                                                                         END;                              
                                                                                                                        
                                                                                       IF FOUND   
                                                                                         THEN     
                                                                                           BEGIN  
                                                                                             GCAS := MID;
                                                                                             INC (PREPO [MID]);
                                                                                           END
                                                                                       ELSE 
	                                                                                 WRITELN (FNAME, 
                                                                                           ' ERROR: Wrong preposition at ',
                                                                                           HEADER, '=>', LINE);
                                                                                    END;
                                                                                END;
                                                                            END;
                                                                        END;
                                                                    END;
                                                                END;
                                                            END;
                                                        END;
                                                    END;
{---------------------------------------------------  ------}
                                                END;  
                                            END;      
                                        END;          
                                    END;              
                                END;                  
                            END;                      
                        END;                          
{---------------------------------------------------  }
                                                    END;
                                                END;
                                            END;
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;                                                                                                                                                                
                END;
            END;
        END;
    END;
                
(* ’„…‹…… ”‹…‘ *)
      FLEXSTR := COPY (LINE1, P + 1, LENGTH (LINE1) - P);
      P1 := POS ('~', FLEXSTR);
      IF P1 = 0
        THEN
          BEGIN
            IF DOUBLE_FL
              THEN WRITELN (FNAME, ' ERROR: WRONG TILDES FOR ', HEADLINE)
              ELSE
                IF FLEXSTR = DUMMY
                  THEN FLEX := '~'
                  ELSE FLEX := FLEXSTR;
          END
        ELSE
          BEGIN
            FLEX := COPY (FLEXSTR, 1, P1 - 2);
            IF FLEX = DUMMY
              THEN FLEX := '~';
            FLX1 := COPY (FLEXSTR , P1 + 1, LENGTH (FLEXSTR) - P1);
            IF FLX1 = DUMMY
              THEN FLX1 := '~';
            IF FL_REVERS
              THEN
                BEGIN
                  TMP := FLEX;
                  FLEX := FLX1;
                  FLX1 := TMP;
                END;
          END;
    END;
END;

   (* ‚‡†… ‹ €’’‚›‰ €„…† “ TOKEN? *)
FUNCTION PART_POSSIBLE (TOKEN : STR115) : BOOLEAN;
       (*=============*)
  CONST
    PART_TOKENS : ARRAY [1..42] OF STRING [7] =
('…‡','‚‡„','‚„','ƒ€‡','„‹ƒ','„“•','„›','†€',
'‚€‘','“€†','’','','‹…„',
'€•','…„','“‘','€','……–','…‘','•','“•',
'‘€•€','‘‚…’','‘…ƒ','‘','‘‹','‘’€•','‘“','‘›',
'’€€','’‹','’“€','”‘','•„','•‹„',
'—€‰','—…‘','…‹','…‘’','','‹€„','•');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;

BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = PART_TOKENS [I])
  UNTIL FOUND OR (I = 42);
  PART_POSSIBLE := FOUND;
END;

      (* —€‘’…/ƒ€ƒ€’…‹… TOKEN ……’ ‘›‘‹ „€’…‹‘’? *)
FUNCTION MEANS_DATIV (TOKEN : STR115) : BOOLEAN;
       (*===========*)
  CONST
    MAXDAT = 108;
    SOME_TOKENS : ARRAY [1..MAXDAT] OF STRING [24] =
('‚‡‚€™€‚‰','‚‡‚€’‚‰','‚‡‚€™€™‰',
'‚“€‚‰','‚“‚‰','‚“€™‰',
'„€‚‰','„€™‰','„€™‰‘','€‚‚‰','€‚‹™‰','‘‹€‚‰',
'‘›‹€™‰','‘’€‚‚‰','‘’€‚‹™‰','“‘’“€™‰','“‘’“‚‰',
'“—‚‰','“—€™‰','‘’‚‰','™€™‰','’‚…’‚‰',
'’‚…—€™‰','„€‚‰','„‹†‚‰','€„','€„“™‰‘',
'…—€‹™‰‘','ƒ—€™‰‘','ƒ—‚‰‘','‚…ƒ€™‰',
'‚…ƒ“‚‰','‚…ƒ€™‰‘','‚…ƒ“‚‰‘','‚…‚‰','„‹†…',
'‚…™‰','€„‹…†€‚‰','‡€‚„“™‰','‘‚’‚‰','‘‚™€‚‰',
'ƒ€™‰','‘‹…„“™‰','‘‚…’“™‰','ƒ‚™‰','‘€‚‰',
'…™€‚‰','‡–›‰','“‚‰','—™‰','—‚‰',
'—™‰‘','—‚‰‘','€„‹…†€™‰','€„‹…†€‚‰',
'…’‘’‚“™‰','…’‘’‚‚€‚‰',
'‘’‚…’‘’‚“™‰','‘’‚…’‘’‚‚€‚‰','“„‚‹…’‚™‰',
'“„‚‹…’‚‚‰','‘‹“†€™‰','’‚…—€™‰','‹…†€™‰','€†€™‰',
'‘’€‚™‰','“ƒ†€™‰','‘“‹™‰','‘—“‚‘’‚“™‰','‘€’‡“™‰',
'‡‚™‰','‡€‚‰‘','‡€‚€™‰‘','“—‚‰‘','“„‚‚‰‘',
'“„‚‹™‰‘','’‚™‰‘','‘’‚‹™‰‘','‡“‚‰‘',
'‡“‹™‰‘','’…“™‰‘','“—€™‰‘','“—‚‰‘',
'“—€™‰','“—‚‰','„‘’€‚‚‰','„‘’€‚‹™‰','…„€›‰',
'’‚„…‰‘’‚“™‰','’‚„…‰‘’‚‚€‚‰','€‚™‰‘',
'…„‹†‚‰','ƒ€‚‰','…„‹€ƒ€™‰','„‚…†…›‰',
'„‚…ƒ€…›‰','„‚…ƒ€‚‰','„‚…ƒ€‚‰‘','„‚…ƒ€™‰',
'’‚‘’€‚‚‰','’‚‘’€‚‹…›‰','’‚‘’€‚‹‚‰'
,'’‚‘’€‚‹‚‰‘',
'„‚…ƒ€™‰‘','†€‹“™‰‘','‘€‡€‚‰','‡€‚‚‰','‚‰‘');

SOME_PREFS : ARRAY [1..16] OF STR5 =
  ('‚','‚‘','‚›','„','€','','','……','',
   '„','…„','…„','…','…','','');
  VAR
    I, J, L, L0 : INTEGER;
    FOUND : BOOLEAN;

BEGIN
  L0 := LENGTH (TOKEN);
  FOUND := FALSE;
  I := 0;

  REPEAT
    INC (I);
    L := LENGTH (SOME_TOKENS [I]);
    FOUND := (SOME_TOKENS [I] = COPY (TOKEN, L0-L+1, L));
  UNTIL FOUND OR (I = MAXDAT);

  IF NOT FOUND
    THEN MEANS_DATIV := FALSE
    ELSE
      IF L = L0
        THEN MEANS_DATIV := TRUE
        ELSE
          BEGIN
            FOUND := FALSE;
            J := 0;
            REPEAT
              INC (J);
              FOUND := (TOKEN = SOME_PREFS [J] + SOME_TOKENS [I]);
            UNTIL FOUND OR (J = 16);
            MEANS_DATIV := FOUND;
          END;
END;

    (* —€‘’… TOKEN ……’ ‘›‘‹ ‘’“…’€‹‘’? *)
FUNCTION MEANS_INSTR (TOKEN : STR115) : BOOLEAN;
       (*===========*)
  CONST
    SOME_TOKENS : ARRAY [1..74] OF STRING [17] =
('†€™‰‘','‚‹€„…™‰','‚‡ƒ‹€‚‹…›‰','‚‘•™€™‰‘',
'‚›“†„€…›‰','‚›“†„…›‰','‚›€†€™‰‘','‚›€‡‚‰‘',
'ƒ„™‰‘','„…’…“…›‰','„‚‹›‰','„‚‹‘’‚“™‰‘',
'‡€—…›‰','‡€—‚‰‘','‡€€‡‚‰‘','‡€€†…›‰',
'€‡€‚‰‘','‹“™‰‘','“—›‰','“—€™‰‘',
'€€‚‹…›‰','€‘‹€„‚‰‘','€‘‹€†„€™‰‘','€‚™‰‘',
'€‘›™€™‰‘','€‘›’‚‰‘','€‘›™…›‰',
'‹€„€™‰','€“‚‰‘','€“’›‰','•„™‰‘','‘€†„€…›‰',
'‘™‰‘','‘…›‰','ƒ€—‚‰‘','ƒ€—…›‰',
'‘‹…›‰','‘‚‰‘','‘‹™‰‘','€‡€‚‰‘',
'€‡›‚€™‰‘','‘’€™‰‘','’‹—‚‰‘','—€‚€›‰',
'…„…‹™‰‘','…„…‹…›‰','ƒ€—‚€™‰‘','ƒ€—…›‰',
'‘’€‚‹…›‰','‹™€™‰‘','’‹—€™‰‘',
'€•“‚‰','‹‚‰‘','‹‡“™‰‘','…—€‹™‰‘','‹›‰',
'€‰‘','“’›‰','’€™‰‘','’€›‰',
'€•“‚‰','—‚‰‘','‡€€—‚€™‰‘',
'…ƒ“‹“™‰‘','…ƒ“‹“…›‰','‘’€„€™‰','‘’€‚‰','‘’€‚™‰‘',
'’™‰‘','’ƒ’™‰‘',
'“‘€‚€™‰‘','“’…‚‰‘','“’…€™‰‘','‚‹™‰‘');
    SOME_PREFS : ARRAY [1..12] OF STR5 =
      ('‚‘','‡€','‘','€','','','’','','','€‡','€‡','“');
  VAR
    I, J, L, L0 : INTEGER;
    FOUND : BOOLEAN;

BEGIN
  L0 := LENGTH (TOKEN);
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    L := LENGTH (SOME_TOKENS [I]);
    FOUND := (SOME_TOKENS [I] = COPY (TOKEN, L0 - L + 1, L));
  UNTIL FOUND OR (I = 74);
  IF NOT FOUND
    THEN MEANS_INSTR := FALSE
    ELSE
      IF L = L0
        THEN MEANS_INSTR := TRUE
        ELSE
          BEGIN
            FOUND := FALSE;
            J := 0;
            REPEAT
              INC (J);
              FOUND := (TOKEN = SOME_PREFS [J] + SOME_TOKENS [I]);
            UNTIL FOUND OR (J = 12);
            MEANS_INSTR := FOUND;
          END;
END;


    (* —€‘’… TOKEN ……’ ‘›‘‹ ƒ…’‚‘’? *)
FUNCTION MEANS_GENIT0 (TOKEN : STR115) : BOOLEAN;
       (*============*)
  CONST
    SOME_TOKENS : ARRAY [1..9] OF STRING [18] =
      ('„€‚‹™‰','„€‚‚‰','„€‚€‚‰','„€™‰',
      '€‹‚€‚‰','€‹‚€™‰','‹†‚‰','€‹†‚‰',
      '€‹€„›‚€™‰');
   VAR
     I : INTEGER;
     FOUND : BOOLEAN;

BEGIN
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = 9);
  MEANS_GENIT0 := FOUND;
END;


    (* —€‘’… TOKEN ……’ ‘›‘‹ ƒ…’‚‘’? *)
FUNCTION MEANS_GENIT (TOKEN : STR115) : BOOLEAN;
       (*===========*)
  CONST
    SOME_TOKENS : ARRAY [1..44] OF STRING [18] =
      ('„…†‚€™‰‘','‘“ƒ€‚‰‘','“ƒ€™‰‘',
      '€‘€™‰‘','„‘’ƒ€™‰','„‘’ƒ“‚‰',
      '‘’™‰‘','‘’‚‰‘','™‰‘','‚‰‘',
      '‘’€€™‰‘','‘’€‚‰‘','—“€™‰‘','—“€‚‰‘',
      '„‚‰‘','„€‚‰‘','„€™‰‘','‘’……ƒ€‚‰‘',
      '‘’……ƒ€™‰‘','‡…ƒ€™‰','‡…†€‚‰',
      '„ƒ€™‰‘','„ƒ€‚‰‘','‘‹“€™‰‘','‘‹“€‚‰‘',
      '‘‹“€‚‰‘','€‘‹“€‚‰‘','€’……‚‰‘','€‚‰‘',
      '€‚€™‰‘','€‚€‚‰‘','„‚‰‘','„‚€™‰‘',
      '‹‚‰‘','‹€‚‰‘','‹€™‰‘','€€‚‰‘',
      '€€‚‰‘','€€™‰‘','€‚‰‘','€‚€‚‰‘',
      '€‚€™‰‘','‘’…‘‚‰‘','‘’…‘™‰‘');
   VAR
     I : INTEGER;
     FOUND : BOOLEAN;

BEGIN
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = 29);
  MEANS_GENIT := FOUND;
END;

  (* ‘’‚…’‘’‚“…’ ‹ „€€ ”‹…‘ „€“ €„…†“? *)
FUNCTION SUITED (FLEX : STR10;
       (*======*)CLASS : INTEGER;
                 CAS : CASUS;
                 VAR GCAS : INTEGER) : BOOLEAN;
BEGIN
  SUITED := FALSE;
  IF FLEX = FINALS [CLASS, CAS]
    THEN
      BEGIN
        SUITED := TRUE;
        GCAS := ORD (CAS);
      END;
END;

  (* ‘‚…… ™…ƒ €„…†€ *)
PROCEDURE ENCODE_ITEM (CLASS : INTEGER;
        (*===========*)NUM : WORD);
   VAR
     DONE : BOOLEAN;
     L : INTEGER;
     TOK1 : STR115;
BEGIN
  DONE := FALSE;
  WITH PARTARR [NUM] DO
    BEGIN
      L := LENGTH (TOKN);
      IF (POS (TOKN [L], '123456') > 0)
        THEN TOK1 := COPY (TOKN, 1, L - 1)
        ELSE TOK1 := TOKN;
      IF (CLASS = 0) AND (GCAS = 0)
        THEN
          BEGIN
            IF MEANS_INSTR (TOK1)
              THEN GCAS := 4
            ELSE IF MEANS_GENIT (TOK1)
              THEN GCAS := 1
            ELSE IF MEANS_DATIV (TOK1)
              AND ((TOK1 <> '“‚‰') AND (TOK1 <> '“€™‰') 
              AND (TOK1 <> '“€‚‰')
              AND (TOK1 <> '„€‚‰') AND (TOK1 <> '„€‚€‚‰') 
              AND (TOK1 <> '„€™‰')
              AND (TOK1 <> '„€‚‰') AND (TOK1 <> '„€‚€‚‰') 
              AND (TOK1 <> '„€™‰')
              OR (HEADER <> '€‹’') AND (HEADER <> '”…'))
              AND ((TOK1 <> '‘‹€‚‰') AND (TOK1 <> '‘›‹€‚‰') 
              AND (TOK1 <> '‘›‹€™‰')
              OR (HEADER <> '”’')) AND (HEADER <> '’…‚')
{‡€€•“‚ €‹’¬ - ®αβ «®αμ!}
              THEN GCAS := 2
              ELSE GCAS := 3;
            DONE := TRUE;
            EXIT;
          END;

      IF NOT DONE AND MEANS_GENIT0 (TOK1) AND (ONLYDOT = 4) AND (ANIM0 <> YES)
        AND SUITED (FLEX, CLASS, GEN, GCAS)
        THEN DONE := TRUE
      ELSE IF MEANS_DATIV (TOK1) AND (ANIM0 <> YES)
        AND SUITED (FLEX, CLASS, DAT, GCAS)
        THEN DONE := TRUE
      ELSE IF MEANS_INSTR (TOK1) AND SUITED (FLEX, CLASS, INS, GCAS)
        THEN DONE := TRUE
      ELSE IF NEG OR MEANS_GENIT (TOK1)
        THEN
          BEGIN
            IF SUITED (FLEX, CLASS, GEN, GCAS)
              THEN DONE := TRUE
            ELSE IF SUITED (FLEX, CLASS, ACC, GCAS)
              THEN DONE := TRUE;
          END
        ELSE
          BEGIN
            IF SUITED (FLEX, CLASS, ACC, GCAS)
              THEN DONE := TRUE
            ELSE IF SUITED (FLEX, CLASS, GEN, GCAS)
              THEN DONE := TRUE;
          END;
      IF NOT DONE
        THEN
          BEGIN
            IF SUITED (FLEX, CLASS, DAT, GCAS)
              THEN DONE := TRUE
            ELSE IF SUITED (FLEX, CLASS, INS, GCAS)
              THEN DONE := TRUE;
          END;
      IF NOT DONE
        THEN WRITELN (FNAME, ' ERROR: WRONG FLECTION FOR CLASS ',
          CLASS, '=>', HEADER, BL, TOKN, ' ~', FLEX);
    END;
END;


PROCEDURE ENCODE_VALID (CLASS : INTEGER);
        (*============*)
   VAR
     I : WORD;
     DONE : BOOLEAN;

BEGIN
  INC (AMT0);
  INC (AMT);
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        IF FLEX = '~'
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;

        IF (GCAS >= 8)
          THEN (* ‚…€ ‘’‚…’‘’‚ …„‹ƒ€ ”‹…‘ *)
            BEGIN
              IF (FINALS [CLASS, PREPOS [GCAS].CAS] <> FLEX)
                THEN WRITELN (FNAME, ' ERROR: PREPOSITION >< FLECTION: ', HEADER,
                  '->', TOKN, BL, PREPOS [GCAS].PRP, ' ~', FLEX);
            END
          ELSE (* ‚…€ …‘…„‹†.—€  „‚€… *)
            BEGIN
              DONE := FALSE;
              IF PART_POSSIBLE (HEADER)
                AND (COPY (TOKN, 1, 5) <> '‡…')
                AND (COPY (TOKN, 1, 4) <> '“„‚')
                AND SUITED (FLEX, CLASS, PAR, GCAS)
                THEN DONE := TRUE;
              IF NOT DONE
                THEN ENCODE_ITEM (CLASS, I);
            END;
      END;
END;


FUNCTION THERE_IS_FLEX (FLEX : STR10;
       (*=============*)CLASS : INTEGER) : BOOLEAN;
BEGIN
  THERE_IS_FLEX := (FLEX = FINALS [CLASS, GEN])
    OR (FLEX = FINALS [CLASS, DAT])
    OR (FLEX = FINALS [CLASS, ACC])
    OR (FLEX = FINALS [CLASS, INS]);
END;

   (* …‘’ ‹ “ „€ƒ ‹€‘‘€ „“…‚‹…›‰ €€‹ƒ  €‰? *)
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
{ ELSE WRITELN (FNAME, ' ERROR: WRONG INANIMATE CLASS: ', CLASS);}
END;


PROCEDURE ENCODE_INVAL1 (VAR CLASS : INTEGER;
        (*=============*)NUMB : NUMBER;
                         GEND : GENDER;
                         ANIM : ANIMA);
  VAR
    ANIMCL, L0 : INTEGER;
    I : WORD;
    DONE, OK, HERE_OK, ANIMABLE, HERE_ANIMABLE,
    FEMINABLE, HERE_FEMINABLE,
    MASCULABLE, HERE_MASCULABLE,
    ACCENTABLE, HERE_ACCENTABLE, CBA : BOOLEAN;
    CAS0 : CASUS;

BEGIN
  OK := TRUE;
  CBA := CAN_BE_ANIMATED (CLASS, ANIMCL);
  ANIMABLE := TRUE;
  FEMINABLE := TRUE;
  ACCENTABLE := TRUE;
  MASCULABLE := TRUE;

  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        L0 := LENGTH (FLEX);
        IF FLEX = '~'
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;
        HERE_MASCULABLE := (CLASS = 41) OR (CLASS = 43)
          OR (CLASS = 45) OR (CLASS = 46) OR (CLASS = 28);

        IF (GCAS >= 8)
          THEN (* ‚…€ ‘’‚…’‘’‚ …„‹ƒ€ ”‹…‘ *)
            BEGIN
              CAS0 := PREPOS [GCAS].CAS;
              HERE_OK := FINALS [CLASS, CAS0] = FLEX;
              HERE_ANIMABLE := NOT HERE_OK AND (ANIM = NO)
                AND (CAS0 = ACC) AND CBA;
              HERE_FEMINABLE := NOT HERE_OK AND (NUMB = PLUR)
                AND (CAS0 = GEN) AND ((FLEX = DUMMY) OR (FLEX = '‰'));
              HERE_ACCENTABLE := NOT HERE_OK AND (NUMB = SING)
                AND (CAS0 = INS) AND (FLEX [L0-1] = '');
              IF HERE_MASCULABLE
                THEN
                  CASE CAS0 OF
                    NOM, ACC : ;
                    GEN :
                      CASE CLASS OF
                        28 : HERE_MASCULABLE := (FLEX = '…‚');
                        ELSE HERE_MASCULABLE := (FLEX = '‚');
                      END;
                    DAT, INS, PRE :
                      CASE CLASS OF
                        28 : HERE_MASCULABLE := (FLEX = FINALS [CLASS, CAS0]);
                        41, 43 : HERE_MASCULABLE :=
                          (''+FLEX = FINALS [CLASS, CAS0]);
                        45 : HERE_MASCULABLE :=
                          ('‰'+FLEX = FINALS [CLASS, CAS0]);
                        46 : HERE_MASCULABLE :=
                          (''+FLEX = FINALS [CLASS, CAS0]);
                      END;
                  END;
              IF NOT (HERE_OK OR HERE_ANIMABLE OR HERE_FEMINABLE
                OR HERE_ACCENTABLE OR HERE_MASCULABLE)
                THEN WRITELN (FNAME, ' ERROR: PREPOSITION >< FLECTION: ',
                  HEADER, '->', TOKN, BL, PREPOS [GCAS].PRP, ' ~', FLEX);
              OK := OK AND HERE_OK;
              ANIMABLE := ANIMABLE AND (HERE_OK OR HERE_ANIMABLE);
              FEMINABLE := FEMINABLE AND (HERE_OK OR HERE_FEMINABLE);
              ACCENTABLE := ACCENTABLE AND (HERE_OK OR HERE_ACCENTABLE);
              MASCULABLE := MASCULABLE AND HERE_MASCULABLE;
            END
          ELSE
            BEGIN
              OK := OK AND THERE_IS_FLEX (FLEX, CLASS);
              ANIMABLE := ANIMABLE AND THERE_IS_FLEX (FLEX, CLASS)
                AND (FLEX <> FINALS [CLASS, ACC]);
              FEMINABLE := FEMINABLE AND (THERE_IS_FLEX (FLEX, CLASS)
                OR (FLEX = '‰') OR (FLEX = DUMMY))
                AND (FLEX <> FINALS [CLASS, GEN]);
              ACCENTABLE := ACCENTABLE AND (THERE_IS_FLEX (FLEX, CLASS)
                OR (L0 > 1) AND (FLEX [L0-1] = ''))
                AND (FLEX <> FINALS [CLASS, INS]);
              IF HERE_MASCULABLE
                THEN
                  CASE CLASS OF
                    28 : HERE_MASCULABLE := (FLEX = '…‚') OR (FLEX = '')
                      OR (FLEX = '') OR (FLEX = '');
                    ELSE HERE_MASCULABLE :=
                      (FLEX = '‚') OR (FLEX = '€') OR (FLEX = '€') OR
                      (CLASS = 45) AND (FLEX = '‰') OR
                      (CLASS = 46) AND (FLEX = '') OR
                      ((CLASS = 41) OR (CLASS = 43)) AND (FLEX = '');
                  END;
              MASCULABLE := MASCULABLE AND HERE_MASCULABLE;
            END;
      END;

  IF OK
    THEN  (* INITIAL CLASS ACCEPTED *)
      BEGIN
        INC (AMT);
        INC (AMT11);
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN
                BEGIN
                  DONE := FALSE;
                  IF PART_POSSIBLE (HEADER)
                    AND SUITED (FLEX, CLASS, PAR, GCAS)
                    AND (COPY (TOKN, 1, 5) <> '‡…')
                    AND (COPY (TOKN, 1, 4) <> '“„‚')
                    THEN DONE := TRUE;
                  IF NOT DONE
                    THEN ENCODE_ITEM (CLASS, I);
                END;
      END
  ELSE IF ANIMABLE
    THEN  (* "ANIMATED" CLASS ACCEPTED *)
      BEGIN
        INC (AMT12);
        INC (AMT);
        CLASS := ANIMCL;
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN ENCODE_ITEM (CLASS, I);
      END
  ELSE IF FEMINABLE
    THEN  (* "FEMINATED" CLASS ACCEPTED *)
      BEGIN
{ writeln ('FEMINATED ', headline);}
        INC (AMT13);
        INC (AMT);
        IF (CLASS = 86) OR (CLASS = 88)
          THEN CLASS := 90
        ELSE IF (CLASS = 37) OR (CLASS = 33)
          THEN CLASS := 35
        ELSE IF CLASS = 39
          THEN CLASS := 28
        ELSE IF CLASS = 74
          THEN CLASS := 131
          ELSE WRITELN (FNAME, ' ERROR: CANT FEMINIZE CLASS ', CLASS);
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN ENCODE_ITEM (CLASS, I);
      END
  ELSE IF MASCULABLE
    THEN  (* "MASCULATED" CLASS ACCEPTED *)
      BEGIN
{ writeln ('MASCULATED ', headline);}
        INC (AMT14);
        INC (AMT);
        IF CLASS = 28
          THEN CLASS := 39
          ELSE CLASS := 37;
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            BEGIN
              IF COPY (FLEX, LENGTH (FLEX) - 1, 2) = ''
                THEN FLEX := '';
              IF GCAS = 0
                THEN ENCODE_ITEM (CLASS, I);
            END;
      END
  ELSE IF ACCENTABLE
    THEN  (* "ACCENTUATED" CLASS ACCEPTED *)
      BEGIN
{   writeln ('ACCENTUATED ', headline);}
        INC (AMT15);
  INC (AMT);
        IF (CLASS = 3) THEN CLASS := 1
        ELSE IF (CLASS = 4) THEN CLASS := 2
        ELSE IF (CLASS = 7) THEN CLASS := 6
        ELSE IF (CLASS = 9) THEN CLASS := 8
        ELSE IF (CLASS = 89)THEN CLASS := 87
        ELSE IF (CLASS = 96)THEN CLASS := 94
        ELSE IF (CLASS = 97)THEN CLASS := 95
        ELSE WRITELN (FNAME, ' ERROR: CANT ACCENTUATE CLASS ', CLASS,
          ' FOR ', HEADLINE);
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN ENCODE_ITEM (CLASS, I);
      END
  ELSE WRITELN (FNAME, ' ERROR: LEFT UNDETERMINED: ', HEADLINE);
END;


PROCEDURE TEST_ENCODE (VAR CLASS : INTEGER;
        (*===========*)VAR ERROR : BOOLEAN);
  VAR
    I : WORD;
BEGIN
  ERROR := FALSE;
  IF CLASS = 0
    THEN
      BEGIN
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
{‚›€‚’!}  THEN GCAS := 3;
        EXIT;
      END;
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        IF FLEX = '~'
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;
            IF GCAS = 0
{‚›€‚’!}  THEN GCAS := 3;

        IF (GCAS >= 8)
          THEN ERROR := ERROR OR
            (FINALS [CLASS, PREPOS [GCAS].CAS] <> FLEX)
          ELSE ENCODE_ITEM (CLASS, I);
      END;
END;


PROCEDURE ENCODE_INVAL2 (VAR CLASS : INTEGER;
        (*=============*)NUMB : NUMBER;
                         GEND : GENDER;
                         ANIM : ANIMA);
  VAR
    ERROR : BOOLEAN;

BEGIN
  INC (AMT2);
  INC (AMT);
  ERROR := FALSE;

{  writeln ('CORRECTED ', headline);}

  CASE CLASS OF
    0 : TEST_ENCODE (CLASS, ERROR);
    6, 8 :
     IF (NUMB = PLUR)
       THEN
         BEGIN
           CLASS := 12;
           TEST_ENCODE (CLASS, ERROR);
           IF ERROR
             THEN
               BEGIN
                 CLASS := 10;
                 TEST_ENCODE (CLASS, ERROR);
               END;
           IF ERROR
             THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 6/8 FOR ',
               HEADLINE);
         END
     ELSE IF (GEND = MASC)
       THEN
         BEGIN
           CLASS := 6;
           TEST_ENCODE (CLASS, ERROR);
           IF ERROR
             THEN WRITELN (FNAME, ' ERROR: CANT OVERIDE CLASS 6 FOR ',
               HEADLINE);
         END;
    9 :
     IF (NUMB = PLUR)
       THEN
         BEGIN
           CLASS := 12;
           TEST_ENCODE (CLASS, ERROR);
           IF ERROR
             THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 9 FOR ',
               HEADLINE);
         END;
    64 :
      BEGIN
        IF (GEND = MASC)
          THEN
            BEGIN
              CLASS := 68;
              TEST_ENCODE (CLASS, ERROR);
              IF ERROR
                THEN
                  BEGIN
                    CLASS := 69;
                    TEST_ENCODE (CLASS, ERROR);
                  END;
            END;
        IF ERROR
          THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 64 FOR ',
            HEADLINE);
      END;
    68 :
      BEGIN
        IF (GEND = FEM)
          THEN
            BEGIN
              CLASS := 64;
              TEST_ENCODE (CLASS, ERROR);
            END;
        IF (GEND <> FEM) OR ERROR
          THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 68 FOR ',
            HEADLINE);
      END;
    75 :
      BEGIN
        IF (NUMB = PLUR)
          THEN
            BEGIN
              CLASS := 77;
              TEST_ENCODE (CLASS, ERROR);
            END;
        IF ERROR
          THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 75 FOR ',
            HEADLINE);
      END;
    77 :
      BEGIN
        IF (NUMB = SING)
          THEN
            BEGIN
              CLASS := 75;
              TEST_ENCODE (CLASS, ERROR);
            END;
        IF ERROR
          THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 77 FOR ',
            HEADLINE);
      END;
    79 :
      BEGIN
        IF (NUMB = SING)
          THEN
            BEGIN
              CLASS := 74;
              TEST_ENCODE (CLASS, ERROR);
            END;
        IF ERROR
          THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 79 FOR ',
            HEADLINE);
      END;
    118 :
      BEGIN
        IF (NUMB = SING)
          THEN
            BEGIN
              CLASS := 17;
              TEST_ENCODE (CLASS, ERROR);
            END;
        IF ERROR
          THEN WRITELN (FNAME, ' ERROR: CANT CORRECT CLASS 118 FOR ',
            HEADLINE);
      END;
    ELSE WRITELN (FNAME, ' ERROR: UNCORRECTED CLASS ', CLASS, ' FOR ',
      HEADLINE);
  END;
END;

     (* ‚›‚„ ‘„…†ƒ ƒ“› ‚ „‚€ ”€‰‹€ *)
PROCEDURE PARTOUT;
        (*=======*)
VAR
  VCLAS, CL2 : INTEGER;
  I : WORD;
  TMP : STR115;
  VALID, THEREIS0 : BOOLEAN;

BEGIN
  THEREIS0 := FALSE;
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        THEREIS0 := THEREIS0 OR (GCAS = NOGCAS);
        TMP := DUMMY;
        CL2 := 255;
        IF ((TOKN = '‚…„“™‰2') OR (TOKN = '‚…„‰') OR
          (TOKN = '—“‚‘’‚“™‰') OR (TOKN = '—“‚‘’‚‚€‚‰') OR 
          (TOKN = '—“‚‘’‚‚€‚‰') OR (TOKN = '€‡€‚‰') OR
          (TOKN = '‚‚‰')) AND (SOBN = 1)
          THEN
            BEGIN
              IF (POS (TOKN[LENGTH(TOKN)], '123456') > 0)
                THEN TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + '‘…'
                ELSE TOKN := TOKN + BL + '‘…';
              SOBN := 0;
              CL2 := 0;
            END;
{ Output to partial file }
        IF NEG
          THEN WRITE (OUT, NE);
        WRITELN (OUT, TOKN, BL : GAP - LENGTH (TOKN) -
          3 * ORD (NEG), SOBN : 2, ONLYDOT : 2, 
          GCAS : 5, STY : 2, IDI : 2);    
        IF GCAS < 8
          THEN INC(CAS_WO_PREP [GCAS]);

{ Output to vocabulary file }
        WRITE (OUT2, '3', ADJCLS : 4, CL2 : 4, BL);   
        IF NEG
          THEN WRITE (OUT2, NE);
        WRITELN (OUT2, TOKN);

     END;
  IF THEREIS0
    THEN WRITELN (FNAME, ' ERROR: ZERO GENCLASS AT ', HEADLINE);
END;

        (* ‚‹…’‘ ‹ TOKEN …„‹†› ‘‹‚‘—…’€…? *)
  FUNCTION HAS_ADV_PREPOS (TOKEN : STR115) : BOOLEAN;
         (*==============*)
    CONST
      PREPOSIT : ARRAY [1..38] OF STRING [10] =
        ('…‡','','‹……','‚','‚','‚’','‚‘…','‚‘…ƒ','‚‘‹…„‘’‚…',
        'ƒ„…','„‚€','„‹','„','…™…','‡€','€','ƒ„€','‘’€’','“„€',
        '…†„“','€','€‰','—…ƒ','„','’','’“„€','','„',
        '‘‹…','','‘','‘','‘ƒ‹€‘','’€','’','•’','—…ƒ','—’');
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := COPY (TOKEN, 1, LENGTH (PREPOSIT [I]) + 1) = PREPOSIT [I] + BL;
    UNTIL FOUND OR (I = 38);
    HAS_ADV_PREPOS := FOUND;
  END;

      (* „‚€… ƒ“›  ‚›‚„ …… ‡€ƒ‹‚€ *)
PROCEDURE OUT_HEADLINE;
        (*============*)

BEGIN
  (* „‚€… ‚‘…‰ ƒ“›, …‘‹ €„ - ‘ …–…‰ *)
  INC(GRNUM);                                    (* DM *)
  IF VALID
    THEN ENCODE_VALID (CLASS)
    ELSE
      IF NG_CHANGE
        THEN ENCODE_INVAL2 (CLASS, NUMB0, GEND0, ANIM0)
        ELSE ENCODE_INVAL1 (CLASS, NUMB0, GEND0, ANIM0);
  IF (ANIM0 = YES) AND CAN_BE_ANIMATED (SUBCL, ANIMSUBCL)
    THEN SUBCL := ANIMSUBCL;

      (* ... ……„ ƒ“‰ *)
  WRITELN (OUT, '+', GRNUM:6, BL, HEADLINE);     (* DM *)

  IF TOTAL <> AMT
    THEN
      BEGIN
        {WRITELN (FNAME, ' ERROR: SOMETHING LEFT UNCLASSIFIED IN GROUP AT ',
          HEADLINE);}
        INC (AMT);
      END;
END;

PROCEDURE FIND_SAME_LINE (VAR CLASS, SUBCL : INTEGER;
        (*==============*)VAR NUMB0 : NUMBER;
                          VAR GEND0 : GENDER;
                          VAR DOUBLE_FL, FL_REVERS : BOOLEAN);
  VAR
    I, J, P, L : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  P := POS ('1<', LINE1) + POS ('2<', LINE1) + POS ('3<', LINE1)
    + POS ('4<', LINE1) + POS ('5<', LINE1) + POS ('6<', LINE1);
  IF P = 0
    THEN HEADER1 := LINE1
    ELSE HEADER1 := COPY (LINE1, 1, P-1);

  WHILE (HEADER1 <= HEADER) AND (LINE1 <> LINE) AND NOT EOF (INP1) DO
    BEGIN
      FOR J := 0 TO 4 DO
        READ (INP1, PARS [J]);
      READ (INP1, CH);
      READLN (INP1, LINE1);
      P := POS ('1<', LINE1) + POS ('2<', LINE1) + POS ('3<', LINE1)
        + POS ('4<', LINE1) + POS ('5<', LINE1) + POS ('6<', LINE1);
      IF P = 0
        THEN HEADER1 := LINE1
        ELSE HEADER1 := COPY (LINE1, 1, P-1);
    END;
{writeln (line1, '<?>', line);}
  
  FOUND := (LINE1 = LINE);

  IF FOUND
    THEN (* ‘‚…… €€…’‚ ‹—…‚ƒ ‘“™…‘’‚’…‹ƒ *)
      BEGIN
        IF (0 < PARS [2]) AND (PARS [2] <> 255)
          {OR ((PARS [1] = 0) AND (PARS [2] > 0))}
          THEN
            BEGIN
              CLASS := PARS [2];
              SUBCL := PARS [1];
            END
          ELSE
            BEGIN
              CLASS := PARS [1];
              SUBCL := PARS [2];
            END;
        NUMB0 := NUMBER (PARS [3]);
        GEND0 := GENDER (PARS [4]);
        DOUBLE_FL := (SUBCL <> 255);
        FL_REVERS := DOUBLE_FL AND (SUBCL > 0);
      END
    ELSE
      BEGIN
        WRITELN (FNAME, ' ERROR: NO MATCH TO ', LINE);
        FLUSH (OUT);
        FLUSH (OUT2);

        CLASS := 0;
        SUBCL := 0;
        NUMB0 := NUMBER (0);
        GEND0 := GENDER (0);
        DOUBLE_FL := TRUE;
        FL_REVERS := FALSE;
 
        {HALT (2);}
      END;
END;

BEGIN      (* MAIN *)

     (* –€‹‡€– €‘‘‚‚ *)
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

     (* –€‹‡€– ………›• *)
  AMT0 := 0;
  AMT11 := 0;
  AMT12 := 0;
  AMT13 := 0;
  AMT14 := 0;
  AMT15 := 0;
  AMT2 := 0;
  AMT := 0;
  TOTAL := 0;
  GRNUM:=1;          (* DM *)
  FOR J := 8 TO MAXPREP29 DO
    PREPO [J] := 0;
  FOR I := 1 TO 5 DO
    USECOUNT [I] := 0;
  FOR I := 0 TO 7 DO
    CAS_WO_PREP [I] := 0;

  ASSIGN (INP1, 'OPFUNC_0.LST');
  RESET (INP1);
  FOR J := 0 TO 4 DO
    READ (INP1, PARS [J]);
  READLN (INP1, CH, LINE1);

  ASSIGN (OUT2, 'OPPART.COD');
  REWRITE (OUT2);

  ASSIGN (OUT3, 'PREPOP.LST');
  REWRITE (OUT3);

  FOR J := 0 TO 77 DO
    BEGIN
      FNAME := 'OPPART' + CHR (ORD ('0') + J DIV 10) +
        CHR (ORD ('0') + J MOD 10) + '.TXT';
      ASSIGN (INP, FNAME);
{writeln (FNAME);}
      RESET (INP);

      FNAMEOUT := COPY (FNAME, 1, LENGTH (FNAME) - 3) + 'COD';
      ASSIGN (OUT, FNAMEOUT);
      REWRITE (OUT);

     (* –€‹‡€– ………›• *)
  PARTAMT := 0;
  HEADER := DUMMY;
  HEADER1 := DUMMY;
  SUBHEAD := DUMMY;
  CLASS := 0;
  SUBCL := 0;
  VALID := FALSE;
  SUBVAL := FALSE;
  NUMB0 := UNKN;
  SUBNUMB := UNKN;
  GEND0 := NONE;
  SUBGEND := NONE;
  ANIM0 := IND;
  SUBANIM := IND;
  INIT_ARRAY;
  NG_CHANGE := FALSE;
  DOUBLE_FL := FALSE;
  FL_REVERS := FALSE;
  THERE_IS_I := FALSE;
  THERE_IS_H := FALSE;
  LINENUM := 0;

    (* ‘‚‰ –‹ *)
  REPEAT
    READLN (INP, LINE);

    INC (LINENUM);
{writeln ('read: ', LINE);}

    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN (FNAME, ' ERROR: UNNECESSARY FINAL BLANK IN LINE ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;

    FIRST := LINE [1];
    IF (FIRST <> BL) AND (FIRST <> '/') AND (FIRST <> '\')
      THEN   (* ‡€ƒ‹‚ ‘’€’ *)
        BEGIN
          IF PARTAMT > 0
            THEN
              BEGIN
                OUT_HEADLINE;
                PARTOUT;
                PARTAMT := 0;
                INIT_ARRAY;
                NG_CHANGE := FALSE;
                DOUBLE_FL := FALSE;
                FL_REVERS := FALSE;
                THERE_IS_I := FALSE;
                THERE_IS_H := FALSE;
                HEADER := DUMMY;
                SUBHEAD := DUMMY;
              END;
          HEADLINE := LINE;
          P := POS ('1', LINE) + POS ('2', LINE) + POS ('3', LINE)
            + POS ('4', LINE) + POS ('5', LINE) + POS ('6', LINE);
{          P := POS (LINE [LENGTH(LINE)], '123456');}
          IF P = 0
            THEN HEADER := LINE
            ELSE HEADER := COPY (LINE, 1, P-1);
          FIND_SAME_LINE (CLASS, SUBCL, NUMB0, GEND0, DOUBLE_FL, FL_REVERS);
        END
      ELSE           (* ‹‹€– *)
        BEGIN

        (* ‚›‚„ ‚ ”€‰‹ „‹ ‘‹‚€ *)
          L := LENGTH (LINE);
          LINE2 := COPY (LINE, 3, L-2);
          IF POS (NE, LINE2) = 1
            THEN
              BEGIN
                P := POS (BL, COPY (LINE2, 4, L-5));
                TOK := COPY (LINE2, 1, P+2);
                TOK3 := TOK;
              END
            ELSE
              BEGIN
                P := POS (BL, LINE2);
                TOK := COPY (LINE2, 1, P-1);
                TOK3 := TOK;
                L := LENGTH (TOK);
                IF POS (TOK [L], '123456') > 0
                  THEN TOK := COPY (TOK, 1, L-1);
              END;

          FIN := COPY (TOK, LENGTH(TOK)-1, 2);
          IF (FIN = '‘')
            THEN TOK1 := COPY (TOK, 1, LENGTH(TOK)-2)
            ELSE TOK1 := TOK;
          FIN1 := COPY (TOK1, LENGTH(TOK1)-1, 2);
          IF (FIN1 <> '›‰') AND (FIN1 <> '‰') AND (FIN1 <> '‰') AND NOT HAS0CL (TOK1)
            THEN
              BEGIN
                WRITELN (FNAME, ' ERROR: Wrong final at ', TOK,
                  ' LINE ', LINENUM);
                HALT;
              END;

          INITADJCL (TOK, CL, GND, NMB);
          WRITELN (OUT2, '3', CL:4, ' 255 ', TOK3);

        (* ‹…… ƒ“› *)
          INC (PARTAMT);
          USACH := LINE [2];
          STYL := POS (USACH, 'sqpm*');
          IF (USACH <> BL) AND (STYL = 0)
            THEN
              BEGIN
                WRITELN (FNAME, ' ERROR: WRONG USAGE LABEL IN LINE ',
                  LINENUM);
                HALT;
              END
            ELSE IF STYL > 0
              THEN INC (USECOUNT [STYL]);

          IDIOM := POS (FIRST, '/\');

          CODE_LINE (PARTAMT, LINE);
          IF EOF (INP)
            THEN
              BEGIN
                OUT_HEADLINE;
                PARTOUT;
              END;
        END;
  UNTIL EOF (INP);
  CLOSE (INP);

  FLUSH (OUT);
  CLOSE (OUT);
    END;

  FLUSH (OUT2);

  WRITELN (USECOUNT [1] : 4, ' SPECIALS');
  WRITELN (USECOUNT [2] : 4, ' COLLOQUIALS');
  WRITELN (USECOUNT [3] : 4, ' INDECENTS');
  WRITELN (USECOUNT [5] : 4, ' FORBIDDENS');
  WRITELN ('FILES OPPART.COD AND OPPARTxx.COD OUTPUT');

  PREPOTOTAL := 0;
  FOR J := 8 TO MAXPREP29 DO
    BEGIN
      WRITELN (OUT3, PREPO [J] : 5, BL, PREPOS [J].PRP);
      INC (PREPOTOTAL, PREPO [J]);
    END;
  {WRITELN (OUT3, PREPOTOTAL, ' PREPS IN COLLOCATIONS');
  WOPREPTOTAL := 0;
  FOR I := 0 TO 7 DO
    BEGIN
      CASE I OF
        0: WRITELN (OUT3, 'NOM: ', CAS_WO_PREP[0]:6);
        1: WRITELN (OUT3, 'GEN: ', CAS_WO_PREP[1]:6);
        2: WRITELN (OUT3, 'DAT: ', CAS_WO_PREP[2]:6);
        3: WRITELN (OUT3, 'ACC: ', CAS_WO_PREP[3]:6);
        4: WRITELN (OUT3, 'INS: ', CAS_WO_PREP[4]:6);
        5: WRITELN (OUT3, 'PRE: ', CAS_WO_PREP[5]:6);
        6: WRITELN (OUT3, 'PAR: ', CAS_WO_PREP[6]:6);
        7: WRITELN (OUT3, 'LOC: ', CAS_WO_PREP[7]:6);
      END;
      INC(WOPREPTOTAL, CAS_WO_PREP[I]);
    END;
  WRITELN (OUT3, WOPREPTOTAL, ' COLLOCATIONS W/O PREPS');}
  FLUSH (OUT3);

  WRITELN (PREPOTOTAL, ' PREPOS IN PREPOP.LST OUTPUT');
END.
