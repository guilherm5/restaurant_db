DROP TABLE IF EXISTS detail_lines;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS taxes;
DROP TABLE IF EXISTS tax_types;
DROP TABLE IF EXISTS guest_checks;
DROP TABLE IF EXISTS restaurant;

CREATE TABLE restaurant (
    restaurant_id SERIAL NOT NULL
    , name VARCHAR(255) NOT NULL
    , location VARCHAR(255)
    , cur_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    , loc_ref VARCHAR(50)
    , description VARCHAR(255)
    , CONSTRAINT pk_restaurant_restaurant_id PRIMARY KEY (restaurant_id)
);

CREATE TABLE guest_checks (
    guest_check_id SERIAL NOT NULL
    , chk_num INT NOT NULL
    , opn_bus_dt DATE DEFAULT NOW() NOT NULL
    , opn_utc TIMESTAMP DEFAULT NOW() NOT NULL
    , opn_lcl TIMESTAMP DEFAULT NOW() NOT NULL
    , clsd_bus_dt DATE DEFAULT CURRENT_DATE NOT NULL
    , clsd_utc TIMESTAMP
    , clsd_lcl TIMESTAMP
    , last_trans_utc TIMESTAMP
    , last_trans_lcl TIMESTAMP
    , last_updated_utc TIMESTAMP
    , last_updated_lcl TIMESTAMP
    , clsd_flag BOOLEAN
    , gst_cnt INT
    , sub_ttl NUMERIC(12, 2)
    , non_txbl_sls_ttl NUMERIC(12, 2) DEFAULT NULL
    , chk_ttl NUMERIC(12, 2)
    , dsc_ttl NUMERIC(12, 2)
    , pay_ttl NUMERIC(12, 2)
    , bal_due_ttl NUMERIC(12, 2) DEFAULT NULL
    , rvc_num INT
    , ot_num INT
    , oc_num INT DEFAULT NULL
    , tbl_num INT
    , tbl_name VARCHAR(255)
    , emp_num INT
    , num_srvc_rd INT
    , num_chk_prntd INT
    , restaurant_id INT
    , CONSTRAINT pk_guest_checks_guest_check_id PRIMARY KEY (guest_check_id)
    , CONSTRAINT fk_guest_checks_restaurant_id FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE
);

CREATE TABLE tax_types (
    tax_type_id SERIAL NOT NULL
    , tax_type_name VARCHAR(255) NOT NULL
    , description VARCHAR(255)
    , type INT NOT NULL
    , CONSTRAINT pk_tax_types_tax_type_id PRIMARY KEY (tax_type_id)
);

CREATE TABLE taxes (
    tax_num SERIAL NOT NULL
    , guest_check_id INT NOT NULL
    , tax_type_id INT NOT NULL
    , txbl_sls_ttl NUMERIC(12, 2)
    , tax_coll_ttl NUMERIC(12, 2)
    , tax_rate NUMERIC(5, 2)
    , CONSTRAINT pk_taxes_tax_num PRIMARY KEY (tax_num)
    , CONSTRAINT fk_taxes_guest_check_id FOREIGN KEY (guest_check_id) REFERENCES guest_checks(guest_check_id) ON DELETE CASCADE
    , CONSTRAINT fk_taxes_tax_type_id FOREIGN KEY (tax_type_id) REFERENCES tax_types(tax_type_id)
);

CREATE TABLE menu_items (
    menu_item_id SERIAL NOT NULL
    , mod_flag BOOLEAN
    , incl_tax NUMERIC(12, 2)
    , active_taxes VARCHAR(255)
    , prc_lvl INT
    , CONSTRAINT pk_menu_items_menu_item_id PRIMARY KEY (menu_item_id)
);

CREATE TABLE detail_lines (
    guest_check_line_item_id SERIAL NOT NULL
    , guest_check_id INT NOT NULL
    , rvc_num INT
    , dtl_ot_num INT
    , dtl_oc_num INT NULL
    , line_num INT
    , dtl_id INT
    , detail_utc TIMESTAMP
    , detail_lcl TIMESTAMP
    , last_update_utc TIMESTAMP
    , last_update_lcl TIMESTAMP
    , bus_dt DATE
    , ws_num INT
    , dsp_ttl NUMERIC(12, 2)
    , dsp_qty INT
    , agg_ttl NUMERIC(12, 2)
    , agg_qty INT
    , chk_emp_id INT
    , chk_emp_num INT
    , svc_rnd_num INT
    , seat_num INT
    , menu_item_id INT NOT NULL
    , CONSTRAINT pk_detail_lines_guest_check_line_item_id PRIMARY KEY (guest_check_line_item_id)
    , CONSTRAINT fk_detail_lines_guest_check_id FOREIGN KEY (guest_check_id) REFERENCES guest_checks(guest_check_id)
    , CONSTRAINT fk_detail_lines_menu_item_id FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
);


INSERT INTO restaurant (name, location, cur_utc, loc_ref, description)
VALUES
('Restaurant A', 'New York, NY', CURRENT_TIMESTAMP, 'NY01', 'Fine dining restaurant in NYC'),
('Restaurant B', 'Los Angeles, CA', CURRENT_TIMESTAMP, 'LA01', 'Casual dining spot in LA'),
('Restaurant C', 'Chicago, IL', CURRENT_TIMESTAMP, 'CH01', 'Cozy cafe in Chicago');

INSERT INTO guest_checks (chk_num, opn_bus_dt, opn_utc, opn_lcl, clsd_bus_dt, clsd_utc, clsd_lcl, last_trans_utc, last_trans_lcl, last_updated_utc, last_updated_lcl, clsd_flag, gst_cnt, sub_ttl, chk_ttl, dsc_ttl, pay_ttl, tbl_num, tbl_name, emp_num, num_srvc_rd, num_chk_prntd, restaurant_id)
VALUES
(1001, '2024-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 4, 120.00, 150.00, 5.00, 145.00, 10, 'Table 1', 101, 2, 1, 1),
(1002, '2024-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 2, 50.00, 60.00, 2.00, 58.00, 5, 'Table 2', 102, 1, 1, 2),
(1003, '2024-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 3, 80.00, 100.00, 3.00, 97.00, 8, 'Table 3', 103, 3, 2, 3);

INSERT INTO tax_types (tax_type_name, description, type)
VALUES
('Sales Tax', 'Standard sales tax', 1),
('Service Charge', 'Additional service charge', 2);

INSERT INTO taxes (guest_check_id, tax_type_id, txbl_sls_ttl, tax_coll_ttl, tax_rate)
VALUES
(1, 1, 120.00, 12.00, 10.00),  -- 10% Sales Tax
(2, 1, 50.00, 5.00, 10.00),   -- 10% Sales Tax
(3, 2, 80.00, 8.00, 10.00);   -- 10% Service Charge

INSERT INTO menu_items (mod_flag, incl_tax, active_taxes, prc_lvl)
VALUES
(TRUE, 15.00, 'Sales Tax', 1),
(TRUE, 25.00, 'Service Charge', 2),
(FALSE, 10.00, 'Sales Tax', 1);

INSERT INTO detail_lines (guest_check_id, rvc_num, dtl_ot_num, line_num, dtl_id, detail_utc, detail_lcl, last_update_utc, last_update_lcl, bus_dt, ws_num, dsp_ttl, dsp_qty, agg_ttl, agg_qty, chk_emp_id, chk_emp_num, svc_rnd_num, seat_num, menu_item_id)
VALUES
(1, 1, 1, 1, 101, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', 1, 30.00, 2, 60.00, 4, 1, 101, 1, 1, 1),
(2, 2, 2, 1, 102, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', 2, 25.00, 1, 50.00, 2, 2, 102, 2, 1, 2),
(3, 3, 3, 1, 103, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', 3, 20.00, 3, 60.00, 9, 3, 103, 3, 2, 3);



INSERT INTO restaurant (name, location, cur_utc, loc_ref, description)
VALUES
('Restaurant A', 'New York, NY', CURRENT_TIMESTAMP, 'NY01', 'Fine dining restaurant in NYC'),
('Restaurant B', 'Los Angeles, CA', CURRENT_TIMESTAMP, 'LA01', 'Casual dining spot in LA'),
('Restaurant C', 'Chicago, IL', CURRENT_TIMESTAMP, 'CH01', 'Cozy cafe in Chicago');

INSERT INTO guest_checks (chk_num, opn_bus_dt, opn_utc, opn_lcl, clsd_bus_dt, clsd_utc, clsd_lcl, last_trans_utc, last_trans_lcl, last_updated_utc, last_updated_lcl, clsd_flag, gst_cnt, sub_ttl, chk_ttl, dsc_ttl, pay_ttl, tbl_num, tbl_name, emp_num, num_srvc_rd, num_chk_prntd, restaurant_id)
VALUES
(1001, '2024-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 4, 120.00, 150.00, 5.00, 145.00, 10, 'Table 1', 101, 2, 1, 1),
(1002, '2024-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 2, 50.00, 60.00, 2.00, 58.00, 5, 'Table 2', 102, 1, 1, 2),
(1003, '2024-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE, 3, 80.00, 100.00, 3.00, 97.00, 8, 'Table 3', 103, 3, 2, 3);

INSERT INTO tax_types (tax_type_name, description, type)
VALUES
('Sales Tax', 'Standard sales tax', 1),
('Service Charge', 'Additional service charge', 2);

INSERT INTO taxes (guest_check_id, tax_type_id, txbl_sls_ttl, tax_coll_ttl, tax_rate)
VALUES
(1, 1, 120.00, 12.00, 10.00),  -- 10% Sales Tax
(2, 1, 50.00, 5.00, 10.00),   -- 10% Sales Tax
(3, 2, 80.00, 8.00, 10.00);   -- 10% Service Charge

INSERT INTO menu_items (mod_flag, incl_tax, active_taxes, prc_lvl)
VALUES
(TRUE, 15.00, 'Sales Tax', 1),
(TRUE, 25.00, 'Service Charge', 2),
(FALSE, 10.00, 'Sales Tax', 1);

INSERT INTO detail_lines (guest_check_id, rvc_num, dtl_ot_num, line_num, dtl_id, detail_utc, detail_lcl, last_update_utc, last_update_lcl, bus_dt, ws_num, dsp_ttl, dsp_qty, agg_ttl, agg_qty, chk_emp_id, chk_emp_num, svc_rnd_num, seat_num, menu_item_id)
VALUES
(1, 1, 1, 1, 101, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', 1, 30.00, 2, 60.00, 4, 1, 101, 1, 1, 1),
(2, 2, 2, 1, 102, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', 2, 25.00, 1, 50.00, 2, 2, 102, 2, 1, 2),
(3, 3, 3, 1, 103, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '2024-11-24', 3, 20.00, 3, 60.00, 9, 3, 103, 3, 2, 3);
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