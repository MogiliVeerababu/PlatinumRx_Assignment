CREATE TABLE clinics (
    cid INT PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE clinic_sales (
    oid INT PRIMARY KEY,
    uid INT,
    cid INT,
    amount DECIMAL(10,2),
    datetime TIMESTAMP,
    sales_channel VARCHAR(20),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid INT PRIMARY KEY,
    cid INT,
    description VARCHAR(100),
    amount DECIMAL(10,2),
    datetime TIMESTAMP,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Add your own sample data as needed
