var Model = function() {
    var precision = 10;
    
    this.points = [
        {x: 50,y: 100},
        {x: 100,y: 50},
        {x: 150,y: 150},
        {x: 80,y: 80},
    ];
        
    this.lines = [];

    this.checkModel = point => {
        for (var i = 0; i < this.points.length; i++) {
            var o = this.points[i];
            if (Math.abs(o.x - point.x) < precision && Math.abs(o.y - point.y) < precision) {
                return false;
            };
        }
        return true;
    }
}