package source.FuncPanel {
	import source.Utilites.SettingPanel;
	import source.Utilites.PazzleEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.Utilites.OnLoader;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class SamplePanel extends SettingPanel{
		private var sprite:Sprite = new Sprite;
		private var ID:int;
		//private var cngPict:changePict;
		private var rmvPict:removePict;
		private var loader:OnLoader;
		public function SamplePanel(inBitmap:BitmapData, ID:int) {
			super();
			this.ID = ID;
			trace(this + " CREATE PANEL");
			var bmp:Bitmap = new Bitmap(inBitmap);
			sprite.addChild(bmp);
			bmp.width = 150;
			bmp.scaleY = bmp.scaleX;
			super.setSprite("КАРТИНКА "+(ID+1).toString(), sprite);
			trace(this + " COMPLATE CREATED");
		}
		public function initButton(){
			//cngPict = new changePict();
			rmvPict = new removePict();
			//sprite.addChild(cngPict);
			sprite.addChild(rmvPict);
			//rmvPict.x = cngPict.width + 10;
			//cngPict.addEventListener(MouseEvent.MOUSE_DOWN, CHANGE_MOUSE_DOWN);
			rmvPict.addEventListener(MouseEvent.MOUSE_DOWN, REMOVE_MOUSE_DOWN);
		}
		private function CHANGE_MOUSE_DOWN(e:MouseEvent){
			loader = new OnLoader();
			loader.addEventListener(PazzleEvent.LOAD_ONE_FILE, LOADER_COMPLATE);
			loader.loadLocalOne("*.png; *.jpg");
		}
		private function LOADER_COMPLATE(e:Event){
			super.dispatchEvent(new Event(PazzleEvent.SAMPLE_CHANGED));
		}
		private function REMOVE_MOUSE_DOWN(e:MouseEvent){
			super.dispatchEvent(new Event(PazzleEvent.SAMPLE_REMOVE));
		}
		public function getNewData():Object{
			var inObject:Object = loader.getData();
			var outObject:Object = new Object();
			var bmp:BitmapData = new BitmapData(inObject.Data.width, inObject.Data.height);
			bmp.draw(inObject.Data, new Matrix());
			outObject.bitmap = bmp;
			outObject.fileName = inObject.fileName
			outObject.ID = this.ID;
			return outObject;
		}
		public function getID():int{
			return ID;
		}
	}
	
}
