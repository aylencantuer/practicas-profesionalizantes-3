export class ApplicationController {
    constructor(view, model, factory, renderer) {
        this.view = view;
        this.model = model;
        this.factory = factory;
        this.renderer = renderer;
    }

    init() {
        this.model.addEventListener('modelChanged', () => this.onModelChanged());
        this.view.addEventListener('createRequest', (e) => this.handleCreateRequest(e.detail.type));
        this.view.addEventListener('figureSelected', (e) => this.model.setSelectedFigure(e.detail.id));
        window.addEventListener('keydown', (e) => this.handleKeyDown(e));
        
        this.onModelChanged();
    }

    onModelChanged() {
        this.renderer.render(this.model.figures);
        this.view.update(this.model.figures, this.model.selectedFigureId);
    }

    handleCreateRequest(type) {
        const color = this.view.getColor();
        const newFigure = this.factory.createFigure(type, color);

        if (newFigure) {
            this.model.addFigure(newFigure);
            this.model.setSelectedFigure(newFigure.id);
        }
    }

    handleKeyDown(event) {
        if (!this.model.getSelectedFigure()) return;

        const moveAmount = 4;
        let dx = 0, dy = 0;

        switch (event.key) {
            case 'ArrowUp': dy = -moveAmount; break;
            case 'ArrowDown': dy = moveAmount; break;
            case 'ArrowLeft': dx = -moveAmount; break;
            case 'ArrowRight': dx = moveAmount; break;
            default: return;
        }
        
        event.preventDefault();//por el scroll
        this.model.moveSelectedFigure(dx, dy);
    }
}