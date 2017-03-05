(function() {
    var maxX = function() {
        return 800;
    };
    var maxY = function() {
        return 400;
    }

    var ball = function(initialPositionX, initialPositionY, incrementX, incrementY, color, size) {
        var x = initialPositionX;
        var y = initialPositionY;
        
        var incrementPosition = function() {
            x += incrementX; 
            y += incrementY; 
            
            if (x + size > maxX() || x < 0) incrementX *= -1;
            if (y + size > maxY() || y < 0) incrementY *= -1;
        }                

        var el = document.createElement("div");
        el.classList.add("myDiv");
        el.style.backgroundColor = color;
        el.style.width = size + "px";
        el.style.height = size + "px";
        el.style.borderRadius = size/2 + "px";

        document.body.appendChild(el);

        setInterval(function() { 
            incrementPosition();
            el.style.left = x + "px";
            el.style.top = y + "px";                
        }, 0);
    }

    for (var i = 0; i < 100; i++) {
        new ball(
            i * 50 % (maxX() - 100), 
            i * 30 % (maxY() - 100), 
            1 + Math.sin(i) * 5, 
            1 + Math.sin(i) * 3, 
            "rgb(" + i * 30 % 256 + "," + i * 50 % 256 + "," + i * 70 % 256 + ")",
            10 + (i * i) % 60);
    }
})();