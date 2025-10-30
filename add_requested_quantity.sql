-- Add requested quantity column to food_requests table
ALTER TABLE food_requests ADD COLUMN requestedQuantity DOUBLE DEFAULT 1.0;

-- Update existing records to have a default value
UPDATE food_requests SET requestedQuantity = 1.0 WHERE requestedQuantity IS NULL;