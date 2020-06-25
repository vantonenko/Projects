var merge = function(left, right) {
    var merged = [];
    var iLeft = 0;
    var iRight = 0;
    while (iLeft < left.length || iRight < right.length) {
        merged.push(iLeft < left.length && iRight < right.length && left[iLeft] < right[iRight] || iRight >= right.length ? left[iLeft++] : right[iRight++]);
    }
    return merged;
}

var sort = function(input) {
    switch (input.length) {
        case 0:
        case 1:
            return input;
        case 2:
            return input[0] < input [1] ? [input[0], input[1]] : [input[1], input[0]];
        default:
            var median = Math.trunc(input.length / 2);
            var left = sort(input.slice(0, median));
            var right = sort(input.slice(median));
            return merge(left, right);
    }
}

var iterations = 100;
var maxLength = 50;
var maxValue = 30;

var randomInteger = function(minValue, maxValue) {
    return minValue + Math.round((maxValue - minValue)*Math.random());
}

for (var i in new Array(iterations).fill()) {
    var length = randomInteger(0, maxLength);
    var input = new Array(length).fill().map(o => randomInteger(0, maxValue));
    console.log(sort(input));
}