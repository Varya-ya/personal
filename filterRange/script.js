let courses = [
    { name: "Courses in England", prices: [0, 100] },
    { name: "Courses in Germany", prices: [500, null] },
    { name: "Courses in Italy", prices: [100, 200] },
    { name: "Courses in Russia", prices: [null, 400] },
    { name: "Courses in China", prices: [50, 250] },
    { name: "Courses in USA", prices: [200, null] },
    { name: "Courses in Kazakhstan", prices: [56, 324] },
    { name: "Courses in France", prices: [null, null] },
];

// Filter by price range function
function filterByPrice(firstValue = null, secondValue = null) {
    if (secondValue == null) {
        return courses.filter(courses => (courses.prices[0] >= firstValue));
    } else {
        return courses.filter(courses => (firstValue <= courses.prices[0] && courses.prices[0] <= secondValue && courses.prices[1] <= secondValue));
    };
}

let requiredRange1 = filterByPrice(null, 200);
let requiredRange2 = filterByPrice(100, 350);
let requiredRange3 = filterByPrice(200, null);

console.log(requiredRange1);
console.log(requiredRange2);
console.log(requiredRange3);

// Sorting courses by price in ascending order
courses.sort(function (a, b) {
    if (a.prices[0] > b.prices[0]) {
        return 1;
    } else if (a.prices[0] < b.prices[0]) {
        return -1;
    } else {
        return a.prices[1] - b.prices[1];
    };
});

console.log(courses);