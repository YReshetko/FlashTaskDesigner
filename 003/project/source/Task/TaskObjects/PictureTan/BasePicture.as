package source.Task.TaskObjects.PictureTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import flash.events.Event;
	import flash.display.Bitmap;
	import source.utils.GetBitmap;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	
	public class BasePicture extends BaseTan{
		public static var GET_XML_SETTINGS:String = 'onGetXmlSettings';
		
		private var pictureName:String;
		
		private var colorTan:Sprite = new Sprite();
		private var blackTan:Sprite = new Sprite();
		private var colorCont:Sprite;
		private var remByteArr:ByteArray;
		public function BasePicture(colorContainer:Sprite, blackContainer:Sprite) {
			super();
			colorCont = colorContainer
			colorContainer.addChild(colorTan);
			blackContainer.addChild(blackTan);
			super.tanColor = colorTan;
			super.tanBlack = blackTan;
			super.dragEvent = true;
		}
		override public function clear():void{
			super.clear();
			remByteArr = null;
			colorTan.parent.removeChild(colorTan);
			blackTan.parent.removeChild(blackTan);
		}
		override public function set name(value:String):void{
			pictureName = value;
		}
		override public function get name():String{
			return pictureName;
		}
		public function get fileName():String{
			return pictureName;
		}
		public function set image(value:ByteArray):void{
			//trace(this + ': in Bitmap = ' + value);
			remByteArr = value;
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_PICTURE_COMPLATE);
			loader.loadBytes(value, context);
		}
		private function LOAD_PICTURE_COMPLATE(e:Event):void{
			//trace(this + ': PICTURE TAN LOAD COMPLATE');
			var value:Bitmap =  e.target.content;
			var bBmp:Bitmap = GetBitmap.alphaChenal(value, true);
			var cBmp:Bitmap = GetBitmap.alphaChenal(value);
			colorTan.addChild(cBmp);
			blackTan.addChild(bBmp);
			cBmp.x = -cBmp.width/2;
			cBmp.y = -cBmp.height/2;
			
			bBmp.x = -bBmp.width/2;
			bBmp.y = -bBmp.height/2;
			this.dispatchEvent(new Event(GET_XML_SETTINGS));
		}
		public function colorMouseEnabled():void{
			//trace(this + ': MOUSE ENABLED');
			colorCont.mouseEnabled = false;
		}
		public function get content():ByteArray{
			trace(this + ': GET CONTENT FROM TAN');
			return remByteArr;
		}
	}
	
}
