PROGRAM ENCODNOM; (* Codifies files SUPNOMxx.TXT *)

USES DOS, NOUNTHRU, CLASTABL, ENCODSCI;

  VAR XL_DAS, BUF : STRING [255];

  CONST
    XOYMAX =   91;
    IYMAX  =  183;
    OYMAX  = 1675;

    MAXPART = 1500;
    BL = ' ';
    TAB = #009;
    MAXEXAMPL = 20;

  TYPE
    STR4 = STRING [4];
    STR35 = STRING [35];
    STR115 = STRING [115];
    PARTARR_PTR = ^PARTARR_TYPE;
    PARTARR_TYPE = ARRAY [1..MAXPART] OF
      RECORD
        TOKN : STR115;   (* ‹… “€‚‹™…… ‘“™…‘’‚’…‹… *)
        HNUM : CHAR;     (* … € *)
        TKN1 : STR115;   (* 1-… “€‚‹.‘“™…‘’‚.(..,…„‘’‚…… *)
        TKN2 : STR115;   (* 2-… “€‚‹.‘“™…‘’‚.(..,’‘“’‘’‚“™…… *)
        CLS1 : INTEGER;  (* ‹€‘‘ 1-ƒ ‘“™…‘’‚’…‹ƒ *)
        CLS2 : INTEGER;  (* ‹€‘‘ 2-ƒ ‘“™…‘’‚’…‹ƒ *)
        NMB1 : NUMBER;   (* —‘‹ 1-ƒ ‘“™…‘’‚’…‹ƒ *)
        NMB2 : NUMBER;   (* —‘‹ 2-ƒ ‘“™…‘’‚’…‹ƒ *)
        GND1 : GENDER;   (* „ 1-ƒ ‘“™…‘’‚’…‹ƒ *)
        GND2 : GENDER;   (* „ 2-ƒ ‘“™…‘’‚’…‹ƒ *)
        ANM1 : ANIMA;    (* „“…‚. 1-ƒ ‘“™…‘’‚’…‹ƒ *)
        ANM2 : ANIMA;    (* „“…‚. 2-ƒ ‘“™…‘’‚’…‹ƒ *)
        GLUE : BOOLEAN;  (* ‡€ ‘‹…‰ *)
        HYPH : BOOLEAN;  (* New! €‹—… „…”‘€ *)
        HOLO : CHAR;     (* ‘‚‹ —€‘’/–…‹ƒ *)
        GCAS : INTEGER;  (* … ™…ƒ €„…†€ *)
        FLEX : STR10;    (* —€… *)
        FLX1 : STR10;    (* „‹’…‹… —€… *)
        ONLYDOT : INTEGER;  (* ‡€ €‹— ƒ’— *)
        STY  : INTEGER;     (* ‡€ €‡ƒ‚‘’*)
        IDI  : INTEGER;     (* ‡€ ”ƒ“€‹‘’ *)
      END;

  CONST
    { Adjectival endings }
    SUFS : ARRAY [1..53] OF STRING [4] =
      ('›‰', '‰', '‰', '‰‘', '€', '', '€‘', '…', '……',
      '……‘', '›…', '…', '…‘', '', '…', '', '', '',
      '€', '€€', '€…', '€', '', '€', '', '›',
      '…‘', '‘', '‘…', '’', '‚', '‚€', '‚', '‚›',
      '›€', '›', '', '€', '€€', '€', '€', '€', '', 
      '…', '…', '', '…', '…‰', '', '›', '€', '', '››');

    {Names of stages for noun classification}
    STAG_NAME : ARRAY [STAGE] OF STR6 = 
      ('UNRZD ','BASIC ','VLONG ','SINGLE','HYPHD ', 
      'DBLZR ','ZPRT2 ','NZPRT2','CONJD ');

    CASNO : ARRAY [NOM..LOC] OF STR3 =
       ('NOM','GEN','DAT','ACC','INS','PRE','PAR','LOC');

    { Tail parts for ruling compound nouns }
    MAX = 1289;
    TAILS : ARRAY [1..MAX] OF STRING [24] =
('^E','^…‡€‘‘’','^‡……€€','^^†^’','^^‚^€',
  '^N4','^N5','^N6','^N8','^N9','^N40','^› ‹ ^',
'"^ƒ€‹…’"','"^‹ ^‹"','"^€…’"','^‘^^ƒ',
'"^’…‹‹"','"^…  ^„†“‹…’’€"','"^‹‰ ^–…‡€"',   
  '€€„…','€’‚‘’','€–','€’›','€€‹‡',
'€‚’‹','€•’…’','€‘‘€‹…','€‘‘’…’',
'€‘’€','€’€',
  '€‡€','€‹€‘','€‹‹›','€‹‹','€','€—',
'…‡€‘‘’','…‡€‘‘’','…‡€’–›','…„‘’‚',
'…‹…','……ƒ','………‘’','‹€ƒ‘‘’…',
'‡…‘','‹…’‚','‹…’','‹€ƒ','‹€ƒ‹“—…',
'‹','‹„€','‹…‡','‹…‡','‹','‹‘’‚',
'‹','•','“„“™……','“€ƒ','„†…’','',
  '‚ ‚›‘’“','‚ ƒ‹€‡€•','‚ ƒ‹…','‚ „‹“',
'‚ „','‚ ‘‹“','‚€€‘‰','‚€‹','‚€’€',
'‚‚‡','‚…„…','‚…„‘’‚€','‚…„‘’‚','‚…','‚…',
'‚…’‹–','‚…€','‚…“™•','‚…‘€','‚…‘','‚…’€',
'‚…—…','‚…™…‘’‚€','‚…™…‘’‚','‚…™…‘’‚','‚„','‚„€',
'‚„‚','‚‡€','‚','‚’','‚›','‚‹€„','‚‹€„‚',
'‚“‘','‚‹€‘’','‚‹€‘’','‚‹…—……','‚‹†…',
'‚€…','‚€','‚‡„…‰‘’‚…','‚‡„…‰‘’‚',
'‚„€','‚„‘€†…','‚„›','‚‡„“•€','‚‡†‘’',
'‚‡†‘’',
'‚‡€‘’','‚‰›','‚‰‘€','‚‡€‹','‚ ’“','‚‹',
'‚‹›','‚‹€','‚‹','‚‹‘','‚‘','‚‘›',
'‚‘’€…','‚‘’…','‚‘’ƒ','‚€—','‚€™…',
'"‚……€ ƒ„€"','‚…','‚‘€‹‚€…','‚›€',
'‚›','‚›‚„','‚›ƒ€…','‚›„€—','‚›„…‹…',
'‚›‹…’€','‚›‹€’›','‚›‹…','‚›€†…','‚›•„',
'‚›•„›…','‚›—…’›',
  'ƒ€‡','ƒ€‡‚€','ƒ€€’','ƒ€€’','ƒ€',
'ƒ‹€‡€','ƒ‹“€','ƒ„','ƒ„€','ƒ„‘’','ƒ€',
'ƒ›','ƒ‘’…‘’‚€','ƒ‘“„€‘’‚','ƒ’‚‘’',
'ƒ€„“‘‚','ƒ€„“‘€','ƒ€„“‘','ƒ€†„€','ƒ›',
'ƒ“‡‚','ƒ“„€','ƒ“€','ƒ›†€',
  '„€‚‹……','„€‚‘’','„€›…','„€›•','„€’€',
'„‚ƒ€’…‹','„‚ƒ€’…‹','„‚†……','„‚†…',
'„…‰‘’‚‰','„…‰‘’‚','„…‰‘’‚…',
'„…‹€','„…‹‚ƒ ™…','„…‹','„…ƒ','„…',
'„…’€‹','„…’','„…’‘’‚','„…’…‹‘’','„€€‡',
'„‡€‰','„”‡','„€€','„…’','„…’‚',
'„‘–‹€','„…‰','„','„','„','„€‚',
'„‚‹‘’‚…','„ƒ‚›','„ƒ‚','„€‡€’…‹‘’‚€',
'„€‡€’…‹‘’‚','„“…’€–','„‹ƒ','„‹‹€€',
'„‹','„€','„','„ƒ€','„ƒ','„†€',
'„‘€','„‘','„‘’€‚€','„‘’€’—‘’','„‘’“€',
'„‘’“','„‘’“‘’','„‘“ƒ€','„•„›','„•„','„“',
'„›•€',
  '"^…‚ƒ…‰ ^…ƒ"','…„–','…„–€','…‡„›',
  '†…‹…‡€','†…‹“„','†…‹“„—…','"^†…’€ ^”ƒ€"',
'†…‘’‘’','†‚’›…','†‡','†‡','†‹…','†',
'†’…‹‘’‚€',
   '‡€ ‹›','‡€ ƒ€–“','‡€ †…‰','‡€ ……',
'‡€‹…‚€','‡€‚………','‡€„€…','‡€„€—€','‡€„€—',
'‡€‹—……','‡€›','‡€€','‡€','‡€„€’…‹‘’‚',
'‡€‹›','‡€‹','‡€›€…','‡€’','‡€€‘','‡€€‘›',
'‡€‘€','‡€‘','‡€…€€','‡€‚…„…‰','‡€‘',
'‡€€’','‡€„','‡€’€’›','‡€™’€','‡€™’',
'‡‚€…','‡‚€','‡„‚…','‡„‚','‡……‹',
'‡…‹','‡……','‡…','‡‹‘’','‡€','‡€',
'‡€‰','‡€—……','‡€','‡…','‡……','‡“‚',
  ' €€‹‡',' …‡€‘‘’',' ‹‡…',' “‚€',
' ‚…‘',' ‚„›',' ‚„',' ‚…„',' ‚…„……',
' ‚‡‚€’',' ‚‘’€…',' ‚›‚‡',' ƒƒ…€',
' ƒ',' „…’‘’‚',' „‘’‘’‚',' „“•',
' ‡€„€—',' ‡€›’…',' ‡€€…',' ‡„‚…',
' ‡‹',' ‡€—……',' ’……‘›',' ‚€–',
' €—…‘’‚',' ’‹',
' ‹…ƒ…„›',' ‹…€‘’‚€',' ‹…—……',' ‹†',
' ‹ƒ’›',' …‘’',' …’„›',' …’„',' …€‹›',
' “',' “‘›',' ”›',' €‚›',' €‹€„€',
' €‹…„',' …„‘’€’',' …',' ›',' €‚›',
' €’€',' „›',' ‘‹“†‚€…',' ™…‘’‚',
' ‡€‘’',' ƒ€—…',' …„…‹…',
' ‘’›',' ‘‚›… —…’›',' ‘…‘’',
' ‘’€‚€',' ’‚…‘’',' ’‚…’‘’‚…‘’',
' ’„…‹€',' ’‡›‚',' ’’…',' €„……',' €‘‘‚›',
' …‘…’‚›',' ‹™€„',' ƒ‚',' „•„›',
' „—……',' €‘€',' ‹“—€’…‹',' ‹‡€',
' ‘€„',' ‘‹…„‘’‚',' €‚€',' €‚„€',
' €‚‹€',' €’€',' …›',' ‡€',
' „€',' ‹…›',' ‚…„……',' „€†€',
' „‚†……',' ’‚‚…‘›',' ’‚',
' ’‚€‡€',' ”‹€’€',' ‘•‹ƒ',
' €‡‹—…',' ‘’',' €‘•„›',' €‘‘’€‚€',
' €‘•„',' …€‹‘’',' …’',' „›',' ‹',
' “',' ‘',' ‘‚„›',' ‘‚‰‘’‚€',' ‘„€—€',
' ‘’›',' ‘„…†€…',' ‘…„…',' ‘‘’€‚',
' ‘’“„—…‘’‚',' ‘•€‘’',' ‘…„‰ ‡…‘',
' ‘…„‘’‚€',' ‘’›',' ‘’……',' ‘’“’“€',
' ‘“…’›',' ’€’€',' ’€…–',' ’‚—…‘’‚',
' ’…‹…”',' ’…‹…”›',' ’›',' “‘‹‚',
' “€„',' “‘‹“ƒ',' “‘’‰‘’‚',' “’‹‡€–',
' “’',' ”€‹',' ”›',' ”“–',' •€……',
' –…‹',' ’…',' ‹€',' –','ƒ›',
'ƒ“','„…',
'„…','„’','‡ ‘’','‡‚…‘’','‡„€','‡„…‹',
'‡………','‡……','‡‹…','‡€†……',
'‡“—……','‡“—…','‹ ‚‰€','‹ ‚…„',
'','ƒ€–','“‹‘›','“™…‘’‚€','“™…‘’‚',
'‚…’€','‚€‹„‘’','‚…‘’–','„“–',
'‘’’“’›','‘’’“’','‘’“–','‘’“–',
'‘’“…’›',
'’…ƒ€–','’…‹‹ƒ…–','’……‘›','’……€',
'’“–','”…–','”‹–','”€–',
'”€–','‘€…›…','‘“‘‘’‚€','‘“‘‘’‚',
'‘‹……','‘‹‡‚€…','‘‘‹…„‚€',
'‘’—','‘•„','’ƒ',
  ' ……',' ‘“„“',' ’“„“','"^ ^‹‡…"',
'€…’','€›','€„‚','€‡','^€‹€‚€',
'€‹…„€','€‹‰','€…','€€',
'€€‹‡€–','€„„€’‚',
'€’€‹€','€’€‹','€“‘’€','€’€','€’›',
'€’…ƒ','€’…ƒ','€—…‘’‚€','€—…‘’‚',
'‚€‹”€–','…','‘‹’€','‘‹’›',
'‹€€','‹€‘‘','‹…’','‹…’‚','‹€’',
'‹€’€','ƒ€','†€','†€','†','„…‘',
'„›','‹—…‘’‚€','‹—…‘’‚','‹‹…’‚','‹–€',
'’…’','€’€','€','‹…‘›','‹…‘',
'”’','…—‘’','’€’','’…‘’','’‹',
'”‹’›','–…–','’“€','„€’',
'€’…‹','‡€','','€–','€‰',
'€‘’›','…„’›','‡‘','‚','“ƒ','“ƒ',
'›‹›','›‹…‚','—','“‚','“‹’“€',
'“‹’“›','“…','“‘','“’',
  '‹€„€”’‚','"^‹……„… ‡…"','‹…’','‹…—……',
'‹†','‹‡›','‹','‹','‹‡','‹‘’',
'‹’…€’“€','‹–€','‹–','‹—‘’','‹”’','‹“',
'‹“—','‹ƒ’›','‹„…‰','‹„','‹„€-‘—‘‹……',
  '€ƒ','€…›','€…’ƒ','€','€',
'€‘','€‘‹€','€‘‹','€‘‘€','€‘’€',
'€’…€‹›','€’','……‹','€’…€‹›','€€',
'€‘’……','…„–€','…‡‹’€','…›',
'…‘’€','…‘’','…‘–€','…‘–…‚','…‘—›•',
'…’„›','…’','…’','…’‚','…•€‡›',
'…•€‡','…•€€','…€‹›…','“',
'‘’‚',
'‘’','“’›','€','','‘‘','……',
'…','ƒ€‡…','‹‘’','„…‹',
'„…‹','„…‹‚€…','„…','‡ƒ','‹„…†',
'‹€','‹','‹—€','…’','‡›',
'’‚›','’€','—','™','™‘’','™',
'“‡›€','›‹','›‘‹','›‹……','‘',
  '€ …','€ ‚›‘ €‹“…','€ †’…‹‘’‚',
'€','€‚›','€ƒ“‡','€„‡','€…','€‡€—……',
'€‹…','€‹ƒ','€‹…’','€‹—›•','€€‚‹…',
'€€‚‹…‘’','€†…‘’','€“……','€“…',
'€‘€†„…','€‘…‹…','€‘‹…','€‘’……','€’',
'€“€','€“','…‚‡‚','…„‚†‘’','…„‚…',
'…„‘’€’','…„‘’€’—‘’','…‘€‚‘’…‰',
'…•„…','…€’‘‘‘’','’','’','›',
'…','‘€','‚‘’…‰','—€ ‘……€„€','€‚‚',
'“†„€',
  '…‘…—……','’€','…','‹—€',
'€','’','“„‚€…','€‡ †‡',
'€‡‚€…','€‡‚€','€™…','“……',
'‘‹“†‚€…','‘’’…‹‘’‚€','“—…','™……',
'™…','™…‘’‚','™›','…„…',
'…’›','‡€‘’','‡€‘’','‡€’…‹‘’‚€',
'‡€’…‹‘’‚','…„…','ƒ','ƒ€—…',
'„…†„€','†„€…','†„€','‡€—…‘’','€',
'“†€™…‰ ‘…„›','…€’›','…€–','…€',
'………','‹€’›','’€','‘','›’','›’',
'ƒ€‡€–','ƒ€‡€–','ƒ€‡€','ƒ€›',
' ‘‘…','ƒ€','„…','…•','…’€–',
'“†…','‘€‹','‘‚€','‘‚€','‘‚›',
'’','’‚…’€','’„…‹','’„›•','‘“™…‘’‚‹…',
'’‚…’‘’‚…‘’','’‚…’‘’‚…‘’','’„›•€',
'’„›•','’›’','’‹—','’‘’…‹‘’',
'’……','’…','’€‚‹…','’“',
'’‘’€‹‘’','’’…','’–›','”‹……',
'•‹€†„…','–…€','—……„',
  '€‹’€','€’','€…‹','€€…’›','€’',
'€’','€’…‘’‚','€›','€‘’','€‘‘€†‚',
'……‚‡','……‘…‹……','……€’€',
'……‚“†……','……›‚','…‘…','…„',
'…‘€‹','…‘€‹€','…‘€‹','"^‚€ „€€"',
'€„›','‘€…','‘€','‘','’€…',
'’€','‹€‚€…','‹€‚‹…','‹€‚€…',
'‹€','‹€’€','‹€’…†','‹…—',
'‹™€„','‹™€„€','‹™€„','^^','‚…„……',
'‚…„…','‚’€','‚…†„……','‚…†„…',
'ƒ…€','„ ƒ‹€‡€','„€','„€','„€—',
'„„…†€','„ƒ’‚','„•„','‡‚—€',
'‡–','‡€…','€…','‰','‹……',
'‹','‹…‡‘’','‹…’€','‹…','‹’€',
'‹’—…‘… ›‹……','‹—‰','‹—',
'‹‚€','‹†……','‹‘€','‹‘›',
'‹‡‚€’…‹','‹“€‘€„€','‹','‹“—…',
'‹‡‚€’‘','…™……','…™…','™',
'™','’…','„›','','“—……',
'„','„€','‘…‹','‘‹…„‘’‚','‘…',
'‘','‘“„€','’','’…‹……','’…–€‹',
'’…','’‹','’…’…‹…‰','’…’…‹',
'’…‹……','’','•„','—’€…',
'‘€','€‚‹','€‚’…‹‘’‚€','€‚‹…',
'€‚’…','€‚€“…','€‚','€‚€',
'€‡„','€’€','…›‚€','…„€‘’',
'…„‹ƒ','…„‹†……','…„‘’†‘’',
'…„€’…‹‘’‚','…„’','…„‘’€‚‹…',
'…','…€€’›','…‘‹…„‚€…','…‘’“‹…',
'…‘’“‘’','…’…„…’‚','…€','›‹',
'‚‹…€’…‹‘’',
'‹…’€','……','€„‹…†‘’','–›',
'’ ……‰','‘','„›','‘†›•',
'’†…','—€','—›','…‘’‚…',
'‹…€','‹…›','‚…„…','ƒ€‚€…',
'ƒ€€','ƒ€‚€','ƒ€›','ƒ…‘‘',
'„“’‚‘’','„“’›','…‡„','…’',
'†‚€…','†‚€','‡‚„’…‹','‡‚„‘’‚',
'‘•†„……','›‘…‹','›‘‹›','‘’€‘’‚€',
'‘’€‘’‚','‘’“„€','–…„“›','–…’‚',
'–…‘‘›','–…‘‘','—‘’','‘•‹ƒ','“‹‘',
'“’›','“’','“’','“’','…','’€','’',
  '€’€','€’','€’','€’›',
'€‚‚…‘…','€„€‹›','€‡','€‡‚’…','€‡‚’',
'€‡„€','€‡‹—','€‡…','€‡†……',
'€‡†…','€‡–€','€‡‚„‘’','€‡€‡…',
'€‰›','€‡›‚','€‡„',
'€‘‘‹……','€‘‘’‰‘’‚€','€‘’…','€‘•„‚',
'€‘—…’','€‘…','……€','…‚‹–',
'…€–','…‚‹–','…ƒ‘’€–','…ƒ“‹‚€…',
'…ƒ“‹‚€','…„€’','…†›','…†','…‡…‚›',
'…‡‘’','……„€–','…„','…„›','…’€',
'…‘“‘›','…‘“‘‚','…”€','……‰','…—',
'‹…‰‡','‘€','‘€','‘‚','‘','’€',
'†„…','‹','‘€','‘’€','‘’','“‹','“',
'“€','“‚„’…‹','^“‘','›','›','„',
  '‘€„','‘€‰’','‘€‹€’','‘€“‰‘’‚','‘€“€‚‹……',
'‘€–‰','‘€•€€','‘‹†…','‘','‘›’€',
'‘‚…„…','‘‚…’€','‘‚„›','‘‚‰‘’‚€','‘‚‡…‰',
'‘‚‡','‘‚‡','‘‚‡','‘…',
'‘……’€','‘…’','‘…’','‘…’€','‘…’','‘…—……',
'‘ƒ€‹‡€–','‘ƒ€‹','‘‹','‘‹€','‘‹›',
'‘‘’…€','‘‘’…›','‘’“€–','‘’“€–',
'‘…†…’','‘€','‘‹…„‚€','‘‹‚€',
'‘‹‚','‘‹‚','‘‹‰','‘‹“†€','‘‹“†›','‘‹“—€',
'‘‹“—€‰','‘€„›','‘…’‘’','‘…’',
'‘‹€','‘›‘‹','"^‘…†€ ‹…‚€"','"^‘‹‚…‰"',
'‘€…','‘‘’‚…‘’','‘‘’‚…‘’','‘›’',
'‘‚…‘’','‘‚…’›','‘‚…’','‘ƒ‹€……','‘ƒ‹€…',
'‘„…†€…','‘…„…','‘‡€…','‘‡€',
'‘','‘','‘€’€','‘“†…','‘‘’€‚',
'‘‘’…','‘‘“™…‘’‚‚€…','‘’“„',
'‘’“„','‘’“„—…‘’‚','‘“‘','‘•€…',
'‘–€‹‡€–','‘…’','‘…–€‹‘’›','‘’€',
'‘’','‘›','‘‘‘’','‘‘‘’',
'‘€‚€','‘€‚…„‹‚‘’','"^‘™€ €‘€‚–€"',
'‘€‚…','‘…„€',
'‘…„…ƒ ‚‡€‘’€','‘…„‘’‚€','‘…„‘’‚','‘',
'‘›‚','‘’€‹‘’','‘’€‚€','‘’€‚','‘’€„',
'‘’€„€’›','‘’€','‘’€—…','‘’€–','‘’€……',
'‘’€’‘’€','‘’€’“‘','‘’…‹','‘’……','‘’‹',
'‘’‘’','‘’‹›','‘’‹','‘’€','‘’›',
'‘’€’”€–','‘’€•‚€…','‘’€•‚€','‘’…‹›',
'‘’’…‹‘’‚','‘’‰','‘’—','‘’“’“€',
'‘’“’“›','‘’“‹','‘’›„','‘“…’›','‘“„','‘“„€',
'‘“','‘“€','‘“™……','‘“™…‘’‚‚€','‘”…€',
'‘”…›','‘•…€','‘—…’','‘›', 
  '’€‡','’‚—…‘’‚','’…‹…”€','’…‹€','’…‹…”',
'’…‹','’…›',
'’……€’“€','’…','’…€','’…€‹',
'’…„€','’…‘','’…‘’','’…•€',
'’…•‹ƒ','’›','"^’•‰ ^„"','’€',
'’‚€›','’€','’ƒ€”','’','’‡‹‹’',
'’ƒ‚…–','’ƒ‚‹','’‡€','’—€','’—',
'’…','’“€','’“„','’“„€','’€‚€’‡',
'’€‘’','’€‘‘€','’…‘’','’“€‹…’›',
'’“‡','’ƒ','’†…‘’…‰','’†…‘’',
  '“›’‚','“‚€†…','“ƒ‹','“„€',
'“„‘’‚………','“‡‹›',
'“€…','“‘“‘','“€‚‹……','“€‚‹…',
'“‚…','“‘‹…','“‘‹‚…','“‘‹‚',
'“‘‹“ƒ','“‘‹“ƒ','“‘’‰—‚‘’',
'“‘’‰‘’‚€','“‘’‰‘’‚','“•','“—€‘’…',
'“—€‘’','“—…’€','“—…†„…','“™…','“™…€',
  '”€’›','”€’','”ƒ“€','”‡“‹’“€',
'”‹‘”','”‹’','^”…„…€–','”„›','”„',
'”','”€','”›','”€‡›','”’','”“–',
'”’…‡',
  '•€€’…‘’€','•€€’…‘’','•“ƒ',
'•„€','•‡‰‘’‚','•€…',
  '–…‹‘’‘’','–…‹','–……','–…‘’…‰',
'–…‘’','–…‘’','–…’›','–…’','–…',
'–…€','–…','–…‚','–‚‹‡€–','–‹',
  '—€‘’','—€‘’','—€‘’’€','—€‘','—…','—…‹‚…€',
'—…‹‚…','—…’›','—…‘’','—‘‹€','—‘‹','—‹…›',
'—‹…',
  '€ƒ','€‘›','','‹€','™…’€','"^™…‹“—"',
  '‡€…›','‹ƒ','€','€','€›',
'‘……’','‹…’—…','‹’€','‹…’‘’€–',
'‹……’›','ƒ€–','…ƒ','…ƒ','€',
'’€›','’€','’…’','”','””…’‚‘’',
'””…’›','””…’',
  '‘’–',
  '‚‹…','‡›','‡›','‰–€','‰–','€','™');

  VAR
CLASS, SUBCL, IDIOM, STYL : INTEGER;
K, P, PH, QS1, QP, QH, CLSI  : INTEGER;
LINENUM, PARTAMT, I, J : LONGINT;
INP, INP1, OUT, OUT1, OUT3, OUT5, OUTF, OUTG : TEXT;
LINE, LINE1, HEADLINE, HEADER, HEADER1,  
  TRUNKS1, TRUNKP, TRUNKH, PREPI : STRING [85];
FNAME, FNAMEOUT : STRING [15];
NUMB0, NMBI : NUMBER;
GEND0, GNDI : GENDER;
ANMI : ANIMA;
DOUBLE_FL, FL_REVERS, VALI : BOOLEAN;
PARS : ARRAY [0..4] OF LONGINT;
CH, USACH, FIRST, SECOND : CHAR;
USECOUNT : ARRAY [0..5] OF LONGINT;

CLASS17 : ARRAY [1..OYMAX] OF STRING [19]; (* ‹‰ *)
CLA0018 : ARRAY [1..XOYMAX] OF STRING [15];  (* ‘“•‰ *)
CLA0107 : ARRAY [1..IYMAX] OF STRING [15]; (* ”€‡€‰ *)

STG : STAGE;
STAG_CNT : ARRAY [STAGE] OF LONGINT;

PARTARR : PARTARR_PTR;

CAS_WO_PREP : ARRAY [0..7] OF LONGINT;
PREPO : ARRAY [8..MAXPREP29] OF LONGINT;
PREPOTOTAL, WOPREPTOTAL : LONGINT;

CASESETS : ARRAY [8..MAXPREP29] OF
  RECORD
    PREPCODE : LONGINT;
    EXAMQUAN : INTEGER;
    CASNAME : CASUS;
    CASTRING : STR35;
    EXAMPLES : ARRAY [1..MAXEXAMPL] OF ARRAY [1..2] OF STR35;
    EXAMPLES2 : ARRAY [0..MAXEXAMPL] OF STR115;
  END;


{ Initiate array for group allocation in heap }
PROCEDURE INIT_ARRAY;
        (*==========*)
VAR I : LONGINT;
BEGIN
  NEW (PARTARR);
  FOR I := 1 TO MAXPART DO
    WITH PARTARR^ [I] DO
      BEGIN
        TOKN := DUMMY;
        HNUM := BL;
        TKN1 := DUMMY;
        TKN2 := DUMMY;
        CLS1 := 0;
        CLS2 := 0;
        NMB1 := UNKN;
        NMB2 := UNKN;
        GND1 := NONE;
        GND2 := NONE;
        ANM1 := IND;
        ANM2 := IND;
        GLUE := FALSE;
        HYPH := FALSE;
        HOLO := BL;
        GCAS := 1;
        FLEX := DUMMY;
        FLX1 := DUMMY;
        ONLYDOT := 0;
        STY  := 0;
        IDI  := 0;
      END;
 END;

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
(TOKEN = '€‰-’') OR (TOKEN = '€‰-‹') OR
(TOKEN = '€‰-“„') OR
(TOKEN = '€€-’') OR (TOKEN = '€€-‹') OR
(TOKEN = '€‰-“„') OR
(TOKEN = '€…-’') OR (TOKEN = '€…-‹') OR
(TOKEN = '€‰-“„');
END;

{ 'Feminine' noun CLASS with the same endings 
  N = 1: in GEN and DAT αases 
  N = 2: in GEN, DAT, and INS αases }
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
    FLEX := COPY (TOKEN, L - LENGTH(SUFS [I]) + 1, LENGTH (SUFS [I]));
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
          IF STEM [L-1] = ''
            THEN CLASS := 1
          ELSE IF (POS (STEM [L-1], SONOR) > 0)
            THEN CLASS := 9
            ELSE CLASS := 2;
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
        END;
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
      MASC : MEETS_GEND := (POS (CH, '‚„‡‰‹‘’”–'+ AFFR + LABIA) > 0);
      FEM :  MEETS_GEND := (POS (CH, '€') > 0);
      NEUT : MEETS_GEND := (POS (CH, '…') > 0)
               OR (TOKEN = '‚…') OR (TOKEN = '');
      COMN : MEETS_GEND := (POS (CH, '›€') > 0);
      ELSE MEETS_GEND := FALSE;
    END;
  END;


FUNCTION HASTAIL (TOKEN : STR115) : INTEGER;
       (*=======*)
  VAR
    I, L : INTEGER;
    FOUND : BOOLEAN;

BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT
    INC (I);
    L := LENGTH (TAILS [I]);
    FOUND := (TAILS [I] = COPY (TOKEN, 1, L)) AND (TOKEN [L+1]= BL);
  UNTIL FOUND OR (I = MAX);
  HASTAIL := I * ORD (FOUND);
END;


PROCEDURE CODE_LINE (NUM : INTEGER;
        (*=========*)LINE : STR115);
  VAR
    LINE1 : STR115;
    LOW, HIGH, MID, P, P1, Q, L : INTEGER;
    FOUND : BOOLEAN;
    RESULT : RESTYPE;
    PREPSTR, FLEXSTR : STR115;
    TMP : STR10;

BEGIN

  LINE1 := COPY (LINE, 3, LENGTH (LINE) - 2);
  WITH PARTARR^ [NUM] DO
    BEGIN
(* Coding of style and idiomacity *)
      STY := STYL;
      IDI := IDIOM;

(* Extraction of part-whole symbol *)
      HOLO := LINE [2];

(* Extraction of glue symbol and fast return *)
      GLUE := (LINE1 [1] = '/');
      IF GLUE
        THEN
          BEGIN
            LINE1 := COPY (LINE1, 2, LENGTH (LINE1) - 1);
            {IF (POS (LINE1 [LENGTH(LINE1)], '123456') > 0)
              THEN
                BEGIN
                  HNUM := LINE1 [LENGTH (LINE1)];
                  TOKN := COPY (LINE1, 1, LENGTH(LINE1) - 1);
                END
              ELSE 
                BEGIN}
            TOKN := LINE1;
            IF (TOKN = DUMMY) OR (TOKN = BL) 
              THEN
                BEGIN
                  WRITELN (HEADLINE);
                  HALT;
                END;
                {END;}

            P := POS (BL, TOKN);
            IF P > 0
              THEN
                BEGIN
                  TKN1 := COPY (TOKN, 1, P - 1);
                  TKN2 := COPY (TOKN, P + 1, LENGTH (TOKN) - P);
                END
          {!} ELSE
                BEGIN
                  P := POS ('_', TOKN);
                  IF P > 0
                    THEN
                      BEGIN
                        HYPH := TRUE;
                        TKN1 := COPY (TOKN, 1, P - 1);
                        TKN2 := COPY (TOKN, P + 1, LENGTH (TOKN) - P);
                        TOKN [P] := '-';
                      END 
                   ELSE TKN1 := TOKN
                 END;
            EXIT;
          END;

(* Try to extract concluding dots *)
      IF COPY (LINE1, LENGTH (LINE1) - 3, 4) = ' ...'
        THEN
          BEGIN
            ONLYDOT := 4;
            LINE1 := COPY (LINE1, 1, LENGTH (LINE1) - 4);
          END;

(* Split ruling noun or 1st its word  *)
      P := POS (BL, LINE1);
      TOKN := COPY (LINE1, 1, P - 1);
      PH := POS ('_', TOKN);
      IF PH > 0
        THEN
          BEGIN
            HYPH := TRUE;
            TKN1 := COPY (TOKN, 1, PH-1);
            TKN2 := COPY (TOKN, PH+1, LENGTH(TOKN)-PH);
            TOKN [PH] := '-';
          END
        ELSE TKN1 := TOKN;
      LINE1 := COPY (LINE1, P + 1, LENGTH (LINE1) - P);

(* Try to split tail of ruling compound *)
      Q := HASTAIL (LINE1);
      IF Q > 0
        THEN
          BEGIN
            TOKN := TOKN + BL + TAILS [Q];
            TKN2 := TAILS [Q];
            L := LENGTH (TAILS [Q]);
            LINE1 := COPY (LINE1, L + 2, LENGTH (LINE1) - L - 1);
          END
        ELSE
          IF (POS (TKN1 [LENGTH (TKN1)], '123456') > 0)
              THEN
                BEGIN
                  HNUM := TKN1 [LENGTH (TKN1)];
                  TKN1 := COPY (TKN1, 1, LENGTH (TKN1) - 1);
                END;

(* Try to extract inner dots *)
      IF POS (DOTS, LINE1) = 1
        THEN
          IF ONLYDOT = 4
            THEN WRITELN (FNAME, ' ERROR: Repeating dots at ', LINE)
            ELSE
              BEGIN
                ONLYDOT := 3;
                LINE1 := COPY (LINE1, 5, LENGTH (LINE1) - 4);
              END;

 (* Exract preposition, simple or compound *)
      GCAS := 1; (* before further elaboration *)
      P := POS ('~', LINE1);
      IF (P = 0)
        THEN
          BEGIN
            WRITELN (FNAME, ' ERROR: Lack of tilde at ', HEADLINE, '=>', LINE);
            EXIT;
          END;

{ Preposition coding }
      PREPSTR := COPY (LINE1, 1, P-2);
{ ... Search in leading group }
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
{------------------------------------------------------------)}                                                    
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
                                              {====================}            
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
{-----------------------------------------------  ----------}
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

(* Split the flexion *)
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

{ Is possible PARtitive case for TOKEN? }
FUNCTION PART_POSSIBLE (TOKEN : STR115) : BOOLEAN;
       (*=============*)
  CONST
    PARTMAX = 50;
    PART_TOKENS : ARRAY [1..PARTMAX] OF STRING [9] =
('…‡','‚‡„','‚„','ƒ€‡',
'„‹ƒ','„“•','„›','†€',
'‚€‘','‚€‘','“€†','’','','€•€‹',
'‹…„','‹…’','€•','…„','‘','“‘','€„',
'ƒ…','€','……–','…‘','•','“•',
'‘€•€','‘‚…’','‘…ƒ','‘','‘’€•','‘“','‘“…–','‘›',
'’€€','’‹','’“€','“‘“‘','”‘',
'•„','•‹„','—€…','—€‰','—…‘',
'€ƒ','…‹','','‹€„','•');
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

{ Does verb TOKEN imply DATiveness? }
FUNCTION MEANS_DATIV (TOKEN : STR115) : BOOLEAN;
       (*===========*)
  CONST
    MAXDAT = 34;
    SOME_TOKENS : ARRAY [1..MAXDAT] OF STRING [16] =
('‚…‘’','‚›…‘……',
'‡‚','…„’›',
'€…','€…','€‘’€‚‹……','…‚‚……',
'’‚…’','’‚…’›','’',
'„€','„€',{'“ƒ‡€',}'‡€„€…','„€—€','™',
  '‡','‘‹€…','‘›‹€','‘’€‚€','’€€…',
  '…„—’……','…’‘’‚…','…’‘’‚',
  '‚…†…‘’','„€†€','’‚„…‰‘’‚…',
  '™……','‘‚™……',
'‘‹…„‚€…','‘’‚…’‘’‚…','‘—“‚‘’‚…',
'“‘’“€','“™…');
    SOME_PREFS : ARRAY [1..10] OF STR6 =
('‚›','„','……','','…„','…„','','','‘','‘');

{"Άλ¤ η   ­­®β ζ¨¨/¨­αβΰγªζ¨¨/¨­δ®ΰ¬ ζ¨¨..." - ­¥ ¤ β¥«μ­λ©!!! 
‚®§¬®¦­  ―ΰ®Ά¥ΰª  ―® ª« ααγ αγι¥αβΆ¨β¥«μ­®¬γ ¨«¨ ®βαγβαβΆ¨ο 
―¥ΰ¥¤ ­¨¬ ¬­®£®β®η¨ο}
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
            UNTIL FOUND OR (J = 10);
            MEANS_DATIV := FOUND;
          END;
END;

FUNCTION SUITED (FLEX : STR5;
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


PROCEDURE ENCODE_ITEM (CLASS : INTEGER;
        (*===========*)NUM : INTEGER);
   VAR
     DONE : BOOLEAN;
BEGIN
  DONE := FALSE;
  WITH PARTARR^ [NUM] DO
    BEGIN
      IF (CLASS = 0) AND (GCAS = 0)
        THEN
          BEGIN
            GCAS := 1;
            DONE := TRUE;
          END;
      IF NOT DONE AND MEANS_DATIV (TOKN)
        AND SUITED (FLEX, CLASS, DAT, GCAS)
        THEN DONE := TRUE
      ELSE
        BEGIN
          IF SUITED (FLEX, CLASS, GEN, GCAS)
            THEN DONE := TRUE
          ELSE IF SUITED (FLEX, CLASS, ACC, GCAS)
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
          CLASS, '=>', HEADLINE, BL, TOKN, ' ~', FLEX);
    END;
END;


PROCEDURE ENCODE_VALID (CLASS : INTEGER);
        (*============*)
   VAR
     I : INTEGER;
     DONE : BOOLEAN;

BEGIN
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR^ [I] DO
  IF NOT GLUE
    THEN
      BEGIN
        IF FLEX = '~'
          THEN FLEX := FINALS [CLASS, NOM]
        ELSE IF FLEX = '/'
          THEN FLEX := DUMMY;

        IF (GCAS >= 8)
          THEN (* Test of preposition-to-flexion match *)
            BEGIN
              IF (FINALS [CLASS, PREPOS [GCAS].CAS] <> FLEX)
                THEN WRITELN (FNAME, ' ERROR: Preposition-Flexion dismatch ',
                  HEADLINE, '=>', TOKN, BL, PREPOS [GCAS].PRP, ' ~', FLEX);
            END
          ELSE (* Test of prepositionless ending and then its coding *)
            BEGIN
              DONE := FALSE;
              IF PART_POSSIBLE (TOKN) AND SUITED (FLEX, CLASS, PAR, GCAS)
                THEN DONE := TRUE;
              IF NOT DONE
                THEN ENCODE_ITEM (CLASS, I);
            END;
      END;
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
{ ELSE WRITELN (FNAME, ' ERROR: WRONG INANIMATE CLASS: ', CLASS);}
END;

PROCEDURE ENCODE_NOUNS;
        (*============*)
   VAR
     I : INTEGER;
     NOUN : STR115;

BEGIN
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR^ [I] DO
      BEGIN        
        PARSENOUN (TOKN, NOUN, CLS1, CLS2, NMB1, GND1, STG);
        TOKN := NOUN;
        INC (STAG_CNT [STG]);
      END;
END;

(* Output of group, line-by-line *)
PROCEDURE PARTOUT;
        (*=======*)
VAR
  I : INTEGER;
  TMP : STR115;

BEGIN
  TMP := DUMMY;
  FOR I := 1 TO PARTAMT DO
    WITH PARTARR^ [I] DO
      BEGIN
        IF GLUE
          THEN
(* IB *)    BEGIN
              GCAS := 255;
              IF HNUM <> BL
                THEN TOKN := TOKN + HNUM;
            END;

        IF (COPY (HEADLINE, LENGTH(HEADLINE)-3, 4) = ' ‚…') AND (GCAS = 3)
          THEN GCAS := 1;
        
        WRITELN (OUT, HOLO, TOKN, BL : 21 - LENGTH (TOKN),
           ONLYDOT : 2, GCAS : 5, STY : 2, IDI : 2);   {IAB}


        IF (GCAS >= 8) AND (GCAS <= MAXPREP29) 
           AND (POS(BL, TOKN) = 0) AND (POS(BL, HEADLINE) = 0) 
           THEN
             WITH CASESETS[GCAS] DO
               IF EXAMQUAN < MAXEXAMPL
                 THEN
                   BEGIN
{-----------------}                      
                     INC(EXAMQUAN);

                     QS1 := LENGTH(TOKN);
                     IF (POS(TOKN[QS1],'123456') > 0)
                       THEN TRUNKS1 := COPY(TOKN, 1, QS1-1)
                       ELSE TRUNKS1 := TOKN;
                     EXAMPLES[EXAMQUAN, 1] := TRUNKS1;

                     PREPI := PREPOS[GCAS].PRP;
                     QP := LENGTH(PREPI);
                     IF (POS(PREPI[QP],'123456') > 0)
                       THEN TRUNKP := COPY(PREPI, 1, QP-1)
                       ELSE TRUNKP := PREPI;
                     CASTRING := TRUNKP;
                     
                     QH := POS('<', HEADLINE);
                     IF QH > 0
                       THEN TRUNKH := COPY(HEADLINE, 1, QH-2)
                       ELSE TRUNKH := HEADLINE;
                     EXAMPLES[EXAMQUAN, 2] := TRUNKH;
                                   
                     INITSUBCL(TRUNKH, CLSI, VALI, NMBI, GNDI, ANMI);

                     EXAMPLES2[EXAMQUAN] := TRUNKS1 + BL + TRUNKP + BL
                       + COPY(TRUNKH, 1, LENGTH(TRUNKH) - LENGTH(FINALS[CLSI,NOM]))
                       + FINALS[CLSI,PREPOS[GCAS].CAS]; 
{-----------------}       
                   END; 
        
        
        IF GCAS < 8
          THEN INC(CAS_WO_PREP [GCAS]);

        IF (TOKN <> TMP)
          THEN
            BEGIN
              WRITELN (OUT1, '1', CLS1 : 4, CLS2 : 4, ORD (NMB1) : 2,
(* IB *)         ORD (GND1) : 2, BL, TOKN);
(*              WRITELN ('1', CLS1 : 4, CLS2 : 4, ORD (NMB1) : 2,
           ORD (GND1) : 2, BL, TOKN); *)
              TMP := TOKN;
            END;
      END;
  DISPOSE (PARTARR);
END;

(* Group coding and output of its header *)
PROCEDURE OUT_HEADLINE;
        (*============*)

BEGIN
  (* General case coding in the group *)
  ENCODE_VALID (CLASS);

  (* „‚€… ‘“™…‘’‚’…‹›• ‚ ƒ“… *)
  ENCODE_NOUNS;

  (* ‘‘’‚… ‚›‚„ ‡€ƒ‹‚€ ƒ“› ‚ „‚€ €‡›• ”€‰‹€ *)
  WRITELN (OUT, HEADLINE);
  WRITELN (OUT1, HEADLINE);
(*  WRITELN (HEADLINE); *)
END;

{ Find the same line in header list to syncronize }
PROCEDURE FIND_SAME_LINE (VAR CLASS, SUBCL : INTEGER;
        (*==============*)VAR NUMB0 : NUMBER;
                          VAR GEND0 : GENDER;
                          VAR DOUBLE_FL, FL_REVERS : BOOLEAN);
  VAR
    J, P : INTEGER;
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
  FOUND := (LINE1 = LINE);
  IF FOUND
    THEN (* Taking parameters of the group header *)
      BEGIN
        IF (0 < PARS [2]) AND (PARS [2] <> 255)
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
        FL_REVERS := (DOUBLE_FL AND (SUBCL > 0));  
      END
    ELSE
      BEGIN
        WRITELN (FNAME, ' ERROR: No match to ', LINE);

        CLASS := 0;
        SUBCL := 0;
        NUMB0 := NUMBER (0);
        GEND0 := GENDER (0);
        DOUBLE_FL := TRUE;
        FL_REVERS := FALSE;
      END;
END;


BEGIN      (* Main  *)
  GLOBAL_INIT;

     (* –€‹‡€– ”€‰‹‚  ………›• *)
  XL_DAS := GetEnv ('XL_DAS_PATH');
  IF XL_DAS = '' THEN
    XL_DAS := '../DAS/';

  FOR I := 8 TO MAXPREP29 DO
    PREPO [I] := 0;
  FOR I := 0 TO 7 DO
    CAS_WO_PREP [I] := 0;
  FOR I := 0 TO 5 DO
    USECOUNT [I] := 0;
  FOR STG := UNRZD TO CONJD DO
    STAG_CNT [STG] := 0;

  FOR J := 8 TO MAXPREP28 DO
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

  ASSIGN (INP1, 'OPFUNC_0.LST');
  RESET (INP1);
  FOR J := 0 TO 4 DO
    READ (INP1, PARS [J]);
  READ (INP1, CH);
  READLN (INP1, LINE1);

  ASSIGN (OUT3, 'PREPO2.LST');
  REWRITE (OUT3);

  ASSIGN (OUT5, 'MOPFCAS2.LST');
  REWRITE (OUT5);

  ASSIGN (OUT1, 'SUPNOM.COD');
  REWRITE (OUT1);

  ASSIGN (OUTF, 'NNEXAMPL.TXT');
  REWRITE (OUTF);

  ASSIGN (OUTG, 'NNEXAMPL2.TXT');
  REWRITE (OUTG);

  MAKE_SUPNOM_1 (OUT1);
                    	
  FOR K := 0 TO 44 DO
    BEGIN
      FNAME := 'SUPNOM' + CHR (ORD('0') + K DIV 10) +
        CHR (ORD('0') + K MOD 10) + '.TXT';
      WRITELN (BL + FNAME + BL + 'processed');

      ASSIGN (INP, FNAME);
      RESET (INP);

      FNAMEOUT := COPY (FNAME, 1, LENGTH (FNAME) - 3) + 'COD';
      ASSIGN (OUT, FNAMEOUT);
      REWRITE (OUT);

      PARTAMT := 0;
      CLASS := 0;
      SUBCL := 0;
      NUMB0 := UNKN;
      GEND0 := NONE;
      INIT_ARRAY;
      DOUBLE_FL := FALSE;
      FL_REVERS := FALSE;
      LINENUM := 0;

    (* ‘‚‰ –‹ *)
  REPEAT
    READLN (INP, LINE);
    INC (LINENUM);
    WHILE (LINE [LENGTH (LINE)] = BL) DO
      BEGIN
        WRITELN (FNAME, ' ERROR: final blank in line ', LINENUM);
        LINE := COPY (LINE, 1, LENGTH (LINE) - 1);
      END;
 
    IF (LINE[4] = '/') AND (POS('~', LINE) > 0) 
      OR (POS(TAB, LINE) > 0) OR (POS('  ~', LINE) > 0)
      THEN WRITELN (FNAME, ' ERROR: wrong tilde or tab in line ', LINENUM);

    USACH := LINE [1];
    LINE := COPY (LINE, 2, LENGTH (LINE) - 1);
    FIRST := LINE [1];
    SECOND := LINE [2];

    IF (FIRST <> BL) AND (FIRST <> '\') AND (FIRST <> '/')
      THEN         (* HEAD *)
        BEGIN
          IF PARTAMT > 0
            THEN
              BEGIN
                OUT_HEADLINE;
                PARTOUT;
                PARTAMT := 0;
                INIT_ARRAY;
                DOUBLE_FL := FALSE;
                FL_REVERS := FALSE;
              END;
          HEADLINE := LINE;
          P := POS(LINE [LENGTH(LINE)], '123456');
          IF P = 0
            THEN HEADER := LINE
            ELSE HEADER := COPY (LINE, 1, P-1);
          FIND_SAME_LINE (CLASS, SUBCL, NUMB0, GEND0, DOUBLE_FL, FL_REVERS);
        END
      ELSE           (* TAIL *)
        BEGIN
          INC (PARTAMT);
          STYL := POS (USACH, 'sqpm*');
          IF (USACH <> BL) AND (STYL = 0) OR (POS (SECOND, ' /\v!') = 0)
            THEN
              BEGIN
                WRITELN (FNAME, ' ERROR: Wrong or shifted label in line ', 
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
  FLUSH (OUT);
  CLOSE (OUT);
  CLOSE (INP);
    END;
  FLUSH (OUT1);

  FOR J := 8 TO MAXPREP28 DO
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

{ WRITELN ('Labeled:', USECOUNT [1] : 4, ' specials');
  WRITELN ('        ', USECOUNT [2] : 4, ' colloquials');
  WRITELN ('        ', USECOUNT [3] : 4, ' indecents');
  WRITELN ('        ', USECOUNT [5] : 4, ' awkwards');}

(* Preposition statistics - for research *)
  PREPOTOTAL := 0;
  FOR J := 8 TO MAXPREP24 DO
    BEGIN
      WRITELN (OUT3, PREPO [J] : 6, BL, PREPOS [J].PRP);
      INC (PREPOTOTAL, PREPO [J]);
    END;
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
      INC (WOPREPTOTAL, CAS_WO_PREP[I]);
    END;
  WRITELN (OUT5, WOPREPTOTAL, ' COLLOCATIONS W/O PREPS');
{  WRITELN ('Ruling nouns among: ');
  FOR STG := UNRZD TO CONJD DO
    IF STAG_CNT [STG] > 0
      THEN WRITELN (BL : 4, STAG_NAME[STG] : 6, 
        ' = ', STAG_CNT [STG] : 6); }
  WRITELN ('Files SUPNOM.COD, SUPNOMxx.COD, PREPO2.LST, MOPFCAS2.LST, NNEXAMPL.TXT output');
  FLUSH (OUT3);
  FLUSH (OUT5);
END.   
