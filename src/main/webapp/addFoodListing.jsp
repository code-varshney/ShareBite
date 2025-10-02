<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Food Listing - Sharebite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBsFCAk-aMJNbajQouFgSQ_7ErRrw8dZ-M&libraries=places"></script>

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .form-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 2.5rem;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .form-header h2 {
            color: #333;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .form-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .form-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .form-section h5 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .form-section h5 i {
            margin-right: 0.5rem;
            color: #667eea;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-submit {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            padding: 1rem 2rem;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-submit:hover {
            background: linear-gradient(45deg, #5a6fd8, #6a4190);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            color: white;
        }
        
        .btn-back {
            background: #6c757d;
            border: none;
            border-radius: 25px;
            padding: 0.75rem 1.5rem;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        
        .image-preview {
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 2rem;
            text-align: center;
            background: #f8f9fa;
            transition: all 0.3s ease;
        }
        
        .image-preview:hover {
            border-color: #667eea;
            background: #f0f2ff;
        }
        
        .image-preview img {
            max-width: 100%;
            max-height: 200px;
            border-radius: 10px;
        }
        
        #map {
            height: 400px;
            width: 100%;
            border-radius: 10px;
            border: 2px solid #e9ecef;
        }
        

    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <h2><i class="fas fa-plus-circle me-2"></i>Add New Food Listing</h2>
                <p>Share your surplus food and help reduce waste in your community</p>
                <% String error = request.getParameter("error"); String success = request.getParameter("success"); %>
                <% if (error != null) { %>
                    <div class="alert alert-danger mt-3">
                        <% if ("missing_fields".equals(error)) { %>
                            Please fill in all required fields.
                        <% } else if ("invalid_expiry".equals(error)) { %>
                            Please select a valid future expiry date.
                        <% } else if ("creation_failed".equals(error)) { %>
                            Failed to add food listing. Please try again.
                        <% } else { %>
                            <%= error %>
                        <% } %>
                    </div>
                <% } %>
                <% if (success != null && "listing_created".equals(success)) { %>
                    <div class="alert alert-success mt-3">
                        Food listing added successfully!
                    </div>
                <% } %>
            </div>
            
            <form action="addFoodListingProcess.jsp" method="post" id="foodListingForm">
                
                <!-- Basic Food Information -->
                <div class="form-section">
                    <h5><i class="fas fa-utensils"></i>Food Information</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="foodName" class="form-label required-field">Food Name</label>
                            <input type="text" class="form-control" id="foodName" name="foodName" 
                                   placeholder="e.g., Fresh Vegetables, Bread, Canned Goods" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="foodType" class="form-label required-field">Food Type</label>
                            <select class="form-select" id="foodType" name="foodType" required>
                                <option value="">Select Food Type</option>
                                <option value="fresh">Fresh</option>
                                <option value="canned">Canned</option>
                                <option value="baked">Baked</option>
                                <option value="dairy">Dairy</option>
                                <option value="frozen">Frozen</option>
                                <option value="packaged">Packaged</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" 
                                  placeholder="Describe the food items, ingredients, condition, etc."></textarea>
                    </div>
                </div>
                
                <!-- Quantity and Expiry -->
                <div class="form-section">
                    <h5><i class="fas fa-weight"></i>Quantity and Expiry</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="quantity" class="form-label required-field">Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" 
                                   min="1" placeholder="Enter quantity" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="quantityUnit" class="form-label required-field">Unit</label>
                            <select class="form-select" id="quantityUnit" name="quantityUnit" required>
                                <option value="">Select Unit</option>
                                <option value="kg">Kilograms (kg)</option>
                                <option value="lbs">Pounds (lbs)</option>
                                <option value="pieces">Pieces</option>
                                <option value="boxes">Boxes</option>
                                <option value="bags">Bags</option>
                                <option value="cans">Cans</option>
                                <option value="liters">Liters</option>
                                <option value="gallons">Gallons</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="expiryDate" class="form-label required-field">Expiry Date</label>
                        <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
                        <small class="form-text text-muted">Please ensure the expiry date is accurate for food safety</small>
                    </div>
                </div>
                
                <!-- Pickup Information -->
                <div class="form-section">
                    <h5><i class="fas fa-map-marker-alt"></i>Pickup Information</h5>
                    <div class="mb-3">
                        <button type="button" class="btn btn-outline-primary" onclick="getCurrentLocation()">
                            <i class="fas fa-location-arrow me-2"></i>Use Current Location
                        </button>
                        <small class="form-text text-muted d-block mt-1">Click to automatically fill address with your current location</small>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="pickupAddress" class="form-label required-field">Pickup Address</label>
                            <input type="text" class="form-control" id="pickupAddress" name="pickupAddress" 
                                   placeholder="Street address" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="pickupCity" class="form-label required-field">City</label>
                            <input type="text" class="form-control" id="pickupCity" name="pickupCity" 
                                   placeholder="City name" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="pickupState" class="form-label required-field">State</label>
                            <input type="text" class="form-control" id="pickupState" name="pickupState" 
                                   placeholder="State name" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="pickupZipCode" class="form-label required-field">ZIP Code</label>
                            <input type="text" class="form-control" id="pickupZipCode" name="pickupZipCode" 
                                   placeholder="ZIP code" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Select Location on Map</label>
                        <div id="map"></div>
                        <small class="form-text text-muted">Click on the map to set pickup location</small>
                        <input type="hidden" id="latitude" name="latitude" value="40.7128">
                        <input type="hidden" id="longitude" name="longitude" value="-74.0060">
                    </div>
                    <div class="mb-3">
                        <label for="pickupInstructions" class="form-label">Pickup Instructions</label>
                        <textarea class="form-control" id="pickupInstructions" name="pickupInstructions" rows="2" 
                                  placeholder="Any special instructions for pickup (e.g., call before arrival, specific entrance, etc.)"></textarea>
                    </div>
                </div>
                
                <!-- Image Upload -->
                <div class="form-section">
                    <h5><i class="fas fa-image"></i>Food Image (Optional)</h5>
                    <div class="mb-3">
                        <input type="file" class="form-control" id="foodImage" name="foodImage" 
                               accept="image/*" onchange="previewImage(this)">
                    </div>
                    <div class="image-preview" id="imagePreview">
                        <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                        <p class="text-muted">Upload an image to help NGOs better understand the food items</p>
                    </div>
                </div>
                
                <!-- Additional Information -->
                <div class="form-section">
                    <h5><i class="fas fa-info-circle"></i>Additional Information</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="storageCondition" class="form-label">Storage Condition</label>
                            <select class="form-select" id="storageCondition" name="storageCondition">
                                <option value="">Select Condition</option>
                                <option value="refrigerated">Refrigerated</option>
                                <option value="frozen">Frozen</option>
                                <option value="room_temperature">Room Temperature</option>
                                <option value="dry_storage">Dry Storage</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="allergenInfo" class="form-label">Allergen Information</label>
                            <input type="text" class="form-control" id="allergenInfo" name="allergenInfo" 
                                   placeholder="e.g., Contains nuts, gluten-free, etc.">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="specialNotes" class="form-label">Special Notes</label>
                        <textarea class="form-control" id="specialNotes" name="specialNotes" rows="2" 
                                  placeholder="Any additional information NGOs should know"></textarea>
                    </div>
                </div>
                
                <!-- Submit Buttons -->
                <div class="row mt-4">
                    <div class="col-md-4">
                        <a href="donorDashboard.jsp" class="btn btn-back w-100">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                    <div class="col-md-8">
                        <button type="submit" class="btn btn-submit">
                            <i class="fas fa-plus me-2"></i>Add Food Listing
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let map;
        let marker;
        let geocoder;
        
        // Set minimum date to today and initialize map
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('expiryDate').min = today;
            
            // Initialize Google Map
            initMap();
        });
        
        function initMap() {
            // Default location (New York City)
            const defaultLocation = { lat: 40.7128, lng: -74.0060 };
            
            // Create map
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 13,
                center: defaultLocation,
                mapTypeId: 'roadmap'
            });
            
            // Create marker
            marker = new google.maps.Marker({
                position: defaultLocation,
                map: map,
                draggable: true,
                title: 'Pickup Location'
            });
            
            // Initialize geocoder
            geocoder = new google.maps.Geocoder();
            
            // Add click listener to map
            map.addListener('click', function(event) {
                updateMarkerPosition(event.latLng);
            });
            
            // Add drag listener to marker
            marker.addListener('dragend', function(event) {
                updateMarkerPosition(event.latLng);
            });
            
            // Update coordinates on load
            updateCoordinates(defaultLocation.lat, defaultLocation.lng);
        }
        
        function updateMarkerPosition(latLng) {
            marker.setPosition(latLng);
            updateCoordinates(latLng.lat(), latLng.lng());
            
            // Reverse geocode to get address
            geocoder.geocode({ location: latLng }, function(results, status) {
                if (status === 'OK' && results[0]) {
                    const addressComponents = results[0].address_components;
                    let streetNumber = '';
                    let route = '';
                    let city = '';
                    let state = '';
                    let zipCode = '';
                    
                    for (let component of addressComponents) {
                        const types = component.types;
                        if (types.includes('street_number')) {
                            streetNumber = component.long_name;
                        } else if (types.includes('route')) {
                            route = component.long_name;
                        } else if (types.includes('locality')) {
                            city = component.long_name;
                        } else if (types.includes('administrative_area_level_1')) {
                            state = component.short_name;
                        } else if (types.includes('postal_code')) {
                            zipCode = component.long_name;
                        }
                    }
                    
                    // Update form fields
                    document.getElementById('pickupAddress').value = streetNumber + ' ' + route;
                    document.getElementById('pickupCity').value = city;
                    document.getElementById('pickupState').value = state;
                    document.getElementById('pickupZipCode').value = zipCode;
                }
            });
        }
        
        function updateCoordinates(lat, lng) {
            document.getElementById('latitude').value = lat.toFixed(6);
            document.getElementById('longitude').value = lng.toFixed(6);
        }
        

        
        // Get current location
        function getCurrentLocation() {
            if (navigator.geolocation) {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Getting Location...';
                button.disabled = true;
                
                navigator.geolocation.getCurrentPosition(
                    function(position) {
                        const lat = position.coords.latitude;
                        const lng = position.coords.longitude;
                        const currentLocation = { lat: lat, lng: lng };
                        
                        // Update map and marker
                        map.setCenter(currentLocation);
                        marker.setPosition(currentLocation);
                        updateCoordinates(lat, lng);
                        
                        // Reverse geocode to get address
                        geocoder.geocode({ location: currentLocation }, function(results, status) {
                            if (status === 'OK' && results[0]) {
                                const addressComponents = results[0].address_components;
                                let streetNumber = '';
                                let route = '';
                                let city = '';
                                let state = '';
                                let zipCode = '';
                                
                                for (let component of addressComponents) {
                                    const types = component.types;
                                    if (types.includes('street_number')) {
                                        streetNumber = component.long_name;
                                    } else if (types.includes('route')) {
                                        route = component.long_name;
                                    } else if (types.includes('locality')) {
                                        city = component.long_name;
                                    } else if (types.includes('administrative_area_level_1')) {
                                        state = component.short_name;
                                    } else if (types.includes('postal_code')) {
                                        zipCode = component.long_name;
                                    }
                                }
                                
                                // Update form fields
                                document.getElementById('pickupAddress').value = streetNumber + ' ' + route;
                                document.getElementById('pickupCity').value = city;
                                document.getElementById('pickupState').value = state;
                                document.getElementById('pickupZipCode').value = zipCode;
                            }
                        });
                        
                        button.innerHTML = originalText;
                        button.disabled = false;
                    },
                    function(error) {
                        alert('Error getting location: ' + error.message);
                        button.innerHTML = originalText;
                        button.disabled = false;
                    },
                    {
                        enableHighAccuracy: true,
                        timeout: 10000,
                        maximumAge: 60000
                    }
                );
            } else {
                alert('Geolocation is not supported by this browser.');
            }
        }
        

        
        // Image preview functionality
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.innerHTML = `
                        <img src="${e.target.result}" alt="Food Preview" class="mb-2">
                        <p class="text-muted">Image preview</p>
                    `;
                };
                
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.innerHTML = `
                    <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                    <p class="text-muted">Upload an image to help NGOs better understand the food items</p>
                `;
            }
        }
        
        // Form validation
        document.getElementById('foodListingForm').addEventListener('submit', function(e) {
            const expiryDate = document.getElementById('expiryDate').value;
            const today = new Date();
            const selectedDate = new Date(expiryDate);
            
            if (selectedDate <= today) {
                e.preventDefault();
                alert('Please select a future expiry date.');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>