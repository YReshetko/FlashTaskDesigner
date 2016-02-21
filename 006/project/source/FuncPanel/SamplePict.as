package source.FuncPanel {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class SamplePict extends Sprite{
		private var ID:String = "";
		private var complate:Array = new Array();
		private var currentH:int;
		private var currentW:int;
		private var imageArr:Array = new Array;
		
		private var currentID:int;
		public function SamplePict(inW:int, inH:int) {
			currentH = inH;
			currentW = inW;
			drawRect();
		}
		private function drawRect(){
			this.graphics.lineStyle(1, 0x000000, 1);
			this.graphics.beginFill(0xDFDFDF, 1);
			this.graphics.drawRect(0,0,currentW,currentH);
			this.graphics.endFill();
		}
		public function setPicture(pictData:BitmapData){
			var pictBitmap:Bitmap = new Bitmap(pictData);
			pictBitmap.width = currentW;
			pictBitmap.height = currentH;
			imageArr.push(pictBitmap);
			this.addChild(pictBitmap);
			currentID = imageArr.length - 1;
		}
		public function initComplate(){
			var i:int;
			for(i=0;i<imageArr.length;i++){
				complate[i] = false;
			}
		}
		public function getID():int{
			return currentID
		}
		public function incID(){
			++currentID;
			if(currentID>imageArr.length - 1){
				currentID = 0;
			}
			this.setChildIndex(imageArr[currentID], this.numChildren - 1);
		}
		public function randomID(){
			currentID = Math.round(Math.random()*(imageArr.length - 1));
			this.setChildIndex(imageArr[currentID], this.numChildren - 1);
		}
		public function setComplate(f:Boolean, ID:int){
			complate[ID] = f;
			//trace(this + " INSERT PARAMETRES ID = " + ID + " FLAG = " + f + " RESULT = " + complate[ID]);
		}
		public function getComplate():Boolean{
			var i:int;
			var flag:Boolean = true;
			for(i=0;i<complate.length;i++){
				//trace(this +" Current COMPLATE = " + complate);
				if(!complate[i]){
					flag = false;
					break;
				}
			}
			return flag;
		}
	}
	
}
