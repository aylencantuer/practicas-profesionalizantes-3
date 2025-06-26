// El código del Web Component es el mismo que antes, ya que su única
// responsabilidad es mostrar la UI y emitir eventos.
// Esta separación ya era correcta.

export class ApplicationUI extends HTMLElement {
    constructor() {
        super();
        const shadow = this.attachShadow({ mode: 'open' });

        const style = document.createElement('style');
        // El CSS ahora podría estar en un archivo separado e importarse,
        // pero para un Web Component es común tenerlo encapsulado.
        style.textContent = `
          :host {
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            height: 100%;
          }
          .main-container {
            display: flex;
            flex-grow: 1;
            height: calc(100% - 40px);
          }
          .sidebar { width: 200px; background-color: #f0f0f0; padding: 20px; box-sizing: border-box; display: flex; flex-direction: column; gap: 15px; border-right: 1px solid #ccc; }
          .sidebar button { padding: 12px; font-size: 14px; cursor: pointer; border: 1px solid #aaa; border-radius: 5px; background-color: #e9e9e9; }
          .sidebar button:hover { background-color: #dcdcdc; }
          .sidebar input[type="color"] { width: 100%; height: 50px; border: 1px solid #ccc; border-radius: 5px; cursor: pointer; padding: 0; }
          .canvas-container { flex: 1; display: flex; justify-content: center; align-items: center; background-color: #ffffff; }
          canvas { border: 2px solid #333; background-color: #fdfdfd; }
          .table-panel { width: 250px; padding: 20px; box-sizing: border-box; background-color: #f0f0f0; border-left: 1px solid #ccc; overflow-y: auto; }
          table { width: 100%; border-collapse: collapse; }
          th, td { padding: 10px; border: 1px solid #ccc; text-align: left; font-size: 14px; }
          th { background-color: #ddd; }
          tbody tr { cursor: pointer; }
          tbody tr:hover { background-color: #e0e0e0; }
          tbody tr.selected { background-color: #a8d1ff; font-weight: bold; }
          .footer { height: 40px; padding: 0 20px; background-color: #333; color: white; display: flex; align-items: center; font-size: 14px; }
        `;

        const mainContainer = document.createElement('div');
        mainContainer.className = 'main-container';
        const sidebar = document.createElement('div');
        sidebar.className = 'sidebar';
        this.btnRect = document.createElement('button');
        this.btnRect.textContent = 'Crear rectángulo';
        this.btnCircle = document.createElement('button');
        this.btnCircle.textContent = 'Crear círculo';
        this.btnTriangle = document.createElement('button');
        this.btnTriangle.textContent = 'Crear triángulo';
        const colorLabel = document.createElement('label');
        colorLabel.setAttribute('for', 'colorPicker');
        colorLabel.textContent = 'Color:';
        this.colorInput = document.createElement('input');
        this.colorInput.type = 'color';
        this.colorInput.id = 'colorPicker';
        this.colorInput.value = '#8A2BE2';
        sidebar.append(this.btnRect, this.btnCircle, this.btnTriangle, colorLabel, this.colorInput);
        
        const canvasContainer = document.createElement('div');
        canvasContainer.className = 'canvas-container';
        this.canvas = document.createElement('canvas');
        this.canvas.width = 600;
        this.canvas.height = 400;
        canvasContainer.appendChild(this.canvas);

        const tablePanel = document.createElement('div');
        tablePanel.className = 'table-panel';
        tablePanel.innerHTML = `<h3>Figuras creadas</h3>
          <table>
            <thead><tr><th>Tipo</th><th>ID/Nombre</th></tr></thead>
            <tbody></tbody>
          </table>`;

        const footer = document.createElement('div');
        footer.className = 'footer';
        this.activeFigureLabel = document.createElement('span');
        footer.appendChild(this.activeFigureLabel);

        mainContainer.append(sidebar, canvasContainer, tablePanel);
        shadow.append(style, mainContainer, footer);

        this.btnRect.onclick = () => this.dispatchEvent(new CustomEvent('createRequest', { detail: { type: 'rectangle' } }));
        this.btnCircle.onclick = () => this.dispatchEvent(new CustomEvent('createRequest', { detail: { type: 'circle' } }));
        this.btnTriangle.onclick = () => this.dispatchEvent(new CustomEvent('createRequest', { detail: { type: 'triangle' } }));
    }

    getCanvas() { return this.canvas; }
    getDrawingContext2D() { return this.canvas.getContext("2d"); }
    getColor() { return this.colorInput.value; }

    update(figures, selectedFigureId) {
        this.updateTable(figures, selectedFigureId);
        this.updateFooter(selectedFigureId);
    }

    updateTable(figures, selectedFigureId) {
        const tbody = this.shadowRoot.querySelector('tbody');
        tbody.innerHTML = '';
        figures.forEach(figure => {
            const row = tbody.insertRow();
            row.dataset.figureId = figure.id;
            row.className = figure.id === selectedFigureId ? 'selected' : '';
            row.insertCell(0).textContent = figure.type;
            row.insertCell(1).textContent = figure.id;
            row.onclick = () => this.dispatchEvent(new CustomEvent('figureSelected', { detail: { id: figure.id } }));
        });
    }

    updateFooter(figureId) {
        this.activeFigureLabel.textContent = `Figura activa seleccionada actual: ${figureId || 'Ninguna'}`;
    }
}
customElements.define('application-ui', ApplicationUI);
