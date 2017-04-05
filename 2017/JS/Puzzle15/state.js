function State(stateArr) {
    var _state = stateArr;
    this.hash = _state.join(" ");
    this.sideLength = Math.floor(Math.sqrt(_state.length));

    var getZeroItem = function() {
        var zeroItemIndex = _state.indexOf(0);
        return {
            index: zeroItemIndex,
            x: zeroItemIndex % this.sideLength,
            y: Math.floor(zeroItemIndex / this.sideLength)
        };
    }

    this.zeroItem = getZeroItem.apply(this);

    this.toString = function() {
        return _state
            .splitOnChunks(this.sideLength)
            .map(chunk => chunk
                .map(e => `${e == 0 ? "_" : e}${(e > 9 ? "" : "_")}`)
                .join("|"))
            .join("/n");
    }

    this.isValidMove = function(move) {
        var newX = this.zeroItem.x + move.x;
        var newY = this.zeroItem.y + move.y;
        var isValidMove = newX >= 0 && newX < this.sideLength &&
            newY >= 0 && newY < this.sideLength;
        return isValidMove;
    }

    this.applyMove = function(move) {
        var newX = this.zeroItem.x + move.x;
        var newY = this.zeroItem.y + move.y;
        var newIndex = newY * this.sideLength + newX;
        return new State(_state.exchange(newIndex, this.zeroItem.index));
    }

    this.equals = function(state) {
        return state.hash == this.hash;
    }

    this.shuffle = function() {
        return new State(_state.shuffle());
    }
}