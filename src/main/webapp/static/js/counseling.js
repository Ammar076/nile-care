// Counseling Module JavaScript
// Handles appointment booking, calendar, and counselor selection

// Counselor data (Fetched from backend)
let counselors = [];

// Available time slots (Dynamically populated based on counselor availability)
let availableTimeSlots = [];

// Global state for appointments (populated from API)
let appointments = [];

// State for selection
let selectedDate = null;
let selectedTime = null;
let selectedCounselor = null;
let counselorAvailability = []; // Store fetched availability slots

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    // Load counselors from API
    loadCounselors();
    
    // FETCH REAL DATA FROM BACKEND
    renderAppointments();

    // Initialize datepicker
    try {
        initializeDatepicker();
    } catch (error) {
        console.error('Datepicker initialization failed:', error);
        const dpContainer = document.getElementById('datepicker-container');
        if (dpContainer) {
            dpContainer.innerHTML =
                '<p class="text-muted text-center py-4">Calendar loading... Please refresh.</p>';
        }
    }

    // Initialize Modal Event Listeners
    initModalListeners();
});

function initModalListeners() {
    setTimeout(function () {
        const bookingModal = document.getElementById('bookingModal');
        const counselorSelectionModal = document.getElementById('counselorSelectionModal');
        const cancelConfirmModal = document.getElementById('cancelConfirmModal');
        const modalOverlay = document.getElementById('modalOverlay');

        const cancelBookingBtn = document.getElementById('cancelBookingBtn');
        const confirmBookingBtn = document.getElementById('confirmBookingBtn');
        const bookAppointmentBtn = document.getElementById('bookAppointmentBtn');
        const closeCounselorSelectionBtn = document.getElementById('closeCounselorSelectionBtn');
        const cancelConfirmCancelBtn = document.getElementById('cancelConfirmCancelBtn');
        const confirmCancelBtn = document.getElementById('confirmCancelBtn');

        // Book appointment button
        if (bookAppointmentBtn) {
            bookAppointmentBtn.addEventListener('click', function () {
                // If all selections are made, book the appointment
                if (selectedCounselor && selectedDate && selectedTime) {
                    confirmBooking();
                } else {
                    // Otherwise, show counselor selection modal
                    renderCounselorSelectionList();
                    if (counselorSelectionModal) counselorSelectionModal.classList.add('active');
                    if (modalOverlay) modalOverlay.classList.add('active');
                    document.body.style.overflow = 'hidden';
                }
            });
        }

        // Close counselor selection
        if (closeCounselorSelectionBtn) {
            closeCounselorSelectionBtn.addEventListener('click', function () {
                closeModal(counselorSelectionModal);
            });
        }

        // Cancel booking (Close modal)
        if (cancelBookingBtn) {
            cancelBookingBtn.addEventListener('click', function () {
                closeModal(bookingModal);
            });
        }

        // Confirm Booking (The key API Action)
        if (confirmBookingBtn) {
            confirmBookingBtn.addEventListener('click', confirmBooking);
        }

        // Close Cancel Confirmation
        if (cancelConfirmCancelBtn) {
            cancelConfirmCancelBtn.addEventListener('click', function () {
                closeModal(cancelConfirmModal);
            });
        }

        // Confirm Cancellation Action
        if (confirmCancelBtn) {
            confirmCancelBtn.addEventListener('click', confirmCancelAppointment);
        }

        // Overlay Click
        if (modalOverlay) {
            modalOverlay.addEventListener('click', function (e) {
                if (e.target === modalOverlay) {
                    closeAllModals();
                }
            });
        }
    }, 100);
}

// Helper to close specific modal
function closeModal(modal) {
    if (modal) modal.classList.remove('active');
    const modalOverlay = document.getElementById('modalOverlay');
    if (modalOverlay) modalOverlay.classList.remove('active');
    document.body.style.overflow = '';
}

function closeAllModals() {
    // Close all custom modals
    document.querySelectorAll('.modal-custom.active').forEach(m => m.classList.remove('active'));
    document.querySelectorAll('.modal.active').forEach(m => m.classList.remove('active'));
    
    // Remove modal overlay
    const modalOverlay = document.getElementById('modalOverlay');
    if (modalOverlay) modalOverlay.classList.remove('active');
    
    // Also remove any Bootstrap modal artifacts
    document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
    document.body.classList.remove('modal-open');
    document.body.style.overflow = '';
    document.body.style.paddingRight = '';
}

// Initialize Bootstrap Datepicker
function initializeDatepicker() {
    if (typeof $ === 'undefined') throw new Error('jQuery is not loaded');

    $('#datepicker-container').datepicker({
        inline: true,
        startDate: new Date(),
        todayHighlight: true,
        format: 'yyyy-mm-dd'
    }).on('changeDate', function (e) {
        selectedDate = e.format();
        selectedTime = null; // Reset time selection when date changes
        updateSelectedDateDisplay();
        renderTimeSlots();
        updateBookButtonState();
    });
}

function updateSelectedDateDisplay() {
    const displayElement = document.getElementById('selected-date-display');
    if (selectedDate) {
        const date = new Date(selectedDate);
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        displayElement.textContent = date.toLocaleDateString('en-US', options);
        displayElement.className = 'mb-3 fw-semibold';
        displayElement.style.color = '#2563eb';
    } else {
        displayElement.textContent = 'Please select a counselor first';
        displayElement.className = 'mb-3 text-muted small';
    }
}

// ==========================================
// LOAD COUNSELORS FROM API
// ==========================================
function loadCounselors() {
    const container = document.getElementById('counselors-container');
    if (container) {
        container.innerHTML = '<div class="col-12 text-center py-4"><i class="fas fa-spinner fa-spin text-primary"></i> Loading counselors...</div>';
    }

    fetch('/api/student/counselors')
        .then(response => {
            if (!response.ok) throw new Error('Failed to fetch counselors');
            return response.json();
        })
        .then(data => {
            counselors = data;
            renderCounselors();
        })
        .catch(error => {
            console.error('Error loading counselors:', error);
            if (container) {
                container.innerHTML = '<div class="col-12"><p class="text-center text-danger py-4">Error loading counselors. Please refresh.</p></div>';
            }
        });
}

function renderTimeSlots() {
    const container = document.getElementById('time-slots-container');
    if (!selectedCounselor) {
        container.innerHTML = '<p class="text-muted small text-center py-4">Please select a counselor first</p>';
        return;
    }
    if (!selectedDate) {
        container.innerHTML = '<p class="text-muted small text-center py-4">Please select a date</p>';
        return;
    }
    
    // Filter availability slots for the selected date
    const selectedDateObj = new Date(selectedDate);
    const slotsForDate = counselorAvailability.filter(slot => {
        const slotDate = new Date(slot.startTime);
        return slotDate.toDateString() === selectedDateObj.toDateString();
    });
    
    if (slotsForDate.length === 0) {
        container.innerHTML = '<p class="text-muted small text-center py-4">No available slots for this date</p>';
        return;
    }
    
    container.innerHTML = '';
    slotsForDate.forEach(function (slot) {
        const startTime = new Date(slot.startTime);
        const timeString = startTime.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit', hour12: true });
        
        const button = document.createElement('button');
        button.className = 'btn btn-outline-primary w-100 text-start mb-2';
        button.innerHTML = `<i class="far fa-clock me-2"></i>${timeString}`;
        button.dataset.slotId = slot.slotId;
        button.dataset.timeString = timeString;
        
        if (selectedTime && selectedTime.slotId === slot.slotId) {
            button.classList.remove('btn-outline-primary');
            button.classList.add('btn-primary');
        }
        button.onclick = function () {
            selectedTime = { slotId: slot.slotId, timeString: timeString };
            renderTimeSlots();
            updateBookButtonState();
        };
        container.appendChild(button);
    });
}

function renderCounselors() {
    const container = document.getElementById('counselors-container');
    if (!container) return;
    
    container.innerHTML = '';
    
    if (counselors.length === 0) {
        container.innerHTML = '<div class="col-12"><p class="text-center text-muted py-4">No counselors available</p></div>';
        return;
    }
    
    counselors.forEach(function (counselor) {
        const col = document.createElement('div');
        col.className = 'col-md-4';
        col.innerHTML = `
            <div class="card card-custom p-4 text-center h-100 hover-shadow" style="cursor: pointer;" onclick="selectCounselorFromDisplay(${counselor.id})">
                <div class="mb-3">
                    <img src="${counselor.avatarUrl}" class="rounded-circle shadow-sm" width="80" height="80" alt="${counselor.name}">
                </div>
                <h6 class="fw-bold mb-2" style="color: #1e3a8a;">${counselor.name}</h6>
                <p class="text-muted small mb-3">${counselor.title}</p>
                <div class="d-flex justify-content-center flex-wrap gap-1">
                    ${counselor.specialties.map(spec => `<span class="badge bg-light text-dark border small">${spec}</span>`).join('')}
                </div>
            </div>`;
        container.appendChild(col);
    });
}

// Update book button state based on selections
function updateBookButtonState() {
    const bookBtn = document.getElementById('bookAppointmentBtn');
    if (!bookBtn) return;
    
    if (selectedCounselor && selectedDate && selectedTime) {
        bookBtn.disabled = false;
        bookBtn.innerHTML = '<i class="fas fa-calendar-check"></i> Confirm Booking';
        bookBtn.style.background = 'linear-gradient(to right, #22c55e, #3b82f6)';
    } else if (selectedCounselor && selectedDate) {
        bookBtn.disabled = false;
        bookBtn.innerHTML = '<i class="fas fa-clock"></i> Select Time Slot';
        bookBtn.style.background = 'linear-gradient(to right, #3b82f6, #a855f7)';
    } else if (selectedCounselor) {
        bookBtn.disabled = false;
        bookBtn.innerHTML = '<i class="fas fa-calendar"></i> Select Date & Time';
        bookBtn.style.background = 'linear-gradient(to right, #3b82f6, #22c55e)';
    } else {
        bookBtn.disabled = true;
        bookBtn.innerHTML = '<i class="fas fa-user"></i> Select Counselor to Book';
        bookBtn.style.background = 'linear-gradient(to right, #94a3b8, #64748b)';
    }
}

function renderCounselorSelectionList() {
    const container = document.getElementById('counselor-selection-list');
    if (!container) return;
    
    container.innerHTML = '';
    counselors.forEach(function (counselor) {
        const col = document.createElement('div');
        col.className = 'col-md-6';
        const isSelected = selectedCounselor && selectedCounselor.id === counselor.id;

        col.innerHTML = `
            <div class="card p-3 cursor-pointer" 
                 onclick="selectCounselor(${counselor.id})"
                 style="cursor: pointer; border: ${isSelected ? '2px solid #3b82f6' : '1px solid #e2e8f0'}; border-radius: 8px;">
                <div class="d-flex align-items-center gap-3">
                    <img src="${counselor.avatarUrl}" class="rounded-circle" width="50" height="50" alt="${counselor.name}">
                    <div class="flex-grow-1">
                        <h6 class="fw-bold mb-1" style="color: #1e3a8a;">${counselor.name}</h6>
                        <p class="text-muted small mb-0">${counselor.title}</p>
                        <div class="d-flex flex-wrap gap-1 mt-2">
                            ${counselor.specialties.map(spec => `<span class="badge bg-light text-dark border" style="font-size: 10px;">${spec}</span>`).join('')}
                        </div>
                    </div>
                </div>
            </div>`;
        container.appendChild(col);
    });
}

// NEW: Select counselor from main display (counselor-first flow)
window.selectCounselorFromDisplay = function (id) {
    selectedCounselor = counselors.find(c => c.id === id);
    if (!selectedCounselor) return;
    
    // Reset selections
    selectedDate = null;
    selectedTime = null;
    
    // Show loading state
    showToast('Loading counselor availability...', 'info');
    
    // Fetch availability for this counselor
    fetch(`/api/student/counselors/${id}/availability`)
        .then(response => {
            if (!response.ok) throw new Error('Failed to fetch availability');
            return response.json();
        })
        .then(data => {
            counselorAvailability = data;
            
            if (data.length === 0) {
                showToast('No available slots for this counselor', 'warning');
                return;
            }
            
            // Show booking section
            const bookingSection = document.getElementById('booking-section');
            if (bookingSection) {
                bookingSection.style.display = 'block';
                
                // Update selected counselor display
                const counselorDisplay = document.getElementById('selected-counselor-display');
                if (counselorDisplay) {
                    counselorDisplay.innerHTML = `
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center gap-3">
                                <img src="${selectedCounselor.avatarUrl}" class="rounded-circle" width="50" height="50" alt="${selectedCounselor.name}">
                                <div>
                                    <h6 class="fw-bold mb-0" style="color: #1e3a8a;">${selectedCounselor.name}</h6>
                                    <p class="text-muted small mb-0">${selectedCounselor.title}</p>
                                </div>
                            </div>
                            <button class="btn btn-sm btn-outline-secondary" onclick="clearCounselorSelection()">
                                <i class="fas fa-times"></i> Change
                            </button>
                        </div>
                    `;
                }
                
                // Smooth scroll to booking section
                setTimeout(() => {
                    bookingSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }, 100);
            }
            
            updateSelectedDateDisplay();
            renderTimeSlots();
            updateBookButtonState();
            showToast(`Selected ${selectedCounselor.name}`, 'success');
        })
        .catch(error => {
            console.error('Error loading availability:', error);
            showToast('Error loading availability. Please try again.', 'danger');
        });
};

// Clear counselor selection and hide booking section
window.clearCounselorSelection = function() {
    selectedCounselor = null;
    selectedDate = null;
    selectedTime = null;
    counselorAvailability = [];
    
    const bookingSection = document.getElementById('booking-section');
    if (bookingSection) {
        bookingSection.style.display = 'none';
    }
    
    updateBookButtonState();
};

// Helper function called by onclick in renderCounselorSelectionList
window.selectCounselor = function (id) {
    selectedCounselor = counselors.find(c => c.id === id);
    if (!selectedCounselor) return;
    
    // Reset selections
    selectedDate = null;
    selectedTime = null;
    
    renderCounselorSelectionList();
    
    // Show loading
    showToast('Loading availability...', 'info');

    // Fetch availability for this counselor
    fetch(`/api/student/counselors/${id}/availability`)
        .then(response => {
            if (!response.ok) throw new Error('Failed to fetch availability');
            return response.json();
        })
        .then(data => {
            counselorAvailability = data;
            
            if (data.length === 0) {
                showToast('No available slots for this counselor', 'warning');
                closeModal(document.getElementById('counselorSelectionModal'));
                return;
            }
            
            setTimeout(function () {
                closeModal(document.getElementById('counselorSelectionModal'));
                
                // Show booking section
                const bookingSection = document.getElementById('booking-section');
                if (bookingSection) {
                    bookingSection.style.display = 'block';
                    setTimeout(() => {
                        bookingSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }, 200);
                }
                
                updateSelectedDateDisplay();
                renderTimeSlots();
                updateBookButtonState();
                showToast(`Selected ${selectedCounselor.name}`, 'success');
            }, 150);
        })
        .catch(error => {
            console.error('Error loading availability:', error);
            showToast('Error loading availability. Please try again.', 'danger');
            closeModal(document.getElementById('counselorSelectionModal'));
        });
};

function updateBookingSummary() {
    const container = document.getElementById('booking-summary');
    if (!container) return;
    
    let html = '';

    if (selectedCounselor) {
        html += `
            <div class="p-3 rounded-3 mb-3" style="background-color: #eff6ff; border: 1px solid #dbeafe;">
                <div class="d-flex align-items-center gap-3">
                    <img src="${selectedCounselor.avatarUrl}" class="rounded-circle" width="48" height="48">
                    <div>
                        <h6 class="fw-bold mb-0" style="color: #1e3a8a;">${selectedCounselor.name}</h6>
                        <p class="small text-muted mb-0">${selectedCounselor.title}</p>
                    </div>
                </div>
            </div>`;
    } else {
        html += `<div class="alert alert-warning mb-3"><i class="fas fa-exclamation-triangle me-2"></i>Please select a counselor</div>`;
    }

    if (selectedDate) {
        const date = new Date(selectedDate);
        html += `
            <div class="p-3 rounded-3 mb-3" style="background-color: #f0fdf4; border: 1px solid #bbf7d0;">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-calendar text-success"></i>
                    <span style="color: #166534;">${date.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' })}</span>
                </div>
            </div>`;
    } else {
        html += `<div class="alert alert-warning mb-3"><i class="fas fa-exclamation-triangle me-2"></i>Please select a date</div>`;
    }

    if (selectedTime) {
        html += `
            <div class="p-3 rounded-3 mb-3" style="background-color: #faf5ff; border: 1px solid #e9d5ff;">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-clock text-purple"></i>
                    <span style="color: #7c3aed;">${selectedTime.timeString || selectedTime}</span>
                </div>
            </div>`;
    } else {
        html += `<div class="alert alert-warning mb-3"><i class="fas fa-exclamation-triangle me-2"></i>Please select a time</div>`;
    }

    container.innerHTML = html;
}

// ==========================================
// 1. API INTEGRATION: CONFIRM BOOKING
// ==========================================
function confirmBooking() {
    // Validation
    if (!selectedCounselor) return showToast('Please select a counselor', 'warning');
    if (!selectedDate) return showToast('Please select a date', 'warning');
    if (!selectedTime) return showToast('Please select a time slot', 'warning');

    const bookBtn = document.getElementById('bookAppointmentBtn');
    if (!bookBtn) return;
    
    const originalText = bookBtn.innerHTML;
    bookBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Booking...';
    bookBtn.disabled = true;

    // Prepare Request Body
    const requestData = {
        counselorId: selectedCounselor.id,
        date: selectedDate, // "2025-12-15"
        time: selectedTime.timeString || selectedTime, // "10:00 AM"
        notes: '' // No notes field in direct booking
    };

    // Send POST Request
    fetch('/api/counseling/book', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(requestData)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast(data.message || 'Appointment booked!', 'success');

                // Refresh list
                renderAppointments();

                // Reset state and hide booking section
                selectedCounselor = null;
                selectedTime = null;
                selectedDate = null;
                counselorAvailability = [];
                
                const bookingSection = document.getElementById('booking-section');
                if (bookingSection) {
                    bookingSection.style.display = 'none';
                }
                
                updateBookButtonState();
                
                // Scroll to appointments
                setTimeout(() => {
                    document.getElementById('appointments-container')?.scrollIntoView({ behavior: 'smooth' });
                }, 500);
            } else {
                showToast(data.message || 'Booking failed', 'danger');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Server connection error', 'danger');
        })
        .finally(() => {
            bookBtn.innerHTML = originalText;
            bookBtn.disabled = false;
        });
}

// ==========================================
// 2. API INTEGRATION: FETCH APPOINTMENTS
// ==========================================
function renderAppointments() {
    const container = document.getElementById('appointments-container');
    container.innerHTML = '<div class="text-center py-4"><i class="fas fa-spinner fa-spin text-primary"></i> Loading...</div>';

    fetch('/api/counseling/my-appointments')
        .then(response => {
            if (!response.ok) throw new Error("Failed to fetch");
            return response.json();
        })
        .then(data => {
            // Update global variable so cancellation works
            window.appointments = data;

            if (!data || data.length === 0) {
                container.innerHTML = '<p class="text-center text-muted py-4">No appointments scheduled</p>';
                return;
            }

            container.innerHTML = '';
            data.forEach(function (appointment) {
                const appointmentDiv = document.createElement('div');
                appointmentDiv.className = 'p-3 rounded-3 border mb-3';
                appointmentDiv.style.backgroundColor = '#f8fafc';

                let statusClass, statusIcon, statusText;
                // Mapping backend status to UI styles
                if (appointment.status === 'upcoming') {
                    statusClass = 'bg-primary text-white';
                    statusIcon = 'fa-clock';
                    statusText = 'Upcoming';
                } else if (appointment.status === 'completed') {
                    statusClass = 'bg-success text-white';
                    statusIcon = 'fa-check-circle';
                    statusText = 'Completed';
                } else if (appointment.status === 'cancelled') {
                    statusClass = 'bg-danger text-white';
                    statusIcon = 'fa-times-circle';
                    statusText = 'Cancelled';
                } else if (appointment.status === 'cancel_requested') {
                    statusClass = 'bg-warning text-dark';
                    statusIcon = 'fa-hourglass-half';
                    statusText = 'Pending Cancel';
                } else {
                    statusClass = 'bg-secondary text-white';
                    statusIcon = 'fa-question';
                    statusText = 'Unknown';
                }

                // Initial formatting for avatar initials
                const initials = appointment.counselorName
                    ? appointment.counselorName.split(' ').map(n => n[0]).join('')
                    : 'DR';

                // Calculate if Join button should be active (10 mins before start to end time)
                let joinButtonHtml = '';
                if (appointment.status === 'upcoming') {
                    const now = new Date();
                    const startTime = new Date(appointment.startTime);
                    const endTime = new Date(appointment.endTime);
                    const tenMinsBefore = new Date(startTime.getTime() - 10 * 60 * 1000);
                    
                    const isWithinTimeWindow = now >= tenMinsBefore && now <= endTime;
                    const hasMeetingLink = appointment.meetingLink && appointment.meetingLink.trim() !== '';
                    
                    if (isWithinTimeWindow && hasMeetingLink) {
                        // Active Join button - clickable
                        joinButtonHtml = `
                            <button class="btn btn-sm btn-success" onclick="joinAppointment('${appointment.id}', '${appointment.meetingLink}')">
                                <i class="fas fa-video me-1"></i>Join Now
                            </button>`;
                    } else if (!hasMeetingLink) {
                        // Meeting link not set by counselor yet
                        joinButtonHtml = `
                            <button class="btn btn-sm btn-outline-secondary" disabled title="Meeting link will be available before your session">
                                <i class="fas fa-video me-1"></i>Link Pending
                            </button>`;
                    } else {
                        // Too early to join - show when it will be available
                        const availableAt = tenMinsBefore.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                        joinButtonHtml = `
                            <button class="btn btn-sm btn-outline-secondary" disabled title="Available at ${availableAt}">
                                <i class="fas fa-video me-1"></i>Join at ${availableAt}
                            </button>`;
                    }
                }

                appointmentDiv.innerHTML = `
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                        <div class="d-flex gap-3 align-items-center flex-grow-1">
                            <div class="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" 
                                 style="width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #22c55e);">
                                <span class="text-white fw-bold">${initials}</span>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex align-items-center gap-2 mb-1">
                                    <h6 class="fw-bold mb-0" style="color: #1e3a8a;">${appointment.counselorName}</h6>
                                    <span class="badge ${statusClass}">
                                        <i class="fas ${statusIcon} me-1"></i>${statusText}
                                    </span>
                                </div>
                                <div class="small text-muted d-flex flex-wrap gap-3">
                                    <span><i class="far fa-calendar me-1"></i>${appointment.date}</span>
                                    <span><i class="far fa-clock me-1"></i>${appointment.time}</span>
                                    <span><i class="fas fa-video me-1"></i>${appointment.type || 'Online'}</span>
                                </div>
                            </div>
                        </div>
                        ${appointment.status === 'upcoming' ? `
                            <div class="d-flex gap-2">
                                ${joinButtonHtml}
                                <button class="btn btn-sm btn-outline-danger" onclick="cancelAppointment('${appointment.id}')">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        ` : ''}
                        ${appointment.status === 'cancel_requested' ? `
                            <div class="d-flex gap-2">
                                <span class="text-muted small"><i class="fas fa-info-circle me-1"></i>Awaiting counselor approval</span>
                            </div>
                        ` : ''}
                    </div>
                `;
                container.appendChild(appointmentDiv);
            });
        })
        .catch(err => {
            console.error(err);
            container.innerHTML = '<p class="text-center text-danger py-4">Error loading appointments</p>';
        });
}

function joinAppointment(id, meetingLink) {
    if (!meetingLink || meetingLink.trim() === '' || meetingLink === 'null' || meetingLink === 'undefined') {
        showToast('Meeting link is not available yet. Please wait for your counselor to add it.', 'warning');
        return;
    }
    
    // Open the meeting link in a new tab
    showToast('Opening video call...', 'info');
    window.open(meetingLink, '_blank');
}

function cancelAppointment(appointmentId) {
    window.appointmentToCancel = appointmentId;
    const modal = document.getElementById('cancelConfirmModal');
    if (modal) {
        modal.classList.add('active');
        document.getElementById('modalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

// NOTE: Since you didn't provide a Cancel Endpoint in the backend, 
// this currently only simulates cancellation on the frontend.
function confirmCancelAppointment() {
    const appointmentId = window.appointmentToCancel;
    if (!appointmentId) return;

    const confirmBtn = document.getElementById('confirmCancelBtn');
    if (confirmBtn) {
        confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';
        confirmBtn.disabled = true;
    }

    // Force close modal immediately before API call (prevents modal sticking)
    const forceCloseModal = () => {
        const modal = document.getElementById('cancelConfirmModal');
        if (modal) modal.classList.remove('active');
        const overlay = document.getElementById('modalOverlay');
        if (overlay) overlay.classList.remove('active');
        document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
        document.body.classList.remove('modal-open');
        document.body.style.overflow = '';
        document.body.style.paddingRight = '';
    };

    // Call the backend API
    fetch(`/api/counseling/appointments/${appointmentId}/cancel`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => response.json())
        .then(data => {
            // Close modal immediately on response
            forceCloseModal();
            
            if (data.success) {
                showToast(data.message || 'Cancellation request sent', 'success');
                // Refresh the appointments list
                renderAppointments();
            } else {
                showToast(data.message || 'Cancellation failed', 'danger');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // Close modal even on error
            forceCloseModal();
            showToast('Server connection error', 'danger');
        })
        .finally(() => {
            // Additional cleanup
            closeAllModals();
            window.appointmentToCancel = null;
            
            // Reset button state
            const btn = document.getElementById('confirmCancelBtn');
            if (btn) {
                btn.innerHTML = 'Yes, Cancel It';
                btn.disabled = false;
            }
        });
}

// Universal Toast Handler
function showToast(message, type) {
    // Check if global ToastNotifications object exists (from other modules)
    if (typeof ToastNotifications !== 'undefined') {
        if (type === 'success') ToastNotifications.showSuccessToast(message);
        else if (type === 'error' || type === 'danger') ToastNotifications.showErrorAlert(message, 'danger');
        else ToastNotifications.showToast(message, type || 'info');
        return;
    }

    // Fallback implementation
    const container = document.getElementById('toast-container') || createToastContainer();
    const toast = document.createElement('div');

    let alertClass = 'alert-info', icon = 'fa-info-circle';
    if (type === 'success') { alertClass = 'alert-success'; icon = 'fa-check-circle'; }
    if (type === 'danger' || type === 'error') { alertClass = 'alert-danger'; icon = 'fa-exclamation-circle'; }
    if (type === 'warning') { alertClass = 'alert-warning'; icon = 'fa-exclamation-triangle'; }

    toast.className = `alert ${alertClass} position-fixed top-0 end-0 m-3 shadow`;
    toast.style.zIndex = '10003';
    toast.style.minWidth = '300px';
    toast.innerHTML = `
        <div class="d-flex align-items-center justify-content-between">
            <div><i class="fas ${icon} me-2"></i>${message}</div>
            <button type="button" class="btn-close ms-2" onclick="this.parentNode.parentNode.remove()"></button>
        </div>`;

    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

function createToastContainer() {
    const div = document.createElement('div');
    div.id = 'toast-container';
    document.body.appendChild(div);
    return div;
}