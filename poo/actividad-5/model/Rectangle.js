//Rectangle.js

export class Rectangle {
    constructor(x,y,w,h) {
        this.x=x;
        this.y = y;
        this.width = w;
        this.height = h;
        this.angle = 0;
        this.speed = 6; 
    }


    draw(context) {
        context.save();
        context.translate(this.x, this.y);
        context.rotate(this.angle);
        context.fillStyle = 'blue';
        context.fillRect(-this.width / 2, -this.height / 2, this.width, this.height);
        context.restore();
    }

    rotate(radians) {
        this.angle += radians;
    }

    moveForward(canvasWidth, canvasHeight) {
        const nextX = this.x + this.speed * Math.cos(this.angle);
        const nextY = this.y + this.speed * Math.sin(this.angle);

         if (this.isInsideBounds(nextX, nextY, canvasWidth, canvasHeight)) {
            this.x = nextX;
            this.y = nextY;
    }

    }

    moveBackward(canvasWidth, canvasHeight) {
        const nextX = this.x - this.speed * Math.cos(this.angle);
        const nextY = this.y - this.speed * Math.sin(this.angle);

        if (this.isInsideBounds(nextX, nextY, canvasWidth, canvasHeight)) {
            this.x = nextX;
            this.y = nextY;
    }
    }

    isInsideBounds(x, y, canvasWidth, canvasHeight) {
        const halfWidth = this.width / 2;
        const halfHeight = this.height / 2;

        return (
            x - halfWidth >= 0 &&
            x + halfWidth <= canvasWidth &&
            y - halfHeight >= 0 &&
            y + halfHeight <= canvasHeight
        );
    }
}