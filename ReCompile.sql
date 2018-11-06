-- You may use DBMS_UTILITY :
-- EXEC DBMS_UTILITY.compile_schema(schema => 'Schema_Name', compile_all => false);
--
BEGIN
  FOR item IN (SELECT object_name, object_type, DECODE (object_type,  'PACKAGE', 1,  'PACKAGE BODY', 2,  3) AS recompile_order
               FROM user_objects
               WHERE status != 'VALID'
               ORDER BY 3) LOOP
    BEGIN
      IF item.object_type <> 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER ' || item.object_type || ' ' || item.object_name || ' COMPILE';
      ELSE
        EXECUTE IMMEDIATE 'ALTER PACKAGE ' || item.object_name || ' COMPILE BODY';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line (item.object_type || ' : ' || item.object_name || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK || '  ' || DBMS_UTILITY.format_error_backtrace);
    END;
  END LOOP;
END;
