var barleyBreakSolver = function() {
    var sideLength = 4;

    var getStateHash = function(state) {
        return state.join(" ");
    }

    var getStateGoal = function() {
        var counter = 0, state = new Array(sideLength * sideLength).fill(0).map(i => counter++);
        return state;
    }

    var getMoves = function() {
        var directions = ["left", "up", "right", "down"];
        var vectors = [[-1,0],[0,-1],[1,0],[0,1]];

        var i = 0;
        return directions.map(direction => { 
            var vector = vectors[i++];
            return {
                direction: direction,
                vector: {
                    x: vector[0],
                    y: vector[1]
                }
            };
        });
    }

    var stateGoal = getStateGoal();
    var stateGoalHash = getStateHash(stateGoal);

    var initialState = stateGoal.shuffle();
    var visitState = {};
    var moves = getMoves();
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
                .map(e => `${e}${(e > 9 ? "_" : "__")}`)
                .join(""))
            .join("/n");
    }

    var computeInerator = function*() {
        do {
            var state = stateStack.pop();
            var stateHash = getStateHash(state);
            
            if (stateHash == stateGoalHash) yield true;
            if (visitState[stateHash]) {
                yield false;
                continue;
            }
            
            visitState[stateHash] = true;

            var zeroItemPosition = getZeroItemPosition(state);
            var newStates = 
                moves
                    .filter(move => isValidMove(zeroItemPosition, move))
                    .map(move => applyMove(state, zeroItemPosition, move));
            
            stateStack.push.apply(stateStack, newStates);
            yield false;
        
        } while (stateStack.length > 0);
    }

    var visualizeState = function(state) {
        var printState = getPrintState(state);
        document.querySelector("div").innerHTML = 
            `${printState.replace(/\/n/g, "<br>")}<br><br>stackSize:${stateStack.length}`;
    }

    this.compute = function() {
        stateStack.push(initialState);

        var iterator = computeInerator();

        var interval = setInterval(() => {
            visualizeState(stateStack.last());

            for (let i of new Array(10 * 1000)) {
                var iteration = iterator.next();
                if (iteration.value || iteration.done) {
                    clearInterval(interval);
                    break;
                }
            }
        }, 0);
    }
}