export class ApplicationModel extends EventTarget {
    constructor() {
        super();
        this.figures = new Map();
        this.selectedFigureId = null;
    }

    addFigure(figure) {
        if (this.figures.has(figure.id)) {
            return false; 
        }
        this.figures.set(figure.id, figure);
        this.notifyChange();
        return true;
    }

    getFigure(id) {
        return this.figures.get(id);
    }
    
    getSelectedFigure() {
        return this.getFigure(this.selectedFigureId);
    }

    setSelectedFigure(id) {
        if (this.selectedFigureId !== id) {
            this.selectedFigureId = id;
            this.notifyChange();
        }
    }

    moveSelectedFigure(dx, dy) {
        const selectedFigure = this.getSelectedFigure();
        if (selectedFigure) {
            selectedFigure.move(dx, dy);
            this.notifyChange();
        }
    }

    //  método para despachar el evento de cambio.
    notifyChange() {
        this.dispatchEvent(new CustomEvent('modelChanged'));
    }
}
