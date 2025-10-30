-- Fix quantity column to handle decimal values properly
ALTER TABLE food_listings MODIFY COLUMN quantity DOUBLE NOT NULL DEFAULT 1.0;

-- Update any existing integer quantities to ensure they work with decimal operations
UPDATE food_listings SET quantity = CAST(quantity AS DOUBLE) WHERE quantity IS NOT NULL;