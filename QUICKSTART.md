# Quick Start Guide - Fem i Rad Web Version

## Running the Game

### Option 1: Direct Open (Simplest)
1. Download or clone the repository
2. Open `index.html` in your web browser
3. Click "New Local Game" to start playing!

### Option 2: Local Server (Recommended for development)
```bash
# Using Python 3
python -m http.server 8000

# Using Node.js
npx http-server

# Using PHP
php -S localhost:8000

# Then open: http://localhost:8000
```

## How to Play

1. **Start Game**: Click "New Local Game" button on the title screen
2. **Place Pieces**: Click/tap on any square to place your piece
   - Player 1 (Circle) goes first - Yellow circles ◯
   - Player 2 (Cross) goes second - Cyan crosses ✕
3. **Pan Board**: Click and drag to move the board around (when game expands)
4. **Undo Move**: Click the "UNDO" button to take back your last move
5. **Win Condition**: First player to get 5 pieces in a row wins!
   - Can be horizontal, vertical, or diagonal
6. **Restart**: After someone wins, click "Restart" to play again

## Game Controls

- **Mouse**: Click to place, click and drag to pan
- **Touch**: Tap to place, drag to pan
- **Keyboard**: Not used (game is fully mouse/touch-based)

## Tips

- The board is 8 columns × 11 rows
- You can scroll/pan the board by dragging
- The turn indicator at the bottom shows whose turn it is
- Scores persist across games (until you refresh the page)
- The UNDO button only works for the last move

## Browser Compatibility

Works on all modern browsers:
- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## Troubleshooting

**Images not loading?**
- Make sure all image files (PNG/JPG) are in the same directory as index.html
- Check browser console for 404 errors

**Game not responding?**
- Try refreshing the page (F5 or Ctrl+R)
- Make sure JavaScript is enabled in your browser
- Check browser console for errors (F12)

**Touch not working on mobile?**
- The game uses modern touch events - update your browser if issues persist
- Try landscape orientation for better experience

## Technical Requirements

- Modern web browser with:
  - HTML5 Canvas support
  - ES6 JavaScript support
  - Touch Events API (for mobile)
- No internet connection required
- No installation needed
- No external dependencies

## File Structure

```
FemIRad/
├── index.html          # Main HTML file - OPEN THIS
├── style.css           # Styling
├── main.js            # Game controller
├── gameboard.js       # Game logic
├── drawfunctions.js   # Drawing utilities
├── README.md          # Full documentation
├── QUICKSTART.md      # This file
└── [images]           # PNG/JPG assets
```

## Need Help?

See the full [README.md](README.md) for detailed information.
