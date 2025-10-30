-- Test script to verify quantity updates are working properly

-- First, let's see current food listings with quantities
SELECT id, foodName, quantity, quantityUnit, status, isActive 
FROM food_listings 
WHERE isActive = 1 
ORDER BY id DESC 
LIMIT 5;

-- Check if there are any food requests
SELECT fr.id, fr.foodListingId, fr.requestedQuantity, fr.status, 
       fl.foodName, fl.quantity as availableQuantity, fl.quantityUnit
FROM food_requests fr 
JOIN food_listings fl ON fr.foodListingId = fl.id 
ORDER BY fr.id DESC 
LIMIT 5;

-- Show the data types of the quantity columns
DESCRIBE food_listings;
DESCRIBE food_requests;