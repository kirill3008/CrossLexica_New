PROGRAM COPUCONT;

USES DOS, INITVER4;

  VAR XL_DAS, BUF : STRING [255];

  TYPE
    STR115 = STRING [115];
    STR5 = STRING [5];
    STR4 = STRING [4];
    STR15 = STRING [15];
    NUMBER = (UNKN, SING, PLUR);
    GENDER = (NONE, MASC, FEM, NEUT, COMN);
    RESTYPE = (LT, EQ, GT);

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    BL = ' ';
    DUMMY = '';
    SUFS : ARRAY [1..53] OF STRING [4] =
      ('õâ', 'àâ', 'éâ', 'àâëü', 'Äü', 'üü', 'Äüëü', 'éÖ', 'ÖÖ',
      'ÖÖëü', 'õÖ', 'àÖ', 'àÖëü', 'úü', 'úÖ', 'úà', 'éü', 'éà',
      'Äò', 'ÄòÄ', 'ÄòÖ', 'Äòà', 'àç', 'àçÄ', 'àçé', 'àçõ',
      'Öëú', 'ëü', 'ëÖ', 'éí', 'Ç', 'ÇÄ', 'Çé', 'Çõ',
      'õçÄ', 'õçé', 'çà', 'Äå', 'ÄåÄ', 'Äåé', 'Äåà', 'çÄ', 'çé', 
      'çÖ', 'Öçú', 'çü', 'Ö', 'Öâ', 'à', 'õç', 'Ä', 'é', 'õçõ');
    AFFR = 'Üóòô';
    LABIA = 'Éäï';
    SONOR = 'ÄÖàéìüõ';
    SOM='àÖÅÇÑáãåçèêëíñâ';

  VAR
    AMTA, AMTV, I, LINENUM, P, PT, L, L1 : INTEGER;
    CLASS, CL2, DOTS : INTEGER;
    INP , OUT : TEXT;
    LINE : STRING [45];
    FNAME : STRING [12];
    VERB, TAIL, TOKEN : STR115;
    VAL, NEG : BOOLEAN;
    NMB : NUMBER;
    GND : GENDER;
    CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ãûÅéâ *)
    CLA0018 : ARRAY [1..XOYMAX] OF STR15;  (* ëìïéâ *)
    CLA0107 : ARRAY [1..IYMAX] OF STR15; (* îÄáÄçàâ *)


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

FUNCTION IS_HYPHBLOCK (TOKEN : STR115) : BOOLEAN;
       (*============*)
BEGIN
  IS_HYPHBLOCK :=
(TOKEN = 'äÄäéâ-í') OR (TOKEN = 'äÄäéâ-ãàÅ') OR
(TOKEN = 'äÄäéâ-çàÅìÑú') OR
(TOKEN = 'äÄäÄü-í') OR (TOKEN = 'äÄäÄü-ãàÅ') OR
(TOKEN = 'äÄäéâ-çàÅìÑú') OR
(TOKEN = 'äÄäàÖ-í') OR (TOKEN = 'äÄäàÖ-ãàÅ') OR
(TOKEN = 'äÄäéâ-çàÅìÑú');
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
            IF COPY (STEM, P - 2, 2) = 'àâ'
              THEN
            BEGIN GEND := MASC;NUMB := SING;END
              ELSE IF COPY (STEM, P - 2, 2) = 'Äü'
              THEN
            BEGIN GEND := FEM;NUMB := SING;END
              ELSE IF COPY (STEM, P - 2, 2) = 'éÖ'
              THEN
            BEGIN GEND := NEUT;NUMB := SING;END
              ELSE
            BEGIN GEND := COMN;NUMB := PLUR;END;
              EXIT;
            END
        ELSE IF (COPY (STEM, 1, P) = 'èé-')
          OR (COPY (STEM, P + 1, LENGTH (STEM) - P) = 'í')
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
    1 : (* -õâ *)
      CASE LAST OF
        'ç' :
          IF (COPY (STEM, L-2, 3) = 'ãúç') OR 
            (COPY (STEM, L-1, 2) = 'âç') 
            THEN CLASS := 2
          ELSE IF STEM [L-1] = 'ç'
            THEN CLASS := 1
          ELSE IF (POS (STEM [L-1], SONOR) > 0)
            THEN CLASS := 9
            ELSE CLASS := 2;
        'í','Ñ','Ç','å','ã','ê','è','Å','ë','ñ','á' : CLASS := 9;
        ELSE CLASS := 0;
      END;
    2 : (* -àâ *)
      BEGIN
        LOW := 1;
        HIGH := IYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*îÄáÄçàâ>*) COMPARE_TOK (STEM, CLA0107 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 7
          ELSE
            IF LAST = 'ç'
              THEN
                IF (POS (STEM [L-1], 'ÇÑÜàâåçêíïòú') > 0)
                  THEN CLASS := 8
                  ELSE CLASS := 0
            ELSE IF (STEM = 'äÄê')
               THEN CLASS := 8
            ELSE IF POS (LAST, LABIA) > 0
              THEN CLASS := 10
            ELSE IF (POS (LAST, AFFR) > 0)
              THEN CLASS := 3
              ELSE CLASS := 0;
      END;
    3 : (* -éâ *)
      IF (STEM = 'ëÇ') OR (STEM = 'íÇ') OR (STEM = 'å')
        THEN CLASS := 11
      ELSE IF (STEM = 'åéêäéÇä') OR (STEM = 'çàíéóä')
        OR (STEM = 'èìÉéÇä') OR (LAST = 'ñ') OR (STEM = 'ëã')
        OR (STEM = 'ëí') OR (STEM = 'áÄëí') OR (STEM = 'ëíê')
        OR (STEM = 'ñÖç')
        THEN CLASS := 0
      ELSE IF POS (LAST, LABIA + AFFR) > 0
        THEN CLASS := 5
        ELSE CLASS := 4;
    4, 7, 10, 13 : (* -àâëü/-Äüëü/-ÖÖëü/-àÖëü *)
      CLASS := 6;
    5 : (* -Äü *)
      BEGIN
        LOW := 1;
        HIGH := OYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*ãûÅÄü>*)  COMPARE_TOK (STEM, CLASS17 [MID], RES);
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
              'É', 'ä', 'ï', 'ò', 'ô', 'ó', 'Ü' :
                BEGIN
                  LOW := 1;
                  HIGH := XOYMAX;
                  FOUND := FALSE;
                  WHILE (HIGH >= LOW) AND NOT FOUND DO
                    BEGIN
                      MID := (HIGH + LOW) DIV 2;
(*ëìïÄü/ÅéãúòÄü*)     COMPARE_TOK (STEM, CLA0018 [MID], RES);
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
              'ç' :
                IF STEM [L-1] = 'ç'
                  THEN CLASS := 1
                  ELSE IF (POS (STEM [L-1], SONOR) > 0)
                    THEN CLASS := 9
                    ELSE CLASS := 2;
              'í','Ñ','Ç','å','ã','ê','è','Å','ë','ñ','á' : CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    6 : (* -üü *)
      IF (LAST = 'ç') OR (LAST = 'Ö') OR (STEM = 'äÄê')
        THEN CLASS := 8
        ELSE CLASS := 0;
    8 : (* -éÖ *)
      IF (STEM = 'ëÇ') OR (STEM = 'íÇ') OR (STEM = 'å')
        THEN CLASS := 11
        ELSE
          CASE LAST OF
            'É', 'ä', 'ï', 'ò', 'ô', 'ó', 'Ü' :
              BEGIN
                LOW := 1;
                HIGH := XOYMAX;
                FOUND := FALSE;
                WHILE (HIGH >= LOW) AND NOT FOUND DO
                  BEGIN
                    MID := (HIGH + LOW) DIV 2;
(*ëìïéÖ/ÅéãúòéÖ>*)  COMPARE_TOK (STEM, CLA0018 [MID], RES);
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
            'ç','í','Ñ','Ç','å','ã','ê','è','Å','ë','ñ','á':
              BEGIN
                LOW := 1;
                HIGH := OYMAX;
                FOUND := FALSE;
                WHILE (HIGH >= LOW) AND NOT FOUND DO
                  BEGIN
                    MID := (HIGH + LOW) DIV 2;
 (*ãûÅéÖ>*)         COMPARE_TOK (STEM, CLASS17 [MID], RES);
                    CASE RES OF
                      LT : HIGH := MID - 1;
                      EQ : FOUND := TRUE;
                      GT : LOW := MID + 1;
                    END;
                  END;
                IF FOUND
                  THEN CLASS := 4
                  ELSE
                    IF LAST = 'ç'
                      THEN
                        IF STEM [L-1] = 'ç'
                          THEN CLASS := 1
                      ELSE IF (POS (STEM [L-1], SONOR) > 0)
                        THEN CLASS := 9
                      ELSE CLASS := 2
                      ELSE
                        CLASS := 9;
              END;
            ELSE CLASS := 0;
          END;
    9 : (* -ÖÖ *)
      IF LAST = 'ç'
        THEN
          IF (POS (STEM [L-1], 'ÇÑÜàâåçêíïòú') > 0)
            THEN CLASS := 8
            ELSE CLASS := 0
     ELSE IF (LAST = 'Ö') OR (STEM = 'äÄê')
        THEN CLASS := 8
        ELSE
          IF POS (LAST, AFFR) > 0
            THEN CLASS := 3
            ELSE CLASS := 0;
    11 : (* -õÖ *)
      BEGIN
        LOW := 1;
        HIGH := OYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*ãûÅõÖ>*)  COMPARE_TOK (STEM, CLASS17 [MID], RES);
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
              'ç' :
                IF STEM [L-1] = 'ç'
                  THEN CLASS := 1
                ELSE IF (POS (STEM [L-1], SONOR) > 0)
                  THEN CLASS := 9
                  ELSE CLASS := 2;
              'í','Ñ','Ç','å','ã','ê','è','Å','ë','ñ','á' :
                CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    12 : (* -àÖ *)
      BEGIN
        LOW := 1;
        HIGH := XOYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*ëìïàÖ/ÅéãúòàÖ*)COMPARE_TOK (STEM, CLA0018 [MID], RES);
            CASE RES OF
              LT : HIGH := MID - 1;
              EQ : FOUND := TRUE;
              GT : LOW := MID + 1;
            END;
          END;
        IF FOUND
          THEN CLASS := 5
          ELSE
            IF LAST = 'ç'
              THEN
                IF (POS (STEM [L-1], 'ÇÑÜàâåçêíïòú') > 0)
                  THEN CLASS := 8
                  ELSE CLASS := 0
            ELSE IF (STEM = 'äÄê') OR (LAST = 'Ö')
              THEN CLASS := 8
              ELSE
                IF (POS (LAST, LABIA) > 0)
                  THEN CLASS := 10
                ELSE
                  IF (POS (LAST, AFFR) > 0) AND (STEM <> 'ÇÖãàó')
                    THEN CLASS := 3
                    ELSE CLASS := 0;
      END;
    14, 15, 16 : (* -úü/-úÖ/-úà *)
      IF (STEM = 'ó') OR (STEM = 'çàó') OR (STEM = 'äéÖ-ó')
        THEN CLASS := 20
        ELSE
      BEGIN
        LOW := 1;
        HIGH := IYMAX;
        FOUND := FALSE;
        WHILE (HIGH >= LOW) AND NOT FOUND DO
          BEGIN
            MID := (HIGH + LOW) DIV 2;
(*îÄáÄçúü>*)COMPARE_TOK (STEM, CLA0107 [MID], RES);
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
    17, 18 : (* -éü/-éà *)
      IF (STEM = 'ëÇ') OR (STEM = 'íÇ') OR (STEM = 'å')
        THEN CLASS := 11
        ELSE CLASS := 0;
    19..22 : (* -Äò/-ÄòÄ/-ÄòÖ/-Äòà *)
      IF (STEM = 'ç') OR (STEM = 'Ç')
        THEN CLASS := 12
        ELSE CLASS := 0;
     23..26 : (* -àç/-àçÄ/-àçé/-àçõ *)
       IF (STEM = 'éÑ')
         THEN CLASS := 16
         ELSE
       IF (STEM = 'Äçûí') OR (STEM = 'ÄêàÄÑç') OR (STEM = 'ÅÄÅìòä')
         OR (STEM = 'ÅêÄíç') OR (STEM = 'ÜÖç') OR (STEM = 'àìÑ') 
         OR (STEM = 'äìäìòä') OR (STEM = 'ãÄëíéóä') OR (STEM = 'èÄè')
         OR (STEM = 'åÄå') OR (STEM = 'åÄåÖçúä') OR (STEM = 'åÄíìòä')
         OR (STEM = 'åÄêíõòä') OR (STEM = 'åÄíÖê') OR (STEM = 'åìÜç')
         OR (STEM = 'ëÖëíê') OR (STEM = 'ëìä') OR (STEM = 'ëìóä') 
         OR (STEM = 'ëíÄêìï') OR (STEM = 'ôìä') OR (STEM = 'ÑüÑ') 
         OR (STEM = 'íÖí') OR (STEM = 'íÖíä') OR (STEM = 'íêàòä')
         OR (STEM = 'òÄêÄòä') OR (STEM = '^òÖåüä') OR (STEM = 'îàãúä')
         OR (STEM = 'ÑÖÑìòä') OR (STEM = 'çÖÇÖëíä')
           THEN CLASS := 17
           ELSE CLASS := 0;
    27..29 : (* -Öëú/-ëü/-ëÖ *)
      IF (STEM = 'Ç')
        THEN CLASS := 15
        ELSE CLASS := 0;
    30,42,43 :  (* -éí/-Ä/-é *)
      IF (STEM = 'í')
        THEN CLASS := 13
      ELSE IF (STEM = 'ùí')
        THEN CLASS := 14
        ELSE CLASS := 0;
    31..34 : (* -Ç/-ÇÄ/-Çé/-Çõ *)
      IF (STEM = '^ïêàëíé') OR (STEM = 'ÄÇÉàÖ')
      OR (STEM = 'ÄÑé') OR (STEM = 'ÄççàÅÄãé')
      OR (STEM = 'ÄÑÄåé') OR (STEM = 'Äçíéçé')
      OR (STEM = 'ÄêïàåÖÑé') OR (STEM = 'ÄïàããÖëé')
      OR (STEM = 'ÅÄâÖëé') OR (STEM = 'ÅàäîéêÑé') 
      OR (STEM = 'ÅêÄíé') OR (STEM = 'ÅÖêíéãÖíé')
      OR (STEM = 'ÅìãÖ') OR (STEM = '^ÅÄêÖçñÖ')
      OR (STEM = '^ÇéãúíÖêé') OR (STEM = '^ÇÄãíÄëÄêé')
      OR (STEM = '^ÇÄãúèìêÉàÖ') OR (STEM = 'Çéãúíé')
      OR (STEM = 'Çéêéçé')
      OR (STEM = 'ÉÄâåéêé') OR (STEM = 'ÉÄãÖçé')
      OR (STEM = '^ÉÄççàÅÄãé') OR (STEM = 'ÉÄìëëé')
      OR (STEM = 'ÉÖêÄäãé') OR (STEM = 'ÉÖêéëíêÄíé')
      OR (STEM = 'ÉÖêäìãÖëé') OR (STEM = '^ÉÖêäìãÖëé')
      OR (STEM = 'ÉéêÑàÖ') OR (STEM = 'ÉãÄìÅÖêé')
      OR (STEM = 'ÑÖäÄêíé') OR (STEM = '^ÑÄçíé') OR (STEM = 'ÑÄåéäãé') 
      OR (STEM = 'ÑÖÑé')  OR (STEM = 'ÑêÄäéçé')
      OR (STEM = 'ÖÇäãàÑé') OR (STEM = 'äÖëÄêÖ')
      OR (STEM = 'äÄàçé') OR (STEM = 'äéôÖÖ')
      OR (STEM = '^äêÖâñÖêé') OR (STEM = 'äêéäéÑàãé')
      OR (STEM = 'ãÄèãÄëé') OR (STEM = 'ãìääìãé')
      OR (STEM = 'çÖÖÇäãàÑé') OR (STEM = 'çÖèíìçé')
      OR (STEM = 'éíñé') OR (STEM = 'çéÖ')
      OR (STEM = 'èàîÄÉéêé') OR (STEM = 'èêéäêìëíé')
      OR (STEM = 'èàêêé') OR (STEM = 'êàåÄçé')
      OR (STEM = 'ëÄåëéçé') OR (STEM = 'ëàáàîé')
      OR (STEM = 'ëîàçäëé') OR (STEM = 'ëéãéåéçé')
      OR (STEM = 'ëõçé') OR (STEM = 'íÄçíÄãé')
      OR (STEM = 'íéêàóÖããàÖ') OR (STEM = 'îÄããéèàÖ')
      OR (STEM = 'ïÄåé') OR (STEM = 'óÖêíé') 
      OR (STEM = 'ùáéèé')
        THEN CLASS := 18
        ELSE CLASS := 0;
{!} 35,36 : (* -çÄ/-çé *)
      IF (STEM = 'éÑ')
        THEN CLASS := 16
        ELSE CLASS := 0;
    37 : (* -çà *)
      IF (STEM = 'éÑ')
        THEN CLASS := 16
      ELSE IF (STEM = 'ÉéëèéÑ')
        THEN CLASS := 21
        ELSE CLASS := 0;
    38..41 : (* -Äå/-ÄåÄ/-Äåé/-Äåà *)
      IF (STEM = 'ë')
        THEN CLASS := 19
        ELSE CLASS := 0;
    44 : (* -Ö *)
      IF (STEM = 'í')
        THEN CLASS := 13
        ELSE CLASS := 0;
    45,46,47 : (* -Öçú/-çü/-çÖ *)
      IF (STEM = 'ÉéëèéÑ')
        THEN CLASS := 21
        ELSE CLASS := 0;
    48 : (* -Öâ *)
      IF (STEM = 'ó') OR (STEM = 'çàó') OR (STEM = 'äéÖ-ó')
        THEN CLASS := 20
        ELSE CLASS := 0;
    49 : (* -à *)
      IF (STEM = 'ùí')
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

BEGIN      (* MAIN *)
  AMTA := 0;
  AMTV := 0;
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

  ASSIGN (OUT, 'COPULAS.COD');
  REWRITE (OUT);

  FNAME := 'COPULAS.TXT';
  WRITELN ('  FILE ', FNAME, ' BEING PROCESSED');
  ASSIGN (INP, FNAME);
  RESET (INP);

  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);
    IF (LINE [1] <> BL)
      THEN   (* áÄÉéãéÇéä ëíÄíúà *)
        BEGIN
          INC (AMTA);
          P := POS ('1', LINE) + POS ('2', LINE) + POS ('3', LINE) +
            POS ('4', LINE) + POS ('5', LINE) + POS ('6', LINE);
          IF P > 0
            THEN TOKEN := COPY (LINE, 1, P - 1)
            ELSE TOKEN := LINE;
          INITADJCL (TOKEN, CLASS, GND, NMB);
          WRITELN (OUT, '+ 3', CLASS : 4, '255' : 4, '0' : 2, BL, LINE);
        END
      ELSE           (* äéåèéçÖçí *)
        BEGIN
          INC (AMTV);
          DOTS := 0;
    {     USACH := LINE [2];
          STYL := POS (USACH, 'sqpm*');
          IF (USACH <> BL) AND (STYL = 0)
            THEN
              BEGIN
                WRITELN ('WRONG USAGE LABEL IN LINE ', LINE);
                HALT;
              END
            ELSE IF STYL > 0
              THEN INC (USECOUNT [STYL]); }

          DOTS := 0;
          NEG := FALSE;
          LINE := COPY (LINE, 3, LENGTH (LINE) - 2);
          PT := POS ('~', LINE);
          LINE := COPY (LINE, 1, PT-2);
          L := LENGTH (LINE);
          
          IF POS ('çÖ ', LINE) = 1
            THEN
              BEGIN
                NEG := TRUE;
                LINE := COPY (LINE, 4, L-3);
                L := L - 3;
              END;

          P := POS (BL, LINE);
          IF P > 0
            THEN
              BEGIN
                VERB := COPY (LINE, 1, P-1);
                TAIL := COPY (LINE, P+1, L-P);
                IF TAIL = '...'
                  THEN
                    BEGIN 
                      DOTS := 1;
                      LINE := COPY (LINE, 1, P-1);
                    END   
                  ELSE
                    BEGIN
                      WRITELN ('WRONG DOTS AT ', LINENUM);
                      HALT;
                    END;
              END
            ELSE VERB := LINE;

          L1 := LENGTH (VERB);
          IF POS (VERB[L1],'123456') > 0
            THEN 
              BEGIN
                VERB := COPY (VERB,1,L1-1);
                DEC (L1);
              END;

          INITVERBCL (VERB, CLASS, VAL);
          IF NOT VAL
            THEN WRITELN ('WRONG VERB ', TOKEN, ' AT LINE ', LINENUM);
          
          IF NEG
            THEN LINE := 'çÖ ' + LINE;

          WRITELN (OUT, '- 2', CLASS : 4, '0' : 4, DOTS : 2, BL, LINE);
        END;
  UNTIL EOF (INP);
  CLOSE (INP);
  FLUSH (OUT);

  WRITELN ('FILE "COPULAS.COD" IS OUTPUT');
  WRITELN;
  WRITELN (AMTA : 5, ' ADJECTIVES');
  WRITELN (AMTV : 5, ' VERB COLLOCS');
  WRITELN (AMTV / AMTA : 5 : 2, ' COLLOCS/ADJ');
END.
