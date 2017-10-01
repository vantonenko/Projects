function Puzzle15Solver() {
    var sideLength = 3;

    var visitState = {};
    var stateGoal = new State(sideLength);

    this.initialState = stateGoal.shuffle();
    this.queue = new Queue();

    this.currentStateNode = new StateNode(this.initialState);

    var getNextStates = function*(state) {
        for (let move of State.moves) {
            if (state.isMoveExceedBoundary(move)) continue;
            var nextMove = state.applyMove(move);
            if (visitState[nextMove.hash]) continue;
            yield nextMove;
        }
    }

    this.computeIterator = function*() {
        this.queue.enqueue(this.currentStateNode);

        while (this.queue.length() > 0) {
            this.currentStateNode = this.queue.dequeue();
            var currentState = this.currentStateNode.state;
            
            visitState[currentState.hash] = true;
            yield currentState.equals(stateGoal);
            
            var possibleStates = getNextStates(currentState);
            for (var state of possibleStates) {
                var nextStateNode = new StateNode(state, this.currentStateNode);
                this.queue.enqueue(nextStateNode);
            }

        } while (this.queue.length > 0);
    }
}