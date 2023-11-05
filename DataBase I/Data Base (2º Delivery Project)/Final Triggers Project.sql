
---------------------------------------------------------------------------------
--**************************** RULE 1 ****************************************--
---------------------------------------------------------------------------------
-- INSERT RULE 1
create or alter trigger trig1_inserted
on PROMOTIONS
after insert
as
begin
	
	declare @Num_Wrong_Already_Exists int;
	declare @Num_Wrong_Insertion_Overlap int;
	declare @Total_Inserted int;

	delete PROMOTIONS
	from inserted i1, inserted i2
	where (i1.IDpromotion<>i2.IDPROMOTION and i1.IDSTORE=i2.IDSTORE and ( (i1.ENDDATE between i2.STARTDATE and i2.ENDDATE)
		or (i1.STARTDATE between i2.STARTDATE and i2.ENDDATE)
		or (i2.ENDDATE between i1.STARTDATE and i1.ENDDATE) ) and i1.IDPROMOTION=PROMOTIONS.IDPROMOTION )

	set @Num_Wrong_Already_Exists = @@ROWCOUNT
	print (cast(@Num_Wrong_Already_Exists as nvarchar(5)) + ' rows overlapped with a row already in PROMOTIONS' )

	delete PROMOTIONS
	from inserted i1, PROMOTIONS p2, PROMOTIONS
	where  (i1.IDpromotion<>p2.IDPROMOTION and i1.IDSTORE=p2.IDSTORE and ( (i1.ENDDATE between p2.STARTDATE and p2.ENDDATE)
		or (i1.STARTDATE between p2.STARTDATE and p2.ENDDATE)
		or (p2.ENDDATE between i1.STARTDATE and i1.ENDDATE) ) and i1.IDPROMOTION=PROMOTIONS.IDPROMOTION  )

	set @Num_Wrong_Insertion_Overlap = @@ROWCOUNT
	print (cast(@Num_Wrong_Insertion_Overlap as nvarchar(5)) + ' rows overlapped with each other')

	set @Total_Inserted = (select count(*) from inserted);

	print('')
	print('A total of ' + cast( (@Total_Inserted-@Num_Wrong_Insertion_Overlap-@Num_Wrong_Already_Exists) as nvarchar(5) ) + ' rows were inserted in PROMOTIONS of a total of ' +
		cast( (@Total_Inserted) as nvarchar(5) ) + ' rows')
end
go
 
 -- UPDATE RULE 1
 create or alter trigger trig1_update
on PROMOTIONS
after update
as
begin
	
	declare @TotalUpdated int;
	declare @WrongRows int;
	
	update PROMOTIONS 
	set STARTDATE=d.STARTDATE, ENDDATE=d.ENDDATE
	from deleted d, inserted i1, PROMOTIONS p2, PROMOTIONS
	where PROMOTIONS.IDPROMOTION=d.IDPROMOTION and PROMOTIONS.IDPROMOTION=i1.IDPROMOTION
			and i1.IDPROMOTION<>p2.IDPROMOTION and  i1.IDSTORE=p2.IDSTORE
			and ( (i1.ENDDATE between p2.STARTDATE and p2.ENDDATE)
		or (i1.STARTDATE between p2.STARTDATE and p2.ENDDATE)
		or (p2.ENDDATE between i1.STARTDATE and i1.ENDDATE) )

	set @WrongRows = @@ROWCOUNT;
	set @TotalUpdated = (select count(*) from inserted);

	print('A total of ' + cast( (@TotalUpdated-@WrongRows) as nvarchar(5)) + ' row(s) were updated, when trying to update a total of ' +  cast( (@TotalUpdated) as nvarchar(5)) +' row(s)')
end
go

---------------------------------------------------------------------------------
--**************************** RULE 3 ****************************************--
---------------------------------------------------------------------------------
-- INSERT RULE 3
create or alter trigger trig3_insert
on ITEMS
after insert
as
begin

	declare @TotalInserted int;
	declare @WrongRows int;
	
	delete ITEMS
	from inserted i
	join STORES s
		on s.IDSTORE=i.IDDESTINATIONSTORE
	where ITEMS.IDITEM = i.IDITEM and ( (s.STORETYPE='premium' and i.PREMIUM=0) or (s.STORETYPE='regular' and i.PREMIUM=1) ) -- delete the ones that break the rule and came from the insert

	set @WrongRows = @@ROWCOUNT;
	set @TotalInserted = (select count(*) from inserted);

	if @WrongRows>0
		print('A total of ' + cast( @WrongRows as nvarchar(5)) + ' row(s) did not follow the Rule 3. So only '+ cast( (@TotalInserted-@WrongRows) as nvarchar(5)) + 
		' row(s) were inserted, when trying to insert a total of ' +  cast( (@TotalInserted) as nvarchar(5)) +' row(s)')
	if @WrongRows=0
		print('All row(s) inserted followed Rule 3')
end
go

---------------------------------------------------------------------------------
--**************************** RULE 4 ****************************************--
---------------------------------------------------------------------------------
-- INSERT RULE 4

create or alter trigger trig4_insert
on ITEMS
after insert
as 
begin
	declare @TotalInserted int;
	declare @WrongRows int;

	delete ITEMS
	from inserted i
	where ITEMS.IDITEM=i.IDITEM and ( (i.[USE] = 'Resell' and (i.IDDESTINATIONSTORE is null or i.PRICE is null or i.PREMIUM is null or i.IDCATEGORY is null or i.IDSUBCATEGORY is null) ) -- resell constraint
	or (i.[USE] = 'Reuse' and i.IDSOCIALPROJECT is null) )-- reuse constraint

	set @WrongRows = @@ROWCOUNT;
	set @TotalInserted = (select count(*) from inserted);

	if @WrongRows>0
		print('A total of ' + cast( @WrongRows as nvarchar(5)) + ' row(s) did not follow the Rule 4. So only '+ cast( (@TotalInserted-@WrongRows) as nvarchar(5)) + 
		' row(s) were inserted, when trying to insert a total of ' +  cast( (@TotalInserted) as nvarchar(5)) +' row(s)')
	if @WrongRows=0
		print('All row(s) inserted followed Rule 4')
end
go

---------------------------------------------------------------------------------
--**************************** RULE 5 ****************************************--
---------------------------------------------------------------------------------
-- INSERT RULE 5
create or alter trigger trig5_insert
on ITEMS
after insert
as
begin

	declare @TotalInserted int;
	declare @WrongRows int;

	delete ITEMS
	from inserted i
	where i.IDITEM=ITEMS.IDITEM
		and i.IDITEM in ( select i.IDITEM
						from STORES s1
						join inserted i
							on s1.IDSTORE=i.IDDESTINATIONSTORE
						join ORIGINOFGOODS og
							on og.IDORIGIN=i.IDORIGIN
						join  STORES s2
							on s2.IDSTORE=og.IDORIGIN
						where s2.IDNDC<>s1.IDNDC

						union

						select i.IDITEM
						from STORES s1
						join inserted i
							on s1.IDSTORE=i.IDDESTINATIONSTORE
						join ORIGINOFGOODS og
							on og.IDORIGIN=i.IDORIGIN
						join CONTAINERS c
							on c.IDCONTAINER=og.IDORIGIN
						join WAREHOUSES w
							on w.IDWAREHOUSE=c.IDWAREHOUSE
						where w.IDNDC<>s1.IDNDC )

	set @WrongRows = @@ROWCOUNT;
	set @TotalInserted = (select count(*) from inserted);

	if @WrongRows>0
		print('A total of ' + cast( @WrongRows as nvarchar(5)) + ' row(s) did not follow the Rule 5. So only '+ cast( (@TotalInserted-@WrongRows) as nvarchar(5)) + 
		' row(s) were inserted, when trying to insert a total of ' +  cast( (@TotalInserted) as nvarchar(5)) +' row(s)')
	if @WrongRows=0
		print('All row(s) inserted followed Rule 5')

end
go

---------------------------------------------------------------------------------
--************************ RULE 2/3/4/5 ***************************************--
---------------------------------------------------------------------------------
-- UPDATE RESTRAINS
create or alter trigger UPDATE_ITEMS_TRIGGER1
on ITEMS
after UPDATE
as
	-------RULE2
	declare @price_regular int;
	declare @price_countdown int;

    update ITEMS
	set PRICEOFSALE = (i.PRICE-i.PRICE*cast(pri.DISCOUNTPERCENTAGE as float)/100)
	from INSERTED i, PROMOITEMS pri, PROMOTIONS p, deleted d
	where pri.IDITEM=i.IDITEM and p.IDPROMOTION=pri.IDPROMOTION and p.TYPEOFPROMOTION = 'Regular' and ITEMS.IDITEM=i.IDITEM 
	and d.IDITEM=ITEMS.IDITEM and d.DATE_OF_SALE is null and i.DATE_OF_SALE is not null and (i.DATE_OF_SALE between p.STARTDATE and p.ENDDATE)
	
	set @price_regular = @@ROWCOUNT;

	if @price_regular>0
		print('The price of sale was updated accordlingly to the discount active')
	else
		print('Date of Sale was not updated / No Promotions Active')

	update ITEMS
	set PRICEOFSALE = ( case 
							when (p.STARTINGPRICE-DATEDIFF(day,p.STARTDATE, i.DATE_OF_SALE)*p.PRICEREDUCTIONPERDAY < p.FINALPRICE) then p.FINALPRICE
							else (p.STARTINGPRICE-DATEDIFF(day,p.STARTDATE, i.DATE_OF_SALE)*p.PRICEREDUCTIONPERDAY )
							end)
	from INSERTED i, PROMOITEMS pri, PROMOTIONS p, deleted d
	where pri.IDITEM=i.IDITEM and p.IDPROMOTION=pri.IDPROMOTION and p.TYPEOFPROMOTION = 'Countdown' and ITEMS.IDITEM=i.IDITEM 
	and d.IDITEM=ITEMS.IDITEM and d.DATE_OF_SALE is null and i.DATE_OF_SALE is not null and (i.DATE_OF_SALE between p.STARTDATE and p.ENDDATE)

	set @price_countdown = @@ROWCOUNT;

	if @price_countdown>0
		print('The price of sale was updated accordlingly to the discount active')
	else
		print('Date of Sale was not updated / No Promotions Active')

	-------RULE3
	declare @wrong_premium_regular int;

	update ITEMS
	set ITEMS.IDSIZE=d.IDSIZE, ITEMS.IDORIGIN=d.IDORIGIN, ITEMS.IDSOCIALPROJECT=d.IDSOCIALPROJECT, ITEMS.IDCATEGORY=d.IDCATEGORY,
		ITEMS.IDSUBCATEGORY=d.IDSUBCATEGORY, ITEMS.IDDESTINATIONSTORE=d.IDDESTINATIONSTORE, ITEMS.DATE_OF_ENTRANCE_IN_NDC=d.DATE_OF_ENTRANCE_IN_NDC,
		ITEMS.DATE_OF_EXIT_FROM_THE_NDC=d.DATE_OF_EXIT_FROM_THE_NDC, ITEMS.DATE_OF_SALE=d.DATE_OF_SALE, ITEMS.[USE]=d.[USE], ITEMS.PRICE=d.PRICE,
		ITEMS.PRICEOFSALE=d.PRICEOFSALE, ITEMS.PREMIUM=d.PREMIUM, ITEMS.BRAND=d.BRAND, ITEMS.SEASON=d.SEASON
	from deleted d join inserted i
		on d.IDITEM=i.IDITEM
	join STORES s
		on i.IDDESTINATIONSTORE=s.IDSTORE
	where d.IDITEM=ITEMS.IDITEM and ( (s.STORETYPE='premium' and i.PREMIUM=0) or (s.STORETYPE='regular' and i.PREMIUM=1) )

	set @wrong_premium_regular = @@ROWCOUNT

	if @wrong_premium_regular>0
		print(cast(@wrong_premium_regular as nvarchar(5)) + ' row(s) was(were) updated to the original values, since they did not follow the Rule 3')
	else
		print('All updates followed the restrains of Rule 3')

	-------RULE4
	declare @wrong_resell int;
	declare @wrong_reuse int;

	update ITEMS
	set ITEMS.[USE]=d.[USE], ITEMS.IDDESTINATIONSTORE=d.IDDESTINATIONSTORE, ITEMS.PRICE=d.PRICE, ITEMS.PREMIUM=d.PREMIUM, 
		ITEMS.IDCATEGORY=d.IDCATEGORY, ITEMS.IDSUBCATEGORY=d.IDSUBCATEGORY
	from inserted i, deleted d
	where i.IDITEM=ITEMS.IDITEM and d.IDITEM=ITEMS.IDITEM and i.[USE]='Resell' and (i.IDDESTINATIONSTORE is null or i.PRICE is null
	or i.PREMIUM is null or i.IDCATEGORY is null or i.IDSUBCATEGORY is null) -- resell constraint

	set @wrong_resell = @@ROWCOUNT
	
	if @wrong_resell>0
		print(cast(@wrong_resell as nvarchar(5)) + ' row(s) was(were) updated to the original value(s), since they did not follow the resell constraints  of Rule 4')
	else
		print('All updates followed the resell restrains of Rule 4')

	update ITEMS
	set ITEMS.[USE]=d.[USE], ITEMS.IDSOCIALPROJECT=d.IDSOCIALPROJECT
	from inserted i, deleted d
	where i.IDITEM=ITEMS.IDITEM and d.IDITEM=ITEMS.IDITEM and i.[USE]='Reuse' and i.IDSOCIALPROJECT is null

	set @wrong_reuse = @@ROWCOUNT

	if @wrong_reuse>0
		print(cast(@wrong_reuse as nvarchar(5)) + ' row(s) was(were) updated to the original value(s), since they did not follow the reuse constraints of Rule 4')
	else
		print('All updates followed the reuse restrains of Rule 4')

	-------RULE 5
	declare @WrongRowsNDC int;

	update ITEMS
	set ITEMS.IDDESTINATIONSTORE=i.IDDESTINATIONSTORE
	from inserted i, deleted d
	where i.IDITEM=ITEMS.IDITEM and d.IDITEM=ITEMS.IDITEM
		and i.IDITEM in ( select i.IDITEM
						from STORES s1
						join inserted i
							on s1.IDSTORE=i.IDDESTINATIONSTORE
						join ORIGINOFGOODS og
							on og.IDORIGIN=i.IDORIGIN
						join  STORES s2
							on s2.IDSTORE=og.IDORIGIN
						where s2.IDNDC<>s1.IDNDC

						union

						select i.IDITEM
						from STORES s1
						join inserted i
							on s1.IDSTORE=i.IDDESTINATIONSTORE
						join ORIGINOFGOODS og
							on og.IDORIGIN=i.IDORIGIN
						join CONTAINERS c
							on c.IDCONTAINER=og.IDORIGIN
						join WAREHOUSES w
							on w.IDWAREHOUSE=c.IDWAREHOUSE
						where w.IDNDC<>s1.IDNDC )

	set @WrongRowsNDC=@@ROWCOUNT;

	if @WrongRowsNDC>0
		print(cast(@wrongRowsNDC as nvarchar(5)) + ' row(s) was(were) updated to the original value(s), since they did not follow the constraints of Rule 5')
	else
		print('All updates followed the reuse restraints of Rule 5')

go