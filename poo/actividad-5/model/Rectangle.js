//rectangle.js

export class Rectangle {
    constructor(x,y,w,h) {
        this.x=x;
        this.y = y;
        this.width = w;
        this.height = h;
        this.angle = 0;
        this.speed = 6; 
    }

    rotate(value){
        this.angle=value
    }

    draw(ctx) {
        ctx.save();
        ctx.translate(this.x, this.y);
        ctx.rotate(this.angle);
        ctx.fillStyle = 'blue';
        ctx.fillRect(-this.width / 2, -this.height / 2, this.width, this.height);
        ctx.restore();
    }

    rotate(radians) {
        this.angle += radians;
    }

    moveForward() {
        this.x += this.speed * Math.cos(this.angle);
        this.y += this.speed * Math.sin(this.angle);
    }

    moveBackward() {
        this.x -= this.speed * Math.cos(this.angle);
        this.y -= this.speed * Math.sin(this.angle);
    }
}