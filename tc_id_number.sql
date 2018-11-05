CREATE FUNCTION tc_id_number (in_tcno IN NUMBER)
  RETURN NUMBER AS
  TYPE c_list IS VARRAY (11) OF NUMBER;
  number_list c_list;
  l_tcno NVARCHAR2 (11);
  l_return NUMBER;
BEGIN
  number_list := c_list ();
  number_list.EXTEND (11);
  l_tcno := TO_CHAR (in_tcno);

  -- TC. kimlik numaralari 11 basamakli olup, sadece rakamlardan olusur
  IF LENGTH (l_tcno) = 11 THEN
    BEGIN
      FOR i IN 1 .. 9 LOOP
        number_list (i) := SUBSTR (l_tcno, i, 1);
      END LOOP;

      -- 1,3,5,7 ve 9. hanelerin toplaminin 7 ile carpimindan 2,4,6, ve 8. haneler cikartildiginda geriye kalan sayinin 10'a gore modu 10. haneyi verir
      number_list (10) := ( (number_list (1) + number_list (3) + number_list (5) + number_list (7) + number_list (9)) * 7) - (number_list (2) + number_list (4) + number_list (6) + number_list (8));
      IF number_list (10) < 10 THEN
        number_list (10) := number_list (10) + 10;
      END IF;
      number_list (10) := MOD (number_list (10), 10);
      
      -- 1,2,3,4,5,6,7,8,9 ve 10. sayilarin toplaminin 10'a gore modu  11. rakami saglar
      number_list (11) := number_list (1) + number_list (2) + number_list (3) + number_list (4) + number_list (5) + number_list (6) + number_list (7) + number_list (8) + number_list (9) + number_list (10);
      number_list (11) := MOD (number_list (11), 10);

      l_return := CASE WHEN TO_NUMBER (SUBSTR (l_tcno, 10, 1)) = number_list (10) AND TO_NUMBER (SUBSTR (l_tcno, 11, 1)) = number_list (11) THEN 1 ELSE 0 END;
    END;
  ELSE
    l_return := 0;
  END IF;
  RETURN l_return;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END tc_id_number;
