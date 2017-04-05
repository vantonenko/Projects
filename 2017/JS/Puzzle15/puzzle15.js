var puzzle15Solver = function() {
    var sideLength = 3;
    var moves = 
        [[-1,0],[0,-1],[1,0],[0,1]].map(v => { 
            return { x: v[0], y: v[1] } 
        });
    
    var stateGoal = (function(){
            var counter = 0, arr = new Array(sideLength * sideLength).fill(0).map(i => counter++);
            return new state(arr);
        })();

    var initialState = stateGoal.shuffle();
    var visitState = {};
    var stateStack = [];

    var getPossibleMovesIterator = function*(state) {
        for (let move of moves) {
            if (!state.isValidMove(move)) continue;
            var nextMove = state.applyMove(move);
            if (visitState[nextMove.hash]) continue;
            yield nextMove;
        }
    }

    var computeIterator = function*() {
        do {
            var state = stateStack.last();
            visitState[state.hash] = true;
            if (state.equals(stateGoal)) yield true;
            
            var possibleMoves = getPossibleMovesIterator(state);
            var nextMove = possibleMoves.next();
            if (nextMove.value) {
                stateStack.push(nextMove.value);
            } else {
                stateStack.pop();
            }
            yield false;
        } while (stateStack.length > 0);
    }

    var visualizeState = function(state, selector = "div#solved") {
        var element = document.querySelector(selector);
        if (!state) {
            element.style.color = "red";
            return;
        }

        var printState = state.toString();
        element.innerHTML = 
            `${printState.replace(/\/n/g, "<br>")}<br><br>stackSize:${stateStack.length}`;
    }

    this.compute = function() {
        stateStack.push(initialState);
        visualizeState(initialState, "div#initial");

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