# Fem i Rad - Web Browser Version

This is a web browser version of the "Fem i Rad" (Five in a Row) game, originally created for iOS using Corona SDK.

## About the Game

Fem i Rad is a strategic board game similar to Gomoku or Five in a Row. Two players take turns placing their pieces (circles and crosses) on a grid. The first player to get five of their pieces in a row (horizontally, vertically, or diagonally) wins!

## How to Play

1. Open `index.html` in a modern web browser
2. Click "New Local Game" to start
3. Players take turns tapping/clicking on the board to place their pieces
4. Drag the board to pan around when the game extends beyond the visible area
5. Use the "UNDO" button to undo the last move
6. The game automatically detects when a player gets five in a row
7. Click "Restart" to play another round

## Features

- **8x11 game board** with scrolling capability
- **Touch and mouse support** - works on desktop and mobile devices
- **Drag to pan** - move the board around as the game expands
- **Undo functionality** - take back your last move
- **Score tracking** - keeps track of wins for both players
- **Responsive design** - adapts to different screen sizes

## Technical Details

The game has been converted from Lua/Corona SDK to vanilla HTML5, CSS3, and JavaScript:

- **HTML5 Canvas** for rendering the game board and pieces
- **CSS3** for styling and animations
- **Vanilla JavaScript** - no frameworks required
- **Touch events** support for mobile devices
- **Modular code structure** with separate files for game logic, drawing, and UI

## Files

- `index.html` - Main HTML structure
- `style.css` - Styling and layout
- `main.js` - Main game controller
- `gameboard.js` - Game board logic and state management
- `drawfunctions.js` - Drawing utilities for pieces
- Image assets (PNG/JPG) - Graphics for UI and backgrounds

## Browser Compatibility

Works in all modern browsers that support:
- HTML5 Canvas
- ES6 JavaScript
- Touch Events API

Tested on:
- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Running Locally

Simply open `index.html` in your web browser. No server required!

For development with live reload, you can use any simple HTTP server:

```bash
# Using Python 3
python -m http.server 8000

# Using Node.js
npx http-server

# Then open http://localhost:8000
```

## Original Version

This game was originally developed for iOS using the Corona SDK. The original Lua source files are included in the repository for reference.

## License

See the repository for license information.
