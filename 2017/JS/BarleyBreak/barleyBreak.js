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

var printState = function(state) {
    function* splitIterator(chunkSize) {
        var cursor = 0;
        while (cursor < state.length) {
            var line = state.slice(cursor, cursor + chunkSize);
            cursor += line.length;
            yield line;
        }    
    }

    var width = Math.floor(Math.sqrt(state.length));
    for (var line of splitIterator(width)) {
        console.log(line.join("\t"));
    }
}

var solve = function() {
    var sideLength = 4;

    var getStateHash = function(state) {
        return state.join(" ");
    }

    var getStateGoal = function() {
        var counter = 0, state = new Array(sideLength * sideLength).fill(0).map(i => counter++);
        return state;
    }

    var stateGoal = getStateGoal();
    var stateGoalHash = getStateHash(stateGoal);

    var initialState = stateGoal.shuffle();
    var visitState = {};
    var moves = [[-1,0],[0,1],[1,0],[0,-1]];
    var stateStack = [];

    var getZeroItemPosition = function(state) {
        var zeroItemIndex = state.indexOf(0);
        return {
            index: zeroItemIndex,
            x: zeroItemIndex % sideLength,
            y: zeroItemIndex / sideLength
        };
    }

    var isValidMove = function(itemPosition, move) {
        var newX = itemPosition.x + move[0];
        var newY = itemPosition.y + move[1];

        var isValidMove = newX >= 0 && newX < sideLength &&
            newY >= 0 && newY < sideLength;

        return isValidMove;
    }

    var applyMove = function(state, itemPosition, move) {
        var newX = itemPosition.x + move[0];
        var newY = itemPosition.y + move[1];

        var newIndex = newY * sideLength + newX;

        return state.exchange(newIndex, itemPosition.index);
    }

    var nextStep = function(state) {
        var stateHash = getStateHash(state);
        
        if (stateHash == stateGoalHash) return true;
        if (visitState[stateHash]) return false;
        
        visitState[stateHash] = true;
        stateStack.push(state);

        var position = getZeroItemPosition(state);
        for (let move of moves.filter(m => isValidMove(position, m))) {
            var newState = applyMove(state, position, move);
            var isSolutionFound = nextStep(newState);
            if (isSolutionFound) return true;
        }

        stateStack.pop();
        return false;
    }

    nextStep(initialState);

    for (let state of stateStack) {
        printState(state);
    }
}

debugger;
solve();