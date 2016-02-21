package source.FuncPanel {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class SamplePict extends Sprite{
		private var ID:String = "";
		private var currentR:int = 0;
		private var complate:Boolean = false;
		public function SamplePict(pictData:BitmapData) {
			var pictBitmap:Bitmap = new Bitmap(pictData);
			this.addChild(pictBitmap);
			pictBitmap.x = -pictBitmap.width/2;
			pictBitmap.y = -pictBitmap.height/2;
		}
		public function setID(ID:String){
			this.ID = ID;
		}
		public function getID():String{
			return ID;
		}
		public function setRotation(Rotation:int){
			this.currentR = Rotation;
		}
		public function getRotation():int{
			return currentR;
		}
		public function incRotation(){
			++currentR;
			if(currentR == 16) currentR = 0;
		}
		public function decRotation(){
			--currentR;
			if(currentR == -1) currentR = 15;
		}
		public function setComplate(f:Boolean){
			complate = f;
		}
		public function getComplate():Boolean{
			return complate;
		}
	}
	
}
