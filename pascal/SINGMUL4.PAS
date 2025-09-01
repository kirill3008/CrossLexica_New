PROGRAM SINGMUL4;

  CONST
    BL = ' ';
    BL2 = '  ';
    DUMMY = '';
    MAX = 740;

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
(*25*) ('‡Ž‰’ˆ‘œ', '‘•Ž„ˆ’œ‘Ÿ','0'), (* €‡Ž‰’ˆ‘œ *)
(*26*) ('‰’ˆ',      '•Ž„ˆ’œ',  '0'), (* ‡€‰’ˆ *)
(*27*) ('‰’ˆ‘œ',    '•Ž„ˆ’œ‘Ÿ','0'), (* ‡€‰’ˆ‘œ *)
(*28*) ('Š€’œ',     '—œ',      '1'), (* ‚›…Š€’œ *)
(*29*) ('Š€’œ‘Ÿ',   '—œ‘Ÿ',    '1'), (* “‚‹…Š€’œ‘Ÿ *)
(*30*) ('‹Ž€’œ‘Ÿ', '‹Ž“’œ', '1'), (* ‹Ž€’œ‘Ÿ *)
(*31*) ('Ž‚ˆ’œ‘Ÿ', '’œ',      '1'), (* ‘’€Ž‚ˆ’œ‘Ÿ *)
(*32*) ('Ž‰’ˆ',     '•Ž„ˆ’œ',  '0'), (* ŽŽ‰’ˆ *)
(*33*) ('Ž‰’ˆ‘œ',   '•Ž„ˆ’œ‘Ÿ','0'), (* ŽŽ‰’ˆ‘œ *)
(*34*) ('‘’ˆ',      '’€’œ',    '0'), (* Ž…‘’ˆ *)
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
    STR3 = STRING [3];
    STR23 = STRING [23];
    STR47 = STRING [47];
    REF = ^NODE;
    NODE =
      RECORD
        KEY : STR47;
        SOURCE : INTEGER;
        LEFT, RIGHT : REF;
      END;

  VAR
    INP, OUT, OUT1 : TEXT;
    LINE, VERB : STRING [47];
    FNAME, NUMSTR : STRING [12];
    J, P, V_AMT, L, I, K : INTEGER;
    VERBS : ARRAY [1..MAX] OF
      RECORD
        CAS : STR3;
        TKN : STR23;
      END;
    ROOT : REF;
    AMTT6 : ARRAY [1..MAXT6T6] OF INTEGER;
    AMTTI : ARRAY [1..MAXT6TI] OF INTEGER;
    AMTPR : ARRAY [1..MAXPREF] OF INTEGER;
    CNT1, CNT2, CNT3 : INTEGER;
    COUNT, BIGCNT, BIGCNT1, BIGCNT2, BIGCNT3 : LONGINT;

  PROCEDURE ALLOC_IN_TREE (TOKEN : STR47;
          (*=============*)FROM : INTEGER;
                           VAR CURROOT : REF);
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
              SOURCE := FROM;
              LEFT := NIL;
              RIGHT := NIL;
            END;
          CURROOT := NEWNODE;
        END
      ELSE WITH CURROOT^ DO
        IF TOKEN <> KEY
          THEN
            IF TOKEN < KEY
              THEN ALLOC_IN_TREE (TOKEN, FROM, LEFT)
              ELSE ALLOC_IN_TREE (TOKEN, FROM, RIGHT);
  END;


  PROCEDURE PRINT_TREE (T : REF);
          (*==========*)
  BEGIN
    IF T <> NIL
      THEN WITH T^ DO
        BEGIN
          PRINT_TREE (LEFT);
          WRITELN (OUT, '2 ', KEY);
          INC (COUNT);
          CASE SOURCE DIV {128}180 OF
            1 : BEGIN
                 INC (CNT1);
                 INC (AMTT6 [SOURCE MOD {128}180]);
                END;
            2 : BEGIN
                 INC (CNT2);
                 INC (AMTTI [SOURCE MOD {128}180]);
                END;
            3 : BEGIN
                 INC (CNT3);
                 INC (AMTPR [SOURCE MOD {128}180]);
                END;
          END;
          PRINT_TREE (RIGHT);
        END;
  END;


  PROCEDURE INIT_GROUP;
          (*==========*)
    VAR
      I : INTEGER;
  BEGIN
    FOR I := 1 TO MAX DO
      WITH VERBS [I] DO
        BEGIN
          TKN := DUMMY;
          CAS := DUMMY;
        END;
    V_AMT := 0;
  END;


  PROCEDURE MAKE_AND_OUT_GROUP;
          (*==================*)

    VAR
      I, J, K, PI, PJ, LI, LJ, FROM : INTEGER;
      FOUND, REVERSE : BOOLEAN;
      TMP_CAS : STR3;
      TMP_TKN, TMP_V, TMP_V2 : STR23;
      PQ : INTEGER;
      FSIX : STRING [6];

  BEGIN

  (* “ŽŸ„Ž—ˆ’œ *)
    FOR I := 1 TO V_AMT DO
      FOR J := I + 1 TO V_AMT DO
        IF VERBS [I].TKN > VERBS [J].TKN
          THEN
            BEGIN
              TMP_CAS := VERBS [I].CAS;
              TMP_TKN := VERBS [I].TKN;
              VERBS [I].CAS := VERBS [J].CAS;
              VERBS [I].TKN := VERBS [J].TKN;
              VERBS [J].CAS := TMP_CAS;
              VERBS [J].TKN := TMP_TKN;
            END;

    FOR I := 1 TO V_AMT DO
      FOR J := I + 1 TO V_AMT DO
        BEGIN
          FOUND := FALSE;
          FROM := 0;
          LI := LENGTH (VERBS [I].TKN);
          LJ := LENGTH (VERBS [J].TKN);

 (* Ž€ ‚ˆ„€ € '’œ', Ž ‘ €‡›Œˆ ‘“””ˆŠ‘€Œˆ ……„ *)
          PI := POS ('’œ', VERBS [I].TKN);
          PJ := POS ('’œ', VERBS [J].TKN);

          IF (PI > 0) AND (PJ > 0) AND (LI - PI = LJ - PJ)
            AND (VERBS [I].TKN <> VERBS [J].TKN)
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
                        TMP_V := VERBS [I].TKN;
                        DELETE (TMP_V, PQ, LENGTH (ASPECT_PAIRS [K, 1]));
                        INSERT (ASPECT_PAIRS [K, 2], TMP_V, PQ);
(* Ž‘Ž‚Ž… “‘‹Ž‚ˆ… „‹Ÿ €› *)
                        FOUND := (TMP_V = VERBS [J].TKN)
                         { AND (VERBS [I].CAS = VERBS [J].CAS) }

{=========================================IN====}
(* Ž’‘…‚ ‹Ž†›• ‚€ˆ€’Ž‚ *)
                          AND (TMP_V <> '…†€’œ')  
                          AND (TMP_V <> '‚ŽŽ—€’œ') AND (TMP_V <> '‚Ž‘Š…‘ˆ’œ') 
                          AND (TMP_V <> '‚›Œ…˜€’œ') AND (TMP_V <> '‚›‹ŽŒˆ’œ')
                          AND (TMP_V <> '‡€‹ŽŒˆ’œ') AND (TMP_V <> '‡€Š“˜€’œ')
                          AND (TMP_V <> '‡€Œ…˜€’œ') AND (TMP_V <> '…‡†€’œ')
                          AND (TMP_V <> '‚…’…’œ') AND (TMP_V <> '‚ˆ‘“’œ')
                          AND (TMP_V <> '„…‹ˆ’œ') AND (TMP_V <> '„…‹ˆ’œ‘Ÿ') 
                          AND (TMP_V <> '„Ž‘’€‚ˆ’œ') AND (TMP_V <> '‡€Œ…’ˆ’œ')
                          AND (TMP_V <> 'Š€’ˆ’œ') 
                          AND (TMP_V <> 'ŠŽ“’œ') AND (TMP_V <> 'Š“ˆ’œ')
                          AND (TMP_V <> '‹€‘’ˆ’œ‘Ÿ')
                          AND (TMP_V <> '€‹Ž†ˆ’œ') AND (TMP_V <> '€Œ…’ˆ’œ') 
                          AND (TMP_V <> '‹ž“’œ')  AND (TMP_V <> 'Ž‹ŽŒˆ’œ')
                          AND (TMP_V <> 'Ž›’œ‘Ÿ') AND (TMP_V <> '€‡‚…˜€’œ')
                          AND (TMP_V <> '€‘Š€’ˆ’œ') AND (TMP_V <> 'Ž†„€’œ')
                          AND (TMP_V <> '‘†ˆ†€’œ') AND (TMP_V <> '‘†ˆ†€’œ‘Ÿ')
                          AND (TMP_V <> '‘‹€“’œ') AND (TMP_V <> '‘‹ŽŒˆ’œ')
                          AND (TMP_V <> '‘Œ…Ÿ’œ') AND (TMP_V <> '‘’ŽŸ’œ')
                          AND (TMP_V <> '‘—ˆ’€’œ') {AND (TMP_V <> '‘š…‘’œ')}
                          AND (TMP_V <> '“’Žˆ’œ')
                          ;
                        REVERSE := (ASPECT_PAIRS [K, 3] = '0');
                      END
                UNTIL FOUND OR (K = MAXT6T6);
              END;
          IF FOUND AND (FROM = 0)
            THEN FROM := {128}180 + K;

(* Ž„ˆ ‚ˆ„ € '’œ', „“ƒŽ‰ - € '’ˆ' ˆ‹ˆ '—œ' *)
          K := 0;
          IF NOT FOUND
            THEN
              REPEAT
                INC (K);
                PQ := POS (ASPECT_PAIRS2 [K, 1], VERBS [I].TKN);
                IF (PQ > 0)  AND (VERBS [I].TKN <> VERBS [J].TKN)
                  AND (PQ + LENGTH (ASPECT_PAIRS2 [K, 1]) - 1 = LI)
                  AND (LI - LJ = LENGTH (ASPECT_PAIRS2 [K, 1]) -
                  LENGTH (ASPECT_PAIRS2 [K, 2]))
                  THEN
                    BEGIN
                      TMP_V := VERBS [I].TKN;
                      DELETE (TMP_V, PQ, LENGTH (ASPECT_PAIRS2 [K, 1]));
                      INSERT (ASPECT_PAIRS2 [K, 2], TMP_V, PQ);
                      FSIX := COPY (TMP_V, 1, 6);
                      FOUND := (TMP_V = VERBS [J].TKN)
                        {AND (VERBS [I].CAS = VERBS [J].CAS)}
                        AND (FSIX <> '‚Ž„ˆ’œ') AND (FSIX <> '‚Ž‡ˆ’œ')
                        AND (FSIX <> 'Ž‘ˆ’œ')
                        ;
                      REVERSE := (ASPECT_PAIRS2 [K, 3] = '0');
                    END;
              UNTIL FOUND OR (K = MAXT6TI);
          IF FOUND AND (FROM = 0)
            THEN FROM := {128}180 + K;

(* „‚€ ‚ˆ„€ €‡‹ˆ—€ž’‘Ÿ ’Ž‹œŠŽ …”ˆŠ‘ŽŒ *)
          IF NOT FOUND AND (LI <> LJ)
            THEN
              BEGIN
                IF LI < LJ
                  THEN
                    BEGIN
                      TMP_V := VERBS [I].TKN;
                      TMP_V2 := VERBS [J].TKN;
                      REVERSE := FALSE;
                    END
                  ELSE
                    BEGIN
                      TMP_V := VERBS [J].TKN;
                      TMP_V2 := VERBS [I].TKN;
                      REVERSE := TRUE;
                    END;
                
                K := 0;
                REPEAT
                  INC (K);

(* Ž‘Ž‚›… “‘‹Ž‚ˆŸ €•Ž†„…ˆŸ ‚ˆ„Ž‚Ž‰ €› *)
                  FOUND := (AS_PRS[K] + TMP_V = TMP_V2)
                   { AND (VERBS [I].CAS = VERBS [J].CAS)}

(* ‡€…’ € ˆŒˆ’€–ˆž …‘Ž‚…˜…ŽƒŽ ‚ˆ„€ ‘Ž‚…˜…›Œ *)
                    AND (TMP_V <> 'Ž‘ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '‚…“’œ') AND (TMP_V <> '‚…‘’ˆ')
                    AND (TMP_V <> '‚‘’€’œ') AND (TMP_V <> '‚ŽŽ“†ˆ’œ')
                    AND (TMP_V <> '‚›€’œ') AND (TMP_V <> '‚›Ž‹ˆ’œ')
                    AND (TMP_V <> '„‚ˆ“’œ') AND (TMP_V <> '„‚ˆ“’œ‘Ÿ')
                    AND (TMP_V <> '„…“’œ') AND (TMP_V <> 'ƒ‹Ž’“’œ')
                    AND (TMP_V <> '„€’œ')
                    AND (TMP_V <> '„Ž€’œ') AND (TMP_V <> '„Ž€’œ‘Ÿ')
                    AND (TMP_V <> '„Ž›’œ')
                    AND (TMP_V <> '„Žƒ€’œ') AND (TMP_V <> '„Žƒ“’œ')
                    AND (TMP_V <> '‡€ƒ“‡ˆ’œ') AND (TMP_V <> '‡€Ÿ„ˆ’œ')
                    AND (TMP_V <> '‡€ˆŒ€’œ‘Ÿ') AND (TMP_V <> 'ˆ‡€’œ') 
                    AND (TMP_V <> 'ˆ‡„…†€’œ‘Ÿ')
                    AND (TMP_V <> 'ˆ‡„€’œ') AND (TMP_V <> 'Š€—“’œ‘Ÿ')
                    AND (TMP_V <> 'Šˆ“’œ')
                    AND (TMP_V <> 'ŠŽ—ˆ’œ') AND (TMP_V <> 'ŠŽ—ˆ’œ‘Ÿ')
                    AND (TMP_V <> 'ŠŽ‘“’œ‘Ÿ') AND (TMP_V <> 'Š“ˆ’œ')
                    AND (TMP_V <> '‹…—œ') AND (TMP_V <> '‹ˆ‡“’œ') 
                    AND (TMP_V <> 'Œ€•“’œ') AND (TMP_V <> 'ŒŽ‹‚ˆ’œ')
                    AND (TMP_V <> 'Œ…‹œŠ“’œ') AND (TMP_V <> '€€’œ‘Ÿ')
                    AND (TMP_V <> '€ƒ€„ˆ’œ') AND (TMP_V <> '€†€’œ')
                    AND (TMP_V <> '€‹…—œ') AND (TMP_V <> '€Ÿ—œ')
                    AND (TMP_V <> '€’Ž…’œ') 
                    AND (TMP_V <> 'Ž‚›Š“’œ') AND (TMP_V <> 'Žˆ„…’œ')
                    AND (TMP_V <> 'Žˆ„…’œ‘Ÿ') AND (TMP_V <> 'Ž…‘’ˆ')
                    AND (TMP_V <> 'Ž“’œ') AND (TMP_V <> 'Ž„…’œ')
                    AND (TMP_V <> 'Ž„…’œ‘Ÿ') AND (TMP_V <> 'Ž„“˜…‚ˆ’œ‘Ÿ')
                    AND (TMP_V <> 'Ž‘Œ›‘‹ˆ’œ') AND (TMP_V <> 'Ž‘Ž‚€’œ')
                    AND (TMP_V <> 'Ž‘Ž‚€’œ‘Ÿ') AND (TMP_V <> 'Ž‘’€‚ˆ’œ')
                    AND (TMP_V <> 'Ž‘’€Ž‚ˆ’œ') AND (TMP_V <> 'Ž‘’€Ž‚ˆ’œ‘Ÿ')
                    AND (TMP_V <> 'Ž‘’ˆ—œ') AND (TMP_V <> 'Ž’‚Žˆ’œ')
                    AND (TMP_V <> 'Ž’Š›’œ') AND (TMP_V <> 'Ž’Š›’œ‘Ÿ')
                    AND (TMP_V <> 'Ž”ŽŒˆ’œ') AND (TMP_V <> 'Ž–…ˆ’œ')
                    AND (TMP_V <> '€‘’œ') AND (TMP_V <> '‹…‘“’œ')
                    AND (TMP_V <> 'Ž„Ÿ’œ') AND (TMP_V <> 'Ž„Ÿ’œ‘Ÿ')
                    AND (TMP_V <> 'Ž‹Ž†ˆ’œ')
                    AND (TMP_V <> 'ˆŸ’œ') AND (TMP_V <> 'Ž„€’œ')
                    AND (TMP_V <> 'Ž‘’ˆ’œ‘Ÿ') AND (TMP_V <> 'Ž—ˆ’€’œ')
                    AND (TMP_V <> '›ƒ“’œ') AND (TMP_V <> '“‘’ˆ’œ')
                    AND (TMP_V <> '€‡‚…˜€’œ') AND (TMP_V <> '€‘Š€’€’œ')
                    AND (TMP_V <> '€‘…„…‹ˆ’œ')AND (TMP_V <> '…˜ˆ’œ')
                    AND (TMP_V <> '‘„€’œ') AND (TMP_V <> '‘…‘’œ')
                    AND (TMP_V <> '‘Š€‡€’œ') AND (TMP_V <> '‘Š›’œ')
                    AND (TMP_V <> '‘Œˆˆ’œ') AND (TMP_V <> '‘Ÿ’œ')
                    AND (TMP_V <> '‘Ž…„ˆˆ’œ') AND (TMP_V <> '‘Ž‡„€’œ')
                    AND (TMP_V <> '‘Ž‘ˆ’œ') AND (TMP_V <> '‘›‘“’œ')
                    AND (TMP_V <> '‘“‘’ˆ’œ') AND (TMP_V <> '‘’€’œ')
                    AND (TMP_V <> '‘’Ÿ•“’œ') AND (TMP_V <> '‘““’œ')
                    AND (TMP_V <> '‘—ˆ’€’œ') AND (TMP_V <> '’Ž‹Š“’œ')
                    AND (TMP_V <> '“‚…ˆ’œ') AND (TMP_V <> '“‚…Ÿ’œ')
                    AND (TMP_V <> '“‡€’œ') AND (TMP_V <> '“ŠŽŒ‹…Š’Ž‚€’œ')
                    AND (TMP_V <> '“Š€‘ˆ’œ') AND (TMP_V <> '“Š“ˆ’œ')  
                    AND (TMP_V <> '“ŒŽ‹Š“’œ') AND (TMP_V <> '“’ˆ•“’œ') 
                    AND (TMP_V <> '•‚€’ˆ’œ')
                    AND (TMP_V <> '•‹Ž“’œ') AND (TMP_V <> '—…Š“’œ')  
                    AND (TMP_V <> '—…€’œ‘Ÿ') AND (TMP_V <> '™…‹Š“’œ')
                    AND (TMP_V <> 'Ÿ‚ˆ’œ') AND (TMP_V <> 'Ÿ‚ˆ’œ‘Ÿ')

(* Ž’‘…‚ ƒ‹€ƒŽ‹Ž‚, …”ˆŠ‘ ……„ ŠŽ’Ž›Œˆ … Ž€‡“…’ ‚ˆ„Ž‚Ž‰ €› *)
                    AND (TMP_V <> '€•€’œ') AND (TMP_V <> '€‹Ž‚€’œ') 
                    AND (TMP_V <> '€‹Ž‚€’œ‘Ÿ') AND (TMP_V <> '‹…‘’…’œ') 
                    AND (TMP_V <> 'Ž‹’€’œ‘Ÿ') AND (TMP_V <> 'ŽŸ’œ‘Ÿ')
                    AND (TMP_V <> '€’œ') AND (TMP_V <> '…—€’œ')
                    AND (TMP_V <> 'Ž„ˆ’œ') AND (TMP_V <> '…ƒ€’œ')
                    AND (TMP_V <> '…†€’œ') AND (TMP_V <> 'ˆ’œ') 
                    AND (TMP_V <> 'Ž‹’“’œ') AND (TMP_V <> '€’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž‘€’œ') AND (TMP_V <> 'Ž‘€’œ‘Ÿ') 
                    AND (TMP_V <> '›‡ƒ€’œ') AND (TMP_V <> '›‡“’œ') 
                    AND (TMP_V <> '›Š€’œ') AND (TMP_V <> '“‹’›•€’œ‘Ÿ') 
                    AND (TMP_V <> '‚…“’œ‘Ÿ') AND (TMP_V <> '‚…’…’œ') 
                    AND (TMP_V <> '‚…’…’œ‘Ÿ') AND (TMP_V <> '‚…‘’ˆ')
                    AND (TMP_V <> '‚…˜ˆ’œ') AND (TMP_V <> '‚…˜ˆ’œ‘Ÿ')
                    AND (TMP_V <> '‚…‘ˆ’œ') AND (TMP_V <> '‚…‘’ˆ‘œ')
                    AND (TMP_V <> '‚…Ÿ’œ') AND (TMP_V <> '‚ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '‚ˆ‹œ“’œ') AND (TMP_V <> '‚ˆ‹Ÿ’œ') 
                    AND (TMP_V <> '‚ˆ‘…’œ') AND (TMP_V <> '‚…‘’ˆ') 
                    AND (TMP_V <> '‚Ž‘ˆ’œ') AND (TMP_V <> '‚Ž„ˆ’œ') 
                    AND (TMP_V <> '‚Ž„ˆ’œ‘Ÿ') AND (TMP_V <> '‚Ž‡‚…‘’ˆ’œ') 
                    AND (TMP_V <> '‚Ž‡ˆ’œ') AND (TMP_V <> '‚Ž‡ˆ’œ‘Ÿ')
                    AND (TMP_V <> '‚ŽŽ“†€’œ') 
                    AND (TMP_V <> '‚Ž‘ˆ’€’œ') AND (TMP_V <> '‚Ž‘ˆ’›‚€’œ') 
                    AND (TMP_V <> '‚Ž‘ˆ’€’œ‘Ÿ') AND (TMP_V <> '‚Ž‘ˆ’›‚€’œ‘Ÿ') 
                    AND (TMP_V <> '‚Ž‹Ž’ˆ’œ') AND (TMP_V <> '‚Ž‹Ž™€’œ') 
                    AND (TMP_V <> '‚ŽŽ˜ˆ’œ') AND (TMP_V <> '‚ˆ•€’œ‘Ÿ')
                    AND (TMP_V <> '‚’Žˆ’œ') AND (TMP_V <> '‚’›Š€’œ') 
                    AND (TMP_V <> '‚›ˆ€’œ') AND (TMP_V <> '‚›„“Œ›‚€’œ')
                    AND (TMP_V <> '‚›…„ˆ‚€’œ‘Ÿ') AND (TMP_V <> '‚›…„ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '‚›Ž‹Ÿ’œ') AND (TMP_V <> '‚›Ž‹Ÿ’œ‘Ÿ') 
                    AND (TMP_V <> '‚›’œ') AND (TMP_V <> '‚›–€€›‚€’œ')
                    AND (TMP_V <> 'ƒ€„€’œ') AND (TMP_V <> 'ƒ‹Ÿ„…’œ') 
                    AND (TMP_V <> 'ƒ‹Ÿ“’œ') AND (TMP_V <> 'ƒ‹Ÿ„…’œ‘Ÿ')
                    AND (TMP_V <> 'ƒ€’œ‘Ÿ') AND (TMP_V <> 'ƒŽ‚…’œ') 
                    AND (TMP_V <> 'ƒŽ‚€ˆ‚€’œ') AND (TMP_V <> 'ƒŽ‚Žˆ’œ') 
                    AND (TMP_V <> 'ƒŽ‚Žˆ’œ‘Ÿ') AND (TMP_V <> 'ƒŽŸ’œ')
                    AND (TMP_V <> 'ƒ€ˆ—ˆ’œ') AND (TMP_V <> 'ƒ…‘’ˆ') 
                    AND (TMP_V <> '„€‚€’œ') AND (TMP_V <> '„€‚€’œ‘Ÿ') 
                    AND (TMP_V <> '„‚ˆƒ€’œ') AND (TMP_V <> '„‚ˆƒ€’œ‘Ÿ') 
                    AND (TMP_V <> '„…‚€’œ') AND (TMP_V <> '„…’œ') 
                    AND (TMP_V <> '„…ƒ€’œ') AND (TMP_V <> '„ˆ‚ˆ’œ') 
                    AND (TMP_V <> '„ˆ‘‹Ž–ˆŽ‚€’œ') AND (TMP_V <> '„ˆ‘‹Ž–ˆŽ‚€’œ‘Ÿ')
                    AND (TMP_V <> '„Ž›‚€’œ') AND (TMP_V <> '„Ž›‚€’œ‘Ÿ')
                    AND (TMP_V <> '„Ž‚…ˆ’œ') AND (TMP_V <> '„Ž‚…Ÿ’œ') 
                    AND (TMP_V <> '„Ž‚…ˆ’œ‘Ÿ') AND (TMP_V <> '„Ž‚…Ÿ’œ‘Ÿ')
                    AND (TMP_V <> '„Ž‚€’œ‘Ÿ') AND (TMP_V <> '„€‡ˆ’œ') 
                    AND (TMP_V <> '„Ž†€’œ') AND (TMP_V <> '„“†ˆ’œ')
                    AND (TMP_V <> '„›ƒ€’œ') AND (TMP_V <> '„›˜€’œ')
                    AND (TMP_V <> '„“’œ') AND (TMP_V <> '…‡„ˆ’œ')
                    AND (TMP_V <> '…‡†€’œ') AND (TMP_V <> '…•€’œ') 
                    AND (TMP_V <> '†€’œ‘Ÿ') AND (TMP_V <> '†„€’œ') 
                    AND (TMP_V <> '†ˆ’œ') 
                    AND (TMP_V <> '‡€‚…™€’œ') AND (TMP_V <> '‡€ƒŽ€’œ') 
                    AND (TMP_V <> '‡€„“Œ€’œ‘Ÿ') AND (TMP_V <> '‡€ˆŒ€’œ')
                    AND (TMP_V <> '‡€€‚ˆ’œ') AND (TMP_V <> '‡€€‚ˆ’œ‘Ÿ')
                    AND (TMP_V <> '‡€€‚‹Ÿ’œ') AND (TMP_V <> '‡€€‚‹Ÿ’œ‘Ÿ') 
                    AND (TMP_V <> '‡€Ÿ†€’œ‘Ÿ') AND (TMP_V <> '‡€Ÿ„ˆ’œ‘Ÿ')
                    AND (TMP_V <> 'ˆƒ€’œ') AND (TMP_V <> 'ˆ‡ˆ€’œ') 
                    AND (TMP_V <> 'ˆ‡ˆ€’œ‘Ÿ') AND (TMP_V <> 'ˆ‡„€‚€’œ') 
                    AND (TMP_V <> 'ˆ‡Œ…ˆ’œ') AND (TMP_V <> 'ˆ‘Š€’œ') 
                    AND (TMP_V <> 'ˆ‘’€’ˆ’œ‘Ÿ') AND (TMP_V <> 'ˆ‘•Ž„ˆ’œ')
                    AND (TMP_V <> 'Š€‘€’œ‘Ÿ') AND (TMP_V <> 'Š€’€’œ') 
                    AND (TMP_V <> 'Š€’€’œ‘Ÿ') AND (TMP_V <> 'Š€—€’œ') 
                    AND (TMP_V <> 'Š€—€’œ‘Ÿ') AND (TMP_V <> 'Š€—“’œ')
                    AND (TMP_V <> 'Šˆ„€’œ') AND (TMP_V <> 'Šˆ‚€’œ')
                    AND (TMP_V <> 'Š‹…‚€’œ') AND (TMP_V <> 'Š‹“ˆ’œ‘Ÿ')
                    AND (TMP_V <> 'ŠŽ‚›‹Ÿ’œ') AND (TMP_V <> 'ŠŽ‚›Ÿ’œ') 
                    AND (TMP_V <> 'ŠŽ‹›•€’œ‘Ÿ') AND (TMP_V <> 'ŠŽ’“‡ˆ’œ') 
                    AND (TMP_V <> 'ŠŽ—€’œ‘Ÿ') AND (TMP_V <> 'ŠŽ‘“’œ‘Ÿ') 
                    AND (TMP_V <> 'ŠŽ’ˆ’œ') AND (TMP_V <> 'ŠŽ‘“’œ‘Ÿ')  
                    AND (TMP_V <> 'ŠˆŠ“’œ') AND (TMP_V <> 'Š…„ˆ’Ž‚€’œ‘Ÿ') 
                    AND (TMP_V <> 'Š“’ˆ’œ') AND (TMP_V <> 'Š“’ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '‹…†€’œ') AND (TMP_V <> '‹…’€’œ')
                    AND (TMP_V <> '‹ˆ’œ‘Ÿ') AND (TMP_V <> '‹Ž‚ˆ’œ') 
                    AND (TMP_V <> '‹Ž‚ˆ’œ‘Ÿ') AND (TMP_V <> '‹ŽŒˆ’œ') 
                    AND (TMP_V <> '‹žˆ’œ') AND (TMP_V <> '‹žŽ‚€’œ‘Ÿ') 
                    AND (TMP_V <> '‹Ÿ‡ƒ€’œ')
                    AND (TMP_V <> 'Œ€Š“’œ') AND (TMP_V <> 'Œ€•€’œ')
                    AND (TMP_V <> 'Œ…Ÿ’œ') AND (TMP_V <> 'Œ…Ÿ’œ‘Ÿ')
                    AND (TMP_V <> 'Œ…’€’œ') AND (TMP_V <> 'Œ…’ˆ’œ')
                    AND (TMP_V <> 'ŒŽ’€’œ') AND (TMP_V <> 'Œ—€’œ‘Ÿ')
                    AND (TMP_V <> 'Œ›Š€’œ') AND (TMP_V <> '€ˆ‚€’œ')  
                    AND (TMP_V <> '€ˆ€’œ') AND (TMP_V <> '€ˆ€’œ‘Ÿ')
                    AND (TMP_V <> '€€’œ') AND (TMP_V <> '€‚…‘ˆ’œ') 
                    AND (TMP_V <> '€‚Ž‡ˆ’œ') AND (TMP_V <> '€…•€’œ') 
                    AND (TMP_V <> '€‡€—€’œ') AND (TMP_V <> '€‡€—ˆ’œ') 
                    AND (TMP_V <> '€Š€‹ˆ‚€’œ') AND (TMP_V <> '€Š€‹ˆ‚€’œ‘Ÿ')  
                    AND (TMP_V <> '€ŠŽˆ’œ') AND (TMP_V <> '€ŠŽˆ’œ‘Ÿ')  
                    AND (TMP_V <> '€‹…ƒ€’œ') AND (TMP_V <> '€Œ…Š€’œ')
                    AND (TMP_V <> '€ˆ„“Œ›‚€’œ') AND (TMP_V <> '€Ÿƒ€’œ') 
                    AND (TMP_V <> '€Ÿƒ€’œ') AND (TMP_V <> '€‘ŒŽ’…’œ‘Ÿ')
                    AND (TMP_V <> '€‘›™€’œ') AND (TMP_V <> '€‘›™€’œ‘Ÿ') 
                    AND (TMP_V <> '€‘›’ˆ’œ') AND (TMP_V <> '€‘›’ˆ’œ‘Ÿ')
                    AND (TMP_V <> '…‘’ˆ') AND (TMP_V <> '…‘’ˆ‘œ')
                    AND (TMP_V <> '€–…‹ˆ‚€’œ') AND (TMP_V <> '€–…‹ˆ’œ') 
                    AND (TMP_V <> '€—ˆ‘‹ˆ’œ') AND (TMP_V <> '…‘’ˆ‘œ') 
                    AND (TMP_V <> 'ˆ‘•Ž„ˆ’œ') AND (TMP_V <> 'Ž‘ˆ’œ') 
                    AND (TMP_V <> '“†„€’œ‘Ÿ')
                    AND (TMP_V <> 'Ž‹ˆ—€’œ') AND (TMP_V <> 'Ž‹ˆ—ˆ’œ') 
                    AND (TMP_V <> 'ŽŽ“„Ž‚€’œ') AND (TMP_V <> 'Ž…’€’œ')
                    AND (TMP_V <> 'Ž™€’œ‘Ÿ') AND (TMP_V <> 'Ž„…‚€’œ‘Ÿ')
                    AND (TMP_V <> 'Ž“‚€’œ') AND (TMP_V <> 'Ž“‚€’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž“’œ') AND (TMP_V <> 'Ž“’œ‘Ÿ')
                    AND (TMP_V <> 'Žƒ…’œ') AND (TMP_V <> 'Ž‡‹ˆ’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž„…‚€’œ') AND (TMP_V <> 'Ž„…‚€’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž„“˜…‚‹Ÿ’œ') AND (TMP_V <> 'Ž„“˜…‚‹Ÿ’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž‡€—€’œ') AND (TMP_V <> 'Ž‡€—ˆ’œ') 
                    AND (TMP_V <> 'Ž…„…‹ˆ’œ') AND (TMP_V <> 'Ž…„…‹Ÿ’œ') 
                    AND (TMP_V <> 'Ž“„Ž‚€’œ') AND (TMP_V <> 'Ž‘Œ›‘‹Ÿ’œ') 
                    AND (TMP_V <> 'Ž‘Ž‚›‚€’œ') AND (TMP_V <> 'Ž‘Ž‚›‚€’œ‘Ÿ')
                    AND (TMP_V <> 'Ž‘€‘’ˆ’œ') AND (TMP_V <> 'Ž‘€™€’œ')
                    AND (TMP_V <> 'Ž‘€‘’ˆ’œ‘Ÿ') AND (TMP_V <> 'Ž‘€™€’œ‘Ÿ')
                    AND (TMP_V <> 'Ž’‚Žˆ’œ') AND (TMP_V <> 'Ž’‚›Š“’œ') 
                    AND (TMP_V <> 'Ž’‘’€’œ')  
                    AND (TMP_V <> 'Ž‘’€‚‹Ÿ’œ') AND (TMP_V <> 'Ž‘’€€‚‹ˆ‚€’œ')
                    AND (TMP_V <> 'Ž’‚Žˆ’œ‘Ÿ') AND (TMP_V <> 'Ž‡€—€’œ')  
                    AND (TMP_V <> 'Ž’†ˆŒ€’œ') AND (TMP_V <> 'Ž’†ˆŒ€’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž”ŽŒ‹Ÿ’œ') 
                    AND (TMP_V <> 'Ž”ŽŒˆ’œ‘Ÿ')AND (TMP_V <> 'Ž”ŽŒ‹Ÿ’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž•Ž’ˆ’œ‘Ÿ')
                    AND (TMP_V <> 'Ž•€Ÿ’œ') AND (TMP_V <> 'Ž•€Ÿ’œ‘Ÿ')
                    AND (TMP_V <> 'Ž–…ˆ‚€’œ') AND (TMP_V <> 'Ž–…ˆ‚€’œ‘Ÿ')
                    AND (TMP_V <> 'Ž–…ˆ’œ') AND (TMP_V <> 'Ž—€Ž‚€’œ‘Ÿ') 
                    AND (TMP_V <> '€„€’œ')
                    AND (TMP_V <> '€ŠŽ‚€’œ')
                    AND (TMP_V <> '€ˆ’œ‘Ÿ') AND (TMP_V <> '€•“’œ')
                    AND (TMP_V <> '…˜ˆ’œ') AND (TMP_V <> 'ˆ’€’œ')
                    AND (TMP_V <> 'ˆ•€’œ') AND (TMP_V <> '‹…‘Š€’œ')
                    AND (TMP_V <> '‹…‘Š€’œ‘Ÿ') AND (TMP_V <> '‹›’œ')
                    AND (TMP_V <> 'Ž„‚ˆƒ“’œ') AND (TMP_V <> 'Ž„„€’œ') 
                    AND (TMP_V <> 'Ž„ƒŽ’€‚‹ˆ‚€’œ‘Ÿ') AND (TMP_V <> 'Ž„ƒŽ’Ž‚ˆ’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž„ˆŒ€’œ') AND (TMP_V <> 'Ž„ˆŒ€’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž‹€ƒ€’œ‘Ÿ') AND (TMP_V <> 'Ž‹‡’ˆ')
                    AND (TMP_V <> 'Ž‹ŽŒ€’œ') AND (TMP_V <> 'Ž‹›•€’œ') 
                    AND (TMP_V <> 'Ž‹“—€’œ') AND (TMP_V <> 'Ž‹“—ˆ’œ') 
                    AND (TMP_V <> 'Ž‹œ‡Ž‚€’œ') AND (TMP_V <> 'ŽŒˆ€’œ') 
                    AND (TMP_V <> 'Ž“—ˆ’œ') AND (TMP_V <> 'Ž•“’œ') 
                    AND (TMP_V <> 'Ž‹œ‡Ž‚€’œ‘Ÿ') AND (TMP_V <> 'Ž‘‹…„Ž‚€’œ')
                    AND (TMP_V <> 'Ž€‡Œ›˜‹Ÿ’œ') AND (TMP_V <> 'Ž‘’€‚‹Ÿ’œ') 
                    AND (TMP_V <> 'Ž’…‹Ÿ’œ') AND (TMP_V <> 'Ž’…‹Ÿ’œ‘Ÿ')
                    AND (TMP_V <> '€‚ˆ’œ') AND (TMP_V <> '€‚ˆ’œ')
                    AND (TMP_V <> '…Ÿ’‘’‚Ž‚€’œ') AND (TMP_V <> 'ˆ‚ˆ’œ') 
                    AND (TMP_V <> 'ˆ‚Ÿ‡€’œ') AND (TMP_V <> 'ˆ‚Ÿ‡›‚€’œ') 
                    AND (TMP_V <> 'ˆ‚›Š“’œ') AND (TMP_V <> 'ˆ„…†€’œ') 
                    AND (TMP_V <> 'ˆ„“Œ€’œ') AND (TMP_V <> 'ˆ„“Œ›‚€’œ') 
                    AND (TMP_V <> 'ˆˆŒ€’œ') AND (TMP_V <> 'ˆˆŒ€’œ‘Ÿ')
                    AND (TMP_V <> 'Ž‚…ˆ’œ') AND (TMP_V <> 'Ž‚…ˆ’œ') 
                    AND (TMP_V <> 'Ž‚…Ÿ’œ') AND (TMP_V <> 'Ž„€’œ') 
                    AND (TMP_V <> 'Ž„€’œ‘Ÿ') AND (TMP_V <> 'Ž„€‚€’œ') 
                    AND (TMP_V <> 'Ž„€‚€’œ‘Ÿ') AND (TMP_V <> 'Ž‘’ˆ’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž™€’œ‘Ÿ') AND (TMP_V <> '›ƒ€’œ') 
                    AND (TMP_V <> '“ƒ€’œ‘Ÿ') AND (TMP_V <> '“‘Š€’œ') 
                    AND (TMP_V <> '“‘Š€’œ‘Ÿ') AND (TMP_V <> '“‘’ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '“’…˜…‘’‚Ž‚€’œ') AND (TMP_V <> '›‹€’œ') 
                    AND (TMP_V <> '›’€’œ')
                    AND (TMP_V <> '€Ž’€’œ') AND (TMP_V <> '€‡ˆ’œ')
                    AND (TMP_V <> '€‡„…‹Ÿ’œ‘Ÿ') AND (TMP_V <> '€‡Œ…Ÿ’œ') 
                    AND (TMP_V <> '€‡Œ›‘‹ˆ’œ') AND (TMP_V <> '€‡Œ›˜‹Ÿ’œ')
                    AND (TMP_V <> '€‡ŒŸ’œ‘Ÿ') AND (TMP_V <> '€‘…„…‹ˆ’œ') 
                    AND (TMP_V <> '€‘…„…‹ˆ’œ‘Ÿ') AND (TMP_V <> '€‘…„…‹Ÿ’œ') 
                    AND (TMP_V <> '€‘…„…‹Ÿ’œ‘Ÿ') AND (TMP_V <> '€‘‘“†„€’œ') 
                    AND (TMP_V <> '…‚…’œ') AND (TMP_V <> '…˜€’œ') 
                    AND (TMP_V <> '…˜€’œ‘Ÿ') AND (TMP_V <> 'Ž„ˆ’œ‘Ÿ') 
                    AND (TMP_V <> 'Ž†€’œ') AND (TMP_V <> 'Ž†„€’œ') 
                    AND (TMP_V <> '“ƒ€’œ‘Ÿ') AND (TMP_V <> '“—€’œ‘Ÿ')
                    AND (TMP_V <> '“‹ˆ’œ') AND (TMP_V <> '›’œ‘Ÿ') 
                    AND (TMP_V <> 'Ÿ„ˆ’œ') 
                    AND (TMP_V <> '‘ˆ‚€’œ') AND (TMP_V <> '‘Ž‘€’œ') 
                    AND (TMP_V <> '‘‚…Š€’œ') AND (TMP_V <> '‘‚…’ˆ’œ‘Ÿ')
                    AND (TMP_V <> '‘ˆ„…’œ') 
                    AND (TMP_V <> '‘Š€‡€’œ‘Ÿ') AND (TMP_V <> '‘Š€‡›‚€’œ‘Ÿ')
                    AND (TMP_V <> '‘Šˆ„›‚€’œ') AND (TMP_V <> '‘Šˆ“’œ')
                    AND (TMP_V <> '‘Š‹ŽŸ’œ') AND (TMP_V <> '‘ŠŽ‹œ‡“’œ')
                    AND (TMP_V <> '‘Š›‚€’œ') AND (TMP_V <> '‘Š›‚€’œ‘Ÿ')
                    AND (TMP_V <> '‘Š“ˆ’œ‘Ÿ') AND (TMP_V <> '‘‹…‡ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '‘‹Žˆ’œ') AND (TMP_V <> '‘Œ“™€’œ')  
                    AND (TMP_V <> '‘Œ“™€’œ‘Ÿ')
                    AND (TMP_V <> '‘ŒŸ’œ') AND (TMP_V <> '‘ŒŸ’œ‘Ÿ')
                    AND (TMP_V <> '‘ˆŒ€’œ') AND (TMP_V <> '‘ˆŒ€’œ‘Ÿ')
                    AND (TMP_V <> '‘Ÿ’œ') AND (TMP_V <> '‘Ÿ’œ‘Ÿ')
                    AND (TMP_V <> '‘Žˆ€’œ') AND (TMP_V <> '‘Žˆ€’œ‘Ÿ') 
                    AND (TMP_V <> '‘Ž‚€’œ') AND (TMP_V <> '‘Ž‚€’œ‘Ÿ') 
                    AND (TMP_V <> '‘Žƒ‹€‘Ž‚€’œ') AND (TMP_V <> '‘Žƒ‹€‘Ž‚€’œ‘Ÿ') 
                    AND (TMP_V <> '‘Žƒ‹€‘Ž‚›‚€’œ') AND (TMP_V <> '‘Žƒ‹€‘Ž‚›‚€’œ‘Ÿ') 
                    AND (TMP_V <> '‘Ž…„ˆˆ’œ') AND (TMP_V <> '‘Ž…„ˆŸ’œ')
                    AND (TMP_V <> '‘Ž…„ˆˆ’œ‘Ÿ') AND (TMP_V <> '‘Ž…„ˆŸ’œ‘Ÿ')
                    AND (TMP_V <> '‘Ž‡„€‚€’œ') AND (TMP_V <> '‘Ž‡„€‚€’œ‘Ÿ')
                    AND (TMP_V <> '‘Ž‡€‚€’œ') AND (TMP_V <> '‘Ž‡€’œ') 
                    AND (TMP_V <> '‘Ž‡€’œ‘Ÿ') AND (TMP_V <> '‘ŽŒ…‚€’œ‘Ÿ')
                    AND (TMP_V <> '‘Ž‹ˆ’œ‘Ÿ') AND (TMP_V <> '‘Ž‘€’œ')
                    AND (TMP_V <> '‘Ž—ˆˆ’œ') AND (TMP_V <> '‘Ž—ˆŸ’œ') 
                    AND (TMP_V <> '‘Ž—ˆ’œ‘Ÿ') AND (TMP_V <> '‘€’œ')
                    AND (TMP_V <> '‘‹…‘“’œ') AND (TMP_V <> '‘€˜ˆ‚€’œ') 
                    AND (TMP_V <> '‘’€‚ˆ’œ') AND (TMP_V <> '‘’€‚ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '‘’€’œ‘Ÿ') AND (TMP_V <> '‘’€Ž‚ˆ’œ‘Ÿ')
                    AND (TMP_V <> '‘’…ƒ€’œ') AND (TMP_V <> '‘’…ƒ“’œ') 
                    AND (TMP_V <> '‘’ˆ€’œ‘Ÿ') AND (TMP_V <> '‘’ŽŸ’œ')
                    AND (TMP_V <> '‘’€•Ž‚€’œ‘Ÿ') AND (TMP_V <> '‘’…‹Ÿ’œ') 
                    AND (TMP_V <> '‘’“ˆ’œ') AND (TMP_V <> '‘’“—€’œ') 
                    AND (TMP_V <> '‘“„ˆ’œ') AND (TMP_V <> '‘““’œ') 
                    AND (TMP_V <> '‘““’œ‘Ÿ') AND (TMP_V <> '‘“™…‘’‚Ž‚€’œ')
                    AND (TMP_V <> '’€™ˆ’œ') AND (TMP_V <> '’…—œ') 
                    AND (TMP_V <> '’ˆ‘“’œ') AND (TMP_V <> '’Š“’œ') 
                    AND (TMP_V <> '’Š“’œ‘Ÿ') AND (TMP_V <> '’Ž‹Š€’œ')
                    AND (TMP_V <> '’Ž“’œ') AND (TMP_V <> '’Ž’€’œ') 
                    AND (TMP_V <> '’Žƒ€’œ') AND (TMP_V <> '’Ž“’œ‘Ÿ') 
                    AND (TMP_V <> '’Ÿ•“’œ') AND (TMP_V <> '’›Š€’œ') 
                    AND (TMP_V <> '’Ÿ“’œ')
                    AND (TMP_V <> '“€‚ˆ’œ') AND (TMP_V <> '“€‚‹Ÿ’œ') 
                    AND (TMP_V <> '“…„ˆ’œ') AND (TMP_V <> '“…†„€’œ') 
                    AND (TMP_V <> '“‚…ˆ’œ') AND (TMP_V <> '“…Ÿ’œ') 
                    AND (TMP_V <> '“ƒŽ’Ž‚ˆ’œ') 
                    AND (TMP_V <> '“‡€‚€’œ') AND (TMP_V <> '“Š“Ÿ’œ')
                    AND (TMP_V <> '“Š€‘ˆ’œ') AND (TMP_V <> '“Š€‘ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '“Š€˜€’œ') AND (TMP_V <> '“Š€˜€’œ‘Ÿ') 
                    AND (TMP_V <> '“‹›€’œ‘Ÿ') AND (TMP_V <> '“Œ…ˆ’œ') 
                    AND (TMP_V <> '“ŒŽ†€’œ') AND (TMP_V <> '“ŒŽ†€’œ‘Ÿ') 
                    AND (TMP_V <> '“ŒŽ†ˆ’œ') AND (TMP_V <> '“ŒŽ†ˆ’œ‘Ÿ')
                    AND (TMP_V <> '“ŒŽ‹Š€’œ') AND (TMP_V <> '“ŒŽ‹Š“’œ')
                    AND (TMP_V <> '“›‚€’œ') 
                    AND (TMP_V <> '“‹Ž’Ÿ’œ') AND (TMP_V <> '“‹Ž’ˆ’œ') 
                    AND (TMP_V <> '“‹Ž’Ÿ’œ‘Ÿ') AND (TMP_V <> '“‹Ž’ˆ’œ‘Ÿ') 
                    AND (TMP_V <> '“ŽŸ„Ž—ˆ’œ') AND (TMP_V <> '“ŽŸ„Ž—ˆ‚€’œ') 
                    AND (TMP_V <> '“ŽŸ„Ž—ˆ’œ‘Ÿ') AND (TMP_V <> '“ŽŸ„Ž—ˆ‚€’œ‘Ÿ') 
                    AND (TMP_V <> '“‘‹€‚‹ˆ‚€’œ‘Ÿ')AND (TMP_V <> '“‘’€ˆ‚€’œ') 
                    AND (TMP_V <> '“‘’“€’œ') AND (TMP_V <> '“‘’“ˆ’œ') 
                    AND (TMP_V <> '“’ŽŒˆ’œ') AND (TMP_V <> '“’ŽŒ‹Ÿ’œ') 
                    AND (TMP_V <> '”›Š€’œ') AND (TMP_V <> '•€Š€’œ') 
                    AND (TMP_V <> '•‹Ž€’œ') AND (TMP_V <> '•Ž„ˆ’œ') 
                    AND (TMP_V <> '•“‘’…’œ') AND (TMP_V <> '–‚…‘’ˆ') 
                    AND (TMP_V <> '–…„ˆ’œ') AND (TMP_V <> '–…‹Ÿ’œ') 
                    AND (TMP_V <> '–…‹Ÿ’œ‘Ÿ') AND (TMP_V <> '—…Š€’œ')
                    AND (TMP_V <> '—…€’œ') AND (TMP_V <> '—…€’œ‘Ÿ') 
                    AND (TMP_V <> '—…‘€’œ') AND (TMP_V <> '—ˆ‘‹ˆ’œ‘Ÿ')
                    AND (TMP_V <> '—ˆ•€’œ') 
                    AND (TMP_V <> '˜€ƒ“’œ') AND (TMP_V <> '˜€‹ˆ’œ') 
                    AND (TMP_V <> '˜€’€’œ') AND (TMP_V <> '˜€’€’œ‘Ÿ') 
                    AND (TMP_V <> '˜‚›“’œ') AND (TMP_V <> '˜…’€’œ') 
                    AND (TMP_V <> '˜…’€’œ‘Ÿ') AND (TMP_V <> '˜ˆ€’œ')
                    AND (TMP_V <> '˜ˆˆ’œ') AND (TMP_V <> '˜ˆ”Ž‚€’œ')
                    AND (TMP_V <> '˜‹…€’œ') AND (TMP_V <> '˜Œ›ƒ€’œ') 
                    AND (TMP_V <> '˜Œ›ƒ“’œ') AND (TMP_V <> '˜›Ÿ’œ')
                    AND (TMP_V <> '™…‹Š€’œ') AND (TMP_V <> '™ˆ€’œ')
                    AND (TMP_V <> 'Ÿ‚‹Ÿ’œ‘Ÿ')

(* ”ˆ‹œ’ - ’Ž‹œŠŽ “Š€‡€›‰ …”ˆŠ‘ Ž€‡“…’ ‚ˆ„Ž‚“ž €“ *)
                    AND ((TMP_V <> '€„…‘Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '€‹Ž„ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€‹œ‡€ŒˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '€€€ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '€žŠ€’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '…†€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…‘ˆ’œ') OR (AS_PRS[K] = '‚‡'))
                    AND ((TMP_V <> '……—œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '……—œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…‘ŽŠŽˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ˆ’Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹€ƒŽ„€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹ŽŠˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Ž„€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŽŒŽ’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '…‘’ˆ') OR (AS_PRS[K] = '„Ž'))
                    AND ((TMP_V <> 'ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“„ˆ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '“ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“Ÿˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '›‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚€‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚€‹Ÿ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‚€‹Ÿ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> '‚€ƒ€ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‚€ˆ’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '‚€ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‚…—€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚…Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‚…Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‚…ˆ”ˆ–ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚…ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚…‘…‹ˆ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '‚…Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚ˆ„…’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '‚ˆˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚ˆ‘“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‚‹€„…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚‹…—œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚Ž…‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚Ž‹Ž‚€’œ') OR (AS_PRS[K] = '‚‡'))
                    AND ((TMP_V <> '‚Ž‹Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‚Ž‹Ž—ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚Ž‹Ž—œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '‚ŽŸ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‚ŽŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‚Ž—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‚€™€’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‚…„ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‚›Ž‚Ÿ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‚œž—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‚Ÿ‡€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‚Ÿ‹ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‚Ÿ‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‚Ÿ‡“’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '‚Ÿ“’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> 'ƒ€‘ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ€‘“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ‚€‡„€’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒ‚€‡„€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒ…Œ…’ˆ‡ˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒˆ“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ‹“˜ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒ‹€„ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ‹€„ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ‹Ž„€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ‹“˜ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ‹Ÿ„…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ƒŽˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ƒ“’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ƒ“’œ‘Ÿ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ƒŽ‹Ž‘Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒŽ…’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ƒŽ‘’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒŽ’Ž‚ˆ’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> 'ƒŽ’Ž‚ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMP_V <> 'ƒ€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ…Œ…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ…’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ƒ…’œ‘Ÿ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ƒ…˜ˆ’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ƒŽˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒŽ‡ˆ’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> 'ƒ“…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ“‡ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ƒ“‡ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ƒ“’Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒ“‘’ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ƒ›‡’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ƒ“ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ“„…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ƒ“‹Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„€‚ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '„€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„…†“ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„…‰‘’‚Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„…‹€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '„…‹€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '„…‹ˆ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '„…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„…ƒ€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '„…†€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„…†€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '„ˆ‚ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„ˆŠ’Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„Ž‡ˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '„Žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„Ž‹€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '„Ž‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„€ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '„€Œ€’ˆ‡ˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '„€’œ') OR (AS_PRS[K] = 'ŽŽ'))
                    AND ((TMP_V <> '„€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„…Œ€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '„ˆ‘’€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '„Žƒ“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„Ÿ•‹…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„“‹ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„“ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '„“Œ€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„“ˆ’œ') OR (AS_PRS[K] = '‚‡'))
                    AND ((TMP_V <> '„“€—ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„“Œ€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '„“’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '…†ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘š'))
                    AND ((TMP_V <> '…‘’œ') OR (AS_PRS[K] = '‘š'))
                    AND ((TMP_V <> '†€‹…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '†€‹Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '†€ˆ’œ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMP_V <> '†€ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMP_V <> '†…‚€’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '†…ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '†…—œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '†ˆ…’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '†€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '‡€Ž’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡€Ž’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡‚……’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡‚“—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡„ŽŽ‚€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡„ŽŽ‚…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡‹ˆ’œ') OR (AS_PRS[K] = '€‡Ž'))
                    AND ((TMP_V <> '‡‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‡Ž'))
                    AND ((TMP_V <> '‡€ŠŽŒˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡€ŠŽŒˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡€Œ…Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‡€’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '‡…’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ˆŒ…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ˆ’……‘Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Š€‡€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š€‹ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> 'Š€‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> 'Š€€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Š€€Š€’œ‘Ÿ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> 'Š€’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š€’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š€˜‹Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š€Ÿ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š‚€‘ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Šˆ…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠˆŸ’ˆ’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> 'Š‹…ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Š‹Žˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽ‹…€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽ‹…€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽ‹Ž‘ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŠŽ‹Ž’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽ‹Ž’œ‘Ÿ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> 'ŠŽŠ…’ˆ‡ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽŠ“ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽŽ€’ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŠŽ‘…‚ˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŠŽ”‹ˆŠ’Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽ€’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> 'ŠŽ€’œ‘Ÿ') OR (AS_PRS[K] = '„Ž'))
                    AND ((TMP_V <> 'ŠŽˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽŒˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ŠŽ€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽ…Š’ˆŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽ—…‚€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> 'ŠŽ—ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽ—ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽ‘ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Š€‘ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Š€‘ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Š€‘’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> 'Š€•Œ€‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Š…ˆ’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> 'Š…‘’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Šˆ‚ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Šˆ‚ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Šˆ’ˆŠŽ‚€’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> 'Šˆ—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŠŽŒ‘€’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> 'ŠŽˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŠŽ˜ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ŠŽ˜ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> 'Š“†ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Š“†ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š“’ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Š“’ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Š›’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š“€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> 'Š“ˆ’œ') OR (AS_PRS[K] = '……'))
                    AND ((TMP_V <> 'Š“‘€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Š“’€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹€„ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹€„ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‹€Š€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‹€ŠˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '‹€‘Š€’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '‹€Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹ƒ€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '‹…‡’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹……’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹…ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‹…’…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹…—ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‹…—ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‹ˆ‡€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹ˆŠŽ‚€’œ') OR (AS_PRS[K] = '‚Ž‡'))
                    AND ((TMP_V <> '‹ˆŽ‚€’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '‹ˆŸ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‹ˆ“’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '‹ˆ‘’€’œ') OR (AS_PRS[K] = '……'))
                    AND ((TMP_V <> '‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‹ˆ–…‚€’œ') OR (AS_PRS[K] = '……'))
                    AND ((TMP_V <> '‹ŽŒ€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‹ŽŒ€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‹Ž•Œ€’ˆ’œ') OR (AS_PRS[K] = '‚‡'))
                    AND ((TMP_V <> '‹Ž™ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‹“‡ƒ€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‹“ˆ’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> 'Œ€‡€’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ€‡€’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Œ€€’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ€€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ€ˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Œ€‘‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Œ€Ÿ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ…„‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œ…‹œ—ˆ’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ…Ÿ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œ…‡“’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Œ…ˆ’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ…ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œ…’‚…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œ…‘ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Œ…‘’ˆ') OR (AS_PRS[K] = 'Ž„'))
                    AND ((TMP_V <> 'ŒˆƒˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŒˆˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Œˆˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œˆˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŒŽ†ˆ’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> 'Œˆ’œ') OR (AS_PRS[K] = '‚Ž‡Ž'))
                    AND ((TMP_V <> 'ŒŽŠ“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŒŽ‹‚ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> 'ŒŽ‹ˆ’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> 'ŒŽ‹Ž’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŒŽ‹Ž’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŒŽ‹—€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŒŽ’ˆŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŒŽˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŒŽŽ‡ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŒŽ™ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ŒŽ™ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'ŒŽ‘’ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'ŒŽ’€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ŒŽ—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Œ“‘‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Œ“—ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Œ“—ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'Œ—€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œ›Š€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Œ›‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Œ›’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> 'Œ›’œ‘Ÿ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> 'Œ›—€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŒŸŒ‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŒŸ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…†ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> 'ˆ‡€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ŽŒˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‘ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> '€‚ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“Œ…Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ž•€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž…„€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‡Žˆ—€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Ž…ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‹ˆ”ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Žˆ…’ˆŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Žˆ…’ˆŽ‚€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '€ŠŽ‘’ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '€‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€ŠŽ‚€’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€•€’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> '€—Š€’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> '€—Š€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> '€Ÿ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '…‹…€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '…ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> '…—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '…’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '…—€’€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '…—œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> 'ˆ€ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ˆ‹ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> 'ˆ—Š€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'ˆ—Š€’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‹€‚ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '‹€‚ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '‹€Š€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹€Š€’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '‹€ˆŽ‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹€‘’€’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '‹€’ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹…‘…‚…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹…‘’ˆ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '‹Ž„ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '‹Ž„ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '‹“’€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‹›’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‹Ÿ‘€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Žˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Ž‹‡€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‹‡’ˆ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‹Ž‘Š€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‹Ž’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ŽŒˆ’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> 'ŽŒˆ’œ‘Ÿ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> 'ŽŽ˜ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> 'Ž’ˆ’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> 'Ž’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> 'Ž‘’‹€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž’…’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> '…‘‘Ž‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Ž’Ž˜ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> 'ŽŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž…Š’ˆŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Ž‘ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž‘ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ž’…‘’Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '›‘Š€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '›‘Š€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'Ÿ’€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> 'Ÿ’€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '“‹ˆŠŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“„ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '“ƒ€’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> '“’€’œ') OR (AS_PRS[K] = '……'))
                    AND ((TMP_V <> '“’€’œ‘Ÿ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '“—ˆ’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> '“•“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '›‹…‘Ž‘ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '›’€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€„Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€„Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '€‘’ˆ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '€‘’ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '€‘•Ž„Ž‚€’œ') OR (AS_PRS[K] = 'ˆ‡'))
                    AND ((TMP_V <> '‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‚€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…€ƒˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…ƒ“‹ˆŽ‚€’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '…„€Š’ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '…‡€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '…‡ŽˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '…ŠŽŒ…„Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> 'ˆ‘Ž‚€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> 'Ž‚Ÿ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '“ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '“ƒ€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '“ŒŸˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '“ŒŸˆ’œ‘Ÿ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '“˜ˆ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> '›’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '›•‹ˆ’œ') OR (AS_PRS[K] = '€‡'))
                    AND ((TMP_V <> 'Ÿ„ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‚€’€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '‘‚…‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‚…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‚…’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‚ˆ„…’…‹œ‘’‚Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘…„‹€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘…‹…Š’ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '‘…‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘…—œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘…—œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘…Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘ˆˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘ˆŸ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘Š€Š€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘Š€„€‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‘Š€ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘ŠŽ‹ˆ’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '‘Š…‘’ˆ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‘‹€‚ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‹€‘’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‹€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‹…„ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‹“†ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‹“˜€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‘‹“˜€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‹›˜€’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '‘‹žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘Œ…Ÿ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘ŒŽ‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘ŒŽ’…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘Ž‚…’Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘Ž‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘Žˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‘Ž’ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '‘Ž•“’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‘Žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‘€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‘Žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘‘Žˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’€€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’…‹ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '‘’ˆ€’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‘’‹€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’Ž€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘’€„€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’€•Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘’ˆ—œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’ˆ—œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’Žƒ€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '‘’Žˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’Žˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’Ž—ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’“—€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’›“’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’›’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘’›„ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘’›ŠŽ‚€’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '‘’›„ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘“„ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘“—ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '‘“˜ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‘“˜ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '‘—ˆ’€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘›€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '‘›€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’€–…‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '’€‘Š€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’€‘Ž‚€’œ') OR (AS_PRS[K] = '……'))
                    AND ((TMP_V <> '’€™ˆ’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '’€Ÿ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '’‚Žˆ’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '’……ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’……’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’…‡€’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '’……’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '’…Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’…Ÿ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’…‘€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’Š€’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '’Ž‹ŠŽ‚€’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '’Ž‹Ž—œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '’ŽŒˆ’œ‘Ÿ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '’Ž“’œ') OR (AS_PRS[K] = '“'))
                    AND ((TMP_V <> '’Žˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’Ž’€’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '’Ž’€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’ŽŒŽ‡ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '’ŽŽˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’Ž—ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '’Ž—ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '’€†ˆˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '’€’ˆ’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> '’€’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’…Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’…‚Ž†ˆ’œ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> '’…‚Ž†ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‚‘'))
                    AND ((TMP_V <> '’…ˆŽ‚€’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '’…€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’Ÿ‘’ˆ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’“…’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '’“†ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '’“†ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž„€'))
                    AND ((TMP_V <> '’“ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '’Ÿ“’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“—ˆ’œ') OR (AS_PRS[K] = '‚›'))
                    AND ((TMP_V <> '“†ˆ€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '“—€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '“—ˆ’œ‘Ÿ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '”ˆ‹œ’Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '”ŽŒ€’ˆŽ‚€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '”ŽŒˆŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '”Ž‘ˆŽ‚€’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '•€Œˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '•‚€‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '•‚€‘’€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '•‹…€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '•‹…‘’€’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '•‹ŽŽ’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '•Œ…‹…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '•Ž„€’€‰‘’‚Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '•Ž„ˆ’œ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '•ŽŽˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '•Ž’…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '•Ž’…’œ‘Ÿ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '•ˆ…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '–€€€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '–…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'ˆ'))
                    AND ((TMP_V <> '–…‹Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '–…‹Ž‚€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '–…ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—…Š€ˆ’œ') OR (AS_PRS[K] = 'Ž’'))
                    AND ((TMP_V <> '—…Š€’œ') OR (AS_PRS[K] = 'ˆ‘'))
                    AND ((TMP_V <> '—…‘’‚…’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '—…ˆ’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '—…’ˆ’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '—…‘€’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—ˆˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—ˆ‘’ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—ˆ‘’ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—ˆ’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—‹…ˆ’œ') OR (AS_PRS[K] = '€‘'))
                    AND ((TMP_V <> '—“‚‘’‚Ž‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '—“Ÿ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '˜…‚…‹ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '˜…‚…‹ˆ’œ‘Ÿ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '˜…’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '˜ˆ’œ') OR (AS_PRS[K] = '‘'))
                    AND ((TMP_V <> '˜“Ž‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '˜€Š‹…‚€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '˜’€ŒŽ‚€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '˜’Ž€’œ') OR (AS_PRS[K] = '‡€'))
                    AND ((TMP_V <> '˜’“Š€’“ˆ’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '˜“Œ…’œ') OR (AS_PRS[K] = '€'))
                    AND ((TMP_V <> '™…ŠŽ’€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '™“€’œ') OR (AS_PRS[K] = 'Ž'))
                    AND ((TMP_V <> '™“ˆ’œ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> '™“ˆ’œ‘Ÿ') OR (AS_PRS[K] = '‘Ž'))
                    AND ((TMP_V <> 'ŠŽŽŒˆ’œ') OR (AS_PRS[K] = '‘'))
                   ;
                UNTIL FOUND OR (K = MAXPREF);
              END;
          IF FOUND AND (FROM = 0)
            THEN FROM := 384 + K;
{===========================================in===}

(* ‚›‚Ž„ ‚ ‘’“Š’““ ‚ ŽŸ„Š… '…‘Ž‚.‚ˆ„ - ‘Ž‚.‚ˆ„' *)
          IF FOUND                            

    (*­ˆ†…‘‹…„“ž™ˆ… €› … Ÿ‚‹Ÿž’‘Ÿ ‚ˆ„Ž‚›Œˆ, •Ž’Ÿ Ž’‚…—€ž’ ‚‡Ÿ’›Œ €‚ˆ‹€Œ *)
            AND NOT((VERBS[J].TKN = '‹“†„€’œ') AND (VERBS[I].TKN = '‹“„ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'ŽŽˆ’œ') AND (VERBS[J].TKN = '……ŽŽˆ’œ'))
            AND NOT((VERBS[I].TKN = '€’œ') AND (VERBS[J].TKN = 'ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‚€‹Ÿ’œ‘Ÿ') AND (VERBS[I].TKN = '‚€‹ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '‚“•€’œ') AND (VERBS[J].TKN = '‚“•“’œ'))
            AND NOT((VERBS[I].TKN = '‚…ˆ’œ') AND (VERBS[J].TKN = '‚…“’œ'))
            AND NOT((VERBS[J].TKN = '‚…’…’œ‘Ÿ') AND (VERBS[I].TKN = '‚…“’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '‚ˆ„€’œ') AND (VERBS[J].TKN = '‚ˆ„…’œ'))
            AND NOT((VERBS[J].TKN = '‚ˆ„›‚€’œ') AND (VERBS[I].TKN = '‚ˆ„€’œ'))
            AND NOT((VERBS[J].TKN = '‚ˆ„›‚€’œ') AND (VERBS[I].TKN = '‚ˆ„…’œ'))
            AND NOT((VERBS[I].TKN = '‚‹ˆ‚€’œ') AND (VERBS[J].TKN = '‚‹ˆŸ’œ'))
            AND NOT((VERBS[J].TKN = '‚Ž‡ˆ’œ') AND (VERBS[I].TKN = '‚…‡’ˆ'))
            AND NOT((VERBS[I].TKN = '‚ŽŽ’ˆ’œ') AND (VERBS[J].TKN = 'Ž‚ŽŽ’ˆ’œ'))
            AND NOT((VERBS[I].TKN = '‚Ž‘Š…‘ˆ’œ') AND (VERBS[J].TKN = '‚Ž‘Š…‘“’œ'))
            AND NOT((VERBS[J].TKN = '‚Ž‘Ÿ’œ') AND (VERBS[I].TKN = '‚Ž‘Ÿ“’œ'))
            AND NOT((VERBS[I].TKN = '‚…ˆ‚€’œ') AND (VERBS[J].TKN = '‚…Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '‚ˆ•€’œ‘Ÿ') AND (VERBS[J].TKN = '‚ˆ•“’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '‚›Ž‘ˆ’œ') AND (VERBS[I].TKN = '‚›…‘’ˆ'))
            AND NOT((VERBS[J].TKN = '‚›‚€‹Ÿ’œ') AND (VERBS[I].TKN = '‚›‚€‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = '‚›ƒ‹Ÿ„…’œ') AND (VERBS[J].TKN = '‚›ƒ‹Ÿ“’œ'))
            AND NOT((VERBS[J].TKN = '‚›ƒ‹Ÿ„›‚€’œ') AND (VERBS[I].TKN = '‚›ƒ‹Ÿ„…’œ'))
            AND NOT((VERBS[J].TKN = '‚›…‡†€’œ') AND (VERBS[I].TKN = '‚›…‡„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‚›ŠˆŠˆ‚€’œ') AND (VERBS[I].TKN = '‚›ŠˆŠ€’œ'))
            AND NOT((VERBS[I].TKN = '‚›ˆ•€’œ') AND (VERBS[J].TKN = '‚›ˆ•“’œ'))
            AND NOT((VERBS[I].TKN = '‚›€‘’€’œ') AND (VERBS[J].TKN = '‚›€‘’ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‚›‘’“†ˆ‚€’œ') AND (VERBS[I].TKN = '‚›‘’“†€’œ'))
            AND NOT((VERBS[I].TKN = '‚›’Ž‹Š€’œ') AND (VERBS[J].TKN = '‚›’Ž‹Š“’œ'))
            AND NOT((VERBS[J].TKN = '‚›’Ÿ•ˆ‚€’œ') AND (VERBS[I].TKN = '‚›’Ÿ•€’œ'))
            AND NOT((VERBS[I].TKN = 'ƒ€‘ˆ’œ') AND (VERBS[J].TKN = 'ƒ€‘“’œ'))
            AND NOT((VERBS[I].TKN = 'ƒ‹Ž’€’œ') AND (VERBS[J].TKN = 'ƒ‹Ž’“’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ‹Ž’€’œ') AND (VERBS[J].TKN = '‡€ƒ‹Ž’€’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ‹Ÿ„…’œ') AND (VERBS[J].TKN = 'ƒ‹Ÿ“’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ€’œ') AND (VERBS[J].TKN = 'ƒ“’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ…‚€’œ') AND (VERBS[J].TKN = 'ƒ…‚ˆ’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ…‚€’œ‘Ÿ') AND (VERBS[J].TKN = 'ƒ…‚ˆ’œ‘Ÿ')) 
            AND NOT((VERBS[I].TKN = 'ƒŽ‚€ˆ‚€’œ') AND (VERBS[J].TKN = 'ƒŽ‚Žˆ’œ')) 
            AND NOT((VERBS[J].TKN = 'ƒŽŸ’œ‘Ÿ') AND (VERBS[I].TKN = 'ƒ€’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '„€‚€’œ') AND (VERBS[J].TKN = '„€‚ˆ’œ'))
            AND NOT((VERBS[I].TKN = '„€‚ˆ’œ') AND (VERBS[J].TKN = '€‡„€‚ˆ’œ'))
            AND NOT((VERBS[I].TKN = '„€’œ') AND (VERBS[J].TKN = '„…’œ'))
            AND NOT((VERBS[I].TKN = '„€’œ') AND (VERBS[J].TKN = '„“’œ'))
            AND NOT((VERBS[I].TKN = 'ƒ€’œ') AND (VERBS[J].TKN = 'ƒ“’œ')) 
            AND NOT((VERBS[I].TKN = 'ƒ€’œ') AND (VERBS[J].TKN = 'ƒ“’œ')) 
            AND NOT((VERBS[I].TKN = '„…‚€’œ') AND (VERBS[J].TKN = '€„…‚€’œ'))
            AND NOT((VERBS[I].TKN = '„…‚€’œ') AND (VERBS[J].TKN = 'Ž„…‚€’œ'))
            AND NOT((VERBS[I].TKN = '„…ƒ€’œ') AND (VERBS[J].TKN = '„…†€’œ'))
            AND NOT((VERBS[I].TKN = '„…ƒ€’œ‘Ÿ') AND (VERBS[J].TKN = '„…†€’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '„ˆ‘’€’œ') AND (VERBS[J].TKN = 'Ž„ˆ‘’€’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '„Ž›‚€’œ‘Ÿ') AND (VERBS[I].TKN = '„Žˆ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '„Ž‹€’œ') AND (VERBS[I].TKN = '„Ž‹€“’œ'))
            AND NOT((VERBS[I].TKN = '„Ž‹€’œ') AND (VERBS[J].TKN = '„Ž‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = '…„€’œ') AND (VERBS[J].TKN = '€„Ž…„€’œ'))
            AND NOT((VERBS[I].TKN = '…‡†€’œ') AND (VERBS[J].TKN = '…•€’œ'))
            AND NOT((VERBS[J].TKN = '‡€‚…˜ˆ‚€’œ') AND (VERBS[I].TKN = '‡€‚…˜€’œ'))
            AND NOT((VERBS[I].TKN = '‡€„€’œ') AND (VERBS[J].TKN = '‡€„…’œ'))
            AND NOT((VERBS[J].TKN = '‡€Šˆ“’œ') AND (VERBS[I].TKN = '‡€Šˆ‚€’œ'))
            AND NOT((VERBS[I].TKN = '‡€ˆ•€’œ') AND (VERBS[J].TKN = '‡€ˆ•“’œ'))
            AND NOT((VERBS[J].TKN = '‡€†€’œ') AND (VERBS[I].TKN = '‡€„…’œ'))
            AND NOT((VERBS[J].TKN = '‡€†ˆ‚€’œ') AND (VERBS[I].TKN = '‡€†€’œ'))
            AND NOT((VERBS[I].TKN = '‡€Œ€•€’œ') AND (VERBS[J].TKN = '‡€Œ€•“’œ'))
            AND NOT((VERBS[J].TKN = '‡€Œ€•ˆ‚€’œ') AND (VERBS[I].TKN = '‡€Œ€•€’œ'))
            AND NOT((VERBS[J].TKN = '‡€‘’€’œ') AND (VERBS[I].TKN = '‡€‘“’œ'))
            AND NOT((VERBS[J].TKN = '‡€‘’›‚€’œ') AND (VERBS[I].TKN = '‡€‘’€’œ'))
            AND NOT((VERBS[J].TKN = '‡€‘’›’œ') AND (VERBS[I].TKN = '‡€‘’›“’œ'))
            AND NOT((VERBS[I].TKN = '‡€’Ž‹Š€’œ') AND (VERBS[J].TKN = '‡€’Ž‹Š“’œ'))
            AND NOT((VERBS[J].TKN = '‡€“†ˆ‚€’œ') AND (VERBS[I].TKN = '‡€“†€’œ'))
            AND NOT((VERBS[I].TKN = '‡€•€†ˆ‚€’œ') AND (VERBS[J].TKN = '‡€•Ž„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‡€•‚€’›‚€’œ') AND (VERBS[I].TKN = '‡€•‚€’€’œ'))
            AND NOT((VERBS[I].TKN = '‡€•‹Ž€’œ') AND (VERBS[J].TKN = '‡€•‹Ž“’œ'))
            AND NOT((VERBS[I].TKN = 'ˆ‡‚…ƒ€’œ') AND (VERBS[J].TKN = 'ˆ‡‚…“’œ'))
            AND NOT((VERBS[I].TKN = 'ˆ‡‚Ž‹ˆ’œ') AND (VERBS[J].TKN = '‘Žˆ‡‚Ž‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Š€‡€’œ‘Ÿ') AND (VERBS[J].TKN = 'Ž’Š€‡€’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Š€’€’œ‘Ÿ') AND (VERBS[J].TKN = 'Š€’ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Š‹€‘’œ') AND (VERBS[J].TKN = 'ŽŠ‹€‘’œ'))
            AND NOT((VERBS[I].TKN = 'Š“€’œ') AND (VERBS[J].TKN = 'Š““’œ'))
            AND NOT((VERBS[I].TKN = 'Š“€’œ') AND (VERBS[J].TKN = '€Š“€’œ'))
            AND NOT((VERBS[I].TKN = 'Š“ˆ’œ') AND (VERBS[J].TKN = 'Š““’œ'))
            AND NOT((VERBS[I].TKN = '‹…’€’œ') AND (VERBS[J].TKN = '‹…’…’œ'))
            AND NOT((VERBS[I].TKN = '‹Ž†ˆ’œ') AND (VERBS[J].TKN = 'ŽŠ‹€‘’œ'))
            AND NOT((VERBS[I].TKN = '‹Ž†ˆ’œ') AND (VERBS[J].TKN = 'Ž‹Ž†ˆ’œ'))
            AND NOT((VERBS[I].TKN = '‹ŽŒ€’œ') AND (VERBS[J].TKN = '‹ŽŒˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Œ“—€’œ‘Ÿ') AND (VERBS[J].TKN = 'Œ“—ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '€‚Ÿ‡€’œ') AND (VERBS[J].TKN = '€‚Ÿ‡“’œ'))
            AND NOT((VERBS[I].TKN = '€„‹ŽŒ€’œ') AND (VERBS[J].TKN = '€„‹ŽŒˆ’œ'))
            AND NOT((VERBS[I].TKN = '€†€’œ') AND (VERBS[J].TKN = '€†ˆ’œ'))
            AND NOT((VERBS[I].TKN = '€Š€‹ˆ‚€’œ‘Ÿ') AND (VERBS[J].TKN = '€Š€‹Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '€Œ…’›‚€’œ') AND (VERBS[I].TKN = '€Œ…’€’œ'))
            AND NOT((VERBS[J].TKN = '€Œ…˜€’œ') AND (VERBS[I].TKN = '€Œ…‘ˆ’œ'))
            AND NOT((VERBS[J].TKN = '€’“†ˆ‚€’œ') AND (VERBS[I].TKN = '€’“†ˆ’œ'))
            AND NOT((VERBS[I].TKN = '€—…Š€’œ') AND (VERBS[J].TKN = '€—…’ˆ’œ'))
            AND NOT((VERBS[I].TKN = '… ‚ˆ„€’œ') AND (VERBS[J].TKN = '… ‚ˆ„…’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‹€„€’œ') AND (VERBS[I].TKN = '‚Ž‡Ž‹€„€’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‹ˆ‡€’œ') AND (VERBS[J].TKN = 'Ž‹ˆ‡“’œ'))
            AND NOT((VERBS[I].TKN = 'Žƒ‹Ÿ„…’œ') AND (VERBS[J].TKN = 'Žƒ‹Ÿ“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž†ˆ‚€’œ') AND (VERBS[J].TKN = 'Ž†ˆ‚ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž›‘Š€’œ') AND (VERBS[J].TKN = 'Ž›‘“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž›‘Š€’œ‘Ÿ') AND (VERBS[J].TKN = 'Ž›‘“’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹€…‚€’œ') AND (VERBS[J].TKN = 'Ž‘‹€“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹€…’œ') AND (VERBS[J].TKN = 'Ž‘‹€ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹€…’œ') AND (VERBS[J].TKN = 'Ž‘‹€“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘‹…ˆ’œ') AND (VERBS[J].TKN = 'Ž‘‹…“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‘Œ›‘‹ˆ‚€’œ') AND (VERBS[J].TKN = 'Ž‘Œ›‘‹Ÿ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž’‚…ƒ€’œ') AND (VERBS[J].TKN = 'Ž’‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž’‚…’…’œ') AND (VERBS[I].TKN = 'Ž’‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž’„…‹›‚€’œ') AND (VERBS[I].TKN = 'Ž’„…‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž’Šˆ„€’œ') AND (VERBS[J].TKN = 'Ž’Šˆ“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž’€›‚€’œ') AND (VERBS[I].TKN = 'Ž’€ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž’‘€†ˆ‚€’œ') AND (VERBS[J].TKN = 'Ž’‘…‘’œ'))
            AND NOT((VERBS[I].TKN = '……Šˆ„€’œ') AND (VERBS[J].TKN = '……Šˆ“’œ'))
            AND NOT((VERBS[I].TKN = '……‘€†ˆ‚€’œ') AND (VERBS[J].TKN = '……‘…‘’œ'))
            AND NOT((VERBS[J].TKN = '‹€‘’Ž‚€’œ') AND (VERBS[I].TKN = '‹€‘’€’œ'))
            AND NOT((VERBS[I].TKN = 'Ž…ƒ€’œ') AND (VERBS[J].TKN = 'Ž…†€’œ'))
            AND NOT((VERBS[J].TKN = 'Ž…†€’œ') AND (VERBS[I].TKN = 'Ž…„ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž›‚€’œ') AND (VERBS[J].TKN = 'Ž›’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚€‹Ÿ’œ') AND (VERBS[I].TKN = 'Ž‚€‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‚…ˆ’œ') AND (VERBS[J].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚…’…’œ') AND (VERBS[I].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚…’…’œ') AND (VERBS[I].TKN = 'Ž‚…’›‚€’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚…’…’œ‘Ÿ') AND (VERBS[I].TKN = 'Ž‚…“’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = 'Ž‚…’›‚€’œ') AND (VERBS[I].TKN = 'Ž‚…’…’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„€‚€’œ') AND (VERBS[J].TKN = 'Ž„€‚ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„€‚€’œ‘Ÿ') AND (VERBS[J].TKN = 'Ž„€‚ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Ž„€’œ') AND (VERBS[J].TKN = 'Ž„“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„‚…ƒ€’œ') AND (VERBS[J].TKN = 'Ž„‚…“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„‚…ƒ€’œ‘Ÿ') AND (VERBS[J].TKN = 'Ž„‚…“’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Ž„…ƒˆ‚€’œ') AND (VERBS[J].TKN = 'Ž„…“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž„ˆ€’œ') AND (VERBS[J].TKN = 'Ž„Ž€’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‹…’€’œ') AND (VERBS[J].TKN = 'Ž‹…’…’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‹‡€’œ') AND (VERBS[J].TKN = 'Ž‹‡’ˆ'))
            AND NOT((VERBS[I].TKN = 'ŽŒˆ€’œ') AND (VERBS[J].TKN = 'ŽŒˆ’œ'))
            AND NOT((VERBS[J].TKN = 'Ž€‡Œ›˜‹Ÿ’œ') AND (VERBS[I].TKN = 'Ž€‡Œ›‘‹ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž…˜€’œ') AND (VERBS[J].TKN = 'Ž…˜ˆ’œ'))
            AND NOT((VERBS[I].TKN = 'Ž’Ÿƒˆ‚€’œ') AND (VERBS[J].TKN = 'Ž’Ÿ“’œ'))
            AND NOT((VERBS[I].TKN = 'Ž‚…ˆ’œ') AND (VERBS[J].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[J].TKN = 'Ž‚…Ÿ’œ') AND (VERBS[I].TKN = 'Ž‚…“’œ'))
            AND NOT((VERBS[I].TKN = 'ˆ‹…ƒ€’œ') AND (VERBS[J].TKN = 'ˆ‹…—œ'))
            AND NOT((VERBS[I].TKN = 'ˆŒ…ˆ‚€’œ‘Ÿ') AND (VERBS[J].TKN = 'ˆŒ…Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = 'ˆ“Š€˜ˆ‚€’œ') AND (VERBS[I].TKN = 'ˆ“Š€˜€’œ'))
            AND NOT((VERBS[J].TKN = 'ˆ“Š€˜ˆ‚€’œ‘Ÿ') AND (VERBS[I].TKN = 'ˆ“Š€˜€’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = 'Ž‘’“†ˆ‚€’œ') AND (VERBS[I].TKN = 'Ž‘’“†€’œ'))
            AND NOT((VERBS[J].TKN = 'Ž—ˆ’€’œ') AND (VERBS[I].TKN = 'Ž—…‘’œ'))
            AND NOT((VERBS[J].TKN = 'Ž—ˆ’€’œ‘Ÿ') AND (VERBS[I].TKN = 'Ž—…‘’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = 'Ÿ„€’œ') AND (VERBS[J].TKN = 'Ÿ‘’œ'))
            AND NOT((VERBS[I].TKN = '€‡‚€‹ˆ‚€’œ') AND (VERBS[J].TKN = '€‡‚€‹Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '€‡‚…‚€’œ') AND (VERBS[J].TKN = '€‡‚…Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '€‡‚…‚€’œ‘Ÿ') AND (VERBS[J].TKN = '€‡‚…Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '€‡ƒ…‚€’œ') AND (VERBS[J].TKN = '€‡ƒ…‚ˆ’œ'))
            AND NOT((VERBS[I].TKN = '€‡ƒ…‚€’œ‘Ÿ') AND (VERBS[J].TKN = '€‡ƒ…‚ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '€‡‹ŽŒ€’œ') AND (VERBS[J].TKN = '€‡‹ŽŒˆ’œ'))
            AND NOT((VERBS[J].TKN = '€‡Œ…’€’œ') AND (VERBS[I].TKN = '€‡Œ…‘’ˆ'))
            AND NOT((VERBS[J].TKN = '€‘Ž™€’œ‘Ÿ') AND (VERBS[I].TKN = '€‘Ž‘’ˆ’œ‘Ÿ'))
            AND NOT((VERBS[I].TKN = '‘€‘›‚€’œ') AND (VERBS[J].TKN = '‘Ž‘€’œ'))
            AND NOT((VERBS[I].TKN = '‘Ž‘€’œ') AND (VERBS[J].TKN = '‘Ž‘ˆ’œ'))
            AND NOT((VERBS[I].TKN = '‘‚…ˆ’œ') AND (VERBS[J].TKN = '‘‚…“’œ'))
            AND NOT((VERBS[I].TKN = '‘‚…Š€’œ') AND (VERBS[J].TKN = '‘‚…“’œ'))
            AND NOT((VERBS[I].TKN = '‘‚ˆ‘’€’œ') AND (VERBS[J].TKN = '‘‚ˆ‘’…’œ'))
            AND NOT((VERBS[J].TKN = '‘€‚Ÿ’œ') AND (VERBS[I].TKN = '‘€‚ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‘‘“†ˆ‚€’œ') AND (VERBS[I].TKN = '‘‘“†€’œ'))
            AND NOT((VERBS[J].TKN = '‘’Ÿ•ˆ‚€’œ') AND (VERBS[I].TKN = '‚‘’Ÿ•ˆ‚€’œ'))
            AND NOT((VERBS[I].TKN = '‘’Žˆ’œ') AND (VERBS[J].TKN = '‘’Ž“’œ'))
            AND NOT((VERBS[J].TKN = '‘“„ˆ’œ') AND (VERBS[I].TKN = 'Ž’‘“„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '‘““’œ') AND (VERBS[I].TKN = '‡€‘““’œ'))
            AND NOT((VERBS[J].TKN = '“…†€’œ') AND (VERBS[I].TKN = '“…„ˆ’œ'))
            AND NOT((VERBS[I].TKN = '“‚€†€’œ') AND (VERBS[J].TKN = '“‚€†ˆ’œ'))
            AND NOT((VERBS[J].TKN = '“‚Ÿ’œ') AND (VERBS[I].TKN = '“‚Ÿ“’œ'))
            AND NOT((VERBS[J].TKN = '“‘‹Ž‚ˆ’œ‘Ÿ') AND (VERBS[I].TKN = 'Ž“‘‹Ž‚ˆ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '“’Ž€’œ') AND (VERBS[I].TKN = '“’Ž“’œ'))
            AND NOT((VERBS[I].TKN = '“’Ž€’œ') AND (VERBS[J].TKN = '“’Žˆ’œ'))
            AND NOT((VERBS[I].TKN = '“–…ˆ‚€’œ') AND (VERBS[J].TKN = '“–…Ÿ’œ'))
            AND NOT((VERBS[I].TKN = '“–…ˆ‚€’œ‘Ÿ') AND (VERBS[J].TKN = '“–…Ÿ’œ‘Ÿ'))
            AND NOT((VERBS[J].TKN = '•‹›“’œ') AND (VERBS[I].TKN = '€•‹›“’œ'))
            AND NOT((VERBS[J].TKN = '•Ž„ˆ’œ') AND (VERBS[I].TKN = 'ˆ•Ž„ˆ’œ'))
            AND NOT((VERBS[J].TKN = '•ˆ…’œ') AND (VERBS[I].TKN = '•ˆ“’œ'))
            AND NOT((VERBS[I].TKN = '—…Š€’œ') AND (VERBS[J].TKN = '—…’ˆ’œ'))
            THEN
              BEGIN   
   
           (* ‘€—€‹€ …‘ŠŽ‹œŠŽ …‘’€„€’Ž Ž€‡Ž‚€›• € *)
                ALLOC_IN_TREE ('‚ˆ‘…’œ' + BL2 + 'Ž‚ˆ‘“’œ', FROM, ROOT);
                ALLOC_IN_TREE ('‚Ž‡ˆ’œ' + BL2 + 'ˆ‚…‡’ˆ', FROM, ROOT);
                ALLOC_IN_TREE ('ƒ‹Ž’€’œ' + BL2 + 'Žƒ‹Ž’ˆ’œ', FROM, ROOT);
                ALLOC_IN_TREE ('ƒŽ‚Žˆ’œ' + BL2 + '‘Š€‡€’œ', FROM, ROOT);
                ALLOC_IN_TREE ('„Ž‘€„Ž‚€’œ' + BL2 + '€‡„Ž‘€„Ž‚€’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('„“†ˆ’œ' + BL2 + 'Ž„“†ˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('‡€€‚‹Ÿ’œ‘Ÿ' + BL2 + 'Ž‡€€‚ˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('†„€’œ' + BL2 + '„Ž†„€’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('ˆŒˆ’ˆŽ‚€’œ' + BL2 + '‘›Œˆ’ˆŽ‚€’œ', FROM, ROOT);
                ALLOC_IN_TREE ('ˆŒŽ‚ˆ‡ˆŽ‚€’œ' + BL2 + '‘›ŒŽ‚ˆ‡ˆŽ‚€’œ', FROM, ROOT);
                ALLOC_IN_TREE ('ˆ‘–…ˆŽ‚€’œ' + BL2 + '‘›‘–…ˆŽ‚€’œ', FROM, ROOT);
                ALLOC_IN_TREE ('ˆ‘Š€’œ' + BL2 + 'Ž’›‘Š€’œ', FROM, ROOT);
                ALLOC_IN_TREE ('Š‹€Ÿ’œ‘Ÿ' + BL2 + 'ŽŠ‹Žˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('…‚ˆ—€’œ' + BL2 + '€‡…‚ˆ—€’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('Ž’ŠŽ‚…ˆ—€’œ' + BL2 + '€‡Ž’ŠŽ‚…ˆ—€’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('€„€’œ' + BL2 + '“€‘’œ', FROM, ROOT);
                ALLOC_IN_TREE ('Ž„Ž‡…‚€’œ' + BL2 + '‡€Ž„Ž‡ˆ’œ', FROM, ROOT);
                ALLOC_IN_TREE ('ŽŸ’œ' + BL2 + '“Žˆ’œ', FROM, ROOT);
                ALLOC_IN_TREE ('“—€’œ‘Ÿ' + BL2 + 'Ž“—ˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('“˜ˆ’œ‘Ÿ' + BL2 + '“•“’œ', FROM, ROOT);
                ALLOC_IN_TREE ('‘Š“—€’œ' + BL2 + '‘Ž‘Š“—ˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('‘Ž‡€‚€’œ' + BL2 + 'Ž‘Ž‡€’œ', FROM, ROOT);
                ALLOC_IN_TREE ('‘ŽŒ…‚€’œ‘Ÿ' + BL2 + '“‘ŽŒˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('‘’›“’œ' + BL2 + 'Ž‘’›’œ', FROM, ROOT);
                ALLOC_IN_TREE ('•Ž„ˆ’œ' + BL2 + 'Ž‰’ˆ', FROM, ROOT);
                ALLOC_IN_TREE ('•‚€’€’œ‘Ÿ' + BL2 + '‘•‚€’ˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('–…‹Ÿ’œ' + BL2 + '‡€–…ˆ’œ', FROM, ROOT);
                ALLOC_IN_TREE ('–…‹Ÿ’œ‘Ÿ' + BL2 + '‡€–…ˆ’œ‘Ÿ', FROM, ROOT);
                ALLOC_IN_TREE ('—…€’œ' + BL2 + 'Ž—…“’œ', FROM, ROOT);
 
 {=====================================================out===}   
 
   (* Ž’ŽŒ ‚‘… Ž‘’€‹œ›… ‘’€„€’Ž Ž€‡Ž‚€›… €›*)
                IF REVERSE
                  THEN ALLOC_IN_TREE (VERBS[J].TKN + BL2 + VERBS[I].TKN,
                    FROM, ROOT)
                  ELSE ALLOC_IN_TREE (VERBS[I].TKN + BL2 + VERBS[J].TKN,
                    FROM, ROOT);

                (* Ž„‘—…’ € Ž ’ˆ“ ”ŽŒˆŽ‚€ˆŸ *)
                CASE FROM DIV {128} 180 OF
                  1 : INC (BIGCNT1);
                  2 : INC (BIGCNT2);
                  3 : INC (BIGCNT3);
                END;
              END;
        END;
  END;


  FUNCTION LOW_CASE (INPSTR : STR23) : STR23;
         (*========*)
    VAR
      I : BYTE;
      OUTSTR : STR23;
  BEGIN
    OUTSTR := INPSTR;
    FOR I := 1 TO LENGTH (INPSTR) DO
      IF INPSTR [I] < ''
        THEN OUTSTR [I] := CHR (ORD (INPSTR [I]) + 32)
        ELSE OUTSTR [I] := CHR (ORD (INPSTR [I]) + 80);
    LOW_CASE := OUTSTR;
  END;


BEGIN            (* MAIN *)

(* ˆˆ–ˆ€‹ˆ‡€–ˆŸ ……Œ…›• *)
  ROOT := NIL;
  COUNT := 0;
  FOR I := 1 TO MAXT6T6 DO
    AMTT6 [I] := 0;
  FOR I := 1 TO MAXT6TI DO
    AMTTI [I] := 0;
  FOR I := 1 TO MAXPREF DO
    AMTPR [I] := 0;
  CNT1 := 0;
  CNT2 := 0;
  CNT3 := 0;
  BIGCNT := 0;
  BIGCNT1 := 0;
  BIGCNT2 := 0;
  BIGCNT3 := 0;

(* –ˆŠ‹ Ž ‚‘…Œ ”€‰‹€Œ ‹ˆƒ‚ˆ‘’ˆ—…‘ŠŽ‰ €‡› "ƒ‹€ƒŽ‹ - …ƒŽ „ŽŽ‹…ˆ…"*)
  FOR J := 0 TO 77 DO
    BEGIN
      FNAME := 'OPFUNC' + CHR (ORD ('0') + J DIV 10) +
        CHR (ORD ('0') + J MOD 10) + '.COD';
      WRITELN ('  FILE ', FNAME, ' BEING PROCESSED');
      ASSIGN (INP, FNAME);
      RESET (INP);

      INIT_GROUP;

    (* Ž‘Ž‚Ž‰ –ˆŠ‹ ‚“’ˆ ”€‰‹€ *)
      REPEAT
        READLN (INP, LINE);
        IF (LINE [1] = '+')
          THEN   (* ‡€ƒŽ‹Ž‚ŽŠ ‘’€’œˆ *)
            BEGIN
              IF V_AMT > 0
                THEN
                  BEGIN
                    MAKE_AND_OUT_GROUP;
                    INIT_GROUP;
                  END;
            END
          ELSE  (* „ŽŽ‹…ˆ… *)
            BEGIN
              L := LENGTH (LINE);
              P := POS (BL2, LINE);
              VERB := COPY (LINE, 1, P-1);
              NUMSTR := COPY (LINE, L-6, 3);
              IF NOT (VERB [LENGTH (VERB)] IN ['1'..'6'])
                AND (VERB <> '›’œ') {AND (VERB <> 'ˆŒ…’œ')}
                AND (VERB <> '€•Ž„ˆ’œ‘Ÿ')
                AND (VERB <> 'Ž’€‚ˆ’œ')
                THEN
                  BEGIN
                    INC (V_AMT);
                    VERBS [V_AMT].CAS := NUMSTR;
                    VERBS [V_AMT].TKN := VERB;
                  END;
              IF EOF (INP) AND (V_AMT > 0)
                THEN
                  BEGIN
                    MAKE_AND_OUT_GROUP;
                    INIT_GROUP;
                  END;
            END;
      UNTIL EOF (INP);
      CLOSE (INP);
    END;

(* ‚›‚Ž„ ‚ˆ„Ž‚›• € ‚Ž ‚…˜ˆ‰ ”€‰‹ *)
  ASSIGN (OUT, 'PAIRS4.DAT');
  REWRITE (OUT);
  PRINT_TREE (ROOT);
  FLUSH (OUT);

(* ‚›‚Ž„ ‘’€’ˆ‘’ˆŠˆ ‚ „“ƒŽ‰ ”€‰‹ (‘’€’ˆ‘’ˆŠ… ŽŠ€ Ž˜ˆŽ—€!!!) *)
  ASSIGN (OUT1, 'ASPSTAT4.DAT');
  REWRITE (OUT1);

  BIGCNT := BIGCNT1 + BIGCNT2 + BIGCNT3;

  FOR K := 1 TO MAXT6T6 DO
    BEGIN
      L := LENGTH (ASPECT_PAIRS [K, 1]) + LENGTH (ASPECT_PAIRS [K, 2]);
      IF (ASPECT_PAIRS [K, 3] = '1')
        THEN WRITELN (OUT1,
          LOW_CASE(ASPECT_PAIRS [K, 1]), BL: 9 - LENGTH (ASPECT_PAIRS [K, 1]),
          LOW_CASE(ASPECT_PAIRS [K, 2]), BL: 9 - LENGTH (ASPECT_PAIRS [K, 2]),
          AMTT6 [K] : 3)
        ELSE WRITELN (OUT1,
          LOW_CASE(ASPECT_PAIRS [K, 2]), BL: 9 - LENGTH (ASPECT_PAIRS [K, 2]),
          LOW_CASE(ASPECT_PAIRS [K, 1]), BL: 9 - LENGTH (ASPECT_PAIRS [K, 1]),
          AMTT6 [K] : 3);
    END;
  WRITELN (OUT1, CNT1 : 5, ' = ', CNT1 / COUNT * 100 : 4 : 1,
    '% UNIQUE PAIRS FORMED WITHOUT ’œ SUFFIXE CHANGE');
  WRITELN (OUT1, BIGCNT1 : 5, ' = ', BIGCNT1 / BIGCNT * 100 : 4 : 1,
    '% REPEATING PAIRS FORMED WITHOUT ’œ SUFFIXE CHANGE');

  FOR K := 1 TO MAXT6TI DO
    BEGIN
      L := LENGTH (ASPECT_PAIRS2 [K, 1]) + LENGTH (ASPECT_PAIRS2 [K, 2]);
      IF (ASPECT_PAIRS2 [K, 3] = '1')
        THEN WRITELN (OUT1,
          LOW_CASE(ASPECT_PAIRS2 [K, 1]), BL: 9 - LENGTH (ASPECT_PAIRS2 [K, 1]),
          LOW_CASE(ASPECT_PAIRS2 [K, 2]), BL: 9 - LENGTH (ASPECT_PAIRS2 [K, 2]),
          AMTTI [K] : 3)
        ELSE WRITELN (OUT1,
          LOW_CASE(ASPECT_PAIRS2 [K, 2]), BL: 9 - LENGTH (ASPECT_PAIRS2 [K, 2]),
          LOW_CASE(ASPECT_PAIRS2 [K, 1]), BL: 9 - LENGTH (ASPECT_PAIRS2 [K, 1]),
          AMTTI [K] : 3);
    END;
  WRITELN (OUT1, CNT2 : 5, ' = ', CNT2 / COUNT * 100 : 4 : 1,
    '% UNIQUE PAIRS FORMED WITH ’œ/’ˆ SUFFIX CHANGE');
  WRITELN (OUT1, BIGCNT2 : 5, ' = ', BIGCNT2 / BIGCNT * 100 : 4 : 1,
    '% REPEATING PAIRS FORMED WITH ’œ/’ˆ SUFFIX CHANGE');

  FOR K := 1 TO MAXPREF DO
    WRITELN (OUT1, LOW_CASE (AS_PRS [K]), BL : (6 - LENGTH (AS_PRS [K])),
    AMTPR [K] : 3);
  WRITELN (OUT1, CNT3 : 5, ' = ', CNT3 / COUNT * 100 : 4 : 1,
    '% UNIQUE PAIRS FORMED WITH PREFIXES');
  WRITELN (OUT1, BIGCNT3 : 5, ' = ', BIGCNT3 / BIGCNT * 100 : 4 : 1,
    '% REPEATING PAIRS FORMED WITH PREFIXES');
  WRITELN (OUT1);
  WRITELN (OUT1, COUNT : 5, ' UNIQUE ASPECT PAIRS TOTALLY IN PAIRS4.DAT');
  WRITELN (OUT1, BIGCNT : 5, ' REPEATING PAIRS REGISTERED WITH ',
    BIGCNT / COUNT : 4 : 1, ' MEAN RATIO');

  FLUSH (OUT1);

(* Š€€Ÿ ‘’€’ˆ‘’ˆŠ€ *)
  WRITELN (CNT1 : 5, ' = ', CNT1 / COUNT * 100 : 4 : 1,
    '% PAIRS FORMED WITHOUT ’œ SUFFIX CHANGE');
  WRITELN (CNT2 : 5, ' = ', CNT2 / COUNT * 100 : 4 : 1,
    '% PAIRS FORMED WITH ’œ/’ˆ SUFFIX CHANGE');
  WRITELN (CNT3 : 5, ' = ', CNT3 / COUNT * 100 : 4 : 1,
    '% PAIRS FORMED WITH PREFIXES');
  WRITELN (COUNT : 5, ' UNIQUE ASPECT PAIRS TOTALLY IN PAIRS4.DAT');
  WRITELN (BIGCNT : 5, ' REPEATING PAIRS REGISTERED WITH ',
    BIGCNT / COUNT : 4 : 1, ' MEAN RATIO');
  WRITELN ('SEE STATISTICS OF ASPECT FORMATION IN ASPSTAT4.DAT');

END.
                                                                    