package source.Designer.Viewer3D {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Model3D extends EventDispatcher{
		private var bmpArr:Array;
		private var numCol:int;
		private var numLin:int
		public function Model3D() {
			super();
		}
		public function setParametrs(arr:Array, numCol:int, numLin:int){
			this.numCol = numCol;
			this.numLin = numLin;
			this.bmpArr = arr;
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		public function getParametres():Array{
			return [numCol, numLin, bmpArr];
		}
	}
	
}
