function Puzzle15Solver() {
    var sideLength = 3;

    var visitState = {};
    var stateGoal = new State(sideLength);

    this.initialState = stateGoal.shuffle();
    this.stateStack = [];

    var getPossibleMoves = function(state) {
        var moves = [];

        for (let move of State.moves) {
            if (state.isMoveExceedBoundary(move)) continue;
            var nextMove = state.applyMove(move);
            if (visitState[nextMove.hash]) continue;
            moves.push(nextMove);
        }

        return moves;
    }

    this.computeFunc = function(state) {
        if (this.stateStack.length > 1000) return false;

        this.stateStack.push(state);
        visitState[state.hash] = true;
        
        if (stateGoal.equals(state)) return true;

        var possibleMoves = getPossibleMoves(state);

        for (var i = 0; i < possibleMoves.length; i++) {
            var result = this.computeFunc(possibleMoves[i]);
            if (result) return true;
        }
        
        this.stateStack.pop();
        return false;
    }

    this.compute = function() {
        this.computeFunc(this.initialState)
    }
}