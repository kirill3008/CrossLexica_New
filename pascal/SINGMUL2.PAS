PROGRAM SINGMUL2;

USES DOS, CLASTABL;

  TYPE
    STR3 = STRING [3];
    STR5 = STRING [5];
    STR6 = STRING [6];
    STR15 = STRING [15];
    STR45 = STRING [55];
    STR115 = STRING [115];
  CONST
    BL = ' ';
    HY = '-';
    DUMMY = '';
    MAXNOUN = 42000; 
    
{ List of SINGL-PLUR or PLUR-SINGL endings of the same length }
    MAX0 = 28;
    NUMB_PAIRS0 : ARRAY [1..MAX0, 1..2] OF STR3 =
(*01*)(('€',     'ˆ'),     (* ‘’ŽŠ€ *)
(*02*) ('€',     '…'),     (* “—ˆ‹ˆ™€ *)
(*03*) ('€',     'Ž'),     (* Ž‹€Š€ *)
(*04*) ('€',     '›'),     (* ‘’…€ *)
(*05*) ('€Ÿ',    '›…'),    (* ‚€€Ÿ *)
(*06*) ('›',    'Ž'),    (* ‹› *)
(*07*) ('‚›',    'Ž‚'),    (* ‚› *)
(*08*) ('…',     'Ÿ'),     (* ‡„€ˆ… *)
(*09*) ('…',     '‰'),     (* €Ž—ˆ… *)
(*10*) ('…Š',    'Šˆ'),    (* Š€Œ…˜…Š *)
(*11*) ('…‹',    '‹›'),    (* Ž‘…‹ *)
(*12*) ('…',    '›'),    (* ‚…’… *)
(*13*) ('…‘',    '‘›'),    (* …‘ *)
(*14*) ('…–',    '–›'),    (* …Œ…– *)
(*15*) ('ˆ',     '‰'),     (* Žˆ *)
(*16*) ('ˆ',     'Ž'),     (* ‹…—Ž *)
(*17*) ('ˆ',     'œ'),     (* ‘’…ˆ *)
(*18*) ('ˆ',     'Ÿ'),     (* ‡…Œ‹ˆ *)
(*19*) ('…‘Ÿ',   '‰‘Ÿ'),   (* ’“„Ÿ™ˆ…‘Ÿ *)
(*20*) ('Šˆ',    'ŽŠ'),    (* Œ…˜Šˆ *)
(*21*) ('‹›',    'Ž‹'),    (* Ž‘‹› *)
(*22*) ('›',    'Ž'),    (* ‘› *)
(*23*) ('Ž…',    'ˆ…'),    (* Œ€’…Œ€’ˆ—…‘ŠŽ… *)
(*24*) ('Ž…',    '›…'),    (* ‚’ŽŽ… *)
(*25*) ('Ž‰',    '›…'),    (* ‚›•Ž„Ž‰ *)
(*26*) ('Ž',    '›'),    (* ‚ˆ•Ž *)
(*27*) ('Ž’',    '’›'),    (* Ž’ *)
(*28*) ('œ',     'Ÿ'));    (* “—ˆ’…‹œ *)

{ List of SINGL-PLUR or PLUR-SINGL endings of different lengths }
  MAX1 = 27;
  NUMB_PAIRS1 : ARRAY [1..MAX1, 1..2] OF STRING [4] =
(*01*)(('',      '€'),     (* „ŽŠ’Ž *)
(*02*) ('',      'ˆ'),     (* „“€Š *)
(*03*) ('',      'Ž‚œŸ'),  (* ‘› *)
(*04*) ('',      '›'),     (* ‘’€Š€ *)
(*05*) ('',      'œŸ'),    (* ‘’“‹ *)
(*06*) ('€',     'ˆ'),    (* ƒŽ‘Ž„€ *)
(*07*) ('€',     'Ž'),    (* ‘“„€ *)
(*08*) ('€’€',   'ŽŽŠ'),  (* Œ›˜€’€ *)
(*09*) ('ƒ',     '‡œŸ'),   (* „“ƒ *)
(*10*) ('…',     'ˆ'),    (* €ŒŸ… *)
(*11*) ('…‚',    'œ‚›'),   (* ‹…‚ *)
(*12*) ('…‚€',   'ˆ'),    (* •Ž‡Ÿ…‚€ *)
(*13*) ('…„',    'œ„›'),   (* ‹…„ *)
(*14*) ('…Š',    '‰Šˆ'),   (* Ž…Š *)
(*15*) ('…Š',    'œŠˆ'),   (* ŠŽ˜…‹…Š *)
(*16*) ('…Œ',    '‰Œ›'),   (* ‡€…Œ *)
(*17*) ('…€',   'Ÿ'),     (* ‡€Œ…€ *)
(*18*) ('…ŽŠ',  'Ÿ’€'),   (* Ÿƒ…ŽŠ *)
(*19*) ('…œ',   'ˆ'),    (* €…œ *)
(*20*) ('…ˆ',   'œ'),     (* „Ž—œ *)
(*21*) ('…–',    '‰–›'),   (* Ž…– *)
(*22*) ('…–',    'œ–›'),   (* “Œ…‹…– *)
(*23*) ('ˆ',    '›'),     (* Ž‹ƒ€ˆ *)
(*24*) ('‰–›',   'Ÿ–'),    (* ‡€‰–› *)
(*25*) ('ˆ',    'Žœ'),   (* Žƒˆ *)
(*26*) ('Ž',     'œŸ'),    (* „……‚Ž *)
(*27*) ('Ž’œ',   '’ˆ'));   (* ‹ŽŠŽ’œ *)

  VAR
    LI, LJ, K, Q, CLASS : INTEGER;
    I, J, PAIRSAMT, N_REACHED : LONGINT; 
    OUT : TEXT;
    FOUND, VALID : BOOLEAN;
    NUMB : NUMBER;
    GEND : GENDER;
    ANIM : ANIMA;
    TOKI, TOKJ : STR45;
    FINI, FINJ : STR5;
    NOUN : ARRAY [1..MAXNOUN] OF STR45;

{ Listing of false SINGL-PLUR pairs of the same lengths }
FUNCTION FORBID_PAIR0 (TOK1, TOK2 : STR45) : BOOLEAN;
       (*============*)
CONST 
  FORBID_MAX0 = 92;
  T : ARRAY [1..FORBID_MAX0, 1..2] OF STR45 =
(('€„…‘€','€„…‘›'),
 ('€Œ€','€Œ…'),
 ('€€‹ˆ’ˆŠ€','€€‹ˆ’ˆŠˆ'),
 ('€‘’Ž”ˆ‡ˆŠ€','€‘’Ž”ˆ‡ˆŠˆ'),
 ('€„€','€„›'),
 ('“€','“ˆ'),
 ('“€','“›'),
 ('“†“€','“†“ˆ'),
 ('‚€‹…Š','‚€‹Šˆ'),
 ('‚……','‚…›'),
 ('‚…Š€','‚…Šˆ'),
 ('‚…Š€','‚…ŠŽ'),
 ('‚…‘€','‚…‘ˆ'),
 ('‚…‘€','‚…‘›'),
 ('ƒ…ŽŽ‹ˆ’ˆŠ€','ƒ…ŽŽ‹ˆ’ˆŠˆ'),
 ('ƒŽ€','ƒŽ…'),
 ('ƒ“„€','ƒ“„ˆ'),
 ('„€','„Ž'),
 ('„ˆ‚€','„ˆ‚Ž'),
 ('„ˆ€ŒˆŠ€','„ˆ€ŒˆŠˆ'),
 ('„ˆ','„Ž'),
 ('„ŽƒŒ€’ˆŠ€','„ŽƒŒ€’ˆŠˆ'),
 ('„“˜Šˆ','„“˜ŽŠ'),
 ('†€','†€€'),
 ('†…‹…‡€','†…‹…‡Ž'),
 ('‰Žƒ€','‰Žƒˆ'),
 ('‰Žƒ','‰Žƒ€'),
 ('Š€‡€','Š€‡ˆ'),
 ('Š€€','Š€…'),
 ('Š€€Š“‹ˆ','Š€€Š“‹œ'),
 ('Š‹€‘‘ˆŠ€','Š‹€‘‘ˆŠˆ'),
 ('ŠŽ‹€','ŠŽ‹›'),
 ('ŠŽ‹œ…','ŠŽ‹œŸ'),
 ('ŠŽ‹','ŠŽ‹€'),
 ('ŠŽ˜…‹…Š','ŠŽ˜…‹Šˆ'),
 ('Šˆ’ˆŠ€','Šˆ’ˆŠˆ'),
 ('‹€ƒ…ˆ','‹€ƒ…Ÿ'),
 ('‹€’€','‹€’ˆ'),
 ('‹……„€','‹……„ˆ'),
 ('‹ˆˆŠ€','‹ˆˆŠˆ'),
 ('‹ŽƒˆŠ€','‹ŽƒˆŠˆ'),
 ('‹Ž†ˆ','‹Ž†œ'),
 ('Œ€’…Œ€’ˆŠ€','Œ€’…Œ€’ˆŠˆ'),
 ('Œ…•€','Œ…•ˆ'),
 ('ŒŽ‹ŽŠˆ','ŒŽ‹ŽŠŽ'),
 ('ŒŽ™ˆ','ŒŽ™œ'),
 ('ŽŠŽŠˆ','ŽŠŽŽŠ'),
 ('Ž„…›','Ž„…€'),
 ('Ž„…›','Ž„…€'),
 ('Ž‘€„Š€','Ž‘€„Šˆ'),
 ('Ž‘€','Ž‘ˆ'),
 ('Ž‘Ž€','Ž‘Žˆ'),
 ('€ˆ','€Ÿ'),
 ('€‘’€','€‘’ˆ'),
 ('€','ˆ'),
 ('……Š','…Šˆ'),
 ('…ˆ','…œ'),
 ('…œŠ€','…œŠˆ'),
 ('…‘œ','…‘Ÿ'),
 ('ˆŠ€','ˆŠ…'),
 ('ˆŽƒ€','ˆŽƒˆ'),
 ('Ž‹ˆ’ˆŠ€','Ž‹ˆ’ˆŠˆ'),
 ('ŽŠˆ','ŽŽŠ'),
 ('€ƒŒ€’ˆŠ€','€ƒŒ€’ˆŠˆ'),
 ('…‘‘€','…‘‘›'),
 ('Ž‚Ž„€','Ž‚Ž„›'),
 ('“‘’›œ','“‘’›Ÿ'),
 ('“˜Šˆ','“˜ŽŠ'),
 ('€€','€›'),
 ('€Š€','€Šˆ'),
 ('Ž†ˆ','Ž†œ'),
 ('ŽŒ€’ˆŠ€','ŽŒ€’ˆŠˆ'),
 ('‘…‹€','‘…‹ˆ'),
 ('‘…‹ˆ','‘…‹Ž'),
 ('‘…Œœ','‘…ŒŸ'),
 ('‘…ˆ','‘…Ž'),
 ('‘…ˆ','‘…œ'),
 ('‘Ž‹ˆ','‘Ž‹Ž'),
 ('‘Ž‹€','‘Ž‹ˆ'),
 ('‘Ž‹ˆ','‘Ž‹Ž'),
 ('‘““ƒ','‘““ƒ€'),
 ('‘“˜€','‘“˜ˆ'),
 ('‘—…’€','‘—…’›'),
 ('’…’€','’…’›'),
 ('’…’€„€','’…’€„ˆ'),
 ('’Ž‹Š','’Ž‹Šˆ'),
 ('’ŽŒŽ‡›','’ŽŒŽ‡€'),
 ('’“˜ˆ','’“˜œ'),
 ('“•€','“•Ž'),
 ('”ˆ‡ˆŠ€','”ˆ‡ˆŠˆ'),
 ('–‚…’€','–‚…’›'),
 ('™…‹Šˆ','™…‹ŽŠ'));
VAR 
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT 
    INC(I); 
    FOUND := (TOK1 = T[I,1]) AND (TOK2 = T[I,2]);
  UNTIL FOUND OR (I = FORBID_MAX0);
  FORBID_PAIR0 := FOUND;
END;

{ Listing of false SINGL-PLUR pairs of differen lengths }
FUNCTION FORBID_PAIR1 (TOK1, TOK2 : STR45) : BOOLEAN;
       (*============*)
CONST 
  FORBID_MAX1 = 114;
  T : ARRAY [1..FORBID_MAX1, 1..2] OF STR45 =
(('€€‹ˆ’ˆŠ','€€‹ˆ’ˆŠ€'),
 ('€€‹Žƒˆ','€€‹Žƒˆˆ'),
 ('€’ˆ‘…’ˆŠ','€’ˆ‘…’ˆŠ€'),
 ('€‘’Ž”ˆ‡ˆŠ','€‘’Ž”ˆ‡ˆŠ€'),
 ('€‡ˆ‹ˆŠ','€‡ˆ‹ˆŠ€'),
 ('€‡ˆ‹ˆŠ','€‡ˆ‹ˆŠˆ'),
 ('€„','€„€'),
 ('€ˆ','€›'),
 ('€Š','€Š€'),
 ('…ƒ“','…ƒ“œŸ'),
 ('Ž‹’“','Ž‹’“œŸ'),
 ('…„…œ','…„ˆ'),
 ('…„','…„ˆ'),
 ('“','“ˆ'),
 ('‚€’€','‚€’ˆ'),
 ('‚…Š','‚…Šˆ'),
 ('‚…‘’','‚…‘’ˆ'),
 ('‚ŽŽ','‚ŽŽ€'),
 ('‚Ž—“','‚Ž—“œŸ'),
 ('‚›Ž','‚›Ž›'),
 ('ƒ…ŽŽ‹ˆ’ˆŠ','ƒ…ŽŽ‹ˆ’ˆŠ€'),
 ('ƒ…Žˆ','ƒ…Žˆˆ'),
 ('ƒ‹Ž“‹€','ƒ‹Ž“‹ˆ'),
 ('ƒŽ‹œ”','ƒŽ‹œ”›'),
 ('ƒŽ‘’','ƒŽ‘’ˆ'),
 ('ƒŽ‘’','ƒŽ‘’œŸ'),
 ('ƒŽ‘’œ','ƒŽ‘’œˆ'),
 ('ƒŽ‘’œ','ƒŽ‘’œŸ'),
 ('ƒ€”€','ƒ€”ˆ'),
 ('ƒ“‡ˆ','ƒ“‡›'),
 ('„…’…Œˆ€’','„…’…Œˆ€’€'),
 ('„ˆ€‹…Š’ˆŠ','„ˆ€‹…Š’ˆŠ€'),
 ('„ˆ€ŒˆŠ','„ˆ€ŒˆŠ€'),
 ('„ŽƒŒ€’ˆŠ','„ŽƒŒ€’ˆŠ€'),
 ('„Ž‹','„Ž‹ˆ'),
 ('„“˜','„“˜€'),
 ('†€','†€€'),
 ('‡€€‚…‘','‡€€‚…‘ˆ'),
 ('‡“','‡“œŸ'),
 ('‰Žƒ','‰Žƒ€'),
 ('Š‹€‘‘ˆŠ','Š‹€‘‘ˆŠ€'),
 ('ŠŽ‹','ŠŽ‹€'),
 ('ŠŽ‹„“','ŠŽ‹„“œŸ'),
 ('ŠŽ‹‹…ƒˆ','ŠŽ‹‹…ƒˆˆ'),
 ('ŠŽŒ','ŠŽŒ€'),
 ('ŠŽŒŽ‡ˆ’','ŠŽŒŽ‡ˆ’€'),
 ('ŠŽ','ŠŽˆ'),
 ('ŠŽˆ','ŠŽˆˆ'),
 ('Š…','Š…ˆ'),
 ('Šˆ’ˆŠ','Šˆ’ˆŠ€'),
 ('ŠŽ‚','ŠŽ‚ˆ'),
 ('ŠŽ','ŠŽ›'),
 ('‹…„','‹…„ˆ'),
 ('‹ˆ‘','‹ˆ‘€'),
 ('‹ˆˆŠ','‹ˆˆŠ€'),
 ('‹ŽƒˆŠ','‹ŽƒˆŠ€'),
 ('‹ž„','‹ž„ˆ'),
 ('Œ…‹','Œ…‹ˆ'),
 ('Œ€…','Œ€…€'),
 ('Œ€…','Œ€…›'),
 ('Œ€’…Œ€’ˆŠ','Œ€’…Œ€’ˆŠ€'),
 ('Œˆ„ˆ','Œˆ„ˆˆ'),
 ('ŒŽ€•ˆ','ŒŽ€•ˆˆ'),
 ('Œ€’…ˆ','Œ€’…ˆˆ'),
 ('ŒŽ…€','ŒŽŸ'),
 ('€–ˆ','€–ˆˆ'),
 ('Ž€‹','Ž€‹€'),
 ('Ž’ˆŠ','Ž’ˆŠ€'),
 ('Ž‘’Žƒ','Ž‘’Žƒ€'),
 ('Ž’…‹','Ž’…‹ˆ'),
 ('Ž’“','Ž’“ˆ'),
 ('€','€ˆ'),
 ('€ˆ','€ˆˆ'),
 ('ˆŽƒ','ˆŽƒ€'),
 ('ˆŠ','ˆŠ€'),
 ('‹€’Ž','‹€’œŸ'),
 ('‹Ÿ‘“','‹Ÿ‘“œŸ'),
 ('ŽƒŽ','ŽƒŽˆ'),
 ('Ž„‚Ž„','Ž„‚Ž„€'),
 ('Ž‹ˆ’ˆŠ','Ž‹ˆ’ˆŠ€'),
 ('Ž‹Žƒ','Ž‹Ž‡œŸ'),
 ('Ž‹›œ','Ž‹›œˆ'),
 ('Ž','Ž€'),
 ('€ƒŒ€’ˆŠ','€ƒŒ€’ˆŠ€'),
 ('€Š’ˆŠ','€Š’ˆŠ€'),
 ('…‘‘','…‘‘€'),
 ('Ž‚Ž„','Ž‚Ž„›'),
 ('Ž…Œ','Ž‰Œ›'),
 ('“‹','“‹ˆ'),
 ('““','““€'),
 ('€','€€'),
 ('…‚','…‚€'),
 ('…‡','…‡ˆ'),
 ('ˆ‘Š','ˆ‘Š€'),
 ('ŽŒ€’ˆŠ','ŽŒ€’ˆŠ€'),
 ('Ž’','Ž’€'),
 ('Ž’','Ž’›'),
 ('‘€','‘€ˆ'),
 ('‘€•€€','‘€•€ˆ'),
 ('‘…Œœ','‘…Œœˆ'),
 ('‘…œŽ','‘…œŽ€'),
 ('‘’€’œ','‘’€’œˆ'),
 ('‘’ˆ•ˆ','‘’ˆ•ˆˆ'),
 ('‘’€’…ƒˆ','‘’€’…ƒˆˆ'),
 ('‘““ƒ','‘““ƒ€'),
 ('’Ž‹Š','’Ž‹Šˆ'),
 ('’Ž','’Žˆ'),
 ('’…‘Š','’…‘Š€'),
 ('’ˆ“','’ˆ“€'),
 ('”€’','”€’€'),
 ('”ˆ‡ˆŠ','”ˆ‡ˆŠ€'),
 ('•‚ŽŽ‘’','•‚ŽŽ‘’ˆ'),
 ('–‚…’','–‚…’›'),
 ('—…’','—…’›'));
VAR 
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT 
    INC(I); 
    FOUND := (TOK1 = T[I,1]) AND (TOK2 = T[I,2]);
  UNTIL FOUND OR (I = FORBID_MAX1);
  FORBID_PAIR1 := FOUND;
END;

{ Initialization of basic nouns array }
PROCEDURE FILL_NOUNS;
        (*===========*)
VAR
  I : LONGINT;
  LINE, TMP : STR115;
  INP : TEXT;
BEGIN
  ASSIGN (INP, 'SUBSTAT3.STS');
  RESET (INP);
  I := 0;
  REPEAT
    READLN (INP, LINE);
    TMP := COPY (LINE, 6, LENGTH(LINE)-5);
    IF (POS(TMP[1], '0123456789^"') = 0) AND (POS ('<', TMP) = 0)  
      AND (POS (BL, TMP) = 0) AND (POS (HY, TMP) = 0)
      AND (POS(TMP[LENGTH(TMP)], '0123456789') = 0) 
      THEN
        BEGIN
          INC(I);
          NOUN [I] := COPY (LINE, 6, LENGTH(LINE)-5);
        END;
  UNTIL EOF(INP) OR (I = MAXNOUN);
  N_REACHED := I;
  CLOSE (INP);
  writeln ('NOUNS are ', N_REACHED);
END;


BEGIN  (* MAIN *)
  FILL_NOUNS;

  ASSIGN (OUT, 'PAIRS2.DAT');
  REWRITE (OUT);

  PAIRSAMT := 0;

  FOR I := 1 TO N_REACHED - 1 DO
    BEGIN
      TOKI := NOUN [I];
      LI := LENGTH (TOKI);
      FOR J := I+1 TO N_REACHED DO
        BEGIN
          TOKJ := NOUN [J];
          LJ := LENGTH (TOKJ);

          IF (TOKI[1] = TOKJ[1])
            THEN
              IF (LI = LJ)
                THEN
                  BEGIN
                    FOUND := FALSE;
                    K := 1;
                    WHILE (TOKI[K] = TOKJ[K]) DO
                      INC(K);
                    FINI := COPY (TOKI, K, LI-K+1);
                    FINJ := COPY (TOKJ, K, LJ-K+1);
                    
                    Q := 0;
                    REPEAT
                      INC(Q);
                      FOUND := (FINI = NUMB_PAIRS0[Q,1]) 
                        AND (FINJ = NUMB_PAIRS0[Q,2]); 
                    UNTIL FOUND OR (Q = MAX0);  
                    
                    IF FOUND 
                      AND NOT FORBID_PAIR0 (TOKI, TOKJ)
                      THEN
                        BEGIN
                          INITSUBCL (TOKI, CLASS, VALID, NUMB, GEND, ANIM);
                 {   IF (TOKI = '€‘’…œˆ–€') THEN WRITELN ('—ˆ‘‹Ž = ', ORD(NUMB));}
                          IF NUMB = SING
                            THEN WRITELN (OUT, '1 ', TOKI, BL:2, TOKJ)
                            ELSE WRITELN (OUT, '1 ', TOKJ, BL:2, TOKI);
                          INC (PAIRSAMT);
                        END;
                  END
                ELSE
                  BEGIN
                    FOUND := FALSE;
                    K := 1;
                    WHILE (TOKI[K] = TOKJ[K]) AND (K <= LI) DO
                      INC(K);
                  {  IF K = LI
                      THEN FINI := ''
                      ELSE } FINI := COPY (TOKI, K, LI-K+1);
                    FINJ := COPY (TOKJ, K, LJ-K+1);
                    Q := 0;
                    REPEAT
                      INC(Q);
                      FOUND := (FINI = NUMB_PAIRS1[Q,1]) 
                        AND (FINJ = NUMB_PAIRS1[Q,2]); 
                    UNTIL FOUND OR (Q = MAX1);  
 
                    IF FOUND 
                      AND NOT FORBID_PAIR1 (TOKI, TOKJ)
                      THEN  
                        BEGIN  
                          INITSUBCL (TOKI, CLASS, VALID, NUMB, GEND, ANIM);
                          IF NUMB = SING
                            THEN WRITELN (OUT, '1 ', TOKI, BL:2, TOKJ)
                            ELSE WRITELN (OUT, '1 ', TOKJ, BL:2, TOKI);
                          INC (PAIRSAMT);
                        END;
                  END;
        END;
    END;

  FLUSH (OUT);

  WRITELN ('File PAIRS2.DAT contains ', PAIRSAMT, ' pairs');
END.
