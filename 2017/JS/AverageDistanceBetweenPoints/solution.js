var 
    cnt = 100 * 1000, // amount of random line segments
    N = 3; // amount of dimensions

// calculates the average distance between to points in N-dimension cube
// see more at https://www.youtube.com/watch?v=i4VqXRRXi68
new Array(cnt)
    .fill(0)
    .map(i => Math.sqrt(
        new Array(3)
            .fill(0)
            .map(i => Math.random(1)-Math.random(1))
            .map(d => d * d)
            .reduce((sum, val) => sum + val)))
    .reduce((sum, value) => sum + value, 0)/cnt;