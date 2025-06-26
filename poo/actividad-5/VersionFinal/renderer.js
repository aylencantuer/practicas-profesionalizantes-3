export class CanvasRenderer {
    constructor(context, canvas) {
        this.ctx = context;
        this.canvas = canvas;
    }

    render(figures) {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        figures.forEach(figure => {
            figure.draw(this.ctx);
        });
    }
}
