PROGRAM ANTOCONT;

USES DOS, CLASTABL, INITVER4;

  VAR XL_DAS, BUF : STRING [255];

  TYPE
    STATUS = (ZERO, SUB, VERB, ADJ, ADV);
    STR2 = STRING [2];
    STR4 = STRING [4];
    STR15 = STRING [15];
    STR50 = STRING [50];

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    MAXBN = 42000;

    TAB = #009;
    SUFS : ARRAY [1..53] OF STRING [4] =
      ('õâ', 'àâ', 'éâ', 'àâëü', 'Äü', 'üü', 'Äüëü', 'éÖ', 'ÖÖ',
      'ÖÖëü', 'õÖ', 'àÖ', 'àÖëü', 'úü', 'úÖ', 'úà', 'éü', 'éà',
      'Äò', 'ÄòÄ', 'ÄòÖ', 'Äòà', 'àç', 'àçÄ', 'àçé', 'àçõ',
      'Öëú', 'ëü', 'ëÖ', 'éí', 'Ç', 'ÇÄ', 'Çé', 'Çõ',
      'õçÄ', 'õçé', 'çà', 'Äå', 'ÄåÄ', 'Äåé', 'Äåà', 'çÄ', 'çé', 
      'çÖ', 'Öçú', 'çü', 'Ö', 'Öâ', 'à', 'õç', 'Ä', 'é', 'õçõ');

    PREPOSIT : ARRAY [1..27] OF STRING [10] =
      ('ÅÖá','ÅéãÖÖ','Ç','Ççìíêà','Ççìíêú','Çé','ÇëãÖÑëíÇàÖ','Ñãü','Ñé',
      'áÄ','àáçìíêà','ä','åÖÜÑì','çÄ','éí','èé','èéÑ','èéáÄÑà','èéëãÖ','èêà',
      'èêé','èêéíàÇ','ë','ëáÄÑà','ëçÄêìÜà','ëéÉãÄëçé','ëèÖêÖÑà');

  VAR
    TOTAL, I, J, K, LINENUM, ERC : INTEGER;

    INP , OUT : TEXT;
    LINE, PREVLINE : STRING [62];
    COUNT : ARRAY [STATUS] OF INTEGER;
    LINE1, {LINE2,} FNAME : STR115;
    BN_REACHED : LONGINT;
    
    CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ãûÅéâ *)
    CLA0018 : ARRAY [1..XOYMAX] OF STR15;  (* ëìïéâ *)
    CLA0107 : ARRAY [1..IYMAX] OF STR15; (* îÄáÄçàâ *)

    BASE_NOUNS : ARRAY [1..MAXBN] OF STR50;

    ST : STATUS;
    LAST : CHAR;
    PART_ARR : ARRAY [0..1] OF
      RECORD
        STS : STATUS;
        LIN : STRING [39];
        TKN : STR115;
        CLS : INTEGER;
        CLS2: INTEGER;
        NUMB : NUMBER;
        GEND : GENDER;
        ANIM : ANIMA;
      END;


PROCEDURE FILL_BASE_NOUNS;
        (*===============*)
VAR
  I, P : LONGINT;
  LINE : STRING [80];
  INP1 : TEXT;
BEGIN
  ASSIGN (INP1, 'BASICS.LST');
  RESET (INP1);
  I := 0;
  REPEAT
    READLN (INP1, LINE);
    INC(I);
    P := POS ('<', LINE);
    IF P > 0
      THEN LINE := COPY (LINE, 1, P-1);
    BASE_NOUNS [I] := LINE;
  UNTIL EOF(INP1);
  BN_REACHED := I;
  CLOSE (INP1);
END;

FUNCTION IN_BASE_NOUNS (TOKEN : STR50) : INTEGER;
       (*============*)
VAR
  LOW, HIGH, MID : LONGINT;
  FOUND : BOOLEAN;
  RES : RESTYPE;

BEGIN
  LOW := 1;
  HIGH := BN_REACHED;
  FOUND := FALSE;
  IN_BASE_NOUNS := 0;
  WHILE (HIGH >= LOW) AND NOT FOUND DO
    BEGIN
      MID := (HIGH + LOW) DIV 2;
      COMPARE_TOK (TOKEN, 
        COPY (BASE_NOUNS[MID],15,LENGTH(BASE_NOUNS[MID])-14), RES);
      CASE RES OF
        LT : HIGH := MID - 1;
        EQ : FOUND := TRUE;
        GT : LOW := MID + 1;
      END;
    END;
  IF FOUND
    THEN IN_BASE_NOUNS := MID;
END;


  PROCEDURE INIT_ARR;
          (*========*)
    VAR
      I : INTEGER;
  BEGIN
    FOR I := 0 TO 1 DO
      WITH PART_ARR [I] DO
        BEGIN
          STS := ZERO;
          LIN := DUMMY;
          TKN := DUMMY;
          CLS := 0;
          CLS2 := 255;
          NUMB := UNKN;
          GEND := NONE;
          ANIM := IND;
        END;
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


{ Adjectives with endings éÇ/éÇÄ/éÇé/éÇõ or ÖÇ/ÖÇÄ/ÖÇ/ÖÇõ }
FUNCTION IN_OV_OVA (STEM : STR115) : BOOLEAN;
       (*=========*)
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
CONST
  OVMAX = 100;
  ST : ARRAY [1..OVMAX] OF STRING [20] =
('ÄÅÖãÖ','ÄÇÉàÖ','ÄÑé','^Äççàóäé','ÄççàÅÄãé','ÄÑÄåé',
'ÄÑé','Äçíéçé','ÄêÖÑé','ÄêàëíéíÖãÖ','ÄêïàåÖÑé',
'ÄïàããÖëé','Äïàããé','ÅÄâÖëé','^ÅÄêÖçñÖ','^ÅÖêàçÉé',
'ÅÄíõÖ','ÅÖêíéãÖíé','ÅàäîéêÑé','ÅêÄíé','ÅìãÖ',
'^ÇÄãúèìêÉàÖ','^ÇÄãíÄëÄêé','ÇÖêÉàãàÖ','ÇàããàáàÖ',
  'Çéãúíé','^ÇéãúíÖêé','Çéêéçé',
'ÉÄâåéêé','ÉÄãÖçé','ÉÄåàãúíéçé','^ÉÄççàÅÄãé','ÉÄìëëé',
  'ÉÖêÄäãé','ÉÖêéëíêÄíé','ÉÖêäìãÖëé','^ÉÖêäìãÖëé',
  'ÉéåÖêé','ÉéêÑàÖ','ÉéëìÑÄêÖ','^ÉìÑáéçé','ÉãÄìÅÖêé',
'ÑÖäÄêíé','^ÑÄçàãé','^ÑÄçíé','ÑÄçíé','ÑÄåéäãé',
  'ÑÖÑé','ÑàéîÄçíé','Ñìïé','ÑéäéãìåÅé','ÑêÄäéçé',
'ÖÇäãàÑé','ÖÇëíÄïàÖ',
'äÖëÄêÖ','äÄàçé','^äÄâåÄçé','äéêàéãàëé','äéôÖÖ',
  '^äêÖâñÖêé','äêéäéÑàãé','^äìãàäé',
'ãÄèãÄëé','ãìääìãé','^åÄÉÖããÄçé','åÄåÄÖ','åÄêäëé',
'çÖÖÇäãàÑé','çÖèíìçé','çéÖ','éíñé',
'èÄïàéçé','èàêêé','èàîÄÉéêé','èéèé','èêéäêìëíé','èêéåÖíÖÖ',
'êàåÄçé',
'ëÄåëéçé','ëàáàîé','ëàãúÇàÖ','ëéãéåéçé','^ëéãéåéçé',
  'ëîàçäëé','ëõçé',
'íÄçíÄãé','íéêêàóÖããàÖ','îÄããéèàÖ','^îàãàèèé',
'ïÄåé','ïÄìëÑéêîé','ïêàëíé','^ïêàëíé','ñÄêÖ','óÖêíé',
'ùÑàèé','ùáéèé','ùâãÖêé','^ùâîÖãÖ','ùéãé');
BEGIN
  FOUND:=FALSE; 
  I:=0;
  REPEAT 
    INC(I); 
    FOUND := (ST[I] = STEM);
  UNTIL FOUND OR (I = OVMAX);
  IN_OV_OVA := FOUND;
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
            ELSE CLASS := 1;
        'ñ' : CLASS := 22;
        'í','Ñ','Ç','å','ã','ê','è','Å','ë','á' : CLASS := 9;
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
            ELSE IF (STEM = 'äÄê') OR (STEM = 'ÑêÖÇã') 
              OR (STEM = 'ÑãàççéòÖ') OR (STEM = 'äéêéíäéòÖ')
              OR (STEM = 'íéãëíéòÖ') OR (STEM = 'íéçäéòÖ')
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
              'ñ' : CLASS := 22;
              'í','Ñ','Ç','å','ã','ê','è','Å','ë','á' : CLASS := 9;
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
     ELSE IF (LAST = 'ñ')
        THEN CLASS := 22
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
              'ñ' :
                CLASS := 22;
              'í','Ñ','Ç','å','ã','ê','è','Å','ë','á' :
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
     30,51,52 :  (* -éí/-Ä/-é *)
      IF (STEM = 'í')
        THEN CLASS := 13
      ELSE IF (STEM = 'ùí')
        THEN CLASS := 14
        ELSE CLASS := 0;
    31..34 : (* -Ç/-ÇÄ/-Çé/-Çõ *)
      IF IN_OV_OVA (STEM)
        THEN CLASS := 18
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
    42,43 : (* -çÄ/-çé *)
      IF (STEM = 'éÑ')
        THEN CLASS := 16
        ELSE CLASS := 0;
    44,45,46 : (* -çÖ/-Öçú/-çü *)
      IF (STEM = 'ÉéëèéÑ')
        THEN CLASS := 21
        ELSE CLASS := 0;
    47 : (* -Ö *)
      IF (STEM = 'í')
        THEN CLASS := 13
        ELSE CLASS := 0;
    48 : (* -Öâ *)
      IF (STEM = 'ó') OR (STEM = 'çàó') 
        OR (STEM = 'äéÖ-ó')
        THEN CLASS := 20
        ELSE CLASS := 0;
    49 : (* -à *)
      IF (STEM = 'ùí')
        THEN CLASS := 14
        ELSE CLASS := 0;
    35,36,50,53 : (* -õç/-õçÄ/-õçé/-õçõ *)
      IF (STEM = 'äìêàñ') OR (STEM = 'èãÖåüççàñ') 
        OR (STEM = 'äéÅõãàñ') OR (STEM = 'äéêåàãàñ')
        OR (STEM = 'íêéàñ')  
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
      N, P : INTEGER;
      STEM, TKN : STR115;

  BEGIN
    CLASS := 0;
    IF (POS ('çÖ ', TOKEN) = 1) OR (POS ('çà ', TOKEN) = 1)
      OR (POS ('à ', TOKEN) = 1) OR (POS ('àãà ', TOKEN) = 1)
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


  FUNCTION ISINS (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      INSFIN : ARRAY [1..6] OF STR2 =
        ('åà','õå','éå','àå','éâ','úû');
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


  FUNCTION IS_PREPOS (TOKEN : STR115) : BOOLEAN;
         (*=========*)
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (TOKEN = PREPOSIT [I]);
    UNTIL FOUND OR (I = 27);
    IS_PREPOS := FOUND;
  END;


  FUNCTION HAS_ADV_PREPOS (TOKEN : STR115) : BOOLEAN;
         (*==============*)
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := COPY (TOKEN, 1, LENGTH (PREPOSIT [I]) + 1) = PREPOSIT [I] + BL;
    UNTIL FOUND OR (I = 26);
    HAS_ADV_PREPOS := FOUND;
  END;


  FUNCTION IS_ADVERB (TOKEN : STR115) : BOOLEAN;
         (*=========*)
    CONST
      ADVERBS : ARRAY [1..61] OF STR115 =
        ('ÅãÄÉéÑÄêü','ÇÅãàáà','ÇÇÖêï','ÇÑÄãà','ÇÑéÇéãú','ÇÑêìÉ',
        'ÇáÄÑ','ÇåÖëíÖ','Ççàá','ÇçéÇú','ÇéäêìÉ','ÇéèêÖäà','ÇèÖêÖÑ',
        'Çèêàíõä','Çêéáú','ÇëÖÉÑÄ','ÇëÖêúÖá','Çëäéãúáú','Çëãìï','Éãìèé',
        'Éìëíé','ÑéåÄ','áÑÖëú','àáÑÄãÖäÄ','àáÑÄãà','àçéÉÑÄ','àëèéÑÇéãú',
        'äêÄâçÖ','ãìóòÖ','åéãóÄ','çÄÇÖä','çÄÇëÖÉÑÄ','çÄáÄÑ','çÄéÅìå',
        'çÄìÉÄÑ','éíäìÑÄ','éóÖçú','èãéïé','èêÖÜÑÖ','èêÖêõÇàëíé','èêüåé',
        'êÖÑäé','ëãÄÅé','ëãÖÇÄ','ëçéÇÄ','ëéÇëÖå','ëèÖòÄ','ëèãéòú','ëèêÄÇÄ',
        'ëìïé','ëûÑÄ','íÄä','íÄå','íÇÖêÑé','íÖèÖêú','íàïé','íìÑÄ','íìí',
        'ïéêéòé','óÄëíé','óàëíé');
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (TOKEN = ADVERBS [I]);
    UNTIL FOUND OR (I = 61);
    IS_ADVERB := FOUND;
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


  FUNCTION ADV_LIKE (TOKEN : STR115) : BOOLEAN;
         (*========*)
    VAR
      L : INTEGER;
      FIN2 : STRING [2];
  BEGIN
    L := LENGTH (TOKEN);
    FIN2 := COPY (TOKEN, L-1, 2);
    ADV_LIKE := (IS_PREPOS (TOKEN) OR IS_ADVERB (TOKEN)
      OR HAS_ADV_PREPOS (TOKEN) OR ISINS (TOKEN)
      OR (TOKEN [L] = 'é') AND (POS (TOKEN [L-1], 'çãäÉÑèêÅïóò') > 0)
      OR (FIN2 = 'íé') AND (POS (TOKEN [L-2], 'àÄìüëõ') > 0)
      OR (FIN2 = 'Çé') AND (COPY (TOKEN, L-3, 4) <> 'ëíÇé')
      OR (COPY (TOKEN, L-2, 3) = 'ëäà') AND (POS (TOKEN [L-3], 'Öçêâú') > 0)
      OR (FIN2 = 'ôÖ') AND (POS (TOKEN [L-2], 'ûìüÄ') > 0)
      OR (FIN2 = 'åé') AND (POS (TOKEN [L-2], 'üàûé') > 0)
      OR (FIN2 = 'çÖ')
      OR (FIN2 = 'ìû')
      OR (TOKEN [L] = 'ì'));
  END;


  FUNCTION CPR_LIKE (TOKEN : STR115) : BOOLEAN;
         (*========*)
    VAR
      L : INTEGER;
  BEGIN
    L := LENGTH (TOKEN);
    CPR_LIKE := (TOKEN [L] = 'Ö') AND (POS (TOKEN [L-1], 'ÖòôóÜ') > 0);
  END;


  FUNCTION DEE_LIKE (TOKEN : STR115) : BOOLEAN;
         (*========*)
    VAR
      L : INTEGER;
  BEGIN
    L := LENGTH (TOKEN);
    DEE_LIKE := (TOKEN [L] = 'ü') AND (POS (TOKEN [L-1], 'ÄüìûÖíÑëáÅè') > 0)
      OR (TOKEN [L] = 'Ä') AND (POS (TOKEN [L-1], 'òôóÜ') > 0)
        AND (COPY(TOKEN, L-3, 4) <> 'ÑÄóÄ')
      OR (COPY (TOKEN, L-1, 2) = 'ëú') AND (POS (TOKEN [L-2], 'üÄà') > 0)
      OR (COPY (TOKEN, L-1, 2) = 'òà');
  END;


  PROCEDURE MAKE_ARR;
          (*========*)
    VAR
      I, P, P1, P2, {P3,} NEWCL : INTEGER;
      TKN0, TKN1, TMP : STR115;
      BOTH_ADJ, BOTH_VERB, BOTH_ADV, {BOTH_SUB,} 
        VALID, VAL2, DONE : BOOLEAN;
      LAB : STRING [2];

  BEGIN
    DONE := FALSE;

    FOR I := 0 TO 1 DO
      WITH PART_ARR [I] DO
        BEGIN
          P := POS ('<', LIN);
          IF P > 0
            THEN
              BEGIN
                LAB := COPY (LIN, P+1, 2);
                LIN := COPY (LIN, 1, P-1);
                IF (LAB = 'Su')
                  THEN STS := SUB
                ELSE IF (LAB = 'Ve')
                  THEN STS := VERB
                ELSE IF (LAB = 'Aj')
                  THEN STS := ADJ
                ELSE IF (LAB = 'Av')
                  THEN STS := ADV
                  ELSE WRITELN (FNAME, ' ERROR: WRONG LABEL AT ', LIN);
                IF (STS <> ZERO) AND (PART_ARR [1-I].STS = ZERO)
                  THEN PART_ARR [1-I].STS := STS;
              END;
          P1 := POS (NE, LIN);
          P2 := POS (NI, LIN);
          IF (P1 = 1) OR (P2 = 1)
            THEN TKN := COPY (LIN, 4, LENGTH (LIN) - 3)
            ELSE TKN := LIN;
          P := POS ('1', TKN) + POS ('2', TKN) + POS ('3', TKN)
            + POS ('4', TKN) + POS ('5', TKN) + POS ('6', TKN);
          IF P > 0
            THEN TKN := COPY (TKN, 1, P - 1);
        END;

    IF PART_ARR [0].STS <> ZERO
      THEN
        CASE PART_ARR [0].STS OF
          VERB:
            BEGIN
              P := POS (BL, PART_ARR [0].TKN);
              IF P > 0
                THEN
                  BEGIN
                    TMP := COPY (PART_ARR [0].TKN, 1, P - 1);
                    INITVERBCL (TMP, PART_ARR [0].CLS, VALID);
                    PART_ARR [0].CLS2 := 0;
                  END
                ELSE
                  BEGIN
                    INITVERBCL (PART_ARR [0].TKN, PART_ARR [0].CLS, VALID);
                    PART_ARR [0].CLS2 := 255;
                    VAL2 := TRUE;
                  END;
              P := POS (BL, PART_ARR [1].TKN);
              IF P > 0
                THEN
                  BEGIN
                    TMP := COPY (PART_ARR [1].TKN, 1, P - 1);
                    INITVERBCL (TMP, PART_ARR [1].CLS, VAL2);
                    PART_ARR [1].CLS2 := 0;
                  END
                ELSE
                  BEGIN
                    INITVERBCL (PART_ARR [1].TKN, PART_ARR [1].CLS, VAL2);
                    PART_ARR [1].CLS2 := 255;
                    VAL2 := TRUE;
                  END;
              IF NOT VALID OR NOT VAL2
                THEN WRITELN (FNAME, ' ERROR: WRONG LABELED PAIR: ',
                  PART_ARR [0].LIN, '...')
                ELSE
                  BEGIN
                    DONE := TRUE;
                    INC (COUNT [VERB], 2);
                  END;
            END;

          SUB :
            BEGIN  {1}
{IF (PART_ARR [0].TKN = 'ÇéÖççõÖ') THEN WRITELN ('1 ', PART_ARR [1].TKN);}
              INITSUBCL (PART_ARR [0].TKN, PART_ARR [0].CLS, VALID,
                PART_ARR [0].NUMB, PART_ARR [0].GEND, PART_ARR [0].ANIM);
              INITSUBCL (PART_ARR [1].TKN, PART_ARR [1].CLS, VAL2,
                PART_ARR [1].NUMB, PART_ARR [1].GEND, PART_ARR [1].ANIM);

                J := IN_BASE_NOUNS (PART_ARR [0].TKN);
                IF (J > 0)
                  THEN
                    BEGIN
{IF (PART_ARR [0].TKN = 'ÇéÖççõÖ') THEN WRITELN (BASE_NOUNS[J]); }
                      VAL (COPY (BASE_NOUNS[J], 3, 3), PART_ARR [0].CLS, ERC);
                      PART_ARR [0].NUMB := NUMBER (ORD(BASE_NOUNS[J,11])-ORD('0'));
                      PART_ARR [0].GEND := GENDER (ORD(BASE_NOUNS[J,13])-ORD('0'));
                      VALID := TRUE;
                    END; 

                K := IN_BASE_NOUNS (PART_ARR [1].TKN);
{IF (PART_ARR [0].TKN = 'òíÄíëäàÖ') THEN WRITELN (BASE_NOUNS[ä]);}
                 IF (K > 0)
                  THEN
                    BEGIN
                      VAL (COPY (BASE_NOUNS[K], 3, 3), PART_ARR [1].CLS, ERC);
                      PART_ARR [1].NUMB := NUMBER (ORD(BASE_NOUNS[K,11])-ORD('0'));
                      PART_ARR [1].GEND := GENDER (ORD(BASE_NOUNS[K,13])-ORD('0'));
                      VAL2 := TRUE;
                    END; 
              DONE := TRUE;
              INC (COUNT [SUB], 2);
            END;
      
          ADJ :
            BEGIN  {2}
IF (PART_ARR [0].TKN = 'ÇéÖççõÖ') THEN WRITELN ('2 ', PART_ARR [1].TKN);
              INITADJCL (PART_ARR [0].TKN, PART_ARR [0].CLS,
                PART_ARR [0].GEND, PART_ARR [0].NUMB);
              INITADJCL (PART_ARR [1].TKN, PART_ARR [1].CLS,
                PART_ARR [1].GEND, PART_ARR [1].NUMB);
              DONE := TRUE;
              INC (COUNT [ADJ], 2);
            END;
         
          ADV :
            BEGIN
              DONE := TRUE;
              INC (COUNT [ADV], 2);
            END;
        END;

    IF NOT DONE
      THEN
        BEGIN
          INITVERBCL (PART_ARR [0].TKN, PART_ARR [0].CLS, VALID);
          INITVERBCL (PART_ARR [1].TKN, PART_ARR [1].CLS, VAL2);
          BOTH_VERB := VALID AND VAL2;
          IF BOTH_VERB
            THEN
              BEGIN
                DONE := TRUE;
                PART_ARR [0].STS := VERB;
                PART_ARR [1].STS := VERB;
                INC (COUNT [VERB], 2);
              END;
        END;

    IF NOT DONE
      THEN
        BEGIN
IF (PART_ARR [0].TKN = 'ÇéÖççõÖ') THEN WRITELN (PART_ARR [1].TKN);
          INITADJCL (PART_ARR [0].TKN, PART_ARR [0].CLS,
            PART_ARR [0].GEND, PART_ARR [0].NUMB);
          INITADJCL (PART_ARR [1].TKN, PART_ARR [1].CLS,
            PART_ARR [1].GEND, PART_ARR [1].NUMB);
          BOTH_ADJ := (PART_ARR [0].CLS > 0) AND (PART_ARR [0].GEND = MASC)
            AND (PART_ARR [1].CLS > 0) AND (PART_ARR [1].GEND = MASC);
          IF BOTH_ADJ
            THEN
              BEGIN
                DONE := TRUE;
                PART_ARR [0].STS := ADJ;
                PART_ARR [1].STS := ADJ;
                INC (COUNT [ADJ], 2);
              END;
        END;

    IF NOT DONE
      THEN
        BEGIN
          TKN0 := PART_ARR [0].TKN;
          TKN1 := PART_ARR [1].TKN;
          BOTH_ADV := ADV_LIKE (TKN0) AND ADV_LIKE (TKN1)
            OR CPR_LIKE (TKN0) AND CPR_LIKE (TKN1)
            OR DEE_LIKE (TKN0) AND DEE_LIKE (TKN1);
          IF BOTH_ADV
            THEN
              BEGIN
                DONE := TRUE;
                PART_ARR [0].STS := ADV;
                PART_ARR [1].STS := ADV;
                INC (COUNT [ADV], 2);
              END;
        END;

    IF NOT DONE
      THEN
        BEGIN
IF (PART_ARR [0].TKN = 'ÇéÖççõÖ') THEN WRITELN (PART_ARR [1].TKN);
          INITSUBCL (PART_ARR [0].TKN, PART_ARR [0].CLS, VALID,
            PART_ARR [0].NUMB, PART_ARR [0].GEND, PART_ARR [0].ANIM);
       
          INITSUBCL (PART_ARR [1].TKN, PART_ARR [1].CLS, VAL2,
              PART_ARR [1].NUMB, PART_ARR [1].GEND, PART_ARR [1].ANIM);
        
          IF (PART_ARR [0].CLS > 0) OR (PART_ARR [1].CLS > 0)
            THEN
              BEGIN
                INC (COUNT [SUB], 2);
                PART_ARR [0].STS := SUB;
                PART_ARR [1].STS := SUB;

                J := IN_BASE_NOUNS (PART_ARR [0].TKN);
                IF (J > 0)
                  THEN
                    BEGIN
IF (PART_ARR [0].TKN = 'ÇéÖççõÖ') THEN WRITELN (BASE_NOUNS[J]);
                      VAL (COPY (BASE_NOUNS[J], 3, 3), PART_ARR [0].CLS, ERC);
                      PART_ARR [0].NUMB := NUMBER (ORD(BASE_NOUNS[J,11])-ORD('0'));
                      PART_ARR [0].GEND := GENDER (ORD(BASE_NOUNS[J,13])-ORD('0'));
                      VALID := TRUE;
                    END; 

                K := IN_BASE_NOUNS (PART_ARR [1].TKN);
                IF (K > 0)
                  THEN
                    BEGIN
                      VAL (COPY (BASE_NOUNS[K], 3, 3), PART_ARR [1].CLS, ERC);
                      PART_ARR [1].NUMB := NUMBER (ORD(BASE_NOUNS[K,11])-ORD('0'));
                      PART_ARR [1].GEND := GENDER (ORD(BASE_NOUNS[K,13])-ORD('0'));
                      VAL2 := TRUE;
                    END; 

              {  IF (PART_ARR [0].ANIM = YES) AND (PART_ARR [1].ANIM = NO)
                  AND CAN_BE_ANIMATED (PART_ARR [1].CLS, NEWCL)
                  THEN PART_ARR [1].CLS := NEWCL;
                IF (PART_ARR [1].ANIM = YES) AND (PART_ARR [0].ANIM = NO)
                  AND CAN_BE_ANIMATED (PART_ARR [0].CLS, NEWCL)
                  THEN PART_ARR [0].CLS := NEWCL; }
              END
            ELSE WRITELN (FNAME, ' ERROR: WRONG PAIR: ',
              ORD (ADV_LIKE (PART_ARR [0].LIN)), BL, PART_ARR [0].LIN, '...',
              ORD (ADV_LIKE (PART_ARR [1].LIN)), BL, PART_ARR [1].LIN);
        END;
  END;


  PROCEDURE OUT_ARR;
          (*=======*)
    VAR
      I, P : INTEGER;
  BEGIN
    FOR I := 0 TO 1 DO
      WITH PART_ARR [I] DO
        BEGIN
          IF I = 0
            THEN WRITE (OUT, '+')
            ELSE WRITE (OUT, '-');
          P := POS ('<', LIN);
          IF (P > 0) AND (LENGTH (LIN) - P = 2)
            THEN LIN := COPY (LIN, 1, P-1);
          P := POS ('3', LIN);
          IF (P = LENGTH (LIN)) AND (STS = VERB) AND (LIN = 'ÅéãÖíú3')
            THEN CLS := 41;
          WRITELN (OUT, ORD (STS) : 2, CLS : 4, CLS2 : 4,
            ORD (NUMB) * ORD (STS = SUB) : 2,
            ORD (GEND) * ORD (STS = SUB) : 2, BL, LIN);
        END;
  END;

BEGIN      (* MAIN *)


  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' THEN
    XL_DAS := '../DAS/';

  FOR ST := ZERO TO ADV DO
    COUNT [ST] := 0;

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

  ASSIGN (OUT, 'ANTONYMS.COD');
  REWRITE (OUT);
  
  FILL_BASE_NOUNS;

  FNAME := 'ANTONYM'+ {CHR (ORD('0') + I)+} '.TXT';
  ASSIGN (INP, FNAME);
  RESET (INP);
  LINENUM := 0;
  INIT_ARR;
  PREVLINE := '';

  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);
    IF (LINE [LENGTH (LINE)] = BL) OR (POS(TAB,LINE) > 0)
      THEN
        BEGIN
          WRITELN (FNAME, ' ERROR: Wrong blank(s) in line ', LINENUM);
          HALT;
       END;
    IF (LINE <= PREVLINE)
      THEN
        BEGIN
          WRITELN (FNAME, ' ERROR: DISORDER AT LINE: ', LINENUM);
          HALT;
        END;

     (* ÇõÑÖãÖçàÖ ãÖÇéÉé éåéçàåÄ *)
    LINE1 := COPY (LINE, 1, 22);
    LAST := LINE1 [LENGTH (LINE1)];
    WHILE (LAST = BL) AND (LINE1 > DUMMY) DO
      BEGIN
        LINE1 := COPY (LINE1, 1, LENGTH (LINE1) - 1);
        LAST := LINE1 [LENGTH (LINE1)];
      END;
    PART_ARR [0].LIN := LINE1;

     (* ÇõÑÖãÖçàÖ èêÄÇéÉé éåéçàåÄ *)
    PART_ARR [1].LIN := COPY (LINE, 23, LENGTH (LINE) - 22);

     (* éÅêÄÅéíäÄ èÄêõ *)
    IF PART_ARR [0].LIN  >= PART_ARR [1].LIN
      THEN
        BEGIN
          WRITELN (FNAME, ' ERROR: INVERTED PAIR: ', PART_ARR [0].LIN,
            BL, '>=<', BL, PART_ARR [1].LIN);
          HALT;
        END;
    MAKE_ARR;
    OUT_ARR;
    INIT_ARR;
    PREVLINE := LINE;
  UNTIL EOF (INP);

  FLUSH (OUT);

  WRITELN ('FILE "ANTONYMS.COD" IS OUTPUT');

  TOTAL := COUNT [SUB] + COUNT [VERB] + COUNT [ADJ] + COUNT [ADV];
  WRITELN;
  WRITELN ('NUMBER OF NOUNS = ', COUNT [SUB]);
  WRITELN ('NUMBER OF VERBS = ', COUNT [VERB]);
  WRITELN ('NUMBER OF ADJECTIVES = ', COUNT [ADJ]);
  WRITELN ('NUMBER OF ADVERBS = ', COUNT [ADV]);
  WRITELN ('TOTAL ANTONYM LINKS = ', TOTAL);
END.
