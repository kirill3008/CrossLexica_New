     { WARNINGS about OPFUNCxx.TXT files content: 
  1. One-word noun vocables should include all homonymous options
     occurring elsewhere, as well as all coordinate noun pairs 
     occurring in SUPNOM files (except pairs of personal names).
  2. Managing verbs should include all homonymous verbs occurring 
     elsewhere.
  3. The widest possible use of prepositions registered in PREPOS 
     array is our goal. Some of already registered prepositions 
     are absent in verb-to-noun collocatios so far, whie SUPNOM 
     files with noun-to-noun collocations deliver additional ones. }

PROGRAM ENCODEOB2;

USES DOS, CLASTABL, INITVER4;

  TYPE
    STR115 = STRING [115];
    STR35 = STRING [39];
    SCALE = (NOTNUM, UNUS, SMALL, BIG1, BIG2);

  CONST
    MAXPART = 900;
    MAXSHORT = 360;
    MINEXAMPL = 20;
    MAXEXAMPL = 50;

    GAP = 24;

    SUFS : ARRAY [1..53] OF STRING [4] =
     ('›‰', 'ˆ‰', 'Ž‰', 'ˆ‰‘Ÿ', '€Ÿ', 'ŸŸ', '€Ÿ‘Ÿ', 'Ž…', '……',
      '……‘Ÿ', '›…', 'ˆ…', 'ˆ…‘Ÿ', 'œŸ', 'œ…', 'œˆ', 'ŽŸ', 'Žˆ',
      '€˜', '€˜€', '€˜…', '€˜ˆ', 'ˆ', 'ˆ€', 'ˆŽ', 'ˆ›',
      '…‘œ', '‘Ÿ', '‘…', 'Ž’', '‚', '‚€', '‚Ž', '‚›',
      '›€', '›Ž', 'ˆ', '€Œ', '€Œ€', '€ŒŽ', '€Œˆ', '€', 'Ž', 
      '…', '…œ', 'Ÿ', '…', '…‰', 'ˆ', '›', '€', 'Ž', '››');
    TAB = #009;
    VERBTAILMAX = 26;
    VERBTAIL : ARRAY [1..VERBTAILMAX] OF STRING [14] = 
      ('‚ ‡€‹“†„…ˆ…','‚…•','‚ˆŒ€ˆ…','‚ˆŒ€ˆŸ',
       '‚…ŒŸ','ƒ…‚','ƒ“‘’œ',
       '„…‹€','„…‹Ž','„Ž‹†Ž…','‡€ Ž‘Ž‚“','‡€’œ',
       'ŽŸ’œ','Œ…‘’Ž','€ ‡€Œ…’Š“','Ž’‚€™…ˆ…',
       'Ž…„“','Ž„ “ƒŽ‡“','Ž€†…ˆ…',
       'Ž‚…Š…','€„Ž‘’œ','‘‚…’','‘ˆŒ€’ˆž',
       '‘Š‹ŽŽ‘’œ','‘Ž—“‚‘’‚ˆ…','‘’€€ˆ…');
    CASNO : ARRAY [NOM..LOC] OF STR3 =
       ('NOM','GEN','DAT','ACC','INS','PRE','PAR','LOC');

   VAR
CLASS, SUBCL, ANIMSUBCL, DEANCL, ANCL, ANSUBCL,
  P, PI, PILI, PH, PK, IDIOM, STYL, ERC, ALLSOB, 
  INISOB, L1, QV, QP, QS, CLSI, D, PU, PB : INTEGER;
INP, OUT, OUT1, OUT2, OUT3, OUT4, OUT5, OUT6, OUTF, OUTG : TEXT;
LINENUM, J, AMT0, AMT11, AMT12, AMT13, AMT14, AMT15,
  AMT2, TOTAL, AMT, I, PARTAMT, GRNUM, CURSHORT : LONGINT;
FIRST, USACH : CHAR;
USECOUNT: ARRAY [1..5] OF LONGINT;
FNAME, FNAMEOUT{, FNAMEOUT1} : STRING [12];
LINE, HEADLINE, HEADER, SUBHEAD, VERB, TOK1, TOK2, PART2,
  PREVHEAD, CURHEAD, TRUNKV, TRUNKP, TRUNKS, PREPI : STR115;
VALID, SUBVAL, NG_CHANGE, DOUBLE_FL, FL_REVERS,
  THERE_IS_I, THERE_IS_H, THERE_IS_VLN, VALI : BOOLEAN;
NUMB, NUMB0, SUBNUMB, NMBI : NUMBER;
GEND, { gender implied by the verb }
GEND0, { gender of the noun } 
SUBGEND, ADJ_GEND, GNDI : GENDER;
ANIM, ANIM0, SUBANIM, ANMI : ANIMA;
CAS_WO_PREP : ARRAY [0..7] OF LONGINT;
SOB_COUNT : ARRAY [0..48] OF LONGINT;
PREPO : ARRAY [8..MAXPREP29] OF LONGINT;
PREPOTOTAL, WOPREPTOTAL : LONGINT;
VLNPAR : ARRAY [1..MAXSHORT, 1..2] OF INTEGER;{ vlong noun numbs & gends }
VLNSTR : ARRAY [1..MAXSHORT] OF STR115;        { vlong noun strings }

CASESETS : ARRAY [8..MAXPREP29] OF
  RECORD
    PREPCODE : LONGINT;
    EXAMQUAN : INTEGER;
    CASNAME : CASUS;
    CASTRING : STR35;
    EXAMPLES : ARRAY [0..MAXEXAMPL] OF ARRAY [1..2] OF STR35;
    EXAMPLES2 : ARRAY [0..MAXEXAMPL] OF STR115;
  END;

PARTARR : ARRAY [1..MAXPART] OF
  RECORD
    WHOLINE : STR115;     { Whole line from 3rd position } 
    NEG   : BOOLEAN;     { Sign of leading NE }
    TOKN  : STR115;       { Verb }
    VCLAS : INTEGER;     { Verb class}
    SOBN  : INTEGER;     { Identifier of reflexive with "‘…Ÿ/‘ŽŽ‰" }
    ONLYDOT : INTEGER;   { Sign of internal/trailing dots }
    PREPSTR : STR115;     { Preposition }
    GCAS  : INTEGER;     { Number of generalized case }
    FLEX  : STR11;       { Flection }
    FLX1  : STR11;       { Additional flection }
    IDI   : INTEGER;     { Sign of figurativity }
    STY   : INTEGER;     { Sign of style }
  END;

CONST NOGCAS = 255; { This GCAS not to be assigned }


{ Is preposition TOKEN among 32 top frequent in XL DB? }
FUNCTION IN_TOP_32 (TOKEN : STR115) : BOOLEAN;
        {=========}
  CONST
    TOKMAX0 = 32;
    TOP_32 : ARRAY [1..TOKMAX0] OF STRING [12] =
      ('‚2','‚1','€1','Š','€2','‘2','Ž’',
       'Ž1','ˆ‡','‡€1','Ž2','‘ ŽŒŽ™œž','‘1',
       '„Ž','‡€2','“','……„','ˆ','—……‡',
       'ˆ‡-‡€','„‹Ÿ','Ž Ž‚Ž„“','ˆ ŽŒŽ™ˆ',
       'Ž„1','Ž„2','Ž‘‹…','…‡','€„','Š€Š5',
       '‚ Š€—…‘’‚…','Ž’Ž‘ˆ’…‹œŽ','“’…Œ' );
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOP_32 [I] = TOKEN);
  UNTIL FOUND OR (I = TOKMAX0);
  IN_TOP_32 := FOUND;
END;

{ Initialization of very long nouns short list }
PROCEDURE VLN_ARRAY_SHORT;
         {===============}
VAR
  I : INTEGER;
  LINE : STR115;
  XL_DAS : STRING [255];
  INP : TEXT;
BEGIN
 { For reference file name }
  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' 
    THEN XL_DAS := '../DAS/';

 { Initiate array }
  ASSIGN (INP, XL_DAS+'FORBASE.DAS');
  RESET (INP);
  I := 0;
  REPEAT
    INC (I);
    READLN (INP, LINE);
    VLNPAR [I, 1] := ORD(LINE [1]) - ORD('0');
    VLNPAR [I, 2] := ORD(LINE [3]) - ORD('0');
    VLNSTR [I] := COPY (LINE, 5, LENGTH(LINE)-4);
  UNTIL EOF (INP) OR (I = MAXSHORT);
  CURSHORT := I;
  CLOSE (INP);
  writeln ('VLN_SHORTS are ', CURSHORT);
END;

{ TOKEN is among very long nouns short list }
FUNCTION AMONG_VLN_SHORTS (TOKEN : STR115;
        {================} VAR NUMR : NUMBER;
                           VAR GNDR : GENDER) : BOOLEAN;
VAR
  I : INTEGER;
  FOUND : BOOLEAN;
{  RES : RESTYPE; }          
BEGIN
  NUMR := UNKN;
  GNDR := NONE;

  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = VLNSTR[I]);
  UNTIL FOUND OR (I = CURSHORT);

  IF FOUND
    THEN 
      BEGIN
        NUMR := NUMBER (VLNPAR [I,1]);
        GNDR := GENDER (VLNPAR [I,2]);
      END;
  AMONG_VLN_SHORTS := FOUND;
END;


{ PART1 may be numeral of any SCALE }
FUNCTION AMONG_NUMERALS (PART : STR115;
        {==============} VAR ERC : INTEGER) : SCALE;
CONST
  MAXUNUS = 3;
  UNUSW : ARRAY [1..MAXUNUS] OF STR7 = 
('Ž„ˆ','Ž„€','Ž„Ž');
  MAXSMALL = 8;
  SMALLW : ARRAY [1..MAXSMALL] OF STR7 =
('„‚€','„‚…','Ž€','Ž…',
'Ž‹’Ž€','Ž‹’Ž›','’ˆ','—…’›…');
  MAXBIG1 = 9;
  BIGW1 : ARRAY [1..MAXBIG1] OF STRING [13] =
('„‚Ž…','’Ž…','—…’‚…Ž','Ÿ’…Ž','˜…‘’…Ž',
'‘…Œ…Ž','‚Ž‘œŒ…Ž','„…‚Ÿ’…Ž','„…‘Ÿ’…Ž');
  MAXBIG2 = 39;
  BIGW2 : ARRAY [1..MAXBIG2] OF STRING [13] =
('Ÿ’œ','˜…‘’œ','‘…Œœ','‚Ž‘…Œœ','„…‚Ÿ’œ',
'„…‘Ÿ’œ','Ž„ˆ€„–€’œ','„‚…€„–€’œ',
'’ˆ€„–€’œ','—…’›€„–€’œ','Ÿ’€„–€’œ',
'˜…‘’€„–€’œ','‘…Œ€„–€’œ','‚Ž‘…Œ€„–€’œ',
'„…‚Ÿ’€„–€’œ','„‚€„–€’œ','’ˆ„–€’œ','‘ŽŽŠ',
'Ÿ’œ„…‘Ÿ’','˜…‘’œ„…‘Ÿ’','‘…Œœ„…‘Ÿ’',
'‚Ž‘…Œœ„…‘Ÿ’','„…‚ŸŽ‘’Ž','„‚…‘’ˆ',
'‘’Ž','Ž‹‘’€','Ž‹’Ž€‘’€','’ˆ„…‚Ÿ’œ',
'’ˆ‘’€','—…’›…‘’€','Ÿ’œ‘Ž’','˜…‘’œ‘Ž’',
'‘…Œœ‘Ž’','‚Ž‘…Œœ‘Ž’','„…‚Ÿ’œ‘Ž’',
'‘ŠŽ‹œŠŽ','…Œ€‹Ž','…‘ŠŽ‹œŠŽ','ŒŽƒŽ');
VAR
  I, NUM : INTEGER;
  SCL : SCALE;
  FOUND : BOOLEAN;
BEGIN
  VAL (PART, NUM, ERC);
  IF ERC = 0
    THEN
      BEGIN
        IF ((NUM MOD 100) DIV 10 = 1)
          THEN SCL := BIG2
          ELSE
            CASE (NUM MOD 10) OF
              1 : SCL := UNUS;
              2, 3, 4 : SCL := SMALL;
              0, 5, 6, 7, 8, 9 : SCL := BIG2;
            END;
      END
  ELSE 
    BEGIN
      I := 0;
      REPEAT
        INC(I);
        FOUND := (PART = UNUSW[I]);
      UNTIL FOUND OR (I = MAXUNUS);
      IF FOUND 
        THEN SCL := UNUS
        ELSE
          BEGIN
            I := 0;
            REPEAT
              INC(I);
              FOUND := (PART = SMALLW[I]);
            UNTIL FOUND OR (I = MAXSMALL);
            IF FOUND 
              THEN SCL := SMALL
                ELSE
                  BEGIN
                    I := 0;
                    REPEAT
                      INC(I);
                      FOUND := (PART = BIGW1[I]);
                    UNTIL FOUND OR (I = MAXBIG1);
                    IF FOUND 
                      THEN SCL := BIG1
                      ELSE
                        BEGIN
                          I := 0;
                          REPEAT
                            INC(I);
                            FOUND := (PART = BIGW2[I]);
                          UNTIL FOUND OR (I = MAXBIG2);
                          IF FOUND 
                            THEN SCL := BIG2
                            ELSE SCL := NOTNUM;
                        END;
                  END;
          END;
    END;
  AMONG_NUMERALS := SCL;
END;

{ Initiate ARRAY content }
PROCEDURE INIT_ARRAY;
         {==========}
  VAR I : INTEGER;
BEGIN
  FOR I := 1 TO MAXPART DO
    WITH PARTARR [I] DO
      BEGIN
        WHOLINE := DUMMY;
        NEG  := FALSE;
        TOKN := DUMMY;
        VCLAS := 0;
        SOBN := 0;
        ONLYDOT := 0;
        PREPSTR := DUMMY;
        GCAS := 3;           {!!!}
        FLEX := DUMMY;
        FLX1 := DUMMY;
        IDI := 0;
        STY := 0;
      END;
 END;

FUNCTION HASFIN (TOKEN : STR115;
        {======} FINAL : STR5) : BOOLEAN;
  VAR L : INTEGER;
BEGIN
  L := LENGTH (FINAL);
  HASFIN := COPY (TOKEN, LENGTH(TOKEN)-L+1, L) = FINAL;
END;

{ 'Feminine' noun CLASS with the same endings 
   N = 1: in GEN and DAT áases 
   N = 2: in GEN, DAT, and INS áases }
FUNCTION FEMIN (CLASS : INTEGER; N : INTEGER) : BOOLEAN;
        {=====}
CONST
  FEMCL1 : ARRAY [1..7] OF INTEGER =
(64, 65, 66, 67, 70, 75, 76);
  FEMCL2 : ARRAY [1..9] OF INTEGER =
(82, 83, 141, 179, 185, 200, 213, 220, 224);
VAR 
  I, L : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  CASE N OF
    1:L:=7; 2:L:=9
  END;
  I:=0;
  REPEAT 
    INC(I); 
    FOUND := (N=1) AND (FEMCL1[I] = CLASS)
      OR (N=2) AND (FEMCL2[I] = CLASS);
  UNTIL FOUND OR (I = L);
  FEMIN := FOUND;
END;

{ Simple subject NUMB and GEND determining  
  based on its predicate VERB form }
PROCEDURE TEST_VERB_FIN (VERB : STR115;
         {=============} VAR NUMB : NUMBER;
                         VAR GEND : GENDER);
  VAR 
    L : INTEGER;
BEGIN
  L := LENGTH (VERB);
  NUMB := UNKN;
  GEND := NONE;
  IF HASFIN (VERB, '€') OR HASFIN (VERB, '€‘œ')
    THEN
      BEGIN
        NUMB := SING;
        GEND := FEM;
      END
  ELSE IF HASFIN (VERB, 'Ž') OR HASFIN (VERB, 'Ž‘œ')
    THEN
      BEGIN
        NUMB := SING;
        GEND := NEUT;
      END
  ELSE IF HASFIN (VERB, 'ˆ') OR HASFIN (VERB, 'ˆ‘œ') OR HASFIN (VERB, '›')
    THEN
      BEGIN
        NUMB := PLUR;
        GEND := COMN;
      END
  ELSE IF (POS (VERB [L], 'ƒŠ•‡‘‹') > 0) OR HASFIN (VERB, 'Ž’')
    OR HASFIN (VERB, '‹‘Ÿ') OR (VERB = '‹ž’') OR (VERB = 'ŽŠ‹Ÿ’')
    THEN
      BEGIN
        NUMB := SING;
        GEND := MASC;
      END
  ELSE IF HASFIN (VERB, 'ž’') OR HASFIN (VERB, 'ž’‘Ÿ')
    OR HASFIN (VERB, '“’‘Ÿ') OR HASFIN (VERB, '€’‘Ÿ')
    OR HASFIN (VERB, 'Ÿ’‘Ÿ')
    THEN
      BEGIN
        NUMB := PLUR;
        GEND := COMN;
      END
  ELSE IF HASFIN (VERB, '…’‘Ÿ') OR HASFIN (VERB, 'ˆ’‘Ÿ')
    THEN NUMB := SING;
END;

  { Classify verb to VERBCL }
PROCEDURE CLASSIFY_VERB (VTOK : STR115;
         {=============} VAR VERBCL : INTEGER);
  VAR
    L : INTEGER;
    TMP : STR115;
    VALID : BOOLEAN;
BEGIN
  L := LENGTH (VTOK);
  IF (POS (VTOK [L], '123456') > 0)
    THEN TMP := COPY (VTOK, 1, L-1)
    ELSE TMP := VTOK;
  VALID := TRUE;

  IF ((TMP = '„Ž•“’œ') AND (VTOK [L] = '2'))
    OR ((TMP='€•“’œ') AND (VTOK [L] = '1'))
    OR ((TMP='‡€€•“’œ') AND (VTOK [L] = '2'))
    OR (TMP='‘„Ž•“’œ') OR (TMP='Ž„Ž•“’œ')
    THEN VERBCL := 10
  ELSE IF ((TMP = '„Ž•“’œ') AND (VTOK [L] = '1'))
    OR ((TMP='€•“’œ') AND (VTOK [L] = '2'))
    OR ((TMP='‡€€•“’œ') AND (VTOK [L] = '1'))
    OR (TMP='Ž„Ž•“’œ') OR (TMP='……„Ž•“’œ')
    THEN VERBCL := 16
  ELSE IF (TMP='Ž‹…’œ') AND (VTOK [L] = '3')
      OR (TMP='‡€Ž‹…’œ') AND (VTOK [L] = '2')
    THEN VERBCL := 41
  ELSE IF ((TMP='†€’œ') OR (TMP='„Ž†€’œ')) AND (VTOK [L] = '2')
    THEN VERBCL := 128
  ELSE IF (TMP='Ž‹…—œ') AND (VTOK [L] = '2')
    THEN VERBCL := 18
  ELSE IF (TMP='‘†€’œ') AND (VTOK [L] = '2')
    THEN VERBCL := 169
  ELSE IF (TMP='‘…’œ') AND (VTOK [L] = '2')
    THEN VERBCL := 141
  ELSE IF (TMP='„‚ˆƒ€’œ') AND (VTOK [L] = '2')
    THEN VERBCL := 107
  ELSE IF (TMP='„‚ˆƒ€’œ‘Ÿ') AND (VTOK [L] = '2')
    THEN VERBCL := 98
  ELSE IF ((TMP='‚…‡€’œ') OR (TMP='‘…‡€’œ')) AND (VTOK [L] = '2')
    THEN VERBCL := 3
  ELSE IF (TMP='‡€‚Ÿ‡€’œ') AND (VTOK [L] = '1')
    THEN VERBCL := 3
  ELSE IF ((TMP='ˆ‘€’œ') OR (TMP='€ˆ‘€’œ')) AND (VTOK [L] = '3')
    THEN VERBCL := 3
  ELSE IF (TMP='’“‘ˆ’œ') AND (VTOK [L] = '2')
    THEN VERBCL := 207
  ELSE IF ( (TMP='‚‘›€’œ') OR (TMP='‚›‘›€’œ') OR (TMP='„Ž‘›€’œ') 
    OR (TMP='‡€‘›€’œ') OR (TMP='€‘›€’œ') OR (TMP='Ž‘›€’œ') 
    OR (TMP='……‘›€’œ') OR (TMP='Ž‘›€’œ')  OR (TMP='Ž’‘›€’œ')
    OR (TMP='Ž„‘›€’œ') OR (TMP='Ž‘›€’œ') OR (TMP='Ž‘›€’œ') 
    OR (TMP='€‘‘›€’œ') OR (TMP='‘‘›€’œ') OR (TMP='“‘›€’œ') ) 
    AND (VTOK [L] = '1')
    THEN VERBCL := 246
  ELSE IF ((TMP='‚›‘›€’œ‘Ÿ') OR (TMP='€‘‘›€’œ‘Ÿ')) AND (VTOK [L] = '1')
    THEN VERBCL := 247
  ELSE INITVERBCL (TMP, VERBCL, VALID);

  IF NOT VALID
    THEN WRITELN (FNAME, ' ERROR: Unclassified or shifted verb ', 
      TMP, ' at ', HEADLINE); 
END;

{ Codify collocation LINE with number NUM in group }
PROCEDURE CODE_LINE (NUM : INTEGER;
         {=========} LINE : STR115);
  VAR
    LINE1 : STR115;
    I, P, P1, LOW, HIGH, MID : INTEGER;
    FOUND, FOUND1 : BOOLEAN;
    RESULT : RESTYPE;
    SOBSTR, FLEXSTR : STR115;
    TMP : STR11;

BEGIN
  LINE1 := COPY (LINE, 3, LENGTH(LINE)-2);

  WITH PARTARR [NUM] DO
    BEGIN
{ Assigning figurativity (idiomaticity) and style }
      IDI := IDIOM;
      STY := STYL;

{ Extraction of trailing dots if exist }
      IF COPY (LINE1, LENGTH(LINE1)-3, 4) = ' ...'
        THEN
          BEGIN
            ONLYDOT := 4;
            LINE1 := COPY (LINE1, 1, LENGTH(LINE1)-4);
          END;

{ Extraction of leading NE if exist }
      NEG := POS (NE, LINE1) = 1;
      IF NEG
        THEN LINE1 := COPY (LINE1, 4, LENGTH(LINE)-3);
      WHOLINE := LINE1;
{ Find and classify verb }
      P := POS (BL, LINE1);
      TOKN := COPY (LINE1, 1, P-1); { <-- this is verb }
      CLASSIFY_VERB (TOKN, VCLAS);      
      
{ String to be elaborated further is }
      LINE1 := COPY (LINE1, P+1, LENGTH(LINE1)-P);

{ Extraction of reflexive ‘…Ÿ/‘……/‘ŽŽ‰/... }
      P := POS ('‘Ž', LINE1) + POS ('‘…', LINE1);
      IF (P > 0) 
        AND (POS ('‚ Ž‘Ž…Ž‘’ˆ', LINE1) = 0)
        AND (POS ('Ž‘Ž…Ž', LINE1) = 0)
        AND (POS ('‘Ž‹€‡', LINE1) = 0)
        AND (POS ('‘Ž‘’‚…Ž', LINE1) = 0)
        THEN
          BEGIN
            REPEAT
              INC (P);
            UNTIL (LINE1 [P] = BL);

            SOBSTR := COPY (LINE1, 1, P-1);
            LINE1 := COPY (LINE1, P+1, LENGTH(LINE1)-P);

            FOUND1 := FALSE;
            I := 0;
            REPEAT 
              INC(I); 
              FOUND1 := (SOBSTR = SOBOJ [I]);
            UNTIL FOUND1 OR (I = 48);

            IF FOUND1
              THEN 
                BEGIN
                  SOBN := I;
                  INC(SOB_COUNT[I]);
                END
              ELSE WRITELN (FNAME, ' ERROR: Wrong reflexive at ',
                HEADER, '=>', LINE);
          END
      ELSE
{ Extraction of compound verb with tail like ‚ˆŒ€ˆ…/Œ…‘’Ž... }
        BEGIN
          FOUND1 := FALSE;
          I := 0;
          REPEAT 
            INC(I);
            L1 := LENGTH (VERBTAIL [I]); 
            FOUND1 := (VERBTAIL [I] = COPY (LINE1, 1, L1)) 
              AND (LINE1 [L1+1] = BL);
          UNTIL FOUND1 OR (I = VERBTAILMAX);

          IF FOUND1
            THEN
              BEGIN
                SOBN := I + 100;
                LINE1 := COPY (LINE1, L1+2, LENGTH (LINE1)-L1-1);
              END
            
{ Extraction of compound 	verb with tail ‡€Œ“† }
          ELSE IF (POS('‡€Œ“†…Œ', LINE1) = 1)
            THEN
              BEGIN
                SOBN := 200;
                LINE1 := COPY (LINE1, 9, LENGTH (LINE1)-8);
              END
          ELSE IF (POS('‡€Œ“†', LINE1) = 1)
            THEN
              BEGIN
                SOBN := 100;
                LINE1 := COPY (LINE1, 7, LENGTH (LINE1)-6);
              END
{ Extraction of compound verb with tail ‡€’œ 
          ELSE IF (POS('‡€’œ', LINE1) = 1)
            THEN
              BEGIN
                SOBN := 150;
                LINE1 := COPY (LINE1, 7, LENGTH (LINE1)-6);
              END }
{ Extraction of compound verb with tail ŽŸ’œ 
          ELSE IF (POS('ŽŸ’œ', LINE1) = 1)
            THEN
              BEGIN
                SOBN := 200;
                LINE1 := COPY (LINE1, 8, LENGTH (LINE1)-7);
              END }
{ Neither reflexive not verb tail }
          ELSE
            BEGIN
              SOBN := 0;
              INC(SOB_COUNT[0]);
            END
        END;

{ Extraction of internal dots }
      IF POS (DOTS, LINE1) = 1
        THEN
          IF ONLYDOT = 4
            THEN WRITELN (FNAME, ' ERROR: Excessive dots at ',
              HEADER, '=>', LINE)
            ELSE ONLYDOT := 3;
      CASE ONLYDOT OF
        1, 2 : LINE1 := COPY (LINE1, 4, LENGTH(LINE1)-3);
        3 : LINE1 := COPY (LINE1, 5, LENGTH(LINE1)-4);
      END;

{ Extraction of simple or compound preposition }
      GCAS := 0;            { Initial hypothesis !!!}
      P := POS (TILDE, LINE1);
      IF P = 0
        THEN
          BEGIN
            WRITELN (FNAME, ' ERROR: Lack of tilde at ',
              HEADER, '=>', LINE);
            EXIT;
          END;
 { Extracting possible preposition }
      PREPSTR := COPY (LINE1, 1, P-2);

{ if (prepstr = '… „€‹…… Š€Š €1')
  then writeln ('found it at ', HEADER); }

 { Is it really among prepositions ? }
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
{------------------------------------------------------------}                                                    
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
                                                                                                                         {===============}
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
                                                                                                                         {===============}
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
                   { --------------------------------------}                        
                                                END;
                                            END;    
                                        END;
                                    END;
                                END;
                            END;
                        END;
{---------------------------------------------------}
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

{ Extraction of flection }
      FLEXSTR := COPY (LINE1, P+1, LENGTH(LINE1)-P);
      P1 := POS (TILDE, FLEXSTR);
      IF P1 = 0
        THEN
          BEGIN
            IF DOUBLE_FL
              THEN WRITELN (FNAME, ' ERROR: Wrong tildes for ', HEADLINE)
              ELSE
                IF FLEXSTR = DUMMY
                  THEN FLEX := TILDE
                  ELSE FLEX := FLEXSTR;
          END
        ELSE
          BEGIN
            FLEX := COPY (FLEXSTR, 1, P1-2);
            IF FLEX = DUMMY
              THEN FLEX := TILDE;
            FLX1 := COPY (FLEXSTR , P1+1, LENGTH(FLEXSTR)-P1);
            IF FLX1 = DUMMY
              THEN FLX1 := TILDE;
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

{ Is TOKEN day number? }
FUNCTION IS_DAY_NUM (TOKEN : STR115) : BOOLEAN;
        {==========}
  CONST
    MAX = 31;
    DAY_TOKENS : ARRAY [1..MAX] OF STRING [2] =
('1','2','3','4','5','6','7','8','9',
'10','11','12','13','14','15','16','17',
'18','19','20','21','22','23','24',
'25','26','27','28','29','30','31');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = DAY_TOKENS [I])
  UNTIL FOUND OR (I = MAX);
  IS_DAY_NUM := FOUND;
END; 

{ Is TOKEN month name? }
FUNCTION IS_MONTH_NAME (TOKEN : STR115) : BOOLEAN;
        {=============}
  CONST
    MAX = 12;
    MONTH_TOKENS : ARRAY [1..MAX] OF STRING [8] =
('Ÿ‚€Ÿ','”…‚€‹Ÿ','Œ€’€','€…‹Ÿ','Œ€Ÿ','ˆžŸ',
'ˆž‹Ÿ','€‚ƒ“‘’€','‘…’ŸŸ','ŽŠ’ŸŸ','ŽŸŸ','„…Š€Ÿ');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = MONTH_TOKENS [I])
  UNTIL FOUND OR (I = MAX);
  IS_MONTH_NAME := FOUND;
END; 

{ Is possible PARtitive case for TOKEN? }
FUNCTION PART_POSSIBLE (TOKEN : STR115) : BOOLEAN;
        {=============}
  CONST
    PARTMAX = 68;
    PART_TOKENS : ARRAY [1..PARTMAX] OF STRING [9] =
('…‡ˆ','‚‡„Ž','‚ˆ„','ƒ€‡','ƒ€‡ŽŠ',
'„Ž‹ƒ','„“•','„›Œ','„›ŒŽŠ','†€','‡€€•',
'Š‚€‘','Š‚€‘ŽŠ','Š“€†','ŠˆŸ’ŽŠ','ŠŽœŸŠ','ŠŽœŸ—ŽŠ',
  'ŠŽ”……Š','ŠŽ”…‰','Š€•Œ€‹',
'‹…„','‹…‘','‹…’','Œ€•','Œ…„','Œ…„ŽŠ','ŒŽ‘','Œ“‘Ž',
'€Ž„…–','ŽƒŽ…Š',
'€','……“ƒ','……–','…—ˆŠ','…‘ŽŠ','…‘Ž—…Š','ŽŽ•',
'‘€•€','‘€•€ŽŠ','‘‚…’','‘…ƒ','‘…†ŽŠ','‘ŽŠ',
  '‘Ž—ŽŠ','‘’€•','‘“','‘“…–','‘›','‘›ŽŠ',
'’€€Š','’€€—ŽŠ','’Ž‹Š','’“Œ€','“Š‘“‘','”Ž‘',
'•Ž„','•Ž‹Ž„','—€…Š','—€‰','—…‘ŽŠ','—…‘Ž—ŽŠ',
'˜€ƒ','˜…‹Š','˜ˆŠ','˜ŽŠŽ‹€„','˜ŽŠŽ‹€„ˆŠ','˜ŽŽ•','Ÿ„');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = PART_TOKENS [I])
  UNTIL FOUND OR (I = PARTMAX);
  PART_POSSIBLE := FOUND;
END; 

{ Does verb TOKEN imply DATivness? }
FUNCTION MEANS_DATIV (TOKEN : STR115) : BOOLEAN;
        {===========}
  CONST
    TOKMAX = 184;
    SOME_TOKENS : ARRAY [1..TOKMAX] OF STRING [20] =
 ('‹€ƒŽ‚Ž‹ˆ’œ',
  '‚€ˆ’œ','‚…‡’ˆ','‚Ž‡ˆ’œ','‚…ˆ’œ','‚…“’œ',
'‚Ž‡€†€’œ','‚Ž‡€‡ˆ’œ','‚ŽŽ’ˆ‚ˆ’œ‘Ÿ','‚“—ˆ’œ',
'‚“—€’œ','‚›„…‹ˆ’œ','‚›„…‹Ÿ’œ','‚›€†€’œ','‚›€‡ˆ’œ',
  'ƒŽ‚Žˆ’œ','ƒ“ˆ’œ',
  '„€‚€’œ','„€‚€’œ‘Ÿ','„€’œ','„€ˆ’œ','„…ŒŽ‘’ˆŽ‚€’œ',
'„Ž‚…ˆ’œ','„Ž‚…ˆ’œ‘Ÿ','„Ž‚…Ÿ’œ','„ŽŠ‹€„›‚€’œ',
'„Ž‹Ž†ˆ’œ','„Ž‘’€‚ˆ’œ','„Ž‘’€‚‹Ÿ’œ','„Ž‘’€‚€’œ‘Ÿ',
'„Ž‘’€’œ‘Ÿ','„ˆ‚ˆ’œ‘Ÿ',
  '†€‹Ž‚€’œ‘Ÿ',
  '‡€‚ˆ„Ž‚€’œ','‡€„Ž‹†€’œ','‡€‹€’ˆ’œ','‡€…’ˆ’œ',
'‡€…™€’œ','‡€Ÿ‚ˆ’œ','‡€Ÿ‚‹Ÿ’œ','‡‚Žˆ’œ',
'ˆ„’ˆ','ˆ‡“Œˆ’œ‘Ÿ','ˆ‡“Œ‹Ÿ’œ‘Ÿ',
'Š€‡€’œ‘Ÿ','ŠŽ…‘Ž„ˆŽ‚€’œ','Œ…˜€’œ','ŒŽ‹ˆ’œ‘Ÿ',
'€„Ž…„€’œ','€„Ž…‘’œ','€ƒ“ˆ’œ','€Œ…Š€’œ',
  '€€ŠŽ‘’ˆ’œ','€ˆ‘€’œ','€ŽŒˆ’œ','…‘’ˆ',
  'Ž‘ˆ’œ','€‚ˆ’œ‘Ÿ',
'Ž…‘…—ˆ’œ','Ž…™€’œ','ŽšŸ‚ˆ’œ','ŽšŸ‚‹Ÿ’œ','Ž’‚…’ˆ’œ',
  'Ž’‚…—€’œ','Ž’„€‚€’œ','Ž’„€’œ','Ž’…‘’ˆ','Ž’Ž‘ˆ’œ',
  'Ž€„Ž‚€’œ‘Ÿ','Ž’€‚ˆ’œ','Ž’€‚‹Ÿ’œ',
'€ŠŽ‘’ˆ’œ','…Ÿ’œ','……‚Ž„ˆ’œ','……„€‚€’œ','……„€’œ',
  '…—€‹ˆ’œ‘Ÿ','ˆ‘€’œ','‹€’ˆ’œ','Ž‚’Žˆ’œ',
  'Ž‚’ŽŸ’œ','Ž‚…ˆ’œ','Ž„€‚€’œ','Ž„€’œ',
  'Ž„€ˆ’œ','Ž„‚…ƒ€’œ','Ž„‚…ƒ€’œ‘Ÿ','Ž„‚…ƒ“’œ',
  'Ž„‚…ƒ“’œ‘Ÿ','Ž„‹…†€’œ','Ž„—ˆŸ’œ','Ž„—ˆˆ’œ',
  'Ž„—ˆŸ’œ‘Ÿ','Ž„—ˆˆ’œ‘Ÿ','Ž†€‹Ž‚€’œ‘Ÿ','Ž‡‚Žˆ’œ',
  'ŽŠ€‡€’œ‘Ÿ','ŽŠŽˆ’œ‘Ÿ','ŽŠŽŸ’œ‘Ÿ','ŽŒ…˜€’œ',
  'ŽŒŽƒ€’œ','ŽŒŽ—œ','ŽŽ…™€’œ','Ž€†€’œ‘Ÿ','Ž€‡ˆ’œ‘Ÿ',
  'Ž‘‚Ÿ’ˆ’œ','Ž“—€’œ','Ž“—ˆ’œ','Ž‘‚Ÿ’ˆ’œ','Ž‘‚Ÿ™€’œ',
  'Ž‘’€‚‹Ÿ’œ','Ž‘‹€’œ','Ž‘‹“†ˆ’œ','Ž‘Ž—“‚‘’‚Ž‚€’œ',
  'Ž‘’€‚‹Ÿ’œ','Ž‘“‹ˆ’œ','Ž‘›‹€’œ','Ž’€Š€’œ',
  '…„‹€ƒ€’œ','…„‹Ž†ˆ’œ','…„Ž‘’€‚ˆ’œ',
  '…„Ž‘’€‚‹Ÿ’œ',{'…„Ž—…‘’œ','…„Ž—ˆ’€’œ',}
  '…Ÿ’‘’‚Ž‚€’œ','ˆ€‚ˆ’œ','ˆ€‚‹Ÿ’œ','ˆ‚…‡’ˆ',
  'ˆ‚Ž‡ˆ’œ','ˆ„€‚€’œ','ˆ„€’œ','ˆŠ€‡€’œ',
  'ˆŠ€‡›‚€’œ','ˆ€„‹…†€’œ','ˆ‘‹€’œ','ˆ‘›‹€’œ',
  'ˆ—ˆŸ’œ','ˆ—ˆˆ’œ','Ž„€‚€’œ','Ž„€’œ',
  'Ž„…ŒŽ‘’ˆŽ‚€’œ','Žˆƒ€’œ','Žˆƒ›‚€’œ',
  'Ž’ˆ‚ˆ’œ‘Ÿ','Ž‘’ˆ’œ','Ž’ˆ‚ˆ’œ‘Ÿ','Ž’ˆ‚ŽŽ‘’€‚ˆ’œ',
  'Ž’ˆ‚ŽŽ‘’€‚‹Ÿ’œ',
  'Ž’ˆ‚Ž„…‰‘’‚Ž‚€’œ','Ž’ˆ‚ŽŽ‘’€‚‹Ÿ’œ','Ž’ˆ‚Ž…—ˆ’œ',
  'Ž™€’œ',
'€„Ž‚€’œ‘Ÿ','€‚Ÿ’œ‘Ÿ','€‘‘Š€‡€’œ','€‘‘Š€‡›‚€’œ','…ŠŽŒ…„Ž‚€’œ',
'‘„€‚€’œ','‘„€’œ','‘‹…„Ž‚€’œ','‘‹“†ˆ’œ',
  '‘Ž‚…’Ž‚€’œ','‘ŽŽ™€’œ','‘ŽŽ™ˆ’œ','‘ŽŽ’‚…’‘’‚Ž‚€’œ',
  '‘“‹ˆ’œ','‘Ž“’‘’‚Ž‚€’œ','‘Ž—“‚‘’‚Ž‚€’œ','‘ˆŒ€’ˆ‡ˆŽ‚€’œ',
  '‘Ž‘Ž‘’‚Ž‚€’œ','‘‹€’œ','‘Ž‡€’œ‘Ÿ','‘Ž‡€‚€’œ‘Ÿ',
  '‘ŽŽ’ˆ‚‹Ÿ’œ‘Ÿ','’…Ž‚€’œ‘Ÿ',
'“ƒŽ†€’œ','“„ˆ‚ˆ’œ‘Ÿ','“„ˆ‚‹Ÿ’œ‘Ÿ','“„Ž‚‹…’‚ŽŸ’œ',
  '“„Ž‚‹…’‚Žˆ’œ','“‹›€’œ‘Ÿ','“†€‘“’œ‘Ÿ','“‘’“€’œ',
  '“‘’“ˆ’œ','“—ˆ’œ‘Ÿ','˜…’€’œ');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = TOKMAX);
  MEANS_DATIV := FOUND;
END;

{ Does verb TOKEN sometimes mean DATiveness? }
FUNCTION MEANS_DATIV0 (TOKEN : STR115) : BOOLEAN;
        {============}
  CONST
    TOKMAX0 = 12;
    SOME_TOKENS : ARRAY [1..TOKMAX0] OF STRING [20] =
 ('‚…‡’ˆ','‚Ž‡ˆ’œ','‚›€’œ','‚›…‘’ˆ',
  'ƒ“ˆ’œ','€ƒ“ˆ’œ','Š€‡€’œ‘Ÿ','Š“ˆ’œ',
  '€ŽŒˆ’œ','…‘’ˆ','ŽŽ‰’ˆ‘œ','Ž•Ž„ˆ’œ‘Ÿ');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = TOKMAX0);
  MEANS_DATIV0 := FOUND;
END;

{ Does verb TOKEN imply INStrumentality? }
FUNCTION MEANS_INSTR (TOKEN : STR115) : BOOLEAN;
        {===========}
  CONST
    TOKMAX = 158;
    SOME_TOKENS : ARRAY [1..TOKMAX] OF STRING [17] =
('Ž†ˆ’œ‘Ÿ','Ž‹…’œ','›’œ',
'‚‹€„…’œ','‚Ž‡ƒ‹€‚‹Ÿ’œ‘Ÿ','‚Ž‘•ˆ’ˆ’œ‘Ÿ','‚Ž‘•ˆ™€’œ‘Ÿ',
  '‚›ƒ‹Ÿ„…’œ','‚Ž‘Ž‹œ‡Ž‚€’œ‘Ÿ','‚Ž‘’Žƒ€’œ‘Ÿ',
  '‚Ž‘•ˆ™€’œ‘Ÿ','‚›“†„€’œ‘Ÿ','‚›€‡ˆ’œ‘Ÿ','‚›€†€’œ‘Ÿ',
  'ƒŽ„ˆ’œ‘Ÿ',
'„…‰‘’‚Ž‚€’œ','„…‹€’œ‘Ÿ','„…’…ŒˆˆŽ‚€’œ‘Ÿ','„ˆŠ’Ž‚€’œ‘Ÿ',
  '„Ž‚Ž‹œ‘’‚Ž‚€’œ‘Ÿ','…‘’œ','†ˆ’œ',
'‡€‚…„Ž‚€’œ','‡€‚…˜€’œ','‡€‚…˜ˆ’œ','‡€‚‹€„…’œ',
  '‡€Š€—ˆ‚€’œ‘Ÿ','‡€ŠŽ—ˆ’œ‘Ÿ','‡€Š€‘ˆ’œ','‡€Š€˜ˆ‚€’œ',
  '‡€Œ…ˆ’œ','‡€Œ…Ÿ’œ','‡€ˆŒ€’œ‘Ÿ','‡€Ÿ’œ‘Ÿ',
  '‡€ˆ‚€’œ','‡€‹€’ˆ’œ',
'ˆƒ€’œ','ˆ‡ˆ€’œ','ˆ‡€’œ','ˆ‡Œ…Ÿ’œ','ˆ’……‘Ž‚€’œ‘Ÿ',
'Š€‡€’œ‘Ÿ','Š‹Ÿ‘’œ‘Ÿ','ŠŽ—€’œ‘Ÿ','ŠŽ—ˆ’œ‘Ÿ',
'‹…—ˆ’œ‘Ÿ','‹žŽ‚€’œ‘Ÿ','Œ“—€’œ‘Ÿ','€‡‚€’œ',
'€‡›‚€’œ','€‡›‚€’œ‘Ÿ','€‡€—€’œ‘Ÿ','€‡€—ˆ’œ',
  '€Žˆ’œ','€Ž‹ˆ’œ','€Ž‹Ÿ’œ','€€‚ˆ’œ',
  '€€‚‹Ÿ’œ','€‘‹€„ˆ’œ‘Ÿ','€‘‹€†„€’œ‘Ÿ','€‘›’ˆ’œ‘Ÿ',
  '€‘›™€’œ‘Ÿ',
'Ž…‘…—ˆ‚€’œ','Ž…‘…—ˆ’œ','Ž‹€ƒ€’œ','Ž‹€ƒ€’œ‘Ÿ',
  'Ž‹€„€’œ','Ž‹ˆ–…‚€’œ','ŽŒ€“’œ‘Ÿ','ŽŒ€›‚€’œ‘Ÿ',
  'ŽŽ‰’ˆ‘œ','ŽŽ‹œ™€’œ‘Ÿ','Ž•Ž„ˆ’œ‘Ÿ','Ž˜ˆ‚€’œ',
  'Ž˜ˆ’œ','ŽšŸ‚ˆ’œ','ŽšŸ‚‹Ÿ’œ','ŽšŸ‘ˆ’œ',
  'ŽšŸ‘Ÿ’œ','ŽšŸ‘Ÿ’œ‘Ÿ','Ž‚‹€„…’œ','Žƒ€ˆ—ˆ‚€’œ‘Ÿ',
  'Žƒ€ˆ—ˆ’œ‘Ÿ','ŽŠ€‡€’œ‘Ÿ','ŽŠ€‡›‚€’œ‘Ÿ','Žˆ‘›‚€’œ',
  'Ž…„…‹Ÿ’œ‘Ÿ','Ž‘ŠŽˆ’œ‘Ÿ','Ž‘ŠŽ‹Ÿ’œ‘Ÿ',
  'Ž‘’€‚€’œ‘Ÿ','Ž‘’€’œ‘Ÿ','Ž’„…‹€’œ','Ž’„…‹›‚€’œ',
  'Ž’‹ˆ—€’œ‘Ÿ','Ž–…ˆ‚€’œ‘Ÿ','Ž—€Ž‚€’œ‘Ÿ','Ž—€Ž‚›‚€’œ‘Ÿ',
'€•“’œ','ŽŠ›‚€’œ','Žˆ’œ','ŽŠ›’œ',
  'Ž‹œ‡Ž‚€’œ‘Ÿ','Žˆ’€’œ‘Ÿ','Žˆ’›‚€’œ‘Ÿ',
  '…—€‹ˆ’œ‘Ÿ','ŽŠ€‡€’œ‘Ÿ','ŽŠ‹Ÿ‘’œ‘Ÿ','Ž€‚ˆ’œ‘Ÿ',
  'Ž‘‹“†ˆ’œ','…„‘’€‚ˆ’œ','…„‘’€‚‹Ÿ’œ','………ƒ€’œ',
  'ˆˆŒ€’œ','ŽˆŠ€’œ‘Ÿ','ŽˆŠ“’œ‘Ÿ',
'€Ž’€’œ','€‡€‡ˆ’œ‘Ÿ','€‡€†€’œ‘Ÿ','€‡ˆ‘Ž‚€’œ',
  '€‡ˆ‘Ž‚›‚€’œ','€‘Ž‹€ƒ€’œ',
  '…ƒ“‹ˆŽ‚€’œ‘Ÿ','“ŠŽ‚Ž„ˆ’œ','“ŠŽ‚Ž„‘’‚Ž‚€’œ‘Ÿ',
'‘„…‹€’œ‘Ÿ','‘‹“†ˆ’œ',{'‘€„ˆ’œ','‘€†€’œ',}'‘’€’œ',
  '‘’€Ž‚ˆ’œ‘Ÿ','‘’€„€’œ','‘’…‹Ÿ’œ','‘—ˆ’€’œ',
  '‘—ˆ’€’œ‘Ÿ',
'’…˜ˆ’œ‘Ÿ','’ŽŒˆ’œ‘Ÿ','’ŽƒŽ‚€’œ','’ŸƒŽ’ˆ’œ‘Ÿ',
'“ƒŽ‘’ˆ’œ','“ƒŽ‘’ˆ’œ‘Ÿ','“‚‹…—œ‘Ÿ','“‚‹…Š€’œ‘Ÿ','“ƒŽ™€’œ','“„€ˆ’œ',
  '“Š€‡€’œ','“Š€‡›‚€’œ','“Š€‘ˆ’œ','“Š€˜€’œ','“Š…ˆ’œ',
  '“Š…‹Ÿ’œ','“‘ŽŠ€ˆ‚€’œ‘Ÿ','“‘’€ˆ‚€’œ','“’…˜€’œ‘Ÿ',
  '“’…˜ˆ’œ‘Ÿ','“€‚‹Ÿ’œ','“€‚‹Ÿ’œ‘Ÿ','•€€Š’…ˆ‡Ž‚€’œ',
  '•€€Š’…ˆ‡Ž‚€’œ‘Ÿ',
'Ÿ‚ˆ’œ‘Ÿ','Ÿ‚‹Ÿ’œ‘Ÿ');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = TOKMAX);
  MEANS_INSTR := FOUND;
END;

{ Verb TOKEN implies GENitivity for PART case }
FUNCTION MEANS_GENIT0 (TOKEN : STR115) : BOOLEAN;
        {============}
  CONST
    TOKMAX = 38;
    SOME_TOKENS : ARRAY [1..TOKMAX] OF STRING [14] =
('‚“•€’œ','‚‘›€’œ','‚›ˆ’œ',
'„€‚€’œ','„€’œ','„Ž€‚ˆ’œ','„Ž€‚‹Ÿ’œ','„Žˆ‚€’œ‘Ÿ',
  '„Ž‘’€’œ',
'ˆ‡…ƒ€’œ','Š€‘€’œ‘Ÿ',
'€Š‹€„›‚€’œ','€ŠŽ‹Ž’œ','€‹ˆ’œ','€‹ˆ‚€’œ',
  '€‹Ž†ˆ’œ','€ˆ’œ‘Ÿ','€ˆ‚€’œ‘Ÿ','… „…‹€’œ',
  '… ‘„…‹€’œ',
'ŽŽŽ‚€’œ','ŽŽ‘ˆ’œ','ˆ„€‚€’œ','ˆ„€’œ',
'ˆ…‘’ˆ','Ž†€‹…’œ','Ž„€‚ˆ’œ','Ž„€‚‹Ÿ’œ',
'Ž‹Ž†ˆ’œ','ŽŽŽ‚€’œ','ˆ€‚ˆ’œ','ˆ€‚‹Ÿ’œ',
'… •‚€’ˆ’œ','•‚€’ˆ’œ','… •‚€’€’œ','•‚€’€’œ',
'•Ž’…’œ','•Ž’…’œ‘Ÿ');
   VAR
     I : INTEGER;
     FOUND : BOOLEAN;
BEGIN
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = TOKMAX);
  MEANS_GENIT0 := FOUND;
END;

{ Does verb TOKEN mean GENitivity in general? }
FUNCTION MEANS_GENIT (TOKEN : STR115) : BOOLEAN;
        {===========}
  CONST
    TOKMAX = 39;
    SOME_TOKENS : ARRAY [1..TOKMAX] OF STRING [14] =   
('ŽŸ’œ‘Ÿ','ƒ“˜€’œ‘Ÿ',
'„Žˆ‚€’œ‘Ÿ','„Žˆ’œ‘Ÿ','„Ž†„€’œ‘Ÿ','„ŽŒŽƒ€’œ‘Ÿ',
'„Ž‘’ˆƒ€’œ','„Ž‘’ˆ—œ',
'†„€’œ','ˆ‡…ƒ€’œ','ˆ‡…†€’œ','ˆ‘Š€’œ','ˆ‘“ƒ€’œ‘Ÿ',
'‹ˆ˜ˆ’œ','‹ˆ˜€’œ','‹ˆ˜ˆ’œ‘Ÿ','‹ˆ˜€’œ‘Ÿ',
'€€’œ‘Ÿ','€ˆ€’œ‘Ÿ','€ŒŽ‹Ž’œ',
  '€‘‹“˜€’œ‘Ÿ','€ˆ’œ‘Ÿ','€’……’œ‘Ÿ',
'Ž†ˆ„€’œ','Ž€‘€’œ‘Ÿ','Ž‘’……ƒ€’œ‘Ÿ','Ž‘‹“˜€’œ‘Ÿ',
'‹…‘“’œ','Ž€ˆ‚€’œ‘Ÿ','Ž’…Ž‚€’œ',
  'ˆ„…†ˆ‚€’œ‘Ÿ','“ƒ€’œ‘Ÿ',
'‘‹“˜€’œ‘Ÿ','‘’ŽŽˆ’œ‘Ÿ','‘’€˜ˆ’œ‘Ÿ',
'‘’…‘Ÿ’œ‘Ÿ','’…Ž‚€’œ','•‹…‘’“’œ','—“€’œ‘Ÿ');
   VAR
     I : INTEGER;
     FOUND : BOOLEAN;
BEGIN
  I := 0;
  REPEAT
    INC (I);
    FOUND := (SOME_TOKENS [I] = TOKEN);
  UNTIL FOUND OR (I = TOKMAX);
  MEANS_GENIT := FOUND;
END;

{ Does flection FLEX suit to CASe for header's CLASS? }
FUNCTION SUITED (FLEX : STR11;
        {======} CLASS : INTEGER;
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

{ Assigning general case for collocation
  numbered with NUM in group with header of CLASS }
PROCEDURE ENCODE_ITEM (CLASS : INTEGER;
         {===========} NUM : INTEGER);
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
        THEN TOK1 := COPY (TOKN, 1, L-1)
        ELSE TOK1 := TOKN;

{ Assigning GCAS for ZERO class HEADER } 
      IF (CLASS = 0) AND (GCAS = 0)
        THEN
          BEGIN
            IF MEANS_DATIV (TOK1)
              THEN 
                CASE ONLYDOT OF
                  0, 3 : GCAS := 2;
                  4 : GCAS := 3;
                END
            ELSE IF (MEANS_GENIT (TOK1) OR MEANS_GENIT0 (TOK1))
              THEN 
                CASE ONLYDOT OF
                  0, 4 : GCAS := 1;
                  3 : GCAS := 3;
                END
            ELSE IF MEANS_INSTR (TOK1)
              THEN
                CASE ONLYDOT OF
                  0, 3 : GCAS := 4;
                  4 : GCAS := 3;
                END
            ELSE GCAS := 3;
            DONE := TRUE;
            EXIT;
          END;

 { Assigning GCAS when noun class is FEMINine } 
      IF NOT DONE THEN
        BEGIN
          {IF SUITED (FLEX, CLASS, INS, GCAS)
            AND (FEMIN (CLASS,1) OR FEMIN (CLASS,2)) 
            AND (MEANS_INSTR (TOK1) OR (TOKN = 'ˆ„’ˆ1')) 
            THEN WRITELN (TOKN, BL, HEADER, BL, FLEX, BL, GCAS);}
 
          IF SUITED (FLEX, CLASS, INS, GCAS) 
            AND (FEMIN (CLASS,1) OR FEMIN (CLASS,2)) 
            AND (MEANS_INSTR (TOK1) OR (TOKN = 'ˆ„’ˆ1')) 
            THEN 
              BEGIN
                DONE := TRUE;
                EXIT;
              END
          ELSE IF FEMIN (CLASS,1) OR FEMIN (CLASS,2)
            THEN
              BEGIN
                IF (MEANS_DATIV (TOK1) OR MEANS_DATIV0 (TOK1)) 
                  AND (ONLYDOT = 3) AND SUITED (FLEX, CLASS, DAT, GCAS) 
                  THEN DONE := TRUE
                ELSE IF (MEANS_DATIV (TOK1) AND (ONLYDOT = 4)) 
                  OR MEANS_GENIT0 (TOK1) OR MEANS_GENIT (TOK1)
                  AND SUITED (FLEX, CLASS, GEN, GCAS) 
                  THEN DONE := TRUE
                ELSE IF SUITED (FLEX, CLASS, ACC, GCAS) 
                  THEN DONE := TRUE;
              END;
        END;
      
{ Assigning GCAS for other HEADER ("inanimate"?) } 
      IF NOT DONE AND (MEANS_GENIT0 (TOK1) OR MEANS_GENIT0 (TOK1)) 
        AND (ONLYDOT = 4) AND (ANIM0 <> YES)
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
        THEN WRITELN (FNAME, ' ERROR: Wrong flexion for CLASS ',
          CLASS, '=>', HEADER, BL, TOKN, ' ~', FLEX);
    END;
END;

{ Final case encoding for VALIDated noun }
PROCEDURE ENCODE_VALID (CLASS : INTEGER);
         {============}
   VAR
     I : INTEGER;
     DONE : BOOLEAN;

BEGIN
  INC (AMT0);
  INC (AMT);
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        IF FLEX = TILDE
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;

        IF (GCAS >= 8)
          THEN { Preposition <=> flection test }
            BEGIN
              IF (FINALS [CLASS, PREPOS [GCAS].CAS] <> FLEX)
                THEN WRITELN (FNAME, ' ERROR: Preposition-Flextion dismatch ',
                  HEADER, '=>', TOKN, BL, PREPOS [GCAS].PRP, ' ~', FLEX);
            END
          ELSE { Prepositionless ending test and coding }
            BEGIN
              DONE := FALSE;
              IF PART_POSSIBLE (HEADER)
                AND (COPY (TOKN, 1, 5) <> 'ˆ‡Œ…')
                AND (COPY (TOKN, 1, 4) <> '“„ˆ‚')
                AND (COPY (TOKN, 1, 4) <> 'Ž’‚…')
                AND (COPY (TOKN, 1, 8) <> 'Ž’ˆ‚Ž')
                AND (COPY (TOKN, 1, 8) <> '‘ŽŽ’‚…’‘')
                AND (COPY (TOKN, 1, 8) <> '‘Ž“’‘’‚')
                AND SUITED (FLEX, CLASS, PAR, GCAS)
                THEN DONE := TRUE;
              IF NOT DONE
                THEN ENCODE_ITEM (CLASS, I);
            END;
      END;
END;

FUNCTION THERE_IS_FLEX (FLEX : STR11;
        {=============} CLASS : INTEGER) : BOOLEAN;
BEGIN
  THERE_IS_FLEX := (FLEX = FINALS [CLASS, GEN])
    OR (FLEX = FINALS [CLASS, DAT])
    OR (FLEX = FINALS [CLASS, ACC])
    OR (FLEX = FINALS [CLASS, INS]);
END;

{ Has CLASS its ANIMCL analogue? }
FUNCTION CAN_BE_ANIMATED (CLASS : INTEGER;
        {===============} VAR ANIMCL : INTEGER) : BOOLEAN;
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

{ Has CLASS its DEANIMCL analogue? }
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

{ Delete comm¥nt in header TOK }
FUNCTION CLEANED (TOK : STR115) : STR115;
        {======}
  VAR 
    PQ : INTEGER; 
BEGIN
  PQ := POS ('<', TOK);
  IF PQ > 1
    THEN CLEANED := COPY (TOK, 1, PQ-1)
    ELSE CLEANED := TOK;
END;

{ Final case encoding for INVALidated noun }
PROCEDURE ENCODE_INVAL1 (VAR CLASS : INTEGER;
         {=============} NUMB : NUMBER;
                         GEND : GENDER;
                         ANIM : ANIMA);
  VAR
    ANIMCL, L0 : INTEGER;
    I : INTEGER;
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
        IF FLEX = TILDE
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;
        HERE_MASCULABLE := (CLASS = 41) OR (CLASS = 43)
          OR (CLASS = 45) OR (CLASS = 46) OR (CLASS = 28);

        IF (GCAS >= 8)
          THEN { Test of preposition-flection correspondence }
            BEGIN
              CAS0 := PREPOS [GCAS].CAS;
              HERE_OK := FINALS [CLASS, CAS0] = FLEX;
              HERE_ANIMABLE := NOT HERE_OK AND (ANIM = NO)
                AND (CAS0 = ACC) AND CBA;
              HERE_FEMINABLE := NOT HERE_OK AND (NUMB = PLUR)
                AND (CAS0 = GEN) AND ((FLEX = DUMMY) OR (FLEX = '‰'));
              HERE_ACCENTABLE := NOT HERE_OK AND (NUMB = SING)
                AND (CAS0 = INS) AND (FLEX [L0-1] = 'Ž');
              IF HERE_MASCULABLE
                THEN
                  CASE CAS0 OF
                    NOM, ACC : ;
                    GEN :
                      CASE CLASS OF
                        28 : HERE_MASCULABLE := (FLEX = '…‚');
                        ELSE HERE_MASCULABLE := (FLEX = 'Ž‚');
                      END;
                    DAT, INS, PRE :
                      CASE CLASS OF
                        28 : HERE_MASCULABLE := (FLEX = FINALS [CLASS, CAS0]);
                        41, 43 : HERE_MASCULABLE :=
                          ('Š'+FLEX = FINALS [CLASS, CAS0]);
                        45 : HERE_MASCULABLE :=
                          ('‰Š'+FLEX = FINALS [CLASS, CAS0]);
                        46 : HERE_MASCULABLE :=
                          ('œŠ'+FLEX = FINALS [CLASS, CAS0]);
                      END;
                  END;
              IF NOT (HERE_OK OR HERE_ANIMABLE OR HERE_FEMINABLE
                OR HERE_ACCENTABLE OR HERE_MASCULABLE)
                THEN WRITELN (FNAME, ' ERROR: Preposition-Flexion dismatch ',
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
                OR (L0 > 1) AND (FLEX [L0-1] = 'Ž'))
                AND (FLEX <> FINALS [CLASS, INS]);
              IF HERE_MASCULABLE
                THEN
                  CASE CLASS OF
                    28 : HERE_MASCULABLE := (FLEX = '…‚') OR (FLEX = 'ˆ')
                      OR (FLEX = 'ŸŒ') OR (FLEX = 'ŸŒˆ');
                    ELSE HERE_MASCULABLE :=
                      (FLEX = 'Ž‚') OR (FLEX = '€Œ') OR (FLEX = '€Œˆ') OR
                      (CLASS = 45) AND (FLEX = '‰Šˆ') OR
                      (CLASS = 46) AND (FLEX = 'œŠˆ') OR
                      ((CLASS = 41) OR (CLASS = 43)) AND (FLEX = 'Šˆ');
                  END;
              MASCULABLE := MASCULABLE AND HERE_MASCULABLE;
            END;
      END;

  IF OK
    THEN  { Initial class accepted }
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
                    AND (COPY (TOKN, 1, 5) <> 'ˆ‡Œ…')
                    AND (COPY (TOKN, 1, 4) <> '“„ˆ‚')
                    THEN DONE := TRUE;
                  IF NOT DONE
                    THEN ENCODE_ITEM (CLASS, I);
                END;
      END
  ELSE IF ANIMABLE
    THEN  { ANIMCL accepted }
      BEGIN
        INC (AMT12);
        INC (AMT);
        CLASS := ANIMCL;
        IF (PI = 0) AND (PH = 0) AND NOT DOUBLE_FL
          THEN writeln (OUT4, CLASS : 3, BL, CLEANED(headline));
        IF DOUBLE_FL AND CAN_BE_ANIMATED (SUBCL, ANSUBCL)
          THEN SUBCL := ANSUBCL;
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN ENCODE_ITEM (CLASS, I);
      END
  ELSE IF FEMINABLE
    THEN  { "FEMINATED" class accepted }
      BEGIN
{  writeln ('FEMINATED ', headline);}
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
          ELSE WRITELN (FNAME, ' ERROR: Cant feminize class ', CLASS, 
            ' for ', HEADLINE);
        IF (PI = 0) AND (PH = 0) AND NOT DOUBLE_FL
          THEN writeln (OUT4, CLASS : 3, BL, CLEANED(headline));
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN ENCODE_ITEM (CLASS, I);
      END
  ELSE IF MASCULABLE
    THEN  { "MASCULATED" class accepted }
      BEGIN
 { writeln ('MASCULATED ', headline);}
        INC (AMT14);
        INC (AMT);
        IF CLASS = 28
          THEN CLASS := 39
          ELSE CLASS := 37;
        IF (PI = 0) AND (PH = 0) AND NOT DOUBLE_FL
          THEN writeln (OUT4, CLASS : 3, BL, CLEANED(headline));
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            BEGIN
              IF COPY (FLEX, LENGTH(FLEX)-1, 2) = 'Šˆ'
                THEN FLEX := 'ˆ';
              IF GCAS = 0
                THEN ENCODE_ITEM (CLASS, I);
            END;
      END
  ELSE IF ACCENTABLE
    THEN  { "ACCENTUATED" CLASS ACCEPTED }
      BEGIN
{   writeln ('ACCENTUATED ', headline); }
        INC (AMT15);
        INC (AMT);
        IF (CLASS = 3) THEN CLASS := 1
        ELSE IF (CLASS = 4) THEN CLASS := 2
        ELSE IF (CLASS = 7) THEN CLASS := 6
        ELSE IF (CLASS = 9) THEN CLASS := 8
        ELSE IF (CLASS = 89) THEN CLASS := 87
        ELSE IF (CLASS = 96) THEN CLASS := 94
        ELSE IF (CLASS = 97) THEN CLASS := 95
        ELSE WRITELN (FNAME, ' ERROR: Cant accentuate class ', CLASS,
          ' for ', HEADLINE);
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN ENCODE_ITEM (CLASS, I);
      END
  ELSE WRITELN (FNAME, ' ERROR: Left undetermined group ', HEADLINE);
END;

PROCEDURE TEST_ENCODE (VAR CLASS : INTEGER;
         {===========} VAR ERROR : BOOLEAN);
  VAR
    I : INTEGER;
BEGIN
  ERROR := FALSE;
  IF CLASS = 0
    THEN
      BEGIN
        FOR I := 1 TO PARTAMT DO
          WITH PARTARR [I] DO
            IF GCAS = 0
              THEN GCAS := 3;       {‚›€‚ˆ’œ!}
        EXIT;
      END;
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        IF FLEX = TILDE
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;

        IF (GCAS >= 8)
          THEN ERROR := ERROR OR
            (FINALS [CLASS, PREPOS [GCAS].CAS] <> FLEX)
          ELSE ENCODE_ITEM (CLASS, I);
      END;
END;

PROCEDURE ENCODE_INVAL2 (VAR CLASS : INTEGER;
         {=============} NUMB : NUMBER;
                         GEND : GENDER;
                         ANIM : ANIMA);
  VAR
    ERROR : BOOLEAN;

BEGIN
  INC (AMT2);
  INC (AMT);
  ERROR := FALSE;

{writeln ('CORRECTED ', headline);}

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
             THEN WRITELN (FNAME, ' ERROR: Cannot correct CLASS 6/8 for ',
               HEADLINE);
         END
     ELSE IF (GEND = MASC)
       THEN
         BEGIN
           CLASS := 6;
           TEST_ENCODE (CLASS, ERROR);
           IF ERROR
             THEN WRITELN (FNAME, ' ERROR: Cannot override CLASS 6 for ',
               HEADLINE);
         END;
    9 :
     IF (NUMB = PLUR)
       THEN
         BEGIN
           CLASS := 12;
           TEST_ENCODE (CLASS, ERROR);
           IF ERROR
             THEN WRITELN (FNAME, ' ERROR: Cannot correct CLASS 9 for ',
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
          THEN WRITELN (FNAME, ' ERROR: Cannot correct CLASS 64 for ',
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
          THEN WRITELN (FNAME, ' ERROR: Cant correct class 68 for ',
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
          THEN WRITELN (FNAME, ' ERROR: Cant correct class 75 for ',
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
          THEN WRITELN (FNAME, ' ERROR: Cant correct class 77 for ',
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
          THEN WRITELN (FNAME, ' ERROR: Cant correct class 79 for ',
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
          THEN WRITELN (FNAME, ' ERROR: Cant correct class 118 for ',
            HEADLINE);
      END;
    ELSE WRITELN (FNAME, ' ERROR: Wrong agreement or class ', CLASS, ' for ',
      HEADLINE);
  END;
END;

{ Output group content to two output files }
PROCEDURE PARTOUT;
         {=======}
VAR
  CL2 : INTEGER;
  I : INTEGER;
  THEREIS0 : BOOLEAN;

BEGIN
  THEREIS0 := FALSE;
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR [I] DO
      BEGIN
        THEREIS0 := THEREIS0 OR (GCAS = NOGCAS);
        CL2 := 255;
        
        IF (SOBN = 200) 
          AND ((TOKN = '›’œ') OR (TOKN = 'Ž‘’€‚€’œ‘Ÿ') OR (TOKN = 'Ž‘’€’œ‘Ÿ')) 
          THEN
            BEGIN
              TOKN := COPY (TOKN,1,LENGTH(TOKN)) + BL + '‡€Œ“†…Œ';
              SOBN := 0;
              CL2 := 0;
            END
       ELSE IF (SOBN = 100) 
          AND ((TOKN = '‚›‰’ˆ1') OR (TOKN = '‚›•Ž„ˆ’œ1')) 
          THEN
            BEGIN
              TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + '‡€Œ“†';
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF (SOBN > 100) 
          THEN
            BEGIN
              IF (POS (TOKN[LENGTH(TOKN)], '123456') > 0)
                THEN TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + VERBTAIL [SOBN-100]
                ELSE TOKN := TOKN + BL + VERBTAIL [SOBN-100];
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF ((TOKN = '‚…‘’ˆ2') OR (TOKN = 'Ž‚…‘’ˆ') OR
          (TOKN = '—“‚‘’‚Ž‚€’œ') OR (TOKN = 'Ž—“‚‘’‚Ž‚€’œ') OR
          (TOKN = 'ŽŠ€‡€’œ2') OR (TOKN = 'ŽŠ€‡›‚€’œ2') OR
          (TOKN = 'Ž™“™€’œ') OR (TOKN = 'Ž™“’ˆ’œ') OR
          (TOKN = '‚›‘’€‚‹Ÿ’œ') OR (TOKN = '‚›‘’€‚ˆ’œ') OR 
          (TOKN = '‘’€‚ˆ’œ') OR (TOKN = 'Ž‘’€‚ˆ’œ2') OR 
          (TOKN = '‡€…ŠŽŒ…„Ž‚€’œ') OR (TOKN = '„…†€’œ') OR
          (TOKN = '… Ž€™€’œ') OR (TOKN = 'Ž…‡Ž€‘ˆ’œ') OR
          (TOKN = 'ŽŸ‚ˆ’œ') OR (TOKN = 'ŽŸ‚‹Ÿ’œ') OR 
          (TOKN = '‘„…†€’œ') OR (TOKN = '‘„…†ˆ‚€’œ')) 
          AND (SOBN = 1)
          THEN
            BEGIN
              IF (POS (TOKN[LENGTH(TOKN)], '123456') > 0)
                THEN TOKN := COPY (TOKN, 1, LENGTH(TOKN)-1) + BL + '‘…Ÿ'
                ELSE TOKN := TOKN + BL + '‘…Ÿ';
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF (TOKN = '…„‘’€‚‹Ÿ’œ2') AND (SOBN = 3)
          THEN
            BEGIN
              TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + '‘ŽŽ‰';
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF (TOKN = '…„‘’€‚‹Ÿ’œ2') AND (SOBN = 6)
          THEN
            BEGIN
              TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + 'ˆ‡ ‘…Ÿ';
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF ((TOKN = '…„‘’€‚‹Ÿ’œ1') OR (TOKN = '…„‘’€‚ˆ’œ1'))
          AND (SOBN = 2)
          THEN
            BEGIN
              TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + '‘……';
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF ((TOKN = '‡€Œ…Ž‚€’œ') OR (TOKN = 'Ÿ‚‹Ÿ’œ'))
          AND (SOBN = 3)
          THEN
            BEGIN
              TOKN := TOKN + BL + '‘ŽŽ‰';
              SOBN := 0;
              CL2 := 0;
            END
        ELSE IF ((TOKN = '€‘Ž‹€ƒ€’œ1') OR (TOKN = '€‘Ž‹Ž†ˆ’œ1'))
          AND (SOBN = 15)
          THEN
            BEGIN
              TOKN := COPY (TOKN,1,LENGTH(TOKN)-1) + BL + 'Š ‘……';
              SOBN := 0;
              CL2 := 0;
            END;
  { Output to file of links }
        IF (TOKN = '„……‚œŸ1') AND (GCAS = 0)
          THEN GCAS := 3;                          {forcing!}

        IF NEG
          THEN WRITE (OUT, NE);

        WRITELN (OUT, TOKN, BL : GAP - LENGTH(TOKN) - 3 * ORD (NEG) - 1, 
          SOBN : 3, ONLYDOT : 2, GCAS : 5, STY : 2, IDI : 2);  

{ ! SOBN field is widened from 2 to 3, since  only last digit 
    can be read out now by AFG program.        12.11.13, IAB ! }

{  2nd way to cope with is shifting output string 
   to the right by 2 bytes additionally: 
        WRITELN (OUT, TOKN, BL : 17 - LENGTH(TOKN) - 3 * ORD (NEG), 
          SOBN : 3, ONLYDOT : 2, GCAS : 5, STY : 2, IDI : 2);                                                            IAB ! }
          
        IF (GCAS >= 8) AND (GCAS <= MAXPREP29) 
           AND (POS(BL, TOKN) = 0) 
           AND (POS(BL, HEADLINE) = 0)
           AND (POS('-', HEADLINE) = 0)
           AND (POS('^', HEADLINE) = 0)
           THEN
             WITH CASESETS[GCAS] DO
               IF (NOT IN_TOP_32(PREPOS[GCAS].PRP) 
                    AND (EXAMQUAN < MINEXAMPL))
                  OR (IN_TOP_32(PREPOS[GCAS].PRP)
                    AND (EXAMQUAN < MAXEXAMPL) 
                    AND (ONLYDOT = 0))
                 THEN
                   BEGIN
{-----------------}                      
                     INC(EXAMQUAN);

                     QV := LENGTH(TOKN);
                     IF (POS(TOKN[QV],'123456') > 0)
                       THEN TRUNKV := COPY(TOKN, 1, QV-1)
                       ELSE TRUNKV := TOKN;
                     EXAMPLES[EXAMQUAN, 1] := TRUNKV;

                     PREPI := PREPOS[GCAS].PRP;
                     QP := LENGTH(PREPI);
                     IF (POS(PREPI[QP],'123456') > 0)
                       THEN TRUNKP := COPY(PREPI, 1, QP-1)
                       ELSE TRUNKP := PREPI;
                     CASTRING := TRUNKP;
                     
                     QS := POS('<', HEADLINE);
                     IF QS  > 0
                       THEN TRUNKS := COPY(HEADLINE, 1, QS-2)
                       ELSE TRUNKS := HEADLINE;
                     EXAMPLES[EXAMQUAN, 2] := TRUNKS;
                                   
                     INITSUBCL(TRUNKS, CLSI, VALI, NMBI, GNDI, ANMI);
                     
                     EXAMPLES2[EXAMQUAN] := TRUNKV + BL + TRUNKP + BL
                       + COPY(TRUNKS, 1, LENGTH(TRUNKS) - LENGTH(FINALS[CLSI,NOM]))
                       + FINALS[CLSI,PREPOS[GCAS].CAS]; 
{-----------------}                      
                   END; 

{!!!}   IF (GCAS = 0) 
          THEN GCAS := 3;
        IF GCAS < 8
          THEN INC(CAS_WO_PREP [GCAS]);

 { Output to vocabulary file }
        WRITE (OUT2, '2', VCLAS : 4, CL2 : 4, BL);       { IAB ! }
        IF NEG
          THEN WRITE (OUT2, NE);
        WRITELN (OUT2, TOKN);
     END;
  IF THEREIS0
    THEN WRITELN (FNAME, ' ERROR: Zero GENCLASS at ', HEADLINE);
END;

  { Is TOKEN a prepositional phrase? }
  FUNCTION HAS_ADV_PREPOS (TOKEN : STR115) : BOOLEAN;
          {==============}
    CONST
      PREPOSIT : ARRAY [1..36] OF STRING [10] =
        ('…‡','ŽŠ','Ž‹……',
        '‚','‚Ž','‚Ž’',{'‚‘…',}'‚‘…ƒŽ','‚‘‹…„‘’‚ˆ…',
        'ƒ„…','„‹Ÿ','„Ž','…™…','‡€',
        'Š€Š','ŠŽƒ„€','Š‘’€’ˆ','Š“„€',
        'Œ…†„“','€','ˆŠ€ŠŽ‰','ˆ—…ƒŽ',
        'Ž„ˆ','Ž’','Ž’Š“„€',
        'Ž','Ž„','Ž‘‹…','ˆ',
        '‘','‘Ž','‘Žƒ‹€‘Ž','’€Š','’ˆ',
        '•Ž’œ','—…ƒŽ','—’Ž');
    VAR
      I : INTEGER;
      FOUND : BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := COPY (TOKEN, 1, LENGTH(PREPOSIT [I])+1) 
        = PREPOSIT [I] + BL;
    UNTIL FOUND OR (I = 37);
    HAS_ADV_PREPOS := FOUND;
  END;

  { If TOKEN has adjectival ending, give its number }
PROCEDURE DEFINE_SUFS (TOKEN : STR115;
         {===========} VAR NUM : INTEGER);
  VAR
    I, L : INTEGER;
    FOUND : BOOLEAN;
    FLEX : STR11;
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


      { Can be TOKEN adjective-like? }
  FUNCTION MAYBE_ADJ (TOKEN : STR115;
          {=========} VAR GEND : GENDER) : BOOLEAN;
    VAR
      LAST : CHAR;
      L, FLEX_NUM : INTEGER;
      VAL : BOOLEAN;

BEGIN
  GEND := NONE;
  IF {(TOKEN = '19') OR (TOKEN = '20') OR (TOKEN = '21')   
    OR} (TOKEN = '^X^I^X') OR (TOKEN = '^X^X') 
    OR (TOKEN = '^X^I^I') OR (TOKEN = '^X^V^I^I^I') 
    OR (TOKEN = '^X^X^I') OR (TOKEN = '101-‰') 
    OR (TOKEN = '1945-‰') OR (TOKEN = '37-‰') 
    OR (TOKEN = '^’…’ˆ‰') OR (TOKEN = '’…’ˆ‰')  
    OR (TOKEN = '’Ž’') OR (TOKEN = '’Ž’') 
    OR (TOKEN = 'Œ€ŠŽ‚') OR (TOKEN = '•ˆ‘’Ž‚') 
    OR (TOKEN = '€ƒ…‹') {OR (TOKEN = '„€')}
    OR (TOKEN = 'Ž‹‚€') OR (TOKEN = '„“ƒ') 
    OR (TOKEN = '‘Š…†…’') OR (TOKEN = '‘‚…’') 
    OR (TOKEN = '‘ŽŠŽ‹') OR (TOKEN = '‘ˆ•') 
    OR (TOKEN = '…„') OR (TOKEN = 'Ž„') 
    OR (TOKEN = '…‘’') OR (TOKEN = '˜“’')     
    OR (TOKEN = '^ˆ—') OR (TOKEN = '^‘›') 
    OR (TOKEN = 'ŽŒ€‡€ˆŠ') OR (TOKEN = '^Š€‰ˆ‰')  
    OR (TOKEN = '^•ˆ‘’Ž‘') OR (TOKEN = '^Žƒ') 
    OR (TOKEN = '^ˆˆ‘“‘') OR (TOKEN = '^€€') 
    OR (TOKEN = '^ˆŽ‚') OR (TOKEN = '^€‹…Š‘€„') 
    OR (TOKEN = '^…’') OR (TOKEN = '^ˆŽ‘ˆ”') 
    OR (TOKEN = 'Š€‹ˆŠ€') OR (TOKEN = 'Œˆ˜Š€') 
    OR (TOKEN = 'Œˆ') OR (TOKEN = 'ŽŒ›‘…‹') 
    OR (TOKEN = 'Ž„ˆ')OR (TOKEN = '^–€œ')  
    OR (TOKEN = '‚…‘œ') OR (TOKEN = '›ˆ‰') 
    OR (TOKEN = '‚…•ˆ‰') OR (TOKEN = '–€œ') 
    OR (TOKEN = '^Š€‹') OR (TOKEN = '^‹…‚') 
    OR (TOKEN = '^„…„') OR (TOKEN = '^‘€‘') 
    OR (TOKEN = '^„…‚€') OR (TOKEN = '^‹ˆ‘€') 
    OR (TOKEN = '^„†Ž') OR (TOKEN = '^”ŽŒ€') 
    OR (TOKEN = '„…„“˜Š€') OR (TOKEN = 'Š€‹ˆŠ€') 
    OR (TOKEN = '„Ÿ„œŠ€') OR (TOKEN = '^„Ÿ„ž˜Š€') 
    OR (TOKEN = '„Ÿ„Ÿ') OR (TOKEN = '^„Ÿ„Ÿ')  
    OR (TOKEN = '^Œ€Š‘ˆŒ') OR (TOKEN = '^”…„…ˆŠ') 
    OR (TOKEN = 'ŽŒ›‘‹') OR (TOKEN = 'ŽŽŠ') 
    OR (TOKEN = '‘…‰') OR (TOKEN = '^ˆ‚€') 
    THEN BEGIN GEND := MASC; VAL := TRUE; END
  ELSE IF (TOKEN = '^‚€‘ˆ‹ˆ‘€') OR (TOKEN = '’€')
    OR (TOKEN = 'Š€€’—ˆŠŽ‚€') OR (TOKEN = '‘‚ŽŸ') 
    OR (TOKEN = '„“˜€') OR (TOKEN = '^–€ˆ–€') 
    OR (TOKEN = '‚€˜€') OR (TOKEN = '€˜€') 
    OR (TOKEN = '‚‘Ÿ') OR (TOKEN = '’œŒ€') 
    OR (TOKEN = 'Ž„€') 
    OR (TOKEN = '30-Ÿ') OR (TOKEN = '‡…Œ‹Ÿ') 
    THEN BEGIN GEND := FEM; VAL := TRUE; END
  ELSE IF (TOKEN = 'Š…‘€…‚Ž') OR (TOKEN = '—…’Ž‚Ž') 
    OR (TOKEN = '‚‘…') OR (TOKEN = '€˜…') 
    OR (TOKEN = '…’“Ž‚Ž') OR (TOKEN = '…—’Ž')
    OR (TOKEN = '„…‹Ž') OR (TOKEN = '„ˆ‚Ž') 
    OR (TOKEN = 'Ž„Ž') OR (TOKEN = 'Ž‹œ˜Ž…') 
    OR (TOKEN = '–€‘’‚Ž')OR (TOKEN = '—“—…‹Ž')
    OR (TOKEN = '—“„Ž') OR (TOKEN = 'Œ€‘‹Ž') 
    OR (TOKEN = '‘‹Ž‚Ž')  OR (TOKEN = '’Ž')
    OR (TOKEN = 'ŽƒŽŒŽ…') OR (TOKEN = '„ŽŽ…')
    THEN BEGIN GEND := NEUT; VAL := TRUE; END
  ELSE IF (TOKEN = '^ƒ…Š“‹…‘Ž‚›') OR (TOKEN = '…’ƒ…Ž‚›')
    OR (TOKEN = '—“—…‹€') OR (TOKEN = 'ˆŒ…€') 
    OR (TOKEN = 'Ž…') OR (TOKEN = '‘‚Žˆ')
    OR (TOKEN = '‚…•ˆ…') OR (TOKEN = 'Š€‰ˆ…') 
    OR (TOKEN = 'ƒŽŽ„€') OR (TOKEN = 'Ž„ˆ') 
    OR (TOKEN = '20-…') OR (TOKEN = '90-…')
    THEN BEGIN GEND := COMN; VAL := TRUE; END
  ELSE
  BEGIN
    DEFINE_SUFS (TOKEN, FLEX_NUM);
    IF (FLEX_NUM = 0) OR (FLEX_NUM > 16)
      THEN VAL := FALSE
      ELSE
        BEGIN
          VAL := TRUE;
          CASE FLEX_NUM OF
            1..4 :
              BEGIN
                GEND := MASC;
                L := LENGTH (TOKEN) - LENGTH (SUFS [FLEX_NUM]);
                LAST := TOKEN [L];
                VAL :=
{-›‰/-ˆ‰‘Ÿ }    (FLEX_NUM = 1) OR (FLEX_NUM = 4) OR
{-ˆ‰ }          (FLEX_NUM = 2) AND ((POS (LAST, AFFR + LABIA) > 0) OR
        (LAST = '') AND (POS (TOKEN [L-1], '‚„†ˆŒ’˜œ') > 0)) OR
{-Ž‰ }          (FLEX_NUM = 3) AND (POS (LAST, '‚ƒ„†Š‹Œ‘’•˜') > 0);
              END;
            5..7, 14 : GEND := FEM;
            8..10, 15 : GEND := NEUT;
            11..13, 16 :
              BEGIN
                GEND := COMN;
                L := LENGTH (TOKEN) - LENGTH (SUFS [FLEX_NUM]);
                LAST := TOKEN [L];
                VAL :=
{-›…/-ˆ…‘Ÿ }    (FLEX_NUM = 11) OR (FLEX_NUM = 13) OR
{-ˆ… }          (FLEX_NUM = 12) AND ((POS (LAST, AFFR + LABIA) > 0) OR
        (LAST = '') AND (POS (TOKEN [L-1], '‚„†ˆŒ’˜œ') > 0)) OR
{-œˆ }          (FLEX_NUM = 16) AND (POS (LAST, '‚†‡‹‘—') > 0);
              END;
          END;
        END;
  END;
  MAYBE_ADJ := VAL;
END;

{ Can be TOKEN as a noun agreed in gender ADJ_GEND? }
FUNCTION MEETS_GEND (TOKEN : STR115;
        {==========} ADJ_GEND : GENDER) : BOOLEAN;
  VAR
    CH : CHAR;
    FIN : STRING [2];
    L0 : INTEGER;

BEGIN
  L0 := LENGTH (TOKEN);
  CH := TOKEN [L0];
  FIN := COPY (TOKEN,L0-1,2);
  MEETS_GEND := FALSE;
  CASE ADJ_GEND OF
    MASC : MEETS_GEND := (POS (CH, '‚„‡‰‹Œ‘’”–œ'+ AFFR + LABIA) > 0);
    FEM  : MEETS_GEND := (POS (CH, '€Ÿœ') > 0) 
      AND (TOKEN <> '…‡€‡‹ˆ—ˆŸ') AND (TOKEN <> '…„‹Ž†…ˆŸ') 
      AND (TOKEN <> '‘Ž‘€') AND (TOKEN <> '‘€ŒŽ‹…’€');
    NEUT : MEETS_GEND := (POS (CH, 'Ž…') > 0) OR (FIN = 'ŒŸ');
    COMN : MEETS_GEND := (POS (CH, '›ˆ€Ÿ') > 0) 
             OR (FIN = '›…') OR (FIN = 'ˆ…') OR (FIN = '…');
  END;
END;

{ Is TOKEN a coordinated pair classified as SING MASC? }
FUNCTION SING_MASC_PAIR (TOKEN : STR115) : BOOLEAN;
        {==============}
CONST
  MAXP = 42;
  PAIRS : ARRAY [1..MAXP] OF STRING [30] =
('€‚’Ž ˆ ‚…„“™ˆ‰','€‚’Ž ˆ Ž„ž‘…',
'‚Ž ˆ €‡Ž‰ˆŠ','‚›ŒŽƒ€’…‹œ ˆ ˜Š“ˆŠ',
'ƒ‹€‚€ ˆ Ž‘Ž‚ŽŽ‹Ž†ˆŠ','ƒŽƒ ˆ Œ€ƒŽƒ',
'„…“’€’ ˆ ‘…€’Ž','„ˆ…Š’Ž ˆ €„Œˆˆ‘’€’Ž',
'„“ƒ ˆ …„ˆŽŒ›˜‹…ˆŠ','„“ƒ ˆ ŠŽ‹‹…ƒ€',
'„“ƒ ˆ €’…','„“ƒ ˆ Ž‘‹…„Ž‚€’…‹œ',
'„“ƒ ˆ ‘Ž€’ˆŠ','ˆ„…Ž‹Žƒ ˆ Ž€ƒ€„ˆ‘’',
'ˆ„…Ž‹Žƒ ˆ “ŠŽ‚Ž„ˆ’…‹œ','ˆ’…‹‹…Š’“€‹ ˆ “„ˆ’',
'ŠŽ“–ˆŽ… ˆ ‚‡Ÿ’Ž—ˆŠ','‹†…– ˆ Ž‹’“',
'‹†…– ˆ €‘ˆ‹œˆŠ','‹†…– ˆ ŽŒ€™ˆŠ',
'Œ€ƒ ˆ ‚Ž‹˜…ˆŠ','Œ€œŸŠ ˆ “ˆ‰–€',
'Œ“† ˆ Ž’…–','…“„€—ˆŠ ˆ ˆ—’Ž†…‘’‚Ž',
'ŽŒ€™ˆŠ ˆ ‹†…–','ˆŸ’…‹œ ˆ Ž‘‘',
'ˆŸ’…‹œ ˆ ŠŽ‹‹…ƒ€','‘‹“ƒ€ ˆ Ž“†…Ž‘…–',
'‘Ž…‘…„ˆŠ ˆ Ž“’—ˆŠ','‘Ž…ˆŠ ˆ „“ƒ',
'‘Ž’‘Œ… ˆ ŠŽŒŒ…’€’Ž','‘Ž’‘Œ… ˆ ˜Ž“Œ…',
'‘““ƒ ˆ Ž‚…‹ˆ’…‹œ','’Ž‚€ˆ™ ˆ „“ƒ',
'’“‘ ˆ ˆ—’Ž†…‘’‚Ž','“ˆ‰–€ ˆ €‘ˆ‹œˆŠ',
'“—…›‰ ˆ ŠŽ€‹…‘’Žˆ’…‹œ','“—…›‰ ˆ ˆ‘€’…‹œ',
'“—…›‰ ˆ “‹ˆ–ˆ‘’','“—…›‰ ˆ “’…˜…‘’‚…ˆŠ',
'–€œ ˆ Žƒ','—…ŒˆŽ ˆ …ŠŽ„‘Œ…');
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC(I); 
    FOUND := (TOKEN=PAIRS[I])
  UNTIL FOUND OR (I = MAXP); 
  SING_MASC_PAIR := FOUND;
END;

{ Is TOKEN a coordinated pair classified as SING FEM? }
FUNCTION SING_FEM_PAIR (TOKEN : STR115) : BOOLEAN;
        {=============}
CONST
  MAXP = 5;
  PAIRS : ARRAY [1..MAXP] OF STRING [30] =
('€“„ˆŽ- ˆ ‚ˆ„…Ž€€€’“€',
'€“„ˆŽ- ˆ ‚ˆ„…ŽŽ„“Š–ˆŸ',
'€“„ˆŽ- ˆ ‚ˆ„…Ž’…•ˆŠ€','†…€ ˆ „“ƒ',
'Ž‘…„‘’‚…Ž‘’œ ˆ …‡„€Ž‘’œ');
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC(I); 
    FOUND := (TOKEN=PAIRS[I])
  UNTIL FOUND OR (I = MAXP); 
  SING_FEM_PAIR := FOUND;
END;

{ Is TOKEN a coordinated pair classified as SING NEUT? }
FUNCTION SING_NEUT_PAIR (TOKEN : STR115) : BOOLEAN;
        {==============}
CONST
  MAXP = 3;
  PAIRS : ARRAY [1..MAXP] OF STRING [30] =
('‚‘… ˆ‹ˆ ˆ—…ƒŽ','ƒ€‡Ž- ˆ ‹…Š’Ž‘€†…ˆ…',
'‹…Š’Ž- ˆ ‚Ž„Ž‘€†…ˆ…');
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC(I); 
    FOUND := (TOKEN=PAIRS[I])
  UNTIL FOUND OR (I = MAXP); 
  SING_NEUT_PAIR := FOUND;
END;

{ Group coding and output od its header }
PROCEDURE OUT_HEADLINE;
         {============}
BEGIN
  { Coding of whole group with possible correction }
  INC(GRNUM);                                    { DM }
  IF VALID
    THEN ENCODE_VALID (CLASS)
    ELSE
      IF NG_CHANGE
        THEN ENCODE_INVAL2 (CLASS, NUMB0, GEND0, ANIM0)
        ELSE ENCODE_INVAL1 (CLASS, NUMB0, GEND0, ANIM0);
  IF (ANIM0 = YES) AND CAN_BE_ANIMATED (SUBCL, ANIMSUBCL)
    THEN SUBCL := ANIMSUBCL;

  { Output of group header to the file of headers }
  WRITE (OUT1, '1');
  IF (HEADLINE = '‚‘… ˆ ‚‘…')
    THEN WRITE (OUT1, '163' : 4, '20' : 4)
  ELSE IF (HEADLINE = '‚‘… ˆ Š€†„›‰')
    THEN WRITE (OUT1, '163' : 4, '61' : 4)
  ELSE IF (HEADLINE = '100 ƒ€ŒŒ')
    THEN WRITE (OUT1, '0' : 4, '228' : 4)
  ELSE IF (HEADLINE = '…‡Ž˜ˆŽ—›… Ž„‘Š€‡Šˆ')
    THEN WRITE (OUT1, '25' : 4, '41' : 4)
  ELSE IF (COPY(HEADLINE, LENGTH(HEADLINE)-4, 5) = '‘ŽŽ‰')
    THEN WRITE (OUT1, CLASS : 4, '329' : 4)
  ELSE IF THERE_IS_VLN OR THERE_IS_H
    THEN WRITE (OUT1, CLASS : 4, SUBCL : 4)
  ELSE IF DOUBLE_FL
    THEN
      BEGIN
        IF FL_REVERS
          THEN WRITE (OUT1, SUBCL : 4, CLASS : 4)
          ELSE WRITE (OUT1, CLASS : 4, SUBCL : 4)
       END
  ELSE WRITE (OUT1, CLASS : 4, '255' : 4);
  
  IF THERE_IS_I 
    THEN
      BEGIN  { Coordinated pair HEADLINE may be singular notion }
        IF SING_MASC_PAIR (HEADLINE)
          THEN BEGIN NUMB0 := SING; GEND0 := MASC; END
        ELSE IF SING_FEM_PAIR (HEADLINE)
          THEN BEGIN NUMB0 := SING; GEND0 := FEM; END
        ELSE IF SING_NEUT_PAIR (HEADLINE)
           THEN BEGIN NUMB0 := SING; GEND0 := NEUT; END
        ELSE BEGIN NUMB0 := PLUR; GEND0 := COMN; END;
      END;

  WRITELN (OUT1, ORD (NUMB0) : 2, ORD (GEND0) : 2, BL, HEADLINE);

  { Output of group header before its group }
  WRITELN (OUT, '+', GRNUM:6, BL, HEADLINE);     { DM }

  IF TOTAL <> AMT
    THEN
      BEGIN
        WRITELN (FNAME, ' ERROR: Something wrong in group ',
          HEADLINE);
        INC (AMT);
      END;
END;

{ Forced animization of single adjective-likes }
FUNCTION ANIMFRCED (TOK : STR115;
        {=========} N : INTEGER) : BOOLEAN;
  CONST            
  T1 : ARRAY [1..45] OF STRING [14] =
('…ƒ‹›…','‹€ƒŽŽ„›…','‹€†…›…','‹€’›…',
'‚…‘’Ž‚›…','‚Ž…›…','‚‘’…—›…','ƒ‹€‚›…','ƒŽ‹“›…',
'ˆ‡€›…','ˆŽ‘‹€‚›…','Š€’Ž†›…','ŠŽ‚Ž‰›…',
'Š…Ž‘’›…','‹…‚›…','‹…ˆ‚›…','Œˆ‹›…','…‚…›…',
'…ŠŽ’Ž›…','…ŽŒ€‹œ›…','Ž‘’€‹œ›…','Ž’‚€†›…',
'€’ˆ‰›…','ŽŠŽ‰›…','Ž‹Ž‚›…','Ž‘›‹œ›…','€‚›…',
'€‘‘‹€‹…›…','Ž„›…',
'‘‚ŽŽ„›…','‘…‡Ž›…','‘…Œ…‰›…','‘‹€›…','‘‹…›…',
'‘Š“›…','‘Œ…‹›…','‘Ž•€’›…','‘—€‘’‹ˆ‚›…',
'’“…Š“‹…‡›…','“‚…—›…','“Œ›…','“—…›…',
'•Ž‹Ž‘’›…','•€›…','—…›…');

T2 : ARRAY [1..10] OF STR11 =
('‹ˆ‡Šˆ…','‚—…€˜ˆ…','„“ƒˆ…','‹“—˜ˆ…','Œ€‹…œŠˆ…',
'…˜ˆ…','€Ž—ˆ…','“‘‘Šˆ…','‘“Œ€‘˜…„˜ˆ…','—“†ˆ…');

T3 : ARRAY [1..3] OF STR11 =
('‚Ž…›‰','‚‘’…—›‰','“—…›‰');

T4 : ARRAY [1..8] OF STR11 =
('‚…„“™ˆ‰','Œ€‹…œŠˆ‰','Ž‚…œŠˆ‰','Ž„ˆŽŠˆ‰','…˜ˆ‰',
'€Ž—ˆ‰','“‘‘Šˆ‰','‘“Œ€‘˜…„˜ˆ‰');

T5 : ARRAY [1..2] OF STR7 =
('„“ƒŽ‰','—“†Ž‰');

  VAR 
    I, L : INTEGER; 
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  CASE N OF
    1:L:=45; 2:L:=10; 3:L:=3; 4:L:=8; 5:L:=2;
  END;
  REPEAT
    INC(I);
    FOUND:=(N=1) AND (T1[I]+'›…'=TOK) 
      OR (N=2) AND (T2[I]+'ˆ…'=TOK)
      OR (N=3) AND (T3[I]+'›‰'=TOK) 
      OR (N=4) AND (T4[I]+'ˆ‰'=TOK) 
      OR (N=5) AND (T5[I]+'Ž‰'=TOK)
  UNTIL FOUND OR(I=L);
  ANIMFRCED:=FOUND;
END;

{ Plural NOUN groups with zero-class initial part }
FUNCTION ZERO_INIT (NOUN : STR115) : BOOLEAN;
        {=========}
CONST
  AMT = 7;
  ZERO_INITS : ARRAY [1..AMT] OF STRING [30] =
('‚…—Ž ‚—…€˜ˆ…','‚‹€‘’œ ˆŒ“™ˆ…','‘…… Ž„Ž›…',
'Ÿ„ŽŒ ‘’ŽŸ™ˆ…','„€‚Ž “Œ…˜ˆ…',
'Š€‰… ‹…‚›…','Š€‰… €‚›…');
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC(I); 
    FOUND := (NOUN = ZERO_INITS[I]);
  UNTIL FOUND OR (I = AMT); 
  ZERO_INIT := FOUND;
END;

                 { MAIN PROGRAM }
BEGIN 
     { Initiate file of superlong headers }
  VLN_ARRAY_SHORT;
     { Initiate extra-group variables }
  AMT0 := 0;
  AMT11 := 0;
  AMT12 := 0;
  AMT13 := 0;
  AMT14 := 0;
  AMT15 := 0;
  AMT2 := 0;
  AMT := 0;
  TOTAL := 0;
  GRNUM := 1;          { DM }

  FOR J := 8 TO MAXPREP29 DO
    PREPO [J] := 0;
  FOR J := 8 TO MAXPREP29 DO
    WITH CASESETS [J] DO
      FOR D := 0 TO MAXEXAMPL DO
        BEGIN
          EXAMPLES[D,1] := DUMMY;
          EXAMPLES[D,2] := DUMMY;
          EXAMPLES2[D] := DUMMY;
        END;

  FOR I := 1 TO 5 DO
    USECOUNT[I] := 0;
  FOR I := 0 TO 7 DO
    CAS_WO_PREP[I] := 0;
  FOR I := 0 TO 48 DO
    SOB_COUNT[I] := 0;

  FOR J := 8 TO MAXPREP29 DO
    WITH CASESETS [J] DO
      BEGIN
        PREPCODE := J;
        EXAMQUAN := 0;
        CASNAME := PREPOS[J].CAS;
        CASTRING := PREPOS[J].PRP;
        FOR I := 1 TO MAXEXAMPL DO
          BEGIN
            EXAMPLES [I,1] := DUMMY;
            EXAMPLES [I,2] := DUMMY;
          END;         
      END;


    {Open all files}
  ASSIGN (OUT1, 'OPFUNC_0.LST');
  REWRITE (OUT1);

  ASSIGN (OUT2, 'OPFUNC.COD');
  REWRITE (OUT2);

  ASSIGN (OUT3, 'PREPO.LST');
  REWRITE (OUT3);

  ASSIGN (OUT4, 'OPFUNC_A.LST');
  REWRITE (OUT4);

  ASSIGN (OUT5, 'MORFCASE.LST');
  REWRITE (OUT5);

  ASSIGN (OUT6, 'SOBCOUNT.LST');
  REWRITE (OUT6);

  ASSIGN (OUTF, 'VNEXAMPL.TXT');
  REWRITE (OUTF);

  ASSIGN (OUTG, 'VNEXAMPL2.TXT');
  REWRITE (OUTG);

  FOR J := 0 TO 77 DO
    BEGIN
      FNAME := 'OPFUNC' + CHR (ORD ('0') + J DIV 10) +
        CHR (ORD ('0') + J MOD 10) + '.TXT';
      ASSIGN (INP, FNAME);
      RESET (INP);

      FNAMEOUT := COPY (FNAME, 1, LENGTH (FNAME) - 3) + 'COD';
      ASSIGN (OUT, FNAMEOUT);
      REWRITE (OUT);

     { Initiate intra-group variables }
  PARTAMT := 0;
  HEADER := DUMMY;
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
  PREVHEAD := DUMMY;
  CURHEAD := DUMMY;

    { Main cycle }
  REPEAT
    READLN (INP, LINE);
    WHILE (COPY (LINE, 1 , 2) = '//') DO
      READLN (INP, LINE);

    INC (LINENUM);

    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN (FNAME, ' ERROR: Final blank in line ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;
    FIRST := LINE [1];
    IF (POS (FIRST, 'sqpm*') > 0) OR (POS(TAB,LINE) > 0)
      THEN
        BEGIN
          WRITELN (FNAME, ' ERROR: Wrong label or inner blanks in ', LINENUM);
          HALT;
        END;

    IF (FIRST <> BL) AND (FIRST <> '/') AND (FIRST <> '\') AND (POS('~', LINE) = 0)
      THEN   { Group header }
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
                THERE_IS_VLN := FALSE;
                HEADER := DUMMY;
                SUBHEAD := DUMMY;
              END;

          PK := POS('<', LINE);
          IF PK = 0
            THEN CURHEAD := LINE
            ELSE CURHEAD := COPY (LINE, 1, PK-2);
   
          PU := POS('_', CURHEAD); 
          IF PU > 0
            THEN CURHEAD[PU] := '-';
               
          IF (CURHEAD >= PREVHEAD) 
            THEN PREVHEAD := CURHEAD
            ELSE
              BEGIN
                WRITELN (FNAME, ' ERROR: Wrong header order for ', LINE);
                HALT;
              END;
          
          HEADLINE := LINE;
          THERE_IS_VLN := FALSE;
          IF AMONG_VLN_SHORTS(LINE, NUMB0, GEND0)
            THEN
              BEGIN
                CLASS := 0;     SUBCL := 0; 
                VALID := TRUE;  ANIM0 := IND;
                THERE_IS_VLN := TRUE;
                INC(TOTAL);
              END
          ELSE IF ZERO_INIT(LINE)
            THEN
              BEGIN
                CLASS := 0;
                PB := POS(BL, LINE);
                PART2 := COPY (LINE, PB+1, LENGTH(LINE)-PB); 
                INITSUBCL (PART2, SUBCL, VALID, NUMB0, GEND0, ANIM0);
                IF CAN_BE_ANIMATED (SUBCL, ANCL)
                  THEN SUBCL := ANCL;
                VALID := TRUE; 
                INC (TOTAL);
              END
          ELSE IF (LINE = '‘€Œ ‘ŽŽ‰')
            THEN
              BEGIN
                CLASS := 328;    SUBCL := 329;
                NUMB0 := SING;   GEND0 := MASC;
                ANIM0 := YES;    VALID := TRUE; 
                INC (TOTAL);
              END
          ELSE IF (LINE = '‘€Œ€ ‘ŽŽ‰')
            THEN
              BEGIN
                CLASS := 179;    SUBCL := 329;
                NUMB0 := SING;   GEND0 := FEM;
                ANIM0 := YES;    VALID := TRUE; 
                INC (TOTAL);
              END
          ELSE IF (LINE = '‘€ŒŽ ‘ŽŽ‰')
            THEN
              BEGIN
                CLASS := 183;    SUBCL := 329;
                NUMB0 := SING;   GEND0 := NEUT;
                ANIM0 := YES;    VALID := TRUE; 
                INC (TOTAL);
              END
          ELSE IF (LINE = '‘€Œˆ ‘ŽŽ‰')
            THEN
              BEGIN
                CLASS := 163;    SUBCL := 329;
                NUMB0 := PLUR;   GEND0 := COMN;
                ANIM0 := YES;    VALID := TRUE; 
                INC (TOTAL);
              END 
        {  ELSE IF (LINE = '„“ƒ „“ƒ€')
            THEN
              BEGIN
                CLASS := 0;      SUBCL := 321;       
                NUMB0 := PLUR;   GEND0 := COMN; 
                ANIM0 := YES;    VALID := TRUE; 
              END  }
            
            ELSE
begin
          P := POS ('1', LINE) + POS ('2', LINE) + POS ('3', LINE) +
            POS ('4', LINE) + POS ('5', LINE) + POS ('6', LINE);
          IF (P > 0) AND (POS ('<', LINE) > P)
            THEN LINE := COPY (LINE, 1, P-1);
          PI := POS (' ˆ ', LINE);
          PILI := POS (' ˆ‹ˆ ', LINE);
          IF PI > 1
            THEN
              BEGIN
                THERE_IS_I := TRUE;
                DOUBLE_FL := TRUE;
                FL_REVERS := TRUE;
                SUBHEAD := COPY (LINE, 1, PI-1);
                HEADER := COPY (LINE, PI+3, LENGTH(LINE)-PI-2);
              END
          ELSE IF PILI > 1
            THEN
              BEGIN
                THERE_IS_I := TRUE;
                DOUBLE_FL := TRUE;
                FL_REVERS := TRUE; 
                SUBHEAD := COPY (LINE, 1, PILI-1);
                HEADER := COPY (LINE, PILI+5, LENGTH(LINE)-PILI-4);
              END
            ELSE
              BEGIN
                PH := POS ('_', LINE);
                IF PH > 1
                  THEN
                    BEGIN
                      THERE_IS_H := TRUE;
                      HEADER := COPY (LINE, 1, PH - 1);
                      SUBHEAD := COPY (LINE, PH + 1, LENGTH (LINE) - PH);
                      HEADLINE [PH] := '-';
                    END
                  ELSE
                    BEGIN
                      P := POS (BL, LINE);
                      DOUBLE_FL := (P > 0) {AND (COPY (LINE, 1, P-1) <> '… ')};
                      IF NOT DOUBLE_FL
                        THEN HEADER := LINE
                        ELSE
                          BEGIN
                            TOK1 := COPY (LINE, 1, P-1);
                            TOK2 := COPY (LINE, P+1, LENGTH (LINE) - P);
                            IF (NOT HAS_ADV_PREPOS (TOK2) AND
                              MAYBE_ADJ (TOK1, ADJ_GEND) AND 
                              MEETS_GEND (TOK2, ADJ_GEND))
                              THEN
                                BEGIN
                                  HEADER := TOK2;
                                  SUBHEAD := TOK1;
                                  FL_REVERS := TRUE;
                                END
                              ELSE
                                BEGIN
                                  HEADER := TOK1;
                                  SUBHEAD := TOK2;
                                  FL_REVERS := FALSE;
                                END;
                          END;
                    END;
              END;

      { Classify deviant homonyms}
        IF (HEADER = 'ŽŠ‘…›') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 86;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '‚ˆ‘Šˆ') OR (HEADER = 'ˆŠˆ')) 
          AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 37;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = '‹€ˆ') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 0;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = 'Š‹ˆŠˆ') AND (LINE [LENGTH (HEADER) + 1] = '3')
          THEN
            BEGIN
              CLASS := 35;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '3');
            END
        ELSE IF (HEADER = 'ˆ‘Šˆ') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 41;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '^ƒ€Œˆ‹œ’Ž') OR (HEADER = '^ƒˆ‹…’')
          OR (HEADER = '^ˆŠŽ‹€…‚')) AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 1;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '€”ƒ€…–')
          AND (LINE [LENGTH (HEADER) + 1] = '3')
          THEN
            BEGIN
              CLASS := 96;     VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '3');
            END
        ELSE IF ((HEADER = '˜…‘’…Š€') OR (HEADER = 'Š“ˆ‹Š€')) 
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 8;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '‹€Œ€') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 6;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = 'ŽŠˆ') OR (HEADER = '‚œ…’€ŒŠˆ'))  
          AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 42;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = '…‹Šˆ') AND (LINE [LENGTH (HEADER) + 1] = '4')
          THEN
            BEGIN
              CLASS := 42;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '4');
            END
        ELSE IF ((HEADER = '‹€‘Šˆ') OR (HEADER = '”ˆŠˆ'))
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 42;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '“›')
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 176;    VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '‚‘…') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 163;    VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '„“ˆ€') AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 6;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := FEM;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = 'ƒ‹€‚€') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 6;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '˜…€') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 6;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := FEM;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = 'Ž‹’“˜Š€') {OR (HEADER = 'ŠŽ˜Š€')}
          AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 8;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = 'ƒ‹€‚›') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 91;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END                
        ELSE IF ((HEADER = '‚œ…’€ŒŠˆ') OR (HEADER = 'Žƒ€Šˆ'))
          AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 42;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = 'Ž›') AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 87;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF ((HEADER = 'Š‘Ž…’›') OR (HEADER = 'Ž›'))
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 90;      VALID := TRUE;
              NUMB0 := PLUR;    GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '’…•ˆŠˆ') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 35;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '‹…‚') OR (HEADER = 'ŠŽ‘’“Š’Ž')) 
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 1;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '“ƒŽ') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 187;        VALID := TRUE;
              NUMB0 := SING;       GEND0 := MASC;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = 'ŒŽ‹œ') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 68;         VALID := TRUE;
              NUMB0 := SING;       GEND0 := MASC;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = 'Ž‘Ž‹') OR (HEADER = '^‚‹€„ˆŒˆ')) 
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 1;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '‘’€ˆ€') OR (HEADER = '‘ŠŽ’ˆ€'))
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 6;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := MASC;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '‘Ž‹œ') AND (LINE [LENGTH (HEADER) + 1] = '3')
          THEN
            BEGIN
              CLASS := 0;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := NEUT;
              ANIM0 := IND;
              writeln (OUT4, CLASS : 3, BL, HEADER + '3');
            END
        ELSE IF ((HEADER = 'Šž—Šˆ') OR (HEADER = '‘’…‹Šˆ'))
          AND (LINE [LENGTH (HEADER) + 1] = '4')
          THEN
            BEGIN
              CLASS := 38;     VALID := TRUE;
              NUMB0 := PLUR;   GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '4');
            END
        ELSE IF ( (HEADER='€’…‹œ…') OR (HEADER='’…‹…€’…‹œ…')
          OR (HEADER='”Ž’Ž€’…‹œ…') OR (HEADER='ˆ’…‚œž')
          OR (HEADER='Š€‡ˆŽ') OR (HEADER='’€Š‘ˆ')
          OR (HEADER='žŽ') OR (HEADER='Š€”…')
          OR (HEADER='Œ…ž') OR (HEADER='”Ž’Ž') 
          OR (HEADER='˜Ž‘‘…') OR (HEADER='–“€Œˆ')
          OR (HEADER='Š‹ˆ˜…') OR (HEADER='˜Ž“')
          OR (HEADER='’€‹Ž') OR (HEADER='’€“') 
          OR (HEADER='€‚…ž') OR (HEADER='^ƒ^')
          OR (HEADER='€Ž') OR (HEADER='€‹œ’Ž')
          OR (HEADER='^^‚^Œ') OR (HEADER='‘“…^^‚^Œ')
          OR (HEADER='^^‹^‘') )
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 0;     VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = 'ŠŽ’€‹œ’Ž') 
          OR (HEADER = 'Œ…––Ž-‘Ž€Ž') 
          OR (HEADER = '‘Ž€Ž'))
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 0;      VALID := TRUE;
              NUMB0 := SING;   GEND0 := FEM;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = 'ŽŒ…‹Ž') OR (HEADER = '“Šˆ'))
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 0;     VALID := TRUE;
              NUMB0 := SING;  GEND0 := NEUT;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '^Œ^Š^‘')
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 0;     VALID := TRUE;
              NUMB0 := SING;  GEND0 := MASC;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '’€‹Ž')
          AND (LINE [LENGTH (HEADER) + 1] = '3')
          THEN
            BEGIN
              CLASS := 16;    VALID := TRUE;
              NUMB0 := SING;  GEND0 := NEUT;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '‡Œ…ˆ') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 40;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '‘€—Šˆ') OR (HEADER = '‘Ž‚Šˆ')) 
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 38;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = 'Ž…€') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 11;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '‚ˆ€') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 12;   VALID := TRUE;
              NUMB0 := PLUR; GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = 'ŠŽ‡‹›') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 204;   VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF (HEADER = '‹ˆ–€') AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 12;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = 'ŠŽŒ€') AND (LINE [LENGTH (HEADER) + 1] = '1')
          THEN
            BEGIN
              CLASS := 10;    VALID := TRUE;
              NUMB0 := PLUR;  GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER + '1');
            END
        ELSE IF (HEADER = 'ŽŠ“ƒ€') AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 8;     VALID := TRUE;
              NUMB0 := SING;  GEND0 := FEM;
              ANIM0 := IND;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '€Š€') OR (HEADER = '€Ž—Š€'))
          AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 8;    VALID := TRUE;
              NUMB0 := SING; GEND0 := MASC;
              ANIM0 := IND;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = '^ˆ‹') OR (HEADER = '^„Ž')) 
        AND (LINE [LENGTH (HEADER) + 1] = '2')
          THEN
            BEGIN
              CLASS := 2;    VALID := TRUE;
              NUMB0 := SING; GEND0 := MASC;
              ANIM0 := YES;
              writeln (OUT4, CLASS : 3, BL, HEADER + '2');
            END
        ELSE IF ((HEADER = 'ƒŽ‹Ž‚€') OR (HEADER = '†ˆ‹€'))
          AND (LINE [LENGTH(HEADER)+1] = '3')
          THEN
            BEGIN
              CLASS := 6;    VALID := TRUE;
              NUMB0 := SING; GEND0 := MASC;
              ANIM0 := IND;
              writeln (OUT4, CLASS : 3, BL, HEADER + '3');
            END
        ELSE IF (HEADER = 'Ž‹›') AND (LINE [LENGTH(HEADER)+1] = '3')
          THEN
            BEGIN
              CLASS := 90;   VALID := TRUE;
              NUMB0 := PLUR; GEND0 := COMN;
              ANIM0 := NO;
              writeln (OUT4, CLASS : 3, BL, HEADER+'3');
            END
        ELSE IF (HEADER = '^^€^„›')
          THEN
            BEGIN
              CLASS := 86;   VALID := TRUE;
              NUMB0 := PLUR; GEND0 := COMN;
              ANIM0 := NO;
            END
        ELSE IF (AMONG_NUMERALS(HEADER, ERC) = BIG1)
          THEN
            BEGIN
              NUMB0 := PLUR; GEND0 := COMN; 
              ANIM0 := YES; VALID := TRUE;
              IF (HEADER = '„‚Ž…') OR (HEADER = '’Ž…')
                THEN CLASS := 208
                ELSE CLASS := 207;
            END
        ELSE INITSUBCL (HEADER, CLASS, VALID, NUMB0, GEND0, ANIM0);

        SUBCL := 255;

{!}     IF THERE_IS_H
          THEN 
            BEGIN
              INITSUBCL (HEADER, CLASS, VALID, NUMB0, GEND0, ANIM0);
              INITSUBCL (SUBHEAD, SUBCL, SUBVAL, SUBNUMB,
                 SUBGEND, SUBANIM);  

              IF (HEADER = '‘’€€') AND (SUBHEAD = '—‹…')
                 THEN SUBCL := 2; 
              IF (HEADER = '‘’€›')
                THEN
                  BEGIN
                    CLASS := 91;
                    IF (SUBHEAD = '—‹…›')
                      THEN SUBCL := 87; 
                  END;
              IF (HEADER = 'ŠŽŒ€ˆˆ') AND (SUBHEAD = 'Ž‚€‰„…›')
                THEN SUBCL := 86;
              IF ((HEADER = 'ŠŽŒ€ˆŸ') AND (SUBHEAD = 'Ž‚€‰„…'))
                OR ((HEADER = '‘‹Ž‚Ž') AND (SUBHEAD = '€€‡ˆ’'))
                THEN SUBCL := 1;
              IF (HEADER = '€Š') AND (SUBHEAD = 'Š…„ˆ’Ž')
                 THEN SUBCL := 1; 
              IF (HEADER = '‡€‚Ž„') 
                AND ((SUBHEAD = 'ˆ‡ƒŽ’Ž‚ˆ’…‹œ') OR (SUBHEAD = 'Žˆ‡‚Ž„ˆ’…‹œ'))
                 THEN SUBCL := 68; 
              IF (HEADER = '‡€‚Ž„›') 
                AND ((SUBHEAD = 'ˆ‡ƒŽ’Ž‚ˆ’…‹ˆ') OR (SUBHEAD = 'Žˆ‡‚Ž„ˆ’…‹ˆ'))
                 THEN SUBCL := 30; 
              IF (HEADER = 'ƒŽŽ„') AND (SUBHEAD = 'ƒ…Ž‰')
                 THEN SUBCL := 59; 
              IF (HEADER = '€Ž—ˆ…') AND (SUBHEAD = 'Š“‹ˆ')
                 THEN BEGIN CLASS := 27; SUBCL := 0; END;

              IF (SUBHEAD = 'ŠŽ…‘Ž„…’') OR (SUBHEAD = 'ŠŽ…‘Ž„…’›')
                OR (SUBHEAD = '€Š’ˆŠ') OR (SUBHEAD = '€Š’ˆŠˆ')
                OR (SUBHEAD = '“Ž…‡ˆ–›') OR (SUBHEAD = '…‡ˆ„…’')
                THEN { Both parts are to be animated }
                  BEGIN 
                    IF CAN_BE_ANIMATED (CLASS, ANCL) THEN CLASS := ANCL;
                    IF CAN_BE_ANIMATED (SUBCL, ANCL) THEN SUBCL := ANCL;
                  END;
 
              IF (HEADER = '‹ˆ–€') OR (SUBHEAD = '…‡ˆ„…’›')
                 THEN BEGIN CLASS := 146; SUBCL := 87; END;

              IF (HEADER = '€Ž—ˆ‰') AND (SUBHEAD = '‘’Žˆ’…‹œ')
                 THEN BEGIN CLASS := 62; SUBCL := 69; END;
 
              IF (SUBHEAD = '’Ž') OR (SUBHEAD = 'ƒˆ‹œ') 
                THEN SUBCL := 0;
            

             { IF ((TOK1 = '„‚Ž…') OR (TOK1 = '’Ž…'))
                   AND (TOK2 = '€…‰')
                THEN
                  BEGIN
                    NUMB0 := PLUR; GEND0 := COMN; ANIM := YES;
                    SUBCL := 208;  CLASS := 233;
                    EXIT;
                  END;
              
              IF ((TOK1 = '—…’‚…Ž') OR (TOK1 = 'Ÿ’…Ž'))
                   AND (TOK2 = '€…‰')
                THEN
                  BEGIN
                    NUMB0 := PLUR; GEND0 := COMN; ANIM := YES;
                    SUBCL := 207;  CLASS := 233;
                    EXIT;
                  END;  }
            END;

        IF DOUBLE_FL
          THEN
            BEGIN
              IF FL_REVERS
                THEN 
                  BEGIN
                    IF (TOK2 = 'ƒŽ„›') AND 
                     ( (TOK1 = 'ŒŽƒˆ…') OR (TOK1 = '„Ž‹ƒˆ…') 
                     OR (TOK1 = '‹ˆ†€‰˜ˆ…') OR (TOK1 = '€ˆ…')
                     OR (TOK1 = '…„›„“™ˆ…') OR (TOK1 = '‘‹…„“ž™ˆ…') 
                     OR (TOK1 = 'Ž‘‹…„“ž™ˆ…') 
                     OR (TOK1 = '‹“—˜ˆ…') OR (TOK1 = 'Ž‘‹…„ˆ…') )
                      THEN
                        BEGIN
                          SUBCL := 118;   CLASS := 287;
                          VALID := TRUE;  NUMB0 := PLUR;
                          GEND0 := COMN;  ANIM0 := NO;
                       END
                    ELSE IF (TOK2 = 'ƒŽ„›') 
                      AND ( (TOK1 = '‡…‹›…') OR (TOK1 = '‚Ž…›…') 
                      OR (TOK1 = 'Ž’…Ÿ›…')OR (TOK1 = 'ŽŠ‹Ÿ’›…') 
                      OR (TOK1 = 'Ž˜‹›…') OR (TOK1 = 'Ž†ˆ’›…') ) 
                      THEN 
                        BEGIN 
                          SUBCL := 25;    CLASS := 287; 
                          VALID := TRUE;  NUMB0 := PLUR;
                          GEND0 := COMN;  ANIM0 := NO;
                        END
                    ELSE IF (TOK2 = 'ƒŽ„›') AND (TOK1 = '‘‚Žˆ') 
                      THEN 
                        BEGIN 
                          SUBCL := 169;   CLASS := 287; 
                          VALID := TRUE;  NUMB0 := PLUR;
                          GEND0 := COMN;  ANIM0 := NO;
                        END
                    ELSE IF (TOK1 = 'Ž„') AND (TOK2 = '‚Ž‰‘Š')
                      THEN
                        BEGIN
                          SUBCL := 1;      CLASS := 0;
                          VALID := TRUE;   NUMB0 := SING;
                          GEND0 := MASC;   ANIM0 := NO;
                        END
                   ELSE IF (TOK1 = '‹€ƒŽŽ‹“—ˆ…') AND (TOK2 = '—…‹Ž‚…Š€')
                     THEN
                       BEGIN
                         SUBCL := 17;     CLASS := 0;
                         VALID := TRUE;   NUMB0 := SING;
                         GEND0 := NEUT;   ANIM0 := NO;
                       END
                 {   ELSE IF ((TOK1 = '2') OR (TOK1 = '3') OR (TOK1 = '4'))
                      AND (TOK2 = 'Œƒ/‘“’')
                      THEN
                        BEGIN
                          SUBCL := 0;      CLASS := 0;
                          VALID := TRUE;   NUMB0 := SING;
                          GEND0 := NEUT;   ANIM0 := NO;
                        END  }
                    ELSE IF (TOK1 = '^…‹›‰') AND (TOK2 = '„ŽŒ')
                      THEN
                        BEGIN
                          SUBCL := 119;    CLASS := 1;
                          VALID := TRUE;   NUMB0 := SING;
                          GEND0 := MASC;   ANIM0 := NO;
                        END
                     ELSE IF (TOK1 = 'ŒˆŽ‚›…') AND (TOK2 = '€Š’ˆŠˆ') 
                       THEN 
                         BEGIN 
                           SUBCL := 25;    CLASS := 35; 
                           VALID := TRUE;  NUMB0 := PLUR;
                           GEND0 := COMN;  ANIM0 := NO;
                         END
                     ELSE IF (TOK1 = '‚ˆ’›…') AND (TOK2 = '€›') 
                       THEN 
                         BEGIN 
                           SUBCL := 25;    CLASS := 90; 
                           VALID := TRUE;  NUMB0 := PLUR;
                           GEND0 := COMN;  ANIM0 := NO;
                         END
                     ELSE IF (TOK1 = '‚‘…') AND (TOK2 = '†…‹€ž™ˆ…') 
                       THEN 
                         BEGIN 
                           SUBCL := 163;   CLASS := 27; 
                           VALID := TRUE;  NUMB0 := PLUR;
                           GEND0 := COMN;  ANIM0 := YES;
                         END
                     ELSE IF (TOK1 = '”€‰‹Ž‚›…') AND (TOK2 = 'Œ……„†…›') 
                        THEN 
                          BEGIN 
                            SUBCL := 25;    CLASS := 86; 
                            VALID := TRUE;  NUMB0 := PLUR;
                            GEND0 := COMN;  ANIM0 := NO;
                          END
                    ELSE IF (TOK1 = '”€‰‹Ž‚›‰') AND (TOK2 = 'Œ……„†…') 
                      THEN 
                        BEGIN 
                          SUBCL := 119;   CLASS := 1; 
                          VALID := TRUE;  NUMB0 := SING;
                          GEND0 := MASC;  ANIM0 := NO;
                        END
                    ELSE IF (TOK1 = '“€‚‹Ÿž™ˆ…') AND (TOK2 = 'ŠŽŒ€ˆˆ')
                      THEN
                        BEGIN
                           SUBCL := 118;   CLASS := 28;   
                           VALID := TRUE;  NUMB0 := PLUR;
                           GEND0 := COMN;  ANIM0 := NO;
                        END
                    ELSE IF (TOK1 = '•Ž‡Ÿ‰‘’‚“ž™ˆ…') AND (TOK2 = '‘“š…Š’›')
                      THEN
                        BEGIN
                           SUBCL := 27;    CLASS := 87;   
                           VALID := TRUE;  NUMB0 := PLUR;
                           GEND0 := COMN;  ANIM0 := NO;
                        END
                    ELSE IF (TOK1 = '’“„Ÿ™ˆ…‘Ÿ') AND (TOK2 = 'Œ€‘‘›')
                      THEN
                        BEGIN
                          SUBCL := 199;    CLASS := 90;
                          VALID := TRUE;   NUMB0 := PLUR;
                          GEND0 := COMN;   ANIM0 := NO;
                        END 
                   ELSE IF ((TOK1 = '‚‹ˆŸ’…‹œ›…') OR (TOK1 = 'Ž’‚…’‘’‚…›…')) 
                     AND (TOK2 = '‹ˆ–€')
                     THEN
                        BEGIN
                          SUBCL := 26;    CLASS := 146;
                          VALID := TRUE;   NUMB0 := PLUR;
                          GEND0 := COMN;   ANIM0 := YES;
                      END 
                   ELSE IF (TOK2 = '“—…›…') AND 
                     ((TOK1 = 'ŒŽ‹Ž„›…') OR (TOK1 = 'ˆŽ‘’€›…'))
                      THEN
                        BEGIN
                          SUBCL := 26;    CLASS := 26;
                          VALID := TRUE;  NUMB0 := PLUR;
                          GEND0 := COMN;  ANIM0 := YES;
                       END
                    ELSE IF (TOK1 = '^€€')
                      THEN
                        BEGIN
                          SUBCL := 6;     CLASS := 128;
                          VALID := TRUE;  NUMB0 := SING;
                          GEND0 := MASC;  ANIM0 := YES;
                        END
                    ELSE INITSUBCL (SUBHEAD, SUBCL, SUBVAL, 
                      SUBNUMB, SUBGEND, SUBANIM);
                  END
              ELSE IF IS_DAY_NUM (TOK1) AND IS_MONTH_NAME (TOK2)
                THEN          
                  BEGIN 
                    CLASS := 0; SUBCL := 0;
                    NUMB0 := SING; GEND0 := NEUT; 
                  END
              ELSE IF (AMONG_NUMERALS(TOK1, ERC) = BIG1) AND (ERC = 0) AND
                (  (TOK2 = '€Œ…') OR (TOK2 = 'Œˆ‹‹ˆ€Œ…') OR (TOK2 = 'ŒˆŠŽ€Œ…')
                OR (TOK2 = '€‰’')  OR (TOK2 = 'Šˆ‹Ž€‰’')  OR (TOK2 = 'Œ…ƒ€€‰’') 
                OR (TOK2 = 'ˆ’')   OR (TOK2 = 'Šˆ‹Žˆ’')   OR (TOK2 = 'Œ…ƒ€ˆ’')
                OR (TOK2 = '‚€’’')  OR (TOK2 = 'Šˆ‹Ž‚€’’')  OR (TOK2 = 'Œ…ƒ€‚€’’') 
                OR (TOK2 = '‚Ž‹œ’') OR (TOK2 = 'Šˆ‹Ž‚Ž‹œ’')
                OR (TOK2 = 'ƒ€ŒŒ') OR (TOK2 = 'Šˆ‹Žƒ€ŒŒ') OR (TOK2 = 'Œˆ‹‹ˆƒ€ŒŒ')
                OR (TOK2 = 'ŽŒ')    OR (TOK2 = 'Šˆ‹ŽŽŒ')    OR (TOK2 = 'Œ…ƒŽŒ') )
                THEN
                  BEGIN
                    CLASS := 0; SUBCL := 228;
                    NUMB0 := PLUR; GEND0 := COMN; 
                  END
              ELSE IF (TOK1 = '„“ƒ') AND (TOK2 = '„“ƒ€')
                THEN
                  BEGIN
                    CLASS := 0;    SUBCL := 321;       
                    NUMB0 := PLUR; GEND0 := COMN; 
                  END  
              ELSE IF (AMONG_NUMERALS(TOK1, ERC) = BIG1)
                THEN
                  IF (TOK2 = '€…‰')
                    THEN
                      BEGIN
                        NUMB0 := PLUR; GEND0 := COMN; 
                        ANIM := YES;   SUBCL := 233;
                        IF ((TOK1 = '„‚Ž…') OR (TOK1 = '’Ž…'))
                          THEN CLASS := 208
                        ELSE IF ((TOK1 = '—…’‚…Ž') OR (TOK1 = 'Ÿ’…Ž'))
                          THEN CLASS := 207
                        ELSE 
                          BEGIN
                            WRITELN ('ERROR: Correct the number of €…‰');
                            HALT;
                          END;
                      END
                 ELSE
                   BEGIN
                     NUMB0 := SING; GEND0 := NEUT;
                     INITSUBCL (TOK2, SUBCL, VALID, NUMB0, GEND0, ANIM);
                     IF ((SUBCL = 258) OR (SUBCL =228) OR (SUBCL =229) OR (SUBCL =233)) 
                       AND (ANIM = NO)
                       THEN
                         IF (TOK1 = '„‚Ž…') OR (TOK1 = '’Ž…')
                           THEN CLASS := 305
                           ELSE CLASS := 289
                     ELSE IF ((SUBCL = 258) OR (SUBCL =227) OR (SUBCL =228) 
                       OR (SUBCL =229) OR (SUBCL =284) OR (SUBCL =233) 
                       OR (SUBCL =239) OR (SUBCL =259) OR (SUBCL =306) OR (SUBCL =307)) 
                       AND (ANIM = YES)
                       THEN  
                         IF (TOK1 = '„‚Ž…') OR (TOK1 = '’Ž…')
                           THEN CLASS := 208
                           ELSE CLASS := 207;
                   END
              ELSE IF (AMONG_NUMERALS(TOK2, ERC) = BIG1)
                THEN
                  BEGIN
                    NUMB0 := PLUR; GEND0 := COMN; ANIM := YES;
                    IF (TOK2 = '„‚Ž…') OR (TOK2 = '’Ž…')
                      THEN SUBCL := 208
                      ELSE SUBCL := 207;
                    IF (TOK1 = '‚‘…')
                      OR (TOK1 = '€˜ˆ') OR (TOK1 = '’ˆ') 
                      OR (TOK1 = '‘‚Žˆ') OR (TOK1 = '’…')
                      THEN CLASS := 163
                    ELSE IF (COPY (TOK1, LENGTH(TOK1)-1, 2) = '›…')
                      THEN CLASS := 26
                    ELSE IF (COPY (TOK1, LENGTH(TOK1)-1, 2) = 'ˆ…')
                      THEN CLASS := 27
                    ELSE WRITELN ('ERROR: Collocation uncodable');
                  END
              
           
              ELSE IF (AMONG_NUMERALS(TOK1, ERC) = BIG2) 
                THEN
                  BEGIN
                    NUMB0 := SING; GEND0 := NEUT;
                    IF (ERC = 0)
                      THEN
                        BEGIN
                          CLASS := 0;
                          IF ( (TOK2 = '€Œ…') OR (TOK2 = 'Œˆ‹‹ˆ€Œ…') 
                              OR (TOK2 = 'ŒˆŠŽ€Œ…')
                            OR (TOK2 = '€‰’') OR (TOK2 = 'Šˆ‹Ž€‰’')
                              OR (TOK2 = 'Œ…ƒ€€‰’') 
                            OR (TOK2 = 'ˆ’') OR (TOK2 = 'Šˆ‹Žˆ’')   
                              OR (TOK2 = 'Œ…ƒ€ˆ’')
                            OR (TOK2 = '‚€’’')  OR (TOK2 = 'Šˆ‹Ž‚€’’')  
                              OR (TOK2 = 'Œ…ƒ€‚€’’') 
                            OR (TOK2 = '‚Ž‹œ’') OR (TOK2 = 'Šˆ‹Ž‚Ž‹œ’')
                            OR (TOK2 = 'ƒ€ŒŒ') OR (TOK2 = 'Šˆ‹Žƒ€ŒŒ') 
                              OR (TOK2 = 'Œˆ‹‹ˆƒ€ŒŒ')
                            OR (TOK2 = 'ŽŒ') OR (TOK2 = 'Šˆ‹ŽŽŒ') 
                              OR (TOK2 = 'Œ…ƒŽŒ') )
                            THEN
                              BEGIN 
                                SUBCL := 228;
                                NUMB0 := PLUR; GEND0 := COMN; 
                              END
                            ELSE INITSUBCL (TOK1, CLASS, VALID, NUMB, GEND, ANIM);
                        END;
                    IF (TOK2 = '‹…’')   
                      THEN SUBCL := 238          { <Ÿ’œ/30> ‹…’ }
                    ELSE IF (TOK2 = 'Š€‹Žˆ‰') OR (TOK2 = '‘…ˆ‰') 
                      OR (TOK2 = 'ŠŽˆ‰') OR (TOK2 = 'Ž–ˆ‰') 
                      OR (TOK2 = '”€Œˆ‹ˆ‰')  
                      THEN SUBCL := 304          { <200> Š€‹Žˆ‰ }
                    ELSE IF (TOK2 = 'Š€…‹œ') OR (TOK2 = '‡…Œ…‹œ')  
                      OR (TOK2 ='ŠŽ‚…‹œ') OR (TOK2 = '…’…‹œ') 
                      THEN SUBCL := 322     { <„…‘Ÿ’œ> Š€…‹œ/‡…Œ…‹œ }
                    ELSE IF (TOK2 = '…„…‹œ')    
                      THEN SUBCL := 270          { <Ÿ’œ> …„…‹œ }
                    ELSE IF (TOK2 = '—…‹Ž‚…Š') OR (TOK2 = '€‡') 
                      OR (TOK2 = 'Œˆ“’') OR (TOK2 = '„…‹') 
                      THEN SUBCL := 228
                    ELSE IF (TOK2 = '‚…—…€') OR (TOK2 = '“’€') 
                      OR ((TOK1 = '12') OR (TOK1 = '„‚…€„–€’œ')) 
                      AND (TOK2 = 'Ž—ˆ')
                      THEN SUBCL := 0
                      ELSE INITSUBCL (TOK2, SUBCL, VALID, 
                        NUMB, GEND, ANIM0);
                  END
              ELSE IF (AMONG_NUMERALS(TOK1, ERC) = SMALL) 
                THEN
                  BEGIN
                    NUMB0 := PLUR; GEND0 := COMN;
                    IF ERC = 0
                      THEN CLASS := 0
                      ELSE INITSUBCL (TOK1, CLASS, VALID, 
                        NUMB0, GEND0, ANIM0);
                    
                    IF (TOK2 = 'ƒŽ„€')          
                      THEN SUBCL := 237
                    ELSE IF (TOK2 = 'Š‹ˆŠ€')
                      THEN SUBCL := 10
                    ELSE INITSUBCL (TOK2, SUBCL, VALID, 
                        NUMB, GEND, ANIM0);
                    
                    IF (ERC > 0) AND (ANIM0 = YES) 
                      AND CAN_BE_ANIMATED (CLASS, ANCL)
                      THEN CLASS := ANCL;
                   END 
              ELSE IF (TOK1 = '€Šˆ') AND (TOK2 = '„€›•')
                THEN
                  BEGIN
                    SUBCL := 0;      CLASS := 37;
                    VALID := TRUE;   NUMB0 := PLUR;
                    GEND0 := COMN;   ANIM0 := NO;
                  END
              ELSE IF (TOK1 = '‘“’ˆŠ') AND (TOK2 = '†ˆ‡ˆ')
                THEN
                  BEGIN
                    SUBCL := 0;      CLASS := 2;
                    VALID := TRUE;   NUMB0 := SING;
                    GEND0 := MASC;   ANIM0 := YES;
                  END
              ELSE IF (TOK1 = '…‚…‘’œ') AND (TOK2 = 'Š’Ž')
                THEN
                  BEGIN
                    SUBCL := 150;    CLASS := 0;
                    VALID := TRUE;   NUMB0 := SING;
                    GEND0 := MASC;   ANIM0 := YES;
                  END
             ELSE IF (TOK1 = '…‚…‘’œ') AND (TOK2 = '—’Ž')
                THEN
                  BEGIN
                    SUBCL := 151;    CLASS := 0;
                    VALID := TRUE;   NUMB0 := SING;
                    GEND0 := NEUT;   ANIM0 := NO;
                  END
             ELSE IF (TOK1 = '‚‘…') AND (TOK2 = 'ˆ ‚‘…') 
                  THEN 
                    BEGIN 
                      CLASS := 20;    SUBCL := 163;   
                      VALID := TRUE;  NUMB0 := PLUR;
                      GEND0 := COMN;  ANIM0 := YES;
                    END  
             ELSE IF (TOK1 = '‚‘…') 
                AND ((TOK2 = '€‡Ž‚ˆ„Ž‘’ˆ') OR (TOK2 = 'Ž„ŽŽ‘’ˆ') 
                  OR (TOK2 = '„ˆ') OR (TOK2 = '„…’€‹ˆ'))
                THEN
                  BEGIN
                    CLASS := 169;   SUBCL := 30;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := NO;
                  END
              ELSE IF (TOK1 = '‚‘…') 
                AND ((TOK2 = '‘’ŽŽ›') OR (TOK2 = 'Œ…›') 
                  OR (TOK2 = '‘”…›'))
                THEN
                  BEGIN
                    CLASS := 169;   SUBCL := 90;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := NO;
                  END
              ELSE IF (TOK1 = '‚‘…') AND (TOK2 = '‹ž„ˆ')
                THEN
                  BEGIN
                    CLASS := 163;   SUBCL := 32;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := YES;
                  END
              ELSE IF (TOK1 = '€˜…') AND (TOK2 = '‚‘…')
                THEN
                  BEGIN
                    CLASS := 162;   SUBCL := 20;
                    VALID := TRUE;  NUMB0 := SING;
                    GEND0 := NEUT;  ANIM0 := NO;
                  END
              ELSE IF (TOK1 = '‚‘…') AND (TOK2 = '‘‹“—€ˆ')
                THEN
                  BEGIN
                    CLASS := 169;   SUBCL := 39;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := NO;
                  END
              ELSE IF (TOK1 = '‚‘…') AND (TOK2 = '‚…Œ…€') 
                THEN 
                  BEGIN 
                    CLASS := 169;   SUBCL := 12; 
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := NO;
                 END
              ELSE IF (TOK1 = '’…’œˆ') AND (TOK2 = '‹ˆ–€')
                THEN
                  BEGIN
                    CLASS := 163;   SUBCL := 146;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := YES;
                  END 
             { ELSE IF ((TOK1 = '‚‹ˆŸ’…‹œ›…') OR (TOK1 = 'Ž’‚…’‘’‚…›…')) 
                AND (TOK2 = '‹ˆ–€')
                THEN
                  BEGIN
                    CLASS := 26;    SUBCL := 146;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := YES;
                  END }
              ELSE IF (TOK1 = 'ƒ‹€‚›') AND (TOK2 = '€‚ˆ’…‹œ‘’‚')
                THEN
                  BEGIN
                    CLASS := 91;    SUBCL := 0;
                    VALID := TRUE;  NUMB0 := PLUR;
                    GEND0 := COMN;  ANIM0 := YES;
                  END
              ELSE SUBCL := 0;
            END;
        INC (TOTAL);
      END
end
      ELSE           { Collocation }
        IF LINE [3] = TILDE
          THEN   { Subject agreed against NUMB and GEND? }
            BEGIN
              VERB := COPY (LINE, 5, LENGTH (LINE) - 4);
              P := POS (TILDE, VERB);
              IF P > 0
                THEN VERB := COPY (VERB, P + 2, LENGTH (VERB)-P-1);
              TEST_VERB_FIN (VERB, NUMB, GEND);
              IF (NUMB > UNKN) AND (NUMB <> NUMB0) AND NOT THERE_IS_I
                THEN
                  IF VALID OR (CLASS = 17) OR (CLASS = 64) 
                    OR (CLASS = 75) OR (CLASS = 77) 
                    THEN WRITELN (FNAME, ' ERROR: Number collision at ',
                      HEADER, '=>', LINENUM)
                    ELSE
                      BEGIN
                        NG_CHANGE := TRUE;
                        NUMB0 := NUMB;
                      END;
              IF (GEND > NONE) AND (GEND <> GEND0) 
                AND NOT THERE_IS_I AND NOT THERE_IS_H
                THEN
                  IF VALID OR (CLASS = 17) OR (CLASS = 64) 
                    OR (CLASS = 75) OR (CLASS = 77) 
                    THEN WRITELN (FNAME, ' ERROR: Gender collision at ',
                      HEADER, '=>', LINENUM)
                    ELSE
                      BEGIN
                        NG_CHANGE := TRUE;
                        GEND0 := GEND;
                      END;
            END
          ELSE  { Supplement => to the structure under coding }
            BEGIN
              INC (PARTAMT);
              USACH := LINE [2];
              STYL := POS (USACH, 'sqpm*');
              IF (USACH <> BL) AND (STYL = 0)
                THEN
                  BEGIN
                    WRITELN (FNAME, ' ERROR: Wrong style label in line ',
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

  FLUSH (OUT1);
  FLUSH (OUT2);

  FOR J := 8 TO MAXPREP29 DO
    WITH CASESETS [J] DO
      IF EXAMQUAN > 0
        THEN
          BEGIN
            WRITELN (OUTF, PREPCODE : 4, EXAMQUAN : 3, 
              BL, CASNO[CASNAME], BL2, CASTRING);
            FOR I := 1 TO EXAMQUAN DO
              WRITELN (OUTF, BL2, BL2, EXAMPLES [I,1], BL2, EXAMPLES [I,2]);
                
            WRITELN (OUTG, CASTRING, '<', CASNO[CASNAME]);
            FOR I := 1 TO EXAMQUAN DO
              WRITELN (OUTG, BL2, EXAMPLES2 [I]);  
          END;
  FLUSH (OUTF);
  FLUSH (OUTG);

{ WRITELN ('Groups total  ', TOTAL:4, ' = 100.00%');
  WRITELN ('   validated  ', AMT0 :4, ' =  ', AMT0/TOTAL*100 : 5 : 2, '%');
  WRITELN ('   accepted   ', AMT11:4, ' =  ', AMT11/TOTAL*100 : 5 : 2, '%');
  WRITELN ('   animated    ', AMT12:4, ' =  ', AMT12/TOTAL*100 : 5 : 2, '%');
  WRITELN ('   feminated   ', AMT13:4, ' =  ', AMT13/TOTAL*100 : 5 : 2, '%');
  WRITELN ('   masculated  ', AMT14:4, ' =  ', AMT14/TOTAL*100 : 5 : 2, '%');
  WRITELN ('   accentuated ', AMT15:4, ' =  ', AMT15/TOTAL*100 : 5 : 2, '%');
  WRITELN ('   corrected   ', AMT2 :4, ' =  ', AMT2/TOTAL*100 : 5 : 2, '%');
  WRITELN ('Marked: ', USECOUNT [1] : 4, ' specials');
  WRITELN ('        ', USECOUNT [2] : 4, ' colloquials');
  WRITELN ('        ', USECOUNT [3] : 4, ' indecents');
  WRITELN ('        ', USECOUNT [5] : 4, ' awkwards');  }
  
  WRITELN ('Files OPFUNC_0.LST, OPFUNC.COD, OPFUNCxx.COD, PREPO.LST,');
  WRITELN ('  SOBCOUNT.LST, MORFCASE.LST, VNEXAMPL.TXT, VNEXAMPL2.TXT output');

  PREPOTOTAL := 0;
  FOR J := 8 TO MAXPREP29 DO
    BEGIN
      WRITELN (OUT3, PREPO [J] : 7, BL, PREPOS [J].PRP);
      INC (PREPOTOTAL, PREPO [J]);
    END;
  WRITELN (OUT3, PREPOTOTAL, ' PREPS IN COLLOCATIONS');
  WRITELN (OUT5, PREPOTOTAL, ' PREPS IN COLLOCATIONS');
  
  WOPREPTOTAL := 0;
  FOR I := 0 TO 7 DO
    BEGIN
      CASE I OF
        0: WRITELN (OUT5, 'NOM: ', CAS_WO_PREP[0]:6);
        1: WRITELN (OUT5, 'GEN: ', CAS_WO_PREP[1]:6);
        2: WRITELN (OUT5, 'DAT: ', CAS_WO_PREP[2]:6);
        3: WRITELN (OUT5, 'ACC: ', CAS_WO_PREP[3]:6);
        4: WRITELN (OUT5, 'INS: ', CAS_WO_PREP[4]:6);
        6: WRITELN (OUT5, 'PAR: ', CAS_WO_PREP[6]:6);
      END;
      INC(WOPREPTOTAL, CAS_WO_PREP[I]);
    END;
  WRITELN (OUT5, WOPREPTOTAL, ' COLLOCATIONS W/O PREPS');

  ALLSOB := 0;
  INISOB := 0;
  FOR I := 0 TO 48 DO
    BEGIN
      WRITELN (OUT6, SOBOJ[I], BL : 17-LENGTH(SOBOJ[I]), SOB_COUNT[I] : 7);
      IF I > 0
        THEN ALLSOB := ALLSOB + SOB_COUNT[I];
      IF (I > 0) AND (I < 10)
        THEN INISOB := INISOB + SOB_COUNT[I];
    END;
  WRITELN (OUT6, INISOB / ALLSOB * 100 : 4 : 1, '% fertile reflexives');

  FLUSH (OUT3);
  FLUSH (OUT4);
  FLUSH (OUT5);
  FLUSH (OUT6);

  WRITELN (PREPOTOTAL, ' PREPOS IN PREPO.LST OUTPUT');
END.
