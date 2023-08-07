CREATE OR REPLACE FUNCTION validate_cpf(cpf TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    sum INTEGER = 0;
    weight INTEGER = 10;
    first_digit INTEGER;
    second_digit INTEGER;
    check_digits TEXT;
BEGIN
    IF length(cpf) != 11 THEN
        RETURN FALSE;
    END IF;

    FOR i IN 1..9 LOOP
        sum := sum + CAST(substring(cpf from i for 1) AS INTEGER) * weight;
        weight := weight - 1;
    END LOOP;
    first_digit := 11 - (sum % 11);
    IF first_digit >= 10 THEN
        first_digit := 0;
    END IF;

    sum := 0;
    weight := 11;
    FOR i IN 1..10 LOOP
        sum := sum + CAST(substring(cpf from i for 1) AS INTEGER) * weight;
        weight := weight - 1;
    END LOOP;
    second_digit := 11 - (sum % 11);
    IF second_digit >= 10 THEN
        second_digit := 0;
    END IF;

    check_digits := substring(cpf from 10 for 2);
    RETURN check_digits = CAST(first_digit AS TEXT) || CAST(second_digit AS TEXT);
END; $$
LANGUAGE plpgsql;