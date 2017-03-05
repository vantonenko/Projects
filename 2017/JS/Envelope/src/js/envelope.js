var Envelope = new (function() {
    var getStartPoint = points => {
        var maxX = 0;
        var foundPoint = points[0];
        
        points.forEach(p => {
            if (p.x > maxX) {
                maxX = p.x;
                foundPoint = p;
            }
        });
        return foundPoint;
    }

    var getNextPoint = (points, currentPoint, prevPoint) => {
        var minAngle = Infinity;
        var nextPoint = null;

        points.forEach(p => {
            if (p == currentPoint || p.inLoop) return;

            var angle = Vector.getAngle(prevPoint, currentPoint, p);
            if (angle < minAngle) {
                minAngle = angle;
                nextPoint = p;
            }
        });

        nextPoint.inLoop = true;
        return nextPoint;
    }

    var calculateLoop = points => {
        var loop = [];

        points.forEach(p => p.inLoop = false);

        var startPoint = getStartPoint(points);
        var currentPoint = startPoint;
        var prevPoint = {x:startPoint.x + 1, y:startPoint.y};

        do {            
            var nextPoint = getNextPoint(points, currentPoint, prevPoint);
            loop.push(nextPoint);
            
            prevPoint = currentPoint;
            currentPoint = nextPoint;           
        } while (currentPoint != startPoint);

        return loop;
    }

    var pointsToLines = points => {
        var lines = [];

        for (var i = 0; i < points.length; i++) {
            lines.push({
                point0: points[i],
                point1: points[(i + 1) % points.length]
            })
        }

        return lines;
    }

    this.calculateLinesLoop = points => {
        var points = calculateLoop(points);

        return pointsToLines(points);
    }
});