package source.Counter {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.LineScaleMode;
	
	public class OnePoint extends Sprite{
		public static var STATUS_SELECT:int = 0;
		public static var STATUS_FAILD:int = 1;
		public static var STATUS_SUCCESS:int = 2;
		public static var STATUS_DEFAULT:int = 3;
		
		public static var NORMAL_TYPE:int = 4;
		public static var IMAGINARY_TYPE:int = 5;
		
		private static const selectColor:uint = 0xFFFF00;
		private static const faildColor:uint = 0xFF0000;
		private static const successColor:uint = 0x0000FF;
		private static const defaultColor:uint = 0x666666;
		
		private var field:TextField = new TextField();
		private var radius:Number = 9;
		private var currentColor:uint;
		private var numberTask:int;
		public function OnePoint(value:String, color:int, type:int = 4) {
			super();
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.size = 13;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.defaultTextFormat = format;
			numberTask = parseInt(value);
			if(type == IMAGINARY_TYPE){
				field.text = 'M';
			}else{
				field.text = value;
			}
			super.addChild(field);
			field.mouseEnabled = false;
			field.x = -field.width/2;
			field.y = -field.height/2;
			status = color;
		}
		public function set status(value:int):void{
			switch(value){
				case STATUS_SELECT:
					currentColor = selectColor;
				break;
				case STATUS_FAILD:
					currentColor = faildColor;
				break;
				case STATUS_SUCCESS:
					currentColor = successColor;
				break;
				case STATUS_DEFAULT:
					currentColor = defaultColor;
				break;
			}
			drawPoint();
		}
		private function drawPoint():void{
			super.graphics.clear();
			super.graphics.lineStyle(0.1, 0, 1, false, LineScaleMode.NONE);
			super.graphics.beginFill(currentColor, 1);
			super.graphics.drawCircle(0,0,radius);
			super.graphics.endFill();
		}
		
		public function get id():int{
			return numberTask;
		}

	}
	
}
