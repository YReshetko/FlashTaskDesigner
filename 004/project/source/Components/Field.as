package source.Components {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.engine.TextElement;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import source.MainEnvelope;
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	
	public class Field extends TextField{
		
		private static const size:int = 14;
		private static const color:uint = 0x000000;
		private static const bold:Boolean = true;
		private static const font:String = 'Arial';
		
		private static const fBorder:Boolean = true;
		private static const fBorderColor:uint = 0x303030;
		
		private static const fBackground:Boolean = true;
		private static const fBackgroundColor:uint = 0xD0D0D0;
		
		private static const wField:Number = 100;
		private static const hField:Number = 18;
		
		
		public function Field() {
			super();
			initField();
			this.handler = true;
		}
		private function initField():void{
			var format:TextFormat = new TextFormat();
			format.bold = bold;
			format.size = size;
			format.font = font;
			format.color = color;
			
			super.width = wField;
			super.height = hField;
			
			super.background = fBackground;
			super.backgroundColor = fBackgroundColor;
			
			super.border = fBorder;
			super.borderColor = fBorderColor;
			
			super.defaultTextFormat = format;
			super.type = TextFieldType.INPUT;
		}
		private function set handler(value:Boolean):void{
			if(value){
				super.addEventListener(TextEvent.TEXT_INPUT, FIELD_INPUT_TEXT);
				super.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
				super.addEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_IN);
				super.addEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			}else{
				super.removeEventListener(TextEvent.TEXT_INPUT, FIELD_INPUT_TEXT);
				super.removeEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
				super.removeEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_IN);
				super.removeEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			}
		}
		private function FIELD_FOCUS_IN(event:FocusEvent):void{
			super.dispatchEvent(new Event(COEvent.FIELD_FOCUS));
		}
		private function FIELD_FOCUS_OUT(event:FocusEvent):void{
			super.dispatchEvent(new Event(COEvent.FIELD_FOCUS_OUT));
		}
		private function FIELD_INPUT_TEXT(event:TextEvent):void{
			startTimer();
		}
		private function FIELD_KEY_DOWN(event:KeyboardEvent):void{
			if(event.charCode == Keyboard.ENTER){
				super.dispatchEvent(new Event(COEvent.PRESS_ENTER));
			}else{
				startTimer();
			}
		}
		private function startTimer():void{
			handler = false;
			var timer:Timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER);
			timer.start();
		}
		private function TIMER(event:TimerEvent):void{
			super.dispatchEvent(new Event(COEvent.INPUT_TEXT));
			handler = true;
		}
		
		public function isPassword():void{
			super.displayAsPassword = true;
		}
		
		override public function set width(value:Number):void{
			super.width = value;
		}
		public function set color(value:uint):void{
			super.backgroundColor = value
		}
        public function get color():uint{
            return super.backgroundColor;
        }

		public function setFocus():void{
			MainEnvelope.STAGE.focus = this as InteractiveObject;
		}
	}
	
}
