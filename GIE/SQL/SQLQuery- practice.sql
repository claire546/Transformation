select * from [dbo].[PurchaseTrans]
select * from [dbo].[SpecialOffer]

select accountnumber, supplier from [dbo].[PurchaseTrans] where Country = 'canada'

select distinct accountnumber, supplier from PurchaseTrans where country = 'canada'

select *  from PurchaseTrans where city = 'burnaby' and UnitPrice > 100

select * from PurchaseTrans where CarrierTrackingNumber like '4B%'

select orderid, productid,country, unitprice * orderqty as Purchaseamount, SpecialOfferID,
case specialofferID
 when 1 then 'blackfirday'
 when 2 then 'hallow day promotion'
 when 3 then 'winter offer'
 when 4 then 'back to school'
 when 6 then 'Liberty Anniversary'
 when 7 then 'Summer Sales'
 when 9 then 'Canada 150th Years'
 when 13 then 'Civil Holiday'
 when 14 then 'good friday'
 else 'no discount'
 end as Promotiontype
from PurchaseTrans


select OrderID, Supplier, productid,(UnitPrice*OrderQty) Purchaseamount,Country,
case country
when 'canada' then
  case 
  when unitprice*orderqty <=1000 and UnitPrice*OrderQty <= 1500 then 'low'
  when unitprice*orderqty >=1500 and UnitPrice*OrderQty >= 2000 then 'meduim'
  else 'High'
  end 
	  when 'France' then 
	  case 
	  when unitprice*orderqty <=100 and UnitPrice*OrderQty <= 150 then 'low'
	  when unitprice*orderqty >=150 and UnitPrice*OrderQty >= 200 then 'meduim'
	  else 'High'
	  end
end as KPIIndicator   
from PurchaseTrans

select count(*) from PurchaseTrans
 select count(employee) from purchasetrans
 select count (distinct(employee)) from PurchaseTrans

 select avg(UnitPrice) as Average from PurchaseTrans
 select avg(distinct(unitprice)) from PurchaseTrans
 select max(unitprice) from PurchaseTrans
 select min(unitprice ) from PurchaseTrans

 select sum(orderqty) total from PurchaseTrans
 select sum(distinct(orderqty)) from purchasetrans

 select country,sum (distinct(orderqty))Totalqty from purchasetrans
 group by country

  select country,sum (orderqty)Totalqty from purchasetrans
 group by country

 select country, class, sum(orderqty)totalqty from PurchaseTrans
 group by rollup (country, class) 
 order by country 

 select country, class, sum (orderqty) totalqty from PurchaseTrans
 group by grouping sets (country, Class) 
 order by country 

  select country,  sum (orderqty) totalqty from PurchaseTrans
 group by grouping sets (country) 
 order by country 

 use SQLessential

 select country , class, sum(orderqty) as Total from purchasetrans
 group by grouping sets (rollup(country, class) )
 order by country 


 select country, sum(distinct (orderqty)) as Total from PurchaseTrans
 group by Country
 having sum(orderqty) >100
 order by country 

 select country, SUM(distinct orderqty)totalqty, count(orderqty) totalqty from PurchaseTrans
 group by country
 having count(orderqty*UnitPrice) >10 
 order by country 

 select country, sum (distinct orderqty) Totalqty, count(orderqty)qtycount, (sum (orderqty * unitprice)) as totalpurchase  from PurchaseTrans
 group by country
 having sum (orderqty * unitprice) > 10 and sum (orderqty * unitprice) >2000
 order by country 

 select country,city, sum(distinct orderqty)totalqty, count(*)qtycount, sum(orderqty*unitprice)Purchaseamt from PurchaseTrans
 group by country, city 
 having count(orderqty*unitprice) >10 and sum(orderqty*unitprice)>2000 
 order by country

  select country,city, sum(distinct orderqty)totalqty, count(*)qtycount, sum(orderqty*unitprice)Purchaseamt from PurchaseTrans
  where country ='canada'
 group by country, city 
 having count(orderqty*unitprice) >10 and sum(orderqty*unitprice)>2000 
 order by country

 select  accountnumber, country, supplier,productid, (orderqty*unitprice)  from PurchaseTrans
  where productid in (select productid from Product where productID <10)

  select accountnumber, country, supplier,productid, (orderqty*unitprice) purchaseamount from PurchaseTrans
  where 
  productID not in (select productID from Product where ProductID <10 ) 
  
  select accountnumber, country, supplier,productid, (orderqty*unitprice) purchaseamount,
   (select ProductName from Product where PurchaseTrans.productID = product.productID) Productname
    from PurchaseTrans

	  select accountnumber, country, supplier,city, (orderqty*unitprice) purchaseamount,
   (select ProductName from Product where PurchaseTrans.productID = product.productID) Productname
    from PurchaseTrans
	   where exists (select SpecialOfferID from SpecialOffer where PurchaseTrans.SpecialOfferID = SpecialOffer.SpecialOfferID) 


select accountnumber,country, city, supplier , 
(select Productname from product where PurchaseTrans.productID = product.productID) 
from purchasetrans
where not exists (select 1 from SpecialOffer where  PurchaseTrans.SpecialOfferID = SpecialOffer.SpecialOfferID)

select accountnumber, country, supplier,productid, (orderqty*unitprice) purchaseamount
   from PurchaseTrans
   where productid > all (select productid from product where productid <10)  


   select accountnumber,country, city, supplier, orderqty*UnitPrice as Total from PurchaseTrans
   where country = 'canada' and orderqty*unitprice > (select AVG(orderqty *UnitPrice) from PurchaseTrans)  

  
   select transid, accountnumber, country, city,supplier, productname, SpecialOffer , purchaseamount from 
   (
   select transid, accountnumber, country, city, supplier, 
   (select productname from Product where productid = PurchaseTrans.ProductID) productname,
   (select SpecialOffer from SpecialOffer where SpecialOfferID = PurchaseTrans.SpecialOfferID) specialoffer,
   orderqty*unitprice as Purchaseamount
    from PurchaseTrans
	where UnitPrice*OrderQty > (select AVG (unitprice *orderqty) from PurchaseTrans)
	)subquery 
	where country = 'canada'
	

	--inner join 


select t.transid, t.accountnumber, t.country, t.city,t.supplier, s.Productname, s.CategoryName, f.SpecialOffer,
 unitprice* orderqty as purchaseamount
   from purchasetrans t
   inner join
    ( select p.ProductID,p.ProductName,g.CategoryName from product p
	inner join productcategory c on c.ProductID= p.ProductID
	inner join category g on g.CategoryID = c.CategoryID
   )s on s.ProductID = t.ProductID
        inner join SpecialOffer f on f.SpecialOfferID = t .SpecialOfferID
          where f.specialofferid  = 4

select a.specialoffer, b.categoryname from SpecialOffer a cross join Category b


-- stored procedure 



alter procedure Detail_prod (@country varchar(50), @minpurchaseamt int)
As 
set nocount on 
Begin
   select transid, accountnumber, country, city,supplier, productname, SpecialOffer , purchaseamount from 
   (
   select transid, accountnumber, country, city, supplier, 
   (select productname from Product where productid = PurchaseTrans.ProductID) productname,
   (select SpecialOffer from SpecialOffer where SpecialOfferID = PurchaseTrans.SpecialOfferID) specialoffer,
   orderqty*unitprice as Purchaseamount
    from PurchaseTrans
	where UnitPrice*OrderQty > (select AVG (unitprice *orderqty) from PurchaseTrans)  
	)subquery
	where country = @country  and Purchaseamount >= @minpurchaseamt
end 


exec Detail_prod 'france' , 1000