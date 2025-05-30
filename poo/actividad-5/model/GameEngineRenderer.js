//GameEngineRenderer.js

export class GameEngineRenderer{
    constructor(canvasInstance){
        this.canvas = canvasInstance;
        this.context=this.canvas.getContext('2d');
        this.objects = new Map();
    }

    addObject (id,object){
        this.objects.set(id,object);
    }

    getObject(id){
        return this.objects.get(id);
    }

    render(){
        //Limpieza
        this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);

        //Dibujado
        for (const item of this.objects.values() )
        {
            item.draw(this.context);
        }
    }
}

function clearCanvas()
{
    context.clearRect(0, 0, canvas.width, canvas.height);
}