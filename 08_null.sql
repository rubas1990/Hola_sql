-- esto  es para ver los nulls --


SELECT * FROM user WHERE email IS NULL; 

-- TAMBIEN SE PUEDE HACER NEGADAS --


SELECT * FROM user  WHERE email IS NOT NULL;
