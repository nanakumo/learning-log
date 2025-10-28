CREATE VIEW item_category AS SELECT item.item_name, category.category_name
FROM item
INNER JOIN category ON item.category_id = category.category_id;