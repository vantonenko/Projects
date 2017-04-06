function Puzzle15Solver() {
    var sideLength = 3;
    var moves = 
        [[-1,0],[0,-1],[1,0],[0,1]].map(v => { 
            return { x: v[0], y: v[1] } 
        });

    var visitState = {};
    var stateGoal = new State(sideLength);

    this.initialState = stateGoal.shuffle();
    this.stateStack = [];

    var getPossibleMovesIterator = function*(state) {
        for (let move of moves) {
            if (state.isMoveExceedBoundary(move)) continue;
            var nextMove = state.applyMove(move);
            if (visitState[nextMove.hash]) continue;
            yield nextMove;
        }
    }

    this.computeIterator = function*() {
        this.stateStack.push(this.initialState);

        do {
            var state = this.stateStack.last();
            visitState[state.hash] = true;
            if (state.equals(stateGoal)) yield true;
            
            var possibleMoves = getPossibleMovesIterator(state);
            var nextMove = possibleMoves.next();
            if (nextMove.value) {
                this.stateStack.push(nextMove.value);
            } else {
                this.stateStack.pop();
            }
            yield false;
        } while (this.stateStack.length > 0);
    }
}