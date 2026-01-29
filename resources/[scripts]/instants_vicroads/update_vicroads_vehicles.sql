-- Add new columns to vicroads_vehicles table for registration information
-- Run this SQL command in your database to add color, type, state, make, model, and imageUrl columns

ALTER TABLE `vicroads_vehicles` 
ADD COLUMN IF NOT EXISTS `color` VARCHAR(50) DEFAULT 'Unknown' AFTER `plate`,
ADD COLUMN IF NOT EXISTS `type` VARCHAR(50) DEFAULT 'Unknown' AFTER `color`,
ADD COLUMN IF NOT EXISTS `state` VARCHAR(50) DEFAULT 'Unknown' AFTER `type`,
ADD COLUMN IF NOT EXISTS `make` VARCHAR(100) DEFAULT 'Unknown' AFTER `state`,
ADD COLUMN IF NOT EXISTS `model` VARCHAR(100) DEFAULT 'Unknown' AFTER `make`,
ADD COLUMN IF NOT EXISTS `imageUrl` TEXT AFTER `model`;
