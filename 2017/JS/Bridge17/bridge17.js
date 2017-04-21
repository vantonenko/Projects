var solve = function() {
    var people = [10, 5, 2, 1];
    var timeGoal = 17;    

    var getAllPairs = function(arr) {
        var c = [];
        for (var i = 0; i < people.length; i++) {
            for (var j = i + 1; j < people.length; j++) {
                c.push([arr[i], arr[j]]);
            }
        }
        return c;
    }
    var moves = getAllPairs(people).concat(people.map(e => [e]));    
    
    var state = {
        left: people.slice(),
        right: [],
        isFlashAtLeftSide: true
    }    

    var isValidMove = function(state, participants) {
        var side = state.isFlashAtLeftSide ? state.left : state.right;
        return participants.every(e => side.includes(e));
    }
    
    var stateStack = [];    

    var nextStep = function(state, time) {
        if (time > timeGoal) return false;
        stateStack.push(state);
        
        if (time == timeGoal && state.left.length == 0) {
            return true;
        }        

        for (var i = 0; i < moves.length; i++) {
            var participants = moves[i];
            if (isValidMove(state, participants)) {                
                var isSolutionFound = nextStep({
                    left: state.isFlashAtLeftSide ? 
                        state.left.filter(e => !participants.includes(e)) : 
                        state.left.concat(participants),
                    right: !state.isFlashAtLeftSide ? 
                        state.right.filter(e => !participants.includes(e)) : 
                        state.right.concat(participants),
                    isFlashAtLeftSide: !state.isFlashAtLeftSide
                }, time + Math.max.apply(Math, participants));
                
                if (isSolutionFound) return true;
            }
        }
        stateStack.pop();
        return false;
    }
    nextStep(state, 0);
    return stateStack;
}

var states = solve();

var printState = function(state) {
    var leftSide = state.left.join(", ");
    var rightSide = state.right.join(", ");

    var flashAtLeft = state.isFlashAtLeftSide ? " @" : "";
    var flashAtRight = !state.isFlashAtLeftSide ? "@ " : "";

    return `${leftSide}${flashAtLeft} >===< ${flashAtRight}${rightSide}`;
}

states.map(state => printState(state)).join("\n");