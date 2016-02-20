package source.EnvKonstraktion.ImageDataBase {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class FileImage extends Sprite{
		public static var FILE_SELECT:String = 'onFileSelect';
		
		private var fImage:fileImage = new fileImage();
		private var lImage:TextField = new TextField();
		
		private var activSprite:Sprite = new Sprite()
		
		private var ID:String;
		
		private var fileName:String;
		public function FileImage(inXML:XML) {
			super();
			fileName = inXML.@name;
			initLabel(fileName.substring(0, fileName.lastIndexOf('.')));
			ID = inXML.@ID;
			initHandler();
		}
		private function initLabel(name:String):void{
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.size = 14;
			lImage.defaultTextFormat = format;
			lImage.autoSize = TextFieldAutoSize.LEFT;
			lImage.mouseEnabled = false;
			super.addChild(fImage);
			super.addChild(lImage);
			lImage.x = fImage.width;
			lImage.text = name;
			Figure.insertRect(activSprite, super.width, super.height);
			activSprite.alpha = 0;
			super.addChild(activSprite);
		}
		private function initHandler():void{
			activSprite.addEventListener(MouseEvent.MOUSE_DOWN, FILE_MOUSE_DOWN);
		}
		private function FILE_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(FileImage.FILE_SELECT));
		}
		public function get path():String{
			return fileName;
		}
		public function get bdName():String{
			return 'ID_DB_' + ID;
		}
	}
	
}
