'This is an analysis based on an online SQL database, that includes the following tables:
1. patients, 2. admissions, 3.doctors, 4. province_names. In the following questions, I 
will execute diverse queries.'

'Question 1: Show first name, last name, and gender of patients whose gender is M.'

SELECT first_name, last_name, gender
FROM patients
WHERE gender LIKE 'M';

'Question 2: Show first name and last name of patients who does not have allergies (null).'

SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;

'Question 3: Show first name of patients that start with the letter C'

'Solution 1'
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';

'Solution 2'
SELECT first_name
FROM patients
WHERE substring(first_name, 1, 1) = 'C';

'Question 4: Show first name and last name of patients that weight 
within the range of 100 to 120 (inclusive).'

'Solution 1'
SELECT first_name, last_name
FROM patients
WHERE weight 
BETWEEN 100 AND 120;

'Solution 2'
SELECT
  first_name,
  last_name
FROM patients
WHERE weight >= 100 AND weight <= 120;

'Question 5: Update the patients table for the allergies column. 
If the patient s allergies is null then replace it with NKA.'

UPDATE patients
SET allergies = 'NKA'
WHERE allergies is NULL;

'Question 6: Show first name and last name concatinated into 
one column to show their full name.'

'Solution 1'
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

'Solution 2'
SELECT first_name || ' ' || last_name
FROM patients;

'Question 7: Show first name, last name, and the full province name of each patient.
Example: Ontario instead of ON.'

SELECT p.first_name, p.last_name, pn.province_name
FROM patients AS p
JOIN province_names AS pn 
ON p.province_id = pn.province_id;

'Question 8: Show how many patients have a birth_date with 2010 as the birth year.'

'Solution 1'
SELECT COUNT(*) AS total_patients
FROM patients
WHERE YEAR(birth_date) = 2010;

'Solution 2'
SELECT count(first_name) AS total_patients
FROM patients
WHERE
  birth_date >= '2010-01-01'
  AND birth_date <= '2010-12-31';

'Question 9: Show the first_name, last_name, and height of the patient with 
the greatest height.'

'Solution 1'
SELECT
  first_name,
  last_name,
  MAX(height) AS height
FROM patients;

'Solution 2'
SELECT
  first_name,
  last_name,
  height
FROM patients
WHERE height = (
    SELECT max(height)
    FROM patients
  );

'Question 10: Show all columns for patients who have one of the following patient_ids:
1,45,534,879,1000'

SELECT *
FROM patients 
WHERE patient_id in (1,45,534,879,1000);

'Question 11: Show the total number of admissions'

SELECT COUNT(*) AS total_admissions
FROM admissions;

'Question 12: Show all the columns from admissions where the patient was 
admitted and discharged on the same day.'

SELECT *
FROM admissions
WHERE admission_date = discharge_date;

'Question 13: Show the patient id and the total number of admissions for patient_id 579.'

SELECT
  patient_id,
  COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

'Question 14: Based on the cities that our patients live in, show unique cities 
that are in province_id NS?'

'Solution 1'
SELECT DISTINCT(city) AS unique_cities
FROM patients
WHERE province_id = 'NS';

'Solution 2'
SELECT city
FROM patients
GROUP BY city
HAVING province_id = 'NS';

'Question 15: Write a query to find the first_name, last name and birth date 
of patients who have height greater than 160 and weight greater than 70'

SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;

'Question 16: Write a query to find list of patients first_name, 
last_name, and allergies from Hamilton where allergies are not null'

SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  city = 'Hamilton'
  and allergies is not null;
  
'Question 17: Based on cities where our patient lives in, write a query to 
display the list of unique city starting with a vowel (a, e, i, o, u). 
Show the result order in ascending by city.'

'Solution 1'
select distinct city
from patients
where
  city like 'a%'
  or city like 'e%'
  or city like 'i%'
  or city like 'o%'
  or city like 'u%'
order by city;

'Solution 2'
SELECT DISTINCT city
FROM patients 
WHERE LOWER(SUBSTR(city,1,1)) in ('a','e','i','o','u');

'Question 18: Show unique birth years from patients and order them by ascending.'

'Solution 1'
SELECT
  DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;

'Solution 2'
SELECT year(birth_date)
FROM patients
GROUP BY year(birth_date);

'Question 19: Show unique first names from the patients table which 
only occurs once in the list.
For example, if two or more people are named John in the first_name column 
then dont include their name in the output list. 
If only 1 person is named Leo then include them in the output.'

'Solution 1'
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

'Solution 2'
SELECT first_name
FROM (
    SELECT
      first_name,
      count(first_name) AS occurrencies
    FROM patients
    GROUP BY first_name
  )
WHERE occurrencies = 1;

'Question 20: Show patient_id and first_name from patients where
their first_name start and ends with s and is at least 6 characters long.'

'Solution 1'
SELECT patient_id, first_name
FROM patients
WHERE LEN(first_name) >= 6
AND first_name LIKE 's%'
AND first_name LIKE '%s';

'Solution 2'
SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s';

'Solution 3'
SELECT
  patient_id,
  first_name
FROM patients
WHERE
  first_name LIKE 's%s'
  AND len(first_name) >= 6;

'Question 21: Show patient_id, first_name, last_name from patients 
whos diagnosis is Dementia.

Primary diagnosis is stored in the admissions table.'

'Solution 1'
SELECT
  patients.patient_id,
  first_name,
  last_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
WHERE diagnosis = 'Dementia';

'Solution 2'
SELECT
  patient_id,
  first_name,
  last_name
FROM patients
WHERE patient_id IN (
    SELECT patient_id
    FROM admissions
    WHERE diagnosis = 'Dementia'
  );
  
'Question 22: Display every patients first_name.
Order the list by the length of each name and then by alphbetically'

SELECT first_name
FROM patients
order by
  len(first_name),
  first_name;
  
'Question 23: Show the total amount of male patients and the total amount of 
female patients in the patients table. Display the two results in the same row.'

'Solution 1'
SELECT 
  (SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
  (SELECT count(*) FROM patients WHERE gender='F') AS female_count;
  
'Solution 2'  
SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients;

'Solution 3'
select 
  sum(case when gender = 'M' then 1 end) as male_count,
  sum(case when gender = 'F' then 1 end) as female_count 
from patients;

'Question 24: Show first and last name, allergies from patients which have allergies 
to either Penicillin or Morphine. Show results ordered ascending by allergies then 
by first_name then by last_name.'

'Solution 1'
SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies,
  first_name,
  last_name;
  
 'Solution 2' 
SELECT
  first_name,
  last_name,
  allergies
FROM
  patients
WHERE
  allergies = 'Penicillin'
  OR allergies = 'Morphine'
ORDER BY
  allergies ASC,
  first_name ASC,
  last_name ASC;

'Question 25: Show patient_id, diagnosis from admissions. Find patients admitted 
multiple times for the same diagnosis.'

'Solution 1'
SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;

'Solution 2'
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(admission_date) > 1;

'Question 26: Show the city and the total number of patients in the city.
Order from most to least patients and then by city name ascending.'

SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city ASC;

'Question 27: Show all allergies ordered by popularity. 
Remove NULL values from query.'

'Solution 1'
SELECT
  allergies,
  COUNT(*) AS total_diagnosis
FROM patients
WHERE
  allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;

'Solution 2'
SELECT
  allergies,
  count(*)
FROM patients
WHERE allergies NOT NULL
GROUP BY allergies
ORDER BY count(*) DESC;

'Solution 3'
SELECT
  allergies,
  count(allergies) AS total_diagnosis
FROM patients
GROUP BY allergies
HAVING
  allergies IS NOT NULL
ORDER BY total_diagnosis DESC;

'Question 28: Show all patient s first_name, last_name, and birth_date 
who were born in the 1970s decade. 
Sort the list starting from the earliest birth_date.'

'Solution 1'
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

'Solution 2'
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  birth_date >= '1970-01-01'
  AND birth_date < '1980-01-01'
ORDER BY birth_date ASC;

'Solution 3'
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE year(birth_date) LIKE '197%'
ORDER BY birth_date ASC;

'Question 29: We want to display each patient s full name in a single column. 
Their last_name in all upper letters must appear first, 
then first_name in all lower case letters. Separate the last_name and first_name
with a comma. Order the list by the first_name in decending order.
EX: SMITH,jane'

SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name 
FROM patients
ORDER BY first_name DESC;

'Question 30: Show the province_id(s), sum of height; 
where the total sum of its patient s height is greater than or equal to 7,000.'

SELECT
  province_id,
  SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000;

'Question 31: Show the difference between the largest weight and smallest weight 
for patients with the last name Maroni.'

'Solution 1'
SELECT (MAX(weight) - MIN(weight)) AS weight_difference
FROM patients
WHERE last_name LIKE 'Maroni';

'Solution 2'
SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

'Question 32: Show all of the days of the month (1-31) and how many admission_dates 
occurred on that day. Sort by the day with most admissions to least admissions.'

SELECT
  DAY(admission_date) AS day_number,
  COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC;

'Question 33: Show all columns for patient_id 542 s most recent admission_date.'

'Solution 1'
SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);
 
'Solution 2' 
SELECT *
FROM admissions
WHERE
  patient_id = '542'
  AND admission_date = (
    SELECT MAX(admission_date)
    FROM admissions
    WHERE patient_id = '542'
  );
 
'Solution 3'
SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;

'Solution 4'
SELECT *
FROM admissions
GROUP BY patient_id
HAVING
  patient_id = 542
  AND max(admission_date);
  
'Question 34: Show patient_id, attending_doctor_id, and diagnosis for admissions 
that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.'

SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR 
  (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  );
  
'Question 35: Show first_name, last_name, and the total number of admissions 
attended for each doctor.
Every admission has been attended by a doctor.'

'Solution 1'  
SELECT
  first_name,
  last_name,
  count(*) as admissions_total
from admissions a
  join doctors ph on ph.doctor_id = a.attending_doctor_id
group by attending_doctor_id;

'Solution 2'
SELECT
  first_name,
  last_name,
  count(*)
from
  doctors p,
  admissions a
where
  a.attending_doctor_id = p.doctor_id
group by p.doctor_id;

'Question 36: For each doctor, display their id, full name, 
and the first and last admission date they attended.'

select
  doctor_id,
  first_name || ' ' || last_name as full_name,
  min(admission_date) as first_admission_date,
  max(admission_date) as last_admission_date
from admissions a
  join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;

'Question 37: Show first name, last name and role of every person that is either 
patient or doctor.The roles are either "Patient" or "Doctor"'

SELECT first_name, last_name, 'Patient' AS Role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' FROM doctors;

'Question 38: Display the total amount of patients for each province. 
Order by descending.'

SELECT
  province_name,
  COUNT(*) as patient_count
FROM patients pa
  join province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;

'Question 39: For every admission, display the patient s full name, 
their admission diagnosis, and their doctor s 
full name who diagnosed their problem.'

'Solution 1'
SELECT pa.first_name || ' ' || pa.last_name AS patient_full_name,
	   ad.diagnosis,
       doc.first_name || ' ' || doc.last_name AS doctor_full_name
FROM admissions as ad
JOIN patients AS pa ON pa.patient_id = ad.patient_id
JOIN doctors AS doc ON ad.attending_doctor_id = doc.doctor_id;

'Solution 2'
SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;

'Question 40: Display the number of duplicate patients based on their 
first_name and last_name.'

select
  first_name,
  last_name,
  count(*) as num_of_duplicates
from patients
group by
  first_name,
  last_name
having count(*) > 1

'Question 41: Display patients full name, height in the units feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,birth_date,gender non abbreviated.

Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.'

select
    concat(first_name, ' ', last_name) AS 'patient_name', 
    ROUND(height / 30.48, 1) as 'height "Feet"', 
    ROUND(weight * 2.205, 0) AS 'weight "Pounds"', birth_date,
CASE
	WHEN gender = 'M' THEN 'MALE' 
  ELSE 'FEMALE' 
END AS 'gender_type'
from patients;

'Question 42: Show patient_id, first_name, last_name from patients 
whose does not have any records in the admissions table. 
(Their patient_id does not exist in any admissions.patient_id rows.)'

'Solution 1'
SELECT patients.patient_id,
	   patients.first_name,
       patients.last_name
FROM patients
FULL OUTER JOIN admissions
ON patients.patient_id = admissions.patient_id
WHERE patients.patient_id IS NULL 
OR admissions.patient_id IS NULL;

'Solution 2'
SELECT
  patients.patient_id,
  first_name,
  last_name
from patients
where patients.patient_id not in (
    select admissions.patient_id
    from admissions
  );
  
'Solution 3'
SELECT
  patients.patient_id,
  first_name,
  last_name
from patients
  left join admissions on patients.patient_id = admissions.patient_id
where admissions.patient_id is NULL;

'Question 43: Show patient_id, weight, height, isObese from the patients table.
Display isObese as a boolean 0 or 1.

Obese is defined as weight(kg)/(height(m)2) >= 30.

weight is in units kg.
height is in units cm.'

'Solution 1'
SELECT patient_id, weight, height, 
  (CASE 
      WHEN weight/(POWER(height/100.0,2)) >= 30 THEN
          1
      ELSE
          0
      END) AS isObese
FROM patients;

'Solution 2'
SELECT
  patient_id,
  weight,
  height,
  weight / power(CAST(height AS float) / 100, 2) >= 30 AS obese
FROM patients;

'Question 44: Show patient_id, first_name, last_name, and 
attending doctor s specialty.
Show only the patients who has a diagnosis as Epilepsy 
and the doctor s first name is Lisa.

Check patients, admissions, and doctors tables for required information.'

'Solution 1'
SELECT patients.patient_id, 
	   patients.first_name,
       patients.last_name, 
       doctors.specialty
FROM admissions 
JOIN patients ON patients.patient_id = admissions.patient_id
			  AND admissions.diagnosis = 'Epilepsy'
JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id
			 and doctors.first_name = 'Lisa';

'Solution 2'
SELECT
  p.patient_id,
  p.first_name AS patient_first_name,
  p.last_name AS patient_last_name,
  ph.specialty AS attending_doctor_specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
WHERE
  ph.first_name = 'Lisa' and
  a.diagnosis = 'Epilepsy';
  
'Solution 3'
SELECT
  pa.patient_id,
  pa.first_name,
  pa.last_name,
  ph1.specialty
FROM patients AS pa
  JOIN (
    SELECT *
    FROM admissions AS a
      JOIN doctors AS ph ON a.attending_doctor_id = ph.doctor_id
  ) AS ph1 USING (patient_id)
WHERE
  ph1.diagnosis = 'Epilepsy'
  AND ph1.first_name = 'Lisa';
  
'Solution 4'  
SELECT
  a.patient_id,
  a.first_name,
  a.last_name,
  b.specialty
FROM
  patients a,
  doctors b,
  admissions c
WHERE
  a.patient_id = c.patient_id
  AND c.attending_doctor_id = b.doctor_id
  AND c.diagnosis = 'Epilepsy'
  AND b.first_name = 'Lisa';
  
'Solution 5'
with patient_table as (
    SELECT
      patients.patient_id,
      patients.first_name,
      patients.last_name,
      admissions.attending_doctor_id
    FROM patients
      JOIN admissions ON patients.patient_id = admissions.patient_id
    where
      admissions.diagnosis = 'Epilepsy'
  )
select
  patient_table.patient_id,
  patient_table.first_name,
  patient_table.last_name,
  doctors.specialty
from patient_table
  JOIN doctors ON patient_table.attending_doctor_id = doctors.doctor_id
WHERE doctors.first_name = 'Lisa';

'Question 45: All patients who have gone through admissions, 
can see their medical documents on our site. 
Those patients are given a temporary password after their first admission. 
Show the patient_id and temp_password.

The password must be the following, in order:
1. patient_id
2. the numerical length of patient s last_name
3. year of patient s birth_date'

'Solution 1'
SELECT
  DISTINCT P.patient_id,
  CONCAT(
    P.patient_id,
    LEN(last_name),
    YEAR(birth_date)
  ) AS temp_password
FROM patients P
  JOIN admissions A ON A.patient_id = P.patient_id;
  
'Solution 2'
select
  distinct p.patient_id,
  p.patient_id || floor(len(last_name)) || floor(year(birth_date)) as temp_password
from patients p
  join admissions a on p.patient_id = a.patient_id;
  
'Solution 3'
select
  pa.patient_id,
  ad.patient_id || floor(len(pa.last_name)) || floor(year(pa.birth_date)) as temp_password
from patients pa
  join admissions ad on pa.patient_id = ad.patient_id
group by pa.patient_id;

'Question 46: We are looking for a specific patient. 
Pull all columns for the patient who matches the following criteria:
- First_name contains an r after the first two letters.
- Identifies their gender as F
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city Kingston'

'Solution 1'
SELECT *
FROM patients
WHERE 
	first_name LIKE '__r%'
	AND gender = 'F'
	AND MONTH(birth_date) IN (02,05,12)
	AND weight BETWEEN 60 AND 80
	AND MOD(patient_id,2) != 0
	AND city = 'Kingston';

'Solution 2'
SELECT *
FROM patients
WHERE
  first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 = 1
  AND city = 'Kingston';
  
'Question 47: Sort the province names in ascending order in such a way 
that the province Ontario is always on top.'

'Solution 1'
SELECT province_name 
FROM province_names
ORDER BY 
	CASE 
    	WHEN province_name = 'Ontario'
        THEN 1
        	ELSE 2 END;

'Solution 2'
select province_name
from province_names
order by
  (case when province_name = 'Ontario' then 0 else 1 end),
  province_name;

'Solution 3'
select province_name
from province_names
order by
  (not province_name = 'Ontario'),
  province_name;
  
'Solution 4'
select province_name
from province_names
order by
  province_name = 'Ontario' desc,
  province_name;
  
'Solution 5'
SELECT province_name
FROM province_names
ORDER BY
  CASE
    WHEN province_name = 'Ontario' THEN 1
    ELSE province_name
  END;
  