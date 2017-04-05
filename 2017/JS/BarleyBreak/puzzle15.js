var puzzle15Solver = function() {
    var sideLength = 3;
    var moves = 
        [[-1,0],[0,-1],[1,0],[0,1]].map(v => { 
            return { vector: { x: v[0], y: v[1] } } 
        });
    
    var stateGoal = (function(){
            var counter = 0, state = new Array(sideLength * sideLength).fill(0).map(i => counter++);
            return state;
        })();

    var getStateHash = function(state) {
        return state.join(" ");
    }

    var stateGoalHash = getStateHash(stateGoal);

    var initialState = stateGoal.shuffle();
    var visitState = {};
    var stateStack = [];

    var getZeroItemPosition = function(state) {
        var zeroItemIndex = state.indexOf(0);
        return {
            index: zeroItemIndex,
            x: zeroItemIndex % sideLength,
            y: Math.floor(zeroItemIndex / sideLength)
        };
    }

    var isValidMove = function(itemPosition, move) {
        var newX = itemPosition.x + move.vector.x;
        var newY = itemPosition.y + move.vector.y;
        var isValidMove = newX >= 0 && newX < sideLength &&
            newY >= 0 && newY < sideLength;
        return isValidMove;
    }

    var applyMove = function(state, itemPosition, move) {
        var newX = itemPosition.x + move.vector.x;
        var newY = itemPosition.y + move.vector.y;
        var newIndex = newY * sideLength + newX;
        return state.exchange(newIndex, itemPosition.index);
    }

    var getPrintState = function(state) {
        var width = Math.floor(Math.sqrt(state.length));
        return state
            .splitOnChunks(width)
            .map(chunk => chunk
                .map(e => `${e == 0 ? "_" : e}${(e > 9 ? "_" : "__")}`)
                .join(""))
            .join("/n");
    }

    var computeIterator = function*() {
        do {
            var state = stateStack.last();
            var stateHash = getStateHash(state);
            visitState[stateHash] = true;
            if (stateHash == stateGoalHash) yield true;
            var zeroItemPosition = getZeroItemPosition(state);
            var possibleMoves = 
                moves
                    .filter(m => isValidMove(zeroItemPosition, m))
                    .map(m => applyMove(state, zeroItemPosition, m))
                    .filter(s => !visitState[getStateHash(s)]);
            
            if (possibleMoves.length == 0) {
                stateStack.pop();
            } else {
                stateStack.push(possibleMoves[0]);
            }
            yield false;
        } while (stateStack.length > 0);
    }

    var visualizeState = function(state) {
        if (!state) return;

        var printState = getPrintState(state);
        document.querySelector("div").innerHTML = 
            `${printState.replace(/\/n/g, "<br>")}<br><br>stackSize:${stateStack.length}`;
    }

    this.compute = function() {
        stateStack.push(initialState);

        var iterator = computeIterator();

        var interval = setInterval(() => {
            visualizeState(stateStack.last());
            for (let i of new Array(10 * 1000)) {
                var iteration = iterator.next();
                if (iteration.value || iteration.done) {
                    visualizeState(stateStack.last());
                    clearInterval(interval);
                    break;
                }
            }
        }, 0);
    }
}