import { Rectangulo, Circulo, TrianguloEquilatero } from './figures.js';

export class FigureFactory {
    constructor(model) {
        // model para comprobar si un ID ya existe.
        this.model = model;
    }

    createFigure(type, color) {

        const id = this._promptForId();
        if (!id) return null;

        const coords = this._promptForCoordinates();
        if (!coords) return null;
        
        try {
            switch (type) {
                case 'rectangle': {
                    const w = parseFloat(prompt('Ingrese el ancho:'));
                    const h = parseFloat(prompt('Ingrese el alto:'));
                    if (isNaN(w) || isNaN(h) || w <= 0 || h <= 0) throw new Error('Dimensiones inválidas.');
                    return new Rectangulo(id, coords.x, coords.y, w, h, color);
                }
                case 'circle': {
                    const r = parseFloat(prompt('Ingrese el radio:'));
                    if (isNaN(r) || r <= 0) throw new Error('Radio inválido.');
                    return new Circulo(id, coords.x, coords.y, r, color);
                }
                case 'triangle': {
                    const s = parseFloat(prompt('Ingrese el tamaño del lado:'));
                    if (isNaN(s) || s <= 0) throw new Error('Lado inválido.');
                    return new TrianguloEquilatero(id, coords.x, coords.y, s, color);
                }
                default:
                    throw new Error(`Tipo de figura desconocido: ${type}`);
            }
        } catch (error) {
            alert(`Error creando la figura: ${error.message}`);
            return null;
        }
    }

    _promptForId() {
        const id = prompt('Ingrese el ID de la figura:');
        if (!id) return null;
        if (this.model.getFigure(id)) {
            alert(`Error: El ID "${id}" ya existe.`);
            return null;
        }
        return id;
    }

    _promptForCoordinates() {
        const x = parseFloat(prompt('Ingrese la coordenada X:'));
        const y = parseFloat(prompt('Ingrese la coordenada Y:'));
        if (isNaN(x) || isNaN(y)) {
            alert('Error: Las coordenadas deben ser números.');
            return null;
        }
        return { x, y };
    }
}
