function rand(start, max) {
    return start + Math.trunc(Math.random() * (max - start));
}

function arrange(input, base) {
    var left = [];
    var center = [];
    var right = [];

    for (var i of input) {
        (i < base 
            ? left 
            : i == base 
                ? center
                : right).push(i);
    }

    return { left, center, right };
}

function sort(input) {
    switch (input.length) {
        case 0:
        case 1:
            return input;
        case 2:
            var [a, b] = input;
            return a < b ? [a, b] : [b, a];
        default:
            var base = input[rand(0, input.length)];
            var { left, center, right } = arrange(input, base);
            return [...sort(left), ...center, ...sort(right)];
    }
}

var iterations = 1000;
var maxLength = 50;
var maxValue = 30;

function* range(start, count) {
    for (var i = start; i < start + count; i++) {
        yield i;
    }
}

for (var i of range(0, iterations)) {
    var length = rand(10, maxLength);
    var input = [...range(0, length)].map(o => rand(0, maxValue));
    console.log(sort(input));
}