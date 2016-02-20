package source.Task.PaintSystem {
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import source.utils.CuterPict;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class ImageContainer extends Sprite{
		private var byteArray:ByteArray;
		private var bitmap:Bitmap;
		private var fileName:String;
		private var imgSprite:Sprite = new Sprite();
		public function ImageContainer(inContainer:Sprite) {
			super();
			inContainer.addChild(super);
			super.addChild(imgSprite);
			imgSprite.addEventListener(MouseEvent.MOUSE_DOWN, IMAGE_MOUSE_DOWN);
			imgSprite.addEventListener(MouseEvent.MOUSE_UP, IMAGE_MOUSE_UP);
		}
		public function setImage(value:ByteArray, name:String):void{
			fileName = name;
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_PICTURE_COMPLATE);
			loader.loadBytes(value, context);
		}
		private function LOAD_PICTURE_COMPLATE(e:Event):void{
			if(bitmap!=null){
				imgSprite.removeChild(bitmap);
				imgSprite.x = 0;
				imgSprite.y = 0;
			}
			bitmap =  e.target.content;
			trace(bitmap);
			imgSprite.addChild(bitmap);
		}
		private function IMAGE_MOUSE_DOWN(e:MouseEvent):void{
			imgSprite.startDrag();
		}
		private function IMAGE_MOUSE_UP(e:MouseEvent):void{
			imgSprite.stopDrag();
		}
		
		public function getSampleImage(inArr:Array):Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			var rect:Rectangle;
			var bmp:Bitmap;
			l = inArr.length;
			for(i=0;i<l;i++){
				rect = inArr[i];
				rect.x = rect.x - imgSprite.x;
				rect.y = rect.y - imgSprite.y;
				trace(bitmap);
				bmp = CuterPict.cutSamplePict(bitmap, rect);
				outArr.push([rect, bmp]);
			}
			return outArr;
		}
		
		public function get listSettings():XMLList{
			if(bitmap == null) return null;
			var outXml:XMLList = new XMLList('<IMAGE/>');
			outXml.@name = fileName;
			return outXml;
		}
		public function get copyBitmap():Bitmap{
			if(bitmap == null) return null;
			var bmpData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
			bmpData.draw(bitmap, new Matrix());
			return new Bitmap(bmpData);
		}
		public function get nameBitmap():String{
			return fileName;
		}
		public function clear():void{
			fileName = '';
			if(bitmap!=null){
				imgSprite.removeChild(bitmap);
				imgSprite.x = 0;
				imgSprite.y = 0;
				bitmap = null;
			}
		}
	}
	
}
