PROGRAM SINGMULT1;
  CONST
    BL = ' '; BL2 = '  ';
    DUMMY = '';
    MAXPART_N = 80;
    MAXPART_V = 40;
    NE = '… ';

    MAXT6T6 = 188;
    ASPECT_PAIRS : ARRAY [1..MAXT6T6, 1..3] OF STRING [8] =
(*01*)(('€',     '',       '1'),   (* Ž‹…‡€’œ *)           
(*02*) ('€',     '…',      '1'),   (* ‚‹…’€’œ *)            
(*03*) ('€',     'ˆ',      '1'),   (* Ž‘€’œ *)            
(*04*) ('€',     'ˆ‚€',    '0'),   (* “„…†€’œ *)           
(*05*) ('€',     'ˆ€',    '0'),   (* €—€’œ *)             
(*06*) ('€',     'ˆŒ€',    '0'),   (* €†€’œ *)             
(*07*) ('€',     '“',     '1'),   (* Ž„‚…ƒ€’œ *)         
(*08*) ('€',     'Ž‚€',    '0'),   (* ˆ‘Ž‚…„€’œ *)         
(*09*) ('€',     '“',      '1'),   (* Žƒˆ€’œ *)         
(*10*) ('€',     '›‚€',    '0'),   (* ……—ˆ’€’œ *)         
(*11*) ('€‹ˆ‚€','Žˆ',    '1'),   (* ˆ‘Ž‘€‹ˆ‚€’œ *)    
(*12*) ('€‹ˆ‚€','Ž‹ˆ',   '1'),   (* ‚›‘Š€‹ˆ‚€’œ *)       
(*13*) ('€ˆ‚€','Žˆ',   '1'),   (* ‡€„€ˆ‚€’œ *)        
(*14*) ('€‚‹ˆ‚€','Ž‚…',    '1'),   (* ‚›‡„Ž€‚‹ˆ‚€’œ *)     
(*15*) ('€‚‹ˆ‚€','Ž‚ˆ',    '1'),   (* ‚›‹€‚‹ˆ‚€’œ *)        
(*16*) ('€‚ˆ‚€','Ž‚Ÿ',   '1'),   (* ‚›€‚ˆ‚€’œ *)        
(*17*) ('€ƒ€',   'Ž†ˆ',    '1'),   (* Ž‹€ƒ€’œ *)           
(*18*) ('€ƒˆ‚€', 'Žƒ€',    '1'),   (* €‘’€ƒˆ‚€’œ‘Ÿ *)        
(*19*) ('€ƒˆ‚€', 'Žƒ“',   '1'),   (* ‚‡„€ƒˆ‚€’œ *)        
(*20*) ('€ƒˆ‚€', 'Ž“',    '1'),   (* ‡€’€ƒˆ‚€’œ *)        
(*21*) ('€„ˆ‚€','Ž„ˆ',   '1'),   (* ‚‡€„ˆ‚€’œ *)        
(*22*) ('€„›‚€', 'Ž„€',    '1'),   (* Žƒ‹€„›‚€’œ *)        
(*23*) ('€†ˆ‚€', '…‘',     '1'),   (* “‘€†ˆ‚€’œ‘Ÿ *)        
(*24*) ('€†ˆ‚€', 'Ž„ˆ',    '1'),   (* ŽŒŽ‹€†ˆ‚€’œ *)        
(*25*) ('€†ˆ‚€', 'Ž†ˆ',    '1'),   (* €‘’Ž€†ˆ‚€’œ *)      
(*26*) ('€†ˆ‚€', 'Ž‡ˆ',    '1'),   (* ‚›ŒŽ€†ˆ‚€’œ *)       
(*27*) ('€‡„›‚€','Ž‡„€',   '1'),   (* Ž€‡„›‚€’œ *)       
(*28*) ('€ˆ‚€',  'Žˆ',     '1'),   (* Ž“‘’€ˆ‚€’œ *)       
(*29*) ('€ˆ‚€',  'ŽŸ',     '1'),   (* €‘’€ˆ‚€’œ *)         
(*30*) ('€Šˆ‚€', 'Ž—ˆ',    '1'),   (* ‚‘Š€Šˆ‚€’œ *)       
(*31*) ('€‹‹ˆ‚€','Ž‹ˆ',  '1'),   (* ‚›„€‹‹ˆ‚€’œ *)      
(*32*) ('€‹‚‹ˆ‚€','Ž‹‚ˆ',  '1'),   (* ‡€Œ€‹‚‹ˆ‚€’œ *)       
(*33*) ('€‹†ˆ‚€','Ž‹†ˆ' ,  '1'),   (* Ž„€‹†ˆ‚€’œ *)         
(*34*) ('€‹ˆ‚€', 'Ž‹ˆ',    '1'),   (* ‚›Œ€‹ˆ‚€’œ *)         
(*35*) ('€‹Šˆ‚€','Ž‹Š€',   '1'),   (* €‘’€‹Šˆ‚€’œ *)       
(*36*) ('€‹Šˆ‚€','Ž‹Š“',  '1'),   (* Ž’€‹Šˆ‚€’œ *)       
(*37*) ('€‹’›‚€','Ž‹’€',   '1'),   (* ‚›€‹’›‚€’œ *)        
(*38*) ('€‹—ˆ‚€','Ž‹—€',   '1'),   (* ‡€Œ€‹—ˆ‚€’œ *)        
(*39*) ('€‹›‚€', 'Ž‹Ž',    '1'),   (* ‚›€‹›‚€’œ *)         
(*40*) ('€‹œ‡›‚€','Ž‹œ‡“','1'),   (* ‚›‘Š€‹œ‡›‚€’œ *)      
(*41*) ('€Œ‹ˆ‚€', 'ŽŒˆ',   '1'),   (* Ž‡€Š€Œ‹ˆ‚€’œ *)         
(*42*) ('€Œ›‚€', 'ŽŒ€',    '1'),   (* ‡€‹€Œ›‚€’œ *)         
(*43*) ('€Œ›‚€', 'ŽŒˆ',    '1'),   (* ‚›‹€Œ›‚€’œ *)        
(*44*) ('€ˆ‚€', 'Žˆ',    '1'),   (* Ž‡‚€ˆ‚€’œ *)        
(*45*) ('€—ˆ‚€','Ž—ˆ',   '1'),   (* ŽŠ€—ˆ‚€’œ *)         
(*46*) ('€‹ˆ‚€','Žˆ',    '1'),   (* €Š€‹ˆ‚€’œ *)        
(*47*) ('€’›‚€','Ž’€',   '1'),   (* “’€’›‚€’œ *)         
(*48*) ('€›‚€', 'Ž€',    '1'),   (* ‚›Š€›‚€’œ *)         
(*49*) ('€ƒˆ‚€','Žƒ“',  '1'),   (* Ž„Œ€ƒˆ‚€’œ *)       
(*50*) ('€ˆ‚€', 'Žˆ',    '1'),   (* ‚›ƒŽ‚€ˆ‚€’œ *)       
(*51*) ('€Œ‹ˆ‚€','ŽŒˆ',  '1'),   (* Ž’Š€Œ‹ˆ‚€’œ *)       
(*52*) ('€•ˆ‚€','Ž•“',  '1'),   (* ‚‘€•ˆ‚€’œ *)        
(*53*) ('€›‚€', 'Ž“',   '1'),   (* ˆ•‚€›‚€’œ *)       
(*54*) ('€›‚€', 'ŽŽ',    '1'),   (* €‘€›‚€’œ *)       
(*55*) ('€‘€',   'Ž‘“',   '1'),   (* Š€‘€’œ‘Ÿ *)     
(*56*) ('€‘Šˆ‚€','Ž‘Š€',   '1'),   (* ŽŽ‹€‘Šˆ‚€’œ *)     
(*57*) ('€‘Šˆ‚€','Ž‘“',   '1'),   (* ŽŽ‹€‘Šˆ‚€’œ *)     
(*58*) ('€‘›‚€', 'Ž‘€',    '1'),   (* €‡€‘›‚€’œ *)       
(*59*) ('€‘›‚€', 'Ž‘ˆ',    '1'),   (* Ž’€‘›‚€’œ *)        
(*60*) ('€’ˆ‚€','Ž’…',   '1'),   (* Ž‘Œ€’ˆ‚€’œ *)        
(*61*) ('€’›‚€', 'Ž’€',    '1'),   (* ‘Œ€’›‚€’œ *)          
(*62*) ('€’›‚€', 'Ž’“',   '1'),   (* ‘ƒ‹€’›‚€’œ *)       
(*63*) ('€’›‚€', 'Ž’ˆ',    '1'),   (* Žƒ‹€’›‚€’œ *)       
(*64*) ('€—ˆ‚€', 'Ž’ˆ',    '1'),   (* Ž‚Ž€—ˆ‚€’œ *)       
(*65*) ('€—ˆ‚€', 'Ž—ˆ',    '1'),   (* ‚›Œ€—ˆ‚€’œ *)         
(*66*) ('€˜ˆ‚€', 'Ž‘ˆ',    '1'),   (* ‘€˜ˆ‚€’œ *)         
(*67*) ('€˜ˆ‚€', 'Ž˜ˆ',    '1'),   (* ˆ‘Š€˜ˆ‚€’œ *)        
(*68*) ('€™ˆ‚€', 'Ž™ˆ',    '1'),   (* ‡€‚€™ˆ‚€’œ *)         
(*69*) ('€™ˆ‚€', 'Ž‘’ˆ',   '1'),   (* ‚›•Ž‹€™ˆ‚€’œ *)       
(*70*) ('ˆ€',  'Ž€',   '1'),   (* €‡ˆ€’œ *)          
(*71*) ('Žƒ“', 'ƒˆ€',   '0'),   (* ŽŽ“’œ *)            
(*72*) ('€',   '‚‡Ÿ',    '1'),   (* €’œ *)              
(*73*) ('‚€',    '',       '1'),   (* „€‚€’œ/‘„“‚€’œ/ˆ˜ˆ‚€’œ/€„…‚€’œ *)
(*74*) ('‚€',    '“',     '1'),   (* Ž‘’›‚€’œ *)            
(*75*) ('‚€',    '›‚€',    '0'),   (* €‡‚€’œ *)            
(*76*) ('‚€',    'Ÿ',      '1'),   (* €‚…‚€’œ *)           
(*77*) ('‚ˆ€',  'Ž‚€',   '1'),   (* Ž„‚ˆ€’œ *)          
(*78*) ('ƒ€',    '†€',     '1'),   (* €‡…ƒ€’œ‘Ÿ *)        
(*79*) ('ƒ€',    '“',     '1'),   (* „‚ˆƒ€’œ *)            
(*80*) ('ƒˆ€',  'Žƒ“',   '1'),   (* ˆ‡ƒˆ€’œ *)           
(*81*) ('ƒˆ‚€',  '“',     '1'),   (* ‚›„…ƒˆ‚€’œ *)        
(*82*) ('ƒŽŸ',  'Žƒ€',   '1'),   (* ‘ƒŽŸ’œ *)            
(*83*) ('„€',    'ˆ„€',    '0'),   (* „Ž†„€’œ‘Ÿ *)             
(*84*) ('„€',    '“',     '1'),   (* Šˆ„€’œ *)             
(*85*) ('„€',    '‘',      '1'),   (* Ž€„€’œ *)           
(*86*) ('„…',    '†€',     '0'),   (* Žˆ„…’œ *)            
(*87*) ('„…',    '†ˆ‚€',   '0'),   (* „Ž‘ˆ„…’œ *)           
(*88*) ('„…',    '“',     '1'),   (* ƒ‹Ÿ„…’œ *)            
(*89*) ('„ˆ',    '†€',     '0'),   (* Ž‘’“„ˆ’œ *)           
(*90*) ('„ˆ',    '†„€',    '0'),   (* Ž‘“„ˆ’œ *)            
(*91*) ('„ˆ',    '†ˆ‚€',   '0'),   (* Žƒ‹€„ˆ’œ *)         
(*92*) ('„ˆ€',  'Ž„€',   '1'),   (* €‡„ˆ€’œ *)          
(*93*) ('„›‚€',  '“',     '1'),   (* ‡€ƒ‹Ÿ„›‚€’œ *)        
(*94*) ('„›‚€',  '‘',      '1'),   (* ‚›Š€„›‚€’œ *)        
(*95*) ('…',     '“',     '1'),   (* ‘‚ˆ‘’…’œ *)           
(*96*) ('…',     '›‚€',    '0'),   (* Ž„ƒ‹Ÿ„…’œ *)         
(*97*) ('…‚€',   'ˆ',      '1'),   (* Ž„‹…‚€’œ *)         
(*98*) ('…‚€',   'ˆ“',    '1'),   (* ‡€‡…‚€’œ *)            
(*99*) ('…‚€',   'Ž‚›‚€',  '0'),   (* Ž‹ˆ–…‚€’œ *)         
(*100*)('…‚€',   'ž“',    '1'),   (* ‹…‚€’œ *)            
(*101*)('…‹ˆ',   'ˆ‹€',    '0'),   (* €‘‘’…‹ˆ’œ *)         
(*102*)('……',   'ˆ€',    '0'),   (* €’……’œ *)           
(*103*)('…“',  'Ž‡‚€™€','0'),   (* ‚…“’œ *)            
(*104*)('…“',  'Ž€—ˆ‚€','0'),   (* ‘‚…“’œ *)           
(*105*)('…‘',    'ˆ’€',    '0'),   (* ‚›—…‘’œ *)            
(*106*)('…‘',    'ˆ’›‚€',  '0'),   (* “—…‘’œ *)             
(*107*)('…’€',   'Ÿ™ˆ',    '1'),   (* Ž…’€’œ *)             
(*108*)('†€',    '‡ˆ',     '1'),   (* €‡ƒ“†€’œ *)         
(*109*)('†„€',   '‡„ˆ',    '1'),   (* ‡€ƒŽŒŽ†„€’œ *)       
(*110*)('†ˆ‚€',  '‡ˆ',     '1'),   (* ‘“†ˆ‚€’œ *)           
(*111*)('†ˆ„€',  'Ž†„€',   '1'),   (* Ž„†ˆ„€’œ *)           
(*112*)('†ˆ€',  'Ž†€',   '1'),   (* Ž†ˆ€’œ *)           
(*113*)('‡ˆ€',  'Ž‡…',   '1'),   (* Ž‡ˆ€’œ *)          
(*114*)('‡†€',   '•€',     '1'),   (* ˆ…‡†€’œ *)          
(*115*)('‡‹Ž†ˆ', '‘Š‹€„›‚€','0'),  (* €‡‹Ž†ˆ’œ *)          
(*116*)('‡Ž‘‹€', '‘‘›‹€',  '0'),   (* €‡Ž‘‹€’œ *)          
(*117*)('‡Ž‘’‹€','‘‘’ˆ‹€', '0'),   (* €‡Ž‘’‹€’œ *)          
(*118*)('ˆ',     '‹ˆ‚€',   '0'),   (* ‡€„€‚ˆ’œ *)           
(*119*)('ˆ',     '‹Ÿ',     '0'),   (* ‚„Ž•Ž‚ˆ’œ *)         
(*120*)('ˆ',     '“',     '1'),   (* ‘ŠŽ‹œ‡ˆ’œ *)          
(*121*)('ˆ',     '›‚€',    '0'),   (* Ž„•‚€’ˆ’œ *)         
(*122*)('ˆ',     'œ“',    '1'),   (* €‹ˆ’œ *)         
(*123*)('ˆ',     'œŸ',    '0'),   (* “‚Ž‹ˆ’œ *)         
(*124*)('ˆ',     'Ÿ',      '0'),   (* Ž‚…ˆ’œ *)          
(*125*)('ˆ€',   '“',     '1'),   (* ‚›ƒˆ€’œ *)           
(*126*)('ˆ‚€',   '“',     '1'),   (* €‘€•ˆ‚€’œ *) 
(*127*)('ˆ‚€',   'œ“',    '1'),   (* “‚ˆ‹ˆ‚€’œ *) 
(*128*)('ˆ‚€',   'Ÿ',      '1'),   (* ‚€ˆ‚€’œ *)           
(*129*)('ˆƒ€',  '‘›ƒ€',  '1'),   (* ˆƒ€’œ *)             
(*130*)('ˆ‹€',   '‹€',     '1'),   (* “‘’ˆ‹€’œ *)           
(*131*)('ˆŒ€',   '“',      '1'),   (* ‚›ˆŒ€’œ *)           
(*132*)('ˆŒ€',   'Ÿ',      '1'),   (* ŽˆŒ€’œ *)          
(*133*)('ˆ€',   'ˆ',     '1'),   (* €ŽŒˆ€’œ *)         
(*134*)('ˆ€',   '“',     '1'),   (* ˆ€’œ *)         
(*135*)('ˆ€',   'Ÿ',      '1'),   (* ‘Œˆ€’œ *)            
(*136*)('ˆ€',   'Ÿ‘',     '1'),   (* ŽŠ‹ˆ€’œ *)         
(*137*)('ˆ€',   'Ÿ“',    '1'),   (* ŽŒˆ€’œ *)           
(*138*)('ˆ€',   'Ž€',   '1'),   (* ‘Žˆ€’œ *)            
(*139*)('ˆ€',   '€',     '1'),   (* ˆˆ€’œ *)          
(*140*)('ˆ€',   '…',     '1'),   (* …‡ˆ€’œ *)          
(*141*)('ˆ’€',   '…‘',     '1'),   (* ‘—ˆ’€’œ *)            
(*142*)('Š€',    '“',     '1'),   (* ‹…‘Š€’œ *)          
(*143*)('Š€',    '’ˆ',     '1'),   (* ‚›“‘Š€’œ *)          
(*144*)('Šˆ‚€',  '“',     '1'),   (* ‚’ˆ‘Šˆ‚€’œ *)        
(*145*)('Š‹€„›‚€','‹Ž†ˆ',  '1'),   (* “Š‹€„›‚€’œ *)         
(*146*)('Š‹€‘',  'Ž‹Ž†ˆ', '1'),   (* Š‹€‘’œ *)             
(*147*)('Š“',   '–€',     '0'),   (* ‚Ž‘Š‹ˆŠ“’œ *)           
(*148*)('Š“',   '—€',     '0'),   (* ŠˆŠ“’œ *)           
(*149*)('Š“',   '›Š€',    '0'),   (* ˆ’Š“’œ *)             
(*150*)('Š€„›‚€','ŽŠ€‘', '1'),   (* ŽŠ€„›‚€’œ *)        
(*151*)('‹€',    '›‹€',    '0'),   (* Ž‘‹€’œ *)            
(*152*)('‹…‚€',  '“',     '1'),   (* Ž›„‹…‚€’œ *)             
(*153*)('‹Ž‚ˆ',  'Ž‰Œ€',  '1'),   (* ‹Ž‚ˆ’œ *)             
(*154*)('‹›ƒ€',  'Ž‹ƒ€',   '1'),   (* Ž‹›ƒ€’œ *)             
(*155*)('Œ›Š€',  'ŽŒŠ“',  '1'),   (* ‘Œ›Š€’œ *)            
(*156*)('€',    'ŽŸ',    '0'),   (* „Žƒ€’œ *)           
(*157*)('“',    '',       '0'),   (* „€€“’œ *)           
(*158*)('“',    '€',     '0'),   (* “’Ž“’œ *)           
(*159*)('“',    '’€',     '0'),   (* ˜…“’œ *)           
(*16-*)('“',    '’…',     '0'),   (* ‹…‘“’œ *)           
(*161*)('“',    '’›‚€',   '0'),   (* ‡€‚…“’œ *)          
(*162*)('“',    '›‚€',    '0'),   (* ‡€—…“’œ *)         
(*163*)('“',    '›€',    '0'),   (* ‡€‘“’œ *)         
(*164*)('“',    'Ÿ',      '0'),   (* ›“’œ *)
(*165*)('Ÿ',    '›Œ€',    '0'),   (* Ž„Ÿ’œ *)
(*166*)('Ž',     'œ“',    '1'),   (* ŠŽ‹Ž’œ *)             
(*167*)('Ž‚€',   '““',    '1'),   (* ‘Ž‚€’œ *)             
(*168*)('Ž‚›‚€', '““',    '1'),   (* ‚›‘Ž‚›‚€’œ *)             
(*169*)('Ž‚€',  '›‚€',   '0'),   (* ‚‡Ž‚€’œ *)           
(*170*)('Ž‘‹€',  '‘›‹€',   '0'),   (* ‘Ž‘‹€’œ *)            
(*171*)('Ž‘€',  '‘ˆ€',   '0'),   (* ŽŽ‘€’œ *)           
(*172*)('Ž‘’‹€', '‘’ˆ‹€',  '0'),   (* Ž„Ž‘’‹€’œ *)           
(*173*)('Ž’Š“', '’›Š€',   '0'),   (* ‚Ž’Š“’œ *)           
(*174*)('Ž•“',  '›•€',    '0'),   (* “‘Ž•“’œ *)           
(*175*)('Ž—…‘','—ˆ’€',   '0'),   (* Ž—…‘’œ *)           
(*176*)('‘ˆ',    '˜€',     '0'),   (* ‚Ž‘Š…‘ˆ’œ *)         
(*177*)('‘ˆ',    '˜ˆ‚€',   '0'),   (* ŽŠ€‘ˆ’œ *)           
(*178*)('‘Šˆ‚€', '™ˆ',     '1'),   (* Ž’€‘Šˆ‚€’œ *)       
(*179*)('‘‹ˆ',   '˜‹Ÿ',    '0'),   (* Ž€‡Œ›‘‹ˆ’œ *)       
(*180*)('‘’ˆ',   '™€',     '0'),   (* Ž‘’ˆ’œ *)           
(*181*)('‘’ˆ',   '™ˆ‚€',   '0'),   (* Ž’€‘’ˆ’œ *)         
(*182*)('’…',    '—ˆ‚€',   '0'),   (* Ž‚…’…’œ *)           
(*183*)('’ˆ',    '—€',     '0'),   (* €Œ…’ˆ’œ *)           
(*184*)('’ˆ',    '—ˆ‚€',   '0'),   (* Ž‹€’ˆ’œ *)           
(*185*)('’ˆ',    '™€',     '0'),   (* €‘›’ˆ’œ *)           
(*186*)('“',     '›‚€',    '0'),   (* ŽŒ€“’œ *)
(*187*)('šŸ',    '›Œ€',    '0'),   (* ˆ‡šŸ’œ *)             
(*188*)('œ“',   'Ÿ',      '0'));  (* ‘’…‹œ“’œ *)
    MAXT6TI = 37;
    ASPECT_PAIRS2 : ARRAY [1..MAXT6TI, 1..3] OF STRING [9] =
(*01*)(('€„ˆ’œ‘Ÿ',  '…‘’œ',    '1'), (* ‘€„ˆ’œ‘Ÿ *)
(*02*) ('€†ˆ‚€’œ‘Ÿ','…‘’œ',    '1'), (* ……‘€†ˆ‚€’œ‘Ÿ *)
(*03*) ('€Šˆ‚€’œ',  'Ž—œ',     '1'), (* ‡€‚Ž‹€Šˆ‚€’œ *)
(*04*) ('€Ž‚ˆ’œ‘Ÿ','€’œ',     '1'), (* ‘’€Ž‚ˆ’œ‘Ÿ *)
(*05*) ('€’œ',      'ˆ',       '1'), (* ‚›€‘’€’œ *)
(*06*) ('€’œ',      '’ˆ',      '1'), (* ‘€‘€’œ/‡€Ž‹‡€’œ *)
(*07*) ('€’œ‘Ÿ',    'ˆ‘œ',     '1'), (* €‡€‘’€’œ‘Ÿ *)
(*08*) ('€’œ‘Ÿ',    '’ˆ‘œ',    '1'), (* ‘€‘€’œ‘Ÿ *)
(*09*) ('€’œ',     '‘’ˆ',     '1'), (* ‚›ƒ…€’œ *)
(*10*) ('€’œ‘Ÿ',   '‘’ˆ‘œ',   '1'), (* ‚›ƒ…€’œ‘Ÿ *)
(*11*) ('ƒ€’œ',     '—œ',      '1'), (* ŽŒŽƒ€’œ/‡€‘’ˆƒ€’œ *)
(*12*) ('ƒ€’œ‘Ÿ',   '—œ‘Ÿ',    '1'), (* Ž’‘’ˆƒ€’œ‘Ÿ*)
(*13*) ('„€’œ',     '‘’ˆ',     '1'), (* ‡€…„€’œ *)
(*14*) ('„€’œ‘Ÿ',   '‘’ˆ‘œ',   '1'), (* €‡…„€’œ‘Ÿ *)
(*15*) ('…‡’ˆ',     'Ž‡ˆ’œ',   '0'), (* ˆ‚…‡’ˆ *)
(*16*) ('…‘’ˆ',     'Ž„ˆ’œ',   '0'), (* ˆ‚…‘’ˆ *)
(*17*) ('…‘’ˆ',     'Ž‘ˆ’œ',   '0'), (* ‚›…‘’ˆ *)
(*18*) ('…‘’ˆ‘œ',   'Ž„ˆ’œ‘Ÿ', '0'), (* €‡‚…‘’ˆ‘œ *)
(*19*) ('…‘’ˆ‘œ',   'Ž‘ˆ’œ‘Ÿ', '0'), (* ………‘’ˆ‘œ *)
(*20*) ('…—œ',      'ˆƒ€’œ',   '0'), (* Ž†…—œ *)
(*21*) ('…—œ',      'Ž†ˆ’œ‘Ÿ', '0'), (* ‹…—œ *)
(*22*) ('…—œ‘Ÿ',    'ˆƒ€’œ‘Ÿ', '0'), (* Ž†…—œ‘Ÿ *)
(*23*) ('‡Ž‰’ˆ',    'Ž‘•Ž„ˆ’œ','0'), (* …‚‡Ž‰’ˆ *)
(*24*) ('‡Ž‰’ˆ',    '‘•Ž„ˆ’œ', '0'), (* Žˆ‡Ž‰’ˆ *)
(*25*) ('‡Ž‰’ˆ‘œ',  '‘•Ž„ˆ’œ‘Ÿ','0'),(* €‡Ž‰’ˆ‘œ *)
(*26*) ('‰’ˆ',      '•Ž„ˆ’œ',  '0'), (* ‡€‰’ˆ *)
(*27*) ('‰’ˆ‘œ',    '•Ž„ˆ’œ‘Ÿ','0'), (* ‡€‰’ˆ‘œ *)
(*28*) ('Š€’œ',     '—œ',      '1'), (* ‚›…Š€’œ *)
(*29*) ('Š€’œ‘Ÿ',   '—œ‘Ÿ',    '1'), (* “‚‹…Š€’œ‘Ÿ *)
(*30*) ('‹Ž€’œ‘Ÿ', '‹Ž“’œ', '1'), (* ‹Ž€’œ‘Ÿ *)
(*31*) ('Ž‚ˆ’œ‘Ÿ', '’œ',      '1'), (* ‘’€Ž‚ˆ’œ‘Ÿ *)
(*32*) ('Ž‰’ˆ',     '•Ž„ˆ’œ',  '0'), (* ŽŽ‰’ˆ *)
(*33*) ('Ž‰’ˆ‘œ',   '•Ž„ˆ’œ‘Ÿ','0'), (* ŽŽ‰’ˆ‘œ *)
(*34*) ('‘’ˆ',      '’€’œ',    '0'), (* ‚›–‚…‘’ˆ *)
(*35*) ('‘’ˆ',      '•ˆ‚€’œ',  '0'), (* ‚›’Ÿ‘’ˆ *)
(*36*) ('‘’ˆ‘œ',    '’€’œ‘Ÿ',  '0'), (* ……‹…‘’ˆ‘œ *)
(*37*) ('’ˆ‘œ',     '€’œ‘Ÿ',   '0'));(* €‡Ž‹‡’ˆ‘œ *)


    MAXPREF = 40;
    AS_PRS : ARRAY [1..MAXPREF] OF STRING [4] =
('‚','‚Ž','‚‡','‚‡Ž','‚‡š',
'‚‘','‚Ž‡','‚Ž‡Ž','‚Ž‘','‚›',
'„Ž','‡€','ˆ‡','ˆ‡Ž','ˆ‡š','ˆ‘',
'€','€„','€„Ž',
'Ž','Ž','ŽŽ','Žš','Ž’','Ž’Ž',
'……','Ž','Ž„','Ž„Ž','Ž„š','ˆ','Ž',
'€‡','€‡Ž','€‡š','€‘',
'‘','‘Ž','‘š','“');

  TYPE
    STATUS = (ZERO, SUB, VERB, ADJ, ADV);
    STR2 = STRING [2];
    STR3 = STRING [3];
    STR115 = STRING [115];
    REF = ^NODE;
    NODE =
      RECORD
        KEY : STR115;
        LEFT, RIGHT : REF;
      END;

  VAR
    N_AMT, V_AMT : INTEGER; 
    I, P, L, CLASS : INTEGER;
    PAIRAMT_V, PAIRAMT_N, COUNT, NCNT : INTEGER;
    INP, OUT, OUTN, OUTV : TEXT;
    INIT, FIN : STR2;
    CURSTAT : STATUS;
    LINE, TAIL, TOKEN : STR115;
    ROOT : REF;
    BORDER, TO_REVERSE : BOOLEAN;

    NOUNS : ARRAY [1..MAXPART_N] OF
      RECORD
        LIN : STR115;
        TKN : STR115;
      END;
    VERBS : ARRAY [1..MAXPART_V] OF
      RECORD
        LIN : STR115;
        TKN : STR115;
      END;


  (* NOTE: Recursive procedures should not pass parameters by value (takes
   *       too much stack), and if the procedure receives parameters by 
   *       reference (var), it cannot be called with an expression. To 
   *       keep the current way of calling this proc, I added var to the
   *       parameter of DO_ALLOC_IN_TREE (and renamed it) and added a buffer
   *       function, see below ALLOC_IN_TREE. AFG
   *)

  PROCEDURE DO_ALLOC_IN_TREE (VAR TOKEN : STR115;
          (*=============*)VAR CURROOT : REF);
    VAR
      NEWNODE : REF;
  BEGIN
    IF CURROOT = NIL
      THEN
        BEGIN
          NEW (NEWNODE);
          WITH NEWNODE^ DO
            BEGIN
              KEY := TOKEN;
              LEFT := NIL;
              RIGHT := NIL;
            END;
          CURROOT := NEWNODE;
        END
      ELSE WITH CURROOT^ DO
        IF TOKEN <> KEY
          THEN
            IF TOKEN < KEY
              THEN DO_ALLOC_IN_TREE (TOKEN, LEFT)
              ELSE DO_ALLOC_IN_TREE (TOKEN, RIGHT);
  END;

  PROCEDURE ALLOC_IN_TREE (TOKEN : STR115;
          (*=============*)VAR CURROOT : REF);
  begin
    do_alloc_in_tree (token, curroot);
  end;

  PROCEDURE PRINT_TREE (T : REF);
          (*==========*)
  BEGIN
    IF T <> NIL
      THEN WITH T^ DO
        BEGIN
          PRINT_TREE (LEFT);
          WRITELN (OUT, KEY);
          INC (COUNT);
          IF (KEY [1] = '2') AND NOT BORDER
            THEN
              BEGIN
                NCNT := COUNT - 1;
                BORDER := TRUE;
              END;
          PRINT_TREE (RIGHT);
        END;
  END;

  PROCEDURE INIT_NOUNS;
         (*===========*)
    VAR
      I : INTEGER;
  BEGIN
    FOR I := 1 TO MAXPART_N DO
      WITH NOUNS [I] DO
        BEGIN
          LIN := DUMMY;
          TKN := DUMMY;
      END;
  END;


  PROCEDURE INIT_VERBS;
         (*===========*)
    VAR
      I : INTEGER;
  BEGIN
    FOR I := 1 TO MAXPART_V DO
      WITH VERBS [I] DO
        BEGIN
          LIN := DUMMY;
          TKN := DUMMY;
      END;
  END;


  FUNCTION ISADJ (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      ADJFIN : ARRAY [1..13] OF STRING [4] =
        ('›‰','ˆ‰','ˆ‰‘Ÿ','Ž‰','›…','ˆ…','ˆ…‘Ÿ',
        '€Ÿ','€Ÿ‘Ÿ','ŸŸ','Ž…','……','……‘Ÿ');
    VAR
      I, L, L1 : INTEGER;
      FOUND :  BOOLEAN;

  BEGIN
    L := LENGTH (TOKEN);
    FOUND := FALSE;
    I := 0;
    REPEAT
      INC (I);
      L1 := LENGTH (ADJFIN [I]);
      FOUND := (ADJFIN [I] = COPY (TOKEN, L-L1+1, L1));
    UNTIL FOUND OR (I = 13);
    ISADJ := FOUND;
  END;


  FUNCTION ISGEN (TOKEN : STR115) : BOOLEAN;
         (*=====*)
    CONST
      GENFIN : ARRAY [1..12] OF STR2 =
        ('€','Ÿ','›','ˆ','Ž‚','…‚','ƒŽ','›•','ˆ•','‰','ŽŠ','…Š');
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
    UNTIL FOUND OR (I = 12);
    ISGEN := FOUND
      AND (TOKEN <> 'Ž‘’€Ž‚Š€') AND (TOKEN <> '‹Ž‡€')
      AND (TOKEN <> '‚›‹€’›') AND (TOKEN <> '‘‹“—€ˆ')
      AND (TOKEN <> '‚‡Ž‘›') AND (TOKEN <> '‘’ˆ‹ˆ')
      AND (TOKEN <> 'ˆ‘’“Œ…’›') AND (TOKEN <> '€‘€Œ‹ˆ')
      AND (TOKEN <> 'Œ€˜“’›') AND (TOKEN <> 'Ž‹…‡ˆ')
      AND (TOKEN <> 'Žƒ€›') AND (TOKEN <> 'ˆ’…‚€‹›')
      AND (TOKEN <> '‚ˆ€') AND (TOKEN <> '€‚€')
      AND (TOKEN <> '’…•ˆŠ€') AND (TOKEN <> '“‘’€Ž‚Š€')
      AND (TOKEN <> '€‘’€') AND (TOKEN <> 'Ž’…‡›')
      AND (TOKEN <> '“‹ˆŠ€') AND (TOKEN <> '€’ˆ‘’›')
      AND (TOKEN <> '…”ŽŒ€') AND (TOKEN <> '”Ž„›')
      AND (TOKEN <> 'ƒ€ŒŽ’€') AND (TOKEN <> '†€›')
      AND (TOKEN <> 'Ž—€’ŽŠ') AND (TOKEN <> '•‹ŽœŸ')
      AND (TOKEN <> 'ˆ‡„…‹ˆŸ') AND (TOKEN <> '‡€Ž‹…‚€ˆŸ')
      AND (TOKEN <> 'Ž„“Š–ˆŸ') AND (TOKEN <> 'Žˆ‡‚…„…ˆŸ')
      AND (TOKEN <> '‘ŽŠ') AND (TOKEN <> '’ŽŠ')
      AND (TOKEN <> '^˜’€’›') AND (TOKEN <> '“Œ€ƒˆ')
      AND (TOKEN <> 'ŽŸ„›') AND (TOKEN <> 'Š€—…‘’‚€')
      AND (TOKEN <> '—…‹Ž‚…Š') AND (TOKEN <> '‹ž„ˆ')
      AND (TOKEN <> 'Œ€’…ˆ€‹›') AND (TOKEN <> '—ˆ‘‹€')
      AND (TOKEN <> 'ŒŽ–ˆˆ');
  END;


  PROCEDURE SPLIT_NOUN (TOK_IN : STR115;
          (*==========*)VAR TOK_OUT : STR115);
    VAR
      P : INTEGER;
      TOK1, TOK2 : STR115;

  BEGIN
    P := POS ('1', TOK_IN) + POS ('2', TOK_IN) + POS ('3', TOK_IN)
      + POS ('4', TOK_IN) + POS ('5', TOK_IN) + POS ('6', TOK_IN);
    IF P > 0
      THEN TOK_OUT := COPY (TOK_IN, 1, P - 1)
      ELSE TOK_OUT := TOK_IN;

    P := POS (BL, TOK_OUT);
    IF P > 0
      THEN
        BEGIN
          TOK1 := COPY (TOK_OUT, 1, P - 1);
          TOK2 := COPY (TOK_OUT, P + 1, LENGTH (TOK_OUT) - P);
          IF NOT ISADJ (TOK1) OR ISGEN (TOK2)
            THEN TOK_OUT := TOK1
            ELSE TOK_OUT := TOK2;
        END;
  END;

FUNCTION REVERSABLE_0 (NUM : INTEGER) : BOOLEAN;
       (*============*)
CONST
  REVERS0 : ARRAY [1..13] OF INTEGER =
    (2,3,6,7,9,15,16,17,18,19,20,21,22);
VAR 
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT 
    INC(I); 
    FOUND := (NUM = REVERS0[I]);
  UNTIL FOUND OR (I = 13);
  REVERSABLE_0 := FOUND;
END;

FUNCTION REVERSABLE_1 (NUM : INTEGER) : BOOLEAN;
       (*============*)
CONST
  REVERS1 : ARRAY [1..9] OF INTEGER =
    (6,7,8,10,12,17,20,24,25);
VAR 
  I : INTEGER; 
  FOUND : BOOLEAN;
BEGIN
  FOUND := FALSE;
  I := 0;
  REPEAT 
    INC(I); 
    FOUND := (NUM = REVERS1[I]);
  UNTIL FOUND OR (I = 9);
  REVERSABLE_1 := FOUND;
END;

  PROCEDURE MAKE_PAIRS_N;
          (*============*)

    CONST

{ List of SINGL-PLUR endings of the same length }
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

{ List of SINGL-PLUR endings of different lengths }
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
      I, J, K, LI, LJ : INTEGER;
      FOUND : BOOLEAN;
      TMP_LIN : STR115;
      TMP_TKN, STEM : STR115;

  BEGIN
    FOR I := 1 TO N_AMT DO
      WITH NOUNS [I] DO
        SPLIT_NOUN (LIN, TKN);

    FOR I := 1 TO N_AMT DO
      FOR J := I + 1 TO N_AMT DO
        IF NOUNS [I].TKN > NOUNS [J].TKN
          THEN
            BEGIN
              TMP_LIN := NOUNS [I].LIN;
              TMP_TKN := NOUNS [I].TKN;
              NOUNS [I].LIN := NOUNS [J].LIN;
              NOUNS [I].TKN := NOUNS [J].TKN;
              NOUNS [J].LIN := TMP_LIN;
              NOUNS [J].TKN := TMP_TKN;
            END;
    FOR I := 1 TO N_AMT DO
      FOR J := I + 1 TO N_AMT DO
        BEGIN
          FOUND := FALSE;
          LI := LENGTH (NOUNS [I].TKN);
          LJ := LENGTH (NOUNS [J].TKN);
          TO_REVERSE := FALSE;
          CASE ABS (LI - LJ) OF
            0 :
              BEGIN
                K := 0;
                REPEAT
                  INC (K);
                  TMP_TKN := COPY (NOUNS [I].TKN, 1,
                    LI - LENGTH (NUMB_PAIRS0 [K, 1])) + NUMB_PAIRS0 [K, 2];
                  FOUND := (COPY (NOUNS [I].TKN,
                    LI - LENGTH (NUMB_PAIRS0 [K, 1]) + 1,
                    LENGTH (NUMB_PAIRS0 [K, 1])) = NUMB_PAIRS0 [K, 1])
                    AND (TMP_TKN = NOUNS [J].TKN);
                UNTIL FOUND OR (K = MAX0);
                TO_REVERSE := REVERSABLE_0 (K);
              END;
            1..4 :
              BEGIN
                FOUND := (NOUNS [I].TKN = '—…‹Ž‚…Š') AND
                  (NOUNS [J].TKN = '‹ž„ˆ')
                  OR (NOUNS [I].TKN = 'ŒŽ‹Ž„Ž‰ —…‹Ž‚…Š') AND
                  (NOUNS [J].TKN = 'ŒŽ‹Ž„›… ‹ž„ˆ')
                  OR (NOUNS [I].TKN = 'ƒ‹“›… ‹ž„ˆ') AND
                  (NOUNS [J].TKN = 'ƒ‹“›‰ —…‹Ž‚…Š')
                  OR (NOUNS [I].TKN = 'ŽŸ„Ž—›‰ —…‹Ž‚…Š') AND
                  (NOUNS [J].TKN = 'ŽŸ„Ž—›… ‹ž„ˆ');
                IF NOT FOUND
                  THEN
                    BEGIN
                      K := 0;
                      REPEAT
                        INC (K);
                        TMP_TKN := COPY (NOUNS [I].TKN, 1,
                          LI - LENGTH (NUMB_PAIRS1 [K, 1])) +
                          NUMB_PAIRS1 [K, 2];
                        FOUND :=
                          (COPY (NOUNS [I].TKN,
                          LI - LENGTH (NUMB_PAIRS1 [K, 1]) + 1,
                          LENGTH (NUMB_PAIRS1 [K, 1])) = NUMB_PAIRS1 [K, 1])
                          AND (TMP_TKN = NOUNS [J].TKN)
                          AND ((K > 1) OR (NOUNS [I].TKN [LI] <> 'Š'));
                      UNTIL FOUND OR (K = MAX1);
                    END;
                FOUND := FOUND                
                  AND NOT ((NOUNS [I].TKN = '‘Ž') 
                  AND (NOUNS [J].TKN = '‘Žˆ'))
                  AND NOT ((NOUNS [I].TKN = '‘“„') 
                  AND (NOUNS [J].TKN = '‘“„œŸ'))
                  AND NOT ((COPY(NOUNS [I].TKN, 
                    LENGTH(NOUNS [I].TKN)-1, 2) = '“') 
                  AND (NOUNS [J].TKN = NOUNS [I].TKN+'œŸ'));
                TO_REVERSE := REVERSABLE_1 (K);
              END;
          END;

          STEM := COPY (NOUNS [I].LIN, 1, LENGTH (NOUNS [I].LIN) - 3);

          IF  (FOUND AND 
            (ABS (LENGTH (NOUNS [I].LIN) - LENGTH (NOUNS [J].LIN)) <= 4))
            AND NOT
            ((COPY (NOUNS [J].LIN, LENGTH (NOUNS [J].LIN) - 2, 3) = 'ˆŠˆ')
            AND (COPY (NOUNS [I].LIN, LENGTH (NOUNS [I].LIN) - 2, 3) = 'ˆŠ€')
            AND (STEM <> 'Š‹ˆ') AND (STEM <> 'Œ…’Ž„') AND (STEM <> '…‹')
            AND (STEM <> '“')  AND (STEM <> '•€€Š’…ˆ‘’'))

            OR ((NOUNS [J].LIN = '–…€Ÿ “Œ€ƒ€') AND
            (NOUNS [I].LIN = '–…›… “Œ€ƒˆ')) 
            THEN
              BEGIN
                IF TO_REVERSE
                  THEN ALLOC_IN_TREE ('1 ' + NOUNS [J].LIN + 
                    BL2 + NOUNS [I].LIN, ROOT)
                  ELSE ALLOC_IN_TREE ('1 ' + NOUNS [I].LIN + 
                    BL2 + NOUNS [J].LIN, ROOT);
                INC (PAIRAMT_N);
              END;
        END;
    N_AMT := 0;
    INIT_NOUNS;
  END;


  PROCEDURE SPLIT_VERB (TOK_IN : STR115;
          (*==========*)VAR TOK_OUT : STR115);
    VAR
      P, L : INTEGER;
      NEGAT : BOOLEAN;

  BEGIN
    NEGAT := (POS (NE, TOK_IN) > 0);
    IF NEGAT
      THEN TOK_OUT := COPY (TOK_IN, 4, LENGTH (TOK_IN) - 3)
      ELSE TOK_OUT := TOK_IN;
    P := POS (BL, TOK_IN);
    IF P > 0
      THEN TOK_OUT := COPY (TOK_OUT, 1, P - 1);
    L := LENGTH (TOK_OUT);
    IF TOK_OUT [L] IN ['1'..'6']
      THEN TOK_OUT := COPY (TOK_OUT, 1, L - 1);
  END;


  PROCEDURE MAKE_PAIRS_V;
          (*============*)

    VAR
      I, J, K, P, PI, PJ, LI, LJ : INTEGER;
      PQ : INTEGER;
      FOUND, REVERSE : BOOLEAN;
      TMP_LIN : STR115;
      TMP_TKN : STR115;
      TMPV, TMPV2 : STR115;

  BEGIN
    FOR I := 1 TO V_AMT DO
      WITH VERBS [I] DO
        SPLIT_VERB (LIN, TKN);

  (* “ŽŸ„Ž—ˆ’œ *)
    FOR I := 1 TO V_AMT DO
      FOR J := I + 1 TO V_AMT DO
        IF VERBS [I].TKN > VERBS [J].TKN
          THEN
            BEGIN
              TMP_LIN := VERBS [I].LIN;
              TMP_TKN := VERBS [I].TKN;
              VERBS [I].LIN := VERBS [J].LIN;
              VERBS [I].TKN := VERBS [J].TKN;
              VERBS [J].LIN := TMP_LIN;
              VERBS [J].TKN := TMP_TKN;
            END;

    FOR I := 1 TO V_AMT DO
      FOR J := I + 1 TO V_AMT DO
        BEGIN
          FOUND := FALSE;
          LI := LENGTH (VERBS [I].TKN);
          LJ := LENGTH (VERBS [J].TKN);

 (* Ž€ ‚ˆ„€ € '’œ', Ž €‡›… ‘“””ˆŠ‘› ……„ ˆŒ *)
          PI := POS ('’œ', VERBS [I].TKN);
          PJ := POS ('’œ', VERBS [J].TKN);
          IF (PI > 0) AND (PJ > 0) AND (LI - PI = LJ - PJ)
            THEN
              BEGIN
                K := 0;
                REPEAT
                  INC (K);
                  PQ := PI - LENGTH (ASPECT_PAIRS [K, 1]);
                  IF (COPY (VERBS [I].TKN, PQ,
                      LENGTH (ASPECT_PAIRS [K, 1])) = ASPECT_PAIRS [K, 1])
                    AND (LI - LJ = LENGTH (ASPECT_PAIRS [K, 1]) -
                      LENGTH (ASPECT_PAIRS [K, 2]))
                    THEN
                      BEGIN
                        TMPV := VERBS [I].TKN;
                        DELETE (TMPV, PQ, LENGTH (ASPECT_PAIRS [K, 1]));
                        INSERT (ASPECT_PAIRS [K, 2], TMPV, PQ);
                        FOUND := (TMPV = VERBS [J].TKN)

(* Ž’‘…‚ ‹Ž†›• ‚€ˆ€’Ž‚ *)
                          AND (TMPV <> '›’œ') AND (TMPV <> '…†€’œ')
                          AND (TMPV <> '‚…“’œ') AND (TMPV <> '‚ˆ‘“’œ') 
                          AND (TMPV <> '‚Ž‘Š…‘ˆ’œ')
                          AND (TMPV <> '‚›“’œ') AND (TMPV <> '„…‹ˆ’œ')
                          AND (TMPV <> '„Ž‘’€‚ˆ’œ') AND (TMPV <> '‡€Œ…’ˆ’œ')
                          AND (TMPV <> 'Š€’ˆ’œ') AND (TMPV <> 'ŠŽ“’œ')
                          AND (TMPV <> 'Š“ˆ’œ')
                          AND (TMPV <> '‹€‘’ˆ’œ‘Ÿ') AND (TMPV <> '‹ŽŒˆ’œ')
                          AND (TMPV <> '€‹Ž†ˆ’œ') 
                          AND (TMPV <> '‹ž“’œ')
                          AND (TMPV <> 'Ž›’œ‘Ÿ') AND (TMPV <> '€‡‚…˜€’œ')
                          AND (TMPV <> '€‘Š€’ˆ’œ') AND (TMPV <> 'Ž†„€’œ')
                          AND (TMPV <> '‘†ˆ†€’œ') AND (TMPV <> '‘†ˆ†€’œ‘Ÿ')
                          AND (TMPV <> '‘‹€“’œ') AND (TMPV <> '‘‹ŽŒˆ’œ')
                          AND (TMPV <> '‘Œ…Ÿ’œ') AND (TMPV <> '‘’ŽŸ’œ')
                          AND (TMPV <> '‘—ˆ’€’œ') AND (TMPV <> '‘š…‘’œ')
                          ;
                        REVERSE := (ASPECT_PAIRS [K, 3] = '0');
                      END
                UNTIL FOUND OR (K = MAXT6T6);
              END;

  (* Ž„ˆ ‚ˆ„ € '’œ', „“ƒŽ‰ - € '’ˆ' ˆ‹ˆ '—œ' *)
          K := 0;
          IF NOT FOUND
            THEN
              REPEAT
                INC (K);
                PQ := POS (ASPECT_PAIRS2 [K, 1], VERBS [I].TKN);
                IF (PQ > 0) AND (LI - LJ = LENGTH (ASPECT_PAIRS2 [K, 1]) -
                  LENGTH (ASPECT_PAIRS2 [K, 2]))
                  THEN
                    BEGIN
                      TMPV := VERBS [I].TKN;
                      DELETE (TMPV, PQ, LENGTH (ASPECT_PAIRS2 [K, 1]));
                      INSERT (ASPECT_PAIRS2 [K, 2], TMPV, PQ);
                      FOUND := (TMPV = VERBS [J].TKN)
                        AND (TMPV <> '‚…‡’ˆ') AND (TMPV <> '‚…‘’ˆ')
                        AND (TMPV <> '…‘’ˆ');
                      REVERSE := (ASPECT_PAIRS2 [K, 3] = '0');
                    END;
              UNTIL FOUND OR (K = MAXT6TI);

(* ‘Ž‚…˜…›‰ ‚ˆ„ Ž’‹ˆ—€…’‘Ÿ „ŽŽ‹ˆ’…‹œ›Œ …”ˆŠ‘ŽŒ *)
          IF NOT FOUND AND (LI <> LJ)
            THEN
              BEGIN
                IF LI < LJ
                  THEN
                    BEGIN
                      TMPV := VERBS [I].TKN;
                      TMPV2 := VERBS [J].TKN;
                      REVERSE := FALSE;
                    END
                  ELSE
                    BEGIN
                      TMPV := VERBS [J].TKN;
                      TMPV2 := VERBS [I].TKN;
                      REVERSE := TRUE;
                    END;
                K := 0;
                REPEAT
                  INC (K);
                  FOUND := (AS_PRS[K] + TMPV = TMPV2)
(* Ž’‘“’‘’‚“…’ ‘Ž‚…˜. ‚ˆ„ ‘ …”ˆŠ‘ŽŒ “ ‘‹…„“ž™ˆ• ƒ‹€ƒŽ‹Ž‚ *)
                    AND (TMPV <> '‚Ž‡ˆ’œ')AND (TMPV <> 'ƒ€ˆ—ˆ’œ') 
                    AND (TMPV <> '„…ƒ€’œ')  AND (TMPV <> '„‚ˆƒ€’œ‘Ÿ') 
                    AND (TMPV <> '„‚ˆ“’œ')  AND (TMPV <> '„‚ˆ“’œ‘Ÿ') 
                    AND (TMPV <> 'ˆƒ€’œ') 
                    AND (TMPV <> 'Š€€’œ') AND (TMPV <> 'Šˆ„€’œ') 
                    AND (TMPV <> 'ŠŽ—ˆ’œ') AND (TMPV <> 'ŠŽ—ˆ’œ‘Ÿ')
                    AND (TMPV <> 'Š“ˆ’œ') AND (TMPV <> '›‚€’œ')
                    AND (TMPV <> '›’œ') AND (TMPV <> '†ˆ’œ')
                    AND (TMPV <> '‡€›’œ') AND (TMPV <> '‡€‚Ž„ˆ’œ‘Ÿ') 
                    AND (TMPV <> '‡€„“Œ€’œ‘Ÿ') AND (TMPV <> '‡€„“Œ›‚€’œ‘Ÿ')
                    AND (TMPV <> 'Š€‘€’œ‘Ÿ') AND (TMPV <> 'Šˆ—€’œ')  
                    AND (TMPV <> '‹…’€’œ') 
                    AND (TMPV <> '‹…’…’œ') AND (TMPV <> '‹…—œ')
                    AND (TMPV <> 'Œ…‹œŠ“’œ') AND (TMPV <> 'Ž‘ˆ’œ') 
                    AND (TMPV <> 'Ž„“˜…‚ˆ’œ') AND (TMPV <> 'Ž„“˜…‚ˆ’œ‘Ÿ') 
                    AND (TMPV <> 'Ž„“˜…‚‹Ÿ’œ') AND (TMPV <> 'Ž„“˜…‚‹Ÿ’œ‘Ÿ')
                    AND (TMPV <> 'Ž’‚›Š“’œ') AND (TMPV <> '€‘’œ') 
                    AND (TMPV <> 'ˆ„“Œ€’œ') AND (TMPV <> 'Ž„€‚€’œ') 
                    AND (TMPV <> '›ƒ“’œ') 
                    AND (TMPV <> '“‘Š€’œ') AND (TMPV <> '“‘’ˆ’œ') 
                    AND (TMPV <> '€‡„…‹ˆ’œ') AND (TMPV <> '€‡„…‹Ÿ’œ')
                    AND (TMPV <> '…˜€’œ') AND (TMPV <> '…˜ˆ’œ') 
                    AND (TMPV <> '‘Ž‘ˆ’œ')
                    AND (TMPV <> '‘€˜ˆ‚€’œ') AND (TMPV <> '’Ž‹Š€’œ')
                    AND (TMPV <> '“ŒŽ†€’œ') AND (TMPV <> '“ŒŽ†ˆ’œ')
                    AND (TMPV <> '“’ŽŒˆ’œ') AND (TMPV <> '“’ŽŒˆ’œ‘Ÿ') 
                    AND (TMPV <> '“’ŽŒ‹Ÿ’œ') AND (TMPV <> '“’ŽŒ‹Ÿ’œ‘Ÿ') 
                    AND (TMPV <> '˜ˆ”Ž‚€’œ')
                    AND (TMPV <> 'Ÿ‚ˆ’œ‘Ÿ') AND (TMPV <> 'Ÿ‚‹Ÿ’œ‘Ÿ') 

(* ”ˆ‹œ’ - ‚ˆ„Ž‚€Ÿ €€ ’Ž‹œŠŽ ‘ „€›Œ …„‹ŽƒŽŒ *)
                    AND ((TMPV <> '…†€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '…‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '…‘…„Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ˆ’Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> 'Ž„ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Ž„ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMPV <> '‚…‡’ˆ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMPV <> '‚€ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '‚…ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‚…‘…‹ˆ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMPV <> '‚…‘…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMPV <> '‚‹…—œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‚ŽŸ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '‚Ž—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‚€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> 'ƒ€„€’œ') OR (AS_PRS[K] = '€‡'))
                   { AND ((TMPV <> 'ƒ€‘ˆ’œ') OR (AS_PRS[K] = 'Ž')) }
                    AND ((TMPV <> 'ƒ‹€„ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ƒ‹€„ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ƒ‹“˜ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> 'ƒˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ƒ“’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> 'ƒ“’œ‘Ÿ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> 'ƒŽ‚Žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ƒŽ…’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ƒ…Œ…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ƒ…’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> 'ƒ…’œ‘Ÿ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> 'ƒ…˜ˆ’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> 'ƒ“…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ƒ“‡ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ƒ“‘’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '„€‚ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '„€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '„…‰‘’‚Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '„ˆŠ’Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '„Ž‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '„ŽŽ†€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '„“Œ€’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMPV <> '„“˜ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '…•€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '†€‹…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '†€ˆ’œ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMPV <> '†„€’œ') OR (AS_PRS[K] = 'Ž„Ž'))
                    AND ((TMPV <> '‡€Ž’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡‚……’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡‚“—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡„ŽŽ‚…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡€ŠŽŒˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡€ŠŽŒˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‡€’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> 'Šˆ…’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMPV <> 'Š‹…ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'Š‹…ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŠŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŠŽ‹Ž’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> 'ŠŽ€’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMPV <> 'ŠŽŒˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'Š€‘ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ŠŽˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŠŽ˜ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> 'ŠŽ˜ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> 'Š›’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'Š“ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‹€‘Š€’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMPV <> '‹…„……’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‹…‡’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‹……’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‹…ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‹…ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‹…—ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‹…—ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '‹ˆŸ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‹ŽŒ€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '‹ŽŒ€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '‹žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Œ€‡€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'Œ€‡€’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'Œ€€’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMPV <> 'Œ€€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMPV <> 'Œ€‘‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'Œ…„‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Œ…‘’ˆ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMPV <> 'Œ…’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Œˆˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Œˆˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ŒŽ†ˆ’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> 'Œˆ’œ') OR (AS_PRS[K] = '‚Ž‡Ž'))
                    AND ((TMPV <> 'ŒŽŠ“’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'ŒŽ‹ˆ’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> 'ŒŽ‹Ž’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ŒŽ‹Ž’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŒŽ‹—€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŒŽ™ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŒŽ™ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŒŽ’€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'ŒŽ—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> 'ŒŽ—ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Œ“—ˆ’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMPV <> 'Œ—€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'Œ›’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> 'ŒŸŒ‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> 'ŒŸ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ŒŸ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '…‘’ˆ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMPV <> '€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '€•€’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMPV <> '€—Š€’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMPV <> '€—Š€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMPV <> '…—€’€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '…—œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'ˆ‹ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '‹€‚ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> '‹€‚ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> '‹€Š€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‹€Š€’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> '‹€’ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‹…‘…‚…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‹…‘’ˆ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '‹›’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‹Ž„ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> 'Ž’…’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMPV <> 'Ÿ’€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> 'Ÿ’€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '‹Ž„ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMPV <> '“ƒ€’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMPV <> '“ƒ€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMPV <> '“’€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '“’€’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '“•“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '›‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '…ƒ“‹ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMPV <> 'ˆ‘Ž‚€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '“ˆ’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMPV <> '“ƒ€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '“ƒ€’œ‘Ÿ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‘‚ˆ‘’…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘…Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘‹“˜€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‘Œ…Ÿ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‘ŒŽ’…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘Ž‘€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‘Ž‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘Ž•“’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '‘Žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘’…‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘’€„€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘’Žƒ€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘’“—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘’›„ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‘’›„ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '‘’›“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '‘“˜ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '“—ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMPV <> '’€™ˆ’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMPV <> '’……’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’…‘ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’…Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’ŽŒˆ’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> '’ŽŒˆ’œ‘Ÿ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> '’Ž’€’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMPV <> '’ŽŽˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’Ž—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '’Š€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMPV <> '’Ž—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '’€’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’€’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’…Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’…Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’…‚Ž†ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '’…ˆŽ‚€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '’…‚Ž†ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '“—ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMPV <> '”ˆ‹œ’Ž‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMPV <> '•‚€‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '•ŽŽˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '•Ž•Ž’€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMPV <> '—…‘€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '—ˆ‘’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '—ˆ’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '—ˆ’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '—“‚‘’‚Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '˜ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMPV <> '˜‹…€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMPV <> '˜’€ŒŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '˜’“Š€’“ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '˜“Œ…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '˜“’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMPV <> '™……’€’œ') OR (AS_PRS[K] = 'Ž'))
                    ;
                UNTIL FOUND OR (K = MAXPREF);
              END;

  (* „‚€ ‚ˆ„€ €‡‹ˆ—€ž’‘Ÿ ˆ ‘“””ˆŠ‘ŽŒ ˆ …”ˆŠ‘ŽŒ *)
          IF NOT FOUND
            THEN
              BEGIN
          IF (VERBS [I].TKN = 'Š“ˆ’œ') AND (VERBS [J].TKN = 'ŽŠ“€’œ')
            THEN
              BEGIN
                FOUND := TRUE;
                REVERSE := TRUE;
              END
            ELSE IF (VERBS [I].TKN = VERBS [J].TKN)
              AND (POS ('…‡€’œ', VERBS [I].TKN) > 0)
              THEN
                BEGIN
                  FOUND := TRUE;
                  REVERSE := (VERBS [I].LIN [LENGTH (VERBS [I].TKN) + 1] = '1');
                END;
              END;

  (* ‚›‚Ž„ ‚ ŽŸ„Š… '…‘Ž‚.‚ˆ„ - ‘Ž‚.‚ˆ„' Ž‘‹… Ž’‘…‚€ …„Ž“‘’ˆŒŽƒŽ *)
          IF FOUND
            AND NOT((VERBS[J].TKN = '‹“†„€’œ') AND (VERBS[I].TKN = '‹“„ˆ’œ'))
            AND NOT((VERBS[I].TKN = '€’œ') AND (VERBS[J].TKN = 'ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‚€‹Ÿ’œ‘Ÿ') AND (VERBS[I].TKN = '‚€‹ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '‚“•€’œ') AND (VERBS[J].TKN = '‚“•“’œ'))
            AND NOT((VERBS[I].TKN = '‚…ˆ’œ') AND (VERBS[J].TKN = '‚…“’œ'))
            AND NOT((VERBS[I].TKN = '‚ˆ„€’œ') AND (VERBS[J].TKN = '‚ˆ„…’œ'))
            AND NOT((VERBS[J].TKN = '‚ˆ„›‚€’œ') AND (VERBS[I].TKN = '‚ˆ„…’œ'))
            AND NOT((VERBS[I].TKN = '‚‹ˆ‚€’œ') AND (VERBS[J].TKN = '‚‹ˆŸ’œ'))
            AND NOT((VERBS[J].TKN = '‚Ž‡ˆ’œ') AND (VERBS[I].TKN = '‚…‡’ˆ'))
            AND NOT((VERBS[I].TKN = '‚Ž‘Š…‘ˆ’œ') AND (VERBS[J].TKN = '‚Ž‘Š…‘“’œ'))
            AND NOT((VERBS[I].TKN = '‚…ˆ‚€’œ') AND (VERBS[J].TKN = '‚…Ÿ’œ'))
            AND NOT((VERBS[J].TKN = '‚›Ž‘ˆ’œ') AND (VERBS[I].TKN = '‚›…‘’ˆ'))
            AND NOT((VERBS[J].TKN = '‚›…‡†€’œ') AND (VERBS[I].TKN = '‚›…‡„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‚›ŠˆŠˆ‚€’œ') AND (VERBS[I].TKN = '‚›ŠˆŠ€’œ'))
            AND NOT((VERBS[I].TKN = '‚›ˆ•€’œ') AND (VERBS[J].TKN = '‚›ˆ•“’œ'))
            AND NOT((VERBS[I].TKN = '‚›€‘’€’œ') AND (VERBS[J].TKN = '‚›€‘’ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‚›‘’“†ˆ‚€’œ') AND (VERBS[I].TKN = '‚›‘’“†€’œ'))
            AND NOT((VERBS[J].TKN = '‚›’Ÿ•ˆ‚€’œ') AND (VERBS[I].TKN = '‚›’Ÿ•€’œ'))
            AND NOT((VERBS[I].TKN = 'ƒ€‘ˆ’œ') AND (VERBS[J].TKN = 'ƒ€‘“’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ‹Ÿ„…’œ') AND (VERBS[J].TKN = 'ƒ‹Ÿ“’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒŽ‚€ˆ‚€’œ') AND (VERBS[J].TKN = 'ƒŽ‚Žˆ’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒŽ‚Žˆ’œ‘Ÿ') AND (VERBS[J].TKN = '€‡ƒŽ‚Žˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'ƒŽŸ’œ') AND (VERBS[J].TKN = 'ƒ€’œ'))
            AND NOT((VERBS[I].TKN = 'ƒŽŸ’œ') AND (VERBS[J].TKN = 'ŽƒŽŸ’œ'))
            AND NOT((VERBS[I].TKN = '„€‚€’œ') AND (VERBS[J].TKN = '„€‚ˆ’œ'))
            AND NOT((VERBS[I].TKN = '„€’œ') AND (VERBS[J].TKN = '„…’œ'))
            AND NOT((VERBS[I].TKN = '„…‚€’œ') AND (VERBS[J].TKN = '€„…‚€’œ'))
            AND NOT((VERBS[I].TKN = '„…‚€’œ') AND (VERBS[J].TKN = 'Ž„…‚€’œ'))
            AND NOT((VERBS[I].TKN = '„…ƒ€’œ') AND (VERBS[J].TKN = '„…†€’œ'))
            AND NOT((VERBS[I].TKN = '„…ƒ€’œ‘Ÿ') AND (VERBS[J].TKN = '„…†€’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '„Ž›‚€’œ‘Ÿ') AND (VERBS[I].TKN = '„Žˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '…‡†€’œ') AND (VERBS[J].TKN = '…•€’œ'))
            AND NOT((VERBS[J].TKN = '‡€‚…˜ˆ‚€’œ') AND (VERBS[I].TKN = '‡€‚…˜€’œ'))
            AND NOT((VERBS[I].TKN = '‡€„€’œ') AND (VERBS[J].TKN = '‡€„…’œ'))
            AND NOT((VERBS[I].TKN = '‡€Š€‹ˆ‚€’œ') AND (VERBS[J].TKN = '‡€Š€‹Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '‡€Š€‹ˆ‚€’œ‘Ÿ') AND (VERBS[J].TKN = '‡€Š€‹Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '‡€ˆ•€’œ') AND (VERBS[J].TKN = '‡€ˆ•“’œ'))
            AND NOT((VERBS[J].TKN = '‡€†€’œ') AND (VERBS[I].TKN = '‡€„…’œ'))
            AND NOT((VERBS[J].TKN = '‡€‘’›‚€’œ') AND (VERBS[I].TKN = '‡€‘’€’œ'))
            AND NOT((VERBS[J].TKN = '‡€“†ˆ‚€’œ') AND (VERBS[I].TKN = '‡€“†€’œ'))
            AND NOT((VERBS[I].TKN = '‡€•€†ˆ‚€’œ') AND (VERBS[J].TKN = '‡€•Ž„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‡€•‚€’›‚€’œ') AND (VERBS[I].TKN = '‡€•‚€’€’œ'))
            AND NOT((VERBS[I].TKN = '‡€•‹Ž€’œ') AND (VERBS[J].TKN = '‡€•‹Ž“’œ'))
            AND NOT((VERBS[I].TKN = 'Š€‘€’œ‘Ÿ') AND (VERBS[J].TKN = 'ˆŠŽ‘“’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Š€’€’œ‘Ÿ') AND (VERBS[J].TKN = 'Š€’ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Š“ˆ’œ') AND (VERBS[J].TKN = 'Š““’œ'))
            AND NOT((VERBS[I].TKN = '‹…’€’œ') AND (VERBS[J].TKN = '‹…’…’œ'))
            AND NOT((VERBS[I].TKN = 'Œ“—€’œ‘Ÿ') AND (VERBS[J].TKN = 'Œ“—ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '€‚Ÿ‡€’œ') AND (VERBS[J].TKN = '€‚Ÿ‡“’œ'))
            AND NOT((VERBS[I].TKN = '€Š€‹ˆ‚€’œ‘Ÿ') AND (VERBS[J].TKN = '€Š€‹Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '€Œ…˜€’œ') AND (VERBS[I].TKN = '€Œ…‘ˆ’œ'))
            AND NOT((VERBS[I].TKN = '€—…Š€’œ') AND (VERBS[J].TKN = '€—…’ˆ’œ'))
            AND NOT((VERBS[I].TKN = '… ‚ˆ„€’œ') AND (VERBS[J].TKN = '… ‚ˆ„…’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‘ˆ’œ') AND (VERBS[I].TKN = '…‘’ˆ'))
            AND NOT((VERBS[I].TKN = 'Ž‹ˆ‡€’œ') AND (VERBS[J].TKN = 'Ž‹ˆ‡“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„€ˆ‚€’œ') AND (VERBS[J].TKN = 'Ž„€Ÿ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹€…‚€’œ') AND (VERBS[J].TKN = 'Ž‘‹€ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹€…‚€’œ') AND (VERBS[J].TKN = 'Ž‘‹€“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹€…’œ') AND (VERBS[J].TKN = 'Ž‘‹€ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹…ˆ’œ') AND (VERBS[J].TKN = 'Ž‘‹…“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘Œ›‘‹ˆ‚€’œ') AND (VERBS[J].TKN = 'Ž‘Œ›‘‹Ÿ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘Œ›‘‹ˆ‚€’œ‘Ÿ') AND (VERBS[J].TKN = 'Ž‘Œ›‘‹Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Ž’‚…ƒ€’œ') AND (VERBS[J].TKN = 'Ž’‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž’‚…’…’œ') AND (VERBS[I].TKN = 'Ž’‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž’„…‹›‚€’œ') AND (VERBS[I].TKN = 'Ž’„…‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž’Šˆ„€’œ') AND (VERBS[J].TKN = 'Ž’Šˆ“’œ'))
            AND NOT((VERBS[I].TKN = '……‘€†ˆ‚€’œ') AND (VERBS[J].TKN = '……‘…‘’œ'))
            AND NOT((VERBS[I].TKN = 'Ž…ƒ€’œ') AND (VERBS[J].TKN = 'Ž…†€’œ'))
            AND NOT((VERBS[J].TKN = 'Ž…†€’œ') AND (VERBS[I].TKN = 'Ž…„ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž›‚€’œ') AND (VERBS[J].TKN = 'Ž›’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚€‹Ÿ’œ') AND (VERBS[I].TKN = 'Ž‚€‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‚…ˆ’œ') AND (VERBS[J].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[I].TKN = 'Žƒ€‘ˆ’œ') AND (VERBS[J].TKN = 'Žƒ€‘“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‹‡€’œ') AND (VERBS[I].TKN = '‡€Ž‹‡€’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‹‡€’œ') AND (VERBS[I].TKN = '‡€Ž‹‡’ˆ'))
            AND NOT((VERBS[I].TKN = 'Ž‹‡€’œ') AND (VERBS[J].TKN = 'ŽŽ‹‡€’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‹‡€’œ') AND (VERBS[J].TKN = 'Ž‹‡’ˆ'))
            AND NOT((VERBS[I].TKN = 'Ž‚…ˆ’œ') AND (VERBS[J].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚…Ÿ’œ') AND (VERBS[I].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„‚…ƒ€’œ') AND (VERBS[J].TKN = 'Ž„‚…“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„‚…ƒ€’œ‘Ÿ') AND (VERBS[J].TKN = 'Ž„‚…“’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Ž‘’ˆ€’œ') AND (VERBS[J].TKN = 'Ž‘’ˆ“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‘’“†ˆ‚€’œ') AND (VERBS[I].TKN = 'Ž‘’“†€’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‘’“†ˆ‚€’œ‘Ÿ') AND (VERBS[I].TKN = 'Ž‘’“†€’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '€‡‚€‹ˆ‚€’œ') AND (VERBS[J].TKN = '€‡‚€‹Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '€‡‚…‚€’œ‘Ÿ') AND (VERBS[J].TKN = '€‡‚…Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '…‡€’œ') AND (VERBS[I].TKN = '‡€…‡€’œ'))
            AND NOT((VERBS[J].TKN = '“‹ˆ’œ') AND (VERBS[I].TKN = '‚›“‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = '‘€‘›‚€’œ') AND (VERBS[J].TKN = '‘Ž‘€’œ'))
            AND NOT((VERBS[I].TKN = '‘‚…ˆ’œ') AND (VERBS[J].TKN = '‘‚…“’œ'))
            AND NOT((VERBS[J].TKN = '‘ˆ„…’œ') AND (VERBS[I].TKN = 'Ž‘ˆ„…’œ'))
            AND NOT((VERBS[I].TKN = '‘‚ˆ‘’€’œ') AND (VERBS[J].TKN = '‘‚ˆ‘’…’œ'))
            AND NOT((VERBS[J].TKN = '‘‹€’œ') AND (VERBS[I].TKN = '‚›‘‹€’œ'))
            AND NOT((VERBS[I].TKN = '‘‹…ˆ’œ') AND (VERBS[J].TKN = '‘‹…“’œ'))
            AND NOT((VERBS[J].TKN = '‘Ž‡€‚€’œ') AND (VERBS[I].TKN = 'Ž‘Ž‡€‚€’œ'))
            AND NOT((VERBS[J].TKN = '‘‘“†ˆ‚€’œ') AND (VERBS[I].TKN = '‘‘“†€’œ'))
            AND NOT((VERBS[J].TKN = '‘“†ˆ‚€’œ') AND (VERBS[I].TKN = '‘“†€’œ'))
            AND NOT((VERBS[J].TKN = '‘“†ˆ‚€’œ‘Ÿ') AND (VERBS[I].TKN = '‘“†€’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '‘’Žˆ’œ') AND (VERBS[J].TKN = '‘’Ž“’œ'))
            AND NOT((VERBS[J].TKN = '‘’›“’œ') AND (VERBS[I].TKN = '‡€‘’›“’œ'))
            AND NOT((VERBS[J].TKN = '“…†€’œ') AND (VERBS[I].TKN = '“…„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '“’Ž€’œ') AND (VERBS[I].TKN = '“’Ž“’œ'))
            AND NOT((VERBS[J].TKN = '“’Ž€’œ') AND (VERBS[I].TKN = '“’Žˆ’œ'))
            AND NOT((VERBS[I].TKN = '“–…ˆ‚€’œ') AND (VERBS[J].TKN = '“–…Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '•Ž„ˆ’œ') AND (VERBS[J].TKN = 'ˆ•Ž„ˆ’œ'))
            AND NOT((VERBS[I].TKN = '•ˆ…’œ') AND (VERBS[J].TKN = '•ˆ“’œ'))
            AND NOT((VERBS[I].TKN = '—…Š€’œ') AND (VERBS[J].TKN = '—…’ˆ’œ'))
            THEN
              BEGIN
                ALLOC_IN_TREE ('2 '+ 'Ž‹…’œ1' + BL2 + '‡€Ž‹…’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚€‹ˆ’œ2' + BL2 + '‘‚€‹ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚€‹ˆ’œ3' + BL2 + '‘‚€‹ˆ’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚€‹ˆ’œ4' + BL2 + '‘‚€‹ˆ’œ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚…‡’ˆ1' + BL2 + 'Ž‚…‡’ˆ', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚…˜€’œ1' + BL2 + 'Ž‚…‘ˆ’œ', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚…˜€’œ2' + BL2 + '‚‡‚…‘ˆ’œ', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚Š‹€„›‚€’œ2' + BL2 + '‚‹Ž†ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚…˜€’œ3' + BL2 + 'Ž‚…‘ˆ’œ', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚Ž„ˆ’œ1' + BL2 + 'Ž‚…‘’ˆ', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚Ž„ˆ’œ2' + BL2 + 'Ž‚…‘’ˆ', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚…‡€’œ2' + BL2 + '‚…‡€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚‘›€’œ2' + BL2 + '‚‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‚Ž„ˆ’œ1' + BL2 + '‚›‚…‘’ˆ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‚Ž„ˆ’œ2' + BL2 + '‚›‚…‘’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‚Ž„ˆ’œ3' + BL2 + '‚›‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‚Ž„ˆ’œ4' + BL2 + '‚›‚…‘’ˆ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‚Ž„ˆ’œ5' + BL2 + '‚›‚…‘’ˆ5', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›†ˆŒ€’œ3' + BL2 + '‚›†€’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›“‘Š€’œ1' + BL2 + '‚›“‘’ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›“‘Š€’œ2' + BL2 + '‚›“‘’ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›“‘Š€’œ3' + BL2 + '‚›“‘’ˆ’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›“‘Š€’œ4' + BL2 + '‚›“‘’ˆ’œ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‘›€’œ2' + BL2 + '‚›‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›‘›€’œ‘Ÿ2' + BL2 + '‚›‘›€’œ‘Ÿ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›•Ž„ˆ’œ1' + BL2 + '‚›‰’ˆ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›•Ž„ˆ’œ2' + BL2 + '‚›‰’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›•Ž„ˆ’œ3' + BL2 + '‚›‰’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‚›•Ž„ˆ’œ4' + BL2 + '‚›‰’ˆ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '„Ž‘›€’œ2' + BL2 + '„Ž‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€‚Ž„ˆ’œ1' + BL2 + '‡€‚…‘’ˆ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€‚Ž„ˆ’œ2' + BL2 + '‡€‚…‘’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€‚Ž„ˆ’œ3' + BL2 + '‡€‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€Š…‹Ÿ’œ1' + BL2 + '‡€Š…ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€Š…‹Ÿ’œ2' + BL2 + '‡€Š…ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€Š…‹Ÿ’œ3' + BL2 + '‡€Š…ˆ’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€Š…‹Ÿ’œ4' + BL2 + '‡€Š…ˆ’œ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€“‘Š€’œ1' + BL2 + '‡€“‘’ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€“‘Š€’œ2' + BL2 + '‡€“‘’ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€“‘Š€’œ3' + BL2 + '‡€“‘’ˆ’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€“‘Š€’œ4' + BL2 + '‡€“‘’ˆ’œ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '‡€‘›€’œ2' + BL2 + '‡€‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ˆ„’ˆ1' + BL2 + 'Ž‰’ˆ', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ˆ„’ˆ3' + BL2 + 'Ž‰’ˆ', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž‘›€’œ2' + BL2 + 'Ž‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž’‘›€’œ2' + BL2 + 'Ž’‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '€„€’œ' + BL2 + '“€‘’œ', ROOT);
                ALLOC_IN_TREE ('2 '+ '……‘›€’œ2' + BL2 + '……‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '……‚Ž„ˆ’œ3' + BL2 + '……‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„‚Ž„ˆ’œ2' + BL2 + 'Ž„‚…‘’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„‚Ž„ˆ’œ3' + BL2 + 'Ž„‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„‚Ž„ˆ’œ4' + BL2 + 'Ž„‚…‘’ˆ4', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„‚Ž„ˆ’œ5' + BL2 + 'Ž„‚…‘’ˆ4', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„‘›€’œ2' + BL2 + 'Ž„‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„•Ž„ˆ’œ1' + BL2 + 'Ž„Ž‰’ˆ1', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„•Ž„ˆ’œ2' + BL2 + 'Ž„Ž‰’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž„•Ž„ˆ’œ3' + BL2 + 'Ž„Ž‰’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ŽŠ€‡›‚€’œ1' + BL2 + 'ŽŠ€‡€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ŽŠ€‡›‚€’œ2' + BL2 + 'ŽŠ€‡€’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ŽŠ€‡›‚€’œ2' + BL2 + 'ŽŠ€‡€’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ŽŠ“€’œ1' + BL2 + 'Š“ˆ’œ', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž‹‡€’œ' + BL2 + 'ŽŽ‹‡’ˆ', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž‘…’œ2' + BL2 + 'Ž‘…‚€’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž‘›€’œ2' + BL2 + 'Ž‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '…„‘’€‚‹Ÿ’œ3' + BL2 + '…„‘’€‚ˆ’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ˆ‚Ž„ˆ’œ1' + BL2 + 'ˆ‚…‘’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ˆ‚Ž„ˆ’œ3' + BL2 + 'ˆ‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ 'ˆˆŒ€’œ4' + BL2 + 'ˆŸ’œ4', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Ž†ˆ‚€’œ2' + BL2 + 'Ž†ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ 'Žˆ‡‚Ž„ˆ’œ3' + BL2 + 'Žˆ‡‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡ˆ‚€’œ1' + BL2 + '€‡ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡ˆ€’œ1' + BL2 + '€‡Ž€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡ˆ€’œ3' + BL2 + '€‡Ž€’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡‚Ž„ˆ’œ1' + BL2 + '€‡‚…‘’ˆ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡‚Ž„ˆ’œ6' + BL2 + '€‡‚…‘’ˆ6', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡‚Ž„ˆ’œ2' + BL2 + '€‡‚…‘’ˆ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡‚Ž„ˆ’œ3' + BL2 + '€‡‚…‘’ˆ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‡„…‹Ÿ’œ2' + BL2 + '€‡„…‹ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‘Ž‹€ƒ€’œ2' + BL2 + '€‘Ž‹Ž†ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‘‘›€’œ2' + BL2 + '€‘‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '€‘‘›€’œ‘Ÿ2' + BL2 + '€‘‘›€’œ‘Ÿ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‘€†€’œ1' + BL2 + 'Ž‘€„ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‘€†€’œ2' + BL2 + 'Ž‘€„ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '‘€†€’œ3' + BL2 + 'Ž‘€„ˆ’œ3', ROOT);
                ALLOC_IN_TREE ('2 '+ '‘€†€’œ4' + BL2 + 'Ž‘€„ˆ’œ4', ROOT);
                ALLOC_IN_TREE ('2 '+ '‘‘›€’œ2' + BL2 + '‘‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '‘Ž‡€‚€’œ' + BL2 + 'Ž‘Ž‡€’œ', ROOT);
                ALLOC_IN_TREE ('2 '+ '•‚€’€’œ1' + BL2 + '‘•‚€’ˆ’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '’“˜ˆ’œ2' + BL2 + 'Ž’“˜ˆ’œ2', ROOT);
                ALLOC_IN_TREE ('2 '+ '“‘›€’œ2' + BL2 + '“‘›€’œ1', ROOT);
                ALLOC_IN_TREE ('2 '+ '“—ˆ’œ2' + BL2 + '€“—ˆ’œ', ROOT);


                IF REVERSE
                  THEN ALLOC_IN_TREE ('2 '+ VERBS[J].LIN + BL2 + VERBS[I].LIN,
                    ROOT)
                  ELSE ALLOC_IN_TREE ('2 '+ VERBS[I].LIN + BL2 + VERBS[J].LIN,
                    ROOT);
                INC (PAIRAMT_V);
              END;
        END;

    V_AMT := 0;
    INIT_VERBS;
  END;


BEGIN      (* MAIN *)

  PAIRAMT_N := 0;
  PAIRAMT_V := 0;
  COUNT := 0;
  N_AMT := 0;
  V_AMT := 0;
  INIT_NOUNS;
  INIT_VERBS;
  ROOT := NIL;

  ASSIGN (INP, 'DERIVAT.TXT');
  RESET (INP);
  CURSTAT := ZERO;

  ASSIGN (OUT, 'PAIRS.DAT');
  REWRITE (OUT);


  REPEAT
    READLN (INP, LINE);
    INIT := COPY (LINE, 1, 2);

    IF (INIT = 'ye') OR (INIT = 'no')
       THEN CURSTAT := ZERO
    ELSE IF (CURSTAT = ZERO) AND (INIT = 'Su')
      THEN CURSTAT := SUB
    ELSE IF (CURSTAT = SUB) AND (INIT = 'Ve')
      THEN
        BEGIN
          MAKE_PAIRS_N;
          CURSTAT := VERB;
        END
    ELSE IF (CURSTAT = SUB) AND (INIT = 'Aj')
      THEN           
        BEGIN
          MAKE_PAIRS_N;
          CURSTAT := ADJ;
        END
    ELSE IF (CURSTAT = VERB) AND (INIT = 'Aj')
      THEN
        BEGIN
          MAKE_PAIRS_V;
          CURSTAT := ADJ;
        END
    ELSE IF (CURSTAT = ADJ) AND (INIT = 'Av')
      THEN CURSTAT := ADV
   { ELSE IF (CURSTAT = ADV) AND 
      ((INIT = 'ye') OR (INIT = 'no'))
      THEN CURSTAT := ZERO };

    TAIL := COPY (LINE, 4, LENGTH (LINE) - 3);

    CASE CURSTAT OF
      SUB :
        BEGIN
          INC (N_AMT);
          NOUNS [N_AMT].LIN := TAIL;
        END;
      VERB :
        BEGIN
          INC (V_AMT);
          VERBS [V_AMT].LIN := TAIL;
        END;
      ELSE ;
    END;
  UNTIL EOF (INP);
  CLOSE (INP);

  BORDER := FALSE;
  PRINT_TREE (ROOT);
  FLUSH (OUT);
  CLOSE (OUT);

 (* Dividing pairs to nouns and verbs *)
 
  ASSIGN (INP, 'PAIRS.DAT');
  RESET (INP);

  ASSIGN (OUTN, 'PAIRS1.DAT');
  REWRITE (OUTN);

  ASSIGN (OUTV, 'PAIRV.DAT');
  REWRITE (OUTV);

  READLN (INP, LINE);
  WHILE (COPY(LINE, 1, 2) = '1 ') DO
    BEGIN
      WRITELN (OUTN, LINE);
      READLN (INP, LINE);
    END;
  FLUSH (OUTN);
  CLOSE (OUTN);

  WHILE {(COPY(LINE, 1, 2) = '2 ') AND} NOT EOF(INP) DO
    BEGIN
      WRITELN (OUTV, LINE);
      READLN (INP, LINE);
    END;
  WRITELN (OUTV, LINE);
  
  FLUSH (OUTV); 
  CLOSE (OUTV);

  WRITELN ('Files PAIRS1.DAT and PAIRV.DAT output');
  WRITELN (NCNT : 6 , ' noun pairs in PAIRS1.DAT');
  WRITELN ((COUNT - NCNT) : 6 , ' verb pairs in PAIRV.DAT');
END.
