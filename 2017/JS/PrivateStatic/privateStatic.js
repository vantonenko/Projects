// Put below code into the browser console
var MyClass = (function() {
    var privateStatic = "private static initial";
    return function() {
        var privateVar = "private initial";
        this.publicVar = "public initial";
        this.getPrivateStatic = () => privateStatic;
        this.setPrivateStatic = val => { privateStatic = val };
    } 
})();

MyClass.prototype.publicStaticVar = "public static initial";

var x = new MyClass(); y = new MyClass();

// both outputs "private static initial"
console.log(x.getPrivateStatic());
console.log(y.getPrivateStatic());

x.setPrivateStatic("private static changed");
console.log(y.getPrivateStatic()); // outputs "private static changed"