-- Cold Drink Manufacturing ERP
-- MySQL 8.0+
-- Creates database, master data, transactions, accounting, CRM, HR/payroll,
-- manufacturing, inventory, purchasing, sales, approvals and audit support.

DROP DATABASE IF EXISTS cold_drink_erp;
CREATE DATABASE cold_drink_erp
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE cold_drink_erp;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- ORGANIZATION / SECURITY
-- =========================================================

CREATE TABLE companies (
    company_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_code VARCHAR(20) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    legal_name VARCHAR(200),
    tax_number VARCHAR(50),
    email VARCHAR(150),
    phone VARCHAR(30),
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100) NOT NULL DEFAULT 'India',
    postal_code VARCHAR(20),
    currency_code CHAR(3) NOT NULL DEFAULT 'INR',
    fiscal_year_start_month TINYINT UNSIGNED NOT NULL DEFAULT 4,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_company_fy_month CHECK (fiscal_year_start_month BETWEEN 1 AND 12)
);

CREATE TABLE branches (
    branch_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_code VARCHAR(20) NOT NULL,
    branch_name VARCHAR(120) NOT NULL,
    phone VARCHAR(30),
    email VARCHAR(150),
    address_line1 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_branch_code (company_id, branch_code),
    CONSTRAINT fk_branch_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE roles (
    role_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE users (
    user_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    username VARCHAR(80) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_at DATETIME NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_user_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- =========================================================
-- COMMON / MASTER DATA
-- =========================================================

CREATE TABLE units (
    unit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    unit_code VARCHAR(20) NOT NULL UNIQUE,
    unit_name VARCHAR(50) NOT NULL,
    decimal_places TINYINT UNSIGNED NOT NULL DEFAULT 2,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_unit_decimal CHECK (decimal_places <= 6)
);

CREATE TABLE product_categories (
    category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    category_type ENUM('RAW_MATERIAL','PACKAGING','FINISHED_GOOD','CONSUMABLE','SPARE_PART','ASSET','SERVICE') NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_category (company_id, category_name),
    CONSTRAINT fk_category_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE tax_rates (
    tax_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    tax_name VARCHAR(80) NOT NULL,
    tax_code VARCHAR(30),
    rate DECIMAL(7,3) NOT NULL DEFAULT 0.000,
    is_inclusive BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_tax (company_id, tax_name),
    CONSTRAINT fk_tax_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_tax_rate CHECK (rate >= 0 AND rate <= 100)
);

CREATE TABLE products (
    product_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,
    sku VARCHAR(50) NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    product_type ENUM('RAW_MATERIAL','PACKAGING','FINISHED_GOOD','CONSUMABLE','SPARE_PART','ASSET','SERVICE') NOT NULL,
    base_unit_id BIGINT UNSIGNED NOT NULL,
    purchase_unit_id BIGINT UNSIGNED NULL,
    sales_unit_id BIGINT UNSIGNED NULL,
    standard_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    selling_price DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    reorder_level DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    reorder_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    shelf_life_days INT UNSIGNED NULL,
    batch_required BOOLEAN NOT NULL DEFAULT FALSE,
    expiry_required BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_product_sku (company_id, sku),
    CONSTRAINT fk_product_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES product_categories(category_id),
    CONSTRAINT fk_product_base_unit FOREIGN KEY (base_unit_id) REFERENCES units(unit_id),
    CONSTRAINT fk_product_purchase_unit FOREIGN KEY (purchase_unit_id) REFERENCES units(unit_id) ON DELETE SET NULL,
    CONSTRAINT fk_product_sales_unit FOREIGN KEY (sales_unit_id) REFERENCES units(unit_id) ON DELETE SET NULL,
    CONSTRAINT chk_product_prices CHECK (standard_cost >= 0 AND selling_price >= 0),
    CONSTRAINT chk_product_reorder CHECK (reorder_level >= 0 AND reorder_qty >= 0)
);

CREATE TABLE warehouses (
    warehouse_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    warehouse_code VARCHAR(30) NOT NULL,
    warehouse_name VARCHAR(120) NOT NULL,
    warehouse_type ENUM('RAW_MATERIAL','PRODUCTION','FINISHED_GOODS','GENERAL','DISPATCH','QUARANTINE') NOT NULL DEFAULT 'GENERAL',
    address VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_warehouse (company_id, warehouse_code),
    CONSTRAINT fk_warehouse_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_warehouse_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL
);

CREATE TABLE warehouse_locations (
    location_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    warehouse_id BIGINT UNSIGNED NOT NULL,
    location_code VARCHAR(50) NOT NULL,
    location_name VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_location (warehouse_id, location_code),
    CONSTRAINT fk_location_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE
);

-- =========================================================
-- SUPPLIERS / PURCHASE
-- =========================================================

CREATE TABLE suppliers (
    supplier_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    supplier_code VARCHAR(30) NOT NULL,
    supplier_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(120),
    phone VARCHAR(30),
    email VARCHAR(150),
    tax_number VARCHAR(50),
    payment_terms_days INT UNSIGNED NOT NULL DEFAULT 0,
    credit_limit DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    address_line1 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_supplier (company_id, supplier_code),
    CONSTRAINT fk_supplier_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_supplier_credit CHECK (credit_limit >= 0)
);

CREATE TABLE purchase_requisitions (
    pr_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    pr_number VARCHAR(30) NOT NULL,
    request_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    required_date DATE,
    requested_by BIGINT UNSIGNED NULL,
    status ENUM('DRAFT','SUBMITTED','APPROVED','REJECTED','CLOSED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
    remarks VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_pr (company_id, pr_number),
    CONSTRAINT fk_pr_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_pr_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_pr_user FOREIGN KEY (requested_by) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE purchase_requisition_items (
    pr_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pr_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    unit_id BIGINT UNSIGNED NOT NULL,
    requested_qty DECIMAL(18,4) NOT NULL,
    approved_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    remarks VARCHAR(255),
    CONSTRAINT fk_pri_pr FOREIGN KEY (pr_id) REFERENCES purchase_requisitions(pr_id) ON DELETE CASCADE,
    CONSTRAINT fk_pri_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_pri_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_pri_qty CHECK (requested_qty > 0 AND approved_qty >= 0 AND approved_qty <= requested_qty)
);

CREATE TABLE purchase_orders (
    po_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    supplier_id BIGINT UNSIGNED NOT NULL,
    po_number VARCHAR(30) NOT NULL,
    po_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    expected_date DATE,
    status ENUM('DRAFT','SENT','PARTIAL','RECEIVED','CANCELLED','CLOSED') NOT NULL DEFAULT 'DRAFT',
    currency_code CHAR(3) NOT NULL DEFAULT 'INR',
    subtotal DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    remarks VARCHAR(500),
    created_by BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_po (company_id, po_number),
    CONSTRAINT fk_po_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_po_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_po_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_po_amounts CHECK (subtotal >= 0 AND discount_amount >= 0 AND tax_amount >= 0 AND total_amount >= 0)
);

CREATE TABLE purchase_order_items (
    po_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    po_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    unit_id BIGINT UNSIGNED NOT NULL,
    ordered_qty DECIMAL(18,4) NOT NULL,
    received_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    unit_price DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    line_total DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_poi_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
    CONSTRAINT fk_poi_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_poi_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_poi_qty CHECK (ordered_qty > 0 AND received_qty >= 0 AND received_qty <= ordered_qty),
    CONSTRAINT chk_poi_price CHECK (unit_price >= 0)
);

CREATE TABLE goods_receipts (
    grn_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    warehouse_id BIGINT UNSIGNED NOT NULL,
    supplier_id BIGINT UNSIGNED NOT NULL,
    po_id BIGINT UNSIGNED NULL,
    grn_number VARCHAR(30) NOT NULL,
    receipt_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('DRAFT','RECEIVED','QC_PENDING','ACCEPTED','REJECTED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
    received_by BIGINT UNSIGNED NULL,
    remarks VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_grn (company_id, grn_number),
    CONSTRAINT fk_grn_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_grn_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_grn_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_grn_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id) ON DELETE SET NULL,
    CONSTRAINT fk_grn_user FOREIGN KEY (received_by) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE goods_receipt_items (
    grn_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    grn_id BIGINT UNSIGNED NOT NULL,
    po_item_id BIGINT UNSIGNED NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    location_id BIGINT UNSIGNED NULL,
    batch_no VARCHAR(80),
    manufacture_date DATE NULL,
    expiry_date DATE NULL,
    received_qty DECIMAL(18,4) NOT NULL,
    accepted_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    rejected_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    unit_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    CONSTRAINT fk_gri_grn FOREIGN KEY (grn_id) REFERENCES goods_receipts(grn_id) ON DELETE CASCADE,
    CONSTRAINT fk_gri_po_item FOREIGN KEY (po_item_id) REFERENCES purchase_order_items(po_item_id) ON DELETE SET NULL,
    CONSTRAINT fk_gri_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_gri_location FOREIGN KEY (location_id) REFERENCES warehouse_locations(location_id) ON DELETE SET NULL,
    CONSTRAINT chk_gri_qty CHECK (
        received_qty > 0 AND accepted_qty >= 0 AND rejected_qty >= 0
        AND accepted_qty + rejected_qty <= received_qty
    ),
    CONSTRAINT chk_gri_dates CHECK (expiry_date IS NULL OR manufacture_date IS NULL OR expiry_date >= manufacture_date)
);

-- =========================================================
-- INVENTORY
-- =========================================================

CREATE TABLE inventory_batches (
    batch_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    warehouse_id BIGINT UNSIGNED NOT NULL,
    location_id BIGINT UNSIGNED NULL,
    batch_no VARCHAR(80) NOT NULL,
    manufacture_date DATE NULL,
    expiry_date DATE NULL,
    quantity DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    reserved_quantity DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    unit_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    status ENUM('AVAILABLE','QUARANTINE','BLOCKED','EXPIRED','DAMAGED') NOT NULL DEFAULT 'AVAILABLE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_inventory_batch (product_id, warehouse_id, batch_no),
    CONSTRAINT fk_batch_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_batch_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_batch_location FOREIGN KEY (location_id) REFERENCES warehouse_locations(location_id) ON DELETE SET NULL,
    CONSTRAINT chk_batch_qty CHECK (quantity >= 0 AND reserved_quantity >= 0 AND reserved_quantity <= quantity),
    CONSTRAINT chk_batch_dates CHECK (expiry_date IS NULL OR manufacture_date IS NULL OR expiry_date >= manufacture_date)
);

CREATE TABLE stock_transactions (
    stock_transaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    warehouse_id BIGINT UNSIGNED NOT NULL,
    location_id BIGINT UNSIGNED NULL,
    batch_id BIGINT UNSIGNED NULL,
    transaction_type ENUM(
        'PURCHASE_RECEIPT','PURCHASE_RETURN','SALE','SALES_RETURN',
        'PRODUCTION_CONSUMPTION','PRODUCTION_OUTPUT','TRANSFER_IN',
        'TRANSFER_OUT','ADJUSTMENT_IN','ADJUSTMENT_OUT','DAMAGE','EXPIRY'
    ) NOT NULL,
    reference_type VARCHAR(50),
    reference_id BIGINT UNSIGNED,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    quantity DECIMAL(18,4) NOT NULL,
    unit_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    remarks VARCHAR(255),
    created_by BIGINT UNSIGNED NULL,
    CONSTRAINT fk_st_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_st_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_st_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_st_location FOREIGN KEY (location_id) REFERENCES warehouse_locations(location_id) ON DELETE SET NULL,
    CONSTRAINT fk_st_batch FOREIGN KEY (batch_id) REFERENCES inventory_batches(batch_id) ON DELETE SET NULL,
    CONSTRAINT fk_st_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_st_qty CHECK (quantity > 0)
);

CREATE TABLE stock_transfers (
    transfer_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    transfer_number VARCHAR(30) NOT NULL,
    from_warehouse_id BIGINT UNSIGNED NOT NULL,
    to_warehouse_id BIGINT UNSIGNED NOT NULL,
    transfer_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('DRAFT','IN_TRANSIT','RECEIVED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
    created_by BIGINT UNSIGNED NULL,
    UNIQUE KEY uq_transfer (company_id, transfer_number),
    CONSTRAINT fk_transfer_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_transfer_from FOREIGN KEY (from_warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_transfer_to FOREIGN KEY (to_warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_transfer_user FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT chk_transfer_warehouse CHECK (from_warehouse_id <> to_warehouse_id)
);

CREATE TABLE stock_transfer_items (
    transfer_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transfer_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    batch_id BIGINT UNSIGNED NULL,
    quantity DECIMAL(18,4) NOT NULL,
    CONSTRAINT fk_transfer_item_transfer FOREIGN KEY (transfer_id) REFERENCES stock_transfers(transfer_id) ON DELETE CASCADE,
    CONSTRAINT fk_transfer_item_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_transfer_item_batch FOREIGN KEY (batch_id) REFERENCES inventory_batches(batch_id) ON DELETE SET NULL,
    CONSTRAINT chk_transfer_item_qty CHECK (quantity > 0)
);

-- =========================================================
-- MANUFACTURING
-- =========================================================

CREATE TABLE work_centers (
    work_center_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    work_center_code VARCHAR(30) NOT NULL,
    work_center_name VARCHAR(120) NOT NULL,
    capacity_per_hour DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    hourly_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_work_center (company_id, work_center_code),
    CONSTRAINT fk_wc_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_wc_values CHECK (capacity_per_hour >= 0 AND hourly_cost >= 0)
);

CREATE TABLE recipes (
    recipe_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    finished_product_id BIGINT UNSIGNED NOT NULL,
    recipe_code VARCHAR(30) NOT NULL,
    version_no INT UNSIGNED NOT NULL DEFAULT 1,
    yield_quantity DECIMAL(18,4) NOT NULL,
    yield_unit_id BIGINT UNSIGNED NOT NULL,
    effective_from DATE NOT NULL DEFAULT (CURRENT_DATE),
    effective_to DATE NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_recipe (company_id, recipe_code, version_no),
    CONSTRAINT fk_recipe_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_recipe_product FOREIGN KEY (finished_product_id) REFERENCES products(product_id),
    CONSTRAINT fk_recipe_unit FOREIGN KEY (yield_unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_recipe_yield CHECK (yield_quantity > 0),
    CONSTRAINT chk_recipe_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

CREATE TABLE recipe_items (
    recipe_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    recipe_id BIGINT UNSIGNED NOT NULL,
    material_product_id BIGINT UNSIGNED NOT NULL,
    quantity DECIMAL(18,4) NOT NULL,
    unit_id BIGINT UNSIGNED NOT NULL,
    scrap_percent DECIMAL(7,3) NOT NULL DEFAULT 0.000,
    sequence_no INT UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT fk_recipe_item_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    CONSTRAINT fk_recipe_item_product FOREIGN KEY (material_product_id) REFERENCES products(product_id),
    CONSTRAINT fk_recipe_item_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_recipe_item_qty CHECK (quantity > 0),
    CONSTRAINT chk_recipe_item_scrap CHECK (scrap_percent >= 0 AND scrap_percent <= 100)
);

CREATE TABLE production_orders (
    production_order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    order_number VARCHAR(30) NOT NULL,
    recipe_id BIGINT UNSIGNED NOT NULL,
    finished_product_id BIGINT UNSIGNED NOT NULL,
    planned_qty DECIMAL(18,4) NOT NULL,
    produced_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    rejected_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    planned_start DATETIME,
    planned_end DATETIME,
    actual_start DATETIME NULL,
    actual_end DATETIME NULL,
    status ENUM('PLANNED','RELEASED','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PLANNED',
    production_warehouse_id BIGINT UNSIGNED NOT NULL,
    finished_goods_warehouse_id BIGINT UNSIGNED NOT NULL,
    created_by BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_production_order (company_id, order_number),
    CONSTRAINT fk_prod_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_prod_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_prod_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
    CONSTRAINT fk_prod_product FOREIGN KEY (finished_product_id) REFERENCES products(product_id),
    CONSTRAINT fk_prod_prod_wh FOREIGN KEY (production_warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_prod_fg_wh FOREIGN KEY (finished_goods_warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_prod_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_prod_qty CHECK (planned_qty > 0 AND produced_qty >= 0 AND rejected_qty >= 0),
    CONSTRAINT chk_prod_completed CHECK (produced_qty + rejected_qty <= planned_qty)
);

CREATE TABLE production_materials (
    production_material_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    production_order_id BIGINT UNSIGNED NOT NULL,
    recipe_item_id BIGINT UNSIGNED NULL,
    material_product_id BIGINT UNSIGNED NOT NULL,
    batch_id BIGINT UNSIGNED NULL,
    planned_qty DECIMAL(18,4) NOT NULL,
    consumed_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    unit_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    CONSTRAINT fk_pm_order FOREIGN KEY (production_order_id) REFERENCES production_orders(production_order_id) ON DELETE CASCADE,
    CONSTRAINT fk_pm_recipe_item FOREIGN KEY (recipe_item_id) REFERENCES recipe_items(recipe_item_id) ON DELETE SET NULL,
    CONSTRAINT fk_pm_product FOREIGN KEY (material_product_id) REFERENCES products(product_id),
    CONSTRAINT fk_pm_batch FOREIGN KEY (batch_id) REFERENCES inventory_batches(batch_id) ON DELETE SET NULL,
    CONSTRAINT chk_pm_qty CHECK (planned_qty > 0 AND consumed_qty >= 0 AND consumed_qty <= planned_qty)
);

CREATE TABLE production_outputs (
    production_output_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    production_order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    batch_no VARCHAR(80) NOT NULL,
    manufacture_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    expiry_date DATE NULL,
    produced_qty DECIMAL(18,4) NOT NULL,
    accepted_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    rejected_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    unit_cost DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    CONSTRAINT fk_po_output_order FOREIGN KEY (production_order_id) REFERENCES production_orders(production_order_id) ON DELETE CASCADE,
    CONSTRAINT fk_po_output_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_output_qty CHECK (
        produced_qty > 0 AND accepted_qty >= 0 AND rejected_qty >= 0
        AND accepted_qty + rejected_qty <= produced_qty
    ),
    CONSTRAINT chk_output_dates CHECK (expiry_date IS NULL OR expiry_date >= manufacture_date)
);

CREATE TABLE quality_inspections (
    inspection_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    inspection_type ENUM('PURCHASE','PRODUCTION','DISPATCH','RETURN') NOT NULL,
    reference_id BIGINT UNSIGNED NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    inspector_user_id BIGINT UNSIGNED NULL,
    result ENUM('PENDING','PASS','FAIL','CONDITIONAL') NOT NULL DEFAULT 'PENDING',
    remarks VARCHAR(500),
    CONSTRAINT fk_qi_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_qi_user FOREIGN KEY (inspector_user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE quality_parameters (
    parameter_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parameter_name VARCHAR(100) NOT NULL,
    unit_id BIGINT UNSIGNED NULL,
    min_value DECIMAL(18,6) NULL,
    max_value DECIMAL(18,6) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_qp_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id) ON DELETE SET NULL,
    CONSTRAINT chk_qp_range CHECK (min_value IS NULL OR max_value IS NULL OR min_value <= max_value)
);

CREATE TABLE quality_inspection_results (
    inspection_result_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    inspection_id BIGINT UNSIGNED NOT NULL,
    parameter_id BIGINT UNSIGNED NOT NULL,
    actual_value DECIMAL(18,6),
    pass_flag BOOLEAN NOT NULL DEFAULT FALSE,
    remarks VARCHAR(255),
    CONSTRAINT fk_qir_inspection FOREIGN KEY (inspection_id) REFERENCES quality_inspections(inspection_id) ON DELETE CASCADE,
    CONSTRAINT fk_qir_parameter FOREIGN KEY (parameter_id) REFERENCES quality_parameters(parameter_id)
);

-- =========================================================
-- CUSTOMERS / CRM / SALES
-- =========================================================

CREATE TABLE customer_types (
    customer_type_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    type_name VARCHAR(80) NOT NULL,
    UNIQUE KEY uq_customer_type (company_id, type_name),
    CONSTRAINT fk_customer_type_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE customers (
    customer_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    customer_type_id BIGINT UNSIGNED NULL,
    customer_code VARCHAR(30) NOT NULL,
    customer_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(120),
    phone VARCHAR(30),
    email VARCHAR(150),
    tax_number VARCHAR(50),
    credit_limit DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    payment_terms_days INT UNSIGNED NOT NULL DEFAULT 0,
    address_line1 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_customer (company_id, customer_code),
    CONSTRAINT fk_customer_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_customer_type FOREIGN KEY (customer_type_id) REFERENCES customer_types(customer_type_id) ON DELETE SET NULL,
    CONSTRAINT chk_customer_credit CHECK (credit_limit >= 0)
);

CREATE TABLE leads (
    lead_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    lead_code VARCHAR(30) NOT NULL,
    lead_name VARCHAR(150) NOT NULL,
    company_name VARCHAR(150),
    phone VARCHAR(30),
    email VARCHAR(150),
    source VARCHAR(80),
    status ENUM('NEW','CONTACTED','QUALIFIED','PROPOSAL','WON','LOST') NOT NULL DEFAULT 'NEW',
    assigned_to BIGINT UNSIGNED NULL,
    estimated_value DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    expected_close_date DATE NULL,
    notes VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_lead (company_id, lead_code),
    CONSTRAINT fk_lead_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_lead_user FOREIGN KEY (assigned_to) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_lead_value CHECK (estimated_value >= 0)
);

CREATE TABLE crm_activities (
    activity_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    customer_id BIGINT UNSIGNED NULL,
    lead_id BIGINT UNSIGNED NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    activity_type ENUM('CALL','VISIT','EMAIL','MEETING','FOLLOW_UP','COMPLAINT','OTHER') NOT NULL,
    activity_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subject VARCHAR(150) NOT NULL,
    notes TEXT,
    next_followup_at DATETIME NULL,
    status ENUM('OPEN','DONE','CANCELLED') NOT NULL DEFAULT 'OPEN',
    CONSTRAINT fk_crm_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_crm_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL,
    CONSTRAINT fk_crm_lead FOREIGN KEY (lead_id) REFERENCES leads(lead_id) ON DELETE SET NULL,
    CONSTRAINT fk_crm_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE sales_orders (
    sales_order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    customer_id BIGINT UNSIGNED NOT NULL,
    order_number VARCHAR(30) NOT NULL,
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    expected_delivery_date DATE NULL,
    status ENUM('DRAFT','CONFIRMED','PARTIAL','DELIVERED','CANCELLED','CLOSED') NOT NULL DEFAULT 'DRAFT',
    subtotal DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    credit_check_status ENUM('NOT_CHECKED','PASSED','BLOCKED') NOT NULL DEFAULT 'NOT_CHECKED',
    salesperson_user_id BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_sales_order (company_id, order_number),
    CONSTRAINT fk_so_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_so_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_so_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_so_salesperson FOREIGN KEY (salesperson_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_so_amounts CHECK (subtotal >= 0 AND discount_amount >= 0 AND tax_amount >= 0 AND total_amount >= 0)
);

CREATE TABLE sales_order_items (
    sales_order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    sales_order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    unit_id BIGINT UNSIGNED NOT NULL,
    ordered_qty DECIMAL(18,4) NOT NULL,
    delivered_qty DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    unit_price DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    line_total DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_soi_order FOREIGN KEY (sales_order_id) REFERENCES sales_orders(sales_order_id) ON DELETE CASCADE,
    CONSTRAINT fk_soi_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_soi_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_soi_qty CHECK (ordered_qty > 0 AND delivered_qty >= 0 AND delivered_qty <= ordered_qty),
    CONSTRAINT chk_soi_price CHECK (unit_price >= 0)
);

CREATE TABLE deliveries (
    delivery_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    warehouse_id BIGINT UNSIGNED NOT NULL,
    customer_id BIGINT UNSIGNED NOT NULL,
    sales_order_id BIGINT UNSIGNED NULL,
    delivery_number VARCHAR(30) NOT NULL,
    delivery_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('DRAFT','DISPATCHED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
    delivered_by BIGINT UNSIGNED NULL,
    remarks VARCHAR(500),
    UNIQUE KEY uq_delivery (company_id, delivery_number),
    CONSTRAINT fk_delivery_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_delivery_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    CONSTRAINT fk_delivery_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_delivery_order FOREIGN KEY (sales_order_id) REFERENCES sales_orders(sales_order_id) ON DELETE SET NULL,
    CONSTRAINT fk_delivery_user FOREIGN KEY (delivered_by) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE delivery_items (
    delivery_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    delivery_id BIGINT UNSIGNED NOT NULL,
    sales_order_item_id BIGINT UNSIGNED NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    batch_id BIGINT UNSIGNED NULL,
    quantity DECIMAL(18,4) NOT NULL,
    unit_price DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    CONSTRAINT fk_di_delivery FOREIGN KEY (delivery_id) REFERENCES deliveries(delivery_id) ON DELETE CASCADE,
    CONSTRAINT fk_di_soi FOREIGN KEY (sales_order_item_id) REFERENCES sales_order_items(sales_order_item_id) ON DELETE SET NULL,
    CONSTRAINT fk_di_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_di_batch FOREIGN KEY (batch_id) REFERENCES inventory_batches(batch_id) ON DELETE SET NULL,
    CONSTRAINT chk_di_qty CHECK (quantity > 0)
);

CREATE TABLE sales_invoices (
    sales_invoice_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    customer_id BIGINT UNSIGNED NOT NULL,
    sales_order_id BIGINT UNSIGNED NULL,
    invoice_number VARCHAR(30) NOT NULL,
    invoice_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NULL,
    status ENUM('DRAFT','POSTED','PARTIALLY_PAID','PAID','CANCELLED') NOT NULL DEFAULT 'DRAFT',
    subtotal DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    paid_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_sales_invoice (company_id, invoice_number),
    CONSTRAINT fk_si_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_si_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_si_order FOREIGN KEY (sales_order_id) REFERENCES sales_orders(sales_order_id) ON DELETE SET NULL,
    CONSTRAINT chk_si_amounts CHECK (
        subtotal >= 0 AND discount_amount >= 0 AND tax_amount >= 0
        AND total_amount >= 0 AND paid_amount >= 0 AND paid_amount <= total_amount
    )
);

CREATE TABLE sales_invoice_items (
    sales_invoice_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    sales_invoice_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity DECIMAL(18,4) NOT NULL,
    unit_id BIGINT UNSIGNED NOT NULL,
    unit_price DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    line_total DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_sii_invoice FOREIGN KEY (sales_invoice_id) REFERENCES sales_invoices(sales_invoice_id) ON DELETE CASCADE,
    CONSTRAINT fk_sii_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_sii_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_sii_qty CHECK (quantity > 0)
);

-- =========================================================
-- ACCOUNTING
-- =========================================================

CREATE TABLE account_types (
    account_type_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    normal_balance ENUM('DEBIT','CREDIT') NOT NULL
);

CREATE TABLE accounts (
    account_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    parent_account_id BIGINT UNSIGNED NULL,
    account_type_id BIGINT UNSIGNED NOT NULL,
    account_code VARCHAR(30) NOT NULL,
    account_name VARCHAR(120) NOT NULL,
    is_control_account BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_account (company_id, account_code),
    CONSTRAINT fk_account_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_account_parent FOREIGN KEY (parent_account_id) REFERENCES accounts(account_id) ON DELETE SET NULL,
    CONSTRAINT fk_account_type FOREIGN KEY (account_type_id) REFERENCES account_types(account_type_id)
);

CREATE TABLE fiscal_years (
    fiscal_year_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    year_name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_closed BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE KEY uq_fiscal_year (company_id, year_name),
    CONSTRAINT fk_fy_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_fy_dates CHECK (end_date > start_date)
);

CREATE TABLE journal_entries (
    journal_entry_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    fiscal_year_id BIGINT UNSIGNED NULL,
    entry_number VARCHAR(30) NOT NULL,
    entry_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    source_type VARCHAR(50),
    source_id BIGINT UNSIGNED NULL,
    description VARCHAR(500),
    status ENUM('DRAFT','POSTED','REVERSED') NOT NULL DEFAULT 'DRAFT',
    created_by BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_journal_entry (company_id, entry_number),
    CONSTRAINT fk_je_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_je_fy FOREIGN KEY (fiscal_year_id) REFERENCES fiscal_years(fiscal_year_id) ON DELETE SET NULL,
    CONSTRAINT fk_je_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE journal_entry_lines (
    journal_line_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    journal_entry_id BIGINT UNSIGNED NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    description VARCHAR(255),
    debit DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    credit DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    customer_id BIGINT UNSIGNED NULL,
    supplier_id BIGINT UNSIGNED NULL,
    CONSTRAINT fk_jel_entry FOREIGN KEY (journal_entry_id) REFERENCES journal_entries(journal_entry_id) ON DELETE CASCADE,
    CONSTRAINT fk_jel_account FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    CONSTRAINT fk_jel_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL,
    CONSTRAINT fk_jel_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
    CONSTRAINT chk_jel_amount CHECK (
        debit >= 0 AND credit >= 0 AND NOT (debit > 0 AND credit > 0)
        AND (debit > 0 OR credit > 0)
    )
);

CREATE TABLE payment_methods (
    payment_method_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    method_name VARCHAR(50) NOT NULL,
    account_id BIGINT UNSIGNED NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_payment_method (company_id, method_name),
    CONSTRAINT fk_pm_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_pm_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE SET NULL
);

CREATE TABLE customer_payments (
    customer_payment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    customer_id BIGINT UNSIGNED NOT NULL,
    payment_method_id BIGINT UNSIGNED NOT NULL,
    payment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    reference_number VARCHAR(80),
    amount DECIMAL(18,2) NOT NULL,
    remarks VARCHAR(255),
    created_by BIGINT UNSIGNED NULL,
    CONSTRAINT fk_cp_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_cp_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_cp_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id),
    CONSTRAINT fk_cp_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_cp_amount CHECK (amount > 0)
);

CREATE TABLE supplier_payments (
    supplier_payment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    supplier_id BIGINT UNSIGNED NOT NULL,
    payment_method_id BIGINT UNSIGNED NOT NULL,
    payment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    reference_number VARCHAR(80),
    amount DECIMAL(18,2) NOT NULL,
    remarks VARCHAR(255),
    created_by BIGINT UNSIGNED NULL,
    CONSTRAINT fk_sp_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_sp_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_sp_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id),
    CONSTRAINT fk_sp_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_sp_amount CHECK (amount > 0)
);

-- =========================================================
-- HR / PAYROLL
-- =========================================================

CREATE TABLE departments (
    department_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_department (company_id, department_name),
    CONSTRAINT fk_department_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE designations (
    designation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    designation_name VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_designation (company_id, designation_name),
    CONSTRAINT fk_designation_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE employees (
    employee_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    department_id BIGINT UNSIGNED NULL,
    designation_id BIGINT UNSIGNED NULL,
    employee_code VARCHAR(30) NOT NULL,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80),
    gender ENUM('MALE','FEMALE','OTHER') NULL,
    date_of_birth DATE NULL,
    joining_date DATE NOT NULL,
    leaving_date DATE NULL,
    phone VARCHAR(30),
    email VARCHAR(150),
    bank_account_no VARCHAR(80),
    bank_name VARCHAR(100),
    tax_id VARCHAR(50),
    basic_salary DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    employment_status ENUM('ACTIVE','ON_LEAVE','RESIGNED','TERMINATED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_employee (company_id, employee_code),
    CONSTRAINT fk_employee_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_employee_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL,
    CONSTRAINT fk_employee_designation FOREIGN KEY (designation_id) REFERENCES designations(designation_id) ON DELETE SET NULL,
    CONSTRAINT chk_employee_salary CHECK (basic_salary >= 0),
    CONSTRAINT chk_employee_dates CHECK (leaving_date IS NULL OR leaving_date >= joining_date)
);

CREATE TABLE shifts (
    shift_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    shift_name VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    UNIQUE KEY uq_shift (company_id, shift_name),
    CONSTRAINT fk_shift_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE attendance (
    attendance_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT UNSIGNED NOT NULL,
    attendance_date DATE NOT NULL,
    shift_id BIGINT UNSIGNED NULL,
    check_in DATETIME NULL,
    check_out DATETIME NULL,
    status ENUM('PRESENT','ABSENT','HALF_DAY','LEAVE','HOLIDAY','OFF') NOT NULL DEFAULT 'PRESENT',
    overtime_hours DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    remarks VARCHAR(255),
    UNIQUE KEY uq_attendance (employee_id, attendance_date),
    CONSTRAINT fk_att_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_att_shift FOREIGN KEY (shift_id) REFERENCES shifts(shift_id) ON DELETE SET NULL,
    CONSTRAINT chk_att_ot CHECK (overtime_hours >= 0)
);

CREATE TABLE leave_types (
    leave_type_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    leave_name VARCHAR(80) NOT NULL,
    paid BOOLEAN NOT NULL DEFAULT TRUE,
    annual_limit DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    UNIQUE KEY uq_leave_type (company_id, leave_name),
    CONSTRAINT fk_leave_type_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_leave_limit CHECK (annual_limit >= 0)
);

CREATE TABLE employee_leaves (
    leave_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT UNSIGNED NOT NULL,
    leave_type_id BIGINT UNSIGNED NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    days DECIMAL(8,2) NOT NULL,
    status ENUM('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    reason VARCHAR(500),
    approved_by BIGINT UNSIGNED NULL,
    CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_leave_type FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    CONSTRAINT fk_leave_approver FOREIGN KEY (approved_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_leave_dates CHECK (to_date >= from_date AND days > 0)
);

CREATE TABLE salary_components (
    salary_component_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    component_name VARCHAR(100) NOT NULL,
    component_type ENUM('EARNING','DEDUCTION') NOT NULL,
    calculation_type ENUM('FIXED','PERCENTAGE') NOT NULL DEFAULT 'FIXED',
    default_value DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    UNIQUE KEY uq_salary_component (company_id, component_name),
    CONSTRAINT fk_salary_component_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_salary_component_value CHECK (default_value >= 0)
);

CREATE TABLE employee_salary_components (
    employee_salary_component_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT UNSIGNED NOT NULL,
    salary_component_id BIGINT UNSIGNED NOT NULL,
    value DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    effective_from DATE NOT NULL DEFAULT (CURRENT_DATE),
    effective_to DATE NULL,
    UNIQUE KEY uq_employee_salary_component (employee_id, salary_component_id, effective_from),
    CONSTRAINT fk_esc_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_esc_component FOREIGN KEY (salary_component_id) REFERENCES salary_components(salary_component_id),
    CONSTRAINT chk_esc_value CHECK (value >= 0),
    CONSTRAINT chk_esc_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

CREATE TABLE payroll_periods (
    payroll_period_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    period_name VARCHAR(50) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    status ENUM('OPEN','PROCESSING','PROCESSED','PAID','CLOSED') NOT NULL DEFAULT 'OPEN',
    UNIQUE KEY uq_payroll_period (company_id, period_name),
    CONSTRAINT fk_payroll_period_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_payroll_period_dates CHECK (period_end >= period_start)
);

CREATE TABLE payroll (
    payroll_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    payroll_period_id BIGINT UNSIGNED NOT NULL,
    employee_id BIGINT UNSIGNED NOT NULL,
    basic_salary DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    total_earnings DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    total_deductions DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    net_salary DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    payment_status ENUM('UNPAID','PAID') NOT NULL DEFAULT 'UNPAID',
    payment_date DATE NULL,
    UNIQUE KEY uq_payroll_employee_period (payroll_period_id, employee_id),
    CONSTRAINT fk_payroll_period FOREIGN KEY (payroll_period_id) REFERENCES payroll_periods(payroll_period_id) ON DELETE CASCADE,
    CONSTRAINT fk_payroll_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT chk_payroll_amounts CHECK (
        basic_salary >= 0 AND total_earnings >= 0 AND total_deductions >= 0
        AND net_salary >= 0
    )
);

CREATE TABLE payroll_lines (
    payroll_line_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    payroll_id BIGINT UNSIGNED NOT NULL,
    salary_component_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_payroll_line_payroll FOREIGN KEY (payroll_id) REFERENCES payroll(payroll_id) ON DELETE CASCADE,
    CONSTRAINT fk_payroll_line_component FOREIGN KEY (salary_component_id) REFERENCES salary_components(salary_component_id),
    CONSTRAINT chk_payroll_line_amount CHECK (amount >= 0)
);

-- =========================================================
-- EXPENSES / FIXED ASSETS
-- =========================================================

CREATE TABLE expense_categories (
    expense_category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    account_id BIGINT UNSIGNED NULL,
    UNIQUE KEY uq_expense_category (company_id, category_name),
    CONSTRAINT fk_expense_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_expense_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE SET NULL
);

CREATE TABLE expenses (
    expense_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NULL,
    expense_category_id BIGINT UNSIGNED NOT NULL,
    expense_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    amount DECIMAL(18,2) NOT NULL,
    description VARCHAR(500),
    payment_method_id BIGINT UNSIGNED NULL,
    created_by BIGINT UNSIGNED NULL,
    status ENUM('DRAFT','APPROVED','PAID','CANCELLED') NOT NULL DEFAULT 'DRAFT',
    CONSTRAINT fk_expense_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT fk_expense_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    CONSTRAINT fk_expense_category FOREIGN KEY (expense_category_id) REFERENCES expense_categories(expense_category_id),
    CONSTRAINT fk_expense_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id) ON DELETE SET NULL,
    CONSTRAINT fk_expense_user FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT chk_expense_amount CHECK (amount > 0)
);

CREATE TABLE fixed_assets (
    asset_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    asset_code VARCHAR(30) NOT NULL,
    asset_name VARCHAR(150) NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_cost DECIMAL(18,2) NOT NULL,
    useful_life_months INT UNSIGNED NOT NULL,
    residual_value DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    depreciation_method ENUM('STRAIGHT_LINE','DECLINING_BALANCE') NOT NULL DEFAULT 'STRAIGHT_LINE',
    status ENUM('ACTIVE','DISPOSED','FULLY_DEPRECIATED') NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_asset (company_id, asset_code),
    CONSTRAINT fk_asset_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
    CONSTRAINT chk_asset_cost CHECK (purchase_cost >= 0 AND residual_value >= 0 AND residual_value <= purchase_cost),
    CONSTRAINT chk_asset_life CHECK (useful_life_months > 0)
);

CREATE TABLE asset_depreciation (
    depreciation_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    asset_id BIGINT UNSIGNED NOT NULL,
    depreciation_date DATE NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    accumulated_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    UNIQUE KEY uq_asset_depreciation (asset_id, depreciation_date),
    CONSTRAINT fk_depreciation_asset FOREIGN KEY (asset_id) REFERENCES fixed_assets(asset_id) ON DELETE CASCADE,
    CONSTRAINT chk_depreciation_amount CHECK (amount >= 0 AND accumulated_amount >= 0)
);

-- =========================================================
-- AUDIT
-- =========================================================

CREATE TABLE audit_logs (
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NULL,
    user_id BIGINT UNSIGNED NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT UNSIGNED NULL,
    action ENUM('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','APPROVE','REJECT') NOT NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    ip_address VARCHAR(45),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_company FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE SET NULL,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX idx_stock_product_date ON stock_transactions(product_id, transaction_date);
CREATE INDEX idx_stock_batch ON stock_transactions(batch_id);
CREATE INDEX idx_inventory_expiry ON inventory_batches(expiry_date, status);
CREATE INDEX idx_purchase_supplier_date ON purchase_orders(supplier_id, po_date);
CREATE INDEX idx_sales_customer_date ON sales_orders(customer_id, order_date);
CREATE INDEX idx_invoice_customer_due ON sales_invoices(customer_id, due_date, status);
CREATE INDEX idx_crm_customer_date ON crm_activities(customer_id, activity_date);
CREATE INDEX idx_production_status ON production_orders(status, planned_start);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_payroll_period ON payroll(payroll_period_id);
CREATE INDEX idx_journal_date ON journal_entries(entry_date, status);

-- =========================================================
-- SEED MASTER DATA
-- =========================================================

INSERT INTO roles (role_name, description) VALUES
('ADMIN','Full system access'),
('MANAGEMENT','Management dashboards and reports'),
('PURCHASE','Purchase management'),
('INVENTORY','Warehouse and inventory management'),
('PRODUCTION','Manufacturing and production'),
('SALES','Sales and distribution'),
('CRM','Customer relationship management'),
('ACCOUNTING','Finance and accounting'),
('HR','Human resources and payroll'),
('QUALITY','Quality control');

INSERT INTO units (unit_code, unit_name, decimal_places) VALUES
('PCS','Pieces',0),
('KG','Kilogram',3),
('G','Gram',2),
('L','Litre',3),
('ML','Millilitre',2),
('BOX','Box',0),
('CARTON','Carton',0),
('HR','Hour',2);

INSERT INTO account_types (type_name, normal_balance) VALUES
('ASSET','DEBIT'),
('LIABILITY','CREDIT'),
('EQUITY','CREDIT'),
('REVENUE','CREDIT'),
('EXPENSE','DEBIT'),
('COST_OF_GOODS_SOLD','DEBIT');

-- =========================================================
-- VIEWS
-- =========================================================

CREATE VIEW vw_current_stock AS
SELECT
    ib.product_id,
    p.sku,
    p.product_name,
    ib.warehouse_id,
    w.warehouse_name,
    ib.batch_no,
    ib.expiry_date,
    ib.quantity,
    ib.reserved_quantity,
    (ib.quantity - ib.reserved_quantity) AS available_quantity,
    ib.unit_cost,
    ib.status
FROM inventory_batches ib
JOIN products p ON p.product_id = ib.product_id
JOIN warehouses w ON w.warehouse_id = ib.warehouse_id;

CREATE VIEW vw_customer_outstanding AS
SELECT
    si.customer_id,
    c.customer_code,
    c.customer_name,
    SUM(si.total_amount) AS invoiced_amount,
    SUM(si.paid_amount) AS paid_amount,
    SUM(si.total_amount - si.paid_amount) AS outstanding_amount
FROM sales_invoices si
JOIN customers c ON c.customer_id = si.customer_id
WHERE si.status <> 'CANCELLED'
GROUP BY si.customer_id, c.customer_code, c.customer_name;

CREATE VIEW vw_supplier_purchase_summary AS
SELECT
    po.supplier_id,
    s.supplier_code,
    s.supplier_name,
    COUNT(po.po_id) AS purchase_orders,
    SUM(po.total_amount) AS total_purchase_value
FROM purchase_orders po
JOIN suppliers s ON s.supplier_id = po.supplier_id
WHERE po.status <> 'CANCELLED'
GROUP BY po.supplier_id, s.supplier_code, s.supplier_name;

CREATE VIEW vw_production_summary AS
SELECT
    po.production_order_id,
    po.order_number,
    p.sku,
    p.product_name,
    po.planned_qty,
    po.produced_qty,
    po.rejected_qty,
    po.status,
    po.planned_start,
    po.planned_end
FROM production_orders po
JOIN products p ON p.product_id = po.finished_product_id;

SET FOREIGN_KEY_CHECKS = 1;

-- End of schema.
