var View = function(model) {
    var hideModel = () => {
        var elements = document.querySelectorAll(".point, .line");
        elements.forEach(el => document.body.removeChild(el));
    }

    var showModel = () => {
        model.points.forEach(o => {
            Drawing.drawPoint(o.x, o.y, document.body, "point");
        });

        model.lines.forEach(l => {
            Drawing.drawLine(l.point0.x + 5, l.point0.y + 5, l.point1.x + 5, l.point1.y + 5, document.body, "line");
        });
    }

    this.repaintModel = () => {
        hideModel();
        showModel();
    }
}