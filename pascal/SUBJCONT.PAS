PROGRAM SUBJCONT;

USES DOS, SUBMODUL;

  VAR XL_DAS : STRING [255];

VAR
  LINENUM : LONGINT;

PROCEDURE EROUT;
        (*=====*)
BEGIN
  INC (ERCOUNT);
  ERROR := TRUE;
  WRITELN (HEAD, '>', LINE);
END;

FUNCTION TEST (STEM,TKN:STR115):BOOLEAN;
       (*====*)
  VAR
    I, L, L0 : INTEGER;
    FOUND : BOOLEAN;
    INIT : STRING[9];
BEGIN
  TEST:=FALSE;
  L0:=LENGTH(TKN);
  L:=LENGTH(STEM);

  IF COPY(TKN,L0-L+1,L) <> STEM
    THEN EXIT
    ELSE 
      IF L0 = L
        THEN
          BEGIN
            TEST:=TRUE;
            EXIT;
          END; 
  INIT:=COPY(TKN,1,L0-L);
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC (I);
    FOUND := (PREFS[I]=INIT);
  UNTIL FOUND OR (I=MAXPREF1);
  TEST:=FOUND;
END;

FUNCTION TST (STEM:STR115):BOOLEAN;
       (*===*)
BEGIN
  TST:=TEST(STEM,TKN);
END;

FUNCTION ROOT_3EV : BOOLEAN;
       (*========*)
  CONST
    MAX3EV = 21;
    LIST3EV : ARRAY [1..MAX3EV] OF STRING [11] =
('‹','‚','‚‹€„','ƒ','ƒ','„','„‹','‡',
'‡','‹…„…','‹','„‹','','’','',
'‘','‘','‘’','‘','’‹','’‚…„');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST3EV[I]+'…‚');
  UNTIL FOUND OR (I = MAX3EV);
  ROOT_3EV := FOUND;
END;

FUNCTION STEM_3EV : BOOLEAN;
       (*========*)
  CONST
    MAX3EV = 29;
    LIST3EV : ARRAY [1..MAX3EV] OF STRING [13] =
('„','‡€…—€’‹','‡€’','‡€’','‡€•‹','‡€•',
'€…','…„“','€‹„','›„‹','“', 
'„‹','„“','‡‚…','€…','‹','„‹', 
'—…','‘“„','‘‹€','’‘›','•‹€„','‚…‹',
'„€‡“','…’…','€‡','“‚…™','“‘’€','“–…‹'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST3EV[I]+'…‚');
  UNTIL FOUND OR (I = MAX3EV);
  STEM_3EV := FOUND;
END;

FUNCTION ROOT_10 (INFIX : STR10) : BOOLEAN;
       (*=======*)
  CONST
    MAX10 = 36;
    LIST10 : ARRAY [1..MAX10] OF STRING [6] =
('…ƒ','','“•',
'‚…ƒ','‚…‡','‚‘','‚›','‚‡',
'ƒ€‘','ƒ‹•','ƒ',
'„‚ƒ','„•','„ƒ','„›•',
'†“•','‡','‘','‹…','‹',
'…‡','…','','‹','',
'','•','€•','„‚ƒ','“•',
'‘•','‘’ƒ','’•','’ƒ','’“•','—€•');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST10[I]+INFIX);
  UNTIL FOUND OR (I = MAX10);
  ROOT_10 := FOUND;
END;

FUNCTION STEM_10 (INFIX : STR10) : BOOLEAN;
       (*=======*)
  CONST
    MAX10 = 14;
    LIST10 : ARRAY [1..MAX10] OF STRING [9] =
('‚‘…‘','ƒ','‡€‘“‡','‘‘','‘—…‡',
'…','‘','‘‹€','‘‹…',
'‹…','ƒ','ƒ‡','„ƒ','€‘‘‹€');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST10[I]+INFIX);
  UNTIL FOUND OR (I = MAX10);
  STEM_10 := FOUND;
END;

FUNCTION STEM_16 (INFIX : STR10) : BOOLEAN;
       (*=======*)
  CONST
    MAX16 = 19;
    LIST16 : ARRAY [1..MAX16] OF STRING [9] =
('','“•',
'‚„•','‚‡„•','‚‡„ƒ','‚›„•',
'†“•','„ƒ','‹','',
'€•','’„•',
'……„•','„•','‘‚‘','“•',
'€‘€•','‘„ƒ','•');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST16[I]+INFIX);
  UNTIL FOUND OR (I = MAX16);
  STEM_16 := FOUND;
END;

FUNCTION ROOT_43 : BOOLEAN;
       (*=======*)
  CONST
    MAX43 = 15;
    LIST43 : ARRAY [1..MAX43] OF STRING [11] =
('‹…','‚…','„…','‡€’…','€','‹€','‹…‹…',
'€','…','‘…','‘…','’€','•€','—€','—“');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST43[I]);
  UNTIL FOUND OR (I = MAX43);
  ROOT_43 := FOUND;
END;

FUNCTION ROOT_106 : BOOLEAN;
       (*========*)
  CONST
    MAX106 = 21;
    LIST106 : ARRAY [1..MAX106] OF STRING [11] =
('','ƒƒ','ƒ•','‚•','‹…','‹','‹•',
'“„€•','‹……','‹','…','…ƒ','','‘’…',
'’','’','•‹','••','…','™…','™……'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TEST (LIST106[I],COPY(TKN,1,LENGTH(TKN)-1));
  UNTIL FOUND OR (I = MAX106);
  ROOT_106 := FOUND;
END;

FUNCTION ROOT_111 : BOOLEAN;
       (*========*)
  CONST
    MAX111 = 28;
    LIST111 : ARRAY [1..MAX111] OF STRING [11] =
('…—','‡†','“—','‚……‡†','‚……™','‚‡†', 
'‚—','„…†','„……‡†','„—','„†','„›','†“††', 
'†“—','‡‚“—','—','‹…†','‹—','“—','—','›—',
'™','›—','‘’“—','’—','’…™','“—','“'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST111[I]);
  UNTIL FOUND OR (I = MAX111);
  ROOT_111 := FOUND;
END;

FUNCTION ROOT_217 : BOOLEAN;
       (*========*)
  CONST
    MAX217 = 13;
    LIST217 : ARRAY [1..MAX217] OF STRING [11] =
('','‡','ƒ€‹','ƒ‹','ƒ“','ƒ“',
'„“','‡‚…‡','‡“','“','…','‘','’›');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST217[I]+'„');
  UNTIL FOUND OR (I = MAX217);
  ROOT_217 := FOUND;
END;

FUNCTION ROOT_219 : BOOLEAN;
       (*=======*)
  CONST
    MAX219 = 7;
    LIST219 : ARRAY [1..MAX219] OF STRING [11] =
('“•','“•','‚…','‹…','•','›•','’€€•');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST219[I]+'’');
  UNTIL FOUND OR (I = MAX219);
  ROOT_219 := FOUND;
END;

FUNCTION ROOT_225 : BOOLEAN;
       (*========*)
  CONST
    MAX225 = 13;
    LIST225 : ARRAY [1..MAX225] OF STRING [11] =
('ƒ…','','’…','‘','','‘','‘',
'•','•€','‘‚…','‘','','“');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST225[I]);
  UNTIL FOUND OR (I = MAX225);
  ROOT_225 := FOUND;
END;

FUNCTION ROOT_227 : BOOLEAN;
       (*========*)
  CONST
    MAX227 = 26;
    LIST227 : ARRAY [1..MAX227] OF STRING [11] =
('€‹€“','€','•€','‚…','‚‚€',
'‚‘’…','ƒ€','ƒ€','†','‡€','‹€',
'€','‘€','‘‚','‹€','‹•€', 
'€ƒ','€€”…','…','•','', 
'…','‘……','’€','’€”€…','—€');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST227[I]+'’');
  UNTIL FOUND OR (I = MAX227);
  ROOT_227 := FOUND;
END;

FUNCTION ROOT_211 : BOOLEAN;
       (*========*)
  CONST
    MAX211 = 6;
    LIST211 : ARRAY [1..MAX211] OF STRING [11] =
('‚‹','‚€','€','…','‘‚','’ƒ');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST211[I]+'’');
  UNTIL FOUND OR (I = MAX211);
  ROOT_211 := FOUND;
END;

FUNCTION STEM_211 : BOOLEAN;
       (*========*)
  CONST
    MAX211 = 13;
    LIST211 : ARRAY [1..MAX211] OF STRING [11] =
('‚‡“','‚‘•','‡€™','ƒ€','€','‘‚…','™“',
'ƒ‹','€','‘…','‘‚…','‘“','“');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (COPY(TKN,1,LENGTH(TKN)-1) = LIST211[I]);
  UNTIL FOUND OR (I = MAX211);
  STEM_211 := FOUND;
END;

FUNCTION ROOT_229 : BOOLEAN;
       (*========*)
  CONST
    MAX229 = 181;
    LIST229 : ARRAY [1..MAX229] OF STRING [11] =
('€‚€‹','€€',
'€‹€ƒ€','€','€‹€ƒ“','€€€','€‡€',
  '€‡‹€','€‹€‹','€‹€','€•‚€‹',
  '…„“','‹‚€','—…','“’€‹','“‡›',
  '“’…’…','“””','“',
'‚€ƒ€','‚‡„','‚‹›','‚‹','‚',
  '‚‹',
'ƒ‹€','ƒ‹€','ƒ','ƒ€','ƒ“',
'„…','„…€','„…†“','„‹„','„€',
  '„“„','„“€',
'…ƒ','………','‡‚‹',
'†€‹','†€','†…€','†‹','†“','†“‹',
'‡€','‡€„','‡‹','‡“‘€‹','‡‚‹',
'€‹€“','€’…‹','€”‹','€€“‹',
  '€€’“','€€','…€','‹','…',
  '‡‹','‘›‹','—…ƒ€','€',
  '€•€‹','“—','‘…','“›','“', 
'‹','‹–……',
'€„€','…','…’…‹','“‹','“','‡‹',
  '’','—€‹','™','“‘‹','›‹','›’€',
'',
'€€‹‹…‹','€’','…','…„€‹','…„',
  '…„‹','…’…‹','…—€‹','€','„',
  '†','ƒ€','‹‚','‡‚‹','‡',
  '“','‚','“„','“†','“‡›',
  '“•','‹', 
'€','…‡','€','“', 
'‘€‹','‘€ƒ','‘€„€‹','‘','‘ƒ€‹','‘‹',
  '‘€‹','‘€„€‹','‘…‹','‘’','‘‹','‘',
  '‘‘','‘’€€','‘’€','‘“','‘“’“‹', 
'’€€','’€“','’€‹','’€€€','’€€','’€',
  '’€€’','’……€’“','’…’…','’€','’‚€',
  '’›','’€‹','’€†','’‹‹','’…‡‚',
  '’“€','’›','’', 
'“„€',
'”€”€','”€‘','”‹','”‘€‹','”’‹',
  '”“’‹','”“”›',
'•€‹’“','•…','•‹','••','•“‹ƒ€', 
'–……','–›ƒ€',
'—€‹','—‚€','—…€','—…','—', 
'€€‹','€','','‹','“','',
  '€„','€','','','’',
  '’“€’“', 
'™…','™…’','™“'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;

BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST229[I]);
  UNTIL FOUND OR (I = MAX229);
  ROOT_229 := FOUND;
END;

FUNCTION STEM_229 : BOOLEAN;
       (*========*)
  CONST
    MAX229 = 48;
    LIST229 : ARRAY [1..MAX229] OF STRING [13] =
('€€‹','‚„€','‚…','‚’',
'ƒ‘“„€','‡€‹','‡€•','‡€€‹','‡€€‹', 
'€…‚€','“€','“’‡€','“•€',
'…‡‹','…‡„‹','…‡†','…‘–…',
  '…‘‘‹','…‘‘‹','—“','“‹’“',
  '‘‚……','’','’‹›',
'„—…','‡‚‹','‘€','…‡',
  '„','“‘’‡‚', 
'€‘…‹','€‘‘', 
'‘‘’‹','‘‹','‘‹€ƒ‡‚‹','‘‘',
  '‘“‘‹',
'’','’€‹',
'“„‘’‚…','“‘','“‘’€€','“’•',
'”ƒ‹','”‹','•‹','—€€','€€');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST229[I]);
  UNTIL FOUND OR (I = MAX229);
  STEM_229 := FOUND;
END;

FUNCTION ROOT_231 : BOOLEAN;
       (*========*)
  CONST
    MAX231 = 54;
    LIST231 : ARRAY [1..MAX231] OF STRING [11] =
('€‚','“€‚','“‚','‚€','ƒ‹€‚','ƒ“‘€‚','ƒ’‚',
'ƒ€','ƒ','ƒ‹“','„…‰”','„›','„›‚','‡„€‚',
'‡‹','‡‹‘‹‚','‡€','‡›','€‹›','€’€‚',
'’€“','','‚€‚','“„‚','“—€‚',
'‹€','‹“€‚','€„“','…‡„‚','€‚',
'‹”','‘','‹€‚','„','•€','€‚',
'’‚','','‘‹€','‘‹€‚','‘‹‚','‘’€‚',
'‘“','‘','‘—€‘’‹‚','’€”','’™…‘‹€‚',
'“','“‘‹‚','”€‹‚','……‹‚',
'’€”','““','');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST231[I]);
  UNTIL FOUND OR (I = MAX231);
  ROOT_231 := FOUND;
END;

FUNCTION STEM_231 : BOOLEAN;
       (*========*)
  CONST
    MAX231 = 33;
    LIST231 : ARRAY [1..MAX231] OF STRING [11] =
('‡€›','‡›','‹›','€„“','€‘“','‹€',
'…‘‚','…‘“','€‡“','‘‹€',
'‘’‘‹‚','„‘“„','…‘‹‚','‘‘',
'ƒ“','†','‘‚“','‹','€‡„‘‹‚',
'“‘’‘‹‚','€‡‡‚','‘‚…‘‹‚','‘‹€‚‘‹‚',
'‘„','‘…‘‚','‘€‘‹‚','‘“…‘‹‚','‘“’‚',
'’€”','“ƒ','“‚…„','“','“‘“ƒ“');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST231[I]);
  UNTIL FOUND OR (I = MAX231);
  STEM_231 := FOUND;
END;

FUNCTION ROOT_236 : BOOLEAN;
       (*========*)
  CONST
    MAX236 = 95;
    LIST236 : ARRAY [1..MAX236] OF STRING [11] =
('€’€—','€’’€—','€’€—','“„€†','›—','‚…„€—', 
'‚…‹—','‚†','‚—','ƒ‹—','ƒ€—','„—','„“€—',
'„†','…†','…','††','†“—','‡€—','’†','€—',
'€—','€‹…—','†','’€—','…†','—',
'‘€—','‘—','‘—','—…‚†','—','“†',
'“€†','“—','“‘—','“—','€…†','€—','……™', 
'†','‘’—','—','“›†','“—','€‡€—', 
'€’“†','…„“†','…†','—’†','……—','…‘—','‹™',
'—','’€—','—','—','“†','’—','“€—', 
'›†','€‘“‹€—','€‘’€†','…—','“','›€—',
'‘‚—','‘€—','‘…„’—','‘—','‘“„€—','‘“€’',
'’€‹„›—','’‚†','’…','’‹€—','’—','’…‚†',
'’…†','“‚…—','“’†','”ƒ€—','”„›€—','•…€—',
'•—','•—','•…€—','—€’','—…“—','—…›†',
'—““—','—“„€—','€€','€„€€','™“—');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST236[I]);
  UNTIL FOUND OR (I = MAX236);
  ROOT_236 := FOUND;
END;

FUNCTION STEM_236 : BOOLEAN;
       (*========*)
  CONST
    MAX236 = 54;
    LIST236 : ARRAY [1..MAX236] OF STRING [11] =
('“‹ƒ€—','‚‡“—','‚€„—','‚‘‹—','‚’…',
'‡€€—','‡€’“—','€—','‹…‚€—','€‘’€—','€•‹“—',
'…‡‹—','…‡“†','…‘…—','…‘’—','‹€', 
'€„…†','€‹—','€“†','—…›†','—…“—',
'ƒ‹“','ƒ','‡€„€—','‡‚“—','‹€—','…',
'‘…†','’‚€†','’‹—','’‹—','’—…›†’', 
'’›€—','—…‹‚…—','€€','……€—','„€—',
'„›’†','‘—','“—','’‚…—','€‘‹…', 
'€‘’…‹…','‘†','‘…†','‘‘“—','‘’…†','“‚€†',
'“‚…‚…—','“„‘“†','“','“‹…’“—','“‹—','“’'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST236[I]);
  UNTIL FOUND OR (I = MAX236);
  STEM_236 := FOUND;
END;

FUNCTION ROOT_238 : BOOLEAN;
       (*========*)
  CONST
    MAX238 = 14;
    LIST238 : ARRAY [1..MAX238] OF STRING [11] =
('‘','‚…‘','‚›‘','ƒ“„‘','„“€‘',
'‚€‘','‹€‘','€‘','“„…‘','“‹…‘',
'‹…‘','‹‘','›‹…‘‘','—“„…‘');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST238[I]);
  UNTIL FOUND OR (I = MAX238);
  ROOT_238 := FOUND;
END;

FUNCTION STEM_238 : BOOLEAN;
       (*========*)
  CONST
    MAX238 = 10;
    LIST238 : ARRAY [1..MAX238] OF STRING [13] =
('‹‘','…‡ƒ‹€‘','…‡€‘','›‘','‘',
'……’“‘','‘’‚‹‘','“€‚‚…‘','‘’“‘','’“‘'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST238[I]);
  UNTIL FOUND OR (I = MAX238);
  STEM_238 := FOUND;
END;

FUNCTION ROOT_240 : BOOLEAN;
       (*========*)
  CONST
    MAX240 = 15;
    LIST240 : ARRAY [1..MAX240] OF STRING [11] =
('…','‚€','ƒ€','ƒ‹€','ƒ“','‹','‹€',
'‹•€','ƒ','“','€‘“',
'€','“','•‚',''); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST240[I]+'„');
  UNTIL FOUND OR (I = MAX240);
  ROOT_240 := FOUND;
END;

FUNCTION STEM_240 : BOOLEAN;
       (*========*)
  CONST
    MAX240 = 12;
    LIST240 : ARRAY [1..MAX240] OF STRING [13] =
('€ƒ…‰','‚…•‚','‡€‹€ƒ€‘‘“','‚',
'…‡‚','…‡‚…','…‡‹','‹€ƒ',
'…‘‹','“','€€','€‘ƒ'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST240[I]+'„');
  UNTIL FOUND OR (I = MAX240);
  STEM_240 := FOUND;
END;

FUNCTION ROOT_244 : BOOLEAN;
       (*========*)
  CONST
    MAX244 = 19;
    LIST244 : ARRAY [1..MAX244] OF STRING [11] =
('…‡€','‹','“’“','‚€‹’“','‚‹’“','ƒ‹€',
'…‹','‡','€','’“','”“','“ƒ“',
'‹€','','“’“','','€','…','“');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LIST244[I]+'‡');
  UNTIL FOUND OR (I = MAX244);
  ROOT_244 := FOUND;
END;

FUNCTION STEM_244 : BOOLEAN;
       (*========*)
  CONST
    MAX244 = 7;
    LIST244 : ARRAY [1..MAX244] OF STRING [11] =
('€‹€','ƒ…','…‡ƒ€','…‡‡€€',
'‹€ƒ€','“†“€','€‡€');
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TKN = LIST244[I]+'‡');
  UNTIL FOUND OR (I = MAX244);
  STEM_244 := FOUND;
END;

PROCEDURE ALFIN (VAR TKN : STR115;
        (*=====*)VAR CLS : INTEGER;
                 SYA : BOOLEAN);
  VAR
    L : INTEGER;
    INIT : STRING [7];
    S : BOOLEAN;
BEGIN
  L := LENGTH(TKN);
  INIT := COPY(TKN,1,L-2);
  S := FALSE;

  IF TST('›‡ƒ') OR TST('“•') 
    OR TST('‚…') OR TST('ƒ‹„') 
    OR TST('„‚ƒ') OR TST('„…‹')    
    OR TST('„‹†') OR TST('€—‚') 
    OR TST('€') OR TST('…’') 
    OR TST('…') OR TST('…™')
    OR TST('‘’') OR TST('›‘') 
    OR TST('“…') OR TST('“—')
    OR TST('—’') OR (TKN='‚›€•') 
    OR (TKN='‡€›•') OR (TKN='—') 
    OR (TKN='€—') OR (TKN='†') 
    OR (TKN='……€‘’') OR (TKN='‘“†') 
    OR (TKN='“›•') 
    THEN SETCL(CLS,4,3,SYA)
  ELSE IF (COPY(TKN,L-1,2)='‚')
    THEN 
      IF TST('‡„‚') OR TST('•‚')
        OR (TKN='“ƒ’‚') OR (TKN='“‚')
        THEN SETCL(CLS,4,3,SYA)
        ELSE SETCL(CLS,34,30,SYA) (*“„‚€’*)
  ELSE IF (COPY(TKN,L-1,2)='…‚')
    THEN
      IF ROOT_3EV OR STEM_3EV
        THEN SETCL(CLS,4,3,SYA) (*‚‹€„…’*) 
      ELSE IF POS (TKN [L-2],AFFR) > 0
        THEN SETCL(CLS,82,39,SYA) (*†…‚€’*)
        ELSE SETCL(CLS,35,31,SYA) (*‹…‚€’*)
  ELSE IF TST('‘') 
    THEN SETCL(CLS,281,280,SYA)
  ELSE IF TST('„') OR TST('‘‡„')
    THEN SETCL(CLS,24,22,SYA)
  ELSE IF TST('„€‚') OR TST('‘‡„€‚') 
    OR TST('‡€‚') OR TST('‘’€‚')
    THEN SETCL(CLS,83,71,SYA)
  ELSE IF (TKN='‘›')
    THEN SETCL(CLS,247,246,TRUE)
  ELSE IF TST('—') 
    THEN SETCL(CLS,129,128,SYA)
  ELSE IF TST('‘’')
    THEN SETCL(CLS,95,77,SYA)
  ELSE IF TST('…•')
    THEN SETCL(CLS,110,109,SYA)
  ELSE IF TST('…†')
    THEN SETCL(CLS,84,20,SYA)
  ELSE IF TST('‡‚')
    THEN
      IF (L>2) AND ((COPY(TKN,L-4,3)='') 
        OR (COPY(TKN,L-4,3)='’') 
        OR (COPY(TKN,L-5,4)='„'))
        THEN SETCL(CLS,182,183,SYA)
        ELSE SETCL(CLS,85,75,SYA)
  ELSE IF TST('‘') OR TST('‹‘') 
    OR TST('’…‘')OR TST('—…‘') 
    THEN SETCL(CLS,86,59,SYA)
  ELSE IF (TKN='†‚‘')
    THEN SETCL(CLS,287,286,SYA)
  ELSE IF TST('ƒ‹„')
    THEN SETCL(CLS,101,104,SYA)
  ELSE IF TST('‹…‚…’') OR TST('’') 
    OR TST('‘…†…’') OR TST('’……’')
    THEN SETCL(CLS,9,105,SYA)
  ELSE IF ROOT_106
    THEN SETCL(CLS,108,106,SYA) (*‹……’€’*)
  ELSE IF TST('’')
    THEN SETCL(CLS,263,262,SYA)
  ELSE IF TST('€•') OR TST('€•') 
     OR TST('›•') OR TST('…•') 
    THEN SETCL(CLS,147,125,SYA)
  ELSE IF TST('‹›•')
    THEN SETCL(CLS,265,264,SYA)
  ELSE IF TST('•‹…‘’') OR TST('‘‚‘’') 
    OR TST('„‘’') OR TST('•‹›‘’') 
    OR TST('•‹›‘’')
    THEN SETCL(CLS,148,126,SYA)
  ELSE IF TST('†')
    THEN
      IF (L=1) OR (POS(TKN[L-1],SONOR) > 0)
        THEN SETCL(CLS,87,74,SYA)
        ELSE SETCL(CLS,113,119,SYA)
  ELSE IF TST('ƒ')
    THEN SETCL(CLS,178,179,SYA)
  ELSE IF TST('ƒ')
    THEN SETCL(CLS,88,70,SYA)
  ELSE IF TST('') AND ((INIT='€‡') 
    OR (INIT='„€‡') OR (INIT='’') 
    OR (INIT='') OR (INIT='„') 
    OR (INIT='‚') OR (INIT='‚‡'))
    THEN SETCL(CLS,184,185,SYA)
  ELSE IF TST('„') AND ( (INIT='‡') 
    OR (INIT='‡') OR (INIT='€‡') 
    OR (INIT='’') OR (INIT='') 
    OR (INIT='‘') )
    THEN SETCL(CLS,175,174,SYA)
  ELSE IF TST('') OR TST('„')
    THEN SETCL(CLS,57,56,SYA)
  ELSE IF TST('‚') OR TST('†€†„') 
    OR TST('†„') OR TST('†') 
    OR TST('') OR TST('') 
    OR TST('‚') OR TST('†') 
    OR TST('‘‘') OR TST('‘’') 
    OR TST('‘') OR TST('’') 
    OR (TKN='‘’€†„') 
    THEN SETCL(CLS,12,60,SYA)
  ELSE IF TST('‘‹›')
    THEN SETCL(CLS,254,253,SYA)
  ELSE IF ROOT_111  (*„…†€’*)
    THEN SETCL(CLS,112,111,SYA)
  ELSE IF TST('‘€‡') OR TST('€‡') 
    OR TST('‚‡') OR TST('‹‡')
    OR TST('‡') OR (TKN='‡')
    THEN SETCL(CLS,2,1,SYA)
  ELSE IF TST('…‡') OR TST('€‡')
    THEN SETCL(CLS,99,102,SYA)
  ELSE IF TST('‘') OR TST('›‘') 
    OR TST('‹‘') OR TST('›‘') 
    OR TST('‹…‘') OR TST('“‹…‘')
    THEN SETCL(CLS,89,76,SYA)
  ELSE IF TST('‘€')
    THEN SETCL(CLS,271,270,SYA)
  ELSE IF TST('“‹›') OR TST('‹€')
    OR TST('•›') OR TST('“‹›') 
    THEN SETCL(CLS,100,103,SYA)
  ELSE IF TST('’…') OR TST('‹…') 
    OR TST('„…') OR TST('™') 
    THEN SETCL(CLS,36,32,SYA)
  ELSE IF TST('‘‹')
    THEN SETCL(CLS,123,122,SYA)
  ELSE IF (TKN='€‡‘’‹')
    THEN SETCL(CLS,269,279,SYA)
  ELSE IF (TKN='„‘’‹')
    THEN SETCL(CLS,276,284,SYA)
  ELSE IF TST('‘’‹')
    THEN SETCL(CLS,168,167,SYA)
  ELSE IF (TKN='ƒ‹€ƒ‹')
    THEN SETCL(CLS,249,248,SYA)
  ELSE IF TST('›‡ƒ') 
    THEN SETCL(CLS,98,107,SYA)
  ELSE IF TST('‘‘')
    THEN SETCL(CLS,165,164,SYA)
  ELSE IF TST('‘')
    THEN SETCL(CLS,171,170,SYA)
  ELSE IF TST('‹ƒ')
    THEN SETCL(CLS,187,186,SYA)
  ELSE IF (TKN='')
    THEN 
      BEGIN 
        S := TRUE;
        SETCL(CLS,0,268,FALSE);
      END
  ELSE IF TST('‹') OR TST('') OR TST('')
    THEN 
      BEGIN 
        S := TRUE;
        SETCL(CLS,62,61,SYA);
      END
  ELSE SETCL(CLS,4,3,SYA);

  IF S 
    THEN TKN:=TKN+'€‘’' 
    ELSE TKN:=TKN+'€’';
END;

FUNCTION ELINF_D6 (TKN:STR115) : BOOLEAN;
       (*=======*)
BEGIN
  ELINF_D6 := TST('…€‚„') 
    OR TST('„') OR TST('‚„'); 
END; 

FUNCTION ELINF_ST (TKN:STR115) : BOOLEAN;
       (*=======*)
BEGIN
  ELINF_ST := TST('‹…‘’') OR TST('‘‚‘’') 
    OR TST('‘‚‘’') OR TST('•“‘’') 
    OR TST('…‹…‘’'); 
END; 

FUNCTION ELINF_L (TKN:STR115) : BOOLEAN;
       (*=======*)
BEGIN
  ELINF_L := TST('ƒ…') OR TST('') OR TST('’…') 
    OR TST('‘') OR TST('') OR TST('‘')
    OR TST('‘') OR TST('•') OR TST('•€') 
    OR TST('‘‚…') OR TST('‘') OR TST('')
    OR TST('“');
END; 

FUNCTION ELINF (TKN:STR115) : BOOLEAN;
       (*=======*)
BEGIN
  ELINF := TST('‚…‹') OR TST('ƒ')
    OR TST('‘’') OR TST('‡‚…')
    OR (TKN='…‡') OR (TKN='‡');
END;

PROCEDURE ELFIN(VAR TKN : STR115;
        (*====*)VAR CLS : INTEGER;
                SYA : BOOLEAN);
BEGIN
  TNS:=PAST;
  IF TST('') OR TST('‚‹€„')
    OR TST('‘') 
      AND (TKN<>'‚‘') AND (TKN<>'‘')
    OR (TKN='‚‡›') OR (TKN='…‡†') 
    OR (TKN='‹“')
    THEN 
      BEGIN
        SETCL(CLS,4,3,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF (TKN='‡€‚‘')
    THEN 
      BEGIN      (*‡€‚‘…’*)
        SETCL(CLS,224,250,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('‚‘')
    THEN 
      BEGIN       (*‚‘…’*)
        SETCL(CLS,224,223,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF ROOT_217
    THEN
      BEGIN      (*ƒ‹„…’*) 
        SETCL(CLS,218,217,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF ELINF_D6(TKN)
    THEN 
      BEGIN      (*„…’*)
        SETCL(CLS,267,266,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF ROOT_219
    THEN 
      BEGIN       (*‹…’…’*)
        SETCL(CLS,220,219,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF ELINF_ST (TKN)
    THEN
      BEGIN      (*‹…‘’…’*)
        SETCL(CLS,222,221,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF ELINF_L (TKN)
    THEN 
      BEGIN      (*ƒ……’*)
        SETCL(CLS,226,225,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF ELINF (TKN)
    THEN
      BEGIN      (*ƒ…’*)
        SETCL(CLS,90,41,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('')
    THEN
      BEGIN         (*…’*)
        SETCL(CLS,142,141,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('„') OR (TKN='‚‘’')
    THEN
      BEGIN      (*„…’*)
        SETCL(CLS,95,77,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('…‹')
    THEN 
      BEGIN     (*…‹…’*)
        SETCL(CLS,0,188,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('…‚')
    THEN
      BEGIN     (*…‚…’*)
        SETCL(CLS,79,78,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('•’')
    THEN
      BEGIN    (*•’…’*)
        SETCL(CLS,115,114,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('')
    THEN
      BEGIN         (*…’*)
        SETCL(CLS,0,130,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('')
    THEN
      BEGIN         (*…‘’*)
        SETCL(CLS,55,54,SYA);
        TKN:=TKN+'…‘’';
      END
  ELSE IF TST('‚') OR TST('')
    THEN
      BEGIN         (*‚…‘’*)   
        SETCL(CLS,58,42,SYA);
        TKN:=TKN+'…‘’';
      END
  ELSE IF TST('‘')
    THEN
      BEGIN         (*‘…‘’*)
        SETCL(CLS,144,143,SYA);
        TKN:=TKN+'…‘’';
      END
  ELSE IF TST(DUMMY) 
    THEN
      BEGIN         (*…‘’*)
        SETCL(CLS,29,25,SYA);
        TKN:=TKN+'…‘’';
      END
  ELSE IF TST('—')
    THEN
      BEGIN     (*“—…‘’*)
        SETCL(CLS,44,45,SYA);
        TKN:=TKN+'…‘’';
      END
  ELSE IF TST('‹') OR TST('') 
    OR TST('') OR TST('–‚')
    THEN
      BEGIN     (*‹…‘’*)
        SETCL(CLS,55,54,SYA);
        TKN:=TKN+'…‘’';
      END
  ELSE 
    BEGIN       (*…„…’*)
      SETCL(CLS,4,3,SYA);
      TKN:=TKN+'…’';
    END;

  IF SYA
    THEN
      IF TKN[LENGTH(TKN)]=''
        THEN TKN:=TKN+'‘'
        ELSE TKN:=TKN+'‘';
END;

PROCEDURE ILFIN (VAR TKN:STR115;
        (*=====*)VAR CLS:INTEGER;
                 SYA:BOOLEAN);
  VAR
    L : INTEGER;

BEGIN
  L := LENGTH(TKN);
  TNS := PAST;

  IF TST('•€') OR  TST('„…‹') 
    OR (TKN='„‚') OR (TKN='’')
    OR TST('‘‹') AND (TKN<>'…‘‘‹')
    THEN SETCL(CLS,8,7,SYA)          (*‘‹’*)
  ELSE IF TST('‚') 
    THEN
      IF (L=1) OR (POS(TKN[L-1],SONOR) > 0)
        THEN SETCL(CLS,37,33,SYA)
        ELSE SETCL(CLS,134,133,SYA)
  ELSE IF TST('‹') 
    THEN
      IF (L=1) OR (POS(TKN[L-1],SONOR) > 0)
        THEN SETCL(CLS,37,33,SYA)
        ELSE SETCL(CLS,136,135,SYA)
  ELSE IF TST('')
    THEN
      BEGIN 
        IF (TKN='')
          THEN SETCL(CLS,196,195,SYA)
        ELSE IF (TKN='€„') OR (TKN='„‘') 
          OR (TKN='„“') OR (TKN='‘') 
          OR (TKN='€„')
        THEN SETCL(CLS,194,193,SYA)
        ELSE IF ((L=1) OR (POS (TKN[L-1],SONOR) > 0))
          THEN SETCL(CLS,37,33,SYA)
          ELSE SETCL(CLS,132,131,SYA)
      END
  ELSE IF TST('')
    THEN
      BEGIN 
        IF (TKN='')
          THEN SETCL(CLS,198,197,SYA) (*’*)
        ELSE IF (TKN='‘') OR (TKN='€‘') 
          THEN SETCL(CLS,200,199,SYA) (*€‘’*)
        ELSE IF (TKN='‚') OR (TKN='’')
          OR (TKN='‚‡')            
          THEN SETCL(CLS,194,193,SYA) (*’’*)
        ELSE IF ((L=1) OR (POS(TKN[L-1],SONOR) > 0))
          THEN SETCL(CLS,37,33,SYA)   (*‡€’*)
        ELSE SETCL(CLS,138,137,SYA)   (*’’*)
      END
  ELSE IF (TKN='—€‰') 
    THEN SETCL(CLS,37,33,SYA)       (*—€‰’*)
  ELSE IF TST('') 
    THEN
      BEGIN
        IF (TKN='‘') OR (TKN='€‘') 
          THEN SETCL(CLS,202,201,SYA) (*€‘’*)
        ELSE IF (TKN='„“')
          THEN SETCL(CLS,15,14,SYA)   (*„“’*)
        ELSE IF ((L=1) OR (POS(TKN[L-1],SONOR) > 0))
          THEN SETCL(CLS,37,33,SYA)   (*€’*)
        ELSE SETCL(CLS,140,139,SYA)   (*„’*)
      END
  ELSE IF (TKN='‡†„') (*‡†„’*)
    THEN SETCL(CLS,243,242,SYA)
  ELSE IF (TKN='—') OR (TKN='—') OR (TKN='ƒ')
    THEN SETCL(CLS,4,3,SYA)             (*—’*)
  ELSE IF TST('')                    (*“’*)
    THEN SETCL(CLS,17,81,SYA)
  ELSE IF (POS(TKN[L],LCONS) > 0)
    AND (POS(TKN[L-1],SONOR+'‹’‡‰•') > 0)
    THEN  
      IF ROOT_231 OR STEM_231
        THEN SETCL(CLS,232,231,SYA)   (*ƒ’/*)
        ELSE SETCL(CLS,194,193,SYA) 
  ELSE IF TST('†')                    (*/†’*)
    AND (TKN<>'‡…†') AND (TKN<>'‡€…†')
    AND (TKN<>'…†') AND (TKN<>'€‡…†') 
    THEN SETCL(CLS,94,93,SYA)
  ELSE IF (TKN[L] = '„')
    THEN
      IF TST('—“„')   (*—“„’/„<>—“„’‘/„‘*)
        THEN SETCL(CLS,241,203,SYA)
      ELSE IF (TKN='•“„')                 (*•“„’*)
        THEN SETCL(CLS,8,7,SYA) 
      ELSE IF ROOT_240 OR STEM_240
        OR TST('‹€„') 
          AND (TKN<>'€‘‹€„') AND (TKN<>'“‘‹€„') 
        THEN SETCL(CLS,241,240,SYA)   (*€ƒ€„’/„*)
        ELSE SETCL(CLS,204,203,SYA)   (*“„’/„*)
  ELSE IF (TKN[L] = '‡')
    THEN 
      IF ROOT_244 OR STEM_244
        OR TST('€‚‡') AND (TKN<>'€‚‡') 
        THEN SETCL(CLS,245,244,SYA)   (*…‹‡’/‡*)
        ELSE SETCL(CLS,206,205,SYA)   (*‚‡’/‡*)
  ELSE IF (TKN[L] = '‘')
    THEN 
      IF ROOT_238 OR STEM_238
        OR TST ('’“‘') AND (TKN<>'‚›’“‘') 
        THEN SETCL(CLS,239,238,SYA)   (*‘’/‘*)
        ELSE SETCL(CLS,208,207,SYA)   (*‘’/‘*)
  ELSE IF (COPY(TKN,L-1,2) = '‘’')
    THEN SETCL(CLS,210,209,SYA)       (*‘’’*)
  ELSE IF (TKN[L] = '’')
    THEN 
      BEGIN
        IF TST('—’')                  (*—’’/’“/’*)
          THEN SETCL(CLS,216,215,SYA)
        ELSE IF (TKN='‘‚…’') OR (TKN='‡€‘‚…’') 
          OR (TKN='‡……’')
          THEN SETCL(CLS,214,213,SYA) (*‡€‘‚…’’/—“/’*)
        ELSE IF ROOT_211 OR STEM_211
          THEN SETCL(CLS,212,211,SYA) (*’ƒ’’/™“/’*)
        ELSE IF TST('‘›’')            
          OR (TKN='•’') OR (TKN='€‘•’') 
          THEN SETCL(CLS,273,272,SYA) (*•’’/™“/’*)
        ELSE 
          IF ROOT_227 
            OR TST('’') AND (TKN<>'‚›’')
            OR TST('……’') AND (TKN<>'‡……’') 
            OR (TKN='‡€‹’') OR (TKN='‘‚’') 
            OR (TKN='•€’') OR (TKN='…‘‘…’') 
            OR (TKN='…‘–‚…’') OR (TKN='€’') 
            OR (TKN='‘€“’') OR (TKN='‘›’') 
            OR (TKN='‘’')
            THEN SETCL(CLS,228,227,SYA) (*‚‘’…’’/—“/’*)
        ELSE SETCL(CLS,214,213,SYA);    (*’’/—“/’*)
      END
  ELSE IF (POS(TKN[L],AFFR) > 0)
    THEN 
      BEGIN
        IF (TKN='’“†') OR (TKN='‘…') 
          THEN SETCL(CLS,237,14,SYA) 
                           (*’“†’/†<>’“†’‘/†‘*)
        ELSE IF ROOT_236 OR STEM_236
          OR TST('‹€—') 
            AND (TKN<>'‚‹€—') AND (TKN<>'‹€—')
          OR TST('“—') AND (TKN<>'‚›“—')
          THEN SETCL(CLS,237,236,SYA)     (*€‹…—’/—*)
        ELSE SETCL(CLS,15,14,SYA)         (*‡€—’/—*)
      END
  ELSE IF TST('') AND (TKN<>'€‡„') 
    THEN SETCL(CLS,91,40,SYA)         (*’*)
  ELSE IF TST('ƒ')
    THEN SETCL(CLS,4,3,SYA)           (*ƒ’*)
  ELSE IF TST('‘’…‹')
    THEN SETCL(CLS,121,120,SYA)       (*‘’…‹’*)
  ELSE IF (POS(TKN[L],'‹') > 0)
    THEN  
      IF ROOT_229 OR STEM_229
        OR TST('‚…') AND (TKN<>'‚›‚…')
        OR TST('‡€') AND (TKN<>'‡€')
        OR TST('€') 
          AND (TKN<>'‘€') AND (TKN<>'‚‘€')
        OR TST('…') AND (TKN<>'…')
        OR TST('•“') AND (TKN<>'•“')
        OR TST('–…‹') AND (TKN<>'‘–…‹')
        THEN SETCL(CLS,230,229,SYA)   (*‚‡„’/*)
        ELSE SETCL(CLS,8,7,SYA)       (*„€’/*)
  ELSE IF (POS(TKN[L],SONOR) > 0)
    THEN 
      IF TST('„€') OR TST('‹…') 
        OR TST('') OR TST('') 
        OR TST('‘‚') OR TST('‘’')
        OR TST('„‚') AND (TKN<>'„‚') 
        OR (TKN='‹€ƒ“‘’') OR (TKN='‡€ƒ€') 
        OR (TKN='‘’') OR (TKN='’“„“‘’') 
        OR (TKN='“„‘’') OR (TKN='“’')
        THEN SETCL(CLS,234,233,SYA)   (*‘’’/‰*)
        ELSE SETCL(CLS,8,7,SYA)       (*„’/*)
    ELSE CLS := 0;
  TKN:=TKN+'’';
END;

PROCEDURE YALFIN(VAR TKN : STR115;
        (*=====*)VAR CLS : INTEGER;
                 SYA : BOOLEAN);
    VAR
      L:INTEGER;

BEGIN
  L:=LENGTH (TKN);
  TNS := PAST;

  IF TST('‚') OR TST('‚‹') 
    OR (TKN='') OR (TKN='‘’') 
    OR (TKN='…‘') OR (TKN='‘“™…‘’‚‹') 
    THEN SETCL(CLS,4,3,SYA)     (*’*)
  ELSE IF (TKN='‚')          
    THEN SETCL(CLS,0,285,FALSE) (*‚’*)
  ELSE IF ROOT_43 OR (TKN='‚‡')
    THEN SETCL(CLS,92,43,SYA)     (*‘…’*)
  ELSE IF TST('‘’') OR TST('')
    THEN SETCL(CLS,118,117,SYA)   (*‘’’*)
  ELSE IF (TKN='‚‡')
    THEN SETCL(CLS,127,72,SYA)    (*‚‡’*)
  ELSE IF TST('')
    THEN 
      IF ((L=1) OR (POS(TKN[L-1],SONOR) > 0)) 
        THEN SETCL(CLS,152,151,SYA) (*€’*)
        ELSE SETCL(CLS,173,172,SYA) (*‘’*)
  ELSE IF TST('‚') OR TST('‘’')
    THEN SETCL(CLS,95,77,SYA)       (*“‚’*)
  ELSE IF TST('‘') OR (TKN='‚‘') 
    THEN SETCL(CLS,65,64,SYA)       (*‘’*)
  ELSE IF TST('')
    THEN
      CASE TKN [L-1] OF
        '': SETCL(CLS,67,66,SYA);
        '€','…','','“': SETCL(CLS,69,68,SYA);
        ELSE SETCL(CLS,65,64,SYA);
      END
  ELSE IF (TKN='‡') OR (TKN='’') 
    OR (TKN='„') OR (TKN='€‡') 
    THEN SETCL(CLS,278,277,SYA)     (*‡’*)
  ELSE IF (TKN='')
    THEN SETCL(CLS,283,282,SYA)     (*’*)
  ELSE IF (TKN='€‘')
    THEN SETCL(CLS,152,151,SYA)     (*€‘’*)
  ELSE IF TST('‹')
    THEN SETCL(CLS,150,149,SYA)     (*‹‘’*)
  ELSE SETCL(CLS,4,3,SYA);

  IF (CLS=150) OR (CLS=149) 
    THEN TKN:=TKN+'‘’'
    ELSE TKN:=TKN+'’';

  IF SYA
    THEN TKN:=TKN+'‘';
END;

PROCEDURE ULFIN (TKN:STR115;
        (*=====*)VAR CLS:INTEGER;
                 SYA:BOOLEAN);
  VAR
    L : INTEGER;

BEGIN
  L := LENGTH (TKN);
  TNS := PAST;

  IF TKN[L]=''
    THEN 
      BEGIN
        IF TST('ƒ') 
          OR TST('„‚') OR TST('„“') 
          OR TST('') OR TST('‹') 
          OR TST('') OR TST('‹') 
          OR TST('') OR TST('') 
          OR TST('‘’›') OR TST('‘“') 
          OR TST('’') OR TST('•‹›')
          OR (TKN='‚›') OR (TKN='ƒ‹') 
          OR (TKN='€') OR (TKN='€‡') 
          OR (TKN='‘ƒ') 
          THEN SETCL(CLS,275,274,SYA)
        ELSE IF TST('‚')           
          THEN SETCL(CLS,0,166,FALSE) (*‚“’/‚‹*)
        ELSE IF (TKN='ƒ') OR (TKN='„•') 
          OR (TKN='‘•') OR (TKN='„') 
          OR (TKN='„')  OR (TKN='‡')
          THEN SETCL(CLS,0,288,FALSE) (*ƒ“’/“‹/‹€*)
        ELSE IF (TKN='›„') 
          THEN SETCL(CLS,0,235,FALSE) (*›„“’/›„‹*)
        ELSE SETCL(CLS,53,16,SYA);  (*€–“’/€–“‹*)
      END
    ELSE SETCL(CLS,4,3,SYA);
END;

PROCEDURE YLFIN (TKN : STR115;
        (*=====*)VAR CLS : INTEGER;
                 SYA : BOOLEAN);
BEGIN
  IF TST('›‹')
    THEN SETCL(CLS,73,19,SYA)
  ELSE IF TST('‹›‹') OR TST('‘‹›‹')
    THEN SETCL(CLS,94,93,SYA)
  ELSE IF TST('‘’›‹') OR TST('‘’›‹')
    THEN SETCL(CLS,95,77,SYA)
  ELSE IF TST('›‹') OR TST('‚›‹') 
    OR TST('›‹') OR TST('›‹') OR TST('›‹')
    THEN SETCL(CLS,97,96,SYA)
  ELSE EROUT;
END;

PROCEDURE OIN (VAR TKN : STR115;
        (*===*)VAR CLS : INTEGER;
               SYA : BOOLEAN);
  VAR
    L : INTEGER;
BEGIN
  L:=LENGTH(TKN);
  CASE TKN[L-1] OF
  '’':IF (L>3) AND (TKN[L-2]='') AND (TKN[L-3]<>'')
        THEN
          BEGIN
            SETCL(CLS,158,157,SYA);
            IF TKN[L-3]='‡'
                THEN TKN[L-3]:='‘';
            TKN:=COPY(TKN,1,L-3)+'’……’';
         END
       ELSE
         BEGIN
           SETCL(CLS,63,46,SYA);
           TKN:=COPY(TKN,1,L-1)+'……’';
         END;
  '':IF(TKN='')
        THEN
          BEGIN
            SETCL(CLS,162,161,SYA);
            TKN:='……’';
          END
      ELSE IF (L>3) AND (TKN[L-2]='O') AND (TKN[L-3]<>'')
        THEN
          BEGIN
            SETCL(CLS,160,159,SYA);
            TKN:=COPY(TKN,1,L-3)+'……’';
          END
      ELSE
        BEGIN
          SETCL(CLS,63,46,SYA);
          TKN:=COPY(TKN,1,L-1)+'……’';
       END;
  '':IF (L>3) AND (TKN[L-2]='') AND (TKN[L-3]<>'')
        THEN
          BEGIN
            SETCL(CLS,0,163,SYA);
            TKN:=COPY(TKN,1,L-3)+'……’';
          END
        ELSE
          BEGIN
            SETCL(CLS,0,46,SYA);
            TKN:=COPY(TKN,1,L-1)+'……’';
          END;
  END;
END;

PROCEDURE UTFIN(VAR TKN : STR115;
        (*====*)VAR CLS : INTEGER;
                SYA : BOOLEAN);
VAR
  L : INTEGER;
  INIT : STR115;
BEGIN
  L:=LENGTH (TKN);
  CASE TKN [L] OF

    '':
IF TST('‘…')OR TST('ƒ…')
  THEN
    BEGIN
      TKN:=COPY(TKN,1,L-1)+'‘’';
      SETCL(CLS,80,11,SYA);
    END
ELSE IF TST('')
  THEN
    BEGIN
      TKN:=TKN+'’';
      SETCL(CLS,17,81,SYA);
    END
  ELSE EROUT;

    '‚':
IF TST('‚')
  THEN
    BEGIN
      TKN:=TKN+'€’';
      SETCL(CLS,12,60,SYA);
    END
ELSE IF TST('…‚')
  THEN
    BEGIN
      TKN:=TKN+'…’';
      SETCL(CLS,79,78,SYA);
    END
ELSE IF TST('‡‚')
  THEN
    IF(L>3)AND((TKN[L-3]='’')OR(TKN[L-3]='„'))
      THEN
        BEGIN
          TKN:=COPY(TKN,1,L-3)+'‡‚€’';
          SETCL(CLS,182,183,SYA);
        END
     ELSE
       BEGIN
         TKN:=COPY(TKN,1,L-2)+'‚€’';
         SETCL(CLS,85,75,SYA);
       END
ELSE IF TST('‹›‚')OR TST('†‚')OR TST('‘‹›‚')
  THEN
    BEGIN
      TKN:=COPY(TKN,1,L-1)+'’';
      SETCL(CLS,94,93,SYA);
    END
ELSE EROUT;

    'ƒ':
IF TST('…ƒ')
  THEN
    BEGIN
      TKN:=COPY(TKN,1,L-1)+'†€’';
      SETCL(CLS,84,20,SYA);
    END
ELSE IF TST('‹ƒ')
  THEN
    BEGIN
      TKN:=TKN+'€’';
      SETCL(CLS,187,186,SYA);
    END
ELSE IF TST('†ƒ')
  THEN
    BEGIN
      INIT:=COPY(TKN,1,L-2);
      IF (INIT='€‡') OR (INIT='„€‡') 
        OR (INIT='‘') OR (INIT='') 
        OR (INIT='„') OR (INIT='‚')
        THEN
          BEGIN    (*„†…—*)
            TKN:=COPY(TKN,1,L-3)+'†…—'; 
            SETCL(CLS,156,155,SYA);
        END
      ELSE
        BEGIN       (*‡€†…—*)
          TKN:=COPY(TKN,1,L-1)+'…—';
          SETCL(CLS,28,26,SYA);
        END
    END
ELSE IF TST('‹ƒ') AND (TKN<>'‹ƒ')
  THEN
    BEGIN           (*‹…—*)
      TKN:=COPY(TKN,1,L-2)+'…—';
      SETCL(CLS,146,145,SYA);
    END
  ELSE
    BEGIN
      TKN:=COPY(TKN,1,L-1)+'—';
      SETCL(CLS,23,27,SYA);
    END;

    '„':
IF TST('“„')
  THEN
    BEGIN            (*›’*)
      TKN:=COPY(TKN,1,L-2)+'›’';
      SETCL(CLS,73,19,SYA);
    END
ELSE IF TST('„€„')OR TST('‘‡„€„')
  THEN
    BEGIN            (*‘‡„€’*)
      TKN:=COPY(TKN,1,L-1)+'’';
      SETCL(CLS,24,22,SYA);
    END
ELSE IF TST('‚…„') OR TST('…„')
  OR TST('ƒ„')
  THEN
    BEGIN            (*‡€…‘’*) 
      TKN:=COPY(TKN,1,L-1)+'‘’';
      SETCL(CLS,58,42,SYA);
    END
ELSE IF TST('…„')
  THEN
    BEGIN            (*…•€’*)
      TKN:=COPY(TKN,1,L-1)+'•€’';
      SETCL(CLS,110,109,SYA);
    END
ELSE IF TKN='„'
  THEN
    BEGIN            (*„’*)
      TKN:=TKN+'’';
      SETCL(CLS,154,153,SYA);
    END
ELSE IF TST('‰„')
  THEN
    BEGIN            (*‰’*)
     TKN:=COPY(TKN,1,L-1)+'’';
     SETCL(CLS,13,6,SYA);
    END
ELSE IF TKN='„'
  THEN
    BEGIN            (*„’*)
      TKN:=TKN+'’';
      SETCL(CLS,0,124,SYA);
    END
ELSE IF TST('‘„')
  THEN
    BEGIN            (*‘…‘’*)
      TKN:=COPY(TKN,1,L-2)+'…‘’';
      SETCL(CLS,144,143,SYA);
    END
ELSE IF TST('‚') OR TST('†€†„') 
  OR TST('†„') OR TST('†') 
  OR TST('') OR TST('') 
  OR TST('‚') OR TST('†') 
  OR TST('‘‘') OR TST('‘’') 
  OR TST('‘') OR TST('’') 
  OR (TKN='‘’€†„') 
  THEN
    BEGIN           (*†„€’*)
      TKN:=TKN+'€’';
      SETCL(CLS,12,60,SYA);
    END
ELSE IF TST('‹€„') OR TST('€„')
  THEN
    BEGIN           (*‹€‘’*)
      TKN:=COPY(TKN,1,L-1)+'‘’';
      SETCL(CLS,62,61,SYA);
    END
ELSE EROUT;

    '†':
IF TST('„‚†')OR TST('›‡†')
  THEN
    BEGIN           (*›‡ƒ€’*)
      TKN:=COPY(TKN,1,L-1)+'ƒ€’';
      SETCL(CLS,98,107,SYA);
    END
ELSE IF TST('‚†') OR TST('‘€†') 
  OR TST('€†') OR TST('†') 
  OR (TKN='†') OR TST('‹†')
  THEN
    BEGIN           (*‘€‡€’*)
      TKN:=COPY(TKN,1,L-1)+'‡€’';
      SETCL(CLS,2,1,SYA);
    END
ELSE IF TST('€†') OR TST('…†')
  THEN
    BEGIN           (*€‡€’*)
      TKN:=COPY(TKN,1,L-1)+'‡€’';
      SETCL(CLS,99,102,SYA);
    END
ELSE IF TST('ƒ‹†')
  THEN
    BEGIN           (*ƒ‹„€’*)
      TKN:=COPY(TKN,1,L-1)+'„€’';
      SETCL(CLS,101,104,SYA);
    END
ELSE IF TST('†')
  THEN
    BEGIN           (*‡€†€’*)
      TKN:=TKN+'€’';
      SETCL(CLS,12,60,SYA);
    END
ELSE EROUT;

    '‡':
IF TST('‹…‡') AND (TKN<>'‚›‹…‡') 
  OR TST('ƒ›‡')
  THEN
    BEGIN            (*ƒ›‡’*)
      TKN:=TKN+'’';
      SETCL(CLS,52,49,SYA);
    END
ELSE IF TST('‚…‡') OR TST('‹‡') 
  OR (TKN='‚›‹…‡')
  THEN
    BEGIN            (*‚›‚…‡’*)
      TKN:=TKN+'’';
      SETCL(CLS,50,47,SYA);
    END
ELSE EROUT;

    '':
IF TST('’')
  THEN
    BEGIN            (*’€’*)
      TKN:=TKN+'€’';
      SETCL(CLS,12,60,SYA);
    END
  ELSE
    BEGIN             (*’…—*)
      TKN:=COPY(TKN,1,L-1)+'—';
      SETCL(CLS,21,18,SYA);
    END;

    '':
IF TST('') { /‘/„/€‡||“’ }
  THEN
    BEGIN                (*„’*)
      TKN:=COPY(TKN,1,L-2)+'’';
      SETCL(CLS,65,64,SYA);
    END
ELSE IF TST('‰')  (* /‡€/€|‰|“’ *)
  THEN
    BEGIN                (*‡€’*)
      TKN:=COPY(TKN,1,L-2)+'’';
      SETCL(CLS,69,68,SYA);
    END
ELSE IF (TKN='')
  THEN
    BEGIN               (*’*)
      TKN:=COPY(TKN,1,L-1)+'’';
      SETCL(CLS,67,66,SYA);
    END
ELSE IF TST('†')
  THEN
    BEGIN               (*†€’*)
      TKN:=COPY(TKN,1,L-1)+'€’';
      SETCL(CLS,87,74,SYA);
    END
ELSE EROUT;

    '':
IF TST('‘’€') OR TST('‘’›') OR TST('„…')
    THEN
      BEGIN
         SETCL(CLS,95,77,SYA);
         TKN:=COPY(TKN,1,L-1)+'’';
      END
ELSE IF TST('—')
    THEN
      BEGIN
        SETCL(CLS,129,128,SYA);
        TKN:=COPY(TKN,1,L-1)+'€’';
      END
ELSE IF TST('‹')
  THEN
    BEGIN
      TKN:=COPY(TKN,1,L-1)+'‘’';
      SETCL(CLS,150,149,SYA);
    END
ELSE IF TST('‘’')
  THEN
    BEGIN
      TKN:=TKN+'€’';
      SETCL(CLS,12,60,SYA);
    END
ELSE IF TST('') (* /‘/„||“’ *)
  THEN
    BEGIN
      TKN:=COPY(TKN,1,L-3)+'’';
      SETCL(CLS,173,172,SYA);
    END
ELSE IF TST('') { „/“/||“’ }
  THEN
    BEGIN
      TKN:=COPY(TKN,1,L-1)+'’';
      SETCL(CLS,152,151,SYA);
    END
ELSE IF TST('‚')
  THEN
    BEGIN
      TKN:=TKN+'“’';
      SETCL(CLS,0,166,SYA);
    END
ELSE
  BEGIN
    IF TST('ƒ') 
      OR TST('„‚') OR TST('„“') 
      OR TST('') OR TST('‹') 
      OR TST('') OR TST('‹') 
      OR TST('') OR TST('') 
      OR TST('‘’›') OR TST('‘“') 
      OR TST('’') OR TST('•‹›')
      OR (TKN='‚›') OR (TKN='ƒ‹') 
      OR (TKN='€') OR (TKN='€‡') 
      OR (TKN='‘ƒ') 
      THEN SETCL(CLS,275,274,SYA)
    ELSE IF (POS(TKN [L-1],'€…“›‚’—') > 0)
      OR STEM_16('')           (*€“’/€“‹*)
      THEN SETCL(CLS,53,16,SYA) (*›“’/›“‹*)
    ELSE IF (POS(TKN [L-1],'ƒ‡‘•'(*+'„–'*)) > 0)
      AND (ROOT_10('') OR STEM_10(''))
      THEN SETCL(CLS,5,10,SYA)  (*‚›“’/‚›*)
    ELSE SETCL(CLS,53,16,SYA);  (*€–“’/€–“‹*)
    TKN:=TKN+'“’';
  END;

    '':
IF TST('…') OR TST('„…')
  THEN
    BEGIN
      INIT:=COPY(TKN,1,L-3);
      IF TST('…') AND ((INIT='€‡') 
        OR (INIT='„€‡') OR (INIT='’')
        OR (INIT='') OR (INIT='„') OR (INIT='‚'))
        THEN
          BEGIN
            TKN:=COPY(TKN,1,L-3)+'€’';
            SETCL(CLS,184,185,SYA);
          END
        ELSE
      IF TST('„…') 
        AND ((INIT='‡') OR (INIT='‡') OR (INIT='€‡')
        OR (INIT='’') OR (INIT=''))
        THEN
          BEGIN
            TKN:=COPY(TKN,1,L-3)+'„€’';
            SETCL(CLS,175,174,SYA);
          END
        ELSE
          BEGIN
            TKN:=COPY(TKN,1,L-2)+'€’';
            SETCL(CLS,57,56,SYA);
          END
    END
ELSE IF POS(TKN[L-1],'’')>0
  THEN OIN(TKN,CLS,SYA)
  ELSE
    BEGIN
      TKN:=TKN+'€’';
      SETCL(CLS,12,60,SYA);
   END;

    '‘':
IF TST('…‘') OR TST('€‘') OR TST('’‘')
  THEN
    BEGIN
TKN:=TKN+'’';
SETCL(CLS,50,47,SYA);
    END
ELSE IF TST('‘‘')
  THEN
    BEGIN
TKN:=TKN+'€’';
SETCL(CLS,12,60,SYA);
    END
ELSE EROUT;

     '’':
IF TST('—’')
  THEN
    BEGIN
      IF (TKN='‘—’')
        THEN
          BEGIN         (*‘—…‘’*)
          TKN:=COPY(TKN,1,L-3)+'—…‘’';
          SETCL(CLS,176,177,SYA);
        END
    ELSE
      BEGIN             (*€—…‘’*)
        TKN:=COPY(TKN,1,L-1)+'…‘’';
        SETCL(CLS,44,45,SYA);
      END
   END
ELSE IF TST('‹…’') OR TST('–‚…’') 
  OR TST('…’') OR TST('ƒ…’') 
  OR TST('…’')
  THEN
    BEGIN               (*…‘’*)
      TKN:=COPY(TKN,1,L-1)+'‘’';
      SETCL(CLS,55,54,SYA);
   END
ELSE IF TST('€‘’')
  THEN
    BEGIN              (*€‘’*)
      TKN:=TKN+'';
      SETCL(CLS,51,48,SYA);
   END
ELSE EROUT;

    '—':
IF TST('‘€—') 
  THEN
    BEGIN             (*‘€€’*)
      TKN:=COPY(TKN,1,L-1)+'€’';
      SETCL(CLS,271,270,SYA);
    END
ELSE IF TST('“‹›—') OR TST('‹€—')
  OR TST('•›—') OR TST('“‹›—') 
  THEN
    BEGIN              (*‹€€’*)
      TKN:=COPY(TKN,1,L-1)+'€’';
      SETCL(CLS,100,103,SYA);
    END
ELSE IF ROOT_106
  THEN
    BEGIN             (*‹……’€’*)
      TKN:=COPY(TKN,1,L-1)+'’€’';
      SETCL(CLS,108,106,SYA);
    END
ELSE EROUT;
    '':
IF TST('') OR TST('‹') 
  OR TST('—…')
  THEN
    BEGIN            (*‘€’*)
      TKN:=COPY(TKN,1,L-1)+'‘€’';
      SETCL(CLS,86,59,SYA);
    END
ELSE IF TST('€') OR TST('€') 
  OR TST('›') OR TST('…')
  THEN
    BEGIN            (*€•€’*)
      TKN:=COPY(TKN,1,L-1)+'•€’';
      SETCL(CLS,147,125,SYA);
    END
ELSE IF TST('‹›')
  THEN
    BEGIN            (*‹›•€’*)
      TKN:=COPY(TKN,1,L-1)+'•€’';
      SETCL(CLS,265,264,SYA);
    END
ELSE EROUT;
    '™':
IF TST('™') OR TST('›™') 
  OR TST('›™') OR TST('‹™')
  OR TST('‹…™') OR TST('“‹…™')
    THEN
      BEGIN          (*‘€’*)
        TKN:=COPY(TKN,1,L-1)+'‘€’';
        SETCL(CLS,89,76,SYA);
      END
ELSE IF TST('•‹…™') OR TST('‘‚™') 
  OR TST('„™') OR TST('•‹›™') 
  OR TST('•‹›™')
    THEN
      BEGIN          (*•‹›‘’€’*)
        TKN:=COPY(TKN,1,L-1)+'‘’€’';
         SETCL(CLS,148,126,SYA);
      END
ELSE IF TST('’……™') OR TST('™')
  OR TST('‹…‚…™') OR TST('‘…†…™') 
  THEN
    BEGIN            (*’€’*)
      TKN:=COPY(TKN,1,L-1)+'’€’';
      SETCL(CLS,9,105,SYA);
    END
  ELSE EROUT;
    ELSE EROUT;
  END;
END;

PROCEDURE SHORTFIN(VAR TKN : STR115;
        (*=======*)VAR CLS : INTEGER;
                   SYA : BOOLEAN);
VAR
  L : INTEGER;
  INIT : STR115;
BEGIN
  TNS := PAST;
  L:=LENGTH(TKN);

  CASE TKN [L] OF
    'ƒ':
      IF TST('…ƒ') OR TST('‚…ƒ') 
        OR TST('„ƒ') OR TST('’ƒ') 
        OR TST('„‚ƒ') OR (TKN='ƒ') 
        OR (TKN='„ƒ') 
        THEN
          BEGIN
            SETCL(CLS,5,10,SYA);
            TKN:=TKN+'“’';
          END
      ELSE IF TST('‘’ƒ')
        THEN
          BEGIN
            SETCL(CLS,180,181,SYA);
            TKN:=COPY(TKN,1,L-1)+'—';
          END
      ELSE
        BEGIN
          IF TST('‹…ƒ')
            THEN SETCL(CLS,146,145,SYA)
          ELSE IF TST('†…ƒ')
            THEN
              BEGIN
                INIT:=COPY(TKN,1,L-3);
                IF (INIT='€‡') OR (INIT='‘') 
                  OR (INIT='') OR (INIT='„')
                  THEN SETCL(CLS,156,155,SYA)
                  ELSE SETCL(CLS,28,26,SYA);
              END
          ELSE SETCL(CLS,23,27,SYA);
          TKN:=COPY(TKN,1,L-1)+'—';
        END;
    '':
      IF TST('‹…') OR TST('') 
        OR TST('‚›') OR TST('ƒ')
        OR TST('‹…') OR TST('…') 
        OR TST('') OR TST('‹') 
        OR TST('') OR TST('')
        OR (TKN='‘‘') OR (TKN='‹…') 
        THEN
          BEGIN
            SETCL(CLS,5,10,SYA);
            TKN:=TKN+'“’';
          END
       ELSE
         IF TST('’‹')
           THEN
             BEGIN
               SETCL(CLS,252,251,SYA);
              TKN:=COPY(TKN,1,L-1)+'—';
             END
         ELSE
           BEGIN
             SETCL(CLS,21,18,SYA);
             TKN:=COPY(TKN,1,L-1)+'—';
           END;
    '•','':
      IF TST('“•') OR TST('ƒ‹•') 
        OR TST('„›•') OR TST('†“•') 
        OR TST('‹') OR TST('€•') 
        OR TST('“•') OR TST('‘•') 
        OR TST('’•') OR TST('•') 
        OR TST('—€•') OR TST('’“•') 
        OR TST('„•') OR (TKN='…') 
        OR (TKN='‘') OR (TKN='‘‹…')
        THEN 
          BEGIN
            SETCL(CLS,5,10,SYA);
            TKN:=TKN+'“’';
          END;
    '‡':
      IF TST('…‡') OR TST('‚‡') 
        OR TST('‚…‡') OR TST('‚‡') 
        OR (TKN='‡€‘“‡') OR (TKN='‘—…‡')
        OR (TKN='ƒ‡') 
        THEN
          BEGIN
            SETCL(CLS,5,10,SYA);
            TKN:=TKN+'“’';
          END
      ELSE IF TST('ƒ›‡')
        THEN
          BEGIN
            SETCL(CLS,257,256,SYA);
            TKN:=TKN+'’';
          END
      ELSE IF TST('‹…‡') AND (TKN<>'‚›‹…‡')
        THEN
          BEGIN
            SETCL(CLS,52,49,SYA);
            TKN:=TKN+'’';
          END
      ELSE
        BEGIN
          SETCL(CLS,50,47,SYA);
          TKN:=TKN+'’';
        END;
    '‘':
      IF TST('‚‘') OR TST('ƒ€‘') 
        OR TST('‘') OR (TKN='‚‘…‘') 
        THEN
          BEGIN
            SETCL(CLS,5,10,SYA);
            TKN:=TKN+'“’';
         END
      ELSE IF TST('‘') OR TST('‡‘')
        THEN
          BEGIN
            SETCL(CLS,51,48,SYA);
            TKN:=COPY(TKN,1,L-2)+'€‘’';
          END
      ELSE IF (TKN[L-1]='') OR TST('…‘') OR TST('€‘')
        THEN
          BEGIN
            SETCL(CLS,50,47,SYA);
            TKN:=TKN+'’';
          END;
    '':
      BEGIN
        CASE TKN[L-2] OF
          '’': IF (TKN='‘’…')
                 THEN SETCL(CLS,63,46,SYA) (*‘’……’/‘*)
               ELSE IF (TKN='€‘’…') OR (TKN='‘’…')
                 THEN SETCL(CLS,259,258,SYA) (*€‘’……’/‘*)
               ELSE IF (POS(TKN[L-3],OCONS) > 0)
                 THEN SETCL(CLS,158,157,SYA)
                                    (*(„/’//‘)’……’/‘*)
                 ELSE SETCL(CLS,63,46,SYA); 
                              (*(_/€//……/“/‚›)’……’/‘*)
          '': IF (TKN='…')
                 THEN SETCL(CLS,162,161,SYA)  (*……’/‘*)
               ELSE IF (TKN='€‘…') 
                 THEN SETCL(CLS,261,269,SYA)  (*€‘……’/‘*) 
               ELSE IF POS(TKN[L-3],OCONS) > 0
                  THEN SETCL(CLS,160,159,SYA) (*„……’/‘*)
                  ELSE SETCL(CLS,63,46,SYA);  (*‡€……’/‘*)
          '': IF POS(TKN[L-3],OCONS)>0
                 THEN SETCL(CLS,0,163,SYA)
                 ELSE SETCL(CLS,0,46,SYA);
          ELSE EROUT;
        END;
        TKN:=TKN+'…’';
      END;
    '':
      IF TST('‡') OR (TKN='‘‹€') 
        OR (TKN='ƒ')
        THEN
          BEGIN
            SETCL(CLS,5,10,SYA);
            TKN:=TKN+'“’';
          END
      ELSE IF TST('')
        THEN
          BEGIN
            SETCL(CLS,17,81,SYA);
            TKN:=TKN+'’';
          END
      ELSE
         BEGIN
           SETCL(CLS,80,11,SYA);
           TKN:=COPY(TKN,1,L-1)+'‘’';
         END;
    ELSE EROUT;
  END;
  IF SYA
    THEN
      IF TKN[LENGTH(TKN)]=''
        THEN TKN:=TKN+'‘'
        ELSE TKN:=TKN+'‘';
END;

PROCEDURE ITYAT(VAR TKN : STR115;
        (*====*)VAR CLS : INTEGER;
                SYA : BOOLEAN);
  VAR
    L : INTEGER;
BEGIN
  L:=LENGTH(TKN);

  IF (POS(TKN[L],'‹') > 0)
    THEN
      BEGIN  
        IF TST('‚…‹') OR TST('ƒ') 
          OR TST('‘’') OR TST('‡‚…')
          THEN
            BEGIN                       (*ƒ…’/*)
              SETCL(CLS,90,41,SYA);
              TKN:=TKN+'…’';
            END
        ELSE IF TST('ƒ')
          THEN
            BEGIN
              IF (L=3) OR (POS(TKN[L-3],SONOR)>0) 
                OR (TKN='‡ƒ')
                THEN SETCL(CLS,88,70,SYA)   (*ƒ€’*)
                ELSE SETCL(CLS,178,179,SYA);(*‘ƒ€’*) 
              TKN:=COPY(TKN,1,L-2)+'€’';
            END
        ELSE IF ROOT_229 OR STEM_229
          OR TST('‚…') AND (TKN<>'‚›‚…')
          OR TST('‡€') AND (TKN<>'‡€')
          OR TST('€') 
            AND (TKN<>'‘€') AND (TKN<>'‚‘€')
          OR TST('…') AND (TKN<>'…')
          OR TST('•“') AND (TKN<>'•“')
          OR TST('–…‹') AND (TKN<>'‘–…‹')
          THEN 
            BEGIN                         (*‚‡„’/*)
              SETCL(CLS,230,229,SYA); 
              TKN:=TKN+'’';
            END
          ELSE
            BEGIN                          (*„€’/*)
              SETCL(CLS,8,7,SYA);     
              TKN:=TKN+'’';
            END
      END
  ELSE IF TST('‘’') OR TST('')
    THEN
      BEGIN                    (*‘’’*)  
        SETCL(CLS,118,117,SYA);
        TKN:=TKN+'’';
      END
  ELSE IF ROOT_225
    THEN
      BEGIN                    (*…’*)
        SETCL(CLS,226,225,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('‘')
    THEN
      BEGIN                    (*‘€’*)
        SETCL(CLS,171,170,SYA);
        TKN:=TKN+'€’';
      END
  ELSE IF (POS(TKN[L],LCONS) > 0)
    AND (POS(TKN[L-1],SONOR+'‹’‡‰') > 0)
    THEN 
      BEGIN
        IF ROOT_231 OR STEM_231
          THEN SETCL(CLS,232,231,SYA)  (*ƒ’/*)
          ELSE SETCL(CLS,194,193,SYA); (*•€’/*)
        TKN:=TKN+'’';
      END
  ELSE IF (TKN[L] = '„')
    THEN 
      BEGIN
        IF ELINF_D6 (TKN)
          THEN
            BEGIN              (*„…’/„*)
              SETCL(CLS,267,266,SYA);
              TKN:=TKN+'…’';
            END
        ELSE IF ROOT_217
          THEN
            BEGIN             (* ƒ‹„…’/„ *)
              SETCL(CLS,218,217,SYA);
              TKN:=TKN+'…’';
             END
        ELSE IF TST('…„') 
          THEN
            BEGIN     (* only plur!: ‘…‘’/…„’ *)
              SETCL(CLS,29,25,SYA);
              TKN:=COPY(TKN,1,L-1)+'‘’';
            END
        ELSE IF TST('—“„') 
          THEN 
            BEGIN     (*—“„’/„<>—“„’‘/„‘*)
              SETCL(CLS,241,203,SYA);
              TKN:=TKN+'’';
            END
        ELSE IF ROOT_240 OR STEM_240
          OR TST('‹€„') 
            AND (TKN<>'€‘‹€„') AND (TKN<>'“‘‹€„') 
          THEN        
            BEGIN           (*€ƒ€„’/„*)
              SETCL(CLS,241,240,SYA);  
              TKN:=TKN+'’';
            END
        ELSE                            
          BEGIN              (*“„’/„*)
            SETCL(CLS,204,203,SYA);  
            TKN:=TKN+'’';
          END
      END
  ELSE IF (TKN[L] = '‡')
    THEN 
      BEGIN
        IF ROOT_244 OR STEM_244
          OR TST('€‚‡') AND (TKN<>'€‚‡') 
            THEN SETCL(CLS,245,244,SYA)  (*…‹‡’/‡*)
            ELSE SETCL(CLS,206,205,SYA);  (*‚‡’/‡*)
        TKN:=TKN+'’';
      END
  ELSE IF (TKN[L] = '‘')
    THEN 
      BEGIN
        IF (TKN='‡€‚‘')
          THEN 
            BEGIN            (*‡€‚‘…’/‘*)
              SETCL(CLS,224,250,SYA);
              TKN:=TKN+'…’';
            END
        ELSE IF TST('‚‘')
          THEN 
            BEGIN            (*‚‘…’/‘*)
              SETCL(CLS,224,223,SYA);
              TKN:=TKN+'…’';
            END
        ELSE IF ROOT_238 OR STEM_238
          THEN 
            BEGIN            (*‘’/‘*)
              SETCL(CLS,239,238,SYA);
              TKN:=TKN+'’';
            END
          ELSE 
            BEGIN            (*‘’/‘*)
              SETCL(CLS,208,207,SYA);
              TKN:=TKN+'’';
            END
      END
  ELSE IF (COPY(TKN,L-1,2) = '‘’')
    THEN
      BEGIN 
        IF ELINF_ST (TKN)
          THEN
            BEGIN           (*‹…‘’…’*)
              SETCL(CLS,222,221,SYA);
              TKN:=TKN+'…’';
            END
          ELSE
            BEGIN           (*‘’’*)
              SETCL(CLS,210,209,SYA);
              TKN:=TKN+'’';
            END
      END
  ELSE IF (TKN[L] = '’')
    THEN 
      BEGIN
        IF ROOT_219
          THEN 
            BEGIN                    (*‹…’…’*)
              SETCL(CLS,220,219,SYA);
              TKN:=TKN+'…’';
            END
        ELSE IF TST('—’')
          THEN 
            BEGIN                     (*—’’*)
              SETCL(CLS,216,215,SYA);
              TKN:=TKN+'’';
            END
        ELSE IF (TKN='‡€‘‚…’')OR (TKN='‡……’')
           OR (TKN='‘‚…’')
          THEN 
             BEGIN               (*‡€‘‚…’’/—“/’*)
                SETCL(CLS,214,213,SYA); 
                TKN:=TKN+'’';
             END
        ELSE IF ROOT_211 OR STEM_211
            THEN 
              BEGIN              (*‘…’’/™“/’*)
                SETCL(CLS,212,211,SYA);
                TKN:=TKN+'’';
              END
         ELSE IF TST('‘›’')  
            OR (TKN='•’') OR (TKN='€‘•’') 
            THEN
              BEGIN              (*€‘›’’/™“/’*)
                SETCL(CLS,273,272,SYA);
                TKN:=TKN+'’';
              END
         ELSE IF ROOT_227 
            OR TST('’') AND (TKN<>'‚›’')
            OR TST('……’') AND (TKN<>'‡……’') 
            OR (TKN='‡€‹’') OR (TKN='‘‚’') 
            OR (TKN='•€’') OR (TKN='…‘‘…’') 
            OR (TKN='…‘–‚…’') OR (TKN='€’') 
            OR (TKN='‘€“’') OR (TKN='‘›’') 
            OR (TKN='‘’')
            THEN 
              BEGIN            (*‚‘’…’’/—“/’*)    
                 SETCL(CLS,228,227,SYA);
                 TKN:=TKN+'’';
              END
         ELSE 
           BEGIN                (*’’/—“/’*)
             SETCL(CLS,214,213,SYA);
             TKN:=TKN+'’';
           END
      END
  ELSE IF TST('‘’…‹')
    THEN  
      BEGIN
        SETCL(CLS,121,120,SYA);
        TKN:=TKN+'’';
     END
  ELSE IF ROOT_229 OR STEM_229
    OR TST('–…‹') AND NOT (TKN='‘–…‹')
    OR TST('‡€') AND NOT (TKN='‡€')
    THEN 
      BEGIN  (*‡…’*)
        SETCL(CLS,230,229,SYA);
        TKN:=TKN+'’';
      END
  ELSE IF TST('‹…') OR TST('') 
    OR TST('') OR TST('‘‚') 
    OR TST('‘’')
    OR TST('„‚') AND (TKN<>'„‚') 
    OR (TKN='‹€ƒ“‘’') 
    OR (TKN='‡€ƒ€') OR (TKN='’') 
    OR (TKN='‘’') OR (TKN='’“„“‘’')
    OR (TKN='“„‘’') OR (TKN='“’')
    THEN 
      BEGIN    (*‘’’/‰*)
        SETCL(CLS,234,233,SYA);
        TKN:=TKN+'’';
      END
  ELSE          (*„’/*) 
    BEGIN
      SETCL(CLS,8,7,SYA);
      TKN:=TKN+'’';
    END;
  IF SYA
    THEN TKN:=TKN+'‘';
END;

PROCEDURE ZHET(VAR TKN : STR115;
        (*===*)VAR CLS : INTEGER;
               SYA : BOOLEAN);
VAR
  L : INTEGER;
  INIT : STR115;
BEGIN
  L:=LENGTH(TKN);
  IF TST('††')
    THEN
BEGIN
  INIT:=COPY(TKN,1,L-2);
  IF (INIT='€‡') OR (INIT='‘') 
    OR (INIT='') OR (INIT='„')
    THEN
  BEGIN
    SETCL(CLS,156,155,SYA);
    TKN:=COPY(TKN,1,L-3)+'†…—';
  END
    ELSE
  BEGIN
    SETCL(CLS,28,26,SYA);
    TKN:=COPY(TKN,1,L-1)+'…—';
  END;
END
  ELSE IF TST('„‚†')OR TST('›‡†')
    THEN
      BEGIN
        SETCL(CLS,98,107,SYA);
        TKN:=COPY(TKN,1,L-1)+'ƒ€’';
      END
  ELSE IF TST('‹†')
    THEN
      BEGIN
        SETCL(CLS,146,145,SYA);
        TKN:=COPY(TKN,1,L-2)+'…—';
      END
  ELSE IF TST('‹†')
    THEN
      BEGIN
        SETCL(CLS,187,186,SYA);
        TKN:=COPY(TKN,1,L-1)+'ƒ€’';
      END
  ELSE IF TST('‚†') OR TST('‘€†') 
      OR TST('€†') OR TST('‹†') 
      OR TST('†') OR (TKN='†')
      THEN
      BEGIN
        SETCL(CLS,2,1,SYA);
        TKN:=COPY(TKN,1,L-1)+'‡€’';
      END
  ELSE IF TST('€†') OR TST('…†')
    THEN
      BEGIN           (*€‡€’*)
        TKN:=COPY(TKN,1,L-1)+'‡€’';
        SETCL(CLS,99,102,SYA);
      END
  ELSE IF TST('ƒ‹†')
    THEN
      BEGIN
        SETCL(CLS,101,104,SYA);
        TKN:=COPY(TKN,1,L-1)+'„€’';
      END
  ELSE IF TST('†')
    THEN
      BEGIN
        SETCL(CLS,12,60,SYA);
        TKN:=TKN+'€’';
      END
  ELSE IF TST('……†') OR TST('†')
    THEN
      BEGIN
        SETCL(CLS,23,27,SYA);
        TKN:=COPY(TKN,1,L-1)+'—';
      END
  ELSE CLS:=0;
  IF SYA
    THEN TKN:=TKN+'‘';
END;

PROCEDURE ETFIN (VAR TKN : STR115;
        (*=====*)VAR CLS : INTEGER;
                 SYA : BOOLEAN);
  VAR
    L : INTEGER;
BEGIN
  L:=LENGTH(TKN);
  IF TST('‰')
    THEN
      BEGIN         (*€’*)
        SETCL(CLS,69,68,SYA);
        TKN:=COPY(TKN,1,L-2)+'’';
      END
  ELSE IF TST('‹')
    THEN
      BEGIN         (*‘‹€’*)
        SETCL(CLS,123,122,SYA);
        TKN:=COPY(TKN,1,L-2)+'‘‹€’';
      END
  ELSE IF TST('…—')
    THEN
      BEGIN         (*…—’€’*)
        SETCL(CLS,108,106,SYA);
        TKN:=COPY(TKN,1,L-1)+'’€’';
      END
  ELSE IF TST('‚') OR TST('†€†„') 
    OR TST('†„') OR TST('†') 
    OR TST('') OR TST('') 
    OR TST('‚') OR TST('†') 
    OR TST('‘‘') OR TST('‘’') 
    OR TST('‘') OR TST('’') 
    OR (TKN='‘’€†„') 
    THEN
      BEGIN         (*†„€’*)
        SETCL(CLS,12,60,SYA);
        TKN:=TKN+'€’';
      END
  ELSE IF TST('…‹')
    THEN
      BEGIN          (*…‹…’*)
        SETCL(CLS,0,188,SYA);
        TKN:=TKN+'…’';
      END
  ELSE IF TST('‘’€') OR TST('‘’›') 
    OR TST('„…')
    THEN
      BEGIN          (*‡€‘’€’*)
        SETCL(CLS,95,77,SYA);
        TKN:=COPY(TKN,1,L-3)+'’';
      END
  ELSE IF TST('—')
    THEN
      BEGIN          (*€—€’*)
        SETCL(CLS,129,128,SYA);
        TKN:=COPY(TKN,1,L-1)+'€’';
      END
  ELSE IF TST('')
    THEN
      BEGIN          (*’*)
        SETCL(CLS,65,64,SYA);
        TKN:=COPY(TKN,1,L-2)+'’';
      END
  ELSE IF TST('‘’…‹')
    THEN
      BEGIN         (*‘’…‹’*)
        SETCL(CLS,121,120,SYA);
        TKN:=TKN+'’';
      END
  ELSE IF (TKN='ƒ‹€ƒ‹')
    THEN
      BEGIN         (*ƒ‹€ƒ‹€’*)
        SETCL(CLS,249,248,SYA);
        TKN:=TKN+'€’';
      END
  ELSE IF TKN[L-1]=''
    THEN
      BEGIN         (*’‹’*)
        SETCL(CLS,38,116,SYA);
        TKN:=TKN+'’';
      END
  ELSE IF TST('’…‹') OR TST('‹…‹') 
    OR TST('„…‹') OR TST('™‹') 
    THEN
      BEGIN         (*’…€’*)
        SETCL(CLS,36,32,SYA);
        TKN:=COPY(TKN,1,L-1)+'€’';
      END
  ELSE
    BEGIN
      IF TST('ƒ') 
        OR TST('„‚') OR TST('„“') 
        OR TST('') OR TST('‹') 
        OR TST('') OR TST('‹') 
        OR TST('') OR TST('') 
        OR TST('‘’›') OR TST('‘“') 
        OR TST('’') OR TST('•‹›')
        OR (TKN='‚›') OR (TKN='ƒ‹') 
        OR (TKN='€') OR (TKN='€‡') 
        OR (TKN='‘ƒ') 
        THEN SETCL(CLS,275,274,SYA)
      ELSE IF (POS(TKN [L-1],'€…“›‚’—') > 0)
        OR STEM_16('')           (*€“’/€“‹*)
        THEN SETCL(CLS,53,16,SYA) (*›“’/›“‹*)
      ELSE IF (POS(TKN [L-1],'ƒ‡‘•'(*+'„–'*)) > 0)
        AND (ROOT_10('') OR STEM_10(''))
        THEN SETCL(CLS,5,10,SYA)  (*‚›“’/‚›*)
      ELSE SETCL(CLS,53,16,SYA);  (*€–“’/€–“‹*)
      TKN:=TKN+'“’';
    END;

  IF SYA
    THEN TKN:=TKN+'‘';
END;

PROCEDURE DET(VAR TKN : STR115;
        (*==*)VAR CLS : INTEGER;
              SYA : BOOLEAN);
  VAR
    L : BYTE;
BEGIN
  L:=LENGTH(TKN);
  IF TKN='„'
    THEN
      BEGIN
        SETCL(CLS,0,124,SYA);
        TKN:=TKN+'’';
      END
  ELSE IF TKN='„'
    THEN
      BEGIN
        SETCL(CLS,154,153,SYA);
        TKN:=COPY(TKN,1,L-1)+'‰’';
      END
  ELSE IF TST('‰„')
    THEN
      BEGIN
        SETCL(CLS,13,6,SYA);
        TKN:=COPY(TKN,1,L-1)+'’';
      END
  ELSE IF TST('“„')
    THEN
      BEGIN
        SETCL(CLS,73,19,SYA);
        TKN:=COPY(TKN,1,L-2)+'›’';
      END
  ELSE IF TST('‚…„') OR TST('…„') 
    OR TST('ƒ„') OR TST('‹„')
    THEN
      BEGIN
        SETCL(CLS,58,42,SYA);
        TKN:=COPY(TKN,1,L-1)+'‘’';
      END
  ELSE IF TST('‘„')
    THEN
      BEGIN
        SETCL(CLS,144,143,SYA);
        TKN:=COPY(TKN,1,L-2)+'…‘’';
      END
  ELSE IF TST('†„')
    THEN
      BEGIN
        SETCL(CLS,12,60,SYA);
        TKN:=TKN+'€’';
      END
  ELSE IF TST('…„')
    THEN
      BEGIN
        SETCL(CLS,73,109,SYA);
        TKN:=COPY(TKN,1,L-1)+'•€’';
      END
  ELSE IF (TKN='€„')
    THEN
      BEGIN
        SETCL(CLS,0,268,FALSE);
        TKN:=COPY(TKN,1,L-4)+'€‘’';
      END
  ELSE IF TST('€„') OR TST('‹€„') 
    OR TST('€„') OR TST('„')
    THEN
      BEGIN
        SETCL(CLS,62,61,SYA);
        TKN:=COPY(TKN,1,L-1)+'‘’';
      END
  ELSE EROUT;

  IF SYA
    THEN
     IF TKN[LENGTH(TKN)]=''
        THEN TKN:=TKN+'‘'
        ELSE TKN:=TKN+'‘';
END;

PROCEDURE VET(VAR TKN : STR115;
        (*==*)VAR CLS : INTEGER);
VAR
  L : INTEGER;
BEGIN
  L:=LENGTH(TKN);
  IF TST('‹›‚')OR TST('†‚')OR TST('‘‹›‚')
    THEN
      BEGIN
        TKN:=COPY(TKN,1,L-1)+'’';
        CLS:=93;
      END
  ELSE IF TST('…‚')
    THEN
      BEGIN
        TKN:=TKN+'…’';
        CLS:=78;
      END
  ELSE IF TST('‡‚')
    THEN 
      IF (L>3) AND ((TKN[L-3]='’') OR (TKN[L-3]='„'))
        THEN
          BEGIN
            TKN:=COPY(TKN,1,L-3)+'‡‚€’';
            CLS:=183;
          END
  ELSE
    BEGIN
      TKN:=COPY(TKN,1,L-2)+'‚€’';
      CLS:=75;
    END
  ELSE EROUT;
END;

FUNCTION ATST (N : INTEGER):BOOLEAN;
CONST
  MAX = 25;
  ATV : ARRAY [1..MAX] OF STRING [7]=
('…—','‡†','“—','‚‡†','‚……™','‚—',
'„…†','„†','„……‡†','„›','†“††','†“—',
'‡‚“—','—','‹…†','‹—','—','›—','™',
'›—','‘’“—','’—','’…™','“—','“');
VAR 
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;    
  REPEAT
   INC(I);
   FOUND := (N=1) AND TST(ATV[I]+'’')
         OR (N=2) AND TST(ATV[I]+'€’');
  UNTIL FOUND OR (I = MAX);
  ATST:=FOUND;
END;

FUNCTION ISEN(TKN:STR115):BOOLEAN;

CONST
  ENS: ARRAY [1..23] OF STRING [10]=
('‚€†','‚„','‚‡†','‚…„‘','„‘’“',
'‡‚…‘’','‘€‚','€‹‚…’',
'…‡…†','…“‹','“†',
'€‘','„’—…’','‹…‡','€‚',
'‘‚„','‘‹›','‘ƒ‹€‘','‘‘','‘“…’‚',
'“›’—','“„','“…‘’');
VAR 
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := (ENS[I]+'…'=TKN);
    UNTIL FOUND OR (I = 23);
  ISEN:=FOUND;
END;

PROCEDURE BIT6 (VAR TKN : STR115;
        (*====*)VAR CLS: INTEGER;
                SYA : BOOLEAN);
  VAR
    CH : CHAR;
    INIT : STRING [7];
    L : INTEGER;
BEGIN
  L := LENGTH (TKN);
  INIT := COPY (TKN,1,L-2);
  CH := TKN[L-1];
  CASE CH OF
    '':
       IF (INIT='')
         THEN
           BEGIN
             SETCL(CLS,198,197,SYA);
             TKN:=COPY(TKN,1,L-4)+'’';
           END
       ELSE IF (INIT='‡') OR (INIT='€‡')
         THEN
           BEGIN
             SETCL(CLS,200,199,SYA);
             TKN:=COPY(TKN,1,L-4)+'‘’';
           END
       ELSE IF (INIT='‚') OR (INIT='‘') OR (INIT='„')
         THEN
           BEGIN
             SETCL(CLS,138,137,SYA);
             TKN:=COPY(TKN,1,L-3)+'’';
           END
       ELSE
         BEGIN
           SETCL(CLS,37,33,SYA);
           TKN:=COPY(TKN,1,L-1)+'’';
         END;
    '':
       IF (INIT='‡') OR (INIT='€‡')
         THEN
           BEGIN
             SETCL(CLS,202,201,SYA);
             TKN:=COPY(TKN,1,L-4)+'‘’';
           END
       ELSE IF (INIT='‚') OR (INIT='‘') OR (INIT='„')
         THEN
           BEGIN
             SETCL(CLS,140,139,SYA);
             TKN:=COPY(TKN,1,L-3)+'’';
           END
       ELSE
         BEGIN
           SETCL(CLS,37,33,SYA);
           TKN:=COPY(TKN,1,L-1)+'’';
         END;
    '':
       IF (INIT='‡') OR (INIT='€‡')
         OR (INIT='‚') OR (INIT='‘') OR (INIT='„')
         THEN
           BEGIN
             SETCL(CLS,132,131,SYA);
             TKN:=COPY(TKN,1,L-3)+'’';
           END
       ELSE
         BEGIN
           SETCL(CLS,37,33,SYA);
           TKN:=COPY(TKN,1,L-1)+'’';
         END;
    '‚':
       IF (INIT='‡') OR (INIT='€‡')
         OR (INIT='‚') OR (INIT='‘') OR (INIT='„')
         THEN
           BEGIN
             SETCL(CLS,134,133,SYA);
             TKN:=COPY(TKN,1,L-3)+'‚’';
           END
       ELSE
         BEGIN
           SETCL(CLS,37,33,SYA);
           TKN:=COPY(TKN,1,L-1)+'’';
         END;
    '‹':
       IF (INIT='‡') OR (INIT='€‡')
         OR (INIT='‚') OR (INIT='‘') OR (INIT='„')
         THEN
           BEGIN
             SETCL(CLS,136,135,SYA);
             TKN:=COPY(TKN,1,L-3)+'‹’';
           END
       ELSE
         BEGIN
           SETCL(CLS,37,33,SYA);
           TKN:=COPY(TKN,1,L-1)+'’';
         END;
    ELSE EROUT;
  END;
  IF SYA
    THEN TKN := TKN + '‘';
END;

FUNCTION WOSONOR (TKN : STR115) : BOOLEAN;
       (*=======*)
  CONST
    MAXWO = 51;
    LISTWO : ARRAY [1..MAXWO] OF STRING [10] =
('…‡‡“','…‹…‘','„','›‘’','…‹“',
'…‹‡“','ƒ‹“','ƒ„','ƒ‹“ƒ‹€‡','ƒ“',
'„','„‹ƒ‚‡',
'‹›‘','‘‹€','“‘','','“„',
'…›‘’','…ƒ‹“','…ƒ“','…„','…‹…',
  '…‘','…‘','…’‚…„',
'‘’','…‘’','„†€','€‘‘',
'‘‚…•›‘’','‘‚…•’‚…„','‘‚…’‹ƒ‹€‡','‘…„„',
  '‘…','‘…ƒ‹€‡','‘…ƒ‹€‡','‘‚…','‘',
  '‘','‘’€',
'’‚…„','’‚…„‹','’‹‘’“‡',
'•“','•€','“‡‹',
'—…ƒ‹€‡','—“†„','—“€‡','“‘’','™…„');  
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR TST (LISTWO[I]);
  UNTIL FOUND OR (I = MAXWO);
  WOSONOR := FOUND;
END;

FUNCTION WOSONOY (TOKEN: STR115) : BOOLEAN;
       (*=======*)
  CONST
    MAXWOY = 12;
    LISTWOY : ARRAY [1..MAXWOY] OF STRING [9] =
('‘','‚','†‚','‹„','…‹„','','‘…„',
'‘“','‘‹…','‘›','’“','•“„');  
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TOKEN = LISTWOY[I]);
  UNTIL FOUND OR (I = MAXWOY);
  WOSONOY := FOUND;
END;

FUNCTION WOSONIY (TOKEN: STR115) : BOOLEAN;
       (*=======*)
  CONST
    MAXWIY = 30;
    LISTWIY : ARRAY [1..MAXWIY] OF STRING [11] =
('…‡‹','‹‡“','‘ƒ','‚…’•','‚›‘',
'ƒ‹“','„€‹…','„‚','„', 
'‘','€‘™…','ƒ‹',
'…‚›‘','…ƒ‹“','…„€‹…','…‘’ƒ',
'…','„','„','’‹ƒ',
'‹ƒ','€‡‹','‡‚™…',
'‘‚…•‚›‘','‘‚…•ƒ‹“','‘’ƒ',
'’•','“ƒ','““ƒ',''); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TOKEN = LISTWIY[I]);
  UNTIL FOUND OR (I = MAXWIY);
  WOSONIY := FOUND;
END;

FUNCTION WSONIY (TOKEN: STR115) : BOOLEAN;
       (*======*)
  CONST
    MAXWIY = 87;
    LISTWIY : ARRAY [1..MAXWIY] OF STRING [11] =
('‹‡','‘','‚…‘','‚‡',
'ƒ€„','ƒ','ƒ‹€„','ƒ','ƒ‡„','ƒ“‹',
'„…‡','…„','…',
'†€‹','†€','†…‘’','†„','†“’',
'‡‚','‡','‡›','‡','†€',
'‹','’','€’','…','’',
'‹…ƒ','‹','‹‚','‹',
'…‹','…’','…‡','ƒ',
'…‹‡','…ƒ','…ƒ','…†€','……',
'…‹…ƒ','…‹‚','…€','……„','……‡',
'…‘‹€„','…—…’','…—“’','…','‡',
'€„','‹€‚','‹‘','›’','›‹',
'…„','…‡','',
'‘‚…•†…‘’','‘‚…•ƒ','‘‚…•‡','‘‚…•’',
  '‘‹‡','‘‹€„',
'’…','’','’','’“„…','’‘','’“ƒ‹€‚',
'“‡','•“','—…’','—“’', 
'•‚€’','•‹…‘’','•‹','•‹','•„','•“','•“‘’',
'–…','€’','…ƒ…','',''); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TOKEN = LISTWIY[I]);
  UNTIL FOUND OR (I = MAXWIY);
  WSONIY := FOUND;
END;

FUNCTION AFFRI (TOKEN: STR115) : BOOLEAN;
       (*=====*)
  CONST
    MAXFRI = 35;
    LISTFRI : ARRAY [1..MAXFRI] OF STRING [15] =
('…‹†','…‘‘’›†','‚…‡“—','‚—',
'ƒ—','„…“—',
'†ƒ“—','†‚“—','‹…’“—','‹—','ƒ“—',
'…‡—','…ƒ†','…ƒ—','…ƒ†','…•†',
  '…‘‚…„“™','…‘‚…†','…“‹†',
'„™','‘‚‹€ƒ€™',
'€•“—','…‚“—','•†',
'‘‚…•’…“—','‘“—','‘•†',
'’…†','’…‘“—','’ƒ“—',
'“ƒ…’€™','“‡‹…—','—…†',
'“—','‹…—'); 
  VAR
    I : INTEGER;
    FOUND : BOOLEAN;
BEGIN
  FOUND:=FALSE;
  I:=0;
  REPEAT
    INC(I);
    FOUND := FOUND OR (TOKEN=LISTFRI[I]);
  UNTIL FOUND OR (I = MAXFRI);
  AFFRI := FOUND;
END;


BEGIN      (* MAIN *)
  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' THEN
    XL_DAS := '../DAS/';

  ASSIGN (INP2, XL_DAS+'SHORTADJ.DAS');
  RESET (INP2);
  CURSHORT := 0;
  REPEAT
    INC (CURSHORT);
    READLN (INP2, SHORTADJS [CURSHORT]);
  UNTIL EOF (INP2) OR (CURSHORT = MAXSHORT);
  CLOSE (INP2);

  ERCOUNT := 0;
  TKN := DUMMY;
  HEAD := DUMMY;
  ASSIGN (OUT,'SUBJS.COD');
  REWRITE (OUT);
  ASSIGN (OUT1,'SHORTS0.COD');
  REWRITE (OUT1);
  ASSIGN (OUT2,'PREDVERB.COD');
  REWRITE (OUT2);

  GRNUM:=1;          (* DM *)

  FOR I:=0 TO 77 DO
    BEGIN
      FNAME:='OPFUNC'+CHR (ORD ('0')+I DIV 10) +
        CHR (ORD ('0')+I MOD 10)+'.TXT';
      WRITELN ('  FILE ',FNAME,' PROCESSED');
      ASSIGN (INP,FNAME);
      RESET (INP);
      LINENUM := 0;

      REPEAT
  READLN (INP,LINE);
  INC (LINENUM);

  WHILE (LINE [LENGTH (LINE)] = BL) DO
    BEGIN
      WRITELN (FNAME, ' ERROR: Final blank in line ', LINENUM);
      LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
    END;

  LINE0 := LINE;
  IF (LINE[1]<>BL) AND (LINE[1]<>'/') AND (LINE[1]<>'\')
    THEN
      BEGIN
    P := POS('_', LINE);
    IF P > 1
      THEN LINE[P] := '-';
    HEAD := LINE;
    INC(GRNUM);                                        (* DM *)
    WRITELN(OUT, '+', GRNUM : 6, ' 0   0 0 0 ', LINE); (* DM *)
    P:=POS('1',HEAD)+POS('2',HEAD)+POS('3',HEAD)+
      POS('4',HEAD)+POS('5',HEAD)+POS('6',HEAD);
    IF P > 0 
      THEN HEAD:=COPY(HEAD,1,P-1);
    PTKN:='';
      END
    ELSE IF LINE [3]='~'
          THEN
            BEGIN
        STYL:=LINE[2];
        STY:=POS(STYL,'sqpm*');
        IF (STYL<>BL) AND (STY=0)
          THEN WRITELN ('Wrong label at ', LINE);
        TNS:=NPAST;
        LINE0:=COPY(LINE,5,LENGTH(LINE)-4);
        P:=POS ('~',LINE0);
        IF P > 0
          THEN LINE0:=COPY(LINE0,P+2,LENGTH(LINE0)-P-1);
        NEG:=POS(NE,LINE0)=1;
        IF NEG
          THEN LINE0:=COPY(LINE0,4,LENGTH(LINE0)-3);
        NCH:=BL;
        L:=LENGTH(LINE0);
        IF POS(LINE0[L],'123456') > 0
          THEN
            BEGIN
              NCH:=LINE0[L];
              LINE0:=COPY(LINE0,1,L-1);
              DEC(L);
            END;
        TKN:=LINE0;
        ERROR:=FALSE;

        CASE TKN[L] OF

(* 1 *)         '€','','›':
(* ^ *)         BEGIN
(*^…—.“‚€*) LINE0:=COPY(LINE0,1,LENGTH(LINE0)-1);

   (* V *)        CASE LINE0 [LENGTH(LINE0)] OF
   (* 2 *)          '’':
                      IF 
                        (LINE0='“’') OR (LINE0='“‘’') 
                        OR (LINE0='ƒ“‘’')  OR (LINE0='…ƒ“‘’') 
                        OR (LINE0='‘’') OR (LINE0='…‘’')
                        OR (LINE0='•‹‘’') OR (LINE0='‘‚’')
                        OR (LINE0='†’') OR (LINE0='…†’') 
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'‰';
                          END
                      ELSE IF TST('’') OR TST('ƒ“’') OR TST('—…“’')
                        OR (LINE0='‚’…‚€’') OR (LINE0='„ƒ‚€’') 
                        OR (LINE0='‚‹‘€’') OR (LINE0='„›—€’') 
                        OR (LINE0='‚›‘€‡‚’') OR (LINE0='…’')
                        OR (LINE0='…‡’') OR (LINE0='’„…“’') 
                        OR (LINE0='‚…“’') OR (LINE0='“’') 
                        OR (LINE0='‘‹€„‚€’') OR (LINE0='‘‚…’‹‚€’') 
                        OR (LINE0='†“‹‚€’') OR (LINE0='“‘’‚€’')
                        OR (LINE0='ƒ‹“•‚€’') OR (LINE0='‘’‚€’')
                        OR (LINE0='‘‹…‚€’') OR (LINE0='„“‚€’') 
                        OR (LINE0='‡„‚€’') OR (LINE0='„“•‚’')
                        OR (LINE0='€‹‚€’') OR (LINE0='‚…‹‚€’') 
                        OR (LINE0='…„€‡‚’') 
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END
                      ELSE IF (POS (LINE0[LENGTH(LINE0)-1],
                        (*'…›'*)SONOR+CONS1+CONS2) > 0)
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END
                        ELSE EROUT;
   (* 2 *)          '':
                      IF (LINE0='') OR (LINE0='…')
                        OR (LINE0='…') OR (LINE0='•')
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'‰';
                          END
                      ELSE IF (POS (LINE0[LENGTH(LINE0)-1],'…')>0)
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END
                        ELSE EROUT;
   (* 2 *)          '‚':
                      IF (LINE0='†‚') OR (LINE0='…†‚') OR (LINE0='‚')
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'‰';
                          END
                      ELSE IF (LINE0='’€‚')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0;
                          END
                        ELSE
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END;
   (* 2 *)          '':
                      CASE LINE0 [LENGTH (LINE0)-1] OF
            (* 3 *)     '…','€','','' {,''}:
                      IF (LINE0='') OR (LINE0='‘“†„…') 
                        OR (LINE0='‚…’…') OR (LINE0='‡…‹…') 
                        OR (LINE0='…„') OR (LINE0='ƒ€') 
                        OR (LINE0='„') OR (LINE0='“') 
                        OR (LINE0='‘›‹…') OR (LINE0='…‘›‹…') 
                        OR (LINE0='€ƒ') OR (LINE0='’‹…') 
                        OR (LINE0='…“„…') OR (LINE0='“„…') 
                        OR (LINE0='……') OR (LINE0='•†…') 
                        OR (LINE0='„…') OR (LINE0='‘’“„…')
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END
                      ELSE IF (LINE0='€‘‹›€')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=LINE0;
                          END
                      ELSE IF (LINE0='€……')
                        THEN
                          BEGIN
                            CASE NCH OF
                              BL : 
                                 BEGIN
                                   CLS:=0;
                                   SHRTCLS:=1;
                                   TKN:=LINE0;
                                 END;
                              '2' : 
                                 BEGIN
                                   CLS:=1;
                                   SHRTCLS:=1;
                                   TKN:=LINE0+'›‰';
                                 END;
                            END;
                            TNS:=NIHIL;
                          END
                      ELSE
                        BEGIN
                          CLS:=1;
                          SHRTCLS:=1;
                          TNS:=NIHIL;
                          TKN:=LINE0+'›‰';
                        END;
            (* 3 *)     '': { mb wrong! }
                      IF (LINE0='‹€ƒ‘‹‚…') OR (LINE0='…‘‘›‘‹…') 
                        OR (LINE0='‹…‡…') OR (LINE0='…‡‹…‡…')
                        OR (LINE0='…‡‡…') OR (LINE0='…‡‚…’…')
                        OR (LINE0='…‡„…‰‘’‚…')
                        OR (LINE0='…‡†‡…') OR (LINE0='……‡“‡…') 
                        OR (LINE0='…‡€€‡€') OR (LINE0='…‡“‡…')
                        OR (LINE0='…‡€‚‘’‚…') OR (LINE0='…‡›‘“‘‘’‚…') 
                        OR (LINE0='…‡’‚…’‘’‚…') OR (LINE0='…‘…’‘’‚…') 
                        OR (LINE0='…‘”…') OR (LINE0='…‘•‡‰‘’‚…') 
                        OR (LINE0='…‘—‚…') OR (LINE0='‹€†…')
                        OR (LINE0='…‘—‘‹…') OR (LINE0='…‘—“‚‘’‚…') 
                        OR (LINE0='‹€ƒ“‘’…') OR (LINE0='…‹€ƒ“‘’…')
                        OR (LINE0='ƒ‡…') OR (LINE0='‹€ƒ€……')
                        OR (LINE0='†…‘’‚…') OR (LINE0='‚…‹—…‘’‚…')
                        OR (LINE0='‚›‘€€‚‹…') OR (LINE0='‚‘…€€‚‹…') 
                        OR (LINE0='‚›‘‚€‹”–‚€') OR (LINE0='‚››‹…') 
                        OR (LINE0='‚›‘–…’‚€') OR (LINE0='‚‘’‚…') 
                        OR (LINE0='‚›‘€—…‘’‚…') OR (LINE0='…“›‹…')
                        OR (LINE0='‚›‘€‚‘’‚…') 
                        OR (LINE0='‚›‘€‡‚€') 
                        OR (LINE0='‚›‘„€…') OR (LINE0='‚‘’†…') 
                        OR (LINE0='‚›‘’†…‘’‚…') OR (LINE0='‚›‘•“„†…‘’‚…') 
                        OR (LINE0='‚‡„…†€') OR (LINE0='…‚‡„…†€') 
                        OR (LINE0='ƒ…‹‡‚€') OR (LINE0='ƒ‹“›‘‹…') 
                        OR (LINE0='„‚‰‘’‚…') OR (LINE0='„‚“›‘‹…')
                        OR (LINE0='„‘–‹‚€') OR (LINE0='„€—…‘’‚…') 
                        OR (LINE0='„“†…‘’‚…') OR (LINE0='„…‡‚…') 
                        OR (LINE0='„…‰‘’‚…') OR (LINE0='……„…‹…') 
                        OR (LINE0='…‘‘‹…') OR (LINE0='‡…')
                        OR (LINE0='…„‘’‚…') OR (LINE0='…‘’…‘’‚…') 
                        OR (LINE0='†…‘’‚…') OR (LINE0='†‡…') 
                        OR (LINE0='‡‹€—…‘’‚…') 
                        OR (LINE0='‡…†…') OR (LINE0='‡›‘€') 
                        OR (LINE0='‘“‘‘’‚…') OR (LINE0='€‡€…') 
                        OR (LINE0='‚€‹”–‚€') OR (LINE0='…’‚…') 
                        OR (LINE0='€‹—‘‹…') OR (LINE0='€‹€‘…‹…') 
                        OR (LINE0='“†…‘’‚…') OR (LINE0='…‘“…') 
                        OR (LINE0='…‚„€') OR (LINE0='…„ƒ’‚‹…') 
                        OR (LINE0='…„‘–‹‚€')
                        OR (LINE0='…“€‚‚……')
                        OR (LINE0='‚…™…‘’‚…') OR (LINE0='…‚…™…‘’‚…')
                        OR (LINE0='€„“€') OR (LINE0='€ƒ€') 
                        OR (LINE0='…‘‚€') OR (LINE0='……„“…†„…') 
                        OR (LINE0='€……') OR (LINE0='€›™…')
                        OR (LINE0='€†…') OR (LINE0='‡™…') 
                        OR (LINE0='€‘‹‘’‚…') OR (LINE0='€‘’†…') 
                        OR (LINE0='…†‡…') OR (LINE0='…“†„…') 
                        OR (LINE0='……‘’…‘’‚…') OR (LINE0='…€‘‹‘’‚…') 
                        OR (LINE0='…“……') OR (LINE0='…’…‘€') 
                        OR (LINE0='€‚‘’‚…') OR (LINE0='‹…ƒ›‘‹…')
                        OR (LINE0='™“‘’‚…') OR (LINE0='…‡…')
                        OR (LINE0='ƒ—‘‹…') OR (LINE0='…ƒ—‘‹…') 
                        OR (LINE0='…‚‘’€') OR (LINE0='…†„€') 
                        OR (LINE0='…‚…†…‘’‚…') OR (LINE0='…„€—…‘’‚…')
                        OR (LINE0='…‚€‹”–‚€') OR (LINE0='…‡€‘‹“†…') 
                        OR (LINE0='…’‚‚€') OR (LINE0='……‡“‡…') 
                        OR (LINE0='……„‹…') OR (LINE0='…‘‡€') 
                        OR (LINE0='…ƒ€‡‚€') OR (LINE0='…‚‘’‚…')
                        OR (LINE0='……„€……') OR (LINE0='…„“†…‘’‚…') 
                        OR (LINE0='……‚‡‰„…') OR (LINE0='…€')
                        OR (LINE0='…„“€') OR (LINE0='…‘“™…‘’‚…')
                        OR (LINE0='…€—…‘’‚…') OR (LINE0='…‘‹›•€')
                        OR (LINE0='…€‚„€') OR (LINE0='…‘…„‘’‚…') 
                        OR (LINE0='…‘‚‰‘’‚…') OR (LINE0='…“‚……')
                        OR (LINE0='…“‘’…') OR (LINE0='…‚›„…†€') 
                        OR (LINE0='…“‡„€') 
                        OR (LINE0='‡€—…‘’‚…') OR (LINE0='…‘„…†€') 
                        OR (LINE0='€‡‚€') OR (LINE0='™…‡€') 
                        OR (LINE0='ƒ€—…') OR (LINE0='…ƒ€—…') 
                        OR (LINE0='„“•’‚…') OR (LINE0='„“…‚‹…') 
                        OR (LINE0='„“€') OR (LINE0='’‚‹…—…')  
                        OR (LINE0='‘‚€') OR (LINE0='›„…') 
                        OR (LINE0='†…‘’—…') OR (LINE0='‡‹€……') 
                        OR (LINE0='‚€‚‹…') OR (LINE0='€‚„€') 
                        OR (LINE0='’‚…’‘’‚…') OR (LINE0='‘…„‘’‚…') 
                        OR (LINE0='‘›‘‹…') OR (LINE0='…‘›‘‹…')
                        OR (LINE0='„‚“‘›‘‹…') OR (LINE0='…„‚“‘›‘‹…')
                        OR (LINE0='ƒ“™…‘’‚…') OR (LINE0='‚‘…ƒ“™…‘’‚…')
                        OR (LINE0='‘‚‰‘’‚…') OR (LINE0='…„‹…') 
                        OR (LINE0='’—€') OR (LINE0='’—“†„…') 
                        OR (LINE0='…„€……') OR (LINE0='‡…‹…') 
                        OR (LINE0='’‚…‘’…‘’‚…')
                        OR (LINE0='€‘‘…') OR (LINE0='€‘’…') 
                        OR (LINE0='€‡……') OR (LINE0='‘‚€') 
                        OR (LINE0='„‘’‚…') OR (LINE0='›–€‘’‚…') 
                        OR (LINE0='‘€€„…') OR (LINE0='‘‚…•…‘’…‘’‚…')
                        OR (LINE0='‘€“‚……') OR (LINE0='‘€’‚…†…') 
                        OR (LINE0='‘€‚‹‹…') OR (LINE0='‘’‚…’‘’‚…')
                        OR (LINE0='‘—“‚‘’‚…') OR (LINE0='‘“™…‘’‚…') 
                        OR (LINE0='’†…‘’‚…') OR (LINE0='’€‘’‚…') 
                        OR (LINE0='“‰‘’‚…') OR (LINE0='“…„…') 
                        OR (LINE0='“……') OR (LINE0='“’€') 
                        OR (LINE0='“›‹…') OR (LINE0='“‡…')
                        OR (LINE0='“’—…') OR (LINE0='“’‚…') 
                        OR (LINE0='–…‹…€€‚‹…') OR (LINE0='–…‹…“‘’…‹…') 
                        OR (LINE0='–€‘’‚…') OR (LINE0='–…‹“„…') 
                        OR (LINE0='–‚‹‡‚€') OR (LINE0='–…‹—‘‹…') 
                        OR (LINE0='—“‚‘’‚…') OR (LINE0='—“„„…‰‘’‚…') 
                        OR (LINE0='‘’…') OR (LINE0='‚‘’‚…') 
                        THEN
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END
                        ELSE
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END;
            (* 3 *)     '':
                      IF (LINE0 = '‹') OR (LINE0 = '•…‹')
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=LINE0+'‰';
                          END
                      ELSE IF (LINE0 = '‚‹')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=4;
                            TNS:=NIHIL;
                            TKN:=COPY(LINE0,1,LENGTH(LINE0)-2)+'…';
                          END
                        ELSE
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END;
            (* 3 *)     '‰':
                          IF (LINE0 = '„‘’‰')
                            THEN
                              BEGIN
                                CLS:=2;
                                SHRTCLS:=5;
                                TNS:=NIHIL;
                                TKN:=LINE0+'›‰';
                              END
                            ELSE
                              BEGIN
                                CLS:=2;
                                SHRTCLS:=3;
                                TNS:=NIHIL;
                                TKN:=LINE0+'›‰';
                              END;
            (* 3 *)     '‹':
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=4;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END;
            (* 3 *)     '','‚','„','†','‡','','',
                        '','‘','’','”','—','','™':
                      IF (LINE0 = '‘…') OR (LINE0 = '…‘…') 
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=5;
                            TNS:=NIHIL;
                            TKN:=LINE0+'‰';
                          END
                      ELSE IF (LINE0='„‹†')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=COPY(LINE0,1,LENGTH(LINE0)-1)+'…';
                          END
                      ELSE IF (LINE0='„')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=6;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'';
                          END
                      ELSE IF (LINE0 = '„“') OR (LINE0 = '…„“')
                        OR ( (LINE0 = '—“„') AND
                          ((HEAD = '‡‚™…') OR (HEAD = '‹–')) ) 
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=LINE0+'‰';
                          END
                        ELSE
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=LINE0+'›‰';
                          END;
            (* 3 *)     ELSE
                        IF (POS (LINE0 [LENGTH(LINE0)-1], CONS1+CONS2) > 0)
                          THEN
                            BEGIN
                              CLS:=2;
                              SHRTCLS:=1;
                              TNS:=NIHIL;
                              TKN:=LINE0+'›‰';
                            END
                         ELSE EROUT;
                      END;
   (* 2 *)        '‹':
          IF (COPY(TKN,1,4)='‹') AND (NCH = '1')
            THEN
              BEGIN
                CLS:=9;
                SHRTCLS:=1;
                TNS:=NIHIL;
                NCH:=BL;
                TKN:=COPY(TKN,1,L-1)+'›‰';
              END
          ELSE IF (COPY(TKN,L-5,5)='’†…‹') OR (COPY(TKN,L-5,5)='‚…‘…‹') 
            OR (COPY(TKN,L-5,5)='„……‹') OR (COPY(TKN,1,L-1)='‹') 
            OR (COPY(TKN,1,L-1)='…‡…‹') OR (COPY(TKN,1,L-1)='…‹')
            OR (COPY(TKN,L-3,3)='–…‹') OR (COPY(TKN,1,L-1)='…‹') 
            OR (COPY(TKN,1,L-1)='•‹') OR (COPY(TKN,L-4,4)='„‹') 
            OR (COPY(TKN,L-4,4)='“•‹') AND (COPY(TKN,L-7,7)<>'€‘“•‹') 
              AND (COPY(TKN,L-5,5)<>'“•‹') AND (COPY(TKN,L-6,6)<>'€“•‹')
              AND (COPY(TKN,L-6,6)<>'‚‘“•‹')
            OR (COPY(TKN,L-5,5)='‡ƒ‹') OR (COPY(TKN,L-4,4)='›•‹')
            OR (COPY(TKN,L-3,3)='ƒ‹') OR (COPY(TKN,L-7,7)='‘“‡‹') 
            OR (COPY(TKN,L-5,5)='“ƒ‹') OR (COPY(TKN,L-5,5)='“ƒ‹') 
            OR (COPY(TKN,L-5,5)='‘‚…’‹') OR (COPY(TKN,L-6,6)='‚›“‹')
            OR (COPY(TKN,L-5,5)='‹…‹') AND (COPY(TKN,L-7,7)<>'‹…‹')
            OR (COPY(TKN,L-4,4)='…ƒ‹') OR (COPY(TKN,L-4,4)='€ƒ‹')  
            OR (COPY(TKN,L-8,8)='€‹‘‹') OR (COPY(TKN,L-9,9)='‡‘‹')
            OR (COPY(TKN,L-8,8)='ƒ’…‹') OR (COPY(TKN,L-4,4)='‘‹') 
            OR (COPY(TKN,L-5,5)='„•‹') {OR (COPY(TKN,L-5,5)='„‹')} 
            OR (COPY(TKN,L-5,5)='…€‹') {OR (COPY(TKN,L-4,4)='•‹')} 
            OR (COPY(TKN,L-6,6)='…‡…‹') OR (COPY(TKN,L-6,6)='…“…‹')
            OR (COPY(TKN,L-6,6)='…‘…‹') OR (COPY(TKN,L-6,6)='…‘…‹')
            OR (COPY(TKN,L-5,5)='‘“’“‹') OR (COPY(TKN,L-5,5)='’“‘‹') 
            OR (COPY(TKN,L-4,4)='—€•‹') 
            OR (COPY(TKN,L-10,10)='‘“‹') OR (COPY(TKN,L-4,4)='™“‹')
            OR (COPY(TKN,L-4,4)='’“•‹')  
              AND (COPY(TKN,L-6,6)<>'’“•‹') AND (COPY(TKN,L-7,7)<>'’“•‹')
            OR (COPY(TKN,L-4,4)='“›‹')
            OR (COPY(TKN,L-4,4)='‹') AND ( (HEAD='ƒ›')
              OR (HEAD='‘’') OR (HEAD='') OR (HEAD='€…')
              OR (HEAD='‚‡ƒ‹„›') OR (HEAD='“’€') OR (HEAD='“’') 
              OR (HEAD='”’') OR (HEAD='“‡›€') )
            OR (COPY(TKN,L-4,4)='‘‹') AND ( (HEAD='„…‚“')
              OR (HEAD='€') OR (HEAD='‹„›… ‹„') )
            OR (TKN='€‹') AND ( (HEAD='‡€…‚')
              OR (HEAD='‹€') OR (HEAD='‘‹–…') )
            OR (COPY(TKN,1,L-1)='…‘…‹') OR (COPY(TKN,1,L-1)='‚‹') 
            OR (COPY(TKN,1,L-1)='‘‹')
            THEN
              BEGIN
                CLS:=9;
                SHRTCLS:=1;
                TNS:=NIHIL;
                TKN:=COPY(TKN,1,L-1)+'›‰';
              END
          ELSE IF (COPY(TKN,1,L-1)='‘…‹')
            OR (COPY(TKN,1,L-1)='‘•€‹')
            THEN
              BEGIN
                CLS:=3;
                TKN:=COPY(TKN,1,L-2)+'’';
              END
          ELSE IF (COPY(TKN,1,L-1)='‘…‹')
            THEN
              BEGIN
                IF NCH = '1'
                  THEN
                    BEGIN
                      CLS:=9;
                      SHRTCLS:=1;
                      TNS:=NIHIL;
                      TKN:=COPY(TKN,1,L-1)+'›‰';
                    END
                  ELSE
                    BEGIN
                      CLS:=54;
                      TKN:=COPY(TKN,1,L-2)+'‘’';
                    END;
                NCH := BL;
              END
          ELSE IF (LINE0='€‹') 
            THEN
              BEGIN
                CLS:=0;
                SHRTCLS:=1;
                TNS:=NIHIL;
                TKN:=LINE0;
              END
          ELSE IF (COPY(TKN,1,L-1)='‡‹')
            THEN
              BEGIN
                CLS:=4;
                SHRTCLS:=4;
                TNS:=NIHIL;
                TKN:=COPY(TKN,1,L-1)+'‰';
              END
          ELSE IF (COPY(TKN,1,L-1)='’…‹') 
            OR (COPY(TKN,1,L-1)='‘‹')
            THEN
              BEGIN
                CLS:=9;
                SHRTCLS:=2;
                TNS:=NIHIL;
                TKN:=COPY(TKN,1,L-1)+'›‰';
              END
          ELSE IF (COPY(TKN,L-4,4)='‘€‹')
            THEN
              BEGIN
                IF NCH = '1'
                  THEN
                    BEGIN
                      CLS:=61;
                      TKN:=COPY(TKN,1,L-2)+'‘’';
                    END
                  ELSE
                    BEGIN
                      CLS:=170;
                      TKN:=COPY(TKN,1,L-2)+'’';
                    END;
                TNS:=PAST;
                NCH := BL;
              END
          ELSE IF COPY(TKN,L-3,2)='†ƒ'
            THEN
              BEGIN
                TNS:=PAST;
                INIT:=COPY(TKN,1,L-4);
                IF (INIT='€‡') OR (INIT='‘') 
                  OR (INIT='') OR (INIT='„')
                  THEN
                    BEGIN
                      TKN:=COPY(TKN,1,LENGTH(TKN)-5)+'†…—';
                      CLS:=155;
                    END
                   ELSE
                     BEGIN
                       TKN:=COPY(TKN,1,LENGTH(TKN)-3)+'…—';
                       CLS:=26;
                     END
              END
          ELSE IF (COPY(TKN,L-5,4)='„') { /„‹€/ }
            OR (COPY(TKN,L-5,4)='„•') { „•‹€/ }
            OR (COPY(TKN,1,4)='ƒ') { ƒ‹€/ }
            OR (COPY(TKN,1,3)='‘•') AND (COPY(TKN,4,2)<>'€') { ‘•‹€/ }
            OR (COPY(TKN,1,3)='‡') { ‡‹€/ }
            THEN         
              BEGIN
                CLS:=288;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END
          ELSE IF (COPY(TKN,L-5,4)='‹') { ‡€/‘/‹‹€/ }
            OR (COPY(TKN,L-5,4)='‹…') { ‡€/‹…‹€/ }
            OR (COPY(TKN,L-5,4)='‘‹€') { €‘/‘‹€‹€/ }
               { insert ROOT_10 OR STEM_10 !!! }
            THEN
              BEGIN
                CLS:=10;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END
          ELSE IF (COPY(TKN,L-5,4)='›„') { /›„‹/€/ }
            THEN         
              BEGIN
                CLS:=235;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END
          ELSE IF COPY(TKN,L-5,4)='’‹' { ’‹‹€/ }
            THEN
              BEGIN
                CLS:=251;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-3)+'—';
              END
          ELSE IF COPY(TKN,L-5,4)='ƒ›‡' { ƒ›‡‹€/ }
            THEN
              BEGIN
                CLS:=256;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'’';
              END
          ELSE IF COPY(TKN,L-2,1)='—'
            THEN
              BEGIN
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'…‘’';
                CLS:=45;
              END
          ELSE
            CASE LINE0 [LENGTH (LINE0)-1] OF
            (* 3 *)         '':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                IF (TKN = '‘•€')
                  THEN
                    BEGIN
                      TKN:=TKN+'’';
                      CLS:=7;
                    END
                ELSE ILFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)         '€':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                ALFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)         '…':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                ELFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)         '':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                YALFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)         '“':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                ULFIN(TKN,CLS,FALSE);
                TKN:=TKN+'“’';
              END;
            (* 3 *)         '›':
              BEGIN
                TKN:=COPY(TKN,1,L-1);
                TNS:=PAST;
                YLFIN(TKN,CLS,FALSE);
                TKN:=COPY(TKN,1,L-2)+'’';
              END;
            (* 3 *)         '':
              BEGIN
                CLS:=116;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'’';
              END;
            (* 3 *)           '„': { ›„‹€/ }
              BEGIN
                CLS:=235;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END;
            (* 3 *)         '':
              IF L=3
                THEN
                  BEGIN
                    TKN:='„’';
                    TNS:=PAST;
                    CLS:=124;
                  END
                ELSE
                  BEGIN
                    TKN:=COPY(TKN,1,L-3)+'‰’';
                    TNS:=PAST;
                    IF TKN='‰’'
                      THEN CLS:=153
                      ELSE CLS:=6;
                  END;
            (* 3 *)         ELSE
              IF (POS (LINE0 [LENGTH (LINE0)-1], CONS1) > 0)
                THEN
                  BEGIN
                    TKN:=COPY(TKN,1,L-2);
                    SHORTFIN(TKN,CLS,FALSE);
                  END
                ELSE EROUT;
            END;
    (* 2 *)     '','','‡','‘','','„':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-1);
           L:=LENGTH(TKN);

           IF WOSONOR (TKN) OR (TKN='‘‹€')
             OR (COPY(TKN,L-5,6)='‚‹‘')
             OR (COPY(TKN,L-5,6)='ƒ‹‘')
             THEN
               BEGIN
                 CLS:=9;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'›‰';
               END
           ELSE IF (TKN='€„') OR (TKN='ƒ€‡„') OR (TKN='‹')
             THEN
               BEGIN
                 CLS:=0;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
               END
           ELSE IF (TKN='•’') OR (TKN='…•’')
             THEN
               BEGIN
                 CLS:=9;
                 SHRTCLS:=3;
                 TNS:=NIHIL;
                 TKN:=TKN+'›‰';
               END
           ELSE IF WOSONOY (TKN)
             THEN
               BEGIN
                 CLS:=4;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE EROUT;
         END;
    (* 2 *)     'ƒ','','•':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-1);
           L:=LENGTH(TKN);
           IF (TKN='…‚…‹')
             THEN
               BEGIN
                 CLS:=0;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
               END
           ELSE IF (TKN='‚…‹')
             THEN
               BEGIN
                 CASE NCH OF
                   '1' : 
                     BEGIN
                       CLS:=10;
                       SHRTCLS:=1;
                       TKN:=TKN+'‰';
                     END;
                   '2' : 
                     BEGIN
                       CLS:=0;
                       SHRTCLS:=2;
                     END;
                 END;
                 NCH:=BL;
                 TNS:=NIHIL;
               END
           ELSE IF WOSONIY (TKN) OR (TKN='†…‘’')
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF WSONIY (COPY(TKN,1,L-1))
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='‰') OR (TKN='…‰') 
             OR (COPY(TKN,L-4,5)='‘’‰')
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=3;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='ƒ') 
             THEN
               BEGIN
                 CLS:=10;
                 TNS:=NIHIL;
                 SHRTCLS:=4;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='€„……') OR (TKN='€„…•') 
             OR (TKN='„……') OR (TKN='„…•') 
             OR (TKN='‹……') OR (TKN='‹…•') 
             OR (TKN='‘‹…')
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=5;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='’†')
            THEN
              BEGIN
                CLS:=10;
                SHRTCLS:=5;
                TNS:=NIHIL;
                TKN:=TKN+'‰';
              END
           ELSE IF (TKN='„‹ƒ') OR (TKN='…„‹ƒ') 
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=6;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='„ƒ') OR (TKN='…„ƒ') 
             OR (TKN='‹•') OR (TKN='‹€ƒ') OR (TKN='‚‘…‹€ƒ') 
             OR (TKN='ƒ‹“•') OR (TKN='€ƒ')
             OR (TKN='‹•') OR (TKN='…‹•') 
             OR (TKN='‘“•') OR (TKN='’“ƒ')
             THEN
               BEGIN
                 CLS:=5;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE EROUT;
         END;
    (* 2 *)            '†','—','','™':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-1);
           L:=LENGTH(TKN);
 
           IF AFFRI(TKN) OR (TKN [L]='™')
             THEN
               BEGIN
                 CLS:=3;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='‘‚…†') OR (TKN='ƒ—') 
             OR (TKN='•') OR (TKN='…•')
             THEN
               BEGIN
                 CLS:=3;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE EROUT;
         END;
    (* 2 *)       '–': 
         BEGIN
	   CLS:=22;
	   SHRTCLS:=1;
           TNS:=NIHIL;
           TKN:=COPY(TKN,1,LENGTH(TKN)-1)+'›‰';
         END;
    (* 2 *) ELSE EROUT;
              END;
                END;

(* 1 *)         '':
                  BEGIN
                    LINE0:=COPY(LINE0,1,LENGTH (LINE0)-1);
                    CASE LINE0 [LENGTH (LINE0)] OF
   (* 2 *)            '‹':
          IF COPY(TKN,L-3,2)='†ƒ'
            THEN
              BEGIN
                TNS:=PAST;
                INIT:=COPY(TKN,1,L-4);
                IF (INIT='€‡') OR (INIT='‘') 
                  OR (INIT='') OR (INIT='„')
                  THEN
                    BEGIN
                      TKN:=COPY(TKN,1,LENGTH(TKN)-5)+'†…—';
                      CLS:=155;
                    END
                  ELSE
                    BEGIN
                      TKN:=COPY(TKN,1,LENGTH(TKN)-3)+'…—';
                      CLS:=26;
                    END
              END
          ELSE IF (COPY(TKN,1,L-1)='‘…‹')
            THEN
              BEGIN
                CLS:=3;
                TKN:=COPY(TKN,1,L-2)+'’';
              END
          ELSE IF (COPY(TKN,L-5,4)='„') { /„‹€/ }
            OR (COPY(TKN,L-5,4)='„•') { „•‹€/ }
            OR (COPY(TKN,1,4)='ƒ') { ƒ‹€/ }
            OR (COPY(TKN,1,3)='‘•')  AND (COPY(TKN,4,2)<>'€') { ‘•‹€/ }
            OR (COPY(TKN,1,3)='‡') { ‡‹€/ }
            THEN         
              BEGIN
                CLS:=288;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END
          ELSE IF (COPY(TKN,L-5,4)='‹') { ‡€/‘/‹‹ }
            OR (COPY(TKN,L-5,4)='‹…') { ‡€/‹…‹ }
            OR (COPY(TKN,L-5,4)='‘‹€') { €‘/‘‹€‹ }
            OR (COPY(TKN,L-4,3)='ƒ') { /ƒ‹ }
               { insert ROOT_10 OR STEM_10 !!! }
            THEN
              BEGIN
                CLS:=10;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END
          ELSE IF (COPY(TKN,L-5,4)='›„') { ›„‹ }
            THEN         
              BEGIN
                CLS:=235;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END
          ELSE IF COPY(TKN,L-5,4)='’‹'  (*’‹—/‹*)
            THEN
              BEGIN
                CLS:=251;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-3)+'—';
              END
          ELSE IF COPY(TKN,L-4,3)='‹…ƒ'   (*‹…—/ƒ‹*)
            THEN
              BEGIN
                CLS:=145;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-3)+'—';
              END
          ELSE IF COPY(TKN,L-5,4)='ƒ›‡'  (*ƒ›‡‹*)
            THEN
              BEGIN
                CLS:=256;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'’';
              END
            ELSE
              CASE LINE0 [LENGTH (LINE0)-1] OF
            (* 3 *)           '€':
            IF (TKN='‘€‹')
              THEN
                BEGIN
                  IF NCH = '1'
                    THEN
                      BEGIN
                        CLS:=61;
                        TKN:=COPY(TKN,1,L-2)+'‘’';
                      END
                    ELSE
                      BEGIN
                        CLS:=170;
                        TKN:=COPY(TKN,1,L-2)+'’';
                      END;
                  TNS:=PAST;
                  NCH := BL;
                END
              ELSE
                BEGIN
                  TKN:=COPY(TKN,1,L-3);
                  TNS:=PAST;
                  ALFIN(TKN,CLS,FALSE);
                END;
            (* 3 *)           '…':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                ELFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)           '':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                ILFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)           '':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                YALFIN(TKN,CLS,FALSE);
              END;
            (* 3 *)           '“':
              BEGIN
                TKN:=COPY(TKN,1,L-3);
                ULFIN(TKN,CLS,FALSE);
                TKN:=TKN+'“’';
              END;
            (* 3 *)           '›':
              BEGIN
                TKN:=COPY(TKN,1,L-1);
                TNS:=PAST;
                YLFIN(TKN,CLS,FALSE);
                TKN:=COPY(TKN,1,L-2)+'’';
              END;
            (* 3 *)           '':
              BEGIN
                CLS:=116;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'’';
              END;
            (* 3 *)           '„': { ›„‹ }
              BEGIN
                CLS:= 235;
                TNS:=PAST;
                TKN:=COPY(TKN,1,L-2)+'“’';
              END;
            (* 3 *)           '':
              IF L=3
                THEN
                  BEGIN
                    TKN:='„’';
                    TNS:=PAST;
                    CLS:=124;
                  END
                ELSE
                  BEGIN
                    TKN:=COPY(TKN,1,L-3)+'‰’';
                    TNS:=PAST;
                    IF TKN='‰’'
                      THEN CLS:=153
                      ELSE CLS:=6;
                  END;
            (* 3 *)           '—':
                IF COPY(TKN,1,3)='‘—'
                  THEN
                BEGIN
            CLS:=177;
            TNS:=PAST;
            TKN:=COPY(TKN,1,L-4)+'—…‘’';
                END
                  ELSE
                BEGIN
            CLS:=45;
            TNS:=PAST;
            TKN:=COPY(TKN,1,L-2)+'…‘’';
                END;
            (* 3 *)           ELSE
                IF (POS (LINE0 [LENGTH (LINE0)-1], CONS1)>0)
                  THEN
                    BEGIN
                      TKN:=COPY(TKN,1,L-2);
                      SHORTFIN(TKN,CLS,FALSE);
                    END
                  ELSE EROUT;
                            END;
   (* 2 *)            'ƒ','','•':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-1);
           L:=LENGTH(TKN);

           IF (TKN='…‚…‹')
             THEN 
               BEGIN
                 CLS:=0;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
               END
           ELSE IF (TKN='‚…‹')
             THEN
               BEGIN
                 CASE NCH OF
                   '1' : 
                     BEGIN
                       CLS:=10;
                       SHRTCLS:=1;
                       TKN:=TKN+'‰';
                     END;
                   '2' : 
                     BEGIN
                       CLS:=0;
                       SHRTCLS:=2;
                     END;
                 END;
                 NCH:=BL;
                 TNS:=NIHIL;
               END
           ELSE IF WOSONIY(TKN) OR (TKN='†…‘’')
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF WSONIY (COPY(TKN,1,L-1))
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='‰') OR (TKN='…‰') 
             OR (COPY(TKN,L-4,5)='‘’‰')
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=3;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='ƒ') 
             THEN
               BEGIN
                 CLS:=10;
                 TNS:=NIHIL;
                 SHRTCLS:=4;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='€„……') OR (TKN='€„…•') 
             OR (TKN='„……') OR (TKN='„…•')
             OR (TKN='‹……') OR (TKN='‹…•')
             OR (TKN='‘‹…') 
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=5;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='’†')
             THEN
               BEGIN
                 CLS:=10;
                 SHRTCLS:=5;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
            ELSE IF (TKN='„‹ƒ') OR (TKN='…„‹ƒ') 
              THEN
                BEGIN
                  CLS:=10;
                  TNS:=NIHIL;
                  SHRTCLS:=6;
                  TKN:=TKN+'‰';
               END
            ELSE IF (TKN='„ƒ') OR (TKN='…„ƒ') 
              OR (TKN='‹•') OR (TKN='‹€ƒ') OR (TKN='‚‘…‹€ƒ') 
              OR (TKN='ƒ‹“•') OR (TKN='€ƒ')
              OR (TKN='‹•') OR (TKN='…‹•') 
              OR (TKN='‘“•') OR (TKN='’“ƒ')
              THEN
                BEGIN
                  CLS:=5;
                  SHRTCLS:=1;
                  TNS:=NIHIL;
                  TKN:=TKN+'‰';
                END
            ELSE EROUT;
         END;
   (* 2 *)            '†','—','','™':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-1);
           L:=LENGTH(TKN);

           IF AFFRI (TKN) OR (TKN[L] ='™')
             THEN
               BEGIN
                 CLS:=3;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='‘‚…†') OR (TKN='ƒ—') 
             OR (TKN='•') OR (TKN='…•')
             THEN
               BEGIN
                 CLS:=3;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END;
         END;
   (* 2 *)            '':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-1);
           L:=LENGTH(TKN);

           IF (TKN='‚…') OR (TKN='‡‹') 
             OR (TKN='‘…') OR (TKN='…‘…') 
             OR (TKN='„‘’') OR (TKN='€‡‘’')
             THEN
               BEGIN
                 CLS:=8;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='‘')
             THEN
               BEGIN
                 CLS:=8;
                 SHRTCLS:=2;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='…‘€‰')
             THEN
               BEGIN
                 CLS:=8;
                 SHRTCLS:=3;
                 TNS:=NIHIL;
                 TKN:=TKN+'‰';
               END
           ELSE IF (TKN='„')
             THEN
               BEGIN
                 CLS:=0;
                 SHRTCLS:=6;
                 TNS:=NIHIL;
                 TKN:=COPY(TKN,1,L-1)+'';
               END
           ELSE EROUT;
         END;
   (* 2 *)  ELSE EROUT;
              END;
                END;

(* 1 *)         '':
       IF (TKN[L-1]='')
         THEN 
           BEGIN
             TKN := COPY(TKN,1,LENGTH(TKN)-1);
             L:=LENGTH(TKN);

             IF (TKN='‚…') OR (TKN='‡‹') 
               OR (TKN='‘…') OR (TKN='…‘…')
               OR (COPY(TKN,L-7,8)='‘’')
               THEN
                  BEGIN
                    CLS:=8;
                    SHRTCLS:=1;
                    TNS:=NIHIL;
                    TKN:=TKN+'‰';
                  END
              ELSE IF (TKN='‘')
                THEN
                  BEGIN
                    CLS:=8;
                    SHRTCLS:=2;
                    TNS:=NIHIL;
                    TKN:=TKN+'‰';
                  END
              ELSE IF (TKN='…‘€‰')
                THEN
                  BEGIN
                    CLS:=8;
                    SHRTCLS:=3;
                    TNS:=NIHIL;
                    TKN:=TKN+'‰';
                  END
           END
         ELSE IF (LENGTH(TKN)<=4) OR (TKN[L-1]<>'‘')
           THEN EROUT
           ELSE
             BEGIN
               LINE0:=COPY(LINE0,1,LENGTH (LINE0)-2);
               CASE LINE0 [LENGTH (LINE0)] OF
   (* 3 *)       '’':
                   BEGIN
                     CASE LINE0 [LENGTH (LINE0)-1] OF
          (* 4 *)      '…':
                         IF TST('…—…’‘')
                           THEN
                             BEGIN          (*…’€’‘*)
                               CLS:=108;
                               TKN:=COPY(TKN,1,L-5)+'’€’‘';
                             END
                         ELSE IF TST('€…’‘')
                           THEN
                             BEGIN          (*€’‘*)
                               CLS:=92;
                               TKN:=COPY(TKN,1,L-4)+'’‘';
                             END 
                         ELSE IF TST('—…’‘')
                           THEN
                             BEGIN          (*’€’‘*)
                               CLS:=263;
                               TKN:=COPY(TKN,1,L-5)+'’€’‘';
                             END
                         ELSE IF (COPY(LINE0, LENGTH(LINE0)-5, 4)='€‘’')
                           THEN
                             BEGIN          (*‘€‘’‘*)
                               CLS:=51;
                               TKN:=COPY(TKN,1,L-4)+'‘';
                             END
                         ELSE IF TST('‘›‹…’‘')
                           THEN
                             BEGIN          (*‘›€’‘*)
                               CLS:=247;
                               TKN:=COPY(TKN,1,L-5)+'€’‘';
                             END
                         ELSE IF TST('ƒ›‡…’‘')
                           THEN
                             BEGIN          (*ƒ›‡’‘*)
                               CLS:=257;
                               TKN:=COPY(TKN,1,L-4)+'’‘';
                             END
                         ELSE IF (TKN='‡†„…’‘')
                           THEN
                             BEGIN          (*‡†„’‘*)
                               CLS:=243;
                               TKN:=COPY(TKN,1,L-4)+'’‘';
                             END
                         ELSE IF (COPY(LINE0, LENGTH(LINE0)-4, 3)='€‰')
                           THEN
                             BEGIN          (*‡€’‘*)
                               CLS:=69;
                               TKN:=COPY(TKN,1,L-6)+'’‘';
                             END
                         ELSE IF (COPY(LINE0, LENGTH(LINE0)-3, 2)='…—')
                           THEN
                              BEGIN
                                CLS:=21;
                                TKN:=COPY(TKN,1,L-4)+'‘';
                              END
                         ELSE IF (COPY(LINE0,LENGTH (LINE0)-3,2)='')
                           THEN
                             BEGIN            (*’‘*)
                               CLS:=37;
                               TKN:=COPY(TKN,1,L-5)+'’‘';
                             END
                         ELSE
                           BEGIN
                             TKN:=COPY(TKN,1,L-4);
                             DEC(L,4);
                             CASE TKN[L] OF
                    (* 5 *)    '€':
                     IF TST('„€') OR TST('‘‡„€') OR TST('‘’€')
                       OR TST('‡€') AND (TKN<>'‡€')
                       THEN
                         BEGIN
                           CLS:=83;
                           TKN:=TKN+'‚€’‘';
                         END
                       ELSE
                         BEGIN
                           CLS:=4;
                           TKN:=TKN+'’‘';
                         END;
                    (* 5 *)    '':
                     IF TST('')
                       THEN
                         BEGIN
                           CLS:=142;
                           TKN:=COPY(TKN,1,L-1)+'…’‘';
                         END
                       ELSE
                         BEGIN
                           CLS:=97;
                           TKN:=COPY(TKN,1,L-1)+'›’‘';
                         END;
                    (* 5 *)       '“':
                     IF TST('„“') OR TST('“')
                       THEN
                         BEGIN
                           CLS:=4;
                           TKN:=TKN+'’‘';
                        END
                     ELSE IF POS(TKN[L-1],AFFR)>0
                       THEN
                         BEGIN
                           CLS:=82;
                           TKN:=COPY(TKN,1,L-1)+'…‚€’‘';
                         END
                     ELSE
                       BEGIN
                         CLS:=34;
                         TKN:=COPY(TKN,1,L-1)+'‚€’‘';
                       END;
                    (* 5 *)       '':
                     BEGIN
                       CLS:=35;
                       TKN:=COPY(TKN,1,L-1)+'…‚€’‘';
                     END;
                    (* 5 *)       '‹', 'M':
                     ETFIN(TKN,CLS,TRUE);
                    (* 5 *)       '':
                     IF TST('‘’€')
                       THEN
                         BEGIN
                           CLS:=152;
                           TKN:=COPY(TKN,1,L-1)+'’‘';
                         END
                     ELSE IF TST('„…')
                       THEN
                         BEGIN
                           CLS:=95;
                           TKN:=COPY(TKN,1,L-1)+'’‘';
                         END
                     ELSE IF TST('‹')
                       THEN
                         BEGIN
                           CLS:=150;
                           TKN:=COPY(TKN,1,L-1)+'‘’‘';
                         END
                     ELSE IF TST('')
                       THEN
                         BEGIN
                           CLS:=173;
                           TKN:=COPY(TKN,1,L-3)+'’‘';
                         END
                     ELSE IF TST('')
                       THEN
                         BEGIN
                           CLS:=152;
                           TKN:=COPY(TKN,1,L-1)+'’‘';
                         END
                     ELSE IF TST('—')
                       THEN
                         BEGIN
                           CLS:=129;
                           TKN:=COPY(TKN,1,L-1)+'€’‘';
                         END
                     ELSE
                       BEGIN
                         IF TST('ƒ') 
                           OR TST('„‚') OR TST('„“') 
                           OR TST('') OR TST('‹') 
                           OR TST('') OR TST('‹') 
                           OR TST('') OR TST('') 
                           OR TST('‘’›') OR TST('‘“') 
                           OR TST('’')
                           OR (TKN='‚›') OR (TKN='ƒ‹') 
                           OR (TKN='€') OR (TKN='€‡')
                           OR (TKN='‘ƒ') OR TST('•‹›')
                           THEN CLS:=275
                         ELSE IF (POS(TKN [L-1],'€…“›‚’—') > 0)
                           OR STEM_16('')      (*€“’‘*)
                           THEN CLS:=53         (*›“’‘*)
                         ELSE IF (POS(TKN [L-1],'ƒ‡‘•'(*+'„–'*)) > 0)
                           AND (ROOT_10('') OR STEM_10(''))
                           THEN CLS:=5          (*‡€„•“’‘*)
                         ELSE CLS:=53;          (*€–“’‘*)
                         TKN:=TKN+'“’‘';
                       END;
                    (* 5 *)       '†':
                     ZHET (TKN,CLS,TRUE);
                    (* 5 *)       '„':
                     DET (TKN,CLS,TRUE);
                    (* 5 *)       '':
                     BIT6 (TKN,CLS,TRUE);
                    (* 5 *)       '':
                     IF TKN = '€‡……’‘'
                       THEN
                         BEGIN
                           CLS:=184;
                           TKN:='€‡€’‘';
                         END                      
                     ELSE IF TST('…') OR TST('„…')
                       THEN
                         BEGIN
                           CLS:=57;
                           TKN:=COPY(TKN,1,L-2)+'€’‘';
                         END
                     ELSE IF POS(TKN[L-1],'’')>0
                       THEN
                         BEGIN
                           OIN(TKN,CLS,TRUE);
                           TKN:=TKN+'‘';
                         END
                     ELSE IF (TKN[L-1]='')
                       THEN
                         BEGIN
                           CLS:=38;
                           TKN:=TKN+'’‘';
                         END
                     ELSE
                       BEGIN
                         CLS:=12;
                         TKN:=TKN+'€’‘';
                       END;
                    (* 5 *) 
                     ELSE
                       IF TST('…‘') OR TST('€‘') OR TST('’‘')
                         OR TST('‚…‡') OR TST('‹‡')
                         THEN
                           BEGIN
                             CLS:=50;
                             TKN:=TKN+'’‘';
                           END
                       ELSE IF TST('‘…') OR TST('ƒ…')
                         THEN
                           BEGIN
                             CLS:=80;
                             TKN:=COPY(TKN,1,L-1)+'‘’‘';
                           END
                       ELSE IF TST('‹…’')
                         THEN
                           BEGIN
                             CLS:=55;
                             TKN:=COPY(TKN,1,L-1)+'‘’‘';
                           END
                       ELSE IF TST('†')
                         THEN
                           BEGIN
                             CLS:=87;
                             TKN:=COPY(TKN,1,L-1)+'€’‘';
                           END
                       ELSE IF TST('‚')
                         THEN
                           BEGIN
                             CLS:=12;
                             TKN:=TKN+'€’‘';
                           END
                       ELSE IF TST('™') OR TST('›™') 
                         OR TST('‹™') OR TST('‹…™')
                         THEN
                           BEGIN
                             CLS:=89;
                             TKN:=COPY(TKN,1,L-1)+'‘€’‘';
                           END
                       ELSE IF TST('') OR TST('‹') OR TST('—…')
                         THEN
                           BEGIN
                             CLS:=86;
                             TKN:=COPY(TKN,1,L-1)+'‘€’‘';
                           END
                       ELSE IF TST('‹›')
                         THEN
                           BEGIN
                             CLS:=265;
                             TKN:=COPY(TKN,1,L-1)+'•€’‘';
                           END
                       ELSE IF TST('‘…') OR TST('‚…') OR TST('„…') 
                         OR TST('‘…') OR TST('‹…‹…') OR TST('‹€')
                         THEN
                           BEGIN
                             CLS:=92;
                             TKN:=TKN+'’‘';
                           END
                       ELSE IF TKN[L-1]=''
                         THEN
                           BEGIN
                             CLS:=38;
                             TKN:=TKN+'’‘';
                           END
                       ELSE
                         BEGIN
                           CLS:=4;
                           TKN:=TKN+'’‘';
                         END;
                END;
                     END;
          (* 4 *)               '':
            BEGIN
              TKN:=COPY(TKN,1,L-4);
              L := LENGTH(TKN);
              IF TST('') OR TST('') OR TST('‹')
                THEN
                  BEGIN
                    CLS:=38;
                    TKN:=TKN+'’‘';
                  END
              ELSE IF TST('€')
                THEN
                  BEGIN          (*€’‘*)
                    CLS:=92;
                    TKN:=TKN+'’‘';
                  END 
              ELSE IF TST('‘›‹')
                THEN
                  BEGIN
                    CLS:=247;
                    TKN:=COPY(TKN,1,L-1)+'€’‘';
                  END
              ELSE
                CASE TKN[L] OF
                   (* 5 *)        '€','…','','':
              IF TST('„€') OR TST('‘‡„€') OR TST('‘’€')
                OR TST('‡€') AND (TKN<>'‡€')
                THEN
                  BEGIN
                    CLS:=83;
                    TKN:=TKN+'‚€’‘';
                  END
              ELSE IF TST('‘…') OR TST('‚…') OR TST('„…')
                OR TST('‘…') OR TST('‹…‹…') OR TST('‹€')
                THEN
                  BEGIN
                    CLS:=92;
                    TKN:=TKN+'’‘';
                  END
              ELSE IF TKN[L]=''
                THEN
                  IF TST('')
                    THEN
                      BEGIN
                        CLS:=142;
                        TKN:=COPY(TKN,1,L-1)+'…’‘';
                      END
                    ELSE
                      BEGIN
                        CLS:=97;
                        TKN:=COPY(TKN,1,L-1)+'›’‘';
                      END
              ELSE
                BEGIN
                  CLS:=4;
                  TKN:=TKN+'’‘';
                END;
                    (* 5 *)       '“':
                      IF POS(TKN[L-1], AFFR) > 0
                        THEN
                          BEGIN
                            CLS:=35;
                            TKN:=COPY(TKN,1,L-1)+'…‚€’‘';
                          END
                        ELSE
                          BEGIN
                            CLS:=34;
                            TKN:=COPY(TKN,1,L-1)+'‚€’‘';
                          END;
                    (* 5 *)       '':
                      BEGIN
                        CLS:=35;
                        TKN:=COPY(TKN,1,L-1)+'…‚€’‘';
                      END;
                    (* 5 *)       '‹':
             ETFIN (TKN,CLS,TRUE);
                    (* 5 *)       '':
             BIT6 (TKN,CLS,TRUE);
                    (* 5 *)       ELSE EROUT;
                    END;
                  END;
          (* 4 *)               '“':
            IF TST('‘’€')
              THEN
                BEGIN
                  CLS:=152;
                  TKN:=COPY(TKN,1,L-1)+'’‘';
                END
            ELSE IF (TKN='…—“’‘')
              THEN
                BEGIN
                   CLS:=108;
                   TKN:=COPY(TKN,1,L-5)+'’€’‘';
                 END
            ELSE IF (TKN='‡†„“’‘')
              THEN
                BEGIN
                   CLS:=243;
                   TKN:=COPY(TKN,1,L-4)+'’‘';
                 END
            ELSE IF TST('—“’‘')
              THEN
                BEGIN
                  CLS:=263;
                  TKN:=COPY(TKN,1,L-5)+'’€’‘';
                END
            ELSE IF (TKN='ƒ›‡“’‘')
              THEN
                BEGIN
                  CLS:=257;
                  TKN:=COPY(TKN,1,L-4)+'’‘';
                END
            ELSE IF TST('’‹“’‘')
              THEN
                BEGIN
                  CLS:=252;
                  TKN:=COPY(TKN,1,L-5)+'—‘';
                END
            ELSE
              BEGIN
                TKN:=COPY(TKN,1,L-4);
                UTFIN(TKN,CLS,TRUE);
                IF TKN [LENGTH (TKN)]=''
                  THEN TKN:=TKN+'‘'
                  ELSE TKN:=TKN+'‘';
              END;
          (* 4 *)               '':
            IF TST('‘‹’') AND (TKN<>'…‘‘‹')
              OR (TKN='„‚’') OR (TKN='’’')
              THEN
                BEGIN               (*‘‹’‘*) 
                  CLS:=8;
                  TKN:=COPY(TKN,1,L-4)+'’‘';
                END
              ELSE
                BEGIN
                  TKN:=COPY(TKN,1,L-4);
                  ITYAT(TKN,CLS,TRUE);
                END;
          (* 4 *)               '':
          BEGIN
            TKN:=COPY(TKN,1,L-4);
            DEC(L,4);

            IF (POS(TKN[L],AFFR) > 0)
              THEN 
                BEGIN
                  IF ROOT_236 OR STEM_236
                    OR (TKN='’“†') OR (TKN='‘…')
                    OR TST('“—') AND (TKN<>'‚›“—')
                    OR TST('‹€—') 
                      AND (TKN<>'‚‹€—') AND (TKN<>'‹€—')
                    THEN
                      BEGIN            (*€‹…—’‘*)
                        CLS:=237;      
                        TKN:=TKN+'’‘';
                      END
                  ELSE IF TST('„…†') OR TST('‹…†') 
                    OR TST('—') OR TST('„›') 
                    OR TST('—') OR TST('‘’“—')
                    OR TST('›—') OR TST('’…™') 
                    OR TST('™')
                    THEN
                      BEGIN             (*„…†€’‘*)
                        CLS:=112;
                        TKN:=TKN+'€’‘';
                      END
                  ELSE IF TST('‘‹›')  
                    THEN
                      BEGIN             (*‘‹›€’‘*) 
                        CLS:=254;
                        TKN:=TKN+'€’‘';
                      END
                  ELSE
                    BEGIN               (*‡€—’‘*)
                      CLS:=15;
                      TKN:=TKN+'’‘';
                    END
                END
            ELSE IF TST('‘‹') AND (TKN<>'…‘‘‹')
              OR (TKN='„‚') OR (TKN='’')
              THEN
                BEGIN                   (*‘‹’‘*) 
                  CLS:=8;
                  TKN:=TKN+'’‘';
                END
            ELSE IF TST('‘’') OR TST('')
              THEN
                BEGIN                   (*’‘*) 
                  CLS:=118;
                  TKN:=TKN+'’‘';
                END
            ELSE IF TST('ƒ')          (*ƒ€’‘*) 
              THEN
                BEGIN
                  CLS:=88;
                  TKN:=COPY(TKN,1,L-2)+'€’‘';
                END
            ELSE IF TST('‚…‹') OR TST('ƒ') 
              OR TST('‘’') OR TST('‡‚…')
              THEN 
                BEGIN             (*‘’…’‘*) 
                  CLS:=90; 
                  TKN:=TKN+'…’‘'; 
                END
            ELSE IF TST('’…') 
              OR TST('') OR TST('‘')
              OR TST('‘') OR TST('•') 
              THEN 
                BEGIN            (*’……’‘*)
                  CLS:=226; 
                  TKN:=TKN+'…’‘';
                END
            ELSE IF ROOT_217
              THEN
                BEGIN             (*ƒ‹„…’‘*) 
                  CLS:=218; 
                  TKN:=TKN+'…’‘'; 
                END
            ELSE IF TST('‚‘')
              THEN
                BEGIN             (*’‚‘…’‘*)
                  CLS:=224; 
                  TKN:=TKN+'…’‘'; 
                END
            ELSE IF ELINF_ST (TKN)
              THEN              (*‘‚‘’…’‘*)
                BEGIN 
                  CLS:=222; 
                  TKN:=TKN+'…’‘'; 
                END
            ELSE IF TST('‚…’') OR TST('‹…’') 
              THEN 
                BEGIN           (*‚…’…’‘*)
                  CLS:=220; 
                  TKN:=TKN+'…’‘'; 
                END
            ELSE ITYAT(TKN,CLS,TRUE);
          END;
          (* 4 *)               '€':
          BEGIN
            TKN:=COPY(TKN,1,LENGTH(TKN)-4);
            L:= LENGTH(TKN);

            IF TST('„…†') OR TST('‹…†') 
              OR TST('—') OR TST('„›') 
              OR TST('—') OR TST('‘’“—')
              OR TST('›—') OR TST('’…™') 
              OR TST('™')
              THEN
                BEGIN        (*„…†€’‘*) 
                  CLS:=112;
                  TKN:=TKN+'€’‘';
                END
             ELSE IF TST('‘‹›')
               THEN
                 BEGIN       (*‘‹›€’‘*) 
                   CLS:=254;
                   TKN:=TKN+'€’‘';
                 END
             ELSE IF ROOT_236 OR STEM_236 
               OR TST('‹€—') 
                 AND (TKN<>'‚‹€—') AND (TKN<>'‹€—')
               OR TST('“—') AND (TKN<>'‚›“—')
               THEN
                 BEGIN          (*€‹…—’‘*)
                   CLS:=237;
                   TKN:=TKN+'’‘';
                 END
             ELSE
               BEGIN
                 CLS:=15;
                 TKN:=TKN+'’‘';
               END;
          END;
          (* 4 *)               '‘':
          BEGIN
            TKN:=COPY(TKN,1,L-2);
            DEC(L,2);
            IF TST('…‘’')
              THEN
                BEGIN
                  CLS:=29;
                  TKN:=TKN+'‘';
                END
            ELSE IF TST('„€‘’')
              THEN
                BEGIN
                  CLS:=24;
                  TKN:=COPY(TKN,1,L-2)+'’‘';
                END;
          END;
          (* 4 *)  ELSE EROUT;
                     END;
                       END;
     (* 3 *)              '‹':
              BEGIN
                TNS:=PAST;
                CASE LINE0 [LENGTH (LINE0)-1] OF
               (* 4 *)          '…':
                      CASE LINE0 [LENGTH (LINE0)-2] OF
                           (*5*)    '':
                        BEGIN
                          TKN:=COPY(TKN,1,L-5)+'‰’‘';
                          IF (TKN='‰’‘') 
                            THEN CLS:=154
                            ELSE CLS:=13;   (*‘‰’‘*)
                        END;
                           (*5*)    '—':
                        BEGIN            (*—…‘’‘*)
                           CLS:=44;
                           TKN:=COPY(TKN,1,L-4)+'…‘’‘';
                        END;
                            (*5*)    ELSE
                        BEGIN
                          TKN:=COPY(TKN,1,L-4);
                          ELFIN(TKN,CLS,TRUE);
                        END;
                      END;
               (* 4 *)         '':
                        BEGIN
                          TKN:=COPY(TKN,1,L-4);
                          ILFIN(TKN,CLS,TRUE);
                          TKN:=TKN+'‘';
                        END;
               (* 4 *)         '€':
                        BEGIN
                          TKN:=COPY(TKN,1,L-4);
                          ALFIN(TKN,CLS,TRUE);
                          TKN:=TKN+'‘';
                        END;
               (* 4 *)         '':
                        BEGIN
                          TKN:=COPY(TKN,1,L-4);
                          YALFIN(TKN,CLS,TRUE);
                        END;
               (* 4 *)         '“':
                        BEGIN
                          TKN:=COPY(TKN,1,L-4);
                          ULFIN(TKN,CLS,TRUE);
                          TKN:=TKN+'“’‘';
                        END;
               (* 4 *)         '›':
                        BEGIN
                          TKN:=COPY(TKN,1,L-2);
                          YLFIN(TKN,CLS,TRUE);
                          TKN:=COPY(TKN,1,L-3)+'’‘';
                        END;
               (* 4 *)         '':
                        BEGIN
                          CLS:=38;
                          TKN:=COPY(TKN,1,L-3)+'’‘';
                        END;
               (* 4 *)         ELSE EROUT;
                      END;
              END;
     (* 3 *)              '','','‡','‘','','ƒ','','•':
                BEGIN
                  TKN:=COPY(TKN,1,L-2);
                  SHORTFIN(TKN,CLS,TRUE);
                END;
     (* 3 *)              ELSE EROUT;
                    END;
                  END;

(* 1 *)         '':
              IF (TKN='…‘’')
                THEN
                  BEGIN
                    CLS:=19;
                    TNS:=PRES;
                    TKN:='›’';
                  END
              ELSE IF (COPY(TKN,L-7,4)='’‹')
                THEN
                  BEGIN
                    CLS:=252;
                    TNS:=PAST;
                    TKN:=COPY(TKN,1,L-5)+'—‘';
                  END
              ELSE
                IF (L<=4) OR (TKN[L-1]<>'‘')
                  THEN EROUT
                  ELSE
                    BEGIN
                      LINE0:=COPY(LINE0,1,LENGTH (LINE0)-2);
                      CASE LINE0 [LENGTH (LINE0)] OF
    (* 3 *)               '€','','':
           IF LINE0 [LENGTH (LINE0)-1] <> '‹'
             THEN EROUT
           ELSE IF (LINE0 [LENGTH (LINE0)-2]='')
             THEN
               BEGIN
                 TKN:=COPY(TKN,1,L-5)+'‰’‘';
                 TNS:=PAST;
                 IF TKN='‰’‘'
                   THEN CLS:=154
                   ELSE CLS:=13;
               END
           ELSE IF (LINE0 [LENGTH (LINE0)-2]='—')
             THEN
               BEGIN
                 TKN:=COPY(TKN,1,L-4)+'…‘’‘';
                 TNS:=PAST;
                 CLS:=44;
               END
           ELSE IF COPY(LINE0,LENGTH(LINE0)-3,2) ='†ƒ'
             THEN
               BEGIN
                 TNS:=PAST;
                 INIT:=COPY(TKN,1,L-6);
                 IF (INIT='€‡') OR (INIT='‘')
                   OR (INIT='') OR (INIT='„')
                   THEN
                 BEGIN
                   TKN:=COPY(TKN,1,L-7)+'†…—‘';
                   CLS:=156;
                 END
                   ELSE
                 BEGIN
                   TKN:=COPY(TKN,1,L-5)+'…—‘';
                   CLS:=28;
                 END
               END
             ELSE
               CASE LINE0 [LENGTH (LINE0)-2] OF
                (* 5 *)               '€':
                     BEGIN
                       TKN:=COPY(TKN,1,L-5);
                       TNS:=PAST;
                       ALFIN(TKN,CLS,TRUE);
                       TKN:=TKN+'‘';
                     END;
                (*5*)          '…':
                     BEGIN
                       TKN:=COPY(TKN,1,L-5);
                       ELFIN(TKN,CLS,TRUE);
                     END;
                (*5*)          '':
                     BEGIN
                       TKN:=COPY(TKN,1,L-5);
                       ILFIN(TKN,CLS,TRUE);
                       TKN:=TKN+'‘';
                     END;
                (*5*)          '':
                     BEGIN
                       TKN:=COPY(TKN,1,L-5);
                       YALFIN(TKN,CLS,TRUE);
                     END;
                (*5*)          '“':
                     BEGIN
                       TKN:=COPY(TKN,1,L-5);
                       ULFIN(TKN,CLS,TRUE);
                       TKN:=TKN+'“’‘';
                     END;
                (*5*)           '›':
                     BEGIN
                       TKN:=COPY(TKN,1,L-3);
                       TNS:=PAST;
                       YLFIN(TKN,CLS,TRUE);
                       TKN:=COPY(TKN,1,L-4)+'’‘';
                     END;
                (*5*)            '':
                     BEGIN
                       CLS:=38;
                       TNS:=PAST;
                       TKN:=COPY(TKN,1,L-4)+'’‘';
                     END;
                (*5*)            '','','‡','‘','','ƒ','','•':
                     BEGIN
                       TKN:=COPY(TKN,1,L-4);
                       SHORTFIN(TKN,CLS,TRUE);
                     END;
                (*5*)            ELSE EROUT;
                              END
                          ELSE EROUT;
                        END;
                      END;

(*1*)         '':
                  BEGIN
                    CASE LINE0 [LENGTH (LINE0)-1] OF
    (*2*)           '…':               { ISEN(TKN) ‡€……€ }
                      IF (TKN='……') OR (TKN='’‹…') 
                        OR (TKN='‚…’…')
                        OR (TKN='‡…‹…') OR (TKN='‘’“„…') 
                        OR (TKN='…‘›‹…') OR (TKN='‘›‹…') 
                        OR (TKN='‘“†„…') OR (TKN='„…') 
                        OR (TKN='…“„…') OR (TKN='“„…') 
                        OR (TKN='•†…') OR (TKN='—…')
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END
                      ELSE IF (TKN='‚……') OR (TKN='‡‹…') 
                        OR (TKN='‘……') OR (TKN='…‘……') 
                        OR (TKN='„‘’…') OR (TKN='€‡‘’…') 
                        THEN
                          BEGIN
                            CLS:=8;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰';
                          END
                      ELSE IF (TKN='‘’………') 
                        OR (TKN='€’ƒ“€…') OR (TKN='…‡€…‹‹–…')
                        OR (TKN='…‡‚…') OR (TKN='…‡‚………')
                        OR (TKN='…‡„…') OR (TKN='…‡‡€…')
                        OR (TKN='…‡‡€…') OR (TKN='…‡›…–…')
                        OR (TKN='…‘…‘’€…') OR (TKN='…‘—…')
                        OR (TKN='…‘’€‹€…') OR (TKN='…‘–……')
                        OR (TKN='…‘–………') OR (TKN='‹€ƒ‘‹…')
                        OR (TKN='‹€ƒ“•€…') OR (TKN='……')
                        OR (TKN='‚„•‚……') OR (TKN='‚………')
                        OR (TKN='‚’‘’………') OR (TKN='‚›‘ƒ“€…') 
                        OR (TKN='‚›‘–……') OR (TKN='ƒ“€…')
                        OR (TKN='„‹…') OR (TKN='„‹ƒ‚………')
                        OR (TKN='„€ƒ–……') OR (TKN='†…€…')
                        OR (TKN='€’‚………')
                        THEN
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'›‰';
                          END
                      ELSE IF (TKN='„‹†…')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                          END
                      ELSE IF (TKN='‚‹…')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=4;
                            TNS:=NIHIL;
                          END
                      ELSE IF (TKN='‹…') OR (TKN='•…‹…')
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰';
                          END
                      ELSE IF (TKN='…„“…')
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰';
                          END
                      ELSE IF (TKN='„‚‹…') OR (TKN='‹€‹…') 
                        OR (TKN='‘…‚‹…') OR (TKN='„’‹…') 
                        OR (TKN='‚€’…‹…') OR (TKN='€‹…') 
                        OR (TKN='‹‹…') OR (TKN='…‹‹…') 
                        OR (TKN='…‚€’…‹…') OR (TKN='…„‹†’…‹…') 
                        OR (TKN='›‹…') OR (TKN='…„„…‹…') 
                        OR (TKN='‘€‚‹…') OR (TKN='‘‚…‚‹…') 
                        OR (TKN='€‡ƒ“‹…') OR (TKN='‘‚…•›‹…') 
                        OR (TKN='€‡„‹…') OR (TKN='€‡„€†’…‹…') 
                        OR (TKN='€‡’…‹…') OR (TKN='€‡’…‹…') 
                        OR (TKN='…‡‚‹…') OR (TKN='‘€‡‚‹…') 
                        OR (TKN='…€’‹…') OR (TKN='‹‚…‹…') 
                        OR (TKN='…„€‡€’…‹…') OR (TKN='…„’‹…') 
                        OR (TKN='•„“‹…') OR (TKN='•‹…‘‹…')
                        OR (TKN='„…‚‹…') OR (TKN='‡‚‹…')  
                        OR (TKN='›‹…') OR (TKN='‚‹…') 
                        OR (TKN='„‹†’…‹…') OR (TKN='…“ƒ‹…') 
                        OR (TKN='‘…„‹…') OR (TKN='‘‹€‚‹…') 
                        OR (TKN='”‚‹…')
                        OR (TKN='—‹…€‡„…‹…') OR (TKN='—“‚‘’‚’…‹…')
                        THEN
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'›‰';
                          END
                      ELSE IF (TKN='€……')
                        THEN
                          BEGIN
                            CASE NCH OF
                              BL : 
                                 BEGIN
                                   CLS:=0;
                                   SHRTCLS:=1;
                                 END;
                              '1' : 
                                 BEGIN
                                   CLS:=3;
                                   SHRTCLS:=1;
                                   TKN:=TKN+'›‰';
                                 END;
                              '2' : 
                                 BEGIN
                                   CLS:=1;
                                   SHRTCLS:=1;
                                   TKN:=TKN+'›‰';
                                 END;
                            END;
                            TNS:=NIHIL;
                          END
                      ELSE IF (TKN='‘‹†…')
                        THEN
                          BEGIN
                            CASE NCH OF
                              '3', '4' : {‘‹†…›‰ Ά ¤Άγε α¬λα« ε}
                                 BEGIN
                                   CLS:=1;
                                   SHRTCLS:=1;
                                   TKN:=TKN+'›‰';
                                   NCH:=CHR(ORD(NCH)-2); 
                                 END;
                              '5', '6' : {‘‹†›‰ Ά ¤Άγε α¬λα« ε}
                                 BEGIN
                                   CLS:=1;
                                   SHRTCLS:=2;
                                   TKN:=COPY(TKN,1,L-2)+'›‰';
                                   NCH:=CHR(ORD(NCH)-4); 
                                 END;
                            END;
                            TNS:=NIHIL;
                          END
                      ELSE IF (TKN='€†…') OR (TKN='€……') 
                        OR (TKN='ƒ€—…')
                        THEN
                          BEGIN
                            CASE NCH OF
                              BL : 
                                 BEGIN
                                   CLS:=0;
                                   SHRTCLS:=1;
                                 END;
                              '1' : 
                                 BEGIN
                                   CLS:=1;
                                   SHRTCLS:=3;
                                   TKN:=TKN+'›‰';
                                 END;
                              '2' : 
                                 BEGIN
                                   CLS:=1;
                                   SHRTCLS:=1;
                                   TKN:=TKN+'›‰';
                                 END;
                            END;
                            TNS:=NIHIL;
                          END
                      ELSE IF (TKN='…‘€…') 
                        THEN
                          BEGIN
                            CLS:=8;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰‰';
                          END
                      ELSE IF (TKN='‘…') OR (TKN='…') 
                        OR (TKN='…‘…') OR (TKN='……') 
                        OR (TKN='…‘………') OR (TKN='…‘…')
                        OR (TKN='…‡€‚€…') OR (TKN='‹€ƒ‘’…')
                        OR (TKN='…‡›„……') OR (TKN='“…')  
                        OR (TKN='‹€ƒƒ‚……') 
                        OR (TKN='…‹……') OR (TKN='„……') 
                        OR (TKN='€‹…') OR (TKN='…›—€…')
                        OR (TKN='‚›‘€‹…') OR (TKN='‘’…')
                        OR (TKN='‡€‹…') OR (TKN='…€‹…') 
                        OR (TKN='…„‘’…') OR (TKN='‚‹……')  
                        OR (TKN='‚›‘“†€…') OR (TKN='‚›‘„……')
                        OR (TKN='‘‹“—€…') OR (TKN='‘‚…•“†€…') 
                        OR (TKN='‡…') OR (TKN='€‹€‹…')
                        OR (TKN='ƒ‘‹…') OR (TKN='…‘’…')
                        OR (TKN='…“†€…') OR (TKN='“†€…')
                        OR (TKN='‹……') OR (TKN='€„…')
                        OR (TKN='…‹……') OR (TKN='‹……')
                        OR (TKN='…‘’…') OR (TKN='…‹€ƒ‘’…') 
                        OR (TKN='‘’…') OR (TKN='‘’•…') 
                        OR (TKN='’€ƒ…„…') 
                        OR (TKN='•…‘’€’…') OR (TKN='—…‡‚›—€…')
                        THEN
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰›‰';
                          END
                      ELSE IF (COPY(TKN,L-4,5)='’…‹…') 
                          AND NOT TST('‘’…‹…')
                        OR (COPY(TKN,L-4,5)='…‹…') 
                           AND NOT TST('…‹…')  
                        OR (COPY(TKN,L-3,4)='€‹…') 
                          AND NOT TST('„€‹…') AND NOT TST('‚€‹…') 
                          AND NOT TST('€‹…') AND NOT TST('€‹…')
                          AND (TKN<>'…—€‹…') AND (TKN<>'“†€‹…') 
                          AND (TKN<>'€‚“„€‹…') AND (TKN<>'‡€‘€‹…') 
                        OR (COPY(TKN,L-3,4)='‹…') 
                          AND NOT TST('‹…') AND NOT TST('‹…') 
                          AND (TKN<>'“‘‹…') AND (TKN<>'…‘‘‹…')
                        OR (TKN='…‘’‹…') OR (TKN='…‘…„…‹…') 
                        OR (TKN='…‘–…‹…') OR (TKN='‚‘…‘‹…')
                        OR (TKN='„‚‹…') OR (TKN='…‡‚‹…') 
                        OR (TKN='‡€…„…‹…') OR (TKN='‘€‹…') 
                        OR (TKN='ƒ“‹…') OR (TKN='…„…‹…') 
                        OR (TKN='‘‹…') OR (TKN='…„‚‹…') 
                        OR (TKN='‘€„‚‹…') 
                        THEN
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'›‰';
                          END
                      ELSE IF (TKN[L-2]='‹') 
                          AND (TKN<>'…‘—‘‹…') AND (TKN<>'…ƒ—‘‹…') 
                          AND (TKN<>'…„‹…') AND (TKN<>'ƒ—‘‹…')
                          AND (TKN<>'……„‹…') AND (TKN<>'€‹—‘‹…') 
                          AND (TKN<>'€‹€‘…‹…')
                          AND (TKN<>'‘›‘‹…') AND (TKN<>'…‘‘›‘‹…') 
                          AND (TKN<>'‹…ƒ›‘‹…') AND (TKN<>'…‘›‘‹…') 
                          AND (TKN<>'……„…‹…') AND (TKN<>'…‘‘‹…') 
                          AND (TKN<>'„“…‚‹…') AND (TKN<>'‡…‹…')
                          AND (TKN<>'„‚“‘›‘‹…') AND (TKN<>'…„‚“‘›‘‹…')
                          AND (TKN<>'‚€‚‹…') AND (TKN<>'‘€‚‹‹…') 
                          AND (TKN<>'‚››‹…') AND (TKN<>'…“›‹…')
                          AND (TKN<>'…„ƒ’‚‹…') AND (TKN<>'“›‹…')
                          AND (TKN<>'‚›‘›‘‹…') AND (TKN<>'ƒ‹“›‘‹…')
                          AND (TKN<>'–…‹…€€‚‹…') AND (TKN<>'–…‹…“‘’…‹…') 
                          AND (TKN<>'–…‹—‘‹…')
                        OR TST('‹……') OR TST('€„…')
                        OR TST('‘‚…') OR TST('…') OR TST('„‚…') 
                        OR TST('“—…') OR TST('…‘…') OR (TKN='‘€‘…') 
                        OR TST('‰„…') OR TST('‹„…')OR TST('‚…„…') 
                        OR TST('…„…') OR TST('„€…') OR TST('‚…‡…')
                        OR TST('ƒ›‡…') OR TST('’‘…') OR TST('…’…')
                        OR TST('€…') OR TST('…') OR TST('‹…') 
                       {OR TST('‹‚‹…')}
                        OR TST('€…') OR TST('……') AND (TKN<>'€„……')
                        OR TST('‘…') OR TST('€…') OR TST('’…‘…')
                        OR TST('•…') OR TST('‚’…') {OR TST('‘…„…')}
                        OR TST('ƒ‚…') OR TST('„€…') OR TST('‘’…')
                        OR TST('‚€…') OR TST('„…')
                        OR TST('‘’…') OR TST('“„…') OR TST('—’…')
                        OR TST('†€…') OR TST('“…') OR TST('‡“…')
                        OR TST('„‚…') OR TST('“…')
                        OR TST('’‚…') AND (TKN<>'’‚…')
                        OR TST('—…') AND (TKN<>'—…')
                        OR TST('…„…') AND (TKN<>'“…„…')  
                                                 
                        OR TST('—…') OR TST('‹€—…') OR TST('•‚€—…')
                        OR TST('‹“—…') OR TST('……—…') OR TST('“—…')
                        OR TST('‚…‹—…') OR TST('•†…') OR TST('‹…—…')
                        OR TST('—…') OR TST('“—…') OR TST('‹…—…')
                        OR TST('—…') OR TST('‡€—…') OR TST('‚†…')
                        OR TST('‚—…') OR TST('€‹€“—…') OR TST('‚—…') 
                        OR TST('‹—…') OR TST('‹—…') OR TST('€ƒ—…')
                        OR TST('‘……—…') OR TST('‘’—…') OR TST('…‡†…') 
                        OR TST('—…—…') OR TST('‹—…') OR TST('†…') 
                        OR TST('—…') OR TST('‘…—…') OR TST('…—…')
                        OR TST('€—…') OR TST('‘“—…') OR TST('‘‚…—…')
                        OR TST('ƒ—…') OR TST('‚—…')
                        OR TST('’€—…') OR TST('‹—…') OR TST('…—…')
                        OR TST('ƒ‹—…') OR TST('‘…„’—…') OR TST('‹—…') 
                        OR TST('†…') OR TST('†…')OR TST('‘’›†…') 
                        OR TST('†…') OR TST('††…') OR TST('ƒ“†…')
                        OR TST('„€†…') OR TST('‘€†…') OR TST('–…†…')
                        OR TST('‘‹…†…') OR TST('“†…') OR TST('ƒ†…')
                        OR TST('†…') OR TST('€†…') OR TST('“„€†…')
                        OR TST('‚…†…') OR TST('’€†…') OR TST('…‡†…')
                        OR TST('‘’†…') OR TST('†…') OR TST('ƒ‹€†…')
                        OR TST('†…') OR TST('‘’“†…') OR TST('“’†…')
                        OR TST('€†…') OR TST('††…')
                        OR TST('‘‹“†…') AND (TKN<>'…‡€‘‹“†…') 
                        OR TST('‚‹…—…') AND (TKN<>'’‚‹…—…')
                        OR TST('“—…') AND (TKN<>'‘“—…')
                        OR TST('‹—…') 
                          AND (TKN<>'’‹—…') AND (TKN<>'‹—…')  
                          AND (TKN<>'…‡‹—…') AND (TKN<>'€‡‹—…') 

                        OR TST('‚……') OR TST('“…') OR TST('…')
                        OR TST('…') OR TST('‘“…') OR TST('€…')
                        OR TST('‚›…') OR TST('…') OR TST('ƒ‹€…')
                        OR TST('“…') OR TST('ƒ‹“…') OR TST('‚…')
                        OR TST('‚€…') OR TST('’“…') OR TST('……')
                        OR TST('…')                          
                        OR TST('‹€†…') AND (TKN<>'‚‹€†…')                          
                        OR TST('„“…') 
                          AND (TKN<>'…‡„“…') AND (TKN<>'„“…') 
                        OR TST('›‹…‘…') OR TST('……')
                        OR TST('ƒ€…') OR TST('‚……')  

                        OR TST('€™…') OR TST('“™…') OR TST('“™…')
                        OR TST('‚€™…') OR TST('‘€™…') OR TST('…™…')
                        OR TST('™…') OR TST('—™…') OR TST('…™…')
                        OR TST('‘‚…™…') OR TST('‘‚™…') OR TST('€™…') 
                        OR TST('’€™…') OR TST('™…') OR TST('‘›™…')
                        OR TST('‹™…') OR TST('™…')
                        OR TST('‘‹€™…') OR TST('™…') OR TST('™…')
                        OR TST('“™…')

                        OR TST('“†„…') OR TST('…†„…')
                        OR TST('‚†„…') OR TST('ƒ€†„…') 
                        OR TST('“†„…') OR TST('…†„…')  
                        OR TST('†„…') OR TST('‘‚†„…') 
                        OR TST('‘“†„…') OR TST('’‚…†„…')
                        OR TST('•‹€†„…')                         

                  {!}   OR (TKN='‚„‡……') OR (TKN='‚›’‘…') 
                        OR (TKN='‚‡…') OR (TKN='‚‘……') 
                        OR (TKN='‚›‚…') OR (TKN='‡€‹…') 
                        OR (TKN='‡€’“„…') OR (TKN='‡€•…') 
                        OR (TKN='‡€ƒ‡…') OR (TKN='‡€€‘…') 
                        OR (TKN='‡€€…') OR (TKN='‡€’……') 
                        OR (TKN='‡€’……') OR TST('‡…‹……')
                        OR (TKN='‘……') OR (TKN='€‡…')
                        OR (TKN='‚…') OR (TKN='€‚„…')
                        OR (TKN='‹‚€…') OR (TKN='…„…') 
                        OR (TKN='…„…') OR (TKN='…‘…') 
                        OR (TKN='‘……') OR (TKN='‘‹†…')
                        OR (TKN='’‹…') OR (TKN='………') 
                        OR (TKN='ƒ€…') OR (TKN='†…') 
                        OR (TKN='‘‚……') OR (TKN='’‘’€…') 
                        OR (TKN='€…')
                        OR (TKN='€‚…') OR (TKN='€‡‡…') 
                        OR (TKN='€‡““…') OR (TKN='€‘‘’€…') 
                        OR (TKN='‘•€…') OR (TKN='‘€‚…') 
                        OR (TKN='“‚‹€†…') OR (TKN='““…')
                        OR (TKN='“‘’€…') OR (TKN='“‡€…') 
                        OR (TKN='“‹’…') OR (TKN='“€‡„…')
                        OR (TKN='“‘‹†…') OR (TKN='“’—…') 
                        OR (TKN='“…') OR (TKN='“„‹…')
                        OR TST('–……') 
                          AND (TKN<>'–……') AND (TKN<>'…‘–……') 
                            
                        OR (TKN='€‘’…') OR (TKN='€…') 
                        OR (TKN='‘‹…') OR (TKN='…‘…') 
                        OR TST('‘’…') 
                          AND (TKN<>'‘’…') AND (TKN<>'…‘’…') 
                          AND (TKN<>'…“‘’…')
                        OR (TKN='“‘…') OR (TKN='“„‘’…')
  		        OR (TKN='“’…') 
                       
                        OR (TKN='ƒ……') 
                         
                        OR (TKN='€‡€‡€…') OR (TKN='€‡…')
                        OR (TKN='€‡…') OR (TKN='“‘…')  
                        OR (TKN='‚…’…') OR (TKN='‡“…') 
                        OR (TKN='‚…„…') OR (TKN='“„‘’‚……')
                        OR (TKN='“„‚‹…’‚…') OR (TKN='€•“…')  
                        OR (TKN='„…') OR (TKN='…‡†…') 
                        OR (TKN='‡€…') OR (TKN='‹–…’‚…') 
                        OR (TKN='€…') OR (TKN='’“€’“…') 
                        OR (TKN='‹€ƒ„€…') OR (TKN='…')  
                        OR (TKN='…') OR (TKN='’…') 
                        OR (TKN='‘€…') OR (TKN='‡€“‘…') 
                        OR (TKN='‡€„‡…') 

                        OR (TKN='‚€—…') OR (TKN='‚›“—…') 
                        OR (TKN='‚›“—…') OR (TKN='‚›—…') 
                        OR (TKN='‚‘—…') OR (TKN='‚‡‹•€—…') 
                        OR (TKN='‡€—…') OR (TKN='‡€‹—…') 
                        OR (TKN='‘’‹—…')
                        OR (TKN='‡“—…') OR (TKN='‡“‚…—…')
                        OR (TKN='‘€‹…—…') OR (TKN='…“„—…') 
                        OR TST('€—…') AND (TKN<>'€—…')
                        OR (TKN='€€ƒ—…') OR (TKN='…‘‘…„’—…') 
                        OR (TKN='……‘…—…') OR (TKN='…“—…')
                        OR TST('…—…') AND (TKN<>'…‘…—…')
                        OR (TKN='‹…ƒ—…') OR (TKN='…‘–‚…—…')
                        OR (TKN='ƒ—…') OR (TKN='ƒ€—…') 
                        OR (TKN='€‹—…') OR (TKN='‡‚“—…') 
                        OR (TKN='„“€—…') 
                        OR (TKN='‡€„€—…') OR (TKN='‡€“—…') 
                        OR (TKN='‡€—…') OR (TKN='’‹—…') 
                        OR (TKN='“—…')  OR (TKN='€‡“„—…')
                        OR (TKN='‘‘…„’—…') 
                        OR TST('’—…') 
                          AND (TKN<>'’—…') AND (TKN<>'…’—…')
                        OR (TKN='“†…‘’—…') OR (TKN='“‹—…')
                        OR (TKN='“—…') OR (TKN='“„“—…') 
                        OR (TKN='“„—…') OR (TKN='“—…')

                        OR (TKN='‚‘……') OR (TKN='‘“…') 
                        OR (TKN='‚‡……') OR (TKN='‚‡……') 
                        OR (TKN='‚“…') OR (TKN='‚›’…') 
                        OR (TKN='‹…') OR (TKN='€…') 
                        OR (TKN='“‘’…') OR (TKN='“……') 
                        OR (TKN='€‘’…') OR (TKN='€‘…')
                        OR (TKN='‘‚……') OR (TKN='“‹“—…')
                        OR (TKN='“•“„…') 
                        OR (TKN='“……') OR (TKN='“€‚‚……')

                        OR (TKN='€†…') OR (TKN='€“†…') 
                        OR (TKN='„‹†…') OR (TKN='™€†…')
                        OR (TKN='…‡‚…†…') OR (TKN='‚„“†…')
                        OR (TKN='‘€†…') OR (TKN='‡…†…') 
                        OR (TKN='€‘†…')OR (TKN='‘‚…†…')
                        OR (TKN='“†…') OR (TKN='’“’†…') 
                        OR (TKN='‹†…') OR (TKN='‚›‘€‡…†…') 
                        OR (TKN='€‡“†…') OR (TKN='€‘‘…†…') 
                        OR (TKN='“‹†…') OR (TKN='€‘‹†…') 
                        OR (TKN='‘€†…') OR (TKN='“—’†…') 
                        OR (TKN='…‡‚†…') OR (TKN='…‘“€†…') 
                        OR (TKN='‚›‹“†…') OR (TKN='††…')  
                        OR (TKN='€‡…†…') 
                        OR (TKN='’“†…') OR (TKN='‡€’†…')
                        OR (TKN='…„‘’……†…') OR (TKN='‹†…') 

                        OR (TKN='‚›‹™…') OR (TKN='‚›‘—™…')
                        OR (TKN='‚›•‹™…') 
                        OR (TKN='‡€™™…') OR (TKN='‹™…') 
                        OR (TKN='…™…') OR (TKN='………™…')
                        OR (TKN='…™…') OR (TKN='‚…™…')
                        OR (TKN='ƒ‹™…') OR (TKN='€™…')  
                        OR (TKN='ƒ€™…') OR (TKN='‘’™…')
                        OR (TKN='‘…™…') OR (TKN='‹™…') 
                        OR (TKN='€‡‹€—…') 
                        OR (TKN='‘ƒ“™…') OR (TKN='‘‹™…') 
                        OR (TKN='“‘’€…') OR (TKN='“’‹™…') 
                        OR (TKN='“—€™…') 
                        OR TST('•™…') AND (TKN<>'•™…')
                     
                        OR (TKN='‚…†„…') OR (TKN='‘€†„…') 
                        OR (TKN='€ƒ†„…') OR (TKN='€ƒ…’…') 
                        OR (TKN='“—…†„…') OR (TKN='“‚„…')
                        OR (TKN='“ƒ…’…') OR (TKN='‚‹…’…')
   
                        OR TST('‚……') 
                          AND (TKN<>'‚……') AND (TKN<>'…‚……')
                        OR TST('™…') AND (TKN<>'‡™…')
                      { OR TST('‹€—…') AND (TKN<>'…‡‹€—…') }
                        OR TST('“†…') AND (TKN<>'…‡“†…') 
                        OR TST('……') AND (TKN<>'‘€‡……') 
                          AND (TKN<>'……') AND (TKN<>'…‡……') 
                          AND (TKN<>'…„€……') AND (TKN<>'€‡……') 
                          AND (TKN<>'…‘……') AND (TKN<>'“……')
                        OR TST('‘—…') 
                          AND (TKN<>'‘—…') AND (TKN<>'…‘‘—…') 
                          AND (TKN<>'„‘—…') AND (TKN<>'…‘—…')
                        OR TST('‘…')
                          AND(TKN<>'‘…')AND(TKN<>'…‘‘…')
                        OR TST('‡…') AND (TKN<>'‡…')
                        OR TST('‘…') AND (TKN<>'‘…')    
                        OR TST('‘…')AND(TKN<>'‘…')
                        OR TST('…’…') 
                          AND (TKN<>'‡€…’…') AND (TKN<>'…’…')
                          AND (TKN<>'…‡€…’…') AND (TKN<>'……’…')
                        OR TST('…') AND (TKN<>'…') 
                        OR TST('‹†…') AND (TKN<>'‘‹†…')
                          AND (TKN<>'’‚‹†…') AND (TKN<>'‹†…')
                        THEN 
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END
                      ELSE IF (TKN='‹€ƒ‘‹‚…') OR (TKN='‚‘’‚…') 
                        OR (TKN='‹…‡…') OR (TKN='…‡‹…‡…')
                        OR (TKN='…‡‡…') OR (TKN='…‡‚…’…')
                        OR (TKN='…‡„…‰‘’‚…') 
                        OR (TKN='…‡†‡…') OR (TKN='…‘‘›‘‹…') 
                        OR (TKN='„‚“‘›‘‹…') OR (TKN='…„‚“‘›‘‹…') 
                        OR (TKN='…‡€‚‘’‚…') OR (TKN='…‡’‚…’‘’‚…') 
                        OR (TKN='…‡“‡…') OR (TKN='…‡›‘“‘‘’‚…') 
                        OR (TKN='…‘—‚…') OR (TKN='…‘…’‘’‚…') 
                        OR (TKN='…‘”…') OR (TKN='…‘•‡‰‘’‚…') 
                        OR (TKN='ƒ‡…') OR (TKN='‹€†…') 
                        OR (TKN='…‘—‘‹…') OR (TKN='…‘—“‚‘’‚…') 
                        OR (TKN='‹€ƒ€……') OR (TKN='†…‘’‚…') 
                        OR (TKN='‹€ƒ“‘’…') OR (TKN='…‹€ƒ“‘’…')
                        OR (TKN='‚…‹—…‘’‚…') OR (TKN='‚›‘€—…‘’‚…')
                        OR (TKN='‚›‘€‚‘’‚…') OR (TKN='‚›‘„€…') 
                        OR (TKN='‚›‘›‘‹…')
                        OR (TKN='‚›‘€€‚‹…') OR (TKN='‚‘…€€‚‹…') 
                        OR (TKN='‚›‘’†…‘’‚…') OR (TKN='‚›‘•“„†…‘’‚…')
                        OR (TKN='‚‘…ƒ“™…‘’‚…') OR (TKN='‚‘’†…')
                        OR (TKN='‚››‹…') OR (TKN='ƒ‹“›‘‹…') 
                        OR (TKN='„€—…‘’‚…') OR (TKN='„‚“‘›‘‹…') 
                        OR (TKN='„‚‰‘’‚…') OR (TKN='„…‡‚…') 
                        OR (TKN='„…‰‘’‚…') OR (TKN='„“†…‘’‚…') 
                        OR (TKN='…„‘’‚…') OR (TKN='…‘’…‘’‚…') 
                        OR (TKN='†…‘’‚…') OR (TKN='†‡…') 
                        OR (TKN='‡‹€……') OR (TKN='‡‹€—…‘’‚…') 
                        OR (TKN='‡…†…') OR (TKN='‡™…') 
                        OR (TKN='‚…™…‘’‚…') OR (TKN='…‚…™…‘’‚…') 
                        OR (TKN='‡€‹…‰…') OR (TKN='……„…‹…') 
                        OR (TKN='…‘‘‹…') OR (TKN='‡…') 
                        OR (TKN='€‡€…') OR (TKN='™“‘’‚…')
                        OR (TKN='‹…ƒ›‘‹…') 
                        OR (TKN='……‘’…‘’‚…')OR (TKN='…€‘‹‘’‚…')
                        OR (TKN='€‘’†…') OR (TKN='…†‡…')
                        OR (TKN='…„“†…‘’‚…') OR (TKN='…“†„…') 
                        OR (TKN='…“……') OR (TKN='…“›‹…')
                        OR (TKN='€‹—‘‹…') OR (TKN='€‹€‘…‹…')
                        OR (TKN='…„‹…') OR (TKN='…’‚…')
                        OR (TKN='“†…‘’‚…') OR (TKN='ƒ“™…‘’‚…')
                        OR (TKN='…‘“…') OR (TKN='……„‹…') 
                        OR (TKN='……‡“‡…') OR (TKN='…„ƒ’‚‹…')
                        OR (TKN='€‘‹‘’‚…') OR (TKN='€›™…') 
                        OR (TKN='…‡€‘‹“†…') OR (TKN='…ƒ€—…') 
                        OR (TKN='…‘…„‘’‚…') OR (TKN='……„“…†„…')
                        OR (TKN='…‡…') OR (TKN='……„€……')
                        OR (TKN='……‚‡‰„…') OR (TKN='…‘“™…‘’‚…') 
                        OR (TKN='‡€—…‘’‚…') OR (TKN='…‘›‘‹…')
                        OR (TKN='…‚…†…‘’‚…') OR (TKN='…ƒ—‘‹…')
                        OR (TKN='…€—…‘’‚…') OR (TKN='…‘‚‰‘’‚…') 
                        OR (TKN='…„€—…‘’‚…') OR (TKN='…“‚……') 
                        OR (TKN='…“‘’…') OR (TKN='…“€‚‚……') 
                        OR (TKN='€‚‘’‚…') 
                        OR (TKN='›„…') OR (TKN='‘›‘‹…') 
                        OR (TKN='’‚…’‘’‚…') OR (TKN='’—“†„…') 
                        OR (TKN='„“•’‚…') OR (TKN='„“…‚‹…') 
                        OR (TKN='†…‘’—…') OR (TKN='’‚‹…—…') 
                        OR (TKN='‚€‚‹…') OR (TKN='…‚‘’‚…')
                        OR (TKN='‘…„‘’‚…') OR (TKN='’‚…‘’…‘’‚…') 
                        OR (TKN='…„€……') OR (TKN='‡…‹…') 
                        OR (TKN='€‡……')
                        OR (TKN='„‘’‚…') OR (TKN='›–€‘’‚…') 
                        OR (TKN='‘‚…•…‘’…‘’‚…') OR (TKN='‘“™…‘’‚…') 
                        OR (TKN='‘‚‰‘’‚…') OR (TKN='‘€“‚……') 
                        OR (TKN='‘€’‚…†…') OR (TKN='‘€‚‹‹…')
                        OR (TKN='‘—“‚‘’‚…') OR (TKN='‘’‚…’‘’‚…') 
                        OR (TKN='’€‘’‚…') OR (TKN='’†…‘’‚…') 
                        OR (TKN='“‰‘’‚…') OR (TKN='“…„…') 
                        OR (TKN='“……') 
                        OR (TKN='“›‹…') OR (TKN='“‡…') 
                        OR (TKN='“’—…') OR (TKN='“’‚…') 
                        OR (TKN='–…‹…€€‚‹…') OR (TKN='–…‹…“‘’…‹…')
                        OR (TKN='–€‘’‚…') OR (TKN='–…‹“„…') 
                        OR (TKN='–…‹—‘‹…') 
                        OR (TKN='—“‚‘’‚…') OR (TKN='—“„„…‰‘’‚…') 
                        OR (TKN='‘’…') OR (TKN='‚‘’‚…') 
                        THEN
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=3;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END
                      ELSE IF (POS (TKN[L-2], CONS3+'') > 0)
                        THEN
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=2;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'›‰';
                          END
                      ELSE EROUT;
    (*2*)           '':
                      IF (COPY(TKN,L-4,5) = '‹')
                        THEN
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=4;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'›‰';
                          END
                      ELSE IF (TKN='‘…') OR (TKN='…‘…')
                        THEN
                          BEGIN
                            CLS:=4;
                            SHRTCLS:=5;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰';
                          END
                      ELSE EROUT;
    (*2*)           '€':
                      IF (TKN='€‡‚€') OR (TKN='€‚„€') 
                        OR (TKN='‚‡„…†€') OR (TKN='…‚‡„…†€') 
                        OR (TKN='‚›‘‚€‹”–‚€')
                        OR (TKN='‚›‘–…’‚€')
                        OR (TKN='‚›‘€‡‚€') OR (TKN='ƒ…‹‡‚€')
                        OR (TKN='„‘–‹‚€') OR (TKN='…„‘–‹‚€')
                        OR (TKN='‡›‘€') OR (TKN='‚€‹”–‚€')
                        OR (TKN='…‡€€‡€') OR (TKN='…’‚‚€')
                        OR (TKN='€„“€') OR (TKN='…’…‘€') 
                        OR (TKN='…‚›„…†€') OR (TKN='€ƒ€') 
                        OR (TKN='…‘‚€') OR (TKN='…€‚„€') 
                        OR (TKN='…‚€‹”–‚€') OR (TKN='…‚„€')
                        OR (TKN='…†„€') OR (TKN='…“‡„€') 
                        OR (TKN='…‘‹›•€') OR (TKN='…‘‡€') 
                        OR (TKN='…‚‡„…†€') OR (TKN='…‚‘’€') 
                        OR (TKN='…€') OR (TKN='…„“€')  
                        OR (TKN='…ƒ€‡‚€') OR (TKN='™…‡€')
                        OR (TKN='…‘„…†€') OR (TKN='„“€') 
                        OR (TKN='‘‚€') OR (TKN='‘‚€') 
                        OR (TKN='–‚‹‡‚€') OR (TKN='“’€')
                        THEN
                          CASE NCH OF
                            BL, '1' :
                              BEGIN
                                CLS:=1;
                                SHRTCLS:=3;
                                TKN:=TKN+'›‰';
                                TNS:=NIHIL;
                              END;
                            '2' :
                              BEGIN
                               CLS:=1;
                               SHRTCLS:=1;
                               TKN:=TKN+'›‰';
                               TNS:=NIHIL;
                             END;  
                          END
                      ELSE IF (TKN='ƒ€')
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END
                      ELSE IF (TKN='€‘‹›€')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                          END
                        ELSE
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END;
    (*2*)           '','':
                      IF (TKN='') OR (TKN='…„') 
                        OR (TKN='„')OR (TKN='“')
                        THEN
                          BEGIN
                            CLS:=9;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END
                      ELSE IF (TKN='€‘‘…') OR (TKN='€‘’…') 
                        OR (TKN='‘€€„…') OR (TKN='’—€') 
                        THEN
                          CASE NCH OF
                            BL, '1' :
                              BEGIN
                                CLS:=1;
                                SHRTCLS:=3;
                                TKN:=TKN+'›‰';
                                TNS:=NIHIL;
                              END;
                            '2' :
                              BEGIN
                               CLS:=1;
                               SHRTCLS:=1;
                               TKN:=TKN+'›‰';
                               TNS:=NIHIL;
                             END;  
                          END
                      ELSE IF (TKN='„‘’')
                        THEN
                          BEGIN
                            CLS:=2;
                            SHRTCLS:=5;
                            TNS:=NIHIL;
                            TKN:=COPY(TKN,1,L-2)+'‰›‰';
                          END
                      ELSE IF (TKN='„')
                        THEN
                          BEGIN
                            CLS:=0;
                            SHRTCLS:=6;
                            TNS:=NIHIL;
                          END
                        ELSE
                          BEGIN
                            CLS:=1;
                            SHRTCLS:=1;
                            TNS:=NIHIL;
                            TKN:=TKN+'›‰';
                          END;
                      ELSE EROUT;
                    END;
                  END;

(*1*)      '’':
     BEGIN
       CASE TKN[L-1] OF
    (*2*)      '…':
         BEGIN
           TKN:=COPY(TKN,1,LENGTH(TKN)-2);
           L:=LENGTH(TKN);

           IF TST('ƒ') OR TST('') 
             OR TST('„') AND (TKN<>'„')
             THEN
               BEGIN
                 CLS:=9;
                 SHRTCLS:=1;
                 TNS:=NIHIL;
                 TKN:=TKN+'…’›‰';
               END
           ELSE  IF (TKN='„')
             THEN
               BEGIN
                 CLS:=124;
                 TKN:=TKN+'’';
               END
           ELSE  IF (TKN='‚')
             THEN
               BEGIN
                 CLS:=285;
                 TKN:=TKN+'’';
               END
           ELSE  IF (TKN='†‚‘“')
             THEN
               BEGIN
                 CLS:=286;
                 TKN:=COPY(TKN,1,L-1)+'€’';
               END
          ELSE IF (TKN='„') OR (TKN='„') 
             OR (TKN='„•') OR (TKN='ƒ')
             OR (TKN='‘•') OR (TKN='‡')
             THEN
               BEGIN
                 CLS:=288;
                 TKN:=TKN+'“’';
               END
           ELSE IF (TKN='†€†„')
             THEN
               BEGIN
                 CLS:=60;
                 TKN:=TKN+'€’';
               END
           ELSE IF TST('‘€†') OR TST('€†') 
             OR TST('‚†') OR TST('‹†') 
             OR (TKN='†') OR (TKN='€†')
             THEN
               BEGIN
                 CLS:=1;
                 TKN:=COPY(TKN,1,L-1)+'‡€’';
               END
           ELSE IF (TKN='…†') OR TST('€†') 
             THEN
               BEGIN
                 CLS:=102;
                 TKN:=COPY(TKN,1,L-1)+'‡€’';
               END
           ELSE IF (TKN='‘’†') OR (TKN='†')
             THEN
               BEGIN
                 CLS:=27;
                 TKN:=COPY(TKN,1,L-1)+'—';
               END
           ELSE IF TST('ƒ…’') OR (TKN='‡…’') 
             OR TST('…’') OR (TKN='…’')
             OR TST('‹…’') OR (TKN='…’')
             OR TST('€‘‘‚…’') OR TST('–‚…’') 
             THEN
               BEGIN
                 CLS:=54;
                 TKN:=COPY(TKN,1,L-1)+'‘’';
               END
           ELSE IF TST('—')
             THEN
               BEGIN             (*’€’*)
                 CLS:=262;
                 TKN:=COPY(TKN,1,L-1)+'’€’';
               END
           ELSE IF TST('‹€—') 
             THEN
               BEGIN             (*‹€€’*)
                 CLS:=103;
                 TKN:=COPY(TKN,1,L-1)+'€’';
               END
           ELSE IF TST('‘€—') 
             THEN
               BEGIN             (*‘€€’*)
                 CLS:=270;
                 TKN:=COPY(TKN,1,L-1)+'€’';
               END
           ELSE IF TST('‘›‹')
             THEN
               BEGIN             (*‘›€’*)
                 CLS:=246;
                 TKN:=COPY(TKN,1,L-1)+'€’';
               END
           ELSE IF TST('ƒ‹†')
             THEN
               BEGIN             (*ƒ‹„€’*)
                 CLS:=104;
                 TKN:=COPY(TKN,1,L-1)+'„€’';
               END
           ELSE
             CASE TKN[L] OF
             (*3*) '€','…','','','':
               IF TST('€‘’€') AND (TKN<>'€‘’€')
                 OR TST('“—€') OR (TKN='“•€') 
                 OR (TKN='‘…') OR (TKN='‘…') 
                 THEN
                   BEGIN       (*‘…’/‡“—€’*)
                     CLS:=3;
                     TKN:=TKN+'’';
                   END
               ELSE IF TST('„€') OR TST('‘‡„€')
                 OR TST('‘’€') AND (TKN<>'‘’€')
                 OR TST('‡€') AND (TKN<>'‡€')
                 THEN  
                   BEGIN       (*„€‚€’*)
                     CLS:=71;
                     TKN:=TKN+'‚€’';
                   END
               ELSE IF TST('…')
                 THEN
                   BEGIN       (*’*)
                     CLS:=40;  
                     TKN:=COPY(TKN,1,L-1)+'’';
                   END
               ELSE IF ROOT_43
                 THEN 
                   BEGIN        (*‘…’*)
                     CLS:=43;
                     TKN:=TKN+'’';
                   END
               ELSE IF TST('')
                 THEN
                   BEGIN         (*…’*)
                     CLS:=141;
                     TKN:=COPY(TKN,1,L-1)+'…’';
                   END
               ELSE IF TST('‚') OR TST('') 
                 OR TST('') OR TST('') OR TST('')
                 THEN
                   BEGIN          (*›’*)
                     CLS:=96;
                     TKN:=COPY(TKN,1,L-1)+'›’';
                   END
               ELSE
                 BEGIN
                   CLS:=3;
                   TKN:=TKN+'’';
                 END;
             (*3*) '“':
               IF TST('„“')
                 THEN
                   BEGIN           (*„“’*)
                     CLS:=3;
                     TKN:=TKN+'’';
                   END
               ELSE IF TST('—“')
                 THEN
                   BEGIN           (*—“’*)
                     CLS:=43;
                     TKN:=TKN+'’';
                   END
               ELSE IF POS(TKN[L-1],AFFR)>0
                 THEN
                   BEGIN           (*†…‚€’*)
                      CLS:=39;
                      TKN:=COPY(TKN,1,L-1)+'…‚€’';
                   END
               ELSE
                 BEGIN            (*‚€’*)
                   CLS:=30;
                   TKN:=COPY(TKN,1,L-1)+'‚€’';
                 END;
             (*3*)    '':
               BEGIN              (*‚…‚€’*)
                 CLS:=31;
                 TKN:=COPY(TKN,1,L-1)+'…‚€’';
               END;
             (*3*)    '‹':
                ETFIN (TKN,CLS,FALSE);
             (*3*)    '':
                BIT6 (TKN,CLS,FALSE);
             (*3*)    '':
                IF TST('‹')
                  THEN
                    BEGIN      (*‹‘’*)
                      CLS:=149;
                      TKN:=COPY(TKN,1,L-1)+'‘’';
                    END
                ELSE IF TST('')
                  THEN
                    BEGIN      (*‘’*)
                      CLS:=172;
                      TKN:=COPY(TKN,1,L-3)+'’';
                    END
                ELSE IF TST('')
                   THEN
                     BEGIN       (*’*)
                       CLS:=151;
                       TKN:=COPY(TKN,1,L-1)+'’';
                     END
                ELSE IF TST('‘’')
                  THEN
                    BEGIN        (*‘’€’*)
                      CLS:=60;
                      TKN:=TKN+'€’';
                    END
                ELSE IF TST('‘’›') OR TST('‘’€') 
                  OR TST('„…')
                  THEN
                    BEGIN
                      CLS:=77;
                      TKN:=COPY(TKN,1,L-1)+'’';
                    END
                ELSE IF TST('‚')
                  THEN
                    BEGIN       (*‡€‚“’*) 
                      CLS:=166;
                      TKN:=TKN+'“’';
                    END
                ELSE IF (TKN='›„')
                  THEN 
                    BEGIN       (*›„“’*) 
                      CLS:=235;   
                      TKN:=TKN+'“’';
                    END
                ELSE IF TST('ƒ') 
                  OR TST('„‚') OR TST('„“') 
                  OR TST('') OR TST('‹') 
                  OR TST('') OR TST('‹') 
                  OR TST('') OR TST('') 
                  OR TST('‘’›') OR TST('‘“') 
                  OR TST('’') OR TST('•‹›')
                  OR (TKN='‚›') OR (TKN='ƒ‹') 
                  OR (TKN='€') OR (TKN='€‡') 
                  OR (TKN='‘ƒ') 
                  THEN 
                     BEGIN
                       CLS:=274;           (*‡€’“’*)
                       TKN := TKN+'“’';
                     END
                ELSE IF (POS(TKN [L-1],'€…“›‚’—') > 0)
                  OR STEM_16('')           
                  THEN
                    BEGIN                (*€“’*)
                      CLS:=16;              
                      TKN := TKN+'“’';
                    END
                ELSE IF (POS(TKN [L-1],'ƒ‡‘•'(*+'„–'*)) > 0)
                   AND (ROOT_10('') OR STEM_10(''))
                   THEN
                     BEGIN              (*‚›“’*)
                        CLS:=10;
                        TKN := TKN+'“’';
                     END
                ELSE                    
                  BEGIN                  (*€–“’*)    
                    CLS:=16;               
                    TKN:=TKN+'“’';
                  END;
             (*3*)     '‚': 
                     VET(TKN,CLS);
             (*3*)     '„': 
                     DET(TKN,CLS,FALSE);
             (*3*)     '†': 
                     ZHET(TKN,CLS,FALSE);
             (*3*)     '':
                     IF TST('') OR TST('‹') 
                       OR TST('—…')
                       THEN
                         BEGIN
                         TKN:=COPY(TKN,1,L-1)+'‘€’';
                         CLS:=59;
                       END
                     ELSE IF TST('€') OR TST('€') 
                       OR TST('›') OR TST('…')
                       THEN
                         BEGIN
                           TKN:=COPY(TKN,1,L-1)+'•€’';
                           CLS:=125;
                         END
                     ELSE IF TST('‹›')
                       THEN
                         BEGIN
                           TKN:=COPY(TKN,1,L-1)+'•€’';
                           CLS:=264;
                         END 
                     ELSE EROUT;
             (*3*)     '™':
                     IF TST('‘‚™') OR TST('•‹…™')
                       OR TST('„™') OR TST('•‹›™') 
                       OR TST('•‹›™')
                       THEN
                         BEGIN
                           TKN:=COPY(TKN,1,L-1)+'‘’€’';
                           CLS:=126;
                         END
                     ELSE IF TST('›™') OR TST('™') 
                       OR TST('›™') OR TST('“‹…™') 
                       OR TST('‹…™') OR TST('‹™') 
                       THEN
                         BEGIN
                           TKN:=COPY(TKN,1,L-1)+'‘€’';
                           CLS:=76;
                         END
                     ELSE IF TST('’……™') OR TST('™')
                       OR TST('‹…‚…™') OR TST('‘…†…™') 
                       THEN
                         BEGIN
                           TKN:=COPY(TKN,1,L-1)+'’€’';
                           CLS:=105;
                         END
                     ELSE EROUT;
             (*3*)     '—':
                     IF ROOT_106
                       THEN
                         BEGIN           (*‹……’€’*)
                           TKN:=COPY(TKN,1,L-1)+'’€’';
                           CLS:=106;
                         END
                     ELSE IF TST('‘€—')
                       THEN
                         BEGIN           (*‘€€’*)
                           TKN:=COPY(TKN,1,L-1)+'€’';
                           CLS:=270;
                         END
                     ELSE IF TST('“‹›—') OR TST('‹€—')
                       OR TST('•›—') OR TST('“‹›—') 
                       THEN
                         BEGIN           (*•›€’*)
                           TKN:=COPY(TKN,1,L-1)+'€’';
                           CLS:=103;
                         END
                     ELSE IF TST('•—')
                       THEN
                         BEGIN
                           TKN:=COPY(TKN,1,L-1)+'’…’';
                           CLS:=114;
                         END
                     ELSE
                       BEGIN
                         TKN:=TKN+'';
                         CLS:=18;
                       END;
             (*3*)     '‡':
             IF TST('‹…‡') AND (TKN<>'‚›‹…‡')
               THEN
                 BEGIN
                   CLS:=49;
                   TKN:=TKN+'’';
                 END
             ELSE IF TST('ƒ›‡')
               THEN
                 BEGIN
                   CLS:=256;
                   TKN:=TKN+'’';
                 END
               ELSE
                 BEGIN
                   CLS:=47;
                   TKN:=TKN+'’';
                 END;
             (*3*)     '':
          IF TST('…') OR TST('„…')
            THEN
              BEGIN
                CLS:=56;
                TKN:=COPY(TKN,1,L-2)+'€’';
              END
          ELSE IF POS(TKN[L-1],'’')>0
            THEN OIN(TKN,CLS,FALSE)
            ELSE
              BEGIN
                CLS:=60;
                TKN:=TKN+'€’';
              END;
             (*3*)     '‘':
        IF TST('’‘') OR TST('…‘') OR TST('€‘')
          THEN
            BEGIN
              CLS:=47;
              TKN:=TKN+'’';
            END
        ELSE IF TST('‘‘')
          THEN
            BEGIN
              CLS:=60;
              TKN:=TKN+'€’';
            END
        ELSE EROUT;
             (*3*)     '’':
        IF TST('€‘’')
          THEN
            BEGIN
              CLS:=48;
              TKN:=TKN+'';
            END
        ELSE IF TST('–‚…’') OR TST('ƒ…’') OR TST('…’')
          OR TST('…’') OR TST('‹…’')
          THEN
            BEGIN
              CLS:=54;
              TKN:=COPY(TKN,1,L-1)+'‘’';
            END
        ELSE EROUT;
             (*3*)     '':
        IF TST('†')
          THEN
            BEGIN
              CLS:=74;
              TKN:=COPY(TKN,1,L-1)+'€’';
            END
        ELSE IF TST('')
          THEN
            BEGIN
              CLS:=66;
              TKN:=COPY(TKN,1,L-1)+'’';
            END
        ELSE IF TST('‰') { /‡€/€|‰|…’ }
          THEN
            BEGIN
              CLS:=68;
              TKN:=COPY(TKN,1,L-2)+'’';
            END
        ELSE EROUT;
             (* 3 *)     ELSE EROUT;
                 END;
              END;
    (*2*)    '':
   IF (TKN='‹’')
     THEN
       BEGIN
         CLS:=9;
         SHRTCLS:=1;
         TNS:=NIHIL;
         TKN:=TKN+'›‰';
       END
     ELSE
       CASE LINE0 [LENGTH (LINE0)-2] OF
             (*3*)  '€','…','','','':
         BEGIN
           TKN:=COPY(TKN,1,L-2);
           DEC(L,2);

           IF TST('€‘’€') AND (TKN<>'€‘’€')
             OR (TKN='“•€') OR TST('“—€') 
             OR (TKN='‘…') OR (TKN='‘…') 
             THEN
               BEGIN       (*‘…’/‡“—€’*)
                 CLS:=3;
                 TKN:=TKN+'’';
               END
           ELSE IF TST('„€') OR TST('‘‡„€') OR TST('‘’€')
             OR TST('‡€') AND (TKN<>'‡€')
             THEN
               BEGIN       (*„€‚€’*)
                 CLS:=71;
                 TKN:=TKN+'‚€’';
               END
           ELSE  IF (TKN='‚‡')
             THEN
               BEGIN
                 CLS:=193;
                 TKN:=TKN+'’';
               END
           ELSE  IF (TKN='†‚‘“')
             THEN
               BEGIN
                 CLS:=286;
                 TKN:=COPY(TKN,1,L-3)+'€’';
               END
           ELSE  IF (TKN='')
             THEN
               BEGIN
                 CLS:=96;
                 TKN:=COPY(TKN,1,L-1)+'›’';
               END
           ELSE  IF (TKN='‚')
             THEN
               BEGIN
                 CLS:=285;
                 TKN:=TKN+'’';
               END
           ELSE IF TST('…')
             THEN
               BEGIN
                 CLS:=40;
                 TKN:=COPY(TKN,1,L-1)+'’';
               END
           ELSE IF TST('‚…') OR TST('‘…') OR TST('…') 
             OR TST('‹€') OR TST('’€') OR TST('‹…')
             OR TST('‹…‹…')
             THEN
               BEGIN
                 CLS:=43;
                 TKN:=TKN+'’';
               END
           ELSE IF TST('')
             THEN
               BEGIN         (*…’*)
                 CLS:=141;
                 TKN:=COPY(TKN,1,L-1)+'…’';
               END
           ELSE IF TST('‚') OR TST('') OR TST('')
             THEN
               BEGIN          (*›’*)
                 CLS:=96;
                 TKN:=COPY(TKN,1,L-1)+'›’';
               END
           ELSE
             BEGIN
               CLS:=3;
               TKN:=TKN+'’';
             END;
         END;
             (*3*)      '“':
         BEGIN
           TKN:=COPY(TKN,1,L-2);
           DEC(L,2);
           IF TST('„“')
             THEN
               BEGIN
                 CLS:=3;
                 TKN:=TKN+'’';
              END
           ELSE IF TST('—“')
             THEN
               BEGIN
                 CLS:=43;
                 TKN:=TKN+'’';
              END
           ELSE IF (TKN='†‚‘“')
             THEN
               BEGIN           (*†‚‘€’*)
                 CLS:=286;
                 TKN:=COPY(TKN,1,L-1)+'€’';
               END
           ELSE IF POS(TKN[L-1],AFFR)>0
             THEN
               BEGIN
                 CLS:=39;
                 TKN:=COPY(TKN,1,L-1)+'…‚€’';
               END
           ELSE
             BEGIN
               CLS:=30;
               TKN:=COPY(TKN,1,L-1)+'‚€’';
             END;
         END;
             (*3*)      '':
               BEGIN           (*‚…‚€’*)
                 CLS:=31;
                 TKN:=COPY(TKN,1,L-3)+'…‚€’';
               END;
             (* 3 *)      '‹':
           BEGIN
             TKN:=COPY(TKN,1,L-2);
             ETFIN(TKN,CLS,FALSE);
           END;
             (* 3 *)      '':
           BEGIN
             TKN:=COPY(TKN,1,L-2);
             BIT6 (TKN,CLS,FALSE);
           END;
             (* 3 *)      ELSE EROUT;
                        END;
    (*2*)           '“':
     BEGIN
       TKN:=COPY(TKN,1,L-2);
       L:=LENGTH(TKN);

       IF (TKN='')
         THEN
           BEGIN
             CLS:=4;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'“’‰';
          END
       ELSE IF (TKN='€„’…‘') OR (TKN='‚…') 
         OR (TKN='’„…') OR (TKN='ƒ')
         OR (TKN='„‘’…ƒ') OR (TKN='„’') 
         OR (TKN='……—…')
         THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'“’›‰';
           END
       ELSE IF (TKN='„') OR (TKN='„') 
         OR (TKN='„•') OR (TKN='ƒ')
         OR (TKN='‘•') OR (TKN='‡')
         THEN
           BEGIN
             CLS:=288;
             TKN:=TKN+'“’';
           END
       ELSE IF (TKN='€„')
         THEN
           BEGIN
             CLS:=268;
             TKN:=COPY(TKN,1,L-4)+'€‘’';
           END
       ELSE IF TST('ƒ…’') OR TST('…’') 
         OR TST('‹…’') OR TST('€‘‘‚…’')
         OR TST('–‚…’') OR (TKN='…’') 
         OR (TKN='‡…’')  OR (TKN='…’')
         THEN
           BEGIN
             CLS:=54;
             TKN:=COPY(TKN,1,L-1)+'‘’';
           END
       ELSE IF TST('‘€†') OR TST('€†') 
         OR TST('‚†') OR TST('‹†') 
         OR (TKN='†') OR (TKN='€†')
         THEN
           BEGIN
             CLS:=1;
             TKN:=COPY(TKN,1,L-1)+'‡€’';
           END
       ELSE IF TST('€†') OR TST('…†')
         THEN
           BEGIN           (*€‡€’*)
             CLS:=102;
             TKN:=COPY(TKN,1,L-1)+'‡€’';
           END
       ELSE IF ROOT_106
         THEN
           BEGIN
            CLS:=106;
            TKN:=COPY(TKN,1,L-1)+'’€’';
          END
       ELSE IF TST('—')
         THEN
           BEGIN
             CLS:=262;
             TKN:=COPY(TKN,1,L-1)+'’€’';
           END
       ELSE IF (TKN='„')
         THEN
           BEGIN
             CLS:=124;
             TKN:=TKN+'’';
           END
       ELSE IF TST('ƒ›‡')
         THEN
           BEGIN
             CLS:=256;
             TKN:=TKN+'’';
           END
       ELSE IF TST('‘’ƒ')
         THEN
           BEGIN
             CLS:=27;
             TKN:=COPY(TKN,1,L-1)+'—';
           END
       ELSE IF TST('…ƒ')
         THEN
           BEGIN
             CLS:=20;
             TKN:=COPY(TKN,1,L-1)+'†€’';
           END
       ELSE IF TST('')
         THEN
           BEGIN
             CLS:=59;
             TKN:=COPY(TKN,1,L-1)+'‘€’';
           END
       ELSE IF TST('‚…„')
         THEN
           BEGIN
             CLS:=42;
             TKN:=COPY(TKN,1,L-1)+'‘’';
           END
       ELSE IF TST('')
         THEN
           BEGIN
             CLS:=151;
             TKN:=COPY(TKN,1,L-1)+'’';
          END
       ELSE IF TST('‘’')
         THEN
           BEGIN
             CLS:=60;
             TKN:=TKN+'€’';
          END
       ELSE IF TST('‘’›') OR TST('‘’€') OR TST('„…')
         THEN
           BEGIN
             CLS:=77;
             TKN:=COPY(TKN,1,L-1)+'’';
          END
      ELSE IF (POS (HEAD [LENGTH(HEAD)],'›€…') = 0) 
          AND (POS ('  ', HEAD) = 0)
        OR (COPY(HEAD,1,7)='“‚…') 
        OR (COPY(HEAD,1,6)='……')
        THEN
          BEGIN
            CLS:=9;
            SHRTCLS:=1;
            TNS:=NIHIL;
            TKN:=TKN+'“’›‰';
          END
       ELSE UTFIN(TKN,CLS,FALSE);
     END;
    (*2*)           '':
       IF TST('’') OR TST('’') 
         OR TST('‹’') OR TST('’')
         OR TST('‚’') AND (TKN<>'‚’')
         OR TST('†’') 
           AND (TKN<>'†’') AND (TKN<>'…†’') 
         OR (TKN='€‘‚’') OR (TKN='€‚’') 
         OR (TKN='…‚’') OR (TKN='‚›’')
         OR (TKN='ƒ‹–…‚’') OR (TKN='„€‚’')
         OR (TKN='„…‹‚’') OR (TKN='„’')
         OR (TKN='„“•‚’') OR (TKN='‡€…’') 
         OR (TKN='…’') OR (TKN='‚›‘€‡‚’') 
         OR (TKN='€‹€‡‚’') OR (TKN='€‘’’')  
         OR (TKN='€—’') OR (TKN='…‡’') 
         OR (TKN='…€‡‚’') OR (TKN='…„€‡‚’') 
         OR (TKN='€‘’') OR (TKN='‘‚…†…‚›’')  
         OR (COPY(TKN,L-4,5)='„‚’') 
         THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'›‰';
           END
       ELSE IF (TKN='†’') OR (TKN='…†’') 
         OR (TKN='‚’') OR (TKN='‡€‚’')
         THEN
           BEGIN
             CLS:=4;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'‰';
           END
       ELSE IF TST('‘‹’') AND (TKN<>'…‘‘‹’') 
         OR (TKN='„‚’') OR (TKN='’’') 
         THEN
           BEGIN                (*‘‹’/„‚’*)
             CLS:=7;          
             TKN:=TKN+'';
           END
       ELSE IF TST('…†’')
         THEN
           BEGIN                (*…†€’*)
             CLS:=20;          
             TKN:=COPY(TKN,1,L-2)+'€’';
           END
       ELSE IF (TKN='‘’’')
         THEN
           BEGIN
             IF NCH = '1'
               THEN
                 BEGIN          (*‘’’*)
                   CLS:=233;
                   TKN:=TKN+'';
                 END
               ELSE
                 BEGIN          (*‘’’*)
                   CLS:=117;
                   TKN:=COPY(TKN,1,L-2)+'’';
                 END;
             NCH := BL;
           END
       ELSE IF TST('‹’')
         THEN
           BEGIN                 (*‘’’*)
             CLS:=41;
             TKN:=COPY(TKN,1,L-2)+'…’';
           END
       ELSE IF (POS(TKN [L-2],AFFR) > 0)
         THEN
           BEGIN
             TKN := COPY(TKN,1,LENGTH(TKN)-2);
             IF TST('')
               THEN
                 BEGIN         (*…’*) 
                   CLS:=130;
                   TKN:=TKN+'…’';
                 END
              ELSE IF TST('‘‹›')
               THEN
                 BEGIN         (*‘‹›€’*) 
                  CLS:=253;
                  TKN:=TKN+'€’';
                 END
             ELSE IF ROOT_111
               THEN
                 BEGIN         (*„…†€’*)
                   CLS:=111;
                   TKN:=TKN+'€’';
                 END
             ELSE IF ROOT_236 OR STEM_236 
               OR TST('‹€—') 
                 AND (TKN<>'‚‹€—') AND (TKN<>'‹€—')
               THEN
                 BEGIN          (*€‹…—’*)
                   CLS:=236;
                   TKN:=TKN+'’';
                 END
             ELSE              
               BEGIN            (*‡€—’*)
                 CLS:=14;
                 TKN:=TKN+'’';
               END
           END
       ELSE
         BEGIN
           TKN:=COPY(TKN,1,L-2);
           ITYAT(TKN,CLS,FALSE);
         END;
     (*2*)           '':
       IF TST('’') OR TST('’') 
         OR (TKN='‡’') OR (TKN='’')
         OR (TKN='…™…’') OR (TKN='™…’') 
         OR TST('‹’') OR TST('‚‡’')
         THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'›‰';
           END
       ELSE IF TST('‘‹’') AND (TKN<>'…‘‘‹’') 
         OR (TKN='„‚’') OR (TKN='’’') 
         THEN
           BEGIN                (*‘‹’/„‚’*)
             CLS:=7;          
             TKN:=COPY(TKN,1,L-2)+'’';
           END
       ELSE IF TST('‹’')
         THEN
           BEGIN
             CLS:=41;
             TKN:=COPY(TKN,1,L-2)+'…’';
           END
       ELSE IF (TKN='‘’’')
         THEN
           BEGIN
             IF NCH = '1'
               THEN
                 BEGIN
                   CLS:=233;
                   TKN:=COPY(TKN,1,L-2)+'’';
                 END
               ELSE
                 BEGIN
                   CLS:=117;
                   TKN:=TKN+'';
                 END;
             NCH := BL;
           END
       ELSE IF TST('‘’’')
         THEN
           BEGIN
             CLS:=117;
             TKN:=TKN+'';
           END
       ELSE IF TST('•’’')
         THEN
           BEGIN
             CLS:=114;
             TKN:=COPY(TKN,1,L-2)+'…’';
           END
       ELSE
         BEGIN
           TKN:=COPY(TKN,1,L-2);
           ITYAT(TKN,CLS,FALSE);
         END;
    (*2*)           '€':
       IF TST('†€’') 
         OR (COPY(TKN,L-3,4)='‚€’') 
         OR (COPY(TKN,L-3,4)='…‚€’') 
         OR (TKN='ƒ€’') OR (TKN='•€’') 
         OR (TKN='„€’') OR (TKN='ƒ€’') 
         OR (TKN='‚‡›‚—€’') OR (TKN='‚‹‘€’')
         OR (TKN='„›—€’') OR (TKN='†…€’') 
         OR (TKN='›‹€’') OR (TKN='‹•€’') 
         OR (TKN='•€’') OR (TKN='ƒ‘’“…—€’')
         OR (TKN='€—€’') OR (TKN='…ƒ€’') 
         OR (TKN='‘€’') OR (TKN='‡„…‚€’')  
         OR (TKN='€’') OR (TKN='……‹‚—€’')
         OR (TKN='†€’') OR (TKN='“‡€’') 
         OR (TKN='‹‘€’')
         OR (TKN='€‘‹›‚—€’') OR (TKN='€‘‘›—€’') 
         OR (TKN='‘’“‰—€’') OR (TKN='‘’“…—€’') 
         OR (TKN='“‡—€’') OR (TKN='•‚‘’€’') 
         OR (TKN='•€’') OR (TKN='—…“‰—€’') 
         THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'›‰';
           END
       ELSE IF TST('‘‘€’')
         THEN
           BEGIN
             CLS:=164;
             TKN:=TKN+'';
           END
       ELSE IF (POS(TKN [L-2],AFFR) > 0)
         THEN
           BEGIN
             TKN:=COPY(TKN,1,LENGTH(TKN)-2);
              
             IF TST('')
               THEN
                 BEGIN         (*…’*)
                   CLS:=130;
                   TKN:=TKN+'…’';
                 END
             ELSE IF TST('‘‹›')
               THEN
                 BEGIN          (*‘‹›€’*)  
                   CLS:=253;
                   TKN:=TKN+'€’';
                 END
             ELSE IF ROOT_111
               THEN
                 BEGIN          (*„…†€’*)
                   CLS:=111;
                   TKN:=TKN+'€’';
                 END
             ELSE IF ROOT_236 OR STEM_236 
               OR TST('‹€—') 
                 AND (TKN<>'‚‹€—') AND (TKN<>'‹€—')
               THEN
                 BEGIN          (*€‹…—’*)
                   CLS:=236;
                   TKN:=TKN+'’';
                 END
             ELSE              
               BEGIN            (*‡€—’*)
                 CLS:=14;
                 TKN:=TKN+'’';
               END
           END;
    (*2*)           '','›','':
      IF TST('‘‘›’')            (*‘‘€’*)
        THEN
          BEGIN
            CLS:=164;
            TKN:=COPY(TKN,1,L-2)+'€’';
          END
        ELSE
          BEGIN
            CLS:=9;
            SHRTCLS:=1;
            TNS:=NIHIL;
            TKN:=TKN+'›‰';
          END;
    (*2*)           '‘':
       IF (COPY(TKN,L-3,4)='ƒ“‘’') 
         OR (COPY(TKN,L-3,4)='“‘’') 
         OR (COPY(TKN,L-4,5)='‘’') 
         OR (COPY(TKN,L-5,6)='•‹‘’') 
         OR (COPY(TKN,L-6,7)='…‘’') 
         THEN
           BEGIN
             CLS:=4;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'‰';
           END
       ELSE IF (COPY(TKN,L-2,3)='‘’')
         OR (TKN='’‹‘’') OR (TKN='’‚…‘’') 
         OR (TKN='…’‹‘’') OR (TKN='…—€‘’') 
         OR (TKN='…€‘’') OR (TKN='‹€‘’') 
         OR (TKN='ƒ‹‚€‘’') OR (TKN='‘“‹€‘’') 
         OR (TKN='–‚…’€‘’') 
         THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'›‰';
           END
       ELSE IF COPY(TKN,L-3,2)='„€'
         THEN
           BEGIN
             CLS:=22;
             TKN:=COPY(TKN,1,L-2)+'’';
           END
       ELSE IF TST('…‘’')
         THEN
           BEGIN
             CLS:=25;
             TKN:=TKN+'';
           END
       ELSE EROUT;
         ELSE EROUT;
              END;
                END;

(*1*)        '‹':
      IF (TKN = '‚…‘…‹') OR (TKN = '…‚…‘…‹') 
        OR (TKN = '’†…‹') OR (TKN = '–…‹') 
        OR (TKN = '„……‹') OR (TKN = '›•‹') 
        OR (TKN = '“•‹') OR (TKN = '‘‹') 
        OR (TKN = '‹') OR (TKN = '…‹') 
        OR (TKN = '…‡…‹') 
        OR (TKN = '…€‹') OR (TKN = '‚‹')
        OR (TKN = '€ƒ‹') OR (TKN = '„‹') 
        OR (TKN = '‹') OR (TKN = '“ƒ‹')
        OR (TKN = '‹…‹') OR (TKN = '…‡‡ƒ‹') 
        OR (TKN = '‡ƒ‹') OR (TKN = '“ƒ‹') 
        OR (TKN = 'ƒ‹') OR (TKN = '‡€‘“‡‹') 
        OR (TKN = '‚›“‹') OR (TKN = '“ƒ‹') 
        OR (TKN = '„•‹') OR (TKN = '„‹') 
        OR (TKN = '€‹‘‹') OR (TKN = '‡‘‹') 
        OR (TKN = 'ƒ’…‹') OR (TKN = '…‡…‹')
        OR (TKN = '…‘…‹') OR (TKN = '‘‹') 
        OR (TKN = '…“…‹') OR (TKN = '…‘…‹')
        OR (TKN = '‘“’“‹') OR (TKN = '’“‘‹')  
        OR (TKN = '•‹') 
        OR (TKN = '—€•‹') OR (TKN = '‘“‹') 
        OR (TKN = '“›‹') OR (TKN = '’“•‹')
        OR (TKN = '•‹') OR (TKN = '™“‹') 
        THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=1;
             TNS:=NIHIL;
             TKN:=TKN+'›‰';
           END
        ELSE IF (TKN='‘…‹')
            THEN
              BEGIN
                CLS:=3;
                TKN:=COPY(TKN,1,L-1)+'’';
              END
        ELSE IF (TKN='‘…‹')
          THEN
            BEGIN
              IF NCH = '1'
                THEN
                  BEGIN
                    CLS:=9;
                    SHRTCLS:=1;
                    TNS:=NIHIL;
                    TKN:=TKN+'›‰';
                  END
                ELSE
                  BEGIN
                    CLS:=54;
                    TKN:=COPY(TKN,1,L-1)+'‘’';
                  END;
              NCH := BL;
            END
      ELSE IF (TKN = '€‹') 
        THEN
           BEGIN
             CLS:=0;
             SHRTCLS:=1;
             TNS:=NIHIL;
           END
      ELSE IF (TKN = '‡‹')
        THEN
           BEGIN
             CLS:=4;
             SHRTCLS:=4;
             TNS:=NIHIL;
             TKN:=COPY(TKN,1,L-2)+'‹‰';
           END
      ELSE IF (TKN = '’……‹') OR (TKN = '‘…‹')
        THEN
           BEGIN
             CLS:=9;
             SHRTCLS:=2;
             TNS:=NIHIL;
             TKN:=COPY(TKN,1,L-2)+'‹›‰';
           END
        ELSE
      BEGIN
        TNS:=PAST;
        CASE LINE0 [LENGTH (LINE0)-1] OF
    (*2*)           '…':
        CASE LINE0 [LENGTH (LINE0)-2] OF
       (*3*)'':
      BEGIN
        IF L=3
          THEN TKN := '„’'
          ELSE TKN := COPY(TKN,1,L-3)+'‰’';
        IF TKN='„’' THEN CLS:=124
        ELSE IF TKN='‰’' THEN CLS:=153
          ELSE CLS:=6;
      END;
       (*3*)'—':
      BEGIN
        CLS:=45;
        TKN:=COPY(TKN,1,L-2)+'…‘’';
      END;
       (*3*)'–','†':
      BEGIN
        CLS:=9;
        SHRTCLS:=1;
        TKN:=TKN+'›‰';
        TNS:=NIHIL;
      END;
       (*3*)ELSE
      BEGIN
        TKN:=COPY(TKN,1,L-2);
        ELFIN(TKN,CLS,FALSE);
      END;
        END;
    (*2*)           '€': 
      IF (TKN='“„€‹')
        THEN
          BEGIN
            CLS:=4;
            SHRTCLS:=1;
            TNS:=NIHIL;
            TKN:=TKN+'‰';
          END
      ELSE IF (TKN='‘€‹')
        THEN
          BEGIN
            IF NCH = '1'
              THEN
                BEGIN
                  CLS:=61;
                  TKN:=COPY(TKN,1,L-1)+'‘’';
                END
              ELSE
                BEGIN
                  CLS:=170;
                  TKN:=COPY(TKN,1,L-1)+'’';
                END;
            TNS:=PAST;
            NCH := BL;
          END
        ELSE
          BEGIN
            TKN:=COPY(TKN,1,L-2);
            TNS:=PAST;
            ALFIN(TKN,CLS,FALSE);
          END;
    (*2*)           '':
        BEGIN
          TKN:=COPY(TKN,1,L-2);
          ILFIN(TKN,CLS,FALSE);
        END;
    (*2*)           '':
        BEGIN
          TKN:=COPY(TKN,1,L-2);
          YALFIN(TKN,CLS,FALSE);
        END;
    (*2*)           '“':
        BEGIN
          TKN:=COPY(TKN,1,L-2);
          ULFIN(TKN,CLS,FALSE);
          TKN:=TKN+'“’';
        END;
    (*2*)           '›':
        BEGIN
          YLFIN(TKN,CLS,FALSE);
          TKN:=COPY(TKN,1,L-1)+'’';
        END;
    (*2*)           '':
        BEGIN
          CLS:=116;
          TKN:=COPY(TKN,1,L-1)+'’';
        END;
    (*2*)           '„': { ›„‹ }
        BEGIN
          CLS:=235;
          TNS:=PAST;
          TKN:=COPY(TKN,1,L-1)+'“’';
        END;
    (*2*) ELSE EROUT;
        END;
           END;

(*1*)      'ƒ','','•':
  IF WOSONIY (TKN)
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'‰';
      END
  ELSE IF (TKN='†…‘’')
    THEN
      BEGIN
        CASE NCH OF
          '1','2' : 
            BEGIN
              CLS:=10;
              SHRTCLS:=2;
              TKN:=COPY(TKN,1,L-2)+'‰';
            END;
          '3' : 
            BEGIN
              CLS:=10;
              SHRTCLS:=1;
              TKN:=TKN+'‰';
              NCH:=BL;
            END;
        END;
        TNS:=NIHIL;
      END
  ELSE IF (TKN='…‚…‹')
    THEN
      BEGIN
        CLS:=0;
        TNS:=NIHIL;
        SHRTCLS:=2;
      END
  ELSE IF (TKN='‚…‹')
    THEN
      BEGIN
        CASE NCH OF
          '1' : 
            BEGIN
              CLS:=10;
              SHRTCLS:=1;
              TKN:=TKN+'‰';
            END;
          '2' : 
            BEGIN
              CLS:=0;
              SHRTCLS:=2;
            END;
        END;
        NCH:=BL;
        TNS:=NIHIL;
      END
  ELSE IF WSONIY (COPY(TKN,1,L-2))
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=2;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'‰';
      END
  ELSE IF (COPY(TKN,L-4,5)='‘’…') 
    OR (TKN='…') OR (TKN='……')
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=3;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'‰‰';
      END
  ELSE IF (TKN='ƒ…')
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=4;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'‰';
      END
  ELSE IF (TKN='€„…•…') OR (TKN='€„………') 
    OR (TKN='„………') OR (TKN='„…•…')
    OR (TKN='‹………') OR (TKN='‹…•…')
    OR (TKN='‘‹……')
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=5;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'‰';        
      END
  ELSE IF (TKN='’†…')
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=6;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'‰';
      END
  ELSE IF (TKN='„‹ƒ') OR (TKN='…„‹ƒ') 
    THEN
      BEGIN
        CLS:=10;
        SHRTCLS:=6;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'ƒ‰';
      END
  ELSE IF (TKN='‹•') OR (TKN='‘“•') 
    OR (TKN='‹€ƒ') OR (TKN='‚‘…‹€ƒ') OR (TKN='ƒ‹“•') 
    OR (TKN='‹•') OR (TKN='…‹•') 
    OR (TKN='€ƒ') OR (TKN='’“ƒ') 
    OR (TKN='„ƒ') OR (TKN='…„ƒ')     
    THEN
      BEGIN
        CLS:=5;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'‰';
      END
  ELSE SHORTFIN(TKN,CLS,FALSE);

(*1*)      '','','‡','‘','':
  IF (TKN='') OR (TKN='‘“') OR (TKN='‘‹…') 
    OR (TKN='’“') OR (TKN='‘') OR (TKN='‘›') 
    THEN 
      BEGIN
        CLS:=4;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'‰';
      END
  ELSE IF WOSONOR(TKN) OR (TKN='‘‹€')
    OR (COPY(TKN,L-5,6)='‚‹‘')
    OR (COPY(TKN,L-5,6)='ƒ‹‘')
    THEN
      BEGIN
        CLS:=9;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'›‰';
      END
  ELSE IF (TKN='‹')
    THEN
      BEGIN
        CLS:=0;
        SHRTCLS:=1;
        TNS:=NIHIL;
      END
  ELSE IF (TKN='•’…') OR (TKN='…•’…') 
    THEN
      BEGIN
        CLS:=9;
        SHRTCLS:=3;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-2)+'›‰';
      END
  ELSE SHORTFIN(TKN,CLS,FALSE);

(*1*)       '':
  IF (TKN='') OR (TKN='…') 
    OR (TKN='…') OR (TKN='•')  
    THEN
      BEGIN
        CLS:=4;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'‰';
      END
  ELSE IF (POS(TKN[L-1],'…') > 0)
    THEN
      BEGIN
        CLS:=9;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'›‰';
      END
   ELSE EROUT;

(*1*)       '‚','„': 
  IF (TKN='€„') OR (TKN='ƒ€‡„') OR (TKN='’€‚')
    THEN
      BEGIN
        CLS:=0;
        SHRTCLS:=1;
        TNS:=NIHIL;
      END
  ELSE IF WOSONOY(TKN)
    THEN
      BEGIN
        CLS:=4;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=TKN+'‰';
      END
  ELSE 
    BEGIN
      CLS:=9;
      SHRTCLS:=1;
      TNS:=NIHIL;
      TKN:=TKN+'›‰';
    END;

(*1*)       '–': 
    BEGIN
      CLS:=22;
      SHRTCLS:=1;
      TNS:=NIHIL;
      TKN:=TKN+'›‰';
    END;
(*1*)       '†','—','','™': 
         IF AFFRI(TKN) OR (TKN[L] ='™')
           THEN
             BEGIN
               CLS:=3;
               SHRTCLS:=1;
               TNS:=NIHIL;
               TKN:=TKN+'‰';
             END
         ELSE IF (TKN='‘‚…†') OR (TKN='ƒ—')
           OR (TKN='•') OR (TKN='…•')
           THEN
             BEGIN
               CLS:=3;
               SHRTCLS:=2;
               TNS:=NIHIL;
               TKN:=TKN+'‰';
             END;

(*1*)       '…': 
  IF AFFRI(COPY(TKN,1,LENGTH(TKN)-1)) 
    OR (TKN[L-1] ='™')
    THEN
      BEGIN
        CLS:=3;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-1)+'‰';
      END
  ELSE IF TKN[L-1]='–'
    THEN  
      BEGIN
        CLS:=22;
        SHRTCLS:=1;
        TNS:=NIHIL;
        TKN:=COPY(TKN,1,L-1)+'›‰';
      END
  ELSE IF TKN[L-1]=''
    THEN
      IF (TKN='‚……') OR (TKN='‡‹…') 
        OR (TKN='‘……') OR (TKN='…‘……')
        OR (COPY(TKN,L-7,8)='‘’…')
        THEN
          BEGIN
            CLS:=8;
            SHRTCLS:=1;
            TNS:=NIHIL;
            TKN:=COPY(TKN,1,L-1)+'‰';
          END
       ELSE IF (TKN='‘…')
         THEN
           BEGIN
             CLS:=8;
             SHRTCLS:=2;
             TNS:=NIHIL;
             TKN:=COPY(TKN,1,L-1)+'‰';
           END
       ELSE IF (TKN='…‘€‰…')
         THEN
           BEGIN
             CLS:=8;
             SHRTCLS:=3;
             TNS:=NIHIL;
             TKN:=COPY(TKN,1,L-1)+'‰';
           END
         ELSE EROUT;

(*1*)       ELSE EROUT; 
    END;

  IF NOT ERROR THEN PUTINVOC (TKN,CLS,SHRTCLS,TNS);
    END;
    ERROR:=FALSE;
  UNTIL EOF (INP);
  CLOSE (INP);
END;

  FLUSH (OUT);
  FLUSH (OUT1);
  FLUSH (OUT2);

  WRITELN (ERCOUNT, ' errors found');
  WRITELN ('Files SUBJS.COD, SHORTS0.COD and PREDVERB.COD output');
END.
