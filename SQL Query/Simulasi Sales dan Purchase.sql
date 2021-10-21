USE Bejibun

-- D
--Simulasi sales transaction made by Customer
/* 
 Simulasi dimana Diego Perry, seorang Customer dengan ID CU003
 membeli 100 Apple, 300 Kitkat, serta 600 Shirt pada tanggal 12 Desember 2020.
 Pembelian dilayani oleh Aldo, seorang staff dengan ID ST005.
*/

INSERT INTO TrSales 
VALUES ('SA938', 'ST005', 'CU003', '12/12/2020')

INSERT INTO TrSalesDetail
VALUES ('SA938', 'IT123', 100),
('SA938', 'IT326', 300),
('SA938', 'IT999', 600)

-- Simulasi Purchase transaction by staff
/*
 Kevin Metro, seorang staff Bejibun dengan ID ST168 ingin menambah stok
 Apel, Kitkat, serta Doritos. Kevin ingin membeli barang-barang tersebut
 dari Maiora, sebuah vendor makanan dengan ID VE876.

 Kevin melakukan purchase pada tanggal 12 Desember 2020.
 Karena Maiora tidak memberikan tanggal estimasi barang-barang tersebut sampai,
 maka Kevin membiarkan ArrivalDate kosong.
*/

INSERT INTO TrPurchase
VALUES ('PH928', 'ST168', 'VE876', '12/12/2020', NULL)

INSERT INTO TrPurchaseDetail
VALUES ('PH928', 'IT123', 1000),
('PH928', 'IT326', 5000),
('PH928', 'IT678', 500)