package source.Components {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class Label extends TextField{
		
		private static const size:int = 14;
		private static const color:uint = 0x000000;
		private static const bold:Boolean = true;
		private static const font:String = 'Arial';
		
		
		public function Label() {
			super();
			initField();
		}
		private function initField():void{
			var format:TextFormat = new TextFormat();
			format.size = size;
			format.color = color;
			format.bold = bold;
			format.font = font;
			super.defaultTextFormat = format;
			super.autoSize = TextFieldAutoSize.LEFT;
			super.mouseEnabled = false;
		}
		public function set fieldSize(value:Number):void{
			var format:TextFormat = super.getTextFormat();
			format.size = value;
			super.setTextFormat(format);
			super.defaultTextFormat = format;
		}
	}
}
