--Drop procedures, views, formulas
drop function if exists MonthlyOrders
go

drop view if exists OutstandingOrders
go

drop procedure if exists InventoryAddition
go

drop procedure if exists InventorySubtraction
go

drop function if exists OrderReport
go

--drop tables
--Drop Orders Table
drop table if exists Orders
go

--Drop Customer Table
drop table if exists Customer 
go

--Drop ComputerKitParts Table
drop table if exists ComputerKitParts
go

--Drop ComputerKit Table
drop table if exists ComputerKit
go

--Drop KitType Table
drop table if exists KitType
go

--Drop Inventory Table
drop table if exists Inventory
go

--Drop CosmoOrders Table
drop table if exists CosmoOrders
go

--Drop Parts Table
drop table if exists Parts
go

--Drop PartsTier Table
drop table if exists PartTier
go

--Drop PartType Table
drop table if exists PartType
go

--Create PartType table
create table PartType (
PartTypeID int identity,
PartName varchar(30) not null, 
constraint PK_PartType Primary Key (PartTypeID)
)
go

--Create PartTier table
create table PartTier (
PartTierID int identity,
Tier varchar(1) not null,
constraint PK_PartTier primary key (PartTierID)
)
go

--Create Parts table
create table Parts (
PartID int identity,
Part varchar(20),
PartTypeID int not null,
PartTierID int not null,
constraint PK_Part primary key (PartID),
constraint FK1_Part foreign key (PartTypeID) references PartType(PartTypeID),
constraint FK2_Part foreign key (PartTierID) references PartTier(PartTierID)
)
go

--Create CosmoOrders table
create table CosmoOrders (
CosmoID int identity, 
DatePurchased date not null default GetDate(),
QuantityPurchased numeric not null,
PartID int,
constraint PK_CosmoID primary key (CosmoID),
constraint FK1_CosmoID foreign key (PartID) references Parts(PartID)
)
go

--Create Inventory table
create table Inventory (
InventoryID int identity, 
PartID int,
Part varchar(20),
AmountOnHand numeric not null,
ReOrderPoint numeric not null,
constraint PK_Inventory primary key (InventoryID),
constraint FK1_Inventory foreign key (PartID) references Parts(PartID),
)
go

--Create KitType table
create table KitType (
KitTypeID int identity, 
KitType varchar(15) not null,
constraint PK_KitType primary key (KitTypeID)
)
go

--Create ComputerKit table
create table ComputerKit (
ComputerKitID int identity, 
KitTypeID int not null,
constraint PK_ComputerKit primary key (ComputerKitID),
constraint FK_ComputerKit foreign key (KitTypeID) references KitType(KitTypeID)
)
go

--Create ComputerKitParts table
create table ComputerKitParts (
ComputerKitPartsID int identity, 
ComputerKitID int not null,
PartID int not null,
constraint PK_ComputerKitParts primary key (ComputerKitPartsID),
constraint FK1_ComputerKitParts foreign key (ComputerKitID) references ComputerKit(ComputerKitID),
constraint FK2_ComputerKitParts foreign key (PartID) references Parts(PartID)
)
go

--Create Orders table
create table Orders (
OrdersID int identity, 
ComputerKitID int not null,
CustomerID int not null,
OrderDate datetime default GetDate(),
DeliveryDate datetime default GetDate(),
TimeToDelivery numeric,
constraint PK_Orders primary key (OrdersID)
)
go

--Create Customer table
create table Customer (
CustomerID int identity, 
CustName varchar(30) not null, 
Phone varchar(10) not null,
Email varchar(30) not null, 
MailingAddress varchar(50) not null,
PaymentMethod varchar(20) not null,
constraint PK_Customer primary key (CustomerID),
)
go

alter table Orders add constraint
FK1_Orders foreign key (CustomerID) references Customer(CustomerID)
go

--Insert PartType values
insert into PartType (PartName) values ('Motherboard lvl 1'), ('Motherboard lvl 2'), ('Motherboard lvl 3'),
('Case lvl 1'), ('Case lvl 2'), ('Case lvl 3'),
('Processor lvl 1'), ('Processor lvl 2'), ('Processor lvl 3'),
('Ram lvl 1'), ('Ram lvl 2'), ('Ram lvl 3'), 
('Storage lvl 1'), ('Storage lvl 2'), ('Storage lvl 3'),
('Graphics lvl 1'), ('Graphics lvl 2'), ('Graphics lvl 3'),
('Cooling lvl 1'), ('Cooling lvl 2'), ('Cooling lvl 3')
go

--Insert PartTier values
insert into PartTier (Tier) values ('1'), ('2'), ('3')
go

--Insert Parts values
insert into Parts (PartTypeID, PartTierID) values ('1', '1'), ('2', '2'), ('3', '3'), 
('4', '1'), ('5', '2'), ('6', '3'), 
('7', '1'), ('8', '2'), ('9', '3'),
('10', '1'), ('11', '2'), ('12', '3'), 
('13', '1'), ('14', '2'), ('15', '3'), 
('16', '1'), ('17', '2'), ('18', '3'),
('19', '1'), ('20', '2'), ('21', '3')
go

--Insert CosmoOrders values
insert into CosmoOrders (DatePurchased, QuantityPurchased, PartID) values ('01/01/2020', '3', '1'), ('01/01/2020', '3', '2'), ('01/01/2020', '3', '3'), 
('01/01/2020', '3', '4'), ('01/01/2020', '3', '5'), ('01/01/2020', '3', '6'),
('01/01/2020', '4', '7'), ('01/01/2020', '4', '8'), ('01/01/2020', '4', '9'),
('01/01/2020', '4', '10'), ('01/01/2020', '4', '11'), ('01/01/2020', '4', '12'),
('01/01/2020', '3', '13'), ('01/01/2020', '3', '14'), ('01/01/2020', '3', '15'),
('01/01/2020', '2', '16'), ('01/01/2020', '2', '17'), ('01/01/2020', '2', '18'),
('01/01/2020', '2', '19'), ('01/01/2020', '2', '20'), ('01/01/2020', '2', '21')
go

--Update Parts table with Part names
update Parts set Part = 'Motherboard lvl 1' where PartID = 1
update Parts set Part = 'Motherboard lvl 2' where PartID = 2
update Parts set Part = 'Motherboard lvl 3' where PartID = 3
update Parts set Part = 'Case lvl 1' where PartID = 4
update Parts set Part = 'Case lvl 2' where PartID = 5
update Parts set Part = 'Case lvl 3' where PartID = 6
update Parts set Part = 'Processor lvl 1' where PartID = 7
update Parts set Part = 'Processor lvl 2' where PartID = 8
update Parts set Part = 'Processor lvl 3' where PartID = 9
update Parts set Part = 'RAM lvl 1' where PartID = 10
update Parts set Part = 'RAM lvl 2' where PartID = 11
update Parts set Part = 'RAM lvl 3' where PartID = 12
update Parts set Part = 'Storage lvl 1' where PartID = 13
update Parts set Part = 'Storage lvl 2' where PartID = 14
update Parts set Part = 'Storage lvl 3' where PartID = 15
update Parts set Part = 'Graphics lvl 1' where PartID = 16
update Parts set Part = 'Graphics lvl 2' where PartID = 17
update Parts set Part = 'Graphics lvl 3' where PartID = 18
update Parts set Part = 'Cooling lvl 1' where PartID = 19
update Parts set Part = 'Cooling lvl 2' where PartID = 20
update Parts set Part = 'Cooling lvl 3' where PartID = 21
go

--Insert KitType values
insert into KitType(KitType) values ('Office lvl 1'), ('Office lvl 2'), 
('Office lvl 3'), ('Gaming lvl 1'), ('Gaming lvl 2'), ('Gaming lvl 3')
go

--Insert ComputerKit values
insert into ComputerKit values (1), (2), (3), (4), (5), (6)
go

--Insert ComputerKitParts values
insert into ComputerKitParts(ComputerKitID, PartID) values 
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select PartID from Parts where Part = 'Motherboard lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select PartID from Parts where Part = 'Case lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select PartID from Parts where Part = 'Processor lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select PartID from Parts where Part = 'RAM lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select PartID from Parts where Part = 'Storage lvl 1' )),
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select PartID from Parts where Part = 'Motherboard lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select PartID from Parts where Part = 'Case lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select PartID from Parts where Part = 'Processor lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select PartID from Parts where Part = 'RAM lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select PartID from Parts where Part = 'Storage lvl 2' )),
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select PartID from Parts where Part = 'Motherboard lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select PartID from Parts where Part = 'Case lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select PartID from Parts where Part = 'Processor lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select PartID from Parts where Part = 'RAM lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select PartID from Parts where Part = 'Storage lvl 3' )),
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'Motherboard lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'Case lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'Processor lvl 1' )),
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'RAM lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'Storage lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'Graphics lvl 1' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select PartID from Parts where Part = 'Cooling lvl 1' )),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'Motherboard lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'Case lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'Processor lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'RAM lvl 2' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'Storage lvl 2' )),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'Graphics lvl 2' )),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select PartID from Parts where Part = 'Cooling lvl 2' )),
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'Motherboard lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'Case lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'Processor lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'RAM lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'Storage lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'Graphics lvl 3' )), 
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select PartID from Parts where Part = 'Cooling lvl 3' ))
go

--Insert Inventory values
insert into Inventory(PartID, Part, AmountOnHand, ReOrderPoint) values 
((select PartID from Parts where Part = 'Motherboard lvl 1'), (select Part from Parts where PartID = 1), 6, 3), 
((select PartID from Parts where Part = 'Motherboard lvl 2'), (select Part from Parts where PartID = 2), 4, 3), 
((select PartID from Parts where Part = 'Motherboard lvl 3'), (select Part from Parts where PartID = 3), 3, 3),
((select PartID from Parts where Part = 'Case lvl 1'), (select Part from Parts where PartID = 4), 7, 3), 
((select PartID from Parts where Part = 'Case lvl 2'), (select Part from Parts where PartID = 5), 4, 3), 
((select PartID from Parts where Part = 'Case lvl 3'), (select Part from Parts where PartID = 6), 3, 3),
((select PartID from Parts where Part = 'Processor lvl 1'), (select Part from Parts where PartID = 7), 7, 4), 
((select PartID from Parts where Part = 'Processor lvl 2'), (select Part from Parts where PartID = 8), 5, 4), 
((select PartID from Parts where Part = 'Processor lvl 3'), (select Part from Parts where PartID = 9), 4, 4),
((select PartID from Parts where Part = 'RAM lvl 1'), (select Part from Parts where PartID = 10), 8, 4), 
((select PartID from Parts where Part = 'RAM lvl 2'), (select Part from Parts where PartID = 11), 5, 4), 
((select PartID from Parts where Part = 'RAM lvl 3'), (select Part from Parts where PartID = 12), 4, 4),
((select PartID from Parts where Part = 'Storage lvl 1'), (select Part from Parts where PartID = 13), 6, 4), 
((select PartID from Parts where Part = 'Storage lvl 2'), (select Part from Parts where PartID = 14), 5, 4), 
((select PartID from Parts where Part = 'Storage lvl 3'), (select Part from Parts where PartID = 15), 4, 4),
((select PartID from Parts where Part = 'Graphics lvl 1'), (select Part from Parts where PartID = 16), 5, 2), 
((select PartID from Parts where Part = 'Graphics lvl 2'), (select Part from Parts where PartID = 17), 4, 2), 
((select PartID from Parts where Part = 'Graphics lvl 3'), (select Part from Parts where PartID = 18), 3, 2),
((select PartID from Parts where Part = 'Cooling lvl 1'), (select Part from Parts where PartID = 19), 5, 2), 
((select PartID from Parts where Part = 'Cooling lvl 2'), (select Part from Parts where PartID = 20), 4, 2), 
((select PartID from Parts where Part = 'Cooling lvl 3'), (select Part from Parts where PartID = 21), 3, 2)
go

-- existing customers before the new year
insert into Customer(CustName, Phone, Email, MailingAddress, PaymentMethod) values
('John Johnson', '5555555', 'johnj@email.com', '123 Smith St.', 'Credit Card'),
('Silvia Green', '6660000', 'sgreen@email.com', '246 Ace Rd.', 'Credit Card'),
('Boris Smith', '1006611', 'Bsmith@email.com', '157 Green Dr.', 'Cash'),
('Yancy Day', '1113399', 'YDay@email.com', '357 Day Dr.', 'Debit Card'),
('Steve Bruce', '3339999', 'Brucey@email.com', '468 Spruce Ct.', 'Cash'),
('Yennifer North', '5555533', 'Yenn@email.com', '3456 Spring Ct.', 'Credit Card'),
('Lenny Boy', '2222222', 'Lenny6@email.com', '5555 Spring Ct.', 'Check'),
('Victoria Smek', '4444444', 'vicsmek@email.com', '235 Right Way', 'Cash'),
('Truit Russ', '4444455', 'truitbusiness@email.com', '356 Industry Dr.', 'Credit Card'),
('Holly Flax', '5559988', 'Hflax@email.com', '4367 Forest Dr.', 'Credit Card')
go

--first orders of the new year
insert into Orders(ComputerKitID, CustomerID, OrderDate, DeliveryDate, TimeToDelivery) values
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select CustomerID from Customer where CustName = 'Steve Bruce'), '01/05/2020', '01/09/2020', 4),
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select CustomerID from Customer where CustName = 'Yennifer North'), '01/06/2020', '01/10/2020', 4),
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select CustomerID from Customer where CustName = 'Lenny Boy'), '01/03/2020', '01/06/2020', 3),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select CustomerID from Customer where CustName = 'Victoria Smek'), '01/07/2020', '01/11/2020', 4),
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select CustomerID from Customer where CustName = 'Silvia Green'), '02/01/2020', '02/04/2020', 3),
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select CustomerID from Customer where CustName = 'Boris Smith'), '02/05/2020', '02/09/2020', 3)
go

--function to return previous orders for specific parts ordered by date
create function OrderReport 
(
@Part varchar(20)
)
returns table
as
return 
	select ComputerKitParts.PartID, Orders.ComputerKitID, Orders.OrdersID, Orders.OrderDate, Parts.Part from ComputerKitParts
	inner join Orders on ComputerKitParts.ComputerKitID = Orders.ComputerKitID
	join Parts on Parts.PartID = ComputerKitParts.PartID
where Parts.Part = @Part
go


--procedure to subtract from inventory
create or alter procedure InventorySubtraction(@PartName varchar(20), @AmountOrdered int, @AmountOnHand int) as
begin
update Inventory set AmountOnHand = (@AmountOnHand - @AmountOrdered)
where AmountOnHand = @AmountOnHand and Part = @PartName
return scope_identity()
end
go

--procedure to add to inventory
create or alter procedure InventoryAddition(@PartName varchar(20), @AmountOrdered int, @AmountOnHand int) as
begin
update Inventory set AmountOnHand = (@AmountOnHand + @AmountOrdered)
where AmountOnHand = @AmountOnHand and Part = @PartName
return scope_identity()
end
go

--A view for Ralph to use to see his currently outstanding orders
create view OutstandingOrders as
(
select * from Orders where DeliveryDate is null and TimeToDelivery is null
)
go

--Function to gather parts ordered by month
create or alter function MonthlyOrders 
(
@Month datetime
)
returns table
as
return
select Orders.ComputerKitID, ComputerKitParts.PartID, Parts.Part, Orders.DeliveryDate, 
ROW_NUMBER() OVER (order by Part) AS RowNum
from Orders
join ComputerKitParts on Orders.ComputerKitID = ComputerKitParts.ComputerKitID
join Parts on Parts.PartID = ComputerKitParts.PartID
where DeliveryDate > @Month
go



--Subtracting first orders from Inventory
exec InventorySubtraction 'Case lvl 1', 3, 7
go
exec InventorySubtraction 'Case lvl 2', 2, 4
go
exec InventorySubtraction 'Case lvl 3', 1, 3
go
exec InventorySubtraction 'Cooling lvl 1', 1, 5
go
exec InventorySubtraction 'Cooling lvl 2', 1, 4
go
exec InventorySubtraction  'Cooling lvl 3', 1, 3
go
exec InventorySubtraction 'Graphics lvl 1', 1, 5
go
exec InventorySubtraction 'Graphics lvl 2', 1, 4
go
exec InventorySubtraction 'Graphics lvl 3', 1, 3
go
exec InventorySubtraction 'Motherboard lvl 1', 3, 6
go
exec InventorySubtraction 'Motherboard lvl 2', 2, 4
go
exec InventorySubtraction 'Motherboard lvl 3', 1, 3
go
exec InventorySubtraction 'Processor lvl 1', 3, 7
go
exec InventorySubtraction 'Processor lvl 2', 2, 5
go
exec InventorySubtraction 'Processor lvl 3', 1, 4
go
exec InventorySubtraction 'RAM lvl 1', 2, 8
go
exec InventorySubtraction 'RAM lvl 2', 2, 5
go
exec InventorySubtraction 'RAM lvl 3', 2, 4
go
exec InventorySubtraction 'Storage lvl 1', 2, 6
go
exec InventorySubtraction 'Storage lvl 2', 2, 5
go
exec InventorySubtraction 'Storage lvl 3', 2, 4
go

--Ralph has hit some re-order points, so he puts in a CosmoOrder
--and uses the InventoryAddition function
insert into CosmoOrders (DatePurchased, QuantityPurchased, PartID) values
('02/10/2020', 3, (select PartID from Parts where Part = 'Motherboard lvl 1')), ('02/10/2020', 4, (select PartID from Parts where Part = 'Motherboard lvl 2')),
('02/10/2020', 3, (select PartID from Parts where Part = 'Motherboard lvl 3')), ('02/10/2020', 4, (select PartID from Parts where Part = 'Case lvl 2')), 
('02/10/2020', 2, (select PartID from Parts where Part = 'Case lvl 3')), ('02/10/2020', 3, (select PartID from Parts where Part = 'Processor lvl 1')),
('02/10/2020', 3, (select PartID from Parts where Part = 'Processor lvl 2')), ('02/10/2020', 2, (select PartID from Parts where Part = 'Processor lvl 3')), 
('02/10/2020', 3, (select PartID from Parts where Part = 'RAM lvl 2')), ('02/10/2020', 4, (select PartID from Parts where Part = 'RAM lvl 3')), 
('02/10/2020', 2, (select PartID from Parts where Part = 'Storage lvl 1')), ('02/10/2020', 3, (select PartID from Parts where Part = 'Storage lvl 2')), 
('02/10/2020', 4, (select PartID from Parts where Part = 'Storage lvl 3')), ('02/10/2020', 2, (select PartID from Parts where Part = 'Graphics lvl 3')), 
('02/10/2020', 2, (select PartID from Parts where Part = 'Cooling lvl 3'))
go

exec InventoryAddition 'Motherboard lvl 1', 3, 3
go
exec InventoryAddition 'Motherboard lvl 2', 4, 2
go
exec InventoryAddition 'Motherboard lvl 3', 3, 2
go
exec InventoryAddition 'Case lvl 2', 4, 2
go
exec InventoryAddition 'Case lvl 3', 2, 2
go
exec InventoryAddition 'Processor lvl 2', 3, 3
go
exec InventoryAddition 'Processor lvl 3', 2, 3
go
exec InventoryAddition 'RAM lvl 2', 3, 3
go
exec InventoryAddition 'RAM lvl 3', 4, 2
go
exec InventoryAddition 'Storage lvl 1', 2, 4
go
exec InventoryAddition 'Storage lvl 2', 3, 3
go
exec InventoryAddition 'Storage lvl 3', 4, 2
go
exec InventoryAddition 'Graphics lvl 3', 2, 2
go
exec InventoryAddition 'Cooling lvl 3', 2, 2
go

--A couple customers changed some info!
update Customer set Phone = 55565555, MailingAddress = '34567 John Drive'
where CustomerID = 1
update Customer set CustName = 'Silvia Johnson', MailingAddress = '34567 John Drive'
where CustomerID = 1
update Customer set PaymentMethod = 'Cash'
where CustomerID = 6
go

--inserting more orders
insert into Orders(ComputerKitID, CustomerID, OrderDate, DeliveryDate, TimeToDelivery) values
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '02/12/2020', '02/16/2020', 4),
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select CustomerID from Customer where CustName = 'Boris Smith'), '02/12/2020', '02/16/2020', 4),
((select ComputerKitID from ComputerKit where KitTypeID = 1), (select CustomerID from Customer where CustName = 'Truit Russ'), '02/14/2020', '02/16/2020', 2),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select CustomerID from Customer where CustName = 'Holly Flax'), '02/18/2020', '02/21/2020', 3),
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select CustomerID from Customer where CustName = 'Yennifer North'), '02/19/2020', '02/24/2020', 5),
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select CustomerID from Customer where CustName = 'Yancy Day'), '02/20/2020', '02/24/2020', 4)
go

--Subtracting second orders from Inventory
exec InventorySubtraction 'Case lvl 1', 3, 4
go
exec InventorySubtraction 'Case lvl 2', 2, 6
go
exec InventorySubtraction 'Case lvl 3', 1, 4
go
exec InventorySubtraction 'Cooling lvl 1', 1, 4
go
exec InventorySubtraction 'Cooling lvl 2', 1, 3
go
exec InventorySubtraction  'Cooling lvl 3', 1, 4
go
exec InventorySubtraction 'Graphics lvl 1', 1, 4
go
exec InventorySubtraction 'Graphics lvl 2', 1, 3
go
exec InventorySubtraction 'Graphics lvl 3', 1, 4
go
exec InventorySubtraction 'Motherboard lvl 1', 3, 6
go
exec InventorySubtraction 'Motherboard lvl 2', 2, 6
go
exec InventorySubtraction 'Motherboard lvl 3', 1, 5
go
exec InventorySubtraction 'Processor lvl 1', 3, 4
go
exec InventorySubtraction 'Processor lvl 2', 2, 6
go
exec InventorySubtraction 'Processor lvl 3', 1, 5
go
exec InventorySubtraction 'RAM lvl 1', 3, 6
go
exec InventorySubtraction 'RAM lvl 2', 1, 6
go
exec InventorySubtraction 'RAM lvl 3', 2, 6
go
exec InventorySubtraction 'Storage lvl 1', 3, 6
go
exec InventorySubtraction 'Storage lvl 2', 1, 6
go
exec InventorySubtraction 'Storage lvl 3', 2, 4
go

--2nd CosmoOrder of the New Year
insert into CosmoOrders (DatePurchased, QuantityPurchased, PartID) values
('02/25/2020', 6, (select PartID from Parts where Part = 'Motherboard lvl 1')), ('02/25/2020', 6, (select PartID from Parts where Part = 'Case lvl 1')), 
('02/25/2020', 3, (select PartID from Parts where Part = 'Case lvl 3')), ('02/25/2020', 6, (select PartID from Parts where Part = 'Processor lvl 1')), 
('02/25/2020', 2, (select PartID from Parts where Part = 'Processor lvl 2')), ('02/25/2020', 2, (select PartID from Parts where Part = 'Processor lvl 3')),
('02/25/2020', 6, (select PartID from Parts where Part = 'RAM lvl 1')), ('02/25/2020', 3, (select PartID from Parts where Part = 'RAM lvl 3')),
('02/25/2020', 4, (select PartID from Parts where Part = 'Storage lvl 1')), ('02/25/2020', 2, (select PartID from Parts where Part = 'Graphics lvl 2')), 
('02/25/2020', 2, (select PartID from Parts where Part = 'Cooling lvl 2'))
go

--Adding new parts into inventory
exec InventoryAddition 'Motherboard lvl 1', 6, 3
go
exec InventoryAddition 'Case lvl 1', 6, 1
go
exec InventoryAddition 'Case lvl 3', 3, 3
go
exec InventoryAddition 'Processor lvl 1', 6, 1
go
exec InventoryAddition 'Processor lvl 2', 2, 4
go
exec InventoryAddition 'Processor lvl 3', 2, 4
go
exec InventoryAddition 'RAM lvl 1', 6, 3
go
exec InventoryAddition 'RAM lvl 3', 3, 4
go
exec InventoryAddition 'Storage lvl 1', 4, 3
go
exec InventoryAddition 'Storage lvl 2', 4, 3
go
exec InventoryAddition 'Graphics lvl 2', 2, 2
go
exec InventoryAddition 'Cooling lvl 2', 2, 2
go

--March Orders!
insert into Orders(ComputerKitID, CustomerID, OrderDate, DeliveryDate, TimeToDelivery) values
((select ComputerKitID from ComputerKit where KitTypeID = 2), (Select CustomerID from Customer where CustName = 'Lenny Boy'), '03/01/2020', '03/04/2020', 3),
((select ComputerKitID from ComputerKit where KitTypeID = 3), (Select CustomerID from Customer where CustName = 'Victoria Smek'), '03/03/2020', '03/06/2020', 3),
((select ComputerKitID from ComputerKit where KitTypeID = 1), (Select CustomerID from Customer where CustName = 'Truit Russ'), '03/10/2020', '03/12/2020', 2),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (Select CustomerID from Customer where CustName = 'Holly Flax'), '03/15/2020', '03/18/2020', 3),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (Select CustomerID from Customer where CustName = 'Yennifer North'), '03/17/2020', '03/21/2020', 4),
((select ComputerKitID from ComputerKit where KitTypeID = 4), (Select CustomerID from Customer where CustName = 'Steve Bruce'), '03/21/2020', '03/24/2020', 3)
go

--Final inventory subtraction
exec InventorySubtraction 'Case lvl 1', 3, 7
go
exec InventorySubtraction 'Case lvl 2', 3, 4
go
exec InventorySubtraction 'Case lvl 3', 1, 4
go
exec InventorySubtraction 'Cooling lvl 1', 1, 3
go
exec InventorySubtraction 'Cooling lvl 2', 2, 4
go
exec InventorySubtraction 'Graphics lvl 1', 1, 3
go
exec InventorySubtraction 'Graphics lvl 2', 2, 4
go
exec InventorySubtraction 'Motherboard lvl 1', 3, 9
go
exec InventorySubtraction 'Motherboard lvl 2', 3, 4
go
exec InventorySubtraction 'Processor lvl 1', 3, 7
go
exec InventorySubtraction 'Processor lvl 2', 3, 6
go
exec InventorySubtraction 'RAM lvl 1', 2, 9
go
exec InventorySubtraction 'RAM lvl 2', 3, 5
go
exec InventorySubtraction 'RAM lvl 3', 1, 7
go
exec InventorySubtraction 'Storage lvl 1', 2, 7
go
exec InventorySubtraction 'Storage lvl 3', 1, 6
go

--Final CosmoOrder
insert into CosmoOrders (DatePurchased, QuantityPurchased, PartID) values
('04/01/2020', 5, (select PartID from Parts where Part = 'Motherboard lvl 2' )), ('04/01/2020', 4, (select PartID from Parts where Part = 'Case lvl 2' )), 
('04/01/2020', 3, (select PartID from Parts where Part = 'Processor lvl 1' )),('04/01/2020', 3, (select PartID from Parts where Part = 'Processor lvl 2' )), 
('04/01/2020', 4, (select PartID from Parts where Part = 'RAM lvl 2' )), ('04/01/2020', 2, (select PartID from Parts where Part = 'Graphics lvl 1' )),
('04/01/2020', 2, (select PartID from Parts where Part = 'Graphics lvl 2' )), ('04/01/2020', 2, (select PartID from Parts where Part = 'Cooling lvl 1' )), 
('04/01/2020', 2, (select PartID from Parts where Part = 'Cooling lvl 2' ))
go

--Final Inventory Addition
exec InventoryAddition 'Motherboard lvl 2', 5, 1
go
exec InventoryAddition 'Case lvl 2', 4, 1
go
exec InventoryAddition 'Processor lvl 1', 3, 4
go
exec InventoryAddition 'Processor lvl 2', 3, 3
go
exec InventoryAddition 'RAM lvl 2', 4, 2
go
exec InventoryAddition 'Graphics lvl 1', 2, 2
go
exec InventoryAddition 'Graphics lvl 2', 2, 2
go
exec InventoryAddition 'Cooling lvl 1', 2, 2
go
exec InventoryAddition 'Cooling lvl 2', 2, 2
go

--Ralph's most popular order
select top 3
Count(Orders.ComputerKitID) as TotalKitsOrdered, KitType.KitType
from Orders 
join ComputerKit on Orders.ComputerKitID = ComputerKit.ComputerKitID
join KitType on KitType.KitTypeID = ComputerKit.KitTypeID
group by KitType.KitType
order by TotalKitsOrdered desc
--Ralph's Least Popular order
select top 3
Count(Orders.ComputerKitID) as TotalKitsOrdered, KitType.KitType
from Orders 
join ComputerKit on Orders.ComputerKitID = ComputerKit.ComputerKitID
join KitType on KitType.KitTypeID = ComputerKit.KitTypeID
group by KitType.KitType
order by TotalKitsOrdered 

--Percentage breakdown of each product purchased from Ralph
select 
(Count(Orders.ComputerKitID)*100 / (select count (*) from Orders)) as PercentageTotal, KitType.KitType
from Orders 
join ComputerKit on Orders.ComputerKitID = ComputerKit.ComputerKitID
join KitType on KitType.KitTypeID = ComputerKit.KitTypeID
group by KitType.KitType
order by PercentageTotal desc

--Parts re-ordred the least
select top 5
count(CosmoOrders.PartID)  as TotalReOrdered, Parts.Part
from CosmoOrders
join Parts on CosmoOrders.PartID = Parts.PartID
group by Parts.Part
order by TotalReOrdered
--Part re-ordered the most
select top 5
count(CosmoOrders.PartID)  as TotalReOrdered, Parts.Part
from CosmoOrders
join Parts on CosmoOrders.PartID = Parts.PartID
group by Parts.Part
order by TotalReOrdered desc


--How many orders can Ralph handle with his current re-order points?
/*to do this, I had to subtract down the current inventory
counts to where his reorder points where to provide a more clear 
select result at the end of the orders. Without a more advanced 
inventory selection schema, I am left with counting the orders 
manually that would bring all parts down to 0, and inputting those 
InventorySubtracts so visualize this for answering the project question.
*/
exec InventorySubtraction 'Motherboard lvl 1', 3, 6
go
exec InventorySubtraction 'Motherboard lvl 2', 3, 6
go
exec InventorySubtraction 'Motherboard lvl 3', 1, 4
go
exec InventorySubtraction 'Case lvl 1', 1, 4
go
exec InventorySubtraction 'Case lvl 2', 2, 5
go
exec InventorySubtraction 'Case lvl 3', 3, 6
go
exec InventorySubtraction 'Processor lvl 1', 3, 7
go
exec InventorySubtraction 'Processor lvl 2', 2, 6
go
exec InventorySubtraction 'Processor lvl 3', 2, 6
go
exec InventorySubtraction 'RAM lvl 1', 3, 7
go
exec InventorySubtraction 'RAM lvl 2', 2, 6
go
exec InventorySubtraction 'RAM lvl 3', 2, 6
go
exec InventorySubtraction 'Storage lvl 1', 1, 5
go
exec InventorySubtraction 'Storage lvl 2', 1, 5
go
exec InventorySubtraction 'Storage lvl 3', 1, 5
go
exec InventorySubtraction 'Graphics lvl 1', 2, 4
go
exec InventorySubtraction 'Graphics lvl 2', 2, 4
go
exec InventorySubtraction 'Graphics lvl 3', 1, 3
go
exec InventorySubtraction 'Cooling lvl 1', 2, 4
go
exec InventorySubtraction 'Cooling lvl 2', 2, 4
go
exec InventorySubtraction 'Cooling lvl 3', 1, 3
go

/*Now for the orders! Using just gaming PC's we can
knock out a lot of the parts on hand. */
insert into Orders (ComputerKitID, CustomerID, OrderDate, DeliveryDate, TimeToDelivery)
values
((select ComputerKitID from ComputerKit where KitTypeID = 2), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/01/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 3), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/01/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/02/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 4), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/02/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/02/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 5), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/02/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/02/2020', 1),
((select ComputerKitID from ComputerKit where KitTypeID = 6), (select CustomerID from Customer where CustName = 'Silvia Johnson'), '06/01/2020', '06/02/2020', 1)


--The above translates into the following inventory subtractions
exec InventorySubtraction 'Motherboard lvl 1', 3, 3
go
exec InventorySubtraction 'Motherboard lvl 2', 3, 3
go
exec InventorySubtraction 'Motherboard lvl 3', 2, 3
go
exec InventorySubtraction 'Case lvl 1', 3, 3
go
exec InventorySubtraction 'Case lvl 2', 3, 3
go
exec InventorySubtraction 'Case lvl 3', 2, 3
go
exec InventorySubtraction 'Processor lvl 1', 3, 4
go
exec InventorySubtraction 'Processor lvl 2', 2, 4
go
exec InventorySubtraction 'Processor lvl 3', 3, 4
go
exec InventorySubtraction 'RAM lvl 1', 3, 4
go
exec InventorySubtraction 'RAM lvl 2', 3, 4
go
exec InventorySubtraction 'RAM lvl 3', 2, 4
go
exec InventorySubtraction 'Storage lvl 1', 3, 4
go
exec InventorySubtraction 'Storage lvl 2', 2, 4
go
exec InventorySubtraction 'Storage lvl 3', 3, 4
go
exec InventorySubtraction 'Graphics lvl 1', 2, 2
go
exec InventorySubtraction 'Graphics lvl 2', 2, 2
go
exec InventorySubtraction 'Graphics lvl 3', 1, 2
go
exec InventorySubtraction 'Cooling lvl 1', 2, 2
go
exec InventorySubtraction 'Cooling lvl 2', 2, 2
go
exec InventorySubtraction 'Cooling lvl 3', 1, 2
go

select * from Inventory
/*Based on this table, all it took was 8 orders to 
use enough parts to clear out Ralph's options. 
Ralph's current offerings leave him
unable to sell one of his 6 products. There are enough
parts to create a higher tier office PC out of the remainder,
however, that would involve him updating his offerings. Something
he may not have learned without using visual data!
*/

--Are there any products that Ralph should only buy parts for at a per order basis?
select sum(CosmoOrders.QuantityPurchased) as QuantityOfPartOrdered, Parts.Part
from CosmoOrders
join Parts on Parts.PartID = CosmoOrders.PartID
group by Part
Order by QuantityOfPartOrdered