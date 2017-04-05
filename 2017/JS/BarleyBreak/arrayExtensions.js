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

Array.prototype.exchange = function(index1, index2) {
    var newArr = this.slice();
    
    var temp = newArr[index1];
    newArr[index1] = newArr[index2];
    newArr[index2] = temp;

    return newArr;
}

Array.prototype.fillWithIterator = function(iterator) {
    var arr = this;
    for (let o of iterator) {
        arr.push(o);
    }
    return arr;
}

Array.prototype.splitIterator = function*(chunkSize) {
    var cursor = 0;
    while (cursor < this.length) {
        var line = this.slice(cursor, cursor + chunkSize);
        cursor += line.length;
        yield line;
    }
}

Array.prototype.splitOnChunks = function(chunkSize) {
    return [].fillWithIterator(this.splitIterator(chunkSize));
}

Array.prototype.last = function() {
    if (this.length == 0) return undefined;
    return this.slice(-1)[0];
}