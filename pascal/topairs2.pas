PROGRAM TOPAIRS2;

  CONST
    BL = ' ';
    BL2 = '  ';
    DUMMY = '';
    TLD =  '~';
    US =  '_';
    PS = '1';
    MAX = 10000;

  VAR
    L, P, Q : LONGINT;
    TOTAL, COUNT : LONGINT;
    INP , OUT : TEXT;
    LINE, HEADER : STRING [120];
    GROUP : ARRAY [1..MAX] OF STRING [120];
  
  PROCEDURE GROUPOUT;
    VAR
      I, J : LONGINT;
  BEGIN
    IF    (HEADER <> 'Ž‹…‡œ') 
      AND (HEADER <> '‚€…œ…') 
      AND (HEADER <> 'ƒŽŽ„ ^‘^˜^€')
      AND (HEADER <> 'ƒŽŽ„ ^“Š€ˆ›')
      AND (HEADER <> '„……‚Ž') 
      AND (HEADER <> '„†…Œ') 
      AND (HEADER <> '„†…Œ›') 
      AND (HEADER <> '†…‘ŠŽ… ˆŒŸ') 
      AND (HEADER <> '†…™ˆ€_€–ˆŽ€‹Š€') 
      AND (HEADER <> '†…™ˆ›_€–ˆŽ€‹Šˆ') 
      AND (HEADER <> '‡€‚Ž„') 
      AND (HEADER <> '‡€‚Ž„›') 
      AND (HEADER <> '‡€‹') 
      AND (HEADER <> 'ˆ‡‚…‘’›… €Š’…›')
      AND (HEADER <> 'ˆ‡‚…‘’›… €Š’ˆ‘›')
      AND (HEADER <> 'ˆ‡‚…‘’›… €’ŽŽ‹Žƒˆ, ‘ˆ•Ž‹Žƒˆ ˆ ‘ˆ•ˆ€’›')
      AND (HEADER <> 'ˆ‡‚…‘’›… €•ˆ’…Š’Ž›') 
      AND (HEADER <> 'ˆ‡‚…‘’›… …„ˆˆŒ€’…‹ˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ˆŽ‹Žƒˆ, ”ˆ‡ˆŽ‹Žƒˆ ˆ Œ…„ˆŠˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ‚ŽŠ€‹ˆ‘’› Š‹€‘‘ˆ—…‘Šˆ• ˆ €Ž„ŽƒŽ †€Ž‚')
      AND (HEADER <> 'ˆ‡‚…‘’›… ‚ŽŠ€‹ˆ‘’› Ž“‹Ÿ›• †€Ž‚')
      AND (HEADER <> 'ˆ‡‚…‘’›… ƒ……’ˆŠˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ƒ…Žƒ€”› ˆ “’…˜…‘’‚…ˆŠˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ˆ‡Ž…’€’…‹ˆ ˆ ˆ†……›')
      AND (HEADER <> 'ˆ‡‚…‘’›… ˆ‘Ž‹ˆ’…‹ˆ €‚’Ž‘ŠŽ‰ …‘ˆ') 
      AND (HEADER <> 'ˆ‡‚…‘’›… ˆ‘’ŽˆŠˆ') 
      AND (HEADER <> 'ˆ‡‚…‘’›… ŠŽŒŽ‡ˆ’Ž›, „ˆˆ†…› ˆ ˆ‘Ž‹ˆ’…‹ˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ‹…’—ˆŠˆ ˆ ŠŽ‘ŒŽ€‚’›')
      AND (HEADER <> 'ˆ‡‚…‘’›… ‹ˆƒ‚ˆ‘’›')
      AND (HEADER <> 'ˆ‡‚…‘’›… Œ€’…Œ€’ˆŠˆ, ‘’€’ˆ‘’ˆŠˆ ˆ ˆ”ŽŒ€’ˆŠˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… Ž™…‘’‚…›…, ‚Ž…›… ˆ ƒŽ‘“„€‘’‚…›… „…Ÿ’…‹ˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ˆ‘€’…‹ˆ, Ž’›, „€Œ€’“ƒˆ ˆ †“€‹ˆ‘’›') 
      AND (HEADER <> 'ˆ‡‚…‘’›… …„ˆˆŒ€’…‹ˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… …†ˆ‘‘…›, Ž‘’€Ž‚™ˆŠˆ ˆ •“„Ž†…‘’‚…›… “ŠŽ‚Ž„ˆ’…‹ˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ‘Ž–ˆŽ‹Žƒˆ ˆ Ž‹ˆ’Ž‹Žƒˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ‘Ž’‘Œ…›') 
      AND (HEADER <> 'ˆ‡‚…‘’›… ”ˆ‡ˆŠˆ, Œ…•€ˆŠˆ, €‘’ŽŽŒ› ˆ €‘’Ž”ˆ‡ˆŠˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… ”ˆ‹Ž‘Ž”›')
      AND (HEADER <> 'ˆ‡‚…‘’›… •ˆŒˆŠˆ, ”ˆ‡•ˆŒˆŠˆ ˆ ˆŽ•ˆŒˆŠˆ')
      AND (HEADER <> 'ˆ‡‚…‘’›… •“„Ž†ˆŠˆ') 
      AND (HEADER <> 'ˆ‡‚…‘’›… ˜€•Œ€’ˆ‘’›')
      AND (HEADER <> 'ˆ‡‚…‘’›… ŠŽŽŒˆ‘’›')
    {  AND (HEADER <> 'ˆ‘Š“‘‘’‚Ž') }
      AND (HEADER <> 'ŠŽ”…’›') 
      AND (HEADER <> 'ŠŽ”ˆ’ž') 
      AND (HEADER <> '‹€’ˆ‘Š€Ÿ “Š‚€') 
      AND (HEADER <> '‹…Š€‘’‚Ž') 
      AND (HEADER <> '‹ˆ–€ †…‘ŠŽƒŽ Ž‹€') 
      AND (HEADER <> '‹ˆ–Ž †…‘ŠŽƒŽ Ž‹€') 
      AND (HEADER <> '‹ˆ–€ Œ“†‘ŠŽƒŽ Ž‹€') 
      AND (HEADER <> '‹ˆ–Ž Œ“†‘ŠŽƒŽ Ž‹€') 
      AND (HEADER <> 'Œ“†‘ŠŽ… ˆŒŸ') 
      AND (HEADER <> 'Œ“†—ˆ€_€–ˆŽ€‹') 
      AND (HEADER <> 'Œ“†—ˆ›_€–ˆŽ€‹›') 
      AND (HEADER <> 'Ž‹€‘’œ ^Ž‘‘ˆˆ') 
      AND (HEADER <> 'Ž‹€‘’œ ^“Š€ˆ›') 
      AND (HEADER <> '…„ˆŸ’ˆ…') 
      AND (HEADER <> '…„ˆŸ’ˆŸ') 
      AND (HEADER <> 'ŽŒ›˜‹…Ž‘’œ') 
      AND (HEADER <> 'Ž‹ˆ‚') 
      AND (HEADER <> '’ˆ–€1') 
      AND (HEADER <> '…‹ˆƒˆŽ‡›… €‚’Žˆ’…’›') 
      AND (HEADER <> 'Ž‘‘ˆ‰‘Šˆ‰ ƒŽŽ„') 
      AND (HEADER <> '‘ˆ‹›') 
      AND (HEADER <> '‘Ž‚…’‘Šˆ… ŠŽ‘’“Š’Ž›-“ŠŽ‚Ž„ˆ’…‹ˆ') 
      AND (HEADER <> '‘’€–ˆˆ Œ…’Ž ^ŒŽ‘Š‚›') 
      AND (HEADER <> '–‚…’') 
      AND (HEADER <> '‘ŽŠ') 
      AND (HEADER <> 'Ÿ‡›Š1') 
      THEN
        FOR I := 1 TO COUNT DO
          FOR J := 1 TO COUNT DO
            IF I <> J
              THEN 
                BEGIN
                  INC (TOTAL);
                  WRITELN (OUT, GROUP [I], BL+PS+BL, GROUP [J]);
                END;
    FLUSH (OUT);
  END;

BEGIN
  ASSIGN (OUT, 'HYPAIRS.TXT');
  REWRITE (OUT);
  TOTAL := 0;

  ASSIGN (INP, 'HYPONYM.TXT');
  RESET (INP);
  HEADER := DUMMY;

  REPEAT
    READLN (INP, LINE);
    IF LINE [1] <> BL
      THEN 
        BEGIN
          IF HEADER <> DUMMY
            THEN GROUPOUT;
          FOR L := 1 TO MAX DO
            GROUP [L] := DUMMY;
          COUNT := 0;
          IF POS (LINE [LENGTH(LINE)], '123456') > 0
            THEN LINE := COPY(LINE, 1, LENGTH(LINE)-1);
          HEADER := LINE;
        END
    ELSE
      BEGIN
        LINE := COPY (LINE, 3, LENGTH(LINE)-2);
        INC (COUNT);
        P := POS (TLD, LINE);
        Q := POS (US, LINE);
        IF P > 0
          THEN LINE := COPY (LINE, 1, P-1) + HEADER
        ELSE IF Q > 0
          THEN LINE [Q] := '-';
        GROUP [COUNT] := LINE;
      END;  
      IF EOF (INP)
        THEN GROUPOUT;
  UNTIL EOF (INP);
  FLUSH (OUT);

  WRITELN ('  File HYPAIRS.TXT contains ', TOTAL, ' vocable pairs');
END.
