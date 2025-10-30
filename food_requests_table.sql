-- Food Requests Table Creation Script
-- Run this if the food_requests table doesn't exist or needs to be updated

-- Drop and recreate table to ensure correct structure
DROP TABLE IF EXISTS food_requests;

CREATE TABLE food_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ngoId INT NOT NULL,
    foodListingId INT NOT NULL,
    requestMessage TEXT,
    pickupDate DATE NOT NULL,
    pickupTime TIME,
    status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
    donorResponse TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    isActive BOOLEAN DEFAULT TRUE,
    
    INDEX idx_ngo_id (ngoId),
    INDEX idx_food_listing_id (foodListingId),
    INDEX idx_status (status),
    INDEX idx_created_at (createdAt)
);

-- Insert sample data for testing (using first available user and food listing)
INSERT INTO food_requests (ngoId, foodListingId, requestMessage, pickupDate, pickupTime, status) 
SELECT 
    (SELECT id FROM users ORDER BY id LIMIT 1) as ngoId,
    (SELECT id FROM food_listings WHERE isActive=1 ORDER BY id LIMIT 1) as foodListingId,
    'Sample request for testing purposes' as requestMessage,
    DATE_ADD(CURDATE(), INTERVAL 1 DAY) as pickupDate,
    '14:00:00' as pickupTime,
    'pending' as status
WHERE EXISTS (SELECT 1 FROM users) 
  AND EXISTS (SELECT 1 FROM food_listings WHERE isActive=1);

-- Notifications table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ngo_id INT NOT NULL,
    donor_id INT,
    food_listing_id INT,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'general',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (ngo_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (donor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (food_listing_id) REFERENCES food_listings(id) ON DELETE CASCADE,
    
    INDEX idx_ngo_id (ngo_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);

-- Verify the data was inserted
SELECT 'Food Requests Created:' as info, COUNT(*) as count FROM food_requests;
SELECT 'Sample Request Details:' as info, fr.id, fr.ngoId, fr.foodListingId, fr.status, fr.pickupDate 
FROM food_requests fr LIMIT 1;