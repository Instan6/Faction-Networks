window.addEventListener('message', e => {
    if (e.data.action === 'open') {
        document.getElementById('app').classList.remove('hidden')
        switchTab('home')
        updateDateTime()
        // Set player name if provided by the caller
        const nameEl = document.getElementById('player-name')
        if (nameEl) {
            const playerName = e.data.playerName || e.data.name || e.data.player || null
            if (playerName) nameEl.textContent = playerName
        }
        // populate sidebar/profile fields when opening
        const driverEl = document.getElementById('driver-name')
        if (driverEl) {
            const dn = e.data.playerName || e.data.name || e.data.driverName || e.data.player || null
            if (dn) driverEl.textContent = dn
        }
        const dobEl = document.getElementById('player-dob')
        if (dobEl && e.data.dob) dobEl.textContent = `DOB: ${e.data.dob}`
        const licText = document.getElementById('license-status-text')
        if (licText && e.data.licenseStatus) licText.textContent = e.data.licenseStatus
        const licProg = document.getElementById('license-progress')
        if (licProg && typeof e.data.licensePercent !== 'undefined') licProg.style.width = `${e.data.licensePercent}%`
    }
})

// Theme toggle: persist selection and update root attribute
;(function(){
    const root = document.documentElement
    const toggle = document.getElementById('theme-toggle')
    const icon = document.getElementById('theme-icon')
    const apply = (mode) => {
        if (mode === 'light') root.setAttribute('data-theme', 'light')
        else root.removeAttribute('data-theme')
        localStorage.setItem('mr_theme', mode)
        // update icon: sun for light, moon for dark
        if (icon) {
            if (mode === 'light') {
                icon.innerHTML = '<path d="M12 3v2"/><path d="M12 19v2"/><path d="M4.2 4.2l1.4 1.4"/><path d="M18.4 18.4l1.4 1.4"/><path d="M1 12h2"/><path d="M21 12h2"/><path d="M4.2 19.8l1.4-1.4"/><path d="M18.4 5.6l1.4-1.4"/><circle cx="12" cy="12" r="4"/>'
            } else {
                icon.innerHTML = '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />'
            }
        }
    }

    // initialize from storage
    const stored = localStorage.getItem('mr_theme') || 'dark'
    apply(stored)

    if (toggle) toggle.addEventListener('click', () => {
        const next = (document.documentElement.getAttribute('data-theme') === 'light') ? 'dark' : 'light'
        apply(next)
    })
})()

// Update date and time display
function updateDateTime() {
    const now = new Date()
    const timeOptions = { 
        timeZone: 'Australia/Melbourne', 
        hour: '2-digit', 
        minute: '2-digit',
        hour12: true
    }
    const dateOptions = { 
        timeZone: 'Australia/Melbourne', 
        day: 'numeric', 
        month: 'short', 
        year: 'numeric' 
    }
    
    const timeEl = document.getElementById('current-time')
    const dateEl = document.getElementById('current-date')
    
    if (timeEl) timeEl.textContent = now.toLocaleTimeString('en-AU', timeOptions)
    if (dateEl) dateEl.textContent = now.toLocaleDateString('en-AU', dateOptions)
}

// Update time every minute
setInterval(updateDateTime, 60000)

// Generic data update handler. Send messages with action: 'update' and key/value pairs.
window.addEventListener('message', e => {
    if (e.data.action === 'update' && typeof e.data === 'object') {
        const data = e.data
        const set = (id, value) => {
            const el = document.getElementById(id)
            if (!el || value === undefined || value === null) return
            el.textContent = value
        }

        // Common fields
        if (data.playerName) set('player-name', data.playerName)
        if (data.dob) set('player-dob', data.dob)
        if (data.licenseStatus) set('license-status', data.licenseStatus)
        if (data.licenseExpiry) set('license-expiry', data.licenseExpiry)
        if (data.vehiclePlate) set('vehicle-plate', data.vehiclePlate)
        // allow arbitrary id:value updates
        if (data.fields && typeof data.fields === 'object') {
            Object.keys(data.fields).forEach(k => set(k, data.fields[k]))
        }
    } else if (e.data.action === 'updateVehicles') {
        const vehicles = e.data.vehicles || []
        const vehicleList = document.getElementById('vehicle-list')
        if (!vehicleList) return

        // Clear existing content
        vehicleList.innerHTML = ''

        if (vehicles.length === 0) {
            vehicleList.innerHTML = '<div class="muted">No vehicles found. Go to a dealership to purchase one.</div>'
            return
        }

        vehicles.forEach(veh => {
            const vehDiv = document.createElement('div')
            vehDiv.className = 'vehicle-card'
            const isRegistered = veh.status && veh.status.toUpperCase() === 'REGISTERED'
            const isImpounded = veh.impounded === true
            
            // Format expiry date if registered
            let expiryText = ''
            if (isRegistered && veh.expiry) {
                // Parse the date and format it for Australia/Melbourne timezone
                const expiryDate = new Date(veh.expiry)
                const day = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
                const month = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
                const year = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
                expiryText = `<p class="muted">Expiry Date: ${day}/${month}/${year}</p>`
            }
            
            // Vehicle icon SVG
            const vehicleIcon = `<svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M5 17h14v2a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1v-2z"/>
                <path d="M5 17l2-6h10l2 6"/>
                <path d="M7 11l1-3h8l1 3"/>
                <circle cx="8" cy="17" r="2"/>
                <circle cx="16" cy="17" r="2"/>
            </svg>`
            
            vehDiv.innerHTML = `
                <div class="vehicle-icon">${vehicleIcon}</div>
                <div class="vehicle-content">
                    <div class="vehicle-header">
                        <h3>${veh.model}</h3>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            ${isRegistered ? `<button class="btn-icon" data-action="info" data-vehicle='${JSON.stringify(veh).replace(/'/g, "&apos;")}'>
                                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                    <line x1="12" y1="16" x2="12" y2="12"/>
                                    <line x1="12" y1="8" x2="12.01" y2="8"/>
                                </svg>
                            </button>` : ''}
                            ${isImpounded ? '<span class="pill orange">IMPOUNDED</span>' : ''}
                            <span class="pill ${isRegistered ? 'green' : 'red'}">${veh.status}</span>
                        </div>
                    </div>
                    <p class="vehicle-plate"><small class="muted">Plate: ${veh.plate}</small></p>
                    ${expiryText ? `<p class="vehicle-expiry">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        Expiry Date: ${expiryText.match(/\d+\/\d+\/\d+/)[0]}
                    </p>` : ''}
                    ${!isRegistered ? `<button class="btn green vehicle-register-btn" data-action="register" data-plate="${veh.plate}" data-vehicle='${JSON.stringify(veh).replace(/'/g, "&apos;")}'>
                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 5v14M5 12h14"/>
                        </svg>
                        Register Vehicle - $300
                    </button>` : `<button class="btn green vehicle-register-btn" data-action="edit" data-plate="${veh.plate}" data-vehicle='${JSON.stringify(veh).replace(/'/g, "&apos;")}'>
                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                        Edit Color - $1000
                    </button>`}
                </div>
            `
            vehicleList.appendChild(vehDiv)
        })

        // Add event listeners to buttons
        vehicleList.querySelectorAll('button[data-action]').forEach(btn => {
            btn.addEventListener('click', function() {
                const action = this.dataset.action
                const plate = this.dataset.plate
                
                if (action === 'info') {
                    const vehicleData = JSON.parse(this.dataset.vehicle)
                    showVehicleInfo(vehicleData)
                } else if (action === 'register' && plate) {
                    const vehicleData = JSON.parse(this.dataset.vehicle)
                    showRegistrationForm(vehicleData)
                } else if (action === 'edit' && plate) {
                    const vehicleData = JSON.parse(this.dataset.vehicle)
                    showEditRegistrationForm(vehicleData)
                } else if (action === 'renew' && plate) {
                    showPaymentModal('renew', plate, () => {
                        closeUI()
                    })
                }
            })
        })
        
        // Update home page vehicle list with first registered vehicle
        const homeVehicleList = document.getElementById('home-vehicle-list')
        if (homeVehicleList) {
            const firstRegistered = vehicles.find(v => v.status && v.status.toUpperCase() === 'REGISTERED')
            if (firstRegistered) {
                let expiryInfo = ''
                if (firstRegistered.expiry) {
                    const expiryDate = new Date(firstRegistered.expiry)
                    const day = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
                    const month = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
                    const year = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
                    expiryInfo = `<small class="muted">Expiry Date: ${day}/${month}/${year}</small>`
                }
                homeVehicleList.innerHTML = `
                    <div class="row">
                        <span>${firstRegistered.model} - <small class="muted">${firstRegistered.plate}</small> ${expiryInfo}</span>
                        <span class="pill green">${firstRegistered.status}</span>
                    </div>
                `
            } else if (vehicles.length > 0) {
                // Show first vehicle even if unregistered
                const firstVehicle = vehicles[0]
                homeVehicleList.innerHTML = `
                    <div class="row">
                        <span>${firstVehicle.model} - <small class="muted">${firstVehicle.plate}</small></span>
                        <span class="pill red">${firstVehicle.status}</span>
                    </div>
                `
            } else {
                homeVehicleList.innerHTML = '<div class="muted">No vehicles found.</div>'
            }
        }
    }
})

function closeUI() {
    const app = document.getElementById('app')
    if (app) app.classList.add('hidden')
    try { document.activeElement && document.activeElement.blur() } catch (e) {}
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' })
}

// allow closing via message or Escape key
window.addEventListener('message', e => {
    if (e.data && e.data.action === 'close') closeUI()
})

document.addEventListener('keydown', (ev) => {
    if (ev.key === 'Escape' || ev.key === 'Esc') closeUI()
})

// View License Card button in sidebar
const viewLicenseBtn = document.getElementById('view-license')
if (viewLicenseBtn) {
    viewLicenseBtn.addEventListener('click', () => {
        switchTab('licenses')
    })
}

document.querySelectorAll('.nav button').forEach(btn => {
    btn.onclick = () => switchTab(btn.dataset.tab)
})

function switchTab(tab) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'))
    document.querySelectorAll('.nav button').forEach(b => b.classList.remove('active'))

    document.getElementById(tab).classList.add('active')
    document.querySelector(`[data-tab="${tab}"]`).classList.add('active')
    
    // Load locations when switching to locations tab
    if (tab === 'locations') {
        loadLocations()
    }
}

// Load and display locations
function loadLocations() {
    fetch(`https://${GetParentResourceName()}/getLocations`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    })
    .then(resp => resp.json())
    .then(data => {
        displayLocations(data.locations, data.playerPos)
    })
    .catch(err => {
        console.error('Error loading locations:', err)
        document.getElementById('locations-list').innerHTML = '<div class="muted">Unable to load locations</div>'
    })
}

function displayLocations(locations, playerPos) {
    const container = document.getElementById('locations-list')
    if (!locations || locations.length === 0) {
        container.innerHTML = '<div class="muted">No locations available</div>'
        return
    }

    // Calculate distance for each location
    locations.forEach(loc => {
        const dx = loc.x - playerPos.x
        const dy = loc.y - playerPos.y
        loc.distance = Math.sqrt(dx * dx + dy * dy)
    })

    // Sort by distance
    locations.sort((a, b) => a.distance - b.distance)

    // Display locations
    container.innerHTML = locations.map(loc => `
        <div class="location-item">
            <div class="location-header">
                <div class="location-name">${loc.label || 'VicRoads Office'}</div>
                <div class="location-badge ${loc.isOpen ? 'open' : 'closed'}">${loc.isOpen ? 'OPEN' : 'CLOSED'}</div>
            </div>
            <div class="location-address">${loc.description || 'VicRoads Office Location'}</div>
            ${loc.openHours ? `<div class="location-hours">Hours: ${loc.openHours} AEDT</div>` : ''}
            <button class="location-waypoint-btn" onclick="setLocationWaypoint(${loc.x}, ${loc.y})">Set Waypoint</button>
        </div>
    `).join('')
}

function setLocationWaypoint(x, y) {
    fetch(`https://${GetParentResourceName()}/setWaypoint`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ x, y })
    })
}

// Map functionality
let mapCanvas = null
let mapContext = null
let mapImage = null
let mapImageLoaded = false
let mapData = {
    offsetX: 0,
    offsetY: 0,
    scale: 1,
    isDragging: false,
    lastX: 0,
    lastY: 0,
    locations: [],
    playerPos: null
}

// GTA V map boundaries (game coordinates)
const MAP_BOUNDS = {
    minX: -4000,
    maxX: 4000,
    minY: -4000,
    maxY: 8000
}

function initializeMap() {
    if (!mapCanvas) {
        mapCanvas = document.getElementById('map-canvas')
        if (!mapCanvas) return
        
        mapContext = mapCanvas.getContext('2d')
        
        // Load local map image
        mapImage = new Image()
        mapImage.onload = () => {
            console.log('Map image loaded successfully:', mapImage.width, 'x', mapImage.height, 'Size:', mapImage.src.length, 'bytes')
            mapImageLoaded = true
            drawMap()
        }
        mapImage.onerror = (err) => {
            console.error('Failed to load map image. Error:', err)
            console.error('Image src was:', mapImage.src)
            console.error('This could be due to: file not found, too large, or wrong format')
            mapImageLoaded = false
            drawMap()
        }
        
        // Try loading from NUI resource first
        fetch(`https://${GetParentResourceName()}/getMapTexture`, {
            method: 'POST',
            body: JSON.stringify({})
        }).then(resp => resp.json())
          .then(data => {
              if (data && data.texture) {
                  console.log('Loading map from:', data.texture)
                  // Just use the filename - NUI will resolve it relative to the HTML file
                  mapImage.src = data.texture
              } else {
                  console.log('No texture path returned, using fallback')
                  drawMap()
              }
          }).catch(err => {
              console.error('Failed to get map texture:', err)
              drawMap()
          })
        
        // Set up event listeners for dragging
        const container = mapCanvas.parentElement
        
        let startX = 0
        let startY = 0
        
        container.addEventListener('mousedown', (e) => {
            mapData.isDragging = true
            startX = e.clientX - mapData.offsetX
            startY = e.clientY - mapData.offsetY
            container.classList.add('dragging')
        })
        
        container.addEventListener('mousemove', (e) => {
            if (!mapData.isDragging) return
            
            mapData.offsetX = e.clientX - startX
            mapData.offsetY = e.clientY - startY
            
            updateMapPosition()
        })
        
        container.addEventListener('mouseup', () => {
            mapData.isDragging = false
            container.classList.remove('dragging')
        })
        
        container.addEventListener('mouseleave', () => {
            if (mapData.isDragging) {
                mapData.isDragging = false
                container.classList.remove('dragging')
            }
        })
        
        // Mouse wheel zoom
        container.addEventListener('wheel', (e) => {
            e.preventDefault()
            const delta = e.deltaY > 0 ? 0.9 : 1.1
            const oldScale = mapData.scale
            mapData.scale = Math.max(0.5, Math.min(3, mapData.scale * delta))
            
            // Adjust offset to zoom towards mouse position
            const rect = mapCanvas.getBoundingClientRect()
            const mouseX = e.clientX - rect.left
            const mouseY = e.clientY - rect.top
            
            mapData.offsetX = mouseX - (mouseX - mapData.offsetX) * (mapData.scale / oldScale)
            mapData.offsetY = mouseY - (mouseY - mapData.offsetY) * (mapData.scale / oldScale)
            
            updateMapPosition()
        })
    }
    
    // Request locations from server
    fetch(`https://${GetParentResourceName()}/getLocations`, {
        method: 'POST',
        body: JSON.stringify({})
    }).then(resp => resp.json())
      .then(data => {
          if (data && data.locations) {
              mapData.locations = data.locations
              if (data.playerPos) {
                  mapData.playerPos = data.playerPos
              }
              drawMap()
          }
      }).catch(() => {
          // Locations will be sent via message event
      })
}

function updateMapPosition() {
    if (!mapCanvas) return
    mapCanvas.style.transform = `translate(${mapData.offsetX}px, ${mapData.offsetY}px) scale(${mapData.scale})`
    drawMap()
}

function gameToCanvas(x, y) {
    const width = mapCanvas.width
    const height = mapCanvas.height
    
    // Convert game coordinates to normalized coordinates (0-1)
    const normX = (x - MAP_BOUNDS.minX) / (MAP_BOUNDS.maxX - MAP_BOUNDS.minX)
    const normY = (MAP_BOUNDS.maxY - y) / (MAP_BOUNDS.maxY - MAP_BOUNDS.minY)
    
    return {
        x: normX * width,
        y: normY * height
    }
}

function drawMap() {
    if (!mapContext) return
    
    const width = mapCanvas.width
    const height = mapCanvas.height
    
    // Clear canvas
    mapContext.clearRect(0, 0, width, height)
    
    // Draw the GTA V map image if loaded
    if (mapImageLoaded && mapImage && mapImage.complete && mapImage.naturalWidth > 0) {
        try {
            mapContext.drawImage(mapImage, 0, 0, width, height)
        } catch (e) {
            console.error('Error drawing map image:', e)
            // Fall through to fallback rendering
            mapImageLoaded = false
        }
    }
    
    if (!mapImageLoaded || !mapImage || !mapImage.complete || mapImage.naturalWidth === 0) {
        // Draw styled map background
        const gradient = mapContext.createRadialGradient(width/2, height/2, 0, width/2, height/2, width/2)
        gradient.addColorStop(0, '#1e293b')
        gradient.addColorStop(1, '#0f172a')
        mapContext.fillStyle = gradient
        mapContext.fillRect(0, 0, width, height)
        
        // Draw subtle grid
        mapContext.strokeStyle = 'rgba(74, 222, 128, 0.08)'
        mapContext.lineWidth = 1
        
        const gridSize = 60
        for (let x = 0; x < width; x += gridSize) {
            mapContext.beginPath()
            mapContext.moveTo(x, 0)
            mapContext.lineTo(x, height)
            mapContext.stroke()
        }
        for (let y = 0; y < height; y += gridSize) {
            mapContext.beginPath()
            mapContext.moveTo(0, y)
            mapContext.lineTo(width, y)
            mapContext.stroke()
        }
        
        // Draw map boundary circle
        mapContext.strokeStyle = 'rgba(74, 222, 128, 0.2)'
        mapContext.lineWidth = 3
        mapContext.beginPath()
        mapContext.arc(width / 2, height / 2, Math.min(width, height) * 0.4, 0, Math.PI * 2)
        mapContext.stroke()
        
        // Draw compass directions
        mapContext.fillStyle = 'rgba(148, 163, 184, 0.6)'
        mapContext.font = 'bold 14px Inter, sans-serif'
        mapContext.textAlign = 'center'
        mapContext.fillText('N', width / 2, 30)
        mapContext.fillText('S', width / 2, height - 20)
        mapContext.textAlign = 'left'
        mapContext.fillText('E', width - 30, height / 2)
        mapContext.textAlign = 'right'
        mapContext.fillText('W', 30, height / 2)
        
        // Draw title
        mapContext.fillStyle = 'rgba(148, 163, 184, 0.4)'
        mapContext.font = 'bold 18px Inter, sans-serif'
        mapContext.textAlign = 'center'
        mapContext.fillText('Los Santos', width / 2, height / 2)
        mapContext.font = '12px Inter, sans-serif'
        mapContext.fillText('VicRoads Locations', width / 2, height / 2 + 20)
    }
    
    // Draw locations
    mapData.locations.forEach(loc => {
        const pos = gameToCanvas(loc.x, loc.y)
        
        // Draw location marker shadow
        mapContext.fillStyle = 'rgba(0, 0, 0, 0.3)'
        mapContext.beginPath()
        mapContext.arc(pos.x + 1, pos.y + 1, 10, 0, Math.PI * 2)
        mapContext.fill()
        
        // Draw location marker
        mapContext.fillStyle = '#4ade80'
        mapContext.beginPath()
        mapContext.arc(pos.x, pos.y, 10, 0, Math.PI * 2)
        mapContext.fill()
        
        // Draw marker border
        mapContext.strokeStyle = '#ffffff'
        mapContext.lineWidth = 2
        mapContext.beginPath()
        mapContext.arc(pos.x, pos.y, 10, 0, Math.PI * 2)
        mapContext.stroke()
        
        // Draw location label with background
        mapContext.font = 'bold 12px Inter, sans-serif'
        mapContext.textAlign = 'center'
        const textWidth = mapContext.measureText(loc.label).width
        
        // Background
        mapContext.fillStyle = 'rgba(0, 0, 0, 0.7)'
        mapContext.fillRect(pos.x - textWidth / 2 - 6, pos.y - 30, textWidth + 12, 18)
        
        // Text
        mapContext.fillStyle = '#ffffff'
        mapContext.fillText(loc.label, pos.x, pos.y - 17)
    })
    
    // Draw player position if available
    if (mapData.playerPos) {
        const pos = gameToCanvas(mapData.playerPos.x, mapData.playerPos.y)
        
        // Draw player marker (blue dot with pulse effect)
        mapContext.fillStyle = 'rgba(59, 130, 246, 0.3)'
        mapContext.beginPath()
        mapContext.arc(pos.x, pos.y, 12, 0, Math.PI * 2)
        mapContext.fill()
        
        mapContext.fillStyle = '#3b82f6'
        mapContext.beginPath()
        mapContext.arc(pos.x, pos.y, 8, 0, Math.PI * 2)
        mapContext.fill()
        
        mapContext.strokeStyle = '#ffffff'
        mapContext.lineWidth = 2
        mapContext.beginPath()
        mapContext.arc(pos.x, pos.y, 8, 0, Math.PI * 2)
        mapContext.stroke()
    }
}

// Handle locations data from server
window.addEventListener('message', e => {
    if (e.data.action === 'updateLocations') {
        const locations = e.data.locations || []
        const locationList = document.getElementById('location-list')
        if (!locationList) return
        
        locationList.innerHTML = ''
        
        if (locations.length === 0) {
            locationList.innerHTML = '<div class="muted">No locations available.</div>'
            return
        }
        
        mapData.locations = locations
        
        // Update player position if provided
        if (e.data.playerPos) {
            mapData.playerPos = e.data.playerPos
        }
        
        locations.forEach(loc => {
            const locDiv = document.createElement('div')
            locDiv.className = 'location'
            locDiv.innerHTML = `
                <div>
                    <strong>${loc.label}</strong>
                    <p>${loc.description || 'Office location'}</p>
                </div>
                <button class="btn green small" onclick="setWaypoint(${loc.x}, ${loc.y}, ${loc.z})">Set Waypoint</button>
            `
            locationList.appendChild(locDiv)
        })
        
        // Redraw map with new locations
        if (mapCanvas) {
            drawMap()
        }
    } else if (e.data.action === 'updatePlayerPos') {
        mapData.playerPos = e.data.pos
        if (mapCanvas) {
            drawMap()
        }
    }
})

function setWaypoint(x, y, z) {
    fetch(`https://${GetParentResourceName()}/setWaypoint`, {
        method: 'POST',
        body: JSON.stringify({ x, y, z })
    })
    closeUI()
}

// Vehicle search functionality
let allVehicles = []

document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('vehicle-search')
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase()
            filterVehicles(searchTerm)
        })
    }
    
    // Initialize test button listeners
    initTestButtons()
})

function filterVehicles(searchTerm) {
    const vehicleCards = document.querySelectorAll('.vehicle-card')
    vehicleCards.forEach(card => {
        const plateText = card.querySelector('h4').textContent.toLowerCase()
        if (plateText.includes(searchTerm)) {
            card.style.display = ''
        } else {
            card.style.display = 'none'
        }
    })
}

// Test functionality
let currentTest = null
let currentQuestions = []
let userAnswers = []
let testProgressData = {}
let currentLicenses = []
let phonePhotos = []

// Update test card statuses based on progress and existing licenses
function updateTestCardStatuses() {
    ['driver', 'bike', 'truck'].forEach(licenseType => {
        const progress = testProgressData[licenseType]
        const theoryBtn = document.querySelector(`.test-theory-btn[data-license="${licenseType}"]`)
        const practicalBtn = document.querySelector(`.test-practical-btn[data-license="${licenseType}"]`)
        
        if (!theoryBtn || !practicalBtn) return
        
        // Check if player already has this license (active or suspended)
        const hasLicense = currentLicenses.some(lic => lic.type === licenseType)
        
        if (hasLicense) {
            // Already has license - hide practical button and show single "License Obtained" button
            const buttonContainer = theoryBtn.parentElement
            buttonContainer.style.gridTemplateColumns = '1fr'
            
            theoryBtn.innerHTML = `
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"/>
                </svg>
                License Obtained
            `
            theoryBtn.style.opacity = '0.7'
            theoryBtn.style.pointerEvents = 'none'
            
            practicalBtn.style.display = 'none'
        } else {
            // Reset to 2-column layout if license not obtained
            const buttonContainer = theoryBtn.parentElement
            buttonContainer.style.gridTemplateColumns = '1fr 1fr'
            practicalBtn.style.display = ''
            
            if (progress && progress.theoryPassed) {
                // Theory passed - show checkmark
                theoryBtn.innerHTML = `
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                    Theory Complete
                `
                theoryBtn.style.opacity = '0.7'
                theoryBtn.style.pointerEvents = 'none'
            } else {
                // Reset theory button to default
                theoryBtn.innerHTML = 'Theory Test'
                theoryBtn.style.opacity = '1'
                theoryBtn.style.pointerEvents = 'auto'
            }
            
            if (progress && progress.practicalPassed) {
                // Practical passed - show checkmark  
                practicalBtn.innerHTML = `
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                    Practical Complete
                `
                practicalBtn.style.opacity = '0.7'
                practicalBtn.style.pointerEvents = 'none'
            } else {
                // Reset practical button to default
                practicalBtn.innerHTML = 'Practical Test'
                practicalBtn.style.opacity = '1'
                practicalBtn.style.pointerEvents = 'auto'
            }
        }
    })
}

// Initialize test button event listeners
function initTestButtons() {
    // Handle theory test button clicks
    document.querySelectorAll('.test-theory-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const license = this.dataset.license
            currentTest = license
            userAnswers = []
            
            // Request questions from server
            fetch(`https://${GetParentResourceName()}/getQuestions`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ license: license })
            })
        })
    })

    // Handle practical test button clicks
    document.querySelectorAll('.test-practical-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const license = this.dataset.license
            
            // Close UI and start practical test
            closeUI()
            
            fetch(`https://${GetParentResourceName()}/startPracticalTest`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ license: license })
            })
        })
    })
}

// Receive questions from server
window.addEventListener('message', e => {
    if (e.data.action === 'receiveQuestions') {
        currentQuestions = e.data.questions
        displayTest(e.data.license, e.data.questions)
    } else if (e.data.action === 'updateLicenses') {
        displayLicenses(e.data.licenses, e.data.testProgress)
    } else if (e.data.action === 'updatePhonePhotos') {
        phonePhotos = e.data.photos || []
    } else if (e.data.action === 'testResult') {
        handleTestResult(e.data.result)
    }
})

function displayTest(license, questions) {
    const testArea = document.getElementById('test-area')
    if (!testArea) return
    
    let html = `<div class="card wide">
        <h3>${license.charAt(0).toUpperCase() + license.slice(1)} License Theory Test</h3>
        <div class="test-scroll-container">`
    
    questions.forEach((q, qIndex) => {
        html += `
            <div class="test-question">
                <h4>${qIndex + 1}. ${q.question}</h4>
                <div class="test-answers">
        `
        
        q.answers.forEach((answer, aIndex) => {
            html += `
                <label class="test-answer">
                    <input type="radio" name="q${qIndex}" value="${aIndex}" />
                    <span>${answer}</span>
                </label>
            `
        })
        
        html += `
                </div>
            </div>
        `
    })
    
    html += `
        </div>
        <div class="test-submit">
            <button class="btn green" id="submit-test">Submit Test</button>
            <button class="btn" id="cancel-test">Cancel</button>
        </div>
    </div>`
    
    testArea.innerHTML = html
    
    // Add event listener for submit
    document.getElementById('submit-test').addEventListener('click', submitTest)
    document.getElementById('cancel-test').addEventListener('click', () => {
        testArea.innerHTML = ''
        currentTest = null
        currentQuestions = []
        userAnswers = []
    })
}

function submitTest() {
    const answers = []
    
    for (let i = 0; i < currentQuestions.length; i++) {
        const selected = document.querySelector(`input[name="q${i}"]:checked`)
        if (selected) {
            answers.push(parseInt(selected.value))
        } else {
            answers.push(-1) // No answer selected
        }
    }
    
    // Check if all questions are answered
    if (answers.includes(-1)) {
        alert('Please answer all questions before submitting.')
        return
    }
    
    // Submit to server
    fetch(`https://${GetParentResourceName()}/submitTest`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            license: currentTest, 
            answers: answers 
        })
    })
    
    // Clear test area
    document.getElementById('test-area').innerHTML = ''
    currentTest = null
    currentQuestions = []
    userAnswers = []
}

function displayLicenses(licenses, testProgress = {}) {
    const licenseList = document.getElementById('license-list')
    if (!licenseList) return
    
    // Store test progress and licenses globally
    testProgressData = testProgress
    currentLicenses = licenses
    updateTestCardStatuses()
    
    // Also update the home page and sidebar license status
    updateHomeLicenseStatus(licenses)
    updateSidebarLicenseStatus(licenses)
    
    if (licenses.length === 0) {
        licenseList.innerHTML = `
            <div class="card wide no-licenses">
                <div class="no-licenses-content">
                    <h3>You don't have any licenses</h3>
                    <p class="muted">Complete a test to obtain your first license</p>
                    <button class="btn green" onclick="switchTab('tests')">Go to Tests</button>
                </div>
            </div>
        `
        return
    }
    
    let html = ''
    licenses.forEach(lic => {
        let expiryText = ''
        if (lic.expiry) {
            const expiryDate = new Date(lic.expiry)
            const day = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
            const month = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
            const year = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
            expiryText = `Expiry Date: ${day}/${month}/${year}`
        }
        
        // Check if license is suspended
        const isSuspended = lic.status && lic.status.toLowerCase() === 'suspended'
        let statusExpiryText = ''
        if (isSuspended && lic.statusexpiry) {
            const statusDate = new Date(lic.statusexpiry)
            const day = statusDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
            const month = statusDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
            const year = statusDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
            statusExpiryText = `${day}/${month}/${year}`
        }
        
        // Icon SVG based on license type
        let iconSvg = `<svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M5 17h14v2a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1v-2z"/>
            <path d="M5 17l2-6h10l2 6"/>
            <path d="M7 11l1-3h8l1 3"/>
            <circle cx="8" cy="17" r="2"/>
            <circle cx="16" cy="17" r="2"/>
        </svg>`
        
        if (lic.type === 'bike') {
            iconSvg = `<svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="5.5" cy="17.5" r="3.5"/>
                <circle cx="18.5" cy="17.5" r="3.5"/>
                <path d="M12 6l-3 7h6l-3-7z"/>
                <path d="M9 13l-3.5 4.5"/>
                <path d="M15 13l3.5 4.5"/>
            </svg>`
        }
        
        if (lic.type === 'truck') {
            iconSvg = `<svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <rect x="1" y="7" width="15" height="9" rx="2"/>
                <path d="M16 8h3l2 3v5h-5"/>
                <circle cx="5.5" cy="18.5" r="2.5"/>
                <circle cx="18.5" cy="18.5" r="2.5"/>
            </svg>`
        }
        
        html += `
            <div class="license-card">
                <div class="license-icon">${iconSvg}</div>
                <div class="license-content">
                    <div class="license-header">
                        <h3>${lic.label}</h3>
                        ${isSuspended ? '<span class="pill red">SUSPENDED</span>' : '<span class="pill green">ACTIVE</span>'}
                    </div>
                    <p class="license-expiry">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        ${expiryText}
                    </p>
                    ${isSuspended ? `
                        <div class="suspension-info">
                            <div class="suspension-box">
                                <strong>Demerit Points:</strong> ${lic.demerit_points || 0}
                            </div>
                            <div class="suspension-box">
                                <strong>Suspension Until:</strong> ${statusExpiryText}
                            </div>
                        </div>
                    ` : ''}
                    <div class="license-actions">
                        <button class="btn green license-purchase-btn" data-action="purchaseCard" data-license="${lic.type}">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="2" y="5" width="20" height="14" rx="2"/>
                                <line x1="2" y1="10" x2="22" y2="10"/>
                            </svg>
                            Purchase Physical Card - $500
                        </button>
                    </div>
                </div>
            </div>
        `
    })
    
    licenseList.innerHTML = html
    
    // Add event listeners to purchase buttons
    licenseList.querySelectorAll('button[data-action="purchaseCard"]').forEach(btn => {
        btn.addEventListener('click', function() {
            const license = this.dataset.license
            showPaymentModal('license', license, () => {
                closeUI()
            })
        })
    })
}

function updateHomeLicenseStatus(licenses) {
    const homeLicenseList = document.getElementById('home-license-list')
    if (!homeLicenseList) return
    
    if (licenses.length === 0) {
        homeLicenseList.innerHTML = '<div class="muted">No licenses found.</div>'
        return
    }
    
    // Only show the first license on home page
    const lic = licenses[0]
    let expiryText = ''
    if (lic.expiry) {
        const expiryDate = new Date(lic.expiry)
        const day = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
        const month = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
        const year = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
        expiryText = `Valid Until: ${day}/${month}/${year}`
    }
    
    const isSuspended = lic.status && lic.status.toLowerCase() === 'suspended'
    let statusExpiryText = ''
    if (isSuspended && lic.statusexpiry) {
        const statusDate = new Date(lic.statusexpiry)
        const day = statusDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
        const month = statusDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
        const year = statusDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
        statusExpiryText = `${day}/${month}/${year}`
    }
    
    homeLicenseList.innerHTML = `
        <div class="row">
            <span>${lic.label}</span>
            <span class="pill ${isSuspended ? 'red' : 'green'}">${isSuspended ? 'SUSPENDED' : (expiryText || lic.status.toUpperCase())}</span>
        </div>
        ${isSuspended ? `
            <div class="suspension-info" style="margin-top: 12px;">
                <div class="suspension-box">
                    <strong>Demerit Points:</strong> ${lic.demerit_points || 0}
                </div>
                <div class="suspension-box">
                    <strong>Suspension Until:</strong> ${statusExpiryText}
                </div>
            </div>
        ` : ''}
    `
}

function updateSidebarLicenseStatus(licenses) {
    const sidebarLicenseStatus = document.getElementById('sidebar-license-status')
    if (!sidebarLicenseStatus) return
    
    if (licenses.length === 0) {
        sidebarLicenseStatus.innerHTML = `
            <div style="margin-bottom: 8px; font-weight: 600; color: var(--text);">License Status</div>
            <div class="muted" style="font-size: 13px;">No licenses found.</div>
        `
        return
    }
    
    let html = `<div style="margin-bottom: 12px; font-weight: 600; color: var(--text);">License Status</div>`
    
    licenses.forEach(lic => {
        let expiryText = ''
        if (lic.expiry) {
            const expiryDate = new Date(lic.expiry)
            const day = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
            const month = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
            const year = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
            expiryText = `${day}/${month}/${year}`
        }
        
        const isSuspended = lic.status && lic.status.toLowerCase() === 'suspended'
        
        html += `
            <div class="sidebar-license-box">
                <div class="sidebar-license-name">${lic.label}</div>
                <div class="pill ${isSuspended ? 'red' : 'green'}" style="font-size: 11px; padding: 4px 10px;">${isSuspended ? 'SUSPENDED' : (expiryText || lic.status.toUpperCase())}</div>
            </div>
        `
    })
    
    sidebarLicenseStatus.innerHTML = html
}

function handleTestResult(result) {
    const testArea = document.getElementById('test-area')
    if (!testArea) return
    
    if (result.passed) {
        testArea.innerHTML = `
            <div class="card wide test-result success">
                <h3>✓ Test Passed!</h3>
                <p>Score: ${result.score}%</p>
                <p class="muted">Theory test complete! Now complete the Practical Test to receive your license.</p>
                <div style="display: flex; gap: 12px; justify-content: center;">
                    <button class="btn green" id="start-practical-btn">Start Practical Test</button>
                    <button class="btn green" onclick="document.getElementById('test-area').innerHTML = ''; switchTab('home')">Complete Practical Test Later</button>
                </div>
            </div>
        `
        // Add event listener to start practical test immediately
        setTimeout(() => {
            const btn = document.getElementById('start-practical-btn');
            if (btn) {
                btn.addEventListener('click', function() {
                    closeUI();
                    fetch(`https://${GetParentResourceName()}/startPracticalTest`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ license: result.license })
                    });
                });
            }
        }, 50);
    } else {
        testArea.innerHTML = `
            <div class="card wide test-result failed">
                <h3>✗ Test Failed</h3>
                <p>Score: ${result.score}%</p>
                <p class="muted">Please try again to obtain your license.</p>
                <button class="btn green" onclick="document.querySelector('[data-license=\\\'${result.license}\\\']').click()">Retry Test</button>
                <button class="btn" onclick="document.getElementById('test-area').innerHTML = ''">Close</button>
            </div>
        `
    }
}

function showConfirmModal(title, message, onConfirm) {
    const modal = document.createElement('div')
    modal.className = 'payment-modal'
    modal.style.display = 'flex'
    modal.style.zIndex = '10000'
    modal.style.pointerEvents = 'auto'
    
    modal.innerHTML = `
        <div class="payment-modal-content" style="pointer-events: auto;">
            <h3>${title}</h3>
            <p class="muted" style="margin: 1rem 0;">${message}</p>
            <div class="payment-options">
                <button class="btn green confirm-btn" style="pointer-events: auto;">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                    Confirm
                </button>
                <button class="btn cancel-btn" style="pointer-events: auto; background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); color: var(--red);">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                    Cancel
                </button>
            </div>
        </div>
    `
    document.body.appendChild(modal)
    
    // Add click handler to modal background to close
    modal.addEventListener('click', (e) => {
        if (e.target === modal && modal.parentElement) {
            document.body.removeChild(modal)
        }
    })
    
    // Confirm button
    modal.querySelector('.confirm-btn').addEventListener('click', function(e) {
        e.preventDefault()
        e.stopPropagation()
        if (modal.parentElement) {
            document.body.removeChild(modal)
        }
        onConfirm()
    })
    
    // Cancel button
    modal.querySelector('.cancel-btn').addEventListener('click', function(e) {
        e.preventDefault()
        e.stopPropagation()
        if (modal.parentElement) {
            document.body.removeChild(modal)
        }
    })
}

function showPhotoPickerModal() {
    const modal = document.createElement('div')
    modal.className = 'payment-modal'
    modal.style.display = 'flex'
    modal.style.zIndex = '10001'
    modal.style.pointerEvents = 'auto'
    
    let photosHtml = ''
    
    if (phonePhotos.length === 0) {
        photosHtml = '<p style="text-align: center; color: var(--muted); padding: 20px;">No photos found in your phone gallery</p>'
    } else {
        photosHtml = '<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; max-height: 400px; overflow-y: auto; padding: 8px;">'
        phonePhotos.forEach((photo, index) => {
            photosHtml += `
                <div class="photo-option" data-url="${photo.image}" style="cursor: pointer; position: relative; padding-bottom: 100%; border: 2px solid transparent; border-radius: 4px; overflow: hidden; transition: border-color 0.2s;">
                    <img src="${photo.image}" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\\'http://www.w3.org/2000/svg\\' width=\\'100\\' height=\\'100\\'%3E%3Crect fill=\\'%23333\\' width=\\'100\\' height=\\'100\\'/%3E%3Ctext fill=\\'%23666\\' x=\\'50%25\\' y=\\'50%25\\' text-anchor=\\'middle\\' dy=\\'.3em\\'%3ENo Image%3C/text%3E%3C/svg%3E'">
                </div>
            `
        })
        photosHtml += '</div>'
    }
    
    modal.innerHTML = `
        <div class="payment-modal-content" style="pointer-events: auto; max-width: 600px; width: 90%;">
            <h3>Select Photo</h3>
            <p class="muted" style="margin: 0.5rem 0 1rem 0;">Choose a photo from your gallery</p>
            ${photosHtml}
            <button class="btn cancel-photo-picker" style="width: 100%; margin-top: 16px; pointer-events: auto;">Cancel</button>
        </div>
    `
    document.body.appendChild(modal)
    
    const closeModal = () => {
        if (modal.parentElement) {
            document.body.removeChild(modal)
        }
    }
    
    // Click outside to close
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            closeModal()
        }
    })
    
    // Cancel button
    modal.querySelector('.cancel-photo-picker').addEventListener('click', closeModal)
    
    // Photo selection
    modal.querySelectorAll('.photo-option').forEach(photoDiv => {
        photoDiv.addEventListener('click', function() {
            const imageUrl = this.dataset.url
            document.getElementById('reg-image').value = imageUrl
            document.getElementById('preview-image').src = imageUrl
            document.getElementById('selected-photo-preview').style.display = 'block'
            document.getElementById('select-photo-btn').style.display = 'none'
            closeModal()
        })
        
        // Hover effect
        photoDiv.addEventListener('mouseenter', function() {
            this.style.borderColor = 'var(--green)'
        })
        photoDiv.addEventListener('mouseleave', function() {
            this.style.borderColor = 'transparent'
        })
    })
}

function showPaymentModal(type, data, onSuccess) {
    const modal = document.createElement('div')
    modal.className = 'payment-modal'
    modal.style.display = 'flex'
    modal.style.zIndex = '10000'
    modal.style.pointerEvents = 'auto'
    
    // Determine cost based on type
    let cost = 300
    if (type === 'editRegistration') {
        cost = 1000
    }
    
    modal.innerHTML = `
        <div class="payment-modal-content" style="pointer-events: auto;">
            <h3>Select Payment Method</h3>
            <p class="muted">Cost: $${cost}</p>
            <div class="payment-options">
                <button class="btn green payment-btn" data-method="cash" style="pointer-events: auto;">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="7" width="20" height="10" rx="2"/>
                        <line x1="2" y1="12" x2="22" y2="12"/>
                    </svg>
                    Cash - $${cost}
                </button>
                <button class="btn green payment-btn" data-method="bank" style="pointer-events: auto;">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="18" height="18" rx="2"/>
                        <line x1="3" y1="9" x2="21" y2="9"/>
                        <line x1="9" y1="21" x2="9" y2="9"/>
                    </svg>
                    Bank - $${cost}
                </button>
            </div>
            <button class="btn cancel-payment" style="pointer-events: auto;">Cancel</button>
        </div>
    `
    document.body.appendChild(modal)
    
    // Add click handler to modal background to close
    modal.addEventListener('click', (e) => {
        if (e.target === modal && modal.parentElement) {
            document.body.removeChild(modal)
        }
    })
    
    // Ensure buttons are interactive
    const buttons = modal.querySelectorAll('.payment-btn')
    buttons.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault()
            e.stopPropagation()
            const method = this.dataset.method
            let endpoint, payload
            
            if (type === 'license') {
                endpoint = 'purchaseCard'
                payload = { license: data, paymentMethod: method }
            } else if (type === 'registration') {
                endpoint = 'registerVehicle'
                payload = { ...data, paymentMethod: method }
            } else if (type === 'editRegistration') {
                endpoint = 'editRegistration'
                payload = { ...data, paymentMethod: method }
            } else {
                endpoint = 'renewVehicle'
                payload = { plate: data, paymentMethod: method }
            }
            
            // Close modal immediately
            if (modal.parentElement) {
                document.body.removeChild(modal)
            }
            
            // Close the main UI
            closeUI()
            
            fetch(`https://${GetParentResourceName()}/${endpoint}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            }).then(resp => resp.json()).then(result => {
                // Refresh data after payment attempt
                setTimeout(() => {
                    if (type === 'registration' || type === 'renewVehicle' || type === 'editRegistration') {
                        fetch(`https://${GetParentResourceName()}/getVehicles`, { method: 'POST' })
                    } else if (type === 'license') {
                        fetch(`https://${GetParentResourceName()}/getLicenses`, { method: 'POST' })
                    }
                }, 100)
            }).catch(() => {
                // Error handled by server notification
            })
        })
    })
    
    modal.querySelector('.cancel-payment').addEventListener('click', (e) => {
        e.preventDefault()
        e.stopPropagation()
        if (modal.parentElement) {
            document.body.removeChild(modal)
        }
    })
}

function showVehicleInfo(vehicle) {
    const modal = document.createElement('div')
    modal.className = 'vehicle-info-modal'
    
    // Format expiry date if available
    let expiryDisplay = 'N/A'
    if (vehicle.expiry) {
        const expiryDate = new Date(vehicle.expiry)
        const day = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', day: 'numeric' })
        const month = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', month: 'numeric' })
        const year = expiryDate.toLocaleDateString('en-AU', { timeZone: 'Australia/Melbourne', year: 'numeric' })
        expiryDisplay = `${day}/${month}/${year}`
    }
    
    modal.innerHTML = `
        <div class="vehicle-info-modal-content">
            <div class="vehicle-info-header">
                <h3>Vehicle Information</h3>
                <button class="btn-close-info">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            <div class="vehicle-info-body">
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M5 17h14v2a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1v-2z"/>
                            <path d="M5 17l2-6h10l2 6"/>
                            <circle cx="8" cy="17" r="2"/>
                            <circle cx="16" cy="17" r="2"/>
                        </svg>
                        Model
                    </span>
                    <span class="info-value">${vehicle.model || 'Unknown'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="5" width="18" height="14" rx="2"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        Plate
                    </span>
                    <span class="info-value">${vehicle.plate || 'Unknown'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <path d="M12 6v6l4 2"/>
                        </svg>
                        Status
                    </span>
                    <span class="pill ${vehicle.status && vehicle.status.toUpperCase() === 'REGISTERED' ? 'green' : 'red'}">${vehicle.status || 'Unknown'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20z"/>
                            <path d="M8 14s1.5 2 4 2 4-2 4-2"/>
                        </svg>
                        Type
                    </span>
                    <span class="info-value">${vehicle.type || 'Unknown'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                        </svg>
                        Color
                    </span>
                    <span class="info-value">${vehicle.color || 'Unknown'}</span>
                </div>
                ${vehicle.state ? `
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                            <circle cx="12" cy="10" r="3"/>
                        </svg>
                        State
                    </span>
                    <span class="info-value">${vehicle.state}</span>
                </div>
                ` : ''}
                ${vehicle.status && vehicle.status.toUpperCase() === 'REGISTERED' ? `
                <div class="info-row">
                    <span class="info-label">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        Expiry Date
                    </span>
                    <span class="info-value">${expiryDisplay}</span>
                </div>
                ` : ''}
            </div>
            <button class="btn green close-info-btn">Close</button>
        </div>
    `
    document.body.appendChild(modal)
    
    const closeModal = () => document.body.removeChild(modal)
    modal.querySelector('.btn-close-info').addEventListener('click', closeModal)
    modal.querySelector('.close-info-btn').addEventListener('click', closeModal)
    modal.addEventListener('click', (e) => {
        if (e.target === modal) closeModal()
    })
}

function showRegistrationForm(vehicle) {
    const modal = document.createElement('div')
    modal.className = 'vehicle-info-modal'
    
    modal.innerHTML = `
        <div class="vehicle-info-modal-content">
            <div class="vehicle-info-header">
                <h3>Register Vehicle - ${vehicle.plate}</h3>
                <button class="btn-close-registration">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            <div class="vehicle-info-body">
                <p style="margin: 0 0 20px 0; color: var(--muted); font-size: 14px;">
                    Please provide the following information for vehicle registration. Registration fee: $300
                </p>
                <div class="form-group">
                    <label for="reg-make">Vehicle Make *</label>
                    <input type="text" id="reg-make" class="form-input" placeholder="e.g., Toyota, Ford, Honda" required>
                </div>
                <div class="form-group">
                    <label for="reg-model">Vehicle Model *</label>
                    <input type="text" id="reg-model" class="form-input" placeholder="e.g., Camry, Mustang, Civic" required>
                </div>
                <div class="form-group">
                    <label for="reg-color">Vehicle Color *</label>
                    <select id="reg-color" class="form-input select-neat" required>
                        <option value="" disabled selected>Select Color</option>
                        <option value="Black">Black</option>
                        <option value="White">White</option>
                        <option value="Silver">Silver</option>
                        <option value="Grey">Grey</option>
                        <option value="Red">Red</option>
                        <option value="Blue">Blue</option>
                        <option value="Green">Green</option>
                        <option value="Yellow">Yellow</option>
                        <option value="Orange">Orange</option>
                        <option value="Brown">Brown</option>
                        <option value="Purple">Purple</option>
                        <option value="Pink">Pink</option>
                        <option value="Beige">Beige</option>
                        <option value="Gold">Gold</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reg-type">Vehicle Type *</label>
                    <select id="reg-type" class="form-input select-neat" required>
                        <option value="" disabled selected>Select Vehicle Type</option>
                        <option value="Sedan">Sedan</option>
                        <option value="SUV">SUV</option>
                        <option value="Truck">Truck</option>
                        <option value="Van">Van</option>
                        <option value="Coupe">Coupe</option>
                        <option value="Hatchback">Hatchback</option>
                        <option value="Motorcycle">Motorcycle</option>
                        <option value="Sports">Sports</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reg-state">State *</label>
                    <select id="reg-state" class="form-input select-neat" required>
                        <option value="" disabled selected>Select State</option>
                        <option value="Victoria">Victoria</option>
                        <option value="New South Wales">New South Wales</option>
                        <option value="Queensland">Queensland</option>
                        <option value="South Australia">South Australia</option>
                        <option value="Western Australia">Western Australia</option>
                        <option value="Tasmania">Tasmania</option>
                        <option value="Northern Territory">Northern Territory</option>
                        <option value="Australian Capital Territory">Australian Capital Territory</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reg-image">Vehicle Photo (Optional)</label>
                    <button type="button" class="btn green" id="select-photo-btn" style="width: 100%; margin-bottom: 8px;">Select Photo from Phone</button>
                    <div id="selected-photo-preview" style="display: none; margin-top: 8px; text-align: center;">
                        <img id="preview-image" src="" style="max-width: 100%; max-height: 200px; border-radius: 4px; border: 1px solid var(--border);">
                        <button type="button" class="btn" id="remove-photo-btn" style="margin-top: 8px; width: 100%;">Remove Photo</button>
                    </div>
                    <input type="hidden" id="reg-image" value="">
                    <small style="color: var(--muted); font-size: 12px; margin-top: 4px;">Select a photo from your phone gallery</small>
                </div>
                <p class="form-note">* Required fields</p>
            </div>
            <div style="display: flex; gap: 12px; padding: 0 24px 24px 24px;">
                <button class="btn green register-submit-btn" style="flex: 1;">Register Vehicle</button>
                <button class="btn cancel-registration" style="flex: 1;">Cancel</button>
            </div>
        </div>
    `
    document.body.appendChild(modal)
    
    const closeModal = () => {
        document.removeEventListener('keydown', escapeHandler)
        document.body.removeChild(modal)
    }
    
    // Escape key handler
    const escapeHandler = (e) => {
        if (e.key === 'Escape') {
            closeModal()
        }
    }
    document.addEventListener('keydown', escapeHandler)
    
    modal.querySelector('.btn-close-registration').addEventListener('click', closeModal)
    modal.querySelector('.cancel-registration').addEventListener('click', closeModal)
    
    // Request phone photos
    fetch(`https://${GetParentResourceName()}/getPhonePhotos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    
    // Photo selector button
    modal.querySelector('#select-photo-btn').addEventListener('click', () => {
        showPhotoPickerModal()
    })
    
    // Remove photo button
    modal.querySelector('#remove-photo-btn').addEventListener('click', () => {
        document.getElementById('reg-image').value = ''
        document.getElementById('selected-photo-preview').style.display = 'none'
        document.getElementById('select-photo-btn').style.display = 'block'
    })
    
    modal.querySelector('.register-submit-btn').addEventListener('click', () => {
        const make = document.getElementById('reg-make').value.trim()
        const model = document.getElementById('reg-model').value.trim()
        const color = document.getElementById('reg-color').value.trim()
        const type = document.getElementById('reg-type').value
        const state = document.getElementById('reg-state').value
        const imageUrl = document.getElementById('reg-image').value.trim()
        
        if (!make || !model || !color || !type || !state) {
            // Show error notification
            return
        }
        
        // Close the registration form modal
        closeModal()
        
        // Show payment modal with registration data
        const registrationData = {
            plate: vehicle.plate,
            make: make,
            model: model,
            color: color,
            type: type,
            state: state,
            imageUrl: imageUrl || null
        }
        
        showPaymentModal('registration', registrationData, () => {
            closeUI()
        })
    })
    
    modal.addEventListener('click', (e) => {
        if (e.target === modal) closeModal()
    })
}

function showEditRegistrationForm(vehicle) {
    const modal = document.createElement('div')
    modal.className = 'vehicle-info-modal'
    
    modal.innerHTML = `
        <div class="vehicle-info-modal-content">
            <div class="vehicle-info-header">
                <h3>Edit Registration - ${vehicle.plate}</h3>
                <button class="btn-close-edit">
                    <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            <div class="vehicle-info-body">
                <p style="margin: 0 0 20px 0; color: var(--muted); font-size: 14px;">
                    Update your vehicle color. Update fee: $1000
                </p>
                <div class="form-group">
                    <label for="edit-color">Vehicle Color *</label>
                    <select id="edit-color" class="form-input select-neat" required>
                        <option value="Black" ${vehicle.color === 'Black' ? 'selected' : ''}>Black</option>
                        <option value="White" ${vehicle.color === 'White' ? 'selected' : ''}>White</option>
                        <option value="Silver" ${vehicle.color === 'Silver' ? 'selected' : ''}>Silver</option>
                        <option value="Grey" ${vehicle.color === 'Grey' ? 'selected' : ''}>Grey</option>
                        <option value="Red" ${vehicle.color === 'Red' ? 'selected' : ''}>Red</option>
                        <option value="Blue" ${vehicle.color === 'Blue' ? 'selected' : ''}>Blue</option>
                        <option value="Green" ${vehicle.color === 'Green' ? 'selected' : ''}>Green</option>
                        <option value="Yellow" ${vehicle.color === 'Yellow' ? 'selected' : ''}>Yellow</option>
                        <option value="Orange" ${vehicle.color === 'Orange' ? 'selected' : ''}>Orange</option>
                        <option value="Brown" ${vehicle.color === 'Brown' ? 'selected' : ''}>Brown</option>
                        <option value="Purple" ${vehicle.color === 'Purple' ? 'selected' : ''}>Purple</option>
                        <option value="Pink" ${vehicle.color === 'Pink' ? 'selected' : ''}>Pink</option>
                        <option value="Beige" ${vehicle.color === 'Beige' ? 'selected' : ''}>Beige</option>
                        <option value="Gold" ${vehicle.color === 'Gold' ? 'selected' : ''}>Gold</option>
                    </select>
                </div>
            </div>
            <div style="display: flex; gap: 12px; padding: 0 24px 24px 24px;">
                <button class="btn green edit-submit-btn" style="flex: 1;">Update Registration</button>
                <button class="btn cancel-edit" style="flex: 1;">Cancel</button>
            </div>
        </div>
    `
    document.body.appendChild(modal)
    
    const closeModal = () => document.body.removeChild(modal)
    
    modal.querySelector('.btn-close-edit').addEventListener('click', closeModal)
    modal.querySelector('.cancel-edit').addEventListener('click', closeModal)
    
    modal.querySelector('.edit-submit-btn').addEventListener('click', () => {
        const color = document.getElementById('edit-color').value.trim()
        
        if (!color) {
            // Show error notification
            return
        }
        
        // Close the edit form modal
        closeModal()
        
        // Show payment modal with updated color data
        const registrationData = {
            plate: vehicle.plate,
            color: color
        }
        
        showPaymentModal('editRegistration', registrationData, () => {
            closeUI()
        })
    })
    
    modal.addEventListener('click', (e) => {
        if (e.target === modal) closeModal()
    })
}
