-- insercao de dados para o banco de dados "ecommerce"
use ecommerce;

-- idClient, Fname, Minit, Lname, CPF, Address
insert into Clients(Fname, Minit, Lname, CPF, Address)
	values('Maria', 'M','Silva',12346789,'rua silva de prata,29,Carangola-cidade das flores'),
		  ('Matheus','O','Pimentel',987654321,'rua alemeda 289, Centro - cidade das flores'),
          ('Ricardo','F','Silva',45678913,'avenida alemeda vinha 1009, Centro - cidade das flores'),
          ('Julia','S','Franca',789123465,'rua laranjeiras 861, Centro - cidade das flores'),
          ('Roberta','G','Assis',987453176,'avenidade koller 19, Centro - cidade das flores'),
          ('Isabela','M','Cruz',987346711,'rua alameda das flores 28, Centro - Cidade das Flores');
          
-- idProduct, Pname, classification_kids, category('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis',
-- evaluation, size
insert into product (Pname, classification_kids, category, evaluation, size) 
	values('Fone de ouvido',false,'Eletronico','4',null),
		  ('Barbie elsa',true,'Brinquedos','3',null),
          ('Body carters',true,'Vestimenta','5',null),
          ('Microfone Vedo',false,'Eletronico','4',null),
          ('Sofa retratil',false,'Moveis','3','3x57x80'),
          ('Farinha de arroz',false,'Alimentos','2',null),
          ('Fire Stick Amazon',false,'Eletronico','3',null);
;
-- idOrder,idOrderClient,orderStatus,orderDescription,sendValue,paymentCash
insert into orders (idOrderClient,orderStatus,orderDescription,sendValue,paymentCash) values
	(1,default,'compra via aplicativo',null,1),
    (2,default,'compra via aplicativo',50,0),
    (3,'Confirmado',null,null,1),
    (4,default,'compra via web site',150,0);

-- idProductOrderProduct,idProductOrderOrder,productOrderQuantity,productOrderStatus
insert into productOrder (idProductOrderProduct,idProductOrderOrder,productOrderQuantity,productOrderStatus)
	values (1, 1, 2, null),
		   (2, 4, 1, null),
           (3, 3, 1, null);

-- adicionando produto a um pedido existente
insert into productOrder (idProductOrderProduct,idProductOrderOrder,productOrderQuantity,productOrderStatus)
    values (4,1,1,null);

-- idProdStorage,location,quantity
insert into productStorage (location,quantity)
	values ('Rio de Janeiro', 1000),
		   ('Rio de Janeiro', 500),
           ('Sao Paulo', 10),
           ('Sao Paulo', 100),
           ('Sao Paulo', 10),
           ('Brasilia', 60);

-- idLocationProduct,idLocationStorage,location
insert into storageLocation (idLocationProduct,idLocationStorage,location)
	values (1, 2, 'RJ'),
		   (2, 6, 'GO');

-- idSupplier,SocialName,CNPJ,contact
insert into supplier (SocialName, CNPJ, contact)
	values ('Almeida e filhos', 123456789012345,'21985474'),
		   ('Eletronicos Silva', 897654398088765,'21985484'),
           ('Eletronicos Velma', 879887609826675,'21975474');


-- idProductSupplier,idProductProduct,quantity
insert into productSupplier (idProductSupplier, idProductProduct, quantity)
	values (1,1,500),
		   (1,2,400),
           (2,4,633),
           (3,3,5),
           (2,5,10);
           
-- idSeller,SocialName,AbstName,CNPJ,CPF,location,contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact)
	values ('Tech eletronics',null,128799087678799,null,'Rio de Janeiro', 219946287),
		   ('Botique Durgas',null,null,123456789,'Rio de Janeiro',98788769018),
           ('Kids World',null,676577100907632,null,'Sao Paulo', 78788739205);

-- idProductSeller,idProductProduct,productQuantity
insert into productSeller (idProductSeller,idProductProduct,productQuantity)
	values (1,6,80),
		   (2,7,10);

-- Queries
-- Quais clientes realizaram um pedido?
select * from clients c, orders o where c.idClient = o.idOrderClient; 

-- Retorna clientes que realizaram um pedido e seu status de processamento
select concat(Fname,' ',Lname) as client_name, idOrder as request, orderStatus as status from clients c,
	orders o where c.idClient = idOrderClient;
    
-- Retorna o numero de clientes que realizaram um pedido
select count(*) from clients inner join orders on idClient=idOrderClient;

-- Retorna informações de pedidos que possuam informações sobre os produtos    
select * from clients c inner join orders o on c.idClient = o.idOrderClient
	inner join productOrder p on p.idProductOrderOrder = o.idOrder;

-- Exibir detalhes de todos os pedidos
select concat(c.Fname,' ',c.Lname) as client_name,
	   o.idOrder as orderID,
       o.orderStatus,
       o.orderDescription,
       pd.pName as productName,
       p.productOrderQuantity as Quantity
	from clients c inner join orders o on c.idClient = o.idOrderClient
	inner join productOrder p on p.idProductOrderOrder = o.idOrder
    inner join product pd on p.idProductOrderProduct = pd.idProduct;

-- Retorna cliente cujo pedido não possui detalhes sobre o produto
select * from orders inner join clients on idOrderClient=idClient;
select o.idOrder, concat(c2.fName,' ',c2.lName) as Client_Name 
	from clients c inner join orders o on c.idClient = o.idOrderClient
	not in (select distinct o.idOrder from productOrder po inner join orders o on po.idProductOrderOrder = o.idOrder)
    inner join clients c2 on o.idOrderClient=c2.idClient;

-- Exibir numero de pedidos por cliente
select  c.idClient, concat(c.Fname,' ',c.Lname) as complete_name, count(*) as numOrders 
	from clients c inner join orders o on o.idOrderClient=c.idClient group by idClient order by complete_name;

-- Exibir numero de produtos em cada pedido
select c.idClient as idClient,
	   concat(c.fName,' ',c.lName) as complete_name,
       o.idOrder as idOrder,
       sum(productOrderQuantity) as product_quantity  
	from clients c 
	inner join orders o on c.idClient = o.idOrderClient
    inner join productOrder po on po.idProductOrderOrder = o.idOrder
    group by o.idOrder;