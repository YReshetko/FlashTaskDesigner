package source.utils {
	
	public class CutNormal {

		public static function getCutNormal(value:Array):Array {
			var inArr:Array = value;
			var outArr:Array = new Array();
			var Ax:Number;
			var Ay:Number;
			var Bx:Number; 
			var By:Number;
			var normalAB:Number;
			var	normalAC:Number;
			var Ex:Number;
			var Ey:Number;
			var outX:Number;
			var outY:Number;
			var i:int; 
			var j:int; 
			var l:int;
			var k:int;
			k = inArr.length;
			for(j=0;j<k;j++){
				outArr[j] = new Array();
				inArr[j].unshift(inArr[j][inArr[j].length-2]);
				l = inArr[j].length;
				for(i=1;i<l-1;i++){
					Ax = inArr[j][i-1][0] - inArr[j][i][0];
					Ay = inArr[j][i-1][1] - inArr[j][i][1];
					
					Bx = inArr[j][i+1][0] - inArr[j][i][0];
					By = inArr[j][i+1][1] - inArr[j][i][1];
					
					normalAB = Math.sqrt(Ax*Ax + Ay*Ay);
					normalAC = Math.sqrt(Bx*Bx + By*By);
					Ax = Ax/normalAB;
					Ay = Ay/normalAB;
					
					Bx = Bx/normalAC;
					By = By/normalAC;
					
					Ex = 5*(Ax+Bx);
					Ey = 5*(Ay+By);
					
					outX = inArr[j][i][0]+Ex;
					outY = inArr[j][i][1]+Ey;
					
					outArr[j].push([outX, outY]);
				}
			}
			return outArr;
		}

	}
	
}
