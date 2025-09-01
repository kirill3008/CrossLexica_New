PROGRAM MAGNCLAS;
 
USES DOS, CLASTABL, NOUNTHRU, INITVER4;

  VAR XL_DAS, BUF : STRING [255];

  TYPE
    VSTAGE = (ANY, BASHOM, BASNHM, NBASIC);

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    GLUMAX =  300;
    ATRMAX = 3700;
    MAXBN = 42000;
    MAXVERB = 22000;

    TAB = #009;
    LCSON = ' ¥¨®γολ';

    SUFS : ARRAY [1..55] OF STRING [4] =
      ('›‰', '‰', '‰', '‰‘', '€', '', '€‘', '…', '……',
      '……‘', '›…', '…', '…‘', '', '…', '', '', '',
      '€', '€€', '€…', '€', '', '€', '', '›',
      '…‘', '‘', '‘…', '’', '‚', '‚€', '‚', '‚›',
      '›€', '›', '', '€', '€€', '€', '€', '€', '', 
      '…', '…', '', '…', '…‰', '', '›', '€', '', '››', '','');
          
    STAG_NAME : ARRAY [STAGE] OF STR6 = 
      ('UNRZD ','BASIC ','VLONG ','SINGLE','HYPHD ', 
      'DBLZR ','ZPRT2 ','NZPRT2','CONJD ');
    VSTAG_NAME : ARRAY [VSTAGE] OF STR6 = 
      ('ANY   ','BASHOM','BASNHM','NBASIC');

{ Non-standard adjectives with flections within }
MAX_VLA = 43;
A_TOO_LONG : ARRAY [1..MAX_VLA, 1..2] OF STRING [50] =
(('0 1 0 9 9 9 ', '‚’ ’’ ‚’'),
 ('0 1 0 9 9 9 ', '‚‘… ’€‰ †…'),
 ('0 1 0 9 9 9 ', '‚‘… ’’ †…'),
 ('1 0 0 0 1 9 ', '‚›‚…„…›‰ ‡ ‘’ ‹ “—’†…›‰'),
 ('0 1 0 0 9 9 ', '…„‚€ ‘’™‰ € ƒ€•'),
 ('1 0 0 0 1 9 ', '€‰ › ’  ›‹'),
 ('1-0 9 9 9 9 ', '€‰-‹'),
 ('1-0 1 9 9 9 ', '€‰-‹ „“ƒ‰'),
 ('1-0 0 9 9 9 ', '€‰-‹ …™…'),
 ('1-0 1 9 9 9 ', '€‰-‹ ‰'),
 ('1-0 9 9 9 9 ', '€‰-“„'),
 ('1-0 1 9 9 9 ', '€‰-“„ „“ƒ‰'),
 ('1-0 0 9 9 9 ', '€‰-“„ …™…'),
 ('1-0 1 9 9 9 ', '€‰-“„ ‰'),
 ('1-0 9 9 9 9 ', '€‰-’'),
 ('1-0 1 9 9 9 ', '€‰-’ „“ƒ‰'),
 ('1-0 0 9 9 9 ', '€‰-’ …™…'),
 ('1-0 1 9 9 9 ', '€‰-’ ‰'),
 ('1-0 1 9 9 9 ', '€‰-’ ’……‘›‰'),
 ('1-0 0 1 9 9 ', '€‰-’ … ’€‰'),
 ('1-0 1 9 9 9 ', '€‰-’ …‡‚…‘’›‰'),
 ('1-0 1 9 9 9 ', '€‰-’ …“„€—›‰'),
 ('1-0 1 9 9 9 ', '€‰-’ ‘…›‰'),
 ('1-0 1 9 9 9 ', '€‰-’ ‘›‰'),
 ('1-0 1 9 9 9 ', '€‰-’ ‘’€›‰'),
 ('1-0 1 9 9 9 ', '€‰-’ “„‚’…‹›‰'),
 ('1-0 9 9 9 9 ', '’›‰-‹'),
 ('1-0 9 9 9 9 ', '’›‰-“„'),
 ('0 1 0 0 9 9 ', '… …™‰ ‘…… €‚›•'),
 ('0 1,0 1 9 9 ', '… „, ’€ „“ƒ‰'),
 ('0 1,0 0 0 1 ', '… …‚›‰,   … ‚’‰'),
 ('1 0 1 0 9 9 ', '„  ’’ †…'),
 ('0 0 0 0 9 9 ', '„ € „'),
 ('1 0 1 9 9 9 ', '‘€ … ‘‚‰'),
 ('1,1 0 0 0 0 ', '‘›’›‰, ›‰  ‘ ‚ ’€€…'),
 ('1,0 0 9 9 9 ', '’€‰, € …‘’'),
 ('1,1 0 9 9 9 ', '’€‰, €‰ …‘’'),
 ('0,0 0 9 9 9 ', '’, —’ €„'),
 ('0 1 0 9 9 9 ', '’— ’€‰ †…'),
 ('0 1 0 9 9 9 ', '“† €‰ …‘’'),
 ('1 0 1 0 0 9 ', '“—’†…›‰ ‹ ‚›‚…„…›‰ ‡ ‘’'),
 ('0 1-0 9 9 9 ', '•’ €‰-’'),
 ('0 1 0 0 0 9 ', ' ‡‚…‘’›‰ ‚ “‡• “ƒ€•'));
{ To be appended with '(…‘‹) … …‚›‰, ’  … ‚’‰' (7 parts) }                               



{ Ending of adjectives in nominative case, by classes }
  MAXADJ = 25;
  NOMADJFINS : ARRAY [1..MAXADJ, MASC..COMN] OF STRING [5] =
(*  1*)(('›‰','€','…','›…'),        (* „€›‰ *)
(*  2*) ('›‰','€','…','›…'),        (* ‚„›‰ -differs from cl.1 only in short forms *)
(*  3*) ('‰','€','……','…'),        (* €—‰ *)
(*  4*) ('‰','€','…','›…'),        (* “’‰ *)
(*  5*) ('‰','€','…','…'),        (* ‹•‰ *)
(*  6*) ('‰‘','€‘','……‘','…‘'),(* „€™‰‘ *)
(*  7*) ('‰','','…',''),        (* ‘“—‰ *)
(*  8*) ('‰','','……','…'),        (* €‰ *)
(*  9*) ('›‰','€','…','›…'),        (* ‚›‹’›‰ -differs from cl.1 only in short forms *)
(* 10*) ('‰','€','…','…'),        (* ’•‰ *)
(* 11*) ('‰','','…',''),        (* ‘‚‰ *)
(* 12*) ('€','€€','€…','€'),     (* ‚€ *)
(* 13*) ('’','€','','…'),           (* ’’ *)
(* 14*) ('’','€','',''),           (* ’’ *)
(* 15*) ('…‘','‘','‘…','‘…'),       (* ‚…‘ *)
(* 16*) ('','€','',''),        (* „ *)
(* 17*) ('','€','','›'),     (* € *)
(* 18*) ('‚','‚€','‚','‚›'),         (* ’–‚ *)
(* 19*) ('€','€€','€','€'),     (* ‘€ *)
(* 20*) ('…‰','','…',''),        (* —…‰ *)
(* 21*) ('…','','…',''),       (* ƒ‘„… *)
(* 22*) ('›‰','€','……','›…'),        (* “–›‰ *)
(* 23*) ('›','›€','›','››'),     (* “–› *)
(* 24*) ('-‰','-','-…','-…'),        (* 2000-‰ *)
(* 25*) ('…‰','','…',''));       (* ‘…‰ *)


  TYPE
    STR15 = STRING [15];
    STR50 = STRING [60];
    STATUS = (ZERO, SUB, VERB, ADJ, ADV);
    STR4 = STRING [4];

{!} ATR_ARR_PTR = ^ATR_ARR_TYPE;
{!} ATR_ARR_TYPE = ARRAY [1..ATRMAX] OF
      RECORD
        TKN : STR50;    (* ‹›‰ ‚„ €’“’€ *)
        FPL : INTEGER;  (* „‹€ 1-‰ —€‘’ - „‹ ‘‹‚‘—…’€‰ *)
        STS : STATUS;   (* ””…’‚€ —€‘’ …— €’“’€ *)
        CLS : INTEGER;  (* ‹€‘‘ ‘‹… ‚‘…ƒ €’“’€ ‹ 1‰ —€‘’ *)
        CLS2: INTEGER;  (* ‹€‘‘ ‘‹… 2-‰ —€‘’ €’“’€-C/‘—…’€ *)
        GND : GENDER;   (* „ €’“’€ - ‚……›‰ €€…’ *)
        NMB : NUMBER;   (* —‘‹ €’“’€ - ‚……›‰ €€…’ *)
        NEG : BOOLEAN;  (* €‹—… …„…‘’‚“™…‰ —€‘’–› "…" *)
        NCH : CHAR;     (* … € (…‘‹ ’ ) *)
        IDI : INTEGER;  (* C’…… „€’—‘’ *)
        STY : INTEGER;  (* ‘’‹‘’—…‘€ …’€ *)
        CHN : BOOLEAN;  (* ‡€ ‘…› ‹€‘‘€ ’€ '‚……‰/‚……›‰'*)
      END;

  VAR
{!} ATR_ARR : ATR_ARR_PTR;
    INP, OUT, OUT1, OUT2, OUT3, OUT4, OUT5, OUT6 : TEXT;
    FNAME, FOUTNAME : STRING [12];
    LINE, HEADLINE, NOUN, HEADWOG : STRING [115];
    HEADER, PREVHEAD, DESCR, TKN1, TKN2 : STR50;
    I, J, K, LINENUM, COUNTIDI, COUNT_OUT : LONGINT;
    HCLASS, HCLASS2, CLS1, CLS2, P, PA, PH, L, L1, 
    IDIOM, STYL, VERB_REACHED : INTEGER;
    
    ATR_AMT, GLU_AMT, BN_REACHED : LONGINT;
    USECOUNT : ARRAY [1..8] OF LONGINT;
       
    CLS_ATL : ARRAY [1..MAX_VLA, 1..6] OF INTEGER;
    SPR_ATL : ARRAY [1..MAX_VLA, 1..6] OF CHAR;
    TKN_ATL : ARRAY [1..MAX_VLA, 1..6] OF STRING [15];
    LIST_ATL : ARRAY [1..MAX_VLA, MASC..COMN] OF STRING [40];

    CLASS17 : ARRAY [1..OYMAX] OF STRING [18]; (* ‹‰ *)
    CLA0018 : ARRAY [1..XOYMAX] OF STR15;  (* ‘“•‰ *)
    CLA0107 : ARRAY [1..IYMAX] OF STRING [12]; (* ”€‡€‰ *)
    GLU_ARR : ARRAY [1..GLUMAX] OF
      RECORD
        TKN : STRING [25];
        STS : STATUS;
        CLS : INTEGER;  (* ‹€‘‘ 1-ƒ ‘‹‚€ *)
        CLS2: INTEGER;  (* ‹€‘‘ 2-ƒ ‘‹‚€ *)
        GND : GENDER;(* „ ‘‹…‰ - „‹ ‘“™…‘’‚’…‹›• *)
        NMB : NUMBER;(* —‘‹ ‘‹…‰ - „‹ ‘“™…‘’‚’…‹›• *)
        ANM : ANIMA; (* „“…‚‹.‘‹…‰ - „‹ ‘“™…‘’‚’…‹›• *)
        NCH : CHAR;  (* … € (…‘‹ ’ ) *)
      END;
    EXP_ARR : ARRAY [1..GLUMAX] OF
      RECORD
        TKN : STR50;
        FPL : INTEGER;  (* „‹€ 1‰ —€‘’ - „‹ ‘‹‚‘—…’€‰ *)
        STS : STATUS;
        CLS : INTEGER;
        CLS2: INTEGER;  (* ‹€‘‘ ‘‹… 2‰ —€‘’ ‘… *)
        GND : GENDER;(* „ ‘… *)
        NMB : NUMBER;(* —‘‹ ‘… *)
        NCH : CHAR;  (* … € (…‘‹ ’ ) *)
      END;
    FIN : STRING [4];
    HVALID, HVALID2, DOUBLE_HEAD, INVERSE_HEAD, CHANGE, HYPH : BOOLEAN;
    HNUMB, HNUMB2, NUM0 : NUMBER;
    HGEND, HGEND2, GND0 : GENDER;
    HANIM, HANIM2 : ANIMA;
    HSTAT : STATUS;
    HNCH, FIRST, USACH : CHAR;
    STG : STAGE;
    STAG_CNT : ARRAY [STAGE] OF LONGINT;
    VSTG : VSTAGE;
    VSTAG_CNT : ARRAY [VSTAGE] OF INTEGER;
    VERBSTR : ARRAY [1..MAXVERB] OF STR50;   { basic verb strings }
     
    BASE_NOUNS : ARRAY [1..MAXBN] OF STR50;

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
FUNCTION IN_BASIC_VERBS (TOKEN : STR50) : BOOLEAN;
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
PROCEDURE CLASSIFY_VERB (VTOK : STR50;
         {=============} VAR VERBCL : INTEGER);
  VAR
    L : INTEGER;
    TMPV : STR50;
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
              IF VTOK <> '‚…‘’' 
                THEN 
                  BEGIN
                    WRITELN (OUT1, VTOK);
                    WRITELN (OUT5, VTOK);
                    WRITELN (VTOK);
                  END;
            END;
        INC (VSTAG_CNT[VSTG]);
        IF IN_BASIC_VERBS (VTOK + '1') AND (TMPV <> '‚…‘’')
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

  IF ((TMPV='„•“’') OR (TMPV='‡€€•“’')) AND (NOM = '2')
    OR (TMPV='‘„•“’')
    THEN VERBCL := 10
  ELSE IF ((TMPV='‹…’') OR (TMPV='‡€‹…’')) AND (NOM = '3')
    THEN VERBCL := 41
  ELSE IF (TMPV='‘†€’') AND (NOM = '2')
    THEN VERBCL := 169
  ELSE IF (TMPV='’“‘’') AND (VTOK [L] = '2')
    THEN VERBCL := 207
  ELSE IF (TMPV='‘…‡€’') AND (NOM = '2')
    THEN VERBCL := 3
  ELSE IF ((TMPV='‘€’') OR (TMPV='€‘€’')) AND (NOM = '3')
    THEN VERBCL := 3
  ELSE IF ( (TMPV='‚‘›€’') OR (TMPV='‚›‘›€’') OR (TMPV='„‘›€’') 
    OR (TMPV='‡€‘›€’') OR (TMPV='€‘›€’') OR (TMPV='‘›€’') 
    OR (TMPV='……‘›€’') OR (TMPV='‘›€’')  OR (TMPV='’‘›€’')
    OR (TMPV='„‘›€’') OR (TMPV='‘›€’') OR (TMPV='‘›€’') 
    OR (TMPV='‘‘›€’') OR (TMPV='“‘›€’') ) AND (VTOK [L] = '1')
    THEN VERBCL := 246
  ELSE IF ((TMPV='‚›‘›€’‘') OR (TMPV='€‘‘›€’‘')) AND (VTOK [L] = '1')
    THEN VERBCL := 247
  ELSE INITVERBCL (TMPV, VERBCL, VALID);

  IF NOT VALID AND (TMPV <> '‚…‘’') AND (TMPV <> '›’')
    THEN WRITELN (' ERROR: Dubious verb ', TMPV, ' in line ', LINENUM); 
END;

  PROCEDURE INIT_HEADER;
          (*===========*)
  BEGIN
    HEADER := DUMMY;
    HCLASS := 0;
    HCLASS2 := 255;
    DOUBLE_HEAD := FALSE;
    INVERSE_HEAD := FALSE;
    HVALID := FALSE;
    HNUMB := UNKN;
    HGEND := NONE;
    HANIM := IND;
    HSTAT := ZERO;
    HNCH := BL;
    HYPH := FALSE;
  END;

  PROCEDURE INIT_ARRAYS;
          (*===========*)
    VAR
      I : WORD;

  BEGIN
{!} NEW (ATR_ARR);
    FOR I := 1 TO ATRMAX DO
{!}   WITH ATR_ARR^ [I] DO
        BEGIN
          TKN := DUMMY;
          FPL := 0;
          STS := ZERO;
          CLS := 0;
          CLS2:= 0;
          GND := NONE;
          NMB := UNKN;
          NEG := FALSE;
          NCH := BL;
          IDI := 0;
          STY := 0;
          CHN := FALSE;
        END;
    FOR I := 1 TO GLUMAX DO
      WITH GLU_ARR [I] DO
        BEGIN
          TKN := DUMMY;
          STS := ZERO;
          CLS := 0;
          CLS2:= 255;
          GND := NONE;
          NMB := UNKN;
          ANM := IND;
          NCH := BL;
        END;
    FOR I := 1 TO GLUMAX DO
      WITH EXP_ARR [I] DO
        BEGIN
          TKN := DUMMY;
          FPL := 0;
          STS := ZERO;
          CLS := 0;
          CLS2:= 0;
          GND := NONE;
          NMB := UNKN;
          NCH := BL;
        END;
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

FUNCTION WELL_ENDING (TOKEN : STR50) : BOOLEAN;
       (*===========*)
CONST
  WELL_END_VLA = 76;
A_WELL_LONG : ARRAY [1..WELL_END_VLA] OF STRING [60] =
 ('‹…… …‘’›‰',
 '‹…… “›‰',
 'ƒ ‚…‘’ €‰',
 'ƒ ‡€…’ €‰',
 '“„’ ‡ †› ‚›“’›‰',
 '“„’ ‡ ‡€„–› ‚›“’›‰',
 '“„ ‡„‚ €‰',
 '‚‘… ‹‰',
 '‚‘… €‚ €‰',
 '„‚‹ ‡€…’ €‰',
 ' ‚ ‘… … ‘‚‰‘',
 '‡ ‹„›•, „€ €‰',
 '‡ „€ ‚ ‚›•„™‰',
 '‡-‡€ “ƒ‹€ … ’›‰',
 '‡-‡€ “ƒ‹€ … •‹“’›‰',
 '‡-‡€ “ƒ‹€ … ’•“’›‰',
 '‡-‡€ “ƒ‹€ … “„€…›‰',
 '‡-‡€ “ƒ‹€ … •‹…‘“’›‰',
 '‡-‡€ “ƒ‹€ … •‘“’›‰',
 '€ € ƒ‹’‚‰',
 '€ €•€’›‰',
 '€ ‡‚›‰',
 '€ “„’ ‚›…‰',
 '€ ‚ ‚„“ “™…›‰',
 '€ ‚€’›‰',
 '€ ‚›…‰',
 '€ †…‹…‡›‰',
 '€ ‡ †› ‚›“’›‰',
 '€ ‡ ‡€„–› ‚›“’›‰',
 '€ “•“ ƒ‹’‚‰',
 '€ ‹…‰',
 '€ ‘ ‚‡“ “€‚‰',
 '€ ‘ „“€ “•“‚‰',
 '€ ‘ …€ ‘‚€‹‚‰‘',
 '€ ‘ –… ‘‚€‚‰‘',
 '€ ’€‚‰',
 '€ …‹‚›‰',
 '€ ‡› ƒ‹’‚‰',
 '€‹ “ „‘’“›‰',
 '… €•’ €‰',
 '… ƒ ‚…‘’ €‰',
 '… ƒ ‡€…’ €‰',
 '…‡‚…‘’ ’“„€ ‚‡‚‰‘',
 '…‡‚…‘’ ’“„€ ‚‚‰‘',
 ' ‚ —… … ‡€…€›‰',
 '  —…“ … ‡›‚€™‰',
 '  —…“ … ƒ„›‰',
 '  —…“ … —€‘’›‰',
 '  —…’“ … ƒ„›‰',
 '  —…’“ … ƒ„™‰‘',
 ' € —’ … ƒ„›‰',
 ' € —’ … “†›‰',
 ' € —’ … •†‰',
 ' € —’ … …’…„“™‰',
 ' € —’ … ƒ„›‰',
 ' ‘ —… … ‘‘’€‚›‰',
 ' ‘ —… … ‘€‚›‰',
 ' ‘ —… … ‘•†‰',
 ' ‘  „“• … ‚‚€’›‰',
 ' —…’€ … ‘’™‰',
 '“„€ … ƒ„›‰',
 '“ … “†›‰',
 '—…ƒ … ‡€—€™‰',
 '—… … …—€’…‹›‰',
 '—’ … €‡‹—›‰',
 '€’—…‘ … ’‹—›‰',
 '“‘’ •’ ’€‰',
 '‘€ ‡€…’… €‰',
 '‘€ ‘‰ „€‡“…‚€™‰‘',
 '‘€ ‘‰ €‡“…™‰‘',
 '‘‹‚ ‡ †› ‚›“’›‰',
 '‘‹‚ ‡ ‡€„–› ‚›“’›‰',
 '’… †… ‹› ’›‰',
 '’‹ —’ ‹“—…›‰',
 '—…’ ‚…‘’ €‰',
 '—…’ ‡€…’ €‰');
VAR
  I, L, LI : INTEGER;
  FOUND : BOOLEAN;

BEGIN
  L := LENGTH(TOKEN);
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    LI := LENGTH (A_WELL_LONG[I]);
    FOUND := (L = LI) AND 
      ((COPY (TOKEN, 1, L-2) = COPY (A_WELL_LONG[I], 1, LI-2))
      OR (COPY(TOKEN, L-1, 2) = '‘') 
        AND (COPY(A_WELL_LONG[I], LI-1, 2) = '‘') 
        AND (COPY(TOKEN, 1, L-4) = COPY(A_WELL_LONG[I], 1, LI-4)));
  UNTIL FOUND OR (I = WELL_END_VLA);
  WELL_ENDING := FOUND;
END;

FUNCTION ISPREP (TOKEN : STR50) : BOOLEAN;
       (*======*)
  CONST
    MAXPRE = 73;
    PREPS : ARRAY [1..MAXPRE] OF STRING [13] =
      ('…‡','…‡','‹‡',
      '‚','‚','‚…','‚……„',
        '‚‹’','‚’›','‚€‡…‡','‚›…',
      '„‹','„','‡€',
      '‡','‡-‡€','‡-„','‡',
      '','€','','…','…†„“','',
      '€','€‚‘’…—“','€„','€„','€‡‹',
        '€‘—…’','…„€‹…','…„€‹…“',
        '…‘’',
      '','','','„','’','’',
      '……„','……„','','‚…•','„',
        '„','‡†…','','‘‹…',
        '‘…„‘’‚','…†„…','',
        '…’…‹','','’‚','',
        '“’…',
      '€„','„',
      '‘','‘‚…•','‘‡€„','‘‹€','‘‚‡',
        '‘‹…„','‘','‘‚…‘’','‘ƒ‹€‘',
        '‘™€','‘……„','‘“‘’','‘…„',
      '“','—……‡');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    FOUND := (TOKEN = PREPS [I]);
  UNTIL FOUND OR (I = MAXPRE);
  ISPREP := FOUND;
END;

FUNCTION PSEUDO_ADJ (TOKEN : STR50) : BOOLEAN;
       (*==========*)
CONST
MAX1 = 69;
  EXCEP1 : ARRAY [1..MAX1] OF STRING [16] =
('‘‚„……','€„…†……','‹’……','‘‹……','‡€‘…„€‰',
'€‘“‘’…•‰','‡€—‰','‡€“‘›‚€','„—‰','ƒ€‰',
'€„‰','€‡ƒ‚€‚€','‹—……','—€‘-„“ƒ‰','„…’€‹……',
'‘ƒ‚‰','€……‰','ƒ‹„‰','€‚€—’‰','ƒ“‰',
'€’”…‹‰','€’‰','‡€ €‘‰','€‘‰','€‘‘‰',
'„…‚—‰','’‹€„›‚€','‹†…‰','‚€‡‰','„‚‰',
'‚‘…‰','„…-„…‘‰','…„‹………','‘—€‘’‹‚……','••‚€',
'€‘’›‰','†…—“†‰','€‡€•‚€','”’……','‘‰……',
'’€€„‰','’“—‰','‹€‘’—‰','……‘’€‚€','‚€’…‹……',
'›ƒ‚€','‘€›‚€','—‚€','…„“…‚€','€‡„“›‚€',
'•€›‚€','‘€‚‹‰','‘€“’‰','‘€“—‰','‘’—‰',
'‘…‚…-‚‘’—……','‘…‚…-‡€€„……','‘‹“……','‚……',
'…€™€','‚‘’—……','’€‚€-’€‚‰','€ …‚›‰-‚’‰','„‰ “‰',
'ƒ-‚‘’—……','ƒ-‡€€„……','“…………','„‚… € „‚…','„ ‚ „');
{ ATTN: ‘…‚…-‡€€„…… is included here, but is not permitted 
as adverb in DB (try ‹…ƒ€’), in contrast to ƒ-‡€€„……. Why? }
                  
MAX2 = 151;
  EXCEP2 : ARRAY [1..MAX2] OF STRING [9] =
('…ƒ€','‹……','›‘’……','€‹……','M………','€M………','…†……',
'‡€€……','„€‹……','‘……','›ƒ€','’…‹……','‹’……','€–‰',
'…—’€‰','…‹“ƒ‰','ƒ€„‰','‚……‚‰','’“‘–‰','„…‚—‰','„“€',
'‚††‰','„›‰','†€‰','‡…‰‰','ƒ‰','ƒ‰','ƒ‡‰','›‰',
'‘’…‰','’…‹……','ƒ“„‰','ƒ„‰','‚…‚‰','‚‹‰','‚‰','‚„‰',
'‡€‡‰','…•‰','’—‰','–…—‰','“€„‰','‚‡€‰','ƒ€',
'‹€‚‰','‹€‚‰','‘’‰','„“‰','€“’‰','…€','“‹€',
'†€†„‰','•‹„……','ƒ“‰','„“ƒ‰','„“„—‰','ƒ‰','ƒ‹‚‰',
'‘‹‰','‰','‘‰','…„‰','“ƒ‚‰','‘‹‚‰','‚‰',
'‚…‘‰','‡‰','„‰','‚‰','‰','‚†‰','‘‰','‘’…‹‰',
'’‹‰','‡€ —…’‰','„‰','„™…—‰','…‹—‰','…‹‰','‹…‘…‰',
'‹…’‰','‹€’‰','‹€’‰','—‰','‘’‰','“€’‰','‘’',
'ƒ…','‘‚','‘…','“’—‰','™…’—‰','‰','…‰',
'‚€…','‚…‚›…','€„‚…','‚„‚…','‚’…','€’…','€‚……',
'‘—’€','‚‡€','’€‚‰','’“‰','‡€','…„‹………','ƒ€',
'’›‚€','’‘’“€','………„€','‹€„€','‘›•€','…‚€',
'ƒ€—…','„‚‰','„‹‰','„“‰','„ƒ‰','€‹‰','‹„—‰',
'••€','€…‚€',
'€‡€','€‡ƒ€','“†€','‚‘’€‚€','“‘’€‚€','—’€','‹„‰',
'‡€€„……','‚…„……','‘…‚………','‘‹……','†……','‰','ƒ‰',
'™…’‰','…•’“‰','€…’‰','‚……‰','‹‘‰','‹‰','‘‚…—‰',
'‘‹„……','—……„‰','—…’‰','†„€','‹‹……','ƒ‹“……','“……');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  IF LENGTH (TOKEN) >= 9
    THEN
      REPEAT
        INC (I);
        FOUND := (EXCEP1 [I] = TOKEN);
      UNTIL FOUND OR (I = MAX1)
    ELSE
      REPEAT
        INC (I);
        FOUND := (EXCEP2 [I] = TOKEN);
      UNTIL FOUND OR (I = MAX2);
  PSEUDO_ADJ := FOUND;
END;

FUNCTION SPEC_ADV (TOKEN : STR50) : BOOLEAN;
       (*========*)
CONST
  MAX1 = 28;
  SPEC_ADV1 : ARRAY [1..MAX1] OF STRING [28] =
('–…‰ ‹• †…’‚','‘‹…„…… ‘’','‹€‚‰ •„‰',
'…’…‹‰ •„‰',
'‚… ‚ ‚ ‘’€›… …•','“‘‹“ƒ‰ ‡€ “‘‹“ƒ“','‚‘… ‹› ‚ ‘’“',
'€‚‰ ‘ ‚ ’“','…„ƒ“‚…‰ “‰','€… ‡€ €‡“•‰',
'€†„›‰ †‰ „…','†…‹€…… ‡€ „…‰‘’‚’…‹…','‹•… ‡€ •……',
'‚‘… ‘’› †‡','……„ ƒ‹€‡€ € †‚‰','’„€‚€ ‘…… ’—…’€',
'“„‚‰ ƒ…‰ € ƒ€•','‘’“„‚‰ ƒ…‰ € ƒ€•','…‚‡€ € ‹–€',
'…’‚…„‰ •„‰','… ’„€‚€ ‘…… ’—…’€','€ ‚ ‚„“ “™…›‰',
'‚‘… ‘‹†……  ‘‹†……','… „, ’€ „“ƒ…','’ „, ’ „“ƒ…',
'„ € ›‹€ ‚ ‹…','„€ ƒ€ ‡„…‘, „“ƒ€ ’€','€ …€›‰');

  MAX2 = 123;
  SPEC_ADV2 : ARRAY [1..MAX2] OF STRING [15] =
('‚…‘ ‚€…','‚…‘ ‘','“ƒ‹›… ‘“’','„ € „',
'‰-‰ €','‘€  ‘……','‘€ ‘‰','ƒ€ ‡€ „“‰',
'‚…‰  €‚„‰','‚…‰-€‚„‰','‘‚… …‘’','‘‚…‰ „ƒ‰',
'ƒ€ ƒ‰','‚‘‰ ‚‘—›','‚‘…•  ‚‘','„‰  ‘',
'„“€ „“‰','ƒ… ‚……‚—‰','„›… €—€‹€','‚‹‰ •„‰',
'“……‰ ‘‹›','‘‰‰ —',' ‚ ‡“ ƒ‰','€‘‰ ’',
'€…‰ …›','ƒ“› „“„—‰','„“„—‰','„ €‡','„ƒ‰ –…‰',
'“ƒ‹›… ƒ‹€‡€','€‰ ’','…‹‰ ‚ ‹…‘…','€†„›‰ ƒ„',
'€†„›‰ „…','€†„›‰ …‘–','€†„›‰ €‡','…’… ‚…',
'€‹‰ ‘‘’','’•‰ ‘€‰','‚‹‰ •„‰','€‹‰ ‘‘’',
'…’‚‰ •‚€’‰','…‚›‰ €‡','•‚‘’ „“„‰','•‚‘’ ‚‰',
'“‰ ‹…','„‹’…‹›‰ ‘','‚‘… €‚','‚‘… ‚“ƒ','‚„‚…',
'‰ €‚„‰','—……„‰ €‡','‚‘‰ €‡','‚‘… € …‘’',
'‚‘… ‚ „“ “—“','‚‘… …‡ ‘’€’€','‚‘… …‡ ‡’','‚‘… …‡ €‡€',
'‚‘… „ €‹','‚‘… „ ‘’€’€','‚‘… „ €…‹','‚‘… „ –€',
'‚‘… „—‘’€','‚‘… €‚ €','… …€™€','“’‰','“ƒ‹›‰ ƒ„',
'‚‘… €—‘’','‚‘… „„','‚‘… €‡','‚‘… ‘€‡“','‚‘… ‚“ƒ',
'‚‘… “ƒ','‚‘… –…‹','‚‘… …™…','‚‘… ‘‹†……','…• ƒ‰',
'—€‘-„“ƒ‰','…’‚‰ “‚‰','‘›’‰ €…‰','‘‚…‰ …‰',
'’‰ †… …’‰','‚‘…‰ †…‰','‹… ƒ‹€‡€','‡€„‰ •„','‚…‘‰',
'ƒ‹“‰ ‘…','‰ „ƒ‰','ƒ€‰ …’‹‰','‹‰ ƒ“„',
'‹‰ ‹†‰','–…‹›‰ „…','‚…‘ „…','… „','ƒ‹“‰ —',
'‚…’…… ‚‘…ƒ','‘‚…‰ ‘‰','‚‘… ‹……','‚‘… …†…','… „“€',
'‚‘… ………','‚‘… ‹…ƒ—…','‚‘… ’“„……','ƒ…‰ € ……','‚‘… ‹…',
'‚‘… ‚‡†…','‚‘… †…‘’—…','‚‘… ’…‘……','‘€… ','‘€… ’',
'€…„‚› ‚…','‚‘… …‘……','‚‘…  …‘’€','‚‘… ‚‘’‚………',
'… ‹†‰ ‘‚…’','‚‹€ ‡€ ‚‹‰','„‚… € „‚…','’‰ ‰',
'„……','‘‹“……','„ ‚ „','„ €‡','„ ‡€ „“ƒ');

  SPECPAR1 : ARRAY [1..14] OF STR6 =
('‚…—…','‚…','ƒ„','ƒ„›','„…','„','†‡',
'‹…’','…‘–','€‡','“‰','‘','—€‘','—€‘›');
  
  SPECPAR2 : ARRAY [1..5] OF STRING [11] =
('‚‘…','‚‘…‰','„','‘€','‘‘’‚…‰');

VAR
  I : INTEGER;
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  IF LENGTH (TOKEN) > 15
    THEN
      REPEAT INC (I); FOUND := (SPEC_ADV1 [I] = TOKEN);
      UNTIL FOUND OR (I=MAX1)
    ELSE
      REPEAT INC (I); FOUND := (SPEC_ADV2 [I] = TOKEN);
      UNTIL FOUND OR (I=MAX2);
  IF NOT FOUND THEN
    BEGIN
      I := 0;
      REPEAT
        INC (I);
        FOUND := (POS(BL+SPECPAR1[I],TOKEN) > 0);
      UNTIL FOUND OR (I=14);
    END;
  IF NOT FOUND THEN
    BEGIN
      I := 0;
      REPEAT INC (I); FOUND := (POS(SPECPAR2[I]+BL, TOKEN) > 0);
      UNTIL FOUND OR (I=5);
    END;
  SPEC_ADV := FOUND;
END;
{----------------------}
FUNCTION SPEC_ADJ (TOKEN : STR50) : BOOLEAN;
       (*========*)
CONST
MAX1 = 77;
SPEC_ADJ1 : ARRAY [1..MAX1] OF STRING [28] =
('‹‰ „…‹‚‰ •‚€’',
'‚‘€‹…‰ ”€’€‡','‚›‘‰ ’…‘‚‘’',
  '‚›‘‰ ‚€‹”€–','‚›‘‰ •„‘’',
  '‚›‘‰ ‘’…… ’†…‘’','‚›‘‰ ’……€’“›',
  '‚›‘‰ ””…’‚‘’','‚›‘‰ „“’‚‘’',
  '‚›‘‰ ‡€ƒ‡…‘’',
'ƒƒ€’‘‰ ‚€†‘’','ƒ‘“„€‘’‚…‰ ‚€†‘’',
'„‚‚›“‹‰ ”›',
'…‚…‰‘‰ €–€‹‘’',
'†…‘‰ ‚…•…‰ „…†„›',
'‡……‰ ™‘’',
'‘‹—’…‹‰ ‚€†‘’',
'‘’—…‘‰ ‚€†‘’',
'‘’—…‘‰ ‡€‘’‰',
'€‚€‡‘‰ €–€‹‘’','…‰ €–€‹‘’',
  '‘’€‹‰ —…‘’‘’',
'‹…ƒ‰ ‘’…… ’†…‘’',
'“†‘‰ ‚…•…‰ „…†„›','„…‹‰ ‚…‘’',
'…‚…’‰ €‘’›','…‚›‘…‰ ’‹ƒ',
  '…„“‰ €“†‘’','…‡‚…‘’‰ „›',
  '…‡‚…‘’‰ ’‹ƒ','…›‚…‰ €‘’›',
  '…›—€‰‰ €‘’›','…ƒ€—…‰ ™‘’',
  '‡‰ ‘’…… ……„…‹€','‡‰ ‡€ƒ‡…‘’',
'„ „“ƒƒ ……','„‰  ’‰ †… €‘’',
  '„‰ ƒ‰ ‚ ƒ“',
  '„‰ ƒ‰ ‚ ƒ‹…','^’…—…‘’‚…‰ ^‚‰›',
  'ƒ€—…‰ ›','‘‹…’…‹‰ ‘‚…†…‘’',
  '’…—…‘’‚…‰ €','—€‚€’…‹‰ ‚…‘’',
'…‚‰ …•„‘’','…‚‘’……‰ ‚€†‘’',
  '……•„‰ „‘’“‘’','‚›…‰ ƒ“‡„…‘’',
  '‚›…‰ ƒ’‚‘’','‚›…‰ ”’‘’',
  '‚›…‰ •„‘’','‚›…‰ —‘’',
  '‹’€ …’€ ‘ …‰',
  '‘’‰ ƒ’‚‘’',
  '‚‹…€’…‹‰ ‚…‘’','‹€„‰ €’…€’',
  '’‰ €“†‘’','“ƒ‹‰ ”›',
'€‡‹—‰ ‘’…… ’†…‘’','€‡“‰ „‘’€’—‘’',
  '€‡‹—‰ ‹€‹‡€–','€‡‹—‰ ’‹ƒ',
'‘‹†‰ €•’…’“›','‘‹†‰ ”ƒ“€–',
  '‘‘’‚…‰ ‚€†‘’','‘‘’‚…‰ …‘‰',
  '‘’…‹‰ …“’€–','‘’…‹‰ ‘‚…†…‘’',
  '‘’…‹‰ —‘’’›','‘’…‹‰ …“’€–',
  '‘’€’…ƒ—…‘‰ ‡€—‘’','‘’€…… €’‰ ‚‰›',
'“„‚’…‹‰ ‘…‹‘’','“‹“—…‰ ‹€‚',
'”“„€…’€‹‰ ‚€†‘’',
'€ƒ‚‰ „‘’“‘’','‘’…‰ ‚€“€–');

MAX2 = 154;
SPEC_ADJ2 : ARRAY [1..MAX2] OF STRING [18] =
('‹€†…‰ €’','‰–‚‘‰ „›','‹‰ €‹’“„›',
  '‹‰ ‚€†‘’','‹‰ ƒ‹“›','‹‰ „€‹‘’',
  '‹‰ „‹›','‹‰ ’“–','‹‰ …‘’',
  '‹‰ ™‘’','‹‰ €„…†‘’','‹‰ “',
  '‹‰ ‘‹› ‚‹','‹‰ ’‹™›','‹‰ –…‘’',
'‚…‘‰','‚’‰ ‚‹›','‚’‰ ƒ“›','‚’‰ €’…ƒ',
  '‚’‰ ‘‚…†…‘’','‚’‰ ‘’……','‚›††…‰ ‡…‹',
  '‚›‘• …ƒ‰','‚›‘‰ ƒ’‚‘’','‚›‘‰ …‘’',
  '‚›‘‰ “‹’“›','‚›‘‰ €‹','‚›‘‰ —‘’',
  '‚›‘‰ ‹’‘’','‚›‘‰ ›','‚›‘‰ —‘’',
  '‚›‘‰ ’—‘’','‚›‘‰ —€‘’’›','‚›‘‰ —‘’’›',
  '‚›‘‰ €„…†‘’','‚›‘‰ –…‘’','‚’‰ ƒ“›',
  '‚‡‰ †„‘’',
'ƒ€‡‰ ‘‹“†›','ƒ‹“‰ „…‚‘’','ƒ‹“‰ “‹’“›',
  'ƒ‰','ƒ“‰ €’›',
'„€‹…ƒ „…‰‘’‚','„‰ ‚‹','„‰ „“',
  '„‰ ‘’……','„“ƒ‰ „›','„“ƒ‰',
'‡‹’›… “',
'†€‰ …—€’','’€’‰ ‘‹“†›','^€‘‰ ^‡‚…‡„›',
  '€‘‰ †','€‘‚‰ ‚…‘’','“ƒ‹›‰ ƒ„',
  '“‰ ‚‡','“‰ ‹…–',
'‹…ƒ‰ ‘’……','‹…ƒ‰ ’†…‘’','‹—‰ ƒƒ…›',
  '‹‰ ‹…–','‹‰ ‘‹†‘’','‹‰ –…‰',
'€‹‰ ™‘’','€‰ ‚›€’',
  '‹—‰ „›','€—…… ’“—','‘‰ „›',
'…‹‰ ™‘’','……‹‚‰ „›','…›‚€‹‰ ‘‹›',
  '…‚›‘‰ “‹’“›','‡‰ ‹’‘’','‡‰ ›',
  '‚ƒ “†€','‚‰ ‚‹›',
  '‚‰ ƒ……€–','‚‰ „…‹','‚‰ ‘…',
  '‚‰ ‘‘’…›','‚‰ ”€–',
'€’‰ ‘‚‡','ƒ‰ ‚€†‘’','ƒ‰ „‹›',
  'ƒ‰ ‘‹›','„  „“','„€ „“ƒ‰ €…',
  '„‚……‰ ƒ›','„‰ ‚','„‰ €‘’',
  '„‰ “','‘‰ ‚€†‘’','‘‰ ‘’“–',
  '‘‰ …‘’','‘‰ ’—‘’',
  '’›’‰ „›—',
'…‚‰ ‚…‹—›','…‚‰ ƒ“›','…‚‰ €’…ƒ',
  '…‚‰ ‚‹›','…‚‰ —','…‚‰ €','…‚‰ ‘’……',
  '…—€‹‰ €’','‚“‘……','’……‘……',
  '‹€ ‘ ‚„‰','€‚‘‹€‚‰ ‚…›','…€‹‰ €',
  '‘’‰ ‚…‘’','‘’‰ ‘’“’“›','’‰ ‚‹›',
'€‡‹—‰ †‘’','€‡‹—‰ „›','€‡‹—‰ ’†…‘’',
  '‘’€ 150 ‘ …‰','“—‰ ‚›„…‹','“—‰ €’›',
  '“‘‘‰ €’›','…„‰ €‘’›',
'‘ “’‰','‘ „‚‰‰ ‹‰','‘ ‘ “ƒ‚‰',
  '‘ •’–‰','‘€ ‘‰','‘‚„‰ ’ƒ‚‹',
  '‘‚‰ ›‹›','‘‰ ™','‘‰ ‚…‘’',
  '‘›’‰ €…‰','‘‹†‰ ‘’“’“›','‘‰  ‘’……',
  '‘…„…‰ ’†…‘’','‘—‰ ‘‹“†›','‘’€‰ ‡€€‹',
  '‘’€‰ ‡€‚€‘','‘€ ‘‰','‘’€‰ ‘’‰',
  '‘’€‰ ”€–','‘’','‘’€…… ‚‰›','‘€ ‘…… ƒ‹‚€',
  '‘€ ‘…… ƒ‘„','‘€ ‘…… •‡',
'’€‰ †… €‘’','’€‚€-’€‚‰','’…’…‰ ‚‹›','’…’…‰ ƒ“›',
'—…’‚…’‰ ‚„›','—…’‚…’‰ ƒ“›','—‘’‰ ‚„›','—‘’‰ ›',
'“’‰');
VAR
  I : INTEGER;
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  IF LENGTH (TOKEN) >= 19
    THEN
      REPEAT
        INC (I);
        FOUND := (SPEC_ADJ1 [I] = TOKEN);
      UNTIL FOUND OR (I = MAX1)
    ELSE
      REPEAT
        INC (I);
        FOUND := (SPEC_ADJ2 [I] = TOKEN);
      UNTIL FOUND OR (I = MAX2);
  SPEC_ADJ := FOUND;
END;
{-------------------}
{ Adjectives with endings ‚/‚€/‚/‚› or …‚/…‚€/…‚/…‚› }
FUNCTION IN_OV_OVA (STEM : STR115) : BOOLEAN;
       (*=========*)
VAR
  I : INTEGER; 
  FOUND : BOOLEAN;
CONST
  OVMAX = 114;
  ST : ARRAY [1..OVMAX] OF STRING [20] =
('€…‹…','€‚ƒ…','€„','^€—','€€‹',
  '€„€','€„','€’','€…„','€‘’’…‹…',
  '€•…„','€“€•','€•‹‹…‘','€•‹‹',
'€‰…‘','€€•','^€…–…','^…ƒ','€’›…',
  '…’‹…’','”„','ƒ','€’','“‹…',
'^‚€‹“ƒ…','^‚€‹’€‘€','‚…ƒ‹…','‚‹‹‡…',
  '‚‹’','^‚‹’…','‚',
'ƒ€‰','ƒ€‹…','ƒ€‹’','ƒ€…‹…',
  '^ƒ€€‹',
  'ƒ€“‘‘','ƒ…€‹','ƒ…‘’€’','ƒ…“‹…‘',
  '^ƒ…“‹…‘','ƒ…','ƒ„…','ƒ‘“„€…',
  '^ƒ“„‡','ƒ‹€“…',
'„…€’','^„€‹','^„€’','„€’','„€‹',
  '„…„','„”€’','„“•','„‹“','„€',
'…‚‹„','…‚‘’€•…',
'€€’—','…‘€…','€','^€‰€',
  '‹‘','™……','^…‰–…','„‹',
  '^“‹',
'‹€‹€‘','‹…–','‹““‹',
'^€ƒ…‹‹€','€€…','€‘','…‰‘‘…',
'……‚‹„','…’“','…','’–',
'€•','','”€ƒ','‹…','',
  '…„‘…„€’…‹…','“‘’','…’……',
'€',
'‘€‘','‘‚…','‘‡”','‘‹‚…','‘‹',
  '^‘‹','‘€’','‘”‘','‘›',
'’…‹–…','’€’€‹','’—…‹‹…',
'”€‹‹…','^”‹',
'•€','•€“‘„”','•‘’','^•‘’','–€…','—…’',
'„','‡','‰‹…','^‰”…‹…','‹','’',
'…');
BEGIN
  FOUND:=FALSE; 
  I:=0;
  REPEAT 
    INC(I); 
    FOUND := (ST[I] = STEM);
  UNTIL FOUND OR (I = OVMAX);
  IN_OV_OVA := FOUND;
END;

FUNCTION HAS_VERB_SUF (TOKEN : STR50) : BOOLEAN;
       (*============*)
  CONST
VERB_SUFS : ARRAY [1..6] OF STR4 = ('’', '’‘', 
  '’', '’‘', '—', '—‘');
  VAR
    I, L : INTEGER;
    FOUND : BOOLEAN;
    FLEX : STR4;
BEGIN
  FOUND := FALSE;
  L := LENGTH (TOKEN);
  I := 0;
  REPEAT
    INC (I);
    FLEX := COPY (TOKEN, L - LENGTH (VERB_SUFS [I]) + 1,
      LENGTH (VERB_SUFS [I]));
    FOUND := (VERB_SUFS [I] = FLEX);
  UNTIL FOUND OR (I = 6);
  HAS_VERB_SUF := FOUND;
END;

FUNCTION IS_HYPHBLOCK (TOKEN : STR50) : BOOLEAN;
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

PROCEDURE DEFINE_SUFS (TOKEN : STR50;
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

PROCEDURE CLASSADJ (STEM : STR50;
        (*========*)FLEX_NUM : INTEGER;
                    VAR CLASS : INTEGER;
                    VAR GEND : GENDER;
                    VAR NUMB : NUMBER);
VAR
  LAST : CHAR;
  P : INTEGER;
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
            IF COPY (STEM, P-2, 2) = '‰'
              THEN
                BEGIN GEND := MASC; NUMB := SING;END
            ELSE IF COPY (STEM, P-2, 2) = '€'
              THEN
                BEGIN GEND := FEM; NUMB := SING;END
            ELSE IF COPY (STEM, P-2, 2) = '…'
              THEN
                BEGIN GEND := NEUT; NUMB := SING;END
            ELSE
              BEGIN GEND := COMN; NUMB := PLUR;END;
            EXIT;
          END
        ELSE IF (COPY (STEM, 1, P) = '-')
          OR (COPY (STEM, P + 1, LENGTH (STEM) - P) = '’')
          THEN
        BEGIN GEND := NONE; NUMB := UNKN; CLASS := 0; EXIT; END
          ELSE STEM := COPY (STEM, P + 1, LENGTH (STEM) - P);
	
      NUMB := SING;
      CASE FLEX_NUM OF
        0 : GEND := NONE;
        1..4, 19, 23, 27, 30, 31, 38, 45, 48, 50 : GEND := MASC;
        5..7, 14, 17, 20, 24, 28, 32, 35, 39, 42, 46, 51, 54 : GEND := FEM;
        8..10, 15, 21, 25, 29, 33, 36, 40, 43, 44, 47, 52 : GEND := NEUT;
        11..13, 16, 18, 22, 26, 34, 37, 41, 49, 53, 55 :
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
          ELSE IF (POS (STEM [L-1], SONOR) > 0)
            THEN CLASS := 9
            ELSE CLASS := 1;
        '–' : CLASS := 22;
        '’','„','‚','','‹','','','','‘','‡' : CLASS := 9;
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
            ELSE IF (STEM = '€') OR (COPY(STEM, LENGTH(STEM)-3, 4) = '-€')
              OR (STEM = '„…‚‹') 
              OR (STEM = '„‹…') OR (STEM = '’…') OR (STEM = '€‘…')
              OR (STEM = '’‹‘’…') OR (STEM = '’…')
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
              '–' : CLASS := 22;
              '’','„','‚','','‹','','','','‘','‡' : CLASS := 9;
              ELSE CLASS := 0;
            END;
      END;
    6 : (* - *)
      IF (LAST = '') OR (LAST = '…') OR (STEM = '€') OR (STEM = '„…‚‹')
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
      ELSE IF (LAST = '–') THEN CLASS := 22
      ELSE IF (LAST = '…') OR (STEM = '€') OR (STEM = '„…‚‹')
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
              '–' : CLASS := 22;
              '’','„','‚','','‹','','','','‘','‡' :
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
            ELSE IF (STEM = '€') OR (LAST = '…')  OR (STEM = '„…‚‹')
              THEN CLASS := 8
              ELSE
                IF (POS (LAST, LABIA) > 0)
                  THEN CLASS := 10
                ELSE
                  IF (POS (LAST, AFFR) > 0) AND (STEM <> '‚…‹—')
                    THEN CLASS := 3
                    ELSE
                      IF (STEM = '‘')
                        THEN CLASS := 25
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
         OR (STEM = '€’') OR (STEM = '‚…„') OR (STEM = '„…„“') 
         OR (STEM = '„—…')  
         OR (STEM = '„„') OR (STEM = '„„') OR (STEM = '†…') 
         OR (STEM = '“„') OR (STEM = '““') OR (STEM = '“•€')
         OR (STEM = '‹€‘’—') OR (STEM = '€‹€') 
         OR (STEM = '€') OR (STEM = '€') OR (STEM = '€—') 
         OR (STEM = '€…') OR (STEM = '€’“') OR (STEM = '€’›') 
         OR (STEM = '€’…') OR (STEM = '“†') OR (STEM = '…‚…‘’') 
         OR (STEM = '…‚…‘’') OR (STEM = '') OR (STEM = '') 
         OR (STEM = '€') OR (STEM = '€…') OR (STEM = '€„…„“') 
         OR (STEM = '€€„…„“') OR (STEM = '‘…‘’') 
         OR (STEM = '‘“') OR (STEM = '‘’€“•')OR (STEM = '‘“—') 
         OR (STEM = '’…’') OR (STEM = '’…’') OR (STEM = '’')
         OR (STEM = '€€') OR (STEM = '…') OR (STEM = '™“') 
         OR (STEM = '”‹') OR (STEM = '^”')
           THEN CLASS := 17
           ELSE CLASS := 0;
    27..29 : (* -…‘/-‘/-‘… *)
      IF (STEM = '‚')
        THEN CLASS := 15
        ELSE CLASS := 0;
    30,51,52 :  (* -’/-€/- *)
      IF (STEM = '’')
        THEN CLASS := 13
      ELSE IF (STEM = '’')
        THEN CLASS := 14
        ELSE CLASS := 0;
    31..34 : (* -‚/-‚€/-‚/-‚› *)
      IF IN_OV_OVA (STEM)
        THEN CLASS := 18
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
    42,43 : (* -€/- *)
      IF (STEM = '„')
        THEN CLASS := 16
        ELSE CLASS := 0;
    44,45,46 : (* -…/-…/- *)
      IF (STEM = 'ƒ‘„')
        THEN CLASS := 21
        ELSE CLASS := 0;
    47 : (* -… *)
      IF (STEM = '’')
        THEN CLASS := 13
        ELSE CLASS := 0;
    48 : (* -…‰ *)
      IF (STEM = '—') OR (STEM = '—') 
        OR (STEM = '…-—')
        THEN CLASS := 20
        ELSE
          IF (STEM = '‘')
            THEN CLASS := 25
            ELSE CLASS := 0;
    49 : (* - *)
      IF (STEM = '’')
        THEN CLASS := 14
        ELSE CLASS := 0;
    35,36,50,53 : (* -›/-›€/-›/-›› *)
      IF (STEM = '“–') OR (STEM = '‹…–') 
        OR (STEM = '›‹–') OR (STEM = '‹–')
        OR (STEM = '’–')  
        THEN CLASS := 23
        ELSE CLASS := 0;
    54,55 : (* -/-*)
      IF (STEM = '‘')
        THEN CLASS := 25
        ELSE CLASS := 0;
       
  END;

  IF CLASS = 0
    THEN
      BEGIN
        GEND := NONE;
        NUMB := UNKN;
      END;
END;


  PROCEDURE INITADJCL (TOKEN : STR50;
          (*=========*)VAR CLASS : INTEGER;
                       VAR GEND : GENDER;
                       VAR NUMB : NUMBER);
    VAR
      N, P : INTEGER;
      STEM, TKN : STR50;

  BEGIN
    CLASS := 0;
    IF (POS (NE, TOKEN) = 1) OR (POS (NI, TOKEN) = 1)
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
        END;
  END;


  FUNCTION MAYBE_ADJ (TOKEN : STR50;
         (*=========*)VAR GEND : GENDER) : BOOLEAN;
    VAR
      CLASS : INTEGER;
      NUMB : NUMBER;

  BEGIN
    GEND := NONE;
    INITADJCL (TOKEN, CLASS, GEND, NUMB);
    MAYBE_ADJ := (CLASS > 0);
  END;


  FUNCTION MEETS_GEND (TOKEN : STR50;
         (*==========*)ADJ_GEND : GENDER) : BOOLEAN;
    VAR
      CH : CHAR;

  BEGIN
    CH := TOKEN [LENGTH (TOKEN)];
    CASE ADJ_GEND OF
      MASC : MEETS_GEND := (POS (CH, '‚„‡‰‹‘’”–'+ AFFR + LABIA) > 0);
      FEM :  MEETS_GEND := (POS (CH, '€') > 0);
      NEUT : MEETS_GEND := (POS (CH, '…') > 0)
               OR (TOKEN = '‚…') OR (TOKEN = '');
      COMN : MEETS_GEND := (POS (CH, '›€') > 0);
      ELSE MEETS_GEND := FALSE;
    END;
  END;


  PROCEDURE INIT_ANY (TOKEN : STR50;
          (*========*)VAR CLASS : INTEGER;
                      VAR VALID : BOOLEAN;
                      VAR NUMB : NUMBER;
                      VAR GEND : GENDER;
                      VAR ANIM : ANIMA;
                      STAT : STATUS);
    VAR
      TOKEN3 : STR50;
      NB : STRING [1];
      J, ERC : INTEGER;

    PROCEDURE CFY (CL:INTEGER;
            (*===*)NB:NUMBER;
                   GN:GENDER;
                   AN:ANIMA);
    BEGIN
      CLASS := CL; VALID:=TRUE; NUMB:=NB; GEND:=GN; ANIM:=AN;
    END;

  BEGIN
    IF LENGTH (PREVHEAD) > LENGTH (TOKEN)
      THEN NB := PREVHEAD [LENGTH (TOKEN)+1]
      ELSE NB := DUMMY;
    CASE STAT OF
      SUB :
        BEGIN
        J := IN_BASE_NOUNS (TOKEN + NB);
        IF (J > 0)
          THEN
            BEGIN
              VAL (COPY (BASE_NOUNS[J], 3, 3), CLASS, ERC);
              NUMB := NUMBER (ORD(BASE_NOUNS[J,11])-ORD('0'));
              GEND := GENDER (ORD(BASE_NOUNS[J,13])-ORD('0'));
              VALID := TRUE;
            END 
          ELSE 
            BEGIN
              IF (TOKEN = '‚‘…') AND (NB = '2')
                THEN CFY(163,PLUR,COMN,YES)
                ELSE INITSUBCL (TOKEN, CLASS, VALID, NUMB, GEND, ANIM);
              IF (NUMB = UNKN) OR (GEND = NONE)
                THEN WRITELN (FNAME, ' ERROR: WRONG NOUN: ', TOKEN, ' IN ',
                PREVHEAD);
             END;
        END;

      VERB :
        BEGIN
          IF (COPY (TOKEN, LENGTH (TOKEN)-7, 8) = ' ‡ ‘…')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-8), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-4, 5) = ' ‘…')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-5), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-7, 8) = ' ‘ ‘‰')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-8), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-5, 6) = ' ‘‰')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-6), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-6, 7) = '  ‘……')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-7), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-4, 5) = ' ‘……')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-5), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-5, 6) = ' …‘’')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-6), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-4, 5) = ' ‘‚…’')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-5), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-5, 6) = ' ‡€“†')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-6), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-7, 8) = ' ‚ €‚…')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-8), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-7, 8) = ' ‚ ‘‹€•')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-8), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-5, 6) = ' ‡€’')
                  AND (LENGTH (TOKEN) > 8)
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-6), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-6, 7) = ' ’')
                  AND (LENGTH (TOKEN) > 9)
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-7), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-8, 9) = ' ‚€…')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-9), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-7, 8) = ' „‹†…')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-8), CLASS, VALID);
                HCLASS2 := 0;
              END
          ELSE IF (COPY (TOKEN, LENGTH (TOKEN)-12, 13) = ' ‘…… € ‘“')
            THEN
              BEGIN
                INITVERBCL (COPY (TOKEN, 1, LENGTH (TOKEN)-13), CLASS, VALID);
                HCLASS2 := 0;
              END
            ELSE
              BEGIN
                IF COPY (TOKEN, 1, 3) = NE
                  THEN TOKEN3 := COPY (TOKEN, 4, LENGTH (TOKEN) - 3)
                  ELSE TOKEN3 := TOKEN;
                INITVERBCL (TOKEN3, CLASS, VALID);
                IF (TOKEN = '‘…’') AND (NB = '1')
                  THEN CLASS := 3
                ELSE IF (TOKEN = '„•“’') AND (NB = '2')
                  THEN CLASS := 10
                ELSE IF (TOKEN = '‡€€•“’') AND (NB = '1')
                  THEN CLASS := 16;
                HCLASS2 := 255;
              END;
          IF NOT VALID
            THEN WRITELN (FNAME, ' ERROR: WRONG VERB: ', TOKEN, ' IN ',
              PREVHEAD);
        END;

      ADJ :
        BEGIN
          INITADJCL (TOKEN, CLASS, GEND, NUMB);
          VALID := (CLASS > 0);
          IF NOT VALID 
            AND (TOKEN <> '‡ƒ €') 
            AND (TOKEN <> '€‘ƒ –‚…’€') 
            AND (TOKEN <> '‹ƒ ‘’€')
            AND (TOKEN <> '€‹…ƒ ‘’€')
            AND (TOKEN <> '‚…‹') AND (TOKEN <> '‚…‹‚€’') 
            AND (TOKEN <> '‚‹…') AND (TOKEN <> 'ƒ€‡„')
            AND (TOKEN <> '„‹†…') AND (TOKEN <> '‹') 
            AND (TOKEN <> '€‹') AND (TOKEN <> '€‹‚€’') 
            AND (TOKEN <> '€„…') AND (TOKEN <> '€‘‹›€')
            AND (TOKEN <> '…‚…‹') AND (TOKEN <> '€……') 
            AND (TOKEN <> '„………') AND (TOKEN <> '€„') 
            AND (TOKEN <> '€„………') AND (TOKEN <> '-‘’')
            AND (TOKEN <> '-‚€’') AND (TOKEN <> '-’€‚')
            AND (TOKEN <> '-”‹') AND (TOKEN <> '‘ •’–‰')
            THEN WRITELN (FNAME, ' ERROR: Wrong adjective: ', 
              TOKEN, ' IN ', PREVHEAD);
        END;

      ELSE ;
    END;
  END;


  FUNCTION ISGEN (TOKEN : STR50) : BOOLEAN;
         (*=====*)
    CONST
      GENFIN : ARRAY [1..13] OF STRING [3] =
        ('€','','›','','‚','…‚','‘’‚','ƒ','›•','•','‰','','…');
    VAR
      I, L, L1 : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    IF (TOKEN = '€“') OR (TOKEN = '^€“')
      THEN ISGEN := TRUE
      ELSE
        BEGIN 
    L := LENGTH (TOKEN);
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      L1 := LENGTH (GENFIN [I]);
      FOUND := (GENFIN [I] = COPY (TOKEN, L-L1+1, L1));
    UNTIL FOUND OR (I = 13);
    ISGEN := FOUND
      AND (TOKEN <> '‘') AND (TOKEN <> '’')
      AND (TOKEN <> '^’€’›') AND (TOKEN <> '“€ƒ')
      AND (TOKEN <> '„›') AND (TOKEN <> '€—…‘’‚€')
      AND (TOKEN <> '—…‹‚…') AND (TOKEN <> '‹„')
      AND (TOKEN <> '€’…€‹›') AND (TOKEN <> '—‘‹€')
      AND (TOKEN <> '–') AND (TOKEN <> '„…‹€');
        END;
  END;


  FUNCTION ISINS (TOKEN : STR50) : BOOLEAN;
         (*=====*)
    CONST
      INSFIN : ARRAY [1..2] OF STRING [2] = ('','…‰');
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
    UNTIL FOUND OR (I = 2);
    ISINS := FOUND;
  END;


  FUNCTION ISSAM (TOKEN : STR50) : BOOLEAN;
         (*=====*)
    CONST
      SAM : ARRAY [1..4] OF STRING [5] =
     ('‘€›‰', '‘€€', '‘€…', '‘€›…');
    VAR
      I : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (SAM [I] = TOKEN);
    UNTIL FOUND OR (I = 4);
    ISSAM := FOUND;
  END;


  FUNCTION ISNASH (TOKEN : STR50) : BOOLEAN;
         (*======*)
    CONST
      NASH : ARRAY [1..4] OF STRING [5] =
     ('€', '€€', '€…', '€');
    VAR
      I : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (NASH [I] = TOKEN);
    UNTIL FOUND OR (I = 4);
    ISNASH := FOUND;
  END;


  FUNCTION ISVES (TOKEN : STR50) : BOOLEAN;
         (*=====*)
    CONST
      VES : ARRAY [1..3] OF STRING [5] =
     ('‚…‘', '‚‘', '‚‘…');
    VAR
      I : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      FOUND := (VES [I] = TOKEN);
    UNTIL FOUND OR (I = 3);
    ISVES := FOUND;
  END;


  PROCEDURE MESSAGE (GEND1, GEND2 : GENDER);
          (*=======*)
  BEGIN
    IF (IN_BASE_NOUNS (HEADER) = 0)
      THEN WRITELN (FNAME, ' ERROR: COLLISION: CMN.GEND=', 
      ORD (GEND1), ', H.GEND=', ORD(GEND2), 
      ' FOR HEADER ', PREVHEAD);
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


  PROCEDURE MAKE_ARRAYS;
          (*===========*)
    VAR
      P, PH, CLAS1, CLAS2, N, L, NEWCL : INTEGER;
      I : INTEGER;
      MONOGEN, VAL1, VAL2, VIVID : BOOLEAN;
      CMN_GEND, GEND1, GEND2 : GENDER;
      TOK1, TOK2, TOK3 : STR50;
      STAT1, STAT2 : STATUS;
      NUMB1, NUMB2, CMN_NUMB : NUMBER;
      ANIM2 : ANIMA;

  BEGIN
    MONOGEN := TRUE;
    CMN_GEND := NONE;
    CMN_NUMB := UNKN;

       (* €’€ ƒ“› €’“’‚ *)
    IF ATR_AMT > ATRMAX
      THEN
        BEGIN
          WRITELN ('ERROR: ATR_AMT =', ATR_AMT, ' > ATRMAX');
          RUNERROR (250);
        END;

    FOR I := 1 TO ATR_AMT DO
      WITH ATR_ARR^ [I] DO
        BEGIN
          L := LENGTH (TKN);
          IF L = 0
            THEN
              BEGIN
                WRITELN (FNAME, ' DUMMY ATTRIB AT ', PREVHEAD);
                HALT;
              END;
          GND := NONE;
          NMB := UNKN;

          P := POS (BL, TKN);
          IF P = 0
            THEN
              BEGIN
                IF PSEUDO_ADJ (TKN) OR ISSAM (TKN)
                  OR ISNASH (TKN) OR ISVES (TKN)
                  THEN STS := ADV
                  ELSE
                    BEGIN
                      INITADJCL (TKN, CLS, GND, NMB);
                      IF CLS > 0
                        THEN STS := ADJ
                        ELSE STS := ADV;
                    END;
                IF (TKN = '‚‘…') AND (CMN_GEND = COMN)
                  THEN GND := COMN;
                MONOGEN := MONOGEN AND ((CMN_GEND = NONE)
                  OR (GND = NONE) OR (CMN_GEND = GND));
                IF (CMN_GEND = NONE) AND (STS = ADJ)
                  THEN CMN_GEND := GND;
              END
            ELSE
              BEGIN
                TOK1 := COPY (TKN, 1, P-1);
                TOK2 := COPY (TKN, P + 1, L - P);
                TOK3 := COPY (TKN, 1, L - 2);
                IF (TOK3 = '‚‘… ‹') 
                  OR (TOK3 = '‚‘… ‚')                 {„…‰‘’‚“…’!!! }
                  OR (TOK3 = '„ „…’')              {„…‰‘’‚“…’!!! }
                  OR (TOK3 = '‘‚„ ‚…’“…')   {„…‰‘’‚“…’!!! } 
                  THEN
                    BEGIN
                      STAT1 := ADJ;{ADV;}
                      STAT2 := ADJ;
                      INITADJCL (TOK2, CLAS2, GEND2, NUMB2);
                    END
                ELSE IF SPEC_ADV (TKN)
                  THEN
                    BEGIN
                      STAT1 := ADV;
                      STAT2 := ADV;
                    END
                ELSE IF SPEC_ADJ (TKN)
                  THEN
                    BEGIN
                      STAT1 := ADJ;
                      STAT2 := ZERO;
                    END
                  ELSE
                    BEGIN
                      IF (TOK1[1] = '"') OR ISPREP (TOK1)
                        OR PSEUDO_ADJ (TOK1)
                        THEN STAT1 := ADV
                        ELSE
                          BEGIN
                            INITADJCL (TOK1, CLAS1, GEND1, NUMB1);
                            IF (CLAS1 = 0)
                              THEN STAT1 := ADV
                              ELSE STAT1 := ADJ;
                          END;
                      IF (TOK1[1] = '"') OR ISPREP (TOK1) OR PSEUDO_ADJ (TOK2)
                        THEN STAT2 := ADV
                        ELSE
                          BEGIN
                            INITADJCL (TOK2, CLAS2, GEND2, NUMB2);
                            IF (CLAS2 = 0)
                              THEN STAT2 := ADV
                              ELSE STAT2 := ADJ;
                          END;
                      IF (TOK1 = '…') AND (TOK2 = '„')
                        THEN
                          BEGIN
                            STAT1 := ADV;
                            STAT2 := ADJ;
                            CLAS2 := 0;
                            GEND2 := NONE;
                          END;
                    END;

                CASE STAT1 OF
                  ADV :
                    CASE STAT2 OF
                      ADV : (* „ | ‘…ƒ, ‚‘… ‚… *)
                        STS := ADV;
                      ADJ :
                        IF (TOK1[1] = '"') OR ISPREP (TOK1)
                          THEN (* € | ’‚‹†… *)
                            STS := ADV
                          ELSE (*  | €‘‘’€…›‰,
                                  ‚‘… | ‹‰ ?????? *)
                            BEGIN
                              STS := ADJ;
                              CLS := 0;
                              CLS2 := CLAS2;
                              FPL := P-1;
                              GND := GEND2;
                            END;
                      ELSE ;
                    END;
                  ADJ :
                    IF ((CLAS1 = 4) OR (CLAS1 = 5)) AND (GEND1 = MASC)
                      AND (ISGEN (TOK2) OR ISINS (TOK2))
                      THEN  (* ƒƒ€’‘‰ | ‚€†‘’
                             ¨«¨ ‹‰ | ƒ“„ *)
                        STS := ADV
                      ELSE
                        CASE STAT2 OF
                          ADV : (* ……•„™‰ | ‚ ‚€– *)
                            BEGIN
                              STS := ADJ;
                              CLS := CLAS1;
                              CLS2 := 0;
                              FPL := P - 1;
                              GND := GEND1;
                            END;
                          ADJ : (* ‘€›‰ | ‘…‹›‰ *)
                            BEGIN
                              STS := ADJ;
                              CLS := CLAS1;
                              CLS2 := CLAS2;
                              FPL := P - 1;
                              GND := GEND2;
                            END;
                          ZERO : (* ‡‹’›… “ *)
                            BEGIN
                              STS := ADJ;
                              CLS := 0;
                              CLS2 := 255;
                              FPL := 0;
                              GND := HGEND;
                            END;
                        END;
                  ELSE ;
                END;
                MONOGEN := MONOGEN AND ((CMN_GEND = NONE)
                  OR (GND = NONE) OR (CMN_GEND = GND));
                IF (CMN_GEND = NONE) AND (STS = ADJ)
                  THEN CMN_GEND := GND;
              END;
        END;
    IF MONOGEN
      THEN
        CASE CMN_GEND OF
          COMN : CMN_NUMB := PLUR;
          MASC, FEM, NEUT : CMN_NUMB := SING;
          NONE : ;
        END
      ELSE WRITELN (FNAME, ' ERROR: HETEROGENEOUS GROUP AT: ', PREVHEAD);

       (* €’€ ƒ“‚ƒ ‹—€ *)
    IF (HSTAT = ZERO)
      THEN
        BEGIN
          IF CMN_GEND <> NONE
            THEN (* ‘“™…‘’‚’…‹… *)
              BEGIN
                HSTAT := SUB;
                P := POS (BL, HEADER);
                IF P > 0
                  THEN
                    BEGIN
                      DOUBLE_HEAD := TRUE;
                      TOK1 := COPY (HEADER, 1 , P-1);
                      TOK2 := COPY (HEADER, P+1, LENGTH (HEADER) - P);
                      INITADJCL (TOK1, CLAS1, GEND1, NUMB1);
                      IF (CLAS1 > 0) OR NOT ISGEN (TOK2)
                        THEN
                          BEGIN
                            HEADER := TOK2;
                            INVERSE_HEAD := TRUE;
                          END
                        ELSE HEADER := TOK1;
                      IF INVERSE_HEAD
                        THEN INITSUBCL (TOK1, HCLASS2, VAL2,
                          NUMB2, GEND2, ANIM2)
                        ELSE HCLASS2 := 0;
                    END;
              END
            ELSE
              BEGIN
                DEFINE_SUFS (HEADER, N);
                IF (N > 0) AND (N <= 4) OR (HEADER = '‚…‘')
                  THEN HSTAT := ADJ
                  ELSE
                    IF HAS_VERB_SUF (HEADER) AND
                      (HEADER <> '‘’€’') AND (HEADER <> '’—€‘’')
                      OR (COPY (HEADER, LENGTH (HEADER)-4, 5) = ' ‘…')
                      OR (COPY (HEADER, LENGTH (HEADER)-5, 6) = ' …‘’')
                      THEN HSTAT := VERB
                      ELSE HSTAT := ADV;
              END;
          IF (HSTAT <> ADV)
            THEN
              BEGIN
                INIT_ANY (HEADER, HCLASS, HVALID,
                  HNUMB, HGEND, HANIM, HSTAT);
                IF (HSTAT = SUB) AND (CMN_GEND <> HGEND)
                  THEN
                    BEGIN
                      HNUMB := CMN_NUMB;
                      HGEND := CMN_GEND;
                      CASE HCLASS OF
                        6..9 : CASE CMN_GEND OF
                                 COMN : HCLASS := 12;
                                 MASC : ;
                                 ELSE MESSAGE (CMN_GEND, HGEND);
                               END;
                        64 : IF (CMN_GEND = MASC)
                                THEN HCLASS := 68
                                ELSE MESSAGE (CMN_GEND, HGEND);
                        68 : IF (CMN_GEND = FEM)
                                THEN HCLASS := 64
                                ELSE MESSAGE (CMN_GEND, HGEND);
                        77 : IF (CMN_GEND = FEM)
                                THEN HCLASS := 75
                                ELSE MESSAGE (CMN_GEND, HGEND);
                        79 : IF (CMN_GEND = FEM) OR (CMN_GEND = MASC)
                                THEN HCLASS := 74
                                ELSE MESSAGE (CMN_GEND, HGEND);
                        118: IF (CMN_GEND = NEUT)
                                THEN HCLASS := 17
                                ELSE MESSAGE (CMN_GEND, HGEND);
                        {119: ;}
                        0 : HCLASS := 0;
                        ELSE MESSAGE (CMN_GEND, HGEND);
                      END;
                    END;
              END;
        END;

       (* ……€‡€—…… €…—‰  ‘“™. ‚ …‡. ‹. *)
    IF (HSTAT = SUB)
      THEN
        FOR I := 1 TO ATR_AMT DO
          WITH ATR_ARR^ [I] DO
            IF (STS = ADV)
              THEN
                BEGIN
                  STS := ADJ;
                  CLS := 0;
                  CLS2 := 255;
                END;
{WRITELN ('>POINT FOR GROUP PASSED');}

       (* €’€ ƒ“› ‘‹…… *)

    IF GLU_AMT > GLUMAX
        THEN
            BEGIN
              WRITELN ('ERROR: GLU_AMT =', GLU_AMT, ' > GLUMAX');
                RUNERROR (250);
            END;

    FOR I := 1 TO GLU_AMT DO
      WITH GLU_ARR [I] DO
        BEGIN
          STS := HSTAT;
          CASE STS OF
            SUB :
              BEGIN
                P := POS (BL, TKN);
                IF P = 0
                  THEN
                    BEGIN
                      PH := POS ('_', TKN);
                      IF PH > 0
                        THEN
                          BEGIN
                            TOK1 := COPY (TKN, 1, PH-1);
                            TOK2 := COPY (TKN, PH+1, LENGTH (TKN)-PH);
                            TKN [PH] := '-';
                            INITSUBCL (TOK1, CLS, VAL1, NMB, GND, ANM);
                            INITSUBCL (TOK2, CLS2, VAL2, NMB, GND, ANM);
                          END
                      ELSE IF (POS ('^', COPY (TKN, 3, LENGTH (TKN) - 2)) > 0)
                        THEN
                          BEGIN
                            CLS := 0;
                            VAL2 := TRUE;
                            NMB := HNUMB;
                            GND := HGEND;
                            ANM := HANIM;
                          END
                        ELSE
                          BEGIN
                            INITSUBCL (TKN, CLS, VAL2, NMB, GND, ANM);
                            CLS2 := 255;
                          END;
                      IF (NMB = UNKN) OR (GND = NONE)
                        THEN WRITELN (FNAME, ' ERROR: WRONG NOUN: ', TKN,
                          ' IN ', PREVHEAD);
                    END
                  ELSE
                    BEGIN
                      TOK1 := COPY (TKN, 1, P - 1);
                      TOK2 := COPY (TKN, P + 1, LENGTH (TKN) - P);
                      IF MAYBE_ADJ (TOK1, GEND1) AND MEETS_GEND (TOK2, GEND1)
                        THEN
                          BEGIN
                            INITSUBCL (TOK1, CLS, VAL1, NMB, GND, ANM);
                            INITSUBCL (TOK2, CLS2, VAL2, NMB, GND, ANM);
                          END
                        ELSE
                          BEGIN
                            INITSUBCL (TOK1, CLS, VAL1, NMB, GND, ANM);
                            CLS2 := 0;
                          END;
                    END;
              END;
            VERB :
              BEGIN
                TOK1 := TKN;
                IF (POS (NE, TOK1) = 1)
                  THEN TOK1 := COPY (TOK1, 4, LENGTH (TOK1) - 3);
                INITVERBCL (TOK1, CLS, VAL2);
                CLS2 := 255;
                IF NOT VAL2
                  THEN
                    BEGIN
                      P := POS (BL, TOK1);
                      IF (P > 0)
                        THEN TOK1 := COPY (TOK1, 1, P - 1);
                      INITVERBCL (TOK1, CLS, VAL2);
                      IF NOT VAL2
                        THEN WRITELN (FNAME, ' ERROR: WRONG VERB: ', TKN,
                          ' IN ', PREVHEAD);
                    END;
              END;
            ADJ :
              BEGIN
                P := POS (BL, TKN);
                IF (P = 0)
                  THEN
                    BEGIN
                      INITADJCL (TKN, CLS, GEND2, NUMB2);
                      CLS2 := 255;
                    END
                  ELSE
                    BEGIN
                      IF SPEC_ADJ (TKN)
                        THEN
                          BEGIN
                            CLS := 0;
                            CLS2 := 255;
                         END
                       ELSE
                         BEGIN
                           TOK1 := COPY (TKN, 1, P - 1);
                           TOK2 := COPY (TKN, P + 1, LENGTH (TKN) - P);
                           INITADJCL (TOK1, CLS, GEND2, NUMB2);
                           CLS2 := 0;
                         END;
                    END;
              END;
            ELSE ;
          END;
        END;
    IF HSTAT = SUB (* †…’ ›’, ‰„…’ „“…‚‹……? *)
      THEN
        BEGIN
          VIVID := (HANIM = YES);
          FOR I := 1 TO GLU_AMT DO
             WITH GLU_ARR [I] DO
               VIVID := VIVID OR (GLU_ARR [I].ANM = YES);
          IF VIVID
            THEN
              FOR I := 0 TO GLU_AMT DO
                IF I = 0
                  THEN
                    BEGIN
                      IF (HANIM = NO) AND CAN_BE_ANIMATED (HCLASS, NEWCL)
                        THEN HCLASS := NEWCL;
                    END
                  ELSE
                    BEGIN
                      IF (GLU_ARR [I].ANM = NO) AND
                        CAN_BE_ANIMATED (GLU_ARR [I].CLS, NEWCL)
                        THEN GLU_ARR [I].CLS := NEWCL;
                      IF (GLU_ARR [I].ANM = NO) AND
                        (GLU_ARR [I].CLS2 <> 255) AND
                        CAN_BE_ANIMATED (GLU_ARR [I].CLS2, NEWCL)
                        THEN GLU_ARR [I].CLS2 := NEWCL;
                    END;
        END;

       (* €’€ ƒ“› ’‹‚€‰ ‘‹…… *)

    MONOGEN := TRUE;
    FOR I := 1 TO GLU_AMT DO
      WITH EXP_ARR [I] DO
        BEGIN
          L := LENGTH (TKN);
          GND := NONE;
          NMB := UNKN;
          GEND1 := NONE;
          GEND2 := NONE;

          IF (HSTAT <> SUB)
            THEN
              BEGIN
                STS := ADV;
                CLS := 0;
                CLS2 := 255;
              END
            ELSE
              BEGIN
                STS := ADJ;
                P := POS (BL, TKN);
                IF P = 0
                  THEN
                    BEGIN
                      INITADJCL (TKN, CLS, GND, NMB);
                      MONOGEN := MONOGEN AND ((GND = NONE) OR (HGEND = GND));
                    END
                  ELSE
                    BEGIN
                      TOK1 := COPY (TKN, 1, P - 1);
                      TOK2 := COPY (TKN, P + 1, L - P);

                      INITADJCL (TOK1, CLS, GEND1, NUMB1);
                      INITADJCL (TOK2, CLS2, GEND2, NUMB2);
                      FPL := P - 1;

                      IF SPEC_ADJ (TKN) (* ‚…‘ ‚€… *)
                        OR ISPREP (TOK1)
                        OR ((CLAS1 = 4) OR (CLAS1 = 5)) AND (GEND1 = MASC)
                          AND (ISGEN (TOK2) OR ISINS (TOK2))
                          AND NOT (((CLAS2 = 3) OR (CLAS2 = 8) OR (CLAS2 = 10))
                          AND (GEND2 = MASC))
                        (* ƒƒ€’‘‰ | ‚€†‘’ ¨«¨ ‹‰ | ƒ“„
                                     ­® ­¥ ‘“•‰ | †€‰ *)
                        THEN
                          BEGIN
                            CLS := 0;
                            CLS2 := 255;
                            GEND1 := NONE;
                            GEND2 := NONE;
                            FPL := 0;
                          END
                        ELSE
                          BEGIN
                            IF PSEUDO_ADJ (TOK1)
                              THEN (* €‹…… | €‘‘’€…›‰ *)
                                BEGIN
                                  CLS := 0;
                                  GEND1 := NONE;
                                END;
                            IF PSEUDO_ADJ (TOK2)
                              THEN (* …„‰ | ‘’‰ *)
                                BEGIN
                                  CLS2 := 0;
                                  GEND2 := NONE;
                                END;
                            MONOGEN := MONOGEN
                              AND ((GEND1 = NONE) OR (HGEND = GEND1))
                              AND ((GEND2 = NONE) OR (HGEND = GEND2));
                          END;
                    END;
              END;
        END;
    IF NOT MONOGEN
      THEN WRITELN (FNAME, ' ERROR: HETEROGENEOUS EXPLANS AT: ', PREVHEAD);
  END;


  PROCEDURE GET_NORM (VAR FIN : STR4;
          (*========*)VAR DELTA : INTEGER;
                      CLASS : INTEGER;
                      GEND : GENDER);
  BEGIN
    CASE CLASS OF
      0 :           FIN := DUMMY;
      1, 2, 9 :     FIN := '›‰';
      3, 7, 8, 10 : FIN := '‰';
      4, 5, 11 :    FIN := '‰';
      6 :           FIN := '‰‘';
      12 :          FIN := '€';
      13, 14 :      FIN := '’';
      15 :          FIN := '…‘';
      16, 17 :      FIN := '';
      18 :          FIN := '‚';
      19 :          FIN := '€';
      20 :          FIN := '…‰';
      21 :          FIN := '…';
      22 :          FIN := '›‰';
      23 :          FIN := '›';
      24 :          FIN := '-‰';
    END;

    CASE CLASS OF
      0 : DELTA := 0;
      6 : DELTA := 4;
      12, 17, 19, 23 :
        IF GEND = MASC
          THEN DELTA := 2
          ELSE DELTA := 3;
      13, 14 :
        IF GEND = MASC
          THEN DELTA := 2
          ELSE DELTA := 1;
      15, 21 :
        IF GEND = MASC
          THEN DELTA := 3
          ELSE DELTA := 2;
      18 :
        IF GEND = MASC
          THEN DELTA := 1
          ELSE DELTA := 2;
      ELSE DELTA := 2;
    END;
  END;

  PROCEDURE OUT_ARRAYS;
          (*==========*)
    CONST
      TRIPLE : STRING [3] = '-/\';
    VAR
      FIN, FIN1, FIN2 : STR4;
      I, L, J, L0, DELTA, DELTA1, DELTA2, P, PU : INTEGER;
      HDR, OUTSTR1, OUTSTR2, TOK1, TOK2 : STR50;
      GND2 : GENDER;
      NMB2 : NUMBER;
      DONE, FOUND : BOOLEAN;

  BEGIN
      (* ‚›‚„ ‹—€ *)
    WRITE (OUT, '+', ORD(HSTAT) : 2);
    PA := POS ('<', PREVHEAD);
    IF PA > 0
      THEN HEADWOG := COPY (PREVHEAD, 1, PA-1)
      ELSE HEADWOG := PREVHEAD;
    CASE ORD(HSTAT) OF
      1 :
        BEGIN
          PARSENOUN (HEADWOG, NOUN, CLS1, CLS2, NUM0, GND0, STG);
          HEADWOG := NOUN;
          IF (STG <> BASIC) AND (STG <> VLONG) AND (POS (BL, NOUN) = 0)
            THEN 
              BEGIN
                INC (COUNT_OUT);
                WRITELN (OUT6, ATR_AMT:2, BL, NOUN);
              END;
          INC (STAG_CNT [STG]);
          WRITELN (OUT,  CLS1: 4, CLS2: 4, ORD(NUM0):2, 
            ORD(GND0):2, BL, HEADWOG);
        END;
      2 :
        BEGIN
          IF (HNCH = '3')
            THEN
              BEGIN
                HDR := COPY (PREVHEAD, 1, POS ('3', PREVHEAD)-1);
                IF (HDR = '‹…’') THEN HCLASS := 41;
              END;
          WRITELN (OUT,  HCLASS: 4, HCLASS2: 4, '0':2, '0':2, BL, HEADWOG);
        END;
      3 :
        WRITELN (OUT, HCLASS: 4, HCLASS2: 4, '0':2, '0':2, BL, HEADWOG);
      4 : 
        WRITELN (OUT, '0': 4, '255': 4, '0':2, '0':2, BL, HEADWOG);
     END; (* CASE *)

   { IF (HSTAT = VERB) AND (HNCH = '3')
      THEN
        BEGIN
          HDR := COPY (PREVHEAD, 1, POS ('3', PREVHEAD) - 1);
          IF (HDR = '‹…’') THEN HCLASS := 41;
        END;

    IF DOUBLE_HEAD
      THEN
        IF INVERSE_HEAD
          THEN  WRITE (OUT, HCLASS2 : 4, HCLASS : 4)
          ELSE  WRITE (OUT, HCLASS : 4, '0' : 4)
      ELSE WRITE (OUT, HCLASS : 4, HCLASS2 : 4);
    WRITELN (OUT, ORD (HNUMB) * ORD (HSTAT = SUB) : 2,
      ORD (HGEND) * ORD (HSTAT = SUB) : 2, BL, PREVHEAD); }

      (* ……‹€‘‘”€– "‘€›‰/-€/-…/-›…" ‘…„ €’“’‚ *)
    IF (HSTAT = SUB) OR (HSTAT = ADJ)
      THEN
        FOR I := 1 TO ATR_AMT DO
          WITH ATR_ARR^ [I] DO
            IF (FPL = 0) AND ISSAM (TKN) OR
              (FPL > 0) AND ISSAM (COPY (TKN, 1, FPL))
              THEN
                BEGIN
                  STS := ADJ;
                  CLS := 9;
                END
            ELSE IF (FPL = 0) AND ISNASH (TKN) OR
              (FPL > 0) AND ISNASH (COPY (TKN, 1, FPL))
              THEN
                BEGIN
                  STS := ADJ;
                  CLS := 12;
                END
            ELSE IF (FPL = 0) AND ISVES (TKN)
              THEN
                BEGIN
                  STS := ADJ;
                  CLS := 15;
                END;

      (* ‚›‚„ ƒ“› €’“’‚ *)
    FOR I := 1 TO ATR_AMT DO
      WITH ATR_ARR^ [I] DO
        CASE STS OF
          ADJ:
          BEGIN
            DONE := FALSE;
            L0 := LENGTH(TKN);

  	    IF WELL_ENDING (TKN)
  	      THEN
  		BEGIN
  		  IF COPY (TKN, L0-1, 2) = '‘'     
    		    THEN 
    		      BEGIN 
    		        CLS := 0; CLS2 := 6; 
    		      END
                    ELSE 
                      BEGIN
                        CLS := 0;
                        K := L0;
                        WHILE (TKN[K] <> BL) DO
        	          BEGIN
                            DEC(K);
                            TOK2 := COPY(TKN, K+1, L0-K);
                          END;
                        INITADJCL (TOK2, CLS2, GND2, NMB2);
                      END;
                  DONE := TRUE;
                END;
           
            IF DONE
              THEN
                BEGIN
                  IF CLS2 = 6
                    THEN OUTSTR1 := COPY(TKN, 1, L0-4) + '‰‘'
                    ELSE OUTSTR1 := COPY(TKN, 1, L0-2) + NOMADJFINS[CLS2, MASC];
                  WRITELN (OUT, TRIPLE [SUCC (IDI)], '3' : 2,
                    '0' : 4, CLS2 : 4, STY : 2, BL, OUTSTR1);
                END
            ELSE
              BEGIN
                J := 0;
                FOUND := FALSE;
                REPEAT
                  INC(J);
                  GND := NONE;
                  REPEAT
                    INC(GND);
                    FOUND := (TKN = LIST_ATL[J,GND]);
                  UNTIL FOUND OR (GND = COMN);
                UNTIL FOUND OR (J = MAX_VLA);

                IF FOUND 
                  THEN
                    BEGIN
                      OUTSTR1 := LIST_ATL[J,MASC];
                      WRITELN (OUT, TRIPLE [SUCC (IDI)], '3' : 2,
                        '0' : 4, '0' : 4, STY : 2, BL, OUTSTR1);
                      DONE := TRUE;
                    END;
              END;
            
            IF NOT DONE THEN
            IF FPL = 0
              THEN
                BEGIN
                  PU := POS ('_', TKN);
                  IF (PU > 0)
                    THEN
                      BEGIN
                        L := LENGTH (TKN);
                        TOK1 := COPY(TKN, 1, PU-1);
                        TOK2 := COPY(TKN, PU+1, L-PU);
                        INITADJCL (TOK1, CLS, GND, NMB);
                        INITADJCL (TOK2, CLS2, GND2, NMB2);
                        IF (GND <> GND2) OR (NMB <> NMB2)
                          THEN
                            BEGIN
                              WRITELN('ERROR: Wrong dubble adjective ', TKN);
                              HALT;
                            END;
                        GET_NORM (FIN1, DELTA1, CLS, GND);
                        GET_NORM (FIN2, DELTA2, CLS2, GND2);
                        OUTSTR1 := COPY(TOK1, 1, LENGTH(TOK1)-DELTA1) + FIN1 +
                         '-' + COPY(TOK2, 1, LENGTH(TOK2)-DELTA2) + FIN2;
                        {WRITELN(OUTSTR1);}
                        IF NOT DONE THEN
                          WRITELN (OUT, TRIPLE [SUCC (IDI)], ORD (STS) : 2,
                            CLS : 4, CLS2 : 4, STY : 2, BL, OUTSTR1);
                        DONE := TRUE;
                      END
                    ELSE
                      BEGIN
                        GND := HGEND;
                        GET_NORM (FIN, DELTA, CLS, GND);
                    
(* ‚›‚‹……  ‹€ƒ€’…‹›• ’€ ‘‡”‚/‚€/„‹‚› *)
                    
                        P := POS ('-', TKN);
                        IF (P > 0) AND (CLS = 5) AND (COPY (TKN, 1, P-3) = '€')
                          THEN OUTSTR1 := '€‰-' +
                            COPY (TKN, P + 1, LENGTH (TKN) - P)
                          ELSE OUTSTR1 := COPY (TKN, 1, LENGTH (TKN) - DELTA) + FIN;
                    
 (*!*)                 IF CHN
                          THEN 
                            CASE CLS OF
  	                    4: BEGIN
	                         OUTSTR1[LENGTH(OUTSTR1)-1] := '›';
        	                 CLS := 1;
    	                       END;
             	            5: BEGIN
	                         OUTSTR1[LENGTH(OUTSTR1)-1] := '';
	                         CLS := 3;
	                       END;
                            END;
                        IF NEG
                          THEN OUTSTR1 := NE + OUTSTR1;
                        IF (NCH <> BL)
                          THEN OUTSTR1 := OUTSTR1 + NCH;
                    
                        IF OUTSTR1 = '„…€’‚‚'
                          THEN OUTSTR1 := '„…€’‚';
                    
                        CLS2 := 255;
                        IF NOT DONE THEN
                          WRITELN (OUT, TRIPLE [SUCC (IDI)], ORD (STS) : 2,
                            CLS : 4, CLS2 : 4, STY : 2, BL, OUTSTR1);
                        DONE := TRUE;
                      END;
                                        

 (*                 WRITELN (TRIPLE [SUCC (IDI)], ORD (STS) : 2, 
                    CLS : 4, '255' : 4, STY : 2, BL, OUTSTR1); *)
                END
              ELSE
                BEGIN
                  OUTSTR1 := COPY (TKN, 1, FPL);
                  IF CLS > 0
                    THEN
                      BEGIN
                        GND := HGEND;
                        GET_NORM (FIN, DELTA, CLS, GND);
                        OUTSTR1 := COPY (OUTSTR1, 1,
                           LENGTH (OUTSTR1) - DELTA) + FIN;
                      END;
                  OUTSTR2 := COPY (TKN, FPL + 2, LENGTH (TKN) - FPL);
                  IF CLS2 > 0
                    THEN
                      BEGIN
                        GND := HGEND;
                        GET_NORM (FIN, DELTA, CLS2, GND);
                        OUTSTR2 := COPY (OUTSTR2, 1,
                           LENGTH (OUTSTR2) - DELTA) + FIN;
                      END;
                  IF NEG
                    THEN OUTSTR1 := NE + OUTSTR1;

                  {IF NOT DONE THEN}
                  WRITELN (OUT, TRIPLE [SUCC (IDI)], ORD (STS) : 2, CLS : 4,
                    CLS2 : 4, STY : 2, BL, OUTSTR1, BL, OUTSTR2);
                  DONE := TRUE;
                END;
             END;
          ELSE
            BEGIN
              {IF NOT DONE THEN}
                BEGIN
                   WRITE (OUT, TRIPLE [SUCC (IDI)], ORD(STS) : 2, '0' : 4,
                     '255' : 4, STY : 2, BL);
                   IF NEG
                     THEN WRITE (OUT, NE);
(* ! *)            IF (NCH <> BL)
                     THEN TKN := TKN + NCH;
                   WRITELN (OUT, TKN);
                   DONE := TRUE;
                 END;
            END;
        END;

      (* ……‹€‘‘”€– "‘€›‰/-€/-…/-›…" ‘…„ ‘…‰*)
    IF (HSTAT = SUB) OR (HSTAT = ADJ)
      THEN
        FOR I := 1 TO GLU_AMT DO
          WITH EXP_ARR [I] DO
            IF (FPL = 0) AND ISSAM (TKN) OR
              (FPL > 0) AND ISSAM (COPY (TKN, 1, FPL))
              THEN
                BEGIN
                  STS := ADJ;
                  CLS := 9;
                END;

      (* ‚›‚„ ‡€ƒ‹‚€, ƒ“› ‘‹……  ‘…‰   *)
    IF GLU_AMT > 0
(*      THEN WRITELN (OUT2, PREVHEAD); ** DM *)
      THEN WRITELN (OUT2, ORD(HSTAT), BL, PREVHEAD);            (* DM *)

    FOR I := 1 TO GLU_AMT DO
      BEGIN
        WITH GLU_ARR [I] DO
          BEGIN
            IF NCH <> BL
              THEN TKN := TKN + NCH;
            WRITELN (OUT2, ORD (STS) : 2, CLS : 4, CLS2 : 4,
              ORD (NMB) * ORD (STS = SUB) : 2,
              ORD (GND) * ORD (STS = SUB) : 2, BL, TKN);
          END;
        WITH EXP_ARR [I] DO
          CASE STS OF
            ADJ:
              IF FPL = 0
                THEN
                  BEGIN
                    GET_NORM (FIN, DELTA, CLS, GND);
                    OUTSTR1 := COPY (TKN, 1, LENGTH (TKN) - DELTA) + FIN;
                    IF NCH <> BL
                      THEN OUTSTR1 := OUTSTR1 + NCH;
                    WRITELN (OUT2, BL : 5, ORD (STS), CLS : 4, '255' : 4,
                      '0' : 2, '0' : 2, BL, OUTSTR1);
                  END
              ELSE
                BEGIN
                  OUTSTR1 := COPY (TKN, 1, FPL);
                  IF CLS > 0
                    THEN
                      BEGIN
                        GET_NORM (FIN, DELTA, CLS, GND);
                        OUTSTR1 := COPY (OUTSTR1, 1,
                        LENGTH (OUTSTR1) - DELTA) + FIN;
                      END;
                  OUTSTR2 := COPY (TKN, FPL + 2, LENGTH (TKN) - FPL);
                  IF CLS2 > 0
                    THEN
                      BEGIN
                        GET_NORM (FIN, DELTA, CLS2, GND);
                        OUTSTR2 := COPY (OUTSTR2, 1,
                           LENGTH (OUTSTR2) - DELTA) + FIN;
                      END;
                  WRITELN (OUT2, BL : 5, ORD (STS), CLS : 4, CLS2 : 4,
                    '0' : 2, '0' : 2, BL, OUTSTR1, BL, OUTSTR2);
                END;

            ELSE 
              BEGIN
                IF NCH <> BL
                  THEN TKN := TKN + NCH;
                WRITELN (OUT2, BL : 5, ORD(STS), '0' : 4, '0' : 4,
                  '0' : 2, '0' : 2, BL, TKN);
              END;
          END;
      END;
  END;

PROCEDURE CONVERT_TO_OUT_TABLE;
        (*====================*)
  VAR
    INDX : ARRAY [1..6] OF CHAR;
    SEPR : ARRAY [1..6] OF CHAR;
    CLSS : ARRAY [1..6] OF INTEGER;
    I, J, K, L : INTEGER;
    NUMB : NUMBER;
    GEND : GENDER;
    LINE, LINE1, TOKEN, TAIL : STRING [100];

BEGIN
  ASSIGN (OUT3, 'ATOOLONG.CPP');
  REWRITE (OUT3);

  WRITELN (OUT3, '// CrossLexica Version 2017');
  WRITELN (OUT3, '// List of superlong ajective titles');
  WRITELN (OUT3, '// with morpho-classes of their parts');
  WRITELN (OUT3, '// and separators between thems.');
  WRITELN (OUT3, '// Comma separator is accompanied by one blank.');
  WRITELN (OUT3, 'ATLong =');
  WRITELN (OUT3, '{');

  FOR J := 1 TO MAX_VLA DO
    BEGIN
      FOR I := 1 TO 6 DO
        BEGIN
          CLSS [I] := 255;
          INDX [I] := A_TOO_LONG [J,1,(2*I-1)];
          SEPR [I] := A_TOO_LONG [J,1,(2*I)];
        END;

      TAIL := A_TOO_LONG [J,2];
      I := 1;
      WHILE (I <= 6) AND (INDX [I] <> '9') AND (TAIL <> '') DO
        BEGIN
          K := POS (SEPR[I], TAIL);
          IF K > 0
            THEN 
              BEGIN
                TOKEN := COPY(TAIL,1,K-1);
                IF SEPR[I] = ','
                  THEN TAIL := COPY(TAIL, K+2, LENGTH(TAIL)-K-1)
                  ELSE TAIL := COPY(TAIL, K+1, LENGTH(TAIL)-K);
              END
            ELSE 
              BEGIN
                TOKEN := TAIL;
                TAIL := '';
              END;
          IF INDX [I] = '0'
            THEN CLSS [I] := 0
            ELSE
              BEGIN
                INITADJCL (TOKEN, CLSS[I], GEND, NUMB);
                IF (CLSS [I] = 0) AND (TOKEN <> '‡ƒ €')
                  THEN WRITELN ('WRONG ADJECTIVE ', TOKEN);
              END;
          INC(I);
        END;

      LINE := A_TOO_LONG [J, 2];
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
        ELSE IF ('' <= LINE [I]) AND (LINE [I] <= '')
          THEN LINE1 := LINE1 + CHR (ORD (LINE[I]) + 80)
          ELSE LINE1 := LINE1 + LINE [I];
      UNTIL (I = L);

      WRITE (OUT3, '{{');
      FOR I := 1 TO 5 DO
        WRITE (OUT3, '{', CLSS [I] : 3, ',"', SEPR [I], '"},');
      WRITE (OUT3, '{', CLSS [6] : 3, ',"', SEPR [6], '"}},');
      IF J = MAX_VLA 
        THEN WRITELN (OUT3, ' "', LINE1, '"}')
        ELSE WRITELN (OUT3, ' "', LINE1, '"},');
    END;
  WRITELN (OUT3, '}');
  FLUSH (OUT3);
  WRITELN ('FILE ATOOLONG.CPP OUTPUT');
END;

PROCEDURE CONVERT_TO_INNER_TABLE;
        (*======================*)
  VAR
    INDX : ARRAY [1..6] OF CHAR;
    I, J, K : INTEGER;
    NUMB : NUMBER;
    GEND, GND : GENDER;
    LINE, TAIL : STRING [100];

BEGIN
  FOR J := 1 TO MAX_VLA DO
    BEGIN
      FOR I := 1 TO 6 DO
        BEGIN
          CLS_ATL [J,I] := 255;
          TKN_ATL [J,I] := '';
          SPR_ATL [J,I] := A_TOO_LONG [J,1,(2*I)];
          INDX [I] := A_TOO_LONG [J,1,(2*I-1)];
        END;

      TAIL := A_TOO_LONG [J,2];
      I := 1;
      WHILE (I <= 6) AND (INDX [I] <> '9') AND (TAIL <> '') DO
        BEGIN
          K := POS (SPR_ATL [J,I], TAIL);
          IF K > 0
            THEN 
              BEGIN
                TKN_ATL [J,I] := COPY(TAIL,1,K-1);
                IF SPR_ATL [J,I] = ','
                  THEN TAIL := COPY(TAIL, K+2, LENGTH(TAIL)-K-1)
                  ELSE TAIL := COPY(TAIL, K+1, LENGTH(TAIL)-K);
              END
            ELSE 
              BEGIN
                TKN_ATL [J,I] := TAIL;
                TAIL := '';
              END;
          IF INDX [I] = '0'
            THEN CLS_ATL [J,I] := 0
            ELSE
              BEGIN 
                INITADJCL (TKN_ATL [J,I], CLS_ATL [J,I], 
                  GEND, NUMB);
                IF (GEND <> MASC) OR (NUMB <> SING)
                  THEN WRITELN ('WRONG TABLE LINE ', J);
              END;
          INC(I);
        END;
    END;
  WRITELN ('VLA class table created');

  ASSIGN (OUT4, 'VLA_LIST.TXT');
  REWRITE (OUT4);

  FOR J := 1 TO MAX_VLA DO
    FOR GND := MASC TO COMN DO
      CASE GND OF
        MASC : LIST_ATL [J, MASC] := A_TOO_LONG [J,2];
        FEM, NEUT, COMN : 
          BEGIN
            LINE := '';
            I := 1;
            REPEAT
              IF CLS_ATL [J,I] = 0
                THEN LINE := LINE + TKN_ATL [J,I]
                ELSE LINE := LINE + COPY (TKN_ATL [J,I], 1, 
                  LENGTH (TKN_ATL [J,I]) - 
                  LENGTH (NOMADJFINS [CLS_ATL [J,I],MASC])) +
                  NOMADJFINS [CLS_ATL [J,I],GND];
              IF (I < 6) AND (CLS_ATL [J,I+1] < 255)
                THEN
                  BEGIN 
                    LINE := LINE + SPR_ATL [J,I];
                    IF SPR_ATL [J,I] = ','
                      THEN LINE := LINE + ' ';
                  END;
              INC (I);     
            UNTIL (I = 7) OR (CLS_ATL [J,I] = 255);
           IF (LIST_ATL [J, MASC] = '€‰ › ’  ›‹')
             THEN
               CASE GND OF
                 FEM  : LINE := LINE + 'A';
                 NEUT : LINE := LINE + '';
                 COMN : LINE := LINE + '';
               END;
            LIST_ATL [J, GND] := LINE;
          END;
      END;
  FOR J := 1 TO MAX_VLA DO
    FOR GND := MASC TO COMN DO
      WRITELN (OUT4, LIST_ATL [J,GND]);
  FLUSH (OUT4);
  WRITELN ('All VLAs in VLA_LIST.TXT');
END;

FUNCTION AMONG_TOO_LONG_A (TOKEN : STR115;
        {================} VAR NUMR : NUMBER;
                           VAR GNDR : GENDER) : BOOLEAN;
VAR
  FOUND : BOOLEAN;
  GND : GENDER;
  J, L, L_MASC : INTEGER;

BEGIN
  NUMR := UNKN;
  GNDR := NONE;
  FOUND := FALSE;
  L := LENGTH (TOKEN);

  J := 0;
  REPEAT
    INC (J);
    L_MASC := LENGTH (LIST_ATL [J, MASC]);
    IF (L_MASC - 1 <= L) AND (L <= L_MASC + 2)
      THEN
        BEGIN 
          GND := MASC;  // Start with MASC
          REPEAT
            FOUND := (TOKEN = LIST_ATL[J, GND]);
            IF NOT FOUND THEN
              INC(GND);
          UNTIL FOUND OR (GND = COMN);
    END;
  UNTIL FOUND OR (J = MAX_VLA);

  IF FOUND
    THEN 
      BEGIN
        GNDR := GND;
        IF GND = COMN
          THEN NUMR := PLUR
          ELSE NUMR := SING;
      END;
  AMONG_TOO_LONG_A := FOUND;
END;

BEGIN   (* MAIN *)
  CONVERT_TO_OUT_TABLE;
  CONVERT_TO_INNER_TABLE;
  GLOBAL_INIT;
  FILL_BASE_VERBS;

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

  FILL_BASE_NOUNS;

{ ASSIGN (OUT1, 'HOMODESC.DAT');
  REWRITE (OUT1);}

  ASSIGN (OUT2, 'GLUES.COD');
  REWRITE (OUT2);

  ASSIGN (OUT5, 'VERBYMAG.LST');
  REWRITE (OUT5);

  ASSIGN (OUT6, 'NOUBYMAG.LST');
  REWRITE (OUT6);

  FOR I := 1 TO 5 DO
    USECOUNT [I] := 0;
  FOR STG := UNRZD TO CONJD DO
    STAG_CNT [STG] := 0;
  COUNTIDI := 0;

  COUNT_OUT := 0;

  FOR J := -1 TO 88 DO
    BEGIN
      IF J = -1
        THEN FNAME := 'MAGN_1.DAT'
        ELSE FNAME := 'MAGN' + CHR (ORD ('0') + J DIV 10) +
          CHR (ORD ('0') + J MOD 10) + '.TXT';
      ASSIGN (INP, FNAME);
      RESET (INP);
 writeln(FNAME);

      FOUTNAME := COPY (FNAME, 1, LENGTH(FNAME)-3) + 'COD';
      ASSIGN (OUT, FOUTNAME);
      REWRITE (OUT);

      INIT_ARRAYS;
      ATR_AMT := 0;
      GLU_AMT := 0;
      HEADLINE := DUMMY;
      PREVHEAD := DUMMY;
      LINENUM := 0;

      REPEAT
        READLN (INP, LINE);
        INC (LINENUM);
        IF NOT EOF(INP) AND 
          ((LINE = DUMMY) OR (POS(BL2,LINE) > 1) OR (COPY(LINE,1,3) = BL+BL2)
          OR (POS(BL2, COPY(LINE, 3, LENGTH(LINE)-2)) > 0)) OR (POS(TAB,LINE) > 0)
          THEN
            BEGIN
              WRITELN (FNAME, ' ERROR: Empty or dubious line ', LINENUM);
              HALT;
            END;
        WHILE (LINE [LENGTH (LINE)] = BL) DO
          BEGIN
            WRITELN (FNAME, ' ERROR: Unnecessary final blank in line ',
              LINENUM);
            LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
          END;

        FIRST := LINE [1];
        IF (FIRST <> BL) AND (FIRST <> '/') AND (FIRST <> '\')
          AND (POS (FIRST, 'sqpm*g|&') = 0) AND (POS (BL2, LINE) = 0)
          THEN (* ‡€ƒ‹‚ *)
            BEGIN
              PREVHEAD := HEADLINE;
              HEADLINE := LINE;
              IF (ATR_AMT > 0) OR (GLU_AMT > 0)
                THEN
                  BEGIN
                    MAKE_ARRAYS;
                    OUT_ARRAYS;
                    DISPOSE (ATR_ARR);
                    INIT_ARRAYS;
                    ATR_AMT := 0;
                    GLU_AMT := 0;
                  END;
              INIT_HEADER;
              P := POS ('<', LINE);
              IF P > 0
                THEN
                  BEGIN
                    FIN := COPY (LINE, P + 1, 2);
                    IF (FIN = 'Su')
                      THEN HSTAT := SUB
                    ELSE IF (FIN = 'Ve')
                      THEN HSTAT := VERB
                    ELSE IF (FIN = 'Aj')
                      THEN HSTAT := ADJ
                    ELSE IF (FIN = 'Av')
                      THEN HSTAT := ADV
                  { ELSE WRITELN (FNAME, 
                      ' ERROR: Wrong POS in line ', LINENUM) } ;

                    IF (POS (LINE [P-1], '123456') > 0)
                      THEN
                        BEGIN
                          HEADER := COPY (LINE, 1, P-2);
                          HNCH:= LINE [P-1];
                          {WRITELN (OUT1, LINE);}
                        END
                      ELSE
                        BEGIN
                          HEADER := COPY (LINE, 1, P-1);
                          HEADLINE := HEADER;
                          INIT_ANY (HEADER, HCLASS, HVALID, HNUMB,
                            HGEND, HANIM, HSTAT);
                        END;
                  END
                ELSE
                  IF (POS (LINE [LENGTH (LINE)], '123456') > 0)
                    THEN
                      BEGIN
                        HEADER := COPY (LINE, 1, LENGTH (LINE) - 1);
                        HNCH:= LINE [LENGTH (LINE)];
                      END
                    ELSE
                      BEGIN
                        PH := POS ('_', LINE);
                        IF PH > 0
                          THEN
                            BEGIN
                              HSTAT := SUB;
                              HYPH := TRUE;
                            END;
                        HEADER := LINE;
                        IF HYPH
                          THEN
                            BEGIN
                              TKN1 := COPY (LINE, 1, PH-1); 
                              TKN2 := COPY (LINE, PH+1, LENGTH(LINE)-PH);
                              HEADLINE[PH] := '-';  
                              INITSUBCL (TKN1, HCLASS, HVALID, 
                                HNUMB, HGEND, HANIM);
                              INITSUBCL (TKN2, HCLASS2, HVALID2, 
                                HNUMB2, HGEND2, HANIM2);
                            END;
                      END;
            END
          ELSE (* €’“’/‘‹…‰€ *)
            IF LINE [3] = '/'
              THEN (* ‘‹…‰€ *)
                BEGIN
                  LINE := COPY (LINE, 4, LENGTH (LINE) - 3);
                  P := POS ('=', LINE);
                  DESCR := COPY (LINE, P + 1, LENGTH (LINE) - P);
                  IF (DESCR <> DUMMY)
                    THEN
                      IF COPY (DESCR, LENGTH(DESCR)-1, 2) = ' ~'
                        THEN DESCR := COPY (DESCR, 1, LENGTH (DESCR) - 2)
                        ELSE WRITELN (FNAME, ' ERROR: WRONG FORMAT IN GLUE: ',
                          LINENUM);
                  INC (GLU_AMT);
                  WITH GLU_ARR [GLU_AMT] DO
                    BEGIN
                      TKN := COPY (LINE, 1, P - 1);
                      L1 := LENGTH (TKN);
                      IF POS (TKN [L1], '123456') > 0
                        THEN
                          BEGIN
                            NCH := TKN [L1];
                            TKN := COPY (TKN, 1, L1 - 1);
                          END;
                    END;
                  WITH EXP_ARR [GLU_AMT] DO
                    BEGIN
                      TKN := DESCR;
                      L1 := LENGTH (TKN);
                      IF POS (TKN [L1], '123456') > 0
                        THEN
                          BEGIN
                            NCH := TKN [L1];
                            TKN := COPY (TKN, 1, L1 - 1);
                          END;
                    END;
                END
              ELSE (* ›—›‰ €’“’ *)
                BEGIN
                  USACH := LINE [2];
                  STYL := POS (USACH, 'sqpm*g|&');
                  IF (USACH <> BL) AND (STYL = 0)
                    OR (POS (LINE [1], 'sqpm*g|&') > 0)
                    THEN
                      BEGIN
                        WRITELN (FNAME, ' ERROR: Wrong label in line ',
                          LINENUM);
                        HALT;
                      END
                    ELSE IF STYL > 0
                      THEN INC (USECOUNT [STYL]);

                  IDIOM := POS (FIRST, '/\');
                  IF IDIOM > 0
                    THEN INC (COUNTIDI);
                  LINE := COPY (LINE, 3, LENGTH (LINE) - 2);

                  INC (ATR_AMT);
                  IF POS (NE, LINE) = 1
                    THEN
                      BEGIN
                        LINE := COPY(LINE, 4, LENGTH (LINE) - 3);
                        ATR_ARR^ [ATR_AMT].NEG := TRUE;
                      END;

                  CHANGE := FALSE;
                  K := 0;
                  REPEAT
                    INC (K);
                    P := POS (LINE [K], LCSON);
                    CHANGE := CHANGE OR (P > 0);
                  UNTIL CHANGE OR (K = LENGTH (LINE));
                  IF CHANGE
                    THEN LINE [K] := SONOR [P];

                  WITH ATR_ARR^ [ATR_AMT] DO
                    BEGIN
                      IDI := IDIOM;
                      STY := STYL;
                      CHN := CHANGE;
                      TKN := LINE;
                      L1 := LENGTH (TKN);
                      IF L1 = 0
                        THEN
                          BEGIN
                            WRITELN (HEADER);
                            HALT;
                          END;
                      IF POS (TKN [L1], '123456') > 0
                        THEN
                          BEGIN
                            NCH := TKN [L1];
                            TKN := COPY (TKN, 1, L1 - 1);
                            IF (POS ('‰', TKN) > 0) OR (POS ('››', TKN) > 0)
                              OR (POS ('π', TKN) > 0)
                              THEN WRITELN (FNAME, ' ERROR: WRONG MODIF ', TKN);
                          END;
                    END;
                END;

        IF EOF (INP)
          THEN
            BEGIN
              PREVHEAD := HEADLINE;
              MAKE_ARRAYS;
              OUT_ARRAYS;
{!}           DISPOSE (ATR_ARR);
            END;
      UNTIL EOF (INP);

      FLUSH (OUT);
      CLOSE (OUT);
      CLOSE (INP);
    END;

{ FLUSH (OUT1); }
  FLUSH (OUT2);
  FLUSH (OUT5);
  FLUSH (OUT6);

  WRITELN ('== ', COUNTIDI : 4, ' idioms');
  WRITELN ('== ', USECOUNT [1] : 4, ' special collocations');
  WRITELN (USECOUNT [2] : 7, ' colloquial collocations');
  WRITELN (USECOUNT [3] : 7, ' indecent collocations');
  WRITELN (USECOUNT [5] : 7, ' illiterate collocations');
{  WRITELN ('= Various nouns in: ');
  FOR STG := UNRZD TO CONJD DO
    IF STAG_CNT [STG] > 0
      THEN WRITELN (BL : 4, STAG_NAME[STG] : 6, 
        ' = ', STAG_CNT [STG] : 6); }
  WRITELN ('== ', COUNT_OUT : 4, ' non-basic nouns occurred');
  WRITELN ('Files MAGNxx.COD, GLUES.COD, ATOOLONG.CPP,');
  WRITELN (' VERBYMAG.LST, NOUBYMAG.LST and VLA_LIST.TXT output');
END.
