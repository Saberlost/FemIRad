// drawfunctions.js - Drawing utilities for the game

class DrawFunctions {
    constructor(squareWidth, squareHeight) {
        this.squareWidth = squareWidth;
        this.squareHeight = squareHeight;
    }

    setValues(squareWidth, squareHeight) {
        this.squareWidth = squareWidth;
        this.squareHeight = squareHeight;
    }

    drawCircle(ctx, x, y, xOffset, yOffset) {
        const centerX = x + xOffset * this.squareWidth;
        const centerY = y + yOffset * this.squareHeight;
        const radius = this.squareWidth / 3;

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
        ctx.strokeStyle = '#ffff00'; // Yellow
        ctx.lineWidth = 7;
        ctx.stroke();
    }

    drawCross(ctx, xMin, yMin, xMax, yMax, xOffset, yOffset) {
        const notEdge = 15;
        
        const x1 = xMin + xOffset * this.squareWidth + notEdge;
        const y1 = yMin + yOffset * this.squareHeight + notEdge;
        const x2 = xMax + xOffset * this.squareWidth - notEdge;
        const y2 = yMax + yOffset * this.squareHeight - notEdge;

        ctx.strokeStyle = '#00ffff'; // Cyan
        ctx.lineWidth = 7;
        
        // Draw first line (top-left to bottom-right)
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.stroke();

        // Draw second line (bottom-left to top-right)
        ctx.beginPath();
        ctx.moveTo(x1, y2);
        ctx.lineTo(x2, y1);
        ctx.stroke();
    }
}
