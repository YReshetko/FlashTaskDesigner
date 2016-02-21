package source.Player {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class PlayModel extends EventDispatcher{
		public static const BUILD_COMPLATE	:String = "buildComplate";
		public static const NEW_ROTATION	:String = "newRotation";
		
		private static var ethalonPosition:Array = new Array([[0, 0, 0], [2, 2, 2]],
															 [[2, 0, 0], [0, 2, 2]],
															 [[1, 2, 0], [3, 0, 2]],
															 [[1, 0, 2], [3, 2, 0]],
															 [[2, 1, 2], [0, 1, 0], [1, 1, 1], [3, 1, 3]],
															 [[0, 3, 0], [2, 3, 2], [1, 3, 3], [3, 3, 1]]);
		private var currentPosition:Array = new Array;
		private var typeRotation:String;
		private var currentID:int;
		
		private var numColumn:int;
		private var numLine:int;
		private var bitmapArray:Array;
		public function PlayModel() {
			super();
		}
		public function setBuild(numCol:int, numLin:int, arrBitmap:Array){
			numColumn = numCol;
			numLine = numLin;
			bitmapArray = arrBitmap;
			var i,j:int;
			for(i=0;i<numColumn;i++){
				for(j=0; j<numLine; j++){
					currentPosition.push([Math.round(Math.random()*3), Math.round(Math.random()*3), Math.round(Math.random()*3)]);
					//currentPosition.push([3,3,0]);
				}
			}
			super.dispatchEvent(new Event(BUILD_COMPLATE));
		}
		public function getBuild():Array{
			return [numColumn, numLine, bitmapArray, currentPosition];
		}
		public function setStartPosition(arr:Array){
			currentPosition.push(arr);
		}
		public function getCurrentPosition(ID:int):Array{
			return currentPosition[ID];
		}
		public function setRotation(ID:int, typeRotation:String){
			//currentPosition[ID] = arr;
			this.typeRotation = typeRotation;
			this.currentID = ID;
			super.dispatchEvent(new Event(NEW_ROTATION));
		}
		public function setPosition(ID:int, arr:Array){
			currentPosition[ID] = arr;
		}
		public function getModel():Object{
			var outObject:Object = new Object();
			outObject.Ethalon = ethalonPosition;
			outObject.Current = currentPosition;
			return outObject;
		}
		public function getRotation():Object{
			var outObject:Object = new Object();
			outObject.ID = currentID;
			outObject.typeRotation = typeRotation;
			return outObject;
		}
	}
	
}
