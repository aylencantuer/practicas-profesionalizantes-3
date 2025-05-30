//RectangleController.js

export class RectangleController {
    constructor(rectangle){
    this.rectangle=rectangle;
    this.renderer = renderer;

    window.addEventListener('keydown', (event) => this.KeyHandler(event));
    }

    KeyHandler(event) {
        switch (event.key) {

            case "ArrowUp" :
                this.rectangle.moveForward();
                break;
            case "ArrowDown":
                this.rectangle.moveBackward();
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