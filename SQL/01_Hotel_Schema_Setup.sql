-- Hotel Management Schema Setup

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    booking_date DATE,
    room_no INT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
    id INT PRIMARY KEY,
    booking_id INT,
    bill_id INT,
    bill_date DATE,
    item_id INT,
    item_quantity INT,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Insert Sample Data (example only, add your own as needed)
INSERT INTO users VALUES (1,'John'),(2,'Mary');

INSERT INTO bookings VALUES
(101,'2021-11-10',201,1),
(102,'2021-11-21',105,2);

INSERT INTO items VALUES
(1,'Coffee',50),
(2,'Sandwich',120);

INSERT INTO booking_commercials VALUES
(1,101,5001,'2021-11-10',1,2),
(2,101,5001,'2021-11-10',2,1),
(3,102,5005,'2021-10-10',1,5);
