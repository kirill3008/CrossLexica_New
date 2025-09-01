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
    IF    (HEADER <> '�������') 
      AND (HEADER <> '�������') 
      AND (HEADER <> '����� ^�^�^�')
      AND (HEADER <> '����� ^�������')
      AND (HEADER <> '������') 
      AND (HEADER <> '����') 
      AND (HEADER <> '�����') 
      AND (HEADER <> '������� ���') 
      AND (HEADER <> '�������_����������') 
      AND (HEADER <> '�������_����������') 
      AND (HEADER <> '�����') 
      AND (HEADER <> '������') 
      AND (HEADER <> '���') 
      AND (HEADER <> '��������� ������')
      AND (HEADER <> '��������� �������')
      AND (HEADER <> '��������� �����������, ��������� � ���������')
      AND (HEADER <> '��������� �����������') 
      AND (HEADER <> '��������� ���������������')
      AND (HEADER <> '��������� �������, ��������� � ������')
      AND (HEADER <> '��������� ��������� ������������ � ��������� ������')
      AND (HEADER <> '��������� ��������� ���������� ������')
      AND (HEADER <> '��������� ��������')
      AND (HEADER <> '��������� �������� � ���������������')
      AND (HEADER <> '��������� ������������ � ��������')
      AND (HEADER <> '��������� ����������� ��������� �����') 
      AND (HEADER <> '��������� ��������') 
      AND (HEADER <> '��������� �����������, �������� � �����������')
      AND (HEADER <> '��������� ������� � ����������')
      AND (HEADER <> '��������� ���������')
      AND (HEADER <> '��������� ����������, ���������� � �����������')
      AND (HEADER <> '��������� ������������, ������� � ��������������� �������')
      AND (HEADER <> '��������� ��������, �����, ���������� � ����������') 
      AND (HEADER <> '��������� ���������������')
      AND (HEADER <> '��������� ���������, ������������ � �������������� ������������')
      AND (HEADER <> '��������� ��������� � ����������')
      AND (HEADER <> '��������� ����������') 
      AND (HEADER <> '��������� ������, ��������, ��������� � �����������')
      AND (HEADER <> '��������� ��������')
      AND (HEADER <> '��������� ������, ��������� � ���������')
      AND (HEADER <> '��������� ���������') 
      AND (HEADER <> '��������� ����������')
      AND (HEADER <> '��������� ����������')
    {  AND (HEADER <> '���������') }
      AND (HEADER <> '�������') 
      AND (HEADER <> '��������') 
      AND (HEADER <> '��������� �����') 
      AND (HEADER <> '���������') 
      AND (HEADER <> '���� �������� ����') 
      AND (HEADER <> '���� �������� ����') 
      AND (HEADER <> '���� �������� ����') 
      AND (HEADER <> '���� �������� ����') 
      AND (HEADER <> '������� ���') 
      AND (HEADER <> '�������_��������') 
      AND (HEADER <> '�������_���������') 
      AND (HEADER <> '������� ^������') 
      AND (HEADER <> '������� ^�������') 
      AND (HEADER <> '�����������') 
      AND (HEADER <> '�����������') 
      AND (HEADER <> '��������������') 
      AND (HEADER <> '������') 
      AND (HEADER <> '�����1') 
      AND (HEADER <> '����������� ����������') 
      AND (HEADER <> '���������� �����') 
      AND (HEADER <> '����') 
      AND (HEADER <> '��������� ������������-������������') 
      AND (HEADER <> '������� ����� ^������') 
      AND (HEADER <> '����') 
      AND (HEADER <> '���') 
      AND (HEADER <> '����1') 
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
