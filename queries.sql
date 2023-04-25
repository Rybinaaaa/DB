-- OUTHER JOIN

select purchase.number, purchase.totalsum, c.number
from purchase
         right join client c on purchase.client_id = c.number;

select person.firstname, person.lastname, c.number
from person
         left join client c on person.pid = c.person_id;

-- INNER JOIN

select *
from person
         inner join employee e on person.pid = e.person_id;


select e.salary, e.position, p.firstname, p.lastname
from employee e
         inner join person p on p.pid = e.person_id
where e.salary > 2700;


select category.name, count(p.id) as product_count
from (category
         inner join structure s on category.id = s.category_id)
         inner join product p on s.product_id = p.id
group by  category.name
having count(p.id) > 1
order by product_count desc;


-- union

select sh.street, sh.city, sh.zipcode
from shopbranch sh
union select st.street, st.city, st.zipcode
from stock st;


--

SELECT *
FROM client
WHERE number IN (SELECT d.client_id
                 FROM discounts d
                 WHERE expiredDate > CURRENT_DATE);