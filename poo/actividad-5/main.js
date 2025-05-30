//main.js

import { GameEngineRenderer } from './model/GameEngineRenderer.js';
import { Rectangle } from './model/Rectangle.js';
import { RectangleController } from './controller/RectangleController.js';


function main()
{
    let canvas = document.createElement('canvas');
    canvas.width = 645;
    canvas.height = 400;
    document.body.appendChild(canvas);

    let renderer = new GameEngineRenderer(canvas);

    let rectangle = new Rectangle(200, 200, 100, 50);
    renderer.addObject('Rectangle1', rectangle);

    // Conectar el controlador al mismo rectángulo
    let controller = new RectangleController(rectangle, renderer, canvas);

        /*Por si desp quiero agregar otro 
        //  renderer.addObject('rectangulo 2', new Rectangle(200,200,180,80));
        // renderer.getObject('rectangulo 2').rotate( Math.PI / 4 );
        */

    setInterval( renderer.render.bind(renderer), 16 );
}
window.onload = main;