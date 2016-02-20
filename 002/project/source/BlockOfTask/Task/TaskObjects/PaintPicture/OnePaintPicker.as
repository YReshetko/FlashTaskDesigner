package source.BlockOfTask.Task.TaskObjects.PaintPicture {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	
	public class OnePaintPicker extends Sprite{
		public static var REMOVE_PICKER:String = 'onRemovePicker';
		
		public static var size:int = 25;
		private static var selectColor:uint = 0xFFCC33;
		private static var deselectColor:uint = 0x000000;
		
		private var borderColor:uint = 0x000000;
		private var currentColor:uint = 0xFFFFFF;
		
		private var isSelect:Boolean = false;
		public function OnePaintPicker(value:uint) {
			super();
			color = value;
			super.addEventListener(KeyboardEvent.KEY_DOWN, KEYBOARD_HANDLER);
		}
		
		private function drawPicker():void{
			super.graphics.clear();
			super.graphics.lineStyle(0.1, borderColor, 1);
			super.graphics.beginFill(currentColor, 1);
			super.graphics.drawRect(0, 0, size, size);
			super.graphics.endFill();
		}
		
		
		public function set select(value:Boolean):void{
			isSelect = value;
			borderColor = (isSelect)?selectColor:deselectColor;
			drawPicker();
		}
		
		private function KEYBOARD_HANDLER(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.DELETE){
				super.dispatchEvent(new Event(REMOVE_PICKER));
			}
		}
		
		public function set color(value:uint):void{
			currentColor = value;
			drawPicker();
		}
		public function get color():uint{
			return currentColor;
		}

	}
	
}
