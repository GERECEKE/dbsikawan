DROP DATABASE IF EXISTS `sikawan`;
CREATE DATABASE `sikawan` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `sikawan`;

CREATE TABLE `mitra_warung` (
  `id_mitra` INT NOT NULL AUTO_INCREMENT,
  `nama_mitra` VARCHAR(100) NOT NULL,
  `nama_warung` VARCHAR(150) NOT NULL,
  `telepon` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `alamat` TEXT DEFAULT NULL,
  `status` ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mitra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `produk_titipan` (
  `id_produk` INT NOT NULL AUTO_INCREMENT,
  `id_mitra` INT NOT NULL,
  `nama_barang` VARCHAR(150) NOT NULL,
  `harga_jual` DECIMAL(12,2) NOT NULL,
  `jenis_bagi_hasil` ENUM('nominal', 'persen') NOT NULL DEFAULT 'persen',
  `nilai_bagi_hasil` DECIMAL(12,2) NOT NULL,
  `stok` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_produk`),
  INDEX `idx_produk_mitra` (`id_mitra`),
  CONSTRAINT `fk_produk_mitra`
    FOREIGN KEY (`id_mitra`) REFERENCES `mitra_warung` (`id_mitra`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `transaksi_penjualan` (
  `id_transaksi` INT NOT NULL AUTO_INCREMENT,
  `id_mitra` INT NOT NULL,
  `id_produk` INT NOT NULL,
  `jumlah_terjual` INT NOT NULL,
  `total_penjualan` DECIMAL(12,2) NOT NULL,
  `laba_warung` DECIMAL(12,2) NOT NULL,
  `hak_uang_mitra` DECIMAL(12,2) NOT NULL,
  `tanggal` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transaksi`),
  INDEX `idx_transaksi_mitra` (`id_mitra`),
  INDEX `idx_transaksi_produk` (`id_produk`),
  INDEX `idx_transaksi_tanggal` (`tanggal`),
  CONSTRAINT `fk_transaksi_mitra`
    FOREIGN KEY (`id_mitra`) REFERENCES `mitra_warung` (`id_mitra`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_transaksi_produk`
    FOREIGN KEY (`id_produk`) REFERENCES `produk_titipan` (`id_produk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `mitra_warung` (`nama_mitra`, `nama_warung`, `telepon`, `email`, `alamat`) VALUES
('Budi Santoso', 'Warung Bu Tini', '081234567890', 'budi@example.com', 'Jl. Merdeka No. 1, Jakarta'),
('Siti Rahayu', 'Warung Pak Joko', '081298765432', 'siti@example.com', 'Jl. Sudirman No. 22, Bandung');

INSERT INTO `produk_titipan` (`id_mitra`, `nama_barang`, `harga_jual`, `jenis_bagi_hasil`, `nilai_bagi_hasil`, `stok`) VALUES
(1, 'Keripik Pisang', 15000.00, 'persen', 30.00, 50),
(2, 'Abon Sapi', 45000.00, 'nominal', 15000.00, 20);

INSERT INTO `transaksi_penjualan` (`id_mitra`, `id_produk`, `jumlah_terjual`, `total_penjualan`, `laba_warung`, `hak_uang_mitra`, `tanggal`) VALUES
(1, 1, 3, 45000.00, 31500.00, 13500.00, NOW()),
(2, 2, 2, 90000.00, 60000.00, 30000.00, NOW());