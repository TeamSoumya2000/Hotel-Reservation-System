create database hotel;
use hotel;

CREATE TABLE Guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    city VARCHAR(50)
);
desc guests;

CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number INT UNIQUE,
    room_type VARCHAR(30),
    price_per_night DECIMAL(10,2),
    status VARCHAR(20)
);

desc Rooms;

CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    reservation_status VARCHAR(20),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

desc reservations;

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_mode VARCHAR(20),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);

desc payments;

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_name VARCHAR(100),
    role VARCHAR(50),
    salary DECIMAL(10,2)
);

desc staff;

INSERT INTO Guests (guest_name, phone, email, city) VALUES
('Amit Sharma','9876543210','amit@gmail.com','Delhi'),
('Riya Das','9123456789','riya@gmail.com','Kolkata'),
('Rahul Verma','9988776655','rahul@gmail.com','Mumbai'),
('Sneha Roy','9012345678','sneha@gmail.com','Pune');

select * from guests;

INSERT INTO Rooms (room_number, room_type, price_per_night, status) VALUES
(101,'Single',1500,'Available'),
(102,'Double',2500,'Occupied'),
(201,'Deluxe',3500,'Available'),
(202,'Suite',6000,'Occupied');

select * from rooms;

INSERT INTO Reservations (guest_id, room_id, check_in, check_out, reservation_status) VALUES
(1,2,'2026-01-05','2026-01-08','Checked-out'),
(2,4,'2026-01-09','2026-01-12','Checked-in'),
(3,1,'2026-01-10','2026-01-11','Booked');

select * from reservations;

INSERT INTO Payments (reservation_id, amount, payment_date, payment_mode) VALUES
(1,7500,'2026-01-08','Card'),
(2,18000,'2026-01-09','UPI');

select * from payments;

INSERT INTO Staff (staff_name, role, salary) VALUES
('Ramesh Kumar','Manager',45000),
('Anita Singh','Receptionist',22000),
('Sourav Paul','Housekeeping',18000);

select * from staff;

#---------------------------------------------------------
select * from guests;
select * from rooms;
select * from reservations;
select * from payments;
select * from staff;

#List all guests
select * from guests;

/*1. Displays the complete list of all registered guests.
  2. Helps verify guest data before performing further analysis.*/

#Count total guests
SELECT COUNT(*) AS total_guests FROM Guests;

/*1. Shows the total number of guests registered in the hotel system.
  2. Helps measure the overall customer base size for planning and analysis.*/

#Show available rooms
SELECT room_number, room_type FROM Rooms
WHERE status = 'Available';

/*1. Identifies rooms that are currently available for booking.

  2. Helps front desk and management manage room availability efficiently.*/

#Show occupied rooms
SELECT room_number FROM Rooms
WHERE status = 'Occupied';

#Show all reservations with guest names
SELECT g.guest_name, r.room_number, res.check_in, res.check_out
FROM Reservations res
JOIN Guests g ON res.guest_id = g.guest_id
JOIN Rooms r ON res.room_id = r.room_id;

#Total revenue generated
SELECT SUM(amount) AS total_revenue FROM Payments;

#Average room price
SELECT AVG(price_per_night) AS avg_price FROM Rooms;

#Payment details with guest name
SELECT g.guest_name, p.amount, p.payment_mode
FROM Payments p
JOIN Reservations r ON p.reservation_id = r.reservation_id
JOIN Guests g ON r.guest_id = g.guest_id;

#Highest priced room
SELECT room_number, price_per_night
FROM Rooms
ORDER BY price_per_night DESC
LIMIT 1;

#Reservations count per room type
SELECT rm.room_type, COUNT(res.reservation_id) AS bookings
FROM Reservations res
JOIN Rooms rm ON res.room_id = rm.room_id
GROUP BY rm.room_type;

#Guests who made payments
SELECT DISTINCT g.guest_name
FROM Guests g
JOIN Reservations r ON g.guest_id = r.guest_id
JOIN Payments p ON r.reservation_id = p.reservation_id;

#Occupancy rate of hotel
SELECT 
(COUNT(CASE WHEN status='Occupied' THEN 1 END)*100.0)/COUNT(*) AS occupancy_rate
FROM Rooms;

#Revenue by room type
SELECT rm.room_type, SUM(p.amount) AS revenue
FROM Payments p
JOIN Reservations r ON p.reservation_id = r.reservation_id
JOIN Rooms rm ON r.room_id = rm.room_id
GROUP BY rm.room_type;

#Highest paying guest
SELECT g.guest_name, SUM(p.amount) AS total_paid
FROM Payments p
JOIN Reservations r ON p.reservation_id = r.reservation_id
JOIN Guests g ON r.guest_id = g.guest_id
GROUP BY g.guest_name
ORDER BY total_paid DESC
LIMIT 1;

#Guests staying more than 2 days
SELECT g.guest_name,
DATEDIFF(res.check_out, res.check_in) AS stay_days
FROM Reservations res
JOIN Guests g ON res.guest_id = g.guest_id
WHERE DATEDIFF(res.check_out, res.check_in) > 2;

#Rooms never booked
SELECT room_number FROM Rooms
WHERE room_id NOT IN (SELECT room_id FROM Reservations);

#Total staff salary
SELECT SUM(salary) AS total_salary FROM Staff;

#Highest paid staff member
SELECT staff_name, salary
FROM Staff
ORDER BY salary DESC
LIMIT 1;

#Number of stays per guest
SELECT g.guest_name, COUNT(r.reservation_id) AS total_stays
FROM Guests g
LEFT JOIN Reservations r ON g.guest_id = r.guest_id
GROUP BY g.guest_name;

#Monthly revenue
SELECT MONTH(payment_date) AS month, SUM(amount) AS revenue
FROM Payments
GROUP BY MONTH(payment_date);










