CREATE TABLE warehouse (
    w_id       INT64            NOT NULL,
    w_ytd      FLOAT64        NOT NULL,
    w_tax      FLOAT64        NOT NULL,
    w_name     STRING(10)    NOT NULL,
    w_street_1 STRING(20)    NOT NULL,
    w_street_2 STRING(20)    NOT NULL,
    w_city     STRING(20)    NOT NULL,
    w_state    STRING(2)        NOT NULL,
    w_zip      STRING(9)        NOT NULL
) PRIMARY KEY (w_id);

CREATE TABLE item (
    i_id    INT64           NOT NULL,
    i_name  STRING(24)   NOT NULL,
    i_price FLOAT64       NOT NULL,
    i_data  STRING(50)   NOT NULL,
    i_im_id INT64           NOT NULL
) PRIMARY KEY (i_id);

CREATE TABLE stock (
    s_w_id       INT64           NOT NULL,
    s_i_id       INT64           NOT NULL,
    s_quantity   INT64           NOT NULL,
    s_ytd        FLOAT64       NOT NULL,
    s_order_cnt  INT64           NOT NULL,
    s_remote_cnt INT64           NOT NULL,
    s_data       STRING(50)   NOT NULL,
    s_dist_01    STRING(24)      NOT NULL,
    s_dist_02    STRING(24)      NOT NULL,
    s_dist_03    STRING(24)      NOT NULL,
    s_dist_04    STRING(24)      NOT NULL,
    s_dist_05    STRING(24)      NOT NULL,
    s_dist_06    STRING(24)      NOT NULL,
    s_dist_07    STRING(24)      NOT NULL,
    s_dist_08    STRING(24)      NOT NULL,
    s_dist_09    STRING(24)      NOT NULL,
    s_dist_10    STRING(24)      NOT NULL,
    CONSTRAINT FK_stock_warehouse FOREIGN KEY (s_w_id) REFERENCES warehouse (w_id),
    CONSTRAINT FK_stock_item FOREIGN KEY (s_i_id) REFERENCES item (i_id)
) PRIMARY KEY (s_w_id, s_i_id);

CREATE TABLE district (
    d_w_id      INT64            NOT NULL,
    d_id        INT64            NOT NULL,
    d_ytd       FLOAT64        NOT NULL,
    d_tax       FLOAT64        NOT NULL,
    d_next_o_id INT64            NOT NULL,
    d_name      STRING(10)    NOT NULL,
    d_street_1  STRING(20)    NOT NULL,
    d_street_2  STRING(20)    NOT NULL,
    d_city      STRING(20)    NOT NULL,
    d_state     STRING(2)        NOT NULL,
    d_zip       STRING(9)        NOT NULL,
    CONSTRAINT FK_district_warehouse FOREIGN KEY (d_w_id) REFERENCES warehouse (w_id)
) PRIMARY KEY (d_w_id, d_id);

CREATE TABLE customer (
    c_w_id         INT64            NOT NULL,
    c_d_id         INT64            NOT NULL,
    c_id           INT64            NOT NULL,
    c_discount     FLOAT64        NOT NULL,
    c_credit       STRING(2)        NOT NULL,
    c_last         STRING(16)    NOT NULL,
    c_first        STRING(16)    NOT NULL,
    c_credit_lim   FLOAT64        NOT NULL,
    c_balance      FLOAT64        NOT NULL,
    c_ytd_payment  FLOAT64        NOT NULL,
    c_payment_cnt  INT64            NOT NULL,
    c_delivery_cnt INT64            NOT NULL,
    c_street_1     STRING(20)    NOT NULL,
    c_street_2     STRING(20)    NOT NULL,
    c_city         STRING(20)    NOT NULL,
    c_state        STRING(2)        NOT NULL,
    c_zip          STRING(9)        NOT NULL,
    c_phone        STRING(16)       NOT NULL,
    c_since        TIMESTAMP      NOT NULL DEFAULT (CURRENT_TIMESTAMP()),
    c_middle       STRING(2)        NOT NULL,
    c_data         STRING(500)   NOT NULL,
    CONSTRAINT FK_customer_district FOREIGN KEY (c_w_id, c_d_id) REFERENCES district (d_w_id, d_id)
) PRIMARY KEY (c_w_id, c_d_id, c_id);

CREATE TABLE history (
    h_c_id   INT64           NOT NULL,
    h_c_d_id INT64           NOT NULL,
    h_c_w_id INT64           NOT NULL,
    h_d_id   INT64           NOT NULL,
    h_w_id   INT64           NOT NULL,
    h_date   TIMESTAMP     NOT NULL DEFAULT (CURRENT_TIMESTAMP()),
    h_amount FLOAT64       NOT NULL,
    h_data   STRING(24)   NOT NULL,
    CONSTRAINT FK_history_customer FOREIGN KEY (h_c_w_id, h_c_d_id, h_c_id) REFERENCES customer (c_w_id, c_d_id, c_id),
    CONSTRAINT FK_history_district FOREIGN KEY (h_w_id, h_d_id) REFERENCES district (d_w_id, d_id)
) PRIMARY KEY (h_c_id, h_date, h_data);

CREATE TABLE oorder (
    o_w_id       INT64       NOT NULL,
    o_d_id       INT64       NOT NULL,
    o_id         INT64       NOT NULL,
    o_c_id       INT64       NOT NULL,
    o_carrier_id INT64       ,
    o_ol_cnt     INT64       NOT NULL,
    o_all_local  INT64       NOT NULL,
    o_entry_d    TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP()),
    CONSTRAINT FK_oorder_customer FOREIGN KEY (o_w_id, o_d_id, o_c_id) REFERENCES customer (c_w_id, c_d_id, c_id)
) PRIMARY KEY (o_w_id, o_d_id, o_id);

CREATE TABLE new_order (
    no_w_id INT64 NOT NULL,
    no_d_id INT64 NOT NULL,
    no_o_id INT64 NOT NULL,
    CONSTRAINT FK_new_order_oorder FOREIGN KEY (no_w_id, no_d_id, no_o_id) REFERENCES oorder (o_w_id, o_d_id, o_id)
) PRIMARY KEY (no_w_id, no_d_id, no_o_id);

CREATE TABLE order_line (
    ol_w_id        INT64           NOT NULL,
    ol_d_id        INT64           NOT NULL,
    ol_o_id        INT64           NOT NULL,
    ol_number      INT64           NOT NULL,
    ol_i_id        INT64           NOT NULL,
    ol_delivery_d  TIMESTAMP,
    ol_amount      FLOAT64       NOT NULL,
    ol_supply_w_id INT64           NOT NULL,
    ol_quantity    FLOAT64       NOT NULL,
    ol_dist_info   STRING(24)   NOT NULL,
    CONSTRAINT FK_order_line_oorder FOREIGN KEY (ol_w_id, ol_d_id, ol_o_id) REFERENCES oorder (o_w_id, o_d_id, o_id),
    CONSTRAINT FK_order_line_stock FOREIGN KEY (ol_supply_w_id, ol_i_id) REFERENCES stock (s_w_id, s_i_id)
) PRIMARY KEY (ol_w_id, ol_d_id, ol_o_id, ol_number);

CREATE INDEX idx_customer_name ON customer (c_w_id, c_d_id, c_last, c_first);
CREATE INDEX idx_order ON oorder (o_w_id, o_d_id, o_c_id, o_id);

