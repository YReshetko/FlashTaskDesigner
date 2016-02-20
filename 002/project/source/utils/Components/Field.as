package source.utils.Components {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import source.MainPlayer;
	import flash.events.TextEvent;
	
	public class Field extends Sprite{
		public static var TEXT_INPUT:String = 'onTextInput';
		
		private var TEXT_COLOR:uint = 0x000000;
		private var BACKGROUND_COLOR:uint = 0xFFFFFF;
		private var BORDER_COLOR:uint = 0x000000;
		
		private var BACKGROUND:Boolean = true;
		private var BORDER:Boolean = true;
		
		private var SIZE:Number = 14;
		private var BOLD:Boolean = false;
		private var ITALIC:Boolean = false;
		private var AUTOSIZE:String = 'none';
		private var MULTILINE:Boolean = true;
		
		private var ALIGN:String = 'left';
		private var FONT:String = 'Time New Romans';
		
		
		
		private var field:TextField = new TextField();
		public function Field() {
			super();
			super.addChild(field);
			applySettings();
			
			field.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
		}
		public function correctSize():void{
			field.width = field.textWidth;
			field.height = field.textHeight;
		}
		private function FIELD_KEY_DOWN(event:KeyboardEvent):void{
			startTimer();
		}
		private function startTimer():void{
			var timer:Timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_TIMER);
			timer.start();
		}
		private function TIMER_TIMER(event:TimerEvent):void{
			super.dispatchEvent(new Event(TEXT_INPUT));
		}
		public function set align(value:String):void{
			ALIGN = value;
			applySettings();
		}
		public function get align():String{
			return this.ALIGN;
		}
		public function set bold(value:Boolean):void{
			this.BOLD = value;
			applySettings();
		}
		public function get bold():Boolean{
			return this.BOLD;
		}
		public function set italic(value:Boolean):void{
			this.ITALIC = value;
			applySettings();
		}
		public function get italic():Boolean{
			return this.ITALIC;
		}
		public function set font(value:String):void{
			this.FONT = value;
			applySettings();
		}
		public function get font():String{
			return this.FONT;
		}
		public function set size(value:Number):void{
			this.SIZE = value;
			applySettings();
		}
		public function get size():Number{
			return this.SIZE;
		}
		public function set background(value:Boolean):void{
			this.BACKGROUND = value;
			applySettings();
		}
		public function get background():Boolean{
			return this.BACKGROUND;
		}
		public function set border(value:Boolean):void{
			this.BORDER = value;
			applySettings();
		}
		public function get border():Boolean{
			return this.BORDER;
		}
		public function set backgroundColor(value:uint):void{
			this.BACKGROUND_COLOR = value;
			applySettings();
		}
		public function get backgroundColor():uint{
			return this.BACKGROUND_COLOR;
		}
		public function set borderColor(value:uint):void{
			this.BORDER_COLOR = value;
			applySettings();
		}
		public function get borderColor():uint{
			return this.BORDER_COLOR;
		}
		public function set textColor(value:uint):void{
			this.TEXT_COLOR = value;
			applySettings();
		}
		public function get textColor():uint{
			return this.TEXT_COLOR;
		}
		public function set multiline(value:Boolean):void{
			this.MULTILINE = value;
			applySettings();
		}
		public function get multiline():Boolean{
			return this.MULTILINE;
		}
		
		override public function set width(value:Number):void{
			field.width = value;
		}
		override public function get width():Number{
			return field.width;
		}
		override public function set height(value:Number):void{
			field.height = value;
		}
		override public function get height():Number{
			return field.height;
		}
		public function get text():String{
			return field.text;
		}
		public function set text(value:String):void{
			field.text = value;
		}
		public function get textWidth():Number{
			return field.textWidth;
		}
		public function get textHeight():Number{
			return field.textHeight;
		}
		public function set autoSize(value:Boolean):void{
			if(!value){
				field.autoSize = TextFieldAutoSize.NONE;
				return;
			}
			switch(this.ALIGN){
				case 'left':
				field.autoSize = TextFieldAutoSize.LEFT;
				break;
				case 'center':
				field.autoSize = TextFieldAutoSize.CENTER;
				break;
				case 'right':
				field.autoSize = TextFieldAutoSize.RIGHT;
				break;
			}
		}
		public function set input(value:Boolean):void{
			if(value){
				field.type = TextFieldType.INPUT;
				field.mouseEnabled = true;
			}else{
				field.type = TextFieldType.DYNAMIC;
				field.mouseEnabled = false;
			}
		}
		public function get input():Boolean{
			if(field.type == TextFieldType.INPUT) return true;
			return false;
		}
		public function setCursor():void{
			MainPlayer.STAGE.focus = field;
		}
		
		
		private function applySettings():void{
			var format:TextFormat = new TextFormat();
			format.align = ALIGN;
			format.bold = BOLD;
			format.italic = ITALIC;
			format.font = FONT;
			format.size = SIZE;
			
			field.background = BACKGROUND;
			field.backgroundColor = BACKGROUND_COLOR;
			field.border = BORDER;
			field.borderColor = BORDER_COLOR;
			
			field.textColor = TEXT_COLOR;
			field.multiline = this.MULTILINE;
			
			field.setTextFormat(format);
			field.defaultTextFormat = format;
		}

	}
	
}
