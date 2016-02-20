package source.utils.ColorPicker {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	import source.DesignerMain;
	import flash.display.InteractiveObject;
	
	public class TextPicker extends Sprite{
		private var field:TextField;
		private var rect:Sprite;
		public function TextPicker() {
			super();
			initField();
			initRect();
		}
		private function initField():void{
			field = new TextField();
			var format:TextFormat = new TextFormat();
			format.align = 'center';
			format.bold = true;
			format.size = '14';
			field.defaultTextFormat = format;
			field.restrict = '0123456789abcdef';
			field.maxChars = 6;
			field.width = 60;
			field.height = 20;
			field.border = true;
			field.background = true;
			field.type = TextFieldType.INPUT;
			field.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			//field.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			super.addChild(field);
			field.x = 40;
		}
		private function FIELD_TEXT_INPUT(e:TextEvent):void{
			FIELD_KEY_DOWN();
		}
		private function FIELD_KEY_DOWN(e:KeyboardEvent = null):void{
			if(e.keyCode == Keyboard.CONTROL || e.keyCode == Keyboard.SHIFT || e.keyCode == Keyboard.ALTERNATE) return;
			var timer:Timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			timer.start();
		}
		private function TIMER_COMPLATE(e:TimerEvent=null):void{
			super.dispatchEvent(new Event(ColorPicker.COLOR_CHANGE));
			drawRect(color);
		}
		private function initRect():void{
			rect = new Sprite();
			super.addChild(rect);
		}
		private function drawRect(inColor:uint):void{
			rect.graphics.clear();
			rect.graphics.lineStyle(0.1, 0x000000, 1);
			rect.graphics.beginFill(inColor, 1);
			rect.graphics.drawRect(0, 0, 30, 20);
			rect.graphics.endFill();
		}
		public function set color(value:uint):void{
			field.text = value.toString(16);
			drawRect(value);
		}
		public function get color():uint{
			return parseInt(field.text, 16);
		}
	}
	
}
