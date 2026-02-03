// gameboard.js - Game board logic

class GameBoard {
    constructor(canvas, boardWidth, boardHeight) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.boardWidth = boardWidth;
        this.boardHeight = boardHeight;
        
        // Calculate square dimensions
        const canvasWidth = 480;
        const canvasHeight = 660; // 11 rows visible
        this.squareWidth = canvasWidth / boardWidth;
        this.squareHeight = canvasHeight / boardHeight;
        
        this.canvas.width = canvasWidth;
        this.canvas.height = canvasHeight;
        
        this.drawFunctions = new DrawFunctions(this.squareWidth, this.squareHeight);
        
        // Game state
        this.tableGameBoardPlacement = {};
        this.allCrossAndCircles = [];
        this.turnPhase = 1;
        this.xPosOffset = 0;
        this.yPosOffset = 0;
        this.minX = 0;
        this.maxX = 0;
        this.minY = 0;
        this.maxY = 0;
        this.lastPlacedForUndo = null;
        this.boardLocked = false;
        this.gameOver = false;
        this.winningPlayer = 0;
        
        // Callbacks
        this.onTurnChangeCallback = null;
        
        // Touch/mouse tracking
        this.isDragging = false;
        this.lastMouseX = 0;
        this.lastMouseY = 0;
        this.dragStartX = 0;
        this.dragStartY = 0;
        this.boardStartX = 0;
        this.boardStartY = 0;
        
        this.onWinCallback = null;
        
        this.setupEventListeners();
    }

    setupEventListeners() {
        this.canvas.addEventListener('mousedown', (e) => this.handleStart(e));
        this.canvas.addEventListener('mousemove', (e) => this.handleMove(e));
        this.canvas.addEventListener('mouseup', (e) => this.handleEnd(e));
        this.canvas.addEventListener('touchstart', (e) => this.handleStart(e), { passive: false });
        this.canvas.addEventListener('touchmove', (e) => this.handleMove(e), { passive: false });
        this.canvas.addEventListener('touchend', (e) => this.handleEnd(e), { passive: false });
    }

    getCoordinates(event) {
        const rect = this.canvas.getBoundingClientRect();
        let clientX, clientY;
        
        if (event.touches && event.touches.length > 0) {
            clientX = event.touches[0].clientX;
            clientY = event.touches[0].clientY;
        } else {
            clientX = event.clientX;
            clientY = event.clientY;
        }
        
        return {
            x: clientX - rect.left,
            y: clientY - rect.top
        };
    }

    handleStart(event) {
        event.preventDefault();
        if (this.boardLocked || this.gameOver) return;
        
        const coords = this.getCoordinates(event);
        this.lastMouseX = coords.x;
        this.lastMouseY = coords.y;
        this.dragStartX = coords.x;
        this.dragStartY = coords.y;
        this.boardStartX = this.xPosOffset;
        this.boardStartY = this.yPosOffset;
        this.isDragging = false;
    }

    handleMove(event) {
        event.preventDefault();
        if (this.boardLocked || this.gameOver) return;
        
        const coords = this.getCoordinates(event);
        const deltaX = coords.x - this.dragStartX;
        const deltaY = coords.y - this.dragStartY;
        
        // Check if this is a drag (moved more than 5 pixels)
        if (Math.abs(deltaX) > 5 || Math.abs(deltaY) > 5) {
            this.isDragging = true;
            
            // Calculate movement in grid squares
            const moveX = Math.round(deltaX / this.squareWidth);
            const moveY = Math.round(deltaY / this.squareHeight);
            
            // Update offsets with constraints
            this.xPosOffset = this.constrainOffset(this.boardStartX + moveX, this.minX, this.maxX, this.boardWidth);
            this.yPosOffset = this.constrainOffset(this.boardStartY + moveY, this.minY, this.maxY, this.boardHeight);
            
            this.draw();
        }
    }

    constrainOffset(offset, min, max, boardSize) {
        if (min === max) return 0; // No moves yet
        
        const maxOffset = Math.max(0, max - boardSize + 3);
        const minOffset = Math.min(0, min - 2);
        
        return Math.max(minOffset, Math.min(maxOffset, offset));
    }

    handleEnd(event) {
        event.preventDefault();
        if (this.boardLocked || this.gameOver) return;
        
        if (!this.isDragging) {
            // This was a tap/click
            const coords = this.getCoordinates(event);
            this.placePiece(coords.x, coords.y);
        }
        
        this.isDragging = false;
    }

    getPlayer() {
        return (this.turnPhase % 2) + 1;
    }

    placePiece(x, y) {
        const i = Math.floor(x / this.squareWidth) + this.xPosOffset;
        const j = Math.floor(y / this.squareHeight) + this.yPosOffset;
        
        // Check if position is valid and empty
        if (i < 0 || i >= this.boardWidth || j < 0 || j >= this.boardHeight) return;
        
        if (!this.tableGameBoardPlacement[i]) {
            this.tableGameBoardPlacement[i] = {};
        }
        
        if (this.tableGameBoardPlacement[i][j]) {
            return; // Already occupied
        }
        
        // Place piece
        const player = this.getPlayer();
        this.tableGameBoardPlacement[i][j] = player;
        
        this.lastPlacedForUndo = {
            x: i,
            y: j,
            player: player
        };
        
        this.updateGameBoardMaxs(i, j);
        this.turnPhase++;
        
        // Notify turn change
        if (this.onTurnChangeCallback) {
            this.onTurnChangeCallback();
        }
        
        // Lock board briefly to prevent accidental double-placement
        this.boardLocked = true;
        setTimeout(() => {
            this.boardLocked = false;
        }, 500);
        
        this.draw();
        
        // Check for win
        const winner = this.checkWin(i, j);
        if (winner > 0) {
            this.gameOver = true;
            this.winningPlayer = winner;
            if (this.onWinCallback) {
                setTimeout(() => {
                    this.onWinCallback(winner);
                }, 500);
            }
        }
    }

    updateGameBoardMaxs(x, y) {
        if (this.turnPhase === 1) {
            this.minX = x;
            this.maxX = x;
            this.minY = y;
            this.maxY = y;
        } else {
            this.minX = Math.min(this.minX, x);
            this.maxX = Math.max(this.maxX, x);
            this.minY = Math.min(this.minY, y);
            this.maxY = Math.max(this.maxY, y);
        }
    }

    checkWin(i, j) {
        const player = this.tableGameBoardPlacement[i][j];
        
        // Check horizontal
        let horizontalWin = 1;
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i + k]?.[j] === player) horizontalWin++;
            else break;
        }
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i - k]?.[j] === player) horizontalWin++;
            else break;
        }
        
        // Check vertical
        let verticalWin = 1;
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i]?.[j + k] === player) verticalWin++;
            else break;
        }
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i]?.[j - k] === player) verticalWin++;
            else break;
        }
        
        // Check diagonal (top-left to bottom-right)
        let diagWinLTRD = 1;
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i + k]?.[j + k] === player) diagWinLTRD++;
            else break;
        }
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i - k]?.[j - k] === player) diagWinLTRD++;
            else break;
        }
        
        // Check diagonal (bottom-left to top-right)
        let diagWinLDRT = 1;
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i + k]?.[j - k] === player) diagWinLDRT++;
            else break;
        }
        for (let k = 1; k <= 4; k++) {
            if (this.tableGameBoardPlacement[i - k]?.[j + k] === player) diagWinLDRT++;
            else break;
        }
        
        if (horizontalWin >= 5 || verticalWin >= 5 || diagWinLTRD >= 5 || diagWinLDRT >= 5) {
            return player;
        }
        
        return 0;
    }

    undo() {
        if (!this.lastPlacedForUndo) return false;
        
        const { x, y } = this.lastPlacedForUndo;
        delete this.tableGameBoardPlacement[x][y];
        this.lastPlacedForUndo = null;
        this.turnPhase--;
        this.draw();
        
        return true;
    }

    newGame() {
        this.tableGameBoardPlacement = {};
        this.turnPhase = 1;
        this.xPosOffset = 0;
        this.yPosOffset = 0;
        this.minX = 0;
        this.maxX = 0;
        this.minY = 0;
        this.maxY = 0;
        this.lastPlacedForUndo = null;
        this.boardLocked = false;
        this.gameOver = false;
        this.winningPlayer = 0;
        this.draw();
    }

    draw() {
        // Clear canvas
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Draw grid
        this.ctx.strokeStyle = '#ffffff';
        this.ctx.lineWidth = 2;
        
        for (let i = 0; i <= this.boardWidth; i++) {
            const x = i * this.squareWidth;
            this.ctx.beginPath();
            this.ctx.moveTo(x, 0);
            this.ctx.lineTo(x, this.canvas.height);
            this.ctx.stroke();
        }
        
        for (let j = 0; j <= this.boardHeight; j++) {
            const y = j * this.squareHeight;
            this.ctx.beginPath();
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(this.canvas.width, y);
            this.ctx.stroke();
        }
        
        // Draw pieces
        for (let i in this.tableGameBoardPlacement) {
            for (let j in this.tableGameBoardPlacement[i]) {
                const player = this.tableGameBoardPlacement[i][j];
                const screenX = (parseInt(i) - this.xPosOffset) * this.squareWidth + this.squareWidth / 2;
                const screenY = (parseInt(j) - this.yPosOffset) * this.squareHeight + this.squareHeight / 2;
                
                // Only draw if on screen
                if (screenX >= 0 && screenX <= this.canvas.width && 
                    screenY >= 0 && screenY <= this.canvas.height) {
                    if (player === 1) {
                        this.drawFunctions.drawCircle(this.ctx, screenX, screenY, 0, 0);
                    } else {
                        const xMin = screenX - this.squareWidth / 2;
                        const yMin = screenY - this.squareHeight / 2;
                        const xMax = screenX + this.squareWidth / 2;
                        const yMax = screenY + this.squareHeight / 2;
                        this.drawFunctions.drawCross(this.ctx, xMin, yMin, xMax, yMax, 0, 0);
                    }
                }
            }
        }
    }

    getCurrentPlayer() {
        return this.getPlayer();
    }
}
