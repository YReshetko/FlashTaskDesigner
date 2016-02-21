package source.Designer {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Bitmap;
	
	public class DesModel extends EventDispatcher{
		private static var wScene:int = 730;
		private static var hScene:int = 496;
		
		private var quantiColumn:int = 2;
		private var quantiLine:int = 2;
		private var picArr:Array = new Array([],[],[],[],[],[]);
		public function DesModel() {
			super();
		}
		public function getModel():Array{
			return [quantiColumn, quantiLine, picArr];
		}
		public function getScene():Array{
			return [wScene, hScene];
		}
		public function setPict(ID:int, namePic:String, bData:Bitmap){
			if(picArr[ID]!=null && picArr[ID].length!=0){
				if(namePic == picArr[ID][0])return;
			}
			picArr[ID][0] = namePic;
			picArr[ID][1] = bData;
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		public function setColumnLine(numCol:int, numLin:int){
			quantiColumn = numCol;
			quantiLine = numLin;
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}
