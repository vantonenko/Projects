var ViewModel = function (params) {
    var model = new Model();
    var view = new View(model);

    var updateModel = () => {
        model.lines = Envelope.calculateLinesLoop(model.points);
        view.repaintModel();
    }

    window.onclick = e => {
        var point = {
            x: e.clientX - 5,
            y: e.clientY - 5
        };
        
        if (model.checkModel(point)) {
            model.points.push(point);
            updateModel();    
        }
    };

    updateModel();
}