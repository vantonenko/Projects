function Queue() {
    var arr = [];

    this.enqueue = function(val) {
        arr.push(val);
    }

    this.dequeue = function() {
        return arr.shift();
    }

    this.length = function() {
        return arr.length;
    }
}