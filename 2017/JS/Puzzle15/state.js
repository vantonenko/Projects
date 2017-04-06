function State(o) {
    var _state = o;
    if (!o.length) {
        var sideLength = o;
        var counter = 0, arr = new Array(sideLength * sideLength).fill(0).map(i => counter++);
        _state = arr;
    }

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

    this.isMoveExceedBoundary = function(move) {
        var newX = this.zeroItem.x + move.x;
        var newY = this.zeroItem.y + move.y;
        var isValidMove = newX >= 0 && newX < this.sideLength &&
            newY >= 0 && newY < this.sideLength;
        return !isValidMove;
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

State.moves = 
    [[-1,0],[0,-1],[1,0],[0,1]].map(v => { 
        return { x: v[0], y: v[1] } 
    });