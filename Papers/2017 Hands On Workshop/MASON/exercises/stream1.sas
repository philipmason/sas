data _null_ ;
	file ?fileref to stream to web browser? ;
	input ;
	put _infile_ ;
	cards4 ;
<!DOCTYPE html>
<html lang="en">
<head>
    <title>dc.js - Number Display Example</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/dc/1.7.5/dc.css"/>
</head>
<body>

<div id="chart-ring-year"></div>
<div id="chart-hist-spend"></div>
<div id="chart-row-spenders"></div>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.14/d3.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/crossfilter/1.3.12/crossfilter.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/dc/1.7.5/dc.min.js"></script>
<script type="text/javascript">
var yearRingChart   = dc.pieChart("#chart-ring-year"),
    spendHistChart  = dc.barChart("#chart-hist-spend"),
    spenderRowChart = dc.rowChart("#chart-row-spenders");
// use static or load via d3.csv("spendData.csv", function(error, spendData) {/* do stuff */});
var spendData = [
    {Name: 'Mr A', Spent: '$40', Year: 2011},
    {Name: 'Mr B', Spent: '$10', Year: 2011},
    {Name: 'Mr C', Spent: '$40', Year: 2011},
    {Name: 'Mr A', Spent: '$70', Year: 2012},
    {Name: 'Mr B', Spent: '$20', Year: 2012},
    {Name: 'Mr B', Spent: '$50', Year: 2013},
    {Name: 'Mr C', Spent: '$30', Year: 2013}
];
// normalize/parse data
spendData.forEach(function(d) {
    d.Spent = d.Spent.match(/\d+/);
});
// set crossfilter
var ndx = crossfilter(spendData),
    yearDim  = ndx.dimension(function(d) {return +d.Year;}),
    spendDim = ndx.dimension(function(d) {return Math.floor(d.Spent/10);}),
    nameDim  = ndx.dimension(function(d) {return d.Name;}),
    spendPerYear = yearDim.group().reduceSum(function(d) {return +d.Spent;}),
    spendPerName = nameDim.group().reduceSum(function(d) {return +d.Spent;}),
    spendHist    = spendDim.group().reduceCount();
yearRingChart
    .width(?number of pixels, e.g. between 100 and 400?).height(?number of pixels, e.g. between 100 and 400?)
    .dimension(yearDim)
    .group(spendPerYear)
    .innerRadius(?number of pixels, e.g. between 10 and 100?);
spendHistChart
    .width(?number of pixels, e.g. between 100 and 400?).height(?number of pixels, e.g. between 100 and 400?)
    .dimension(spendDim)
    .group(spendHist)
    .x(d3.scale.linear().domain([0,10]))
    .elasticY(true);
spendHistChart.xAxis().tickFormat(function(d) {return d*10}); // convert back to base unit
spendHistChart.yAxis().ticks(2);
spenderRowChart
    .width(?number of pixels, e.g. between 100 and 400?).height(?number of pixels, e.g. between 100 and 400?)
    .dimension(nameDim)
    .group(spendPerName)
    .elasticX(true);
dc.renderAll();
</script>

</body>
</html>
;;;;
run ;