//RectangleController.js

export class RectangleController {
    constructor(rectangle, renderer, canvas){
    this.rectangle=rectangle;
    this.renderer = renderer;
    this.canvas=canvas;

    window.addEventListener('keydown', (event) => this.KeyHandler(event));
    }

    KeyHandler(event) {
        switch (event.key) {

            case "ArrowUp" :
                this.rectangle.moveForward(this.canvas.width, this.canvas.height);  // modificado
                break;
            case "ArrowDown":
                this.rectangle.moveBackward(this.canvas.width, this.canvas.height); // modificado
                break;

            case "ArrowLeft":
                this.rectangle.rotate(-0.1); // rotación antihoraria
                break;
            case "ArrowRight":
                this.rectangle.rotate(0.1);  // rotación horaria
                break;
        } 

        this.renderer.render(); // Actualiza canvas cvez que se presiona
   
        }

}