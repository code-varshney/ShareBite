// Welcome Popup functionality
function showWelcomePopup(userType, userName) {
    // Check if popup was already shown in this session
    if (sessionStorage.getItem('welcomePopupShown') === 'true') {
        return;
    }

    const popupHTML = `
        <div id="welcomePopup" class="welcome-popup-overlay">
            <div class="welcome-popup-content">
                <div class="welcome-popup-header">
                    <i class="fas fa-heart text-success"></i>
                    <h2>Welcome to ShareBite!</h2>
                    <button type="button" class="popup-close" onclick="closeWelcomePopup()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="welcome-popup-body">
                    <div class="welcome-message">
                        <h4>Hello, ${userName}!</h4>
                        <p class="mb-3">Thank you for joining our mission to reduce food waste and help those in need.</p>
                        ${userType === 'donor' ? 
                            '<p><strong>As a Donor:</strong> You can list surplus food, track donations, and make a real difference in your community.</p>' :
                            '<p><strong>As an NGO:</strong> You can request food donations, manage distributions, and help feed those who need it most.</p>'
                        }
                    </div>
                    <div class="welcome-features">
                        <h5>Quick Tips:</h5>
                        <ul class="feature-list">
                            ${userType === 'donor' ? `
                                <li><i class="fas fa-plus-circle"></i> Add food listings with detailed information</li>
                                <li><i class="fas fa-bell"></i> Get notified when NGOs request your food</li>
                                <li><i class="fas fa-chart-line"></i> Track your donation impact</li>
                            ` : `
                                <li><i class="fas fa-search"></i> Browse available food donations</li>
                                <li><i class="fas fa-hand-holding-heart"></i> Submit requests for needed items</li>
                                <li><i class="fas fa-users"></i> Manage your organization profile</li>
                            `}
                        </ul>
                    </div>
                </div>
                <div class="welcome-popup-footer">
                    <button type="button" class="btn btn-success btn-lg" onclick="closeWelcomePopup()">
                        Get Started <i class="fas fa-arrow-right ms-2"></i>
                    </button>
                </div>
            </div>
        </div>
    `;

    // Add popup to body
    document.body.insertAdjacentHTML('beforeend', popupHTML);
    
    // Show popup with animation
    setTimeout(() => {
        document.getElementById('welcomePopup').classList.add('show');
    }, 100);

    // Mark as shown in session
    sessionStorage.setItem('welcomePopupShown', 'true');
}

function closeWelcomePopup() {
    const popup = document.getElementById('welcomePopup');
    if (popup) {
        popup.classList.remove('show');
        setTimeout(() => {
            popup.remove();
        }, 300);
    }
}

// Auto-close popup after 10 seconds
setTimeout(() => {
    if (document.getElementById('welcomePopup')) {
        closeWelcomePopup();
    }
}, 10000);