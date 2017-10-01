function Queue() {
    var arr = [];

    this.enqueue = function(val) {
        arr.unshift(val);
    }

    this.dequeue = function() {
        return arr.pop();
    }

    this.length = function() {
        return arr.length;
    }
}