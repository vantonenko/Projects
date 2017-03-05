var Vector = new(function() {
    this.getAngle = (p0, p1, p2) => {
        var x1 = p1.x - p0.x;
        var y1 = p1.y - p0.y;
        var x2 = p2.x - p1.x;
        var y2 = p2.y - p1.y;

        var dot = x1*x2 + y1*y2;  
        var det = x1*y2 - y1*x2;             
        var angle = Math.atan2(det, dot);

        return angle;
    }
});