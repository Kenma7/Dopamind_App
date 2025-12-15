-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 15, 2025 at 10:55 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dopamind_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `mood_entries`
--

CREATE TABLE `mood_entries` (
  `id` int(11) NOT NULL,
  `mood` varchar(20) NOT NULL,
  `note` text DEFAULT NULL,
  `created_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mood_entries`
--

INSERT INTO `mood_entries` (`id`, `mood`, `note`, `created_date`, `created_at`) VALUES
(1, 'Baik', '', '2025-12-15', '2025-12-15 05:20:23'),
(2, 'Sangat Baik', '', '2025-12-16', '2025-12-15 17:31:52');

-- --------------------------------------------------------

--
-- Table structure for table `myjournal`
--

CREATE TABLE `myjournal` (
  `id` int(11) NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `type` varchar(50) DEFAULT 'reflection',
  `mood` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `myjournal`
--

INSERT INTO `myjournal` (`id`, `content`, `created_at`, `type`, `mood`) VALUES
(8, 'hari ini adalah hari biasa yang berubah menjadi luar biasa dalam perjalanan pulang kuliah. Aku memutuskan pulang lebih awal Dan berjalan kaki menyusuri jalan kecil yang tidak pernah ku lewati sebelumnya.', '2025-12-15 13:58:21', 'reflection', ''),
(9, 'Kemari aku bertemu dengan seseorang yang tidak pernah kukira akan memberikan impact sebesar ini. Di coffe shop dekat rumah, ada seorang wanita seumuranku duduk sendirian. Aku yang kebetulan juga sendirian, akhirnya mengajaknya mengobrol.', '2025-12-15 14:02:00', 'reflection', ''),
(10, 'hari ini adalah Salah satu hari di mana dunia Teresa bergerak lambat, tapi pikiranku justru berlari kencang. Pagi dimulai dengan kuliah yang cukup intens di kelas. presentasi yang sudah kusiapkan seminggu ternyata harus diubah last minute karena ada perubahan data. Aku merasa sedikit overwhelmed, tapi berhasil tetap tenang', '2025-12-15 14:02:03', 'reflection', ''),
(13, 'malam ini adalah malam pertama dalam waktu lama aku benar-benar sendirian di kontrakan. BIasanya aku akan merasa cemas, mencari distraksi, atau menghubungi seseorang. Tapi hari ini, aku memutuskan untuk berbeda', '2025-12-15 15:42:34', 'reflection', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mood_entries`
--
ALTER TABLE `mood_entries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `myjournal`
--
ALTER TABLE `myjournal`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mood_entries`
--
ALTER TABLE `mood_entries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `myjournal`
--
ALTER TABLE `myjournal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
