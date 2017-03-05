var Drawing = new (function(){
    this.drawPoint = (x, y, element, cssClass) => {
        var el = document.createElement("div");
        el.classList.add(cssClass);
        el.style.left = x + "px";
        el.style.top = y + "px";
        element.appendChild(el);
    }

    this.drawLineAngle = (x, y, angle, length, element, cssClass) => {
        var el = document.createElement("div");
        el.classList.add(cssClass);

        var styles = ''
                + 'width: ' + length + 'px; '
                + '-moz-transform: rotate(' + angle + 'rad); '
                + '-webkit-transform: rotate(' + angle + 'rad); '
                + '-o-transform: rotate(' + angle + 'rad); '  
                + '-ms-transform: rotate(' + angle + 'rad); '  
                + 'transform: rotate(' + angle + 'rad); '  
                + 'top: ' + y + 'px; '
                + 'left: ' + x + 'px; ';
        
        el.setAttribute('style', styles); 
        element.appendChild(el);
    }

    this.drawLine = (x0, y0, x1, y1, element, cssClass) => {
        var a = x1 - x0;
        var b = y1 - y0;               
        
        var length = Math.sqrt(a * a + b * b);  
        var angle = Math.atan2(b, a);
        
        this.drawLineAngle(x0, y0, angle, length, element, cssClass);
    }
});