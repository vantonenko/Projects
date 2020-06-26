function* range(start, count) {
    for (var i = start; i < start + count; i++) {
        yield i;
    }
}

function isPrime(n) {
    var maxDivider = Math.trunc(Math.sqrt(n));
    for (var i of range(2, maxDivider)) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}

function* getPrimes(maxN) {
    for (var i of range(0, maxN)) {
        if (isPrime(i)) {
            yield i;
        }
    }
}

function printPrimes(maxN) {
    console.log([...getPrimes(maxN)].join("\t"));
}

printPrimes(1000);