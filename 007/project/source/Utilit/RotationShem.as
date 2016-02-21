package source.Utilit {
	
	public class RotationShem {
		private static var leftRotation		:Array = new Array([0, 0],
															   [1, 1],
															   [2, 4],
															   [3, 5],
															   [4, 3],
															   [5, 2]);
		private static var rightRotation	:Array = new Array([0, 0],
															   [1, 1],
															   [2, 5],
															   [3, 4],
															   [4, 2],
															   [5, 3]);
		private static var topRotation		:Array = new Array([0, 3],
															   [1, 2],
															   [2, 0],
															   [3, 1],
															   [4, 4],
															   [5, 5]);
		private static var bottomRotation	:Array = new Array([0, 2],
															   [1, 3],
															   [2, 1],
															   [3, 0],
															   [4, 4],
															   [5, 5]);
		public static function transPosition(Arr:Array, type:String):Array{
			var outArray:Array = new Array('','','','','','');
			var currentRotation:Array;
			var i:int;
			switch(type){
				case 'left':
					currentRotation = leftRotation;
				break;
				case 'right':
					currentRotation = rightRotation;
				break;
				case 'top':
					currentRotation = topRotation;
				break;
				case 'bottom':
					currentRotation = bottomRotation;
				break;
			}
			for(i=0;i<currentRotation.length;i++){
				outArray[currentRotation[i][1]] = Arr[currentRotation[i][0]];
			}
			return outArray;
		}
	}
	
}
