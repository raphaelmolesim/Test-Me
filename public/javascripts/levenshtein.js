StringEvaluator = Class.create({

	evaluate : function(evaluated, expected) {
		var distance = this.getLevenshteinDistance(evaluated.toLowerCase(), expected.toLowerCase());
		var percentageWrite = 1 - (distance/evaluated.length);
		return Math.floor( (percentageWrite > 0 ? percentageWrite : 0)  * 100 );
	},

	getLevenshteinDistance : function(evaluated, expected) {
	    var size1 = evaluated.length;
	    var size2 = expected.length;
			var matrix = this.newMatrix(size1);
	    
	    for (var i = 0; i <= size1; i++)
	    	matrix[i][0] = i;

	    for (var j = 0; j <= size2; j++)
	    	matrix[0][j] = j;

	    for (var j = 1; j <= size2; j++)
	    	for (var i = 1; i <= size1; i++)
	    		if (evaluated[i - 1] == expected[j - 1])
	    			matrix[i][j] = matrix[i - 1][j - 1];
	   			else
				    matrix[i][j] = this.minimum(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + 1);

	    return matrix[size1][size2];
	},

  newMatrix : function(size) {
		var matrix = new Array();
    for (var i = 0; i <= size; i++)
    	matrix[i] = new Array();
		return matrix;
	},

	minimum : function(value1, value2, value3) {
    if (value1 < value2 && value1 < value3) return value1;
    if (value2 < value1 && value2 < value3) return value2;
    if (value3 < value1 && value3 < value2) return value3;
    if (value1 == value2) return value1;
    if (value1 == value3) return value1;
    if (value3 == value2) return value2;
    alert(value1 + "/" + value2 + "/" + value3);
	},
});