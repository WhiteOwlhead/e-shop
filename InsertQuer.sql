
INSERT INTO role(role_ID, role_name, description) VALUES (4, 'UserDef', 'CommonUser');
INSERT INTO delivery_type (delivery_ID, description) values (3, 'Pick-up'); 
INSERT INTO item(item_ID, item_name, category, in_stock, item_price) VALUES
	(3, 'Ephone22', 1, 8, 22), (4, 'JustWash200', 3, 2, 80), (5, 'MicroFast', 2, 5, 35), (7, 'Candy-Mac2', 6, 5, 23);
INSERT INTO item_media (item_media_ID, item_media_path, item) VALUES
	(7, 'phone.png', 3), (8, 'washing1.png', 4), (9, 'micro1.png', 5), (11, 'candy.jpg', 7);

INSERT INTO category(category_ID, category_name, category_description) VALUES
	(1, 'Phones', 'Electrical phones, smartphones'), (2, 'Microwaves', 'All types of microwaves'), (3, 'Washing machines', 'All possible washing machines'),
		(6, 'Candy Machines', 'Candy machines of all types');