PROGRAM ENCODVV;

USES INITVER4;

  TYPE
    STR115 = STRING [115];
    STR6 = STRING [6];
    VSTAGE = (ANY, BASHOM, BASNHM, NBASIC);
    RESTYPE = (LT,EQ,GT);
  CONST
    BL = ' ';
    MAXVERB = 22000;
    VSTAG_NAME : ARRAY [VSTAGE] OF STR6 = 
      ('ANY   ','BASHOM','BASNHM','NBASIC');
  VAR
    CLASS, CL2, P, P0, J, STYL : INTEGER;
    INP, OUT, OUT1 : TEXT;
    LINE, TOKEN : STR115;
    AMTV0, AMTV, LINENUM, VERB_REACHED : INTEGER;
    USECOUNT : ARRAY [1..5] OF INTEGER;
    USACH : CHAR;  
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
              IF VTOK <> 'ÇÖëíà' 
                THEN WRITELN (OUT1, VTOK);
            END;
        INC (VSTAG_CNT[VSTG]);
        IF IN_BASIC_VERBS (VTOK + '1') AND (TMPV <> 'ÇÖëíà')
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

  IF POS ('çÖ ', TMPV) = 1
    THEN TMPV := COPY (TMPV, 4, LENGTH (TMPV)-3);
  VALID := TRUE;

 IF ((TMPV = 'Ñéïçìíú') OR (TMPV='áÄèÄïçìíú')) AND (NOM = '2')
    OR (TMPV = 'ëÑéïçìíú')
    THEN VERBCL := 10
  ELSE IF ((TMPV='ÅéãÖíú') OR (TMPV='áÄÅéãÖíú')) AND (NOM = '3')
    THEN VERBCL := 41
  ELSE IF (TMPV='ëÜÄíú') AND (NOM = '2')
    THEN VERBCL := 169
  ELSE IF (TMPV='ëêÖáÄíú') AND (NOM = '2')
    THEN VERBCL := 3
  ELSE IF ((TMPV='èàëÄíú') OR (TMPV='çÄèàëÄíú')) AND (NOM = '3')
    THEN VERBCL := 3
  ELSE INITVERBCL (TMPV, VERBCL, VALID);

  IF NOT VALID AND (TMPV <> 'ÇÖëíà') AND (TMPV <> 'Åõíú')
    THEN WRITELN (' ERROR: Dubious verb ', TMPV, ' in line ', LINENUM); 
END;

BEGIN      (* MAIN *)
     (* àçàñàÄãàáÄñàü èÖêÖåÖççõï *)
  FILL_BASE_VERBS;

  AMTV0 := 0;
  AMTV := 0;
  LINENUM := 0;
  FOR J := 1 TO 5 DO
    USECOUNT [J] := 0;
  FOR VSTG := ANY TO NBASIC DO
    VSTAG_CNT [VSTG] := 0;

  ASSIGN (OUT, 'VERBVERB.COD');
  REWRITE (OUT);

  ASSIGN (OUT1, 'VERBYVER.LST');
  REWRITE (OUT1);

  WRITELN ('  FILE VERBVERB.TXT BEING PROCESSED');
  ASSIGN (INP, 'VERBVERB.TXT');
  RESET (INP);

    (* éëçéÇçéâ ñàäã *)
  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);
    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN (' ERROR: Final blank in line ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;
    IF (LINE [1] <> BL)
      THEN   (* áÄÉéãéÇéä ëíÄíúà *)
        BEGIN
          INC (AMTV0);
          TOKEN := LINE;

          P0 := POS (BL, LINE);
          P := POS (BL, COPY (LINE, 4, LENGTH(LINE) - 3));
          IF (P0 = 0) OR (POS ('çÖ ', LINE) = 1) OR (POS ('çÄ ', LINE) = 1)
            THEN
              BEGIN
                TOKEN := LINE;
                CL2 := 255;
                IF (POS ('çÄ ', LINE) = 1)
                  THEN WRITELN ('ERROR: Correct çÄ to çÖ in line ', LINENUM);
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
          WRITELN (OUT, '+ 2', CLASS : 4, CL2 : 4, ' 0 ', LINE);
        END
      ELSE           (* äéåèéçÖçí *)
        BEGIN
          INC (AMTV);

   { Extraction of style label if exists }
          USACH := LINE [2];
          STYL := POS (USACH, 'sqpm*');
          IF (USACH <> BL) AND (STYL = 0)
            THEN
              BEGIN
                WRITELN ('Wrong style label in line ', LINENUM);
                HALT;
              END
           ELSE IF STYL > 0
             THEN INC (USECOUNT [STYL]); 

          LINE := COPY (LINE, 3, LENGTH (LINE) - 2);

          P0 := POS (BL, LINE);
          P := POS (BL, COPY (LINE, 4, LENGTH(LINE) - 3));
          IF (P0 = 0) OR (POS ('çÖ ', LINE) = 1) OR (POS ('çÄ ', LINE) = 1)
            THEN
              BEGIN
                TOKEN := LINE;
                CL2 := 255;
                IF (POS ('çÄ ', LINE) = 1)
                  THEN WRITELN ('ERROR: Correct çÄ to çÖ in line ', LINENUM);
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
            {'0' : 2, '0' : 2,} STYL : 2, BL, LINE);
        END;
  UNTIL EOF (INP);

  CLOSE (INP);
  FLUSH (OUT);
  FLUSH (OUT1);

  WRITELN (AMTV0 : 5, ' GROUPS HEADED BY VERBS');
  WRITELN (AMTV : 5,  ' VERB-VERB COLLOCATIONS');
  WRITELN ('MEAN GROUP SIZE = ', AMTV / AMTV0 : 4 : 1);
  WRITELN ('== VERBS DISTRIBUTE TO: ');
   FOR VSTG := BASHOM TO NBASIC DO
     WRITELN (BL : 4, VSTAG_NAME[VSTG] : 5, ' = ', VSTAG_CNT [VSTG] : 5);
  WRITELN ('FILES VERBVERB.COD AND VERBYVER.LST OUTPUT');

{ WRITELN (USECOUNT [1] : 6, ' SPECIALS');
  WRITELN (USECOUNT [2] : 6, ' COLLOQUIALS');
  WRITELN (USECOUNT [3] : 6, ' INDECENTS');
  WRITELN (USECOUNT [5] : 6, ' FORBIDDENS'); }
END.
