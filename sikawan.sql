DROP DATABASE IF EXISTS `sikawan`;
CREATE DATABASE `sikawan` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `sikawan`;

CREATE TABLE `mitra_warung` (
  `id_mitra` INT NOT NULL AUTO_INCREMENT,
  `kode_mitra` VARCHAR(30) DEFAULT NULL,
  `nama_mitra` VARCHAR(100) NOT NULL,
  `nama_warung` VARCHAR(150) DEFAULT NULL,
  `telepon` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `alamat` TEXT DEFAULT NULL,
  `status` ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mitra`),
  INDEX `idx_mitra_kode` (`kode_mitra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `produk_titipan` (
  `id_produk` INT NOT NULL AUTO_INCREMENT,
  `id_mitra` INT NOT NULL,
  `kode_produk` VARCHAR(30) DEFAULT NULL,
  `nama_barang` VARCHAR(150) NOT NULL,
  `harga_jual` DECIMAL(12,2) NOT NULL,
  `jenis_bagi_hasil` ENUM('nominal', 'persen') NOT NULL DEFAULT 'nominal',
  `nilai_bagi_hasil` DECIMAL(12,2) NOT NULL,
  `stok` INT NOT NULL DEFAULT 0,
  `stok_minimum` INT NOT NULL DEFAULT 3,
  `batas_waktu` VARCHAR(20) DEFAULT NULL,
  `status` ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
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
  `harga_satuan` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `total_penjualan` DECIMAL(12,2) NOT NULL,
  `laba_warung` DECIMAL(12,2) NOT NULL,
  `hak_uang_mitra` DECIMAL(12,2) NOT NULL,
  `status` ENUM('tercatat', 'sudah_setor') NOT NULL DEFAULT 'tercatat',
  `tanggal` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tanggal_setor` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_transaksi`),
  INDEX `idx_transaksi_mitra` (`id_mitra`),
  INDEX `idx_transaksi_produk` (`id_produk`),
  INDEX `idx_transaksi_tanggal` (`tanggal`),
  INDEX `idx_transaksi_status` (`status`),
  CONSTRAINT `fk_transaksi_mitra`
    FOREIGN KEY (`id_mitra`) REFERENCES `mitra_warung` (`id_mitra`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transaksi_produk`
    FOREIGN KEY (`id_produk`) REFERENCES `produk_titipan` (`id_produk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `mitra_warung` (`kode_mitra`, `nama_mitra`, `nama_warung`, `telepon`, `email`, `alamat`) VALUES
('MIT-01', 'Budi Santoso', 'Warung Bu Tini', '081234567890', 'budi@example.com', 'Jl. Merdeka No. 1, Jakarta'),
('MIT-02', 'Siti Rahayu', 'Warung Pak Joko', '081298765432', 'siti@example.com', 'Jl. Sudirman No. 22, Bandung');

INSERT INTO `produk_titipan` (`id_mitra`, `kode_produk`, `nama_barang`, `harga_jual`, `jenis_bagi_hasil`, `nilai_bagi_hasil`, `stok`, `stok_minimum`, `batas_waktu`) VALUES
(1, 'PRD-01', 'Keripik Pisang', 15000.00, 'persen', 30.00, 50, 5, '31/12/2026'),
(2, 'PRD-02', 'Abon Sapi', 45000.00, 'nominal', 15000.00, 20, 3, '31/12/2026');

INSERT INTO `transaksi_penjualan` (`id_mitra`, `id_produk`, `jumlah_terjual`, `harga_satuan`, `total_penjualan`, `laba_warung`, `hak_uang_mitra`, `tanggal`) VALUES
(1, 1, 3, 15000.00, 45000.00, 31500.00, 13500.00, NOW()),
(2, 2, 2, 45000.00, 90000.00, 60000.00, 30000.00, NOW());
