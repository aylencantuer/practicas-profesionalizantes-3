import { ApplicationUI } from './view.js';
import { ApplicationModel } from './model.js';
import { ApplicationController } from './controller.js';
import { FigureFactory } from './factory.js';
import { CanvasRenderer } from './renderer.js';

function main() {
    // Crear la instancia de la UI y añadirla al DOM.
    const view = new ApplicationUI();
    document.body.appendChild(view);

    //Crear las otras instancias necesarias.
    const model = new ApplicationModel();
    const factory = new FigureFactory(model);
    const renderer = new CanvasRenderer(view.getDrawingContext2D(), view.getCanvas());
    
    //controlador inyecta dependencias.
    const controller = new ApplicationController(view, model, factory, renderer);

    // Inicializar el controlador para que configure los listeners
    controller.init();
}
window.onload = main;