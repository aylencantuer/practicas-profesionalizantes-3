// Clase base abstracta
class Figura {
    constructor(id, x, y, color) {
        if (this.constructor === Figura) {
            throw new Error("No se puede instanciar la clase abstracta Figura.");
        }
        this.id = id;
        this.x = x;
        this.y = y;
        this.color = color;
    }

    move(dx, dy) {
        this.x += dx;
        this.y += dy;
    }

    draw(ctx) {
        throw new Error("El método 'draw' debe ser implementado por las subclases.");
    }
}

export class Rectangulo extends Figura {
    constructor(id, x, y, width, height, color) {
        super(id, x, y, color);
        this.width = width;
        this.height = height;
        this.type = 'R';
    }

    draw(ctx) {
        ctx.save();
        ctx.fillStyle = this.color;
        ctx.fillRect(this.x - this.width / 2, this.y - this.height / 2, this.width, this.height);
        ctx.restore();
    }
}

export class Circulo extends Figura {
    constructor(id, x, y, radius, color) {
        super(id, x, y, color);
        this.radius = radius;
        this.type = 'C';
    }

    draw(ctx) {
        ctx.save();
        ctx.beginPath();
        ctx.fillStyle = this.color;
        ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
        ctx.fill();
        ctx.closePath();
        ctx.restore();
    }
}

export class TrianguloEquilatero extends Figura {
    constructor(id, x, y, side, color) {
        super(id, x, y, color);
        this.side = side;
        this.type = 'T';
    }

    draw(ctx) {
        const height = (Math.sqrt(3) / 2) * this.side;
        ctx.save();
        ctx.beginPath();
        ctx.fillStyle = this.color;
        ctx.translate(this.x, this.y);
        ctx.moveTo(0, -height * 2 / 3);
        ctx.lineTo(-this.side / 2, height * 1 / 3);
        ctx.lineTo(this.side / 2, height * 1 / 3);
        ctx.closePath();
        ctx.fill();
        ctx.restore();
    }
}