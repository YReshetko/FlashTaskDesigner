package source.EnvKonstraktion.PictLibrary {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import source.EnvUtils.EnvDraw.BitmapConverter;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvEvents.Events;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import source.utils.MyMenu;
	import flash.events.ContextMenuEvent;
	import source.EnvLoader.SaveFiles;
	
	
	public class Sample extends Sprite{
		private static const wPict:int = 30;
		private static const hPict:int = 20;
		
		private static var linkSize:int = 12;
		private static var linkColor:uint = 0x000000;
		private static var linkFont:String = 'Arial';
		
		private var backgroundWidth:Number = 200;
		
		private var pictLabel:String;
		private var pictBitmap:Bitmap;
		private var pictByteArray:ByteArray;
		public function Sample(inLabel:String, inBitmap:Bitmap, inByteArray:ByteArray) {
			super();
			pictLabel = inLabel;
			pictBitmap = inBitmap;
			pictByteArray = inByteArray;
			initObject();
		}
		private function initObject():void{
			initLabel(pictLabel);
			var labelBmp:Bitmap = getBitmap();
			labelBmp.width = wPict;
			labelBmp.height = hPict;
			super.addChild(labelBmp);
			super.addEventListener(MouseEvent.ROLL_OVER, SUPER_ROLL_OVER);
			super.addEventListener(MouseEvent.ROLL_OUT, SUPER_ROLL_OUT);
			super.addEventListener(MouseEvent.MOUSE_DOWN, SUPER_MOUSE_DOWN);
			new MyMenu(super, ['Сохранить'], [SavePicture]);
		}
		public function getLabel():String{
			return pictLabel;
		}
		public function getBitmap():Bitmap{
			var outBitmap:Bitmap = BitmapConverter.copyBitmap(pictBitmap);
			return outBitmap;
		}
		public function getByteArray():ByteArray{
			return pictByteArray;
		}
		
		
		private function initLabel(name:String):void{
			var field:TextField = new TextField();
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = linkFont;
			fieldFormat.size = linkSize;
			field.textColor = linkColor;
			fieldFormat.bold = true;
			field.defaultTextFormat = fieldFormat;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.mouseEnabled = false;
			field.text = name;
			super.addChild(field);
			field.x = wPict + 5;
			field.y = (hPict - field.height)/2;
		}
		public function drawBackground(_W:Number):void{
			backgroundWidth = _W;
			Figure.insertRect(super, _W, hPict, 1, 0, 0x000000, 0.3);
		}
		private function SUPER_ROLL_OVER(e:MouseEvent):void{
			Figure.insertRect(super, backgroundWidth, hPict, 1, 0, 0x000000, 0.7);
		}
		private function SUPER_ROLL_OUT(e:MouseEvent):void{
			Figure.insertRect(super, backgroundWidth, hPict, 1, 0, 0x000000, 0.3);
		}
		private function SUPER_MOUSE_DOWN(e:MouseEvent):void{
			Figure.insertRect(super, backgroundWidth, hPict, 1, 0, 0x000000, 1);
			super.dispatchEvent(new Event(Events.SAMPLE_FROM_LIBRARY_MOUSE_DOWN));
		}
		
		
		
		private function SavePicture(event:ContextMenuEvent):void{
			var save:SaveFiles = new SaveFiles();
			save.saveOneFile({'name':pictLabel, 'byteArray':pictByteArray});
		}
	}
	
}
