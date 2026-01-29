# VicRoads Map Setup Guide

## Current Setup
The map currently uses a GTA V satellite map image hosted on imgur. The map is fully interactive with:
- **Drag to pan** - Click and drag the map to move around
- **Scroll to zoom** - Use mouse wheel to zoom in/out (0.5x to 3x)
- **Location markers** - Office locations from config.lua appear as green markers
- **Player position** - Your current position shows as a blue marker

## Using a Custom Map Image

### Option 1: Using Your Own Hosted Image (Recommended)
1. Host your map image on a reliable service (imgur, your own CDN, etc.)
2. Edit `html/app.js` around line 298
3. Replace the `mapImage.src` URL with your image URL:
```javascript
mapImage.src = 'https://your-image-host.com/your-map.png'
```

### Option 2: Using a Local Map File
1. Add your map image to the `html` folder (e.g., `html/gtav_map.png`)
2. Edit `html/app.js` around line 298
3. Change the src to a relative path:
```javascript
mapImage.src = './gtav_map.png'
```
4. Update `fxmanifest.lua` to include the file:
```lua
files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/gtav_map.png'  -- Add this line
}
```

### Option 3: Using FiveM Addon Map Coordinates
If you're using a custom addon map (like Cayo Perico, Liberty City, etc.):

1. Update the `MAP_BOUNDS` in `html/app.js` (around line 277) to match your map:
```javascript
const MAP_BOUNDS = {
    minX: -4000,  // Your map's minimum X coordinate
    maxX: 4000,   // Your map's maximum X coordinate
    minY: -4000,  // Your map's minimum Y coordinate
    maxY: 8000    // Your map's maximum Y coordinate
}
```

2. Get a map image for your addon map and follow Option 1 or 2 above

3. Adjust your office locations in `config.lua` to match coordinates on your custom map

## Recommended Map Images

### GTA V Online Maps:
- **Current (default)**: https://i.imgur.com/KUSH7Tj.png
- **High quality atlas**: https://i.imgur.com/JiV3KjL.jpeg
- **Satellite view**: https://i.imgur.com/YjjQjJT.png

### Custom/Addon Maps:
Search for "[Your Map Name] satellite image" or create your own using map tools.

## Coordinate System
The map uses GTA V's coordinate system:
- Origin (0,0) is roughly in the center of Los Santos
- X increases going East
- Y increases going North
- Typical range: -4000 to +4000 for X, -4000 to +8000 for Y

Your office locations in `config.lua` use these same coordinates, so markers will appear in the correct positions automatically.

## Troubleshooting

**Map not loading?**
- Check browser console (F12) for errors
- Ensure the image URL is accessible (CORS enabled)
- Try a different image URL

**Markers in wrong positions?**
- Verify your `MAP_BOUNDS` match your map
- Check coordinates in `config.lua` are correct
- Ensure image is oriented correctly (North at top)

**Map too zoomed in/out?**
- Adjust the initial scale in `mapData` (line 271)
- Or use mouse wheel to zoom when viewing
