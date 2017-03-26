Array.prototype.shuffle = function(times) {
    var newArr = this.slice();

    for (let i of new Array(this.length)) {
        var i1 = Math.floor(Math.random() * newArr.length);
        var i2 = Math.floor(Math.random() * newArr.length);
        
        var temp = newArr[i1];
        newArr[i1] = newArr[i2];
        newArr[i2] = temp;
    }

    return newArr;
}

Array.prototype.print = function() {
    function* splitIterator(chunkSize) {
        var cursor = 0;
        while (cursor < this.length) {
            var line = this.slice(cursor, cursor + chunkSize);
            cursor += line.length;
            yield line;
        }    
    }

    var width = Math.floor(Math.sqrt(this.length));
    for (var line of splitIterator.apply(this, [width])) {
        console.log(line.join("\t"));
    }
}

var counter = 0, state = new Array(16).fill(0).map(i => counter++).shuffle();

state.print();