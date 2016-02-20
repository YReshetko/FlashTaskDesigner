package source.BlockOfTask.Task.TaskObjects.PictureTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseTan;
	import flash.events.Event;
	import flash.display.Bitmap;
	import source.utils.GetBitmap;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	
	public class BasePicture extends BaseTan{
		public static var GET_SETTINGS:String = 'onGetSettings';
		
		private var pictureName:String;
		
		private var colorTan:Sprite = new Sprite();
		private var blackTan:Sprite = new Sprite();
		private var colorCont:Sprite;
		private var loaded:Boolean = false;
		public function BasePicture(colorContainer:Sprite, blackContainer:Sprite) {
			super();
			colorCont = colorContainer
			colorContainer.addChild(colorTan);
			blackContainer.addChild(blackTan);
			super.tanColor = colorTan;
			super.tanBlack = blackTan;
			super.dragEvent = true;
		}
		override public function set name(value:String):void{
			pictureName = value;
		}
		override public function get name():String{
			return pictureName;
		}
		public function set image(value:ByteArray):void{
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, IMAGE_LOAD_COMPLATE);
			loader.loadBytes(value, context);
		}
		override public function get stand():Boolean{
			if(!loaded) return false;
			trace(this + ': STAND = ' + super.stand);
			return super.stand;
		}
		private function IMAGE_LOAD_COMPLATE(e:Event):void{
			loaded = true;
			var value:Bitmap = e.target.content;
			var bBmp:Bitmap = GetBitmap.alphaChenal(value, true);
			var cBmp:Bitmap = GetBitmap.alphaChenal(value);
			colorTan.addChild(cBmp);
			blackTan.addChild(bBmp);
			cBmp.x = -cBmp.width/2;
			cBmp.y = -cBmp.height/2;
			
			bBmp.x = -bBmp.width/2;
			bBmp.y = -bBmp.height/2;
			this.dispatchEvent(new Event(GET_SETTINGS));
		}
		public function colorMouseEnabled():void{
			//trace(this + ': MOUSE ENABLED');
			colorCont.mouseEnabled = false;
		}
	}
	
}
