// main.js - Main game controller

class Game {
    constructor() {
        this.boardWidth = 8;
        this.boardHeight = 11;
        this.crossScore = 0;
        this.circleScore = 0;
        this.gameBoard = null;
        
        // Get DOM elements
        this.titleScreen = document.getElementById('title-screen');
        this.gameScreen = document.getElementById('game-screen');
        this.winScreen = document.getElementById('win-screen');
        this.canvas = document.getElementById('game-canvas');
        
        this.startButton = document.getElementById('start-button');
        this.restartButton = document.getElementById('restart-button');
        this.undoButton = document.getElementById('undo-button');
        
        this.turnCross = document.getElementById('turn-cross');
        this.turnCircle = document.getElementById('turn-circle');
        
        this.winImage = document.getElementById('win-image');
        this.crossScoreDisplay = document.getElementById('cross-score');
        this.circleScoreDisplay = document.getElementById('circle-score');
        
        this.setupEventListeners();
    }

    setupEventListeners() {
        this.startButton.addEventListener('click', () => this.startGame());
        this.restartButton.addEventListener('click', () => this.restartGame());
        this.undoButton.addEventListener('click', () => this.undo());
    }

    startGame() {
        this.titleScreen.classList.add('hidden');
        this.gameScreen.classList.remove('hidden');
        
        if (!this.gameBoard) {
            this.gameBoard = new GameBoard(this.canvas, this.boardWidth, this.boardHeight);
            this.gameBoard.onWinCallback = (winner) => this.handleWin(winner);
            this.gameBoard.onTurnChangeCallback = () => this.updateTurnIndicator();
        }
        
        this.gameBoard.newGame();
        this.updateTurnIndicator();
    }

    restartGame() {
        this.winScreen.classList.add('hidden');
        this.gameScreen.classList.remove('hidden');
        this.gameBoard.newGame();
        this.updateTurnIndicator();
    }

    undo() {
        if (this.gameBoard && this.gameBoard.undo()) {
            this.updateTurnIndicator();
        }
    }

    handleWin(winner) {
        if (winner === 1) {
            this.circleScore++;
            this.winImage.src = 'CircleWins.png';
        } else if (winner === 2) {
            this.crossScore++;
            this.winImage.src = 'CrossWins.png';
        }
        
        this.crossScoreDisplay.textContent = this.crossScore;
        this.circleScoreDisplay.textContent = this.circleScore;
        
        this.gameScreen.classList.add('hidden');
        this.winScreen.classList.remove('hidden');
    }

    updateTurnIndicator() {
        if (!this.gameBoard) return;
        
        const currentPlayer = this.gameBoard.getCurrentPlayer();
        if (currentPlayer === 1) {
            this.turnCircle.classList.remove('hidden');
            this.turnCross.classList.add('hidden');
        } else {
            this.turnCross.classList.remove('hidden');
            this.turnCircle.classList.add('hidden');
        }
    }
}

// Initialize game when page loads
window.addEventListener('DOMContentLoaded', () => {
    const game = new Game();
});
