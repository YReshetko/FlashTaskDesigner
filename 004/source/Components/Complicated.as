package source.Components {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Complicated extends Sprite{
		private var labelField:Label = new Label();
		private var textField:Field = new Field();
		public function Complicated(label:String) {
			super();
			super.addChild(labelField);
			super.addChild(textField);
			labelField.text = label;
			labelField.x = -labelField.width - 2.5;
			textField.x = 2.5;
			textField.addEventListener(COEvent.INPUT_TEXT, FIELD_TEXT_INPUT);
			textField.addEventListener(COEvent.PRESS_ENTER, PRESS_ENTER);
			textField.addEventListener(COEvent.FIELD_FOCUS, FIELD_FOCUS_IN);
		}
		override public function set width(value:Number):void{
			textField.width = value;
		}
		private function FIELD_FOCUS_IN(event:Event):void{
			super.dispatchEvent(new Event(COEvent.FIELD_FOCUS));
		}
		private function FIELD_TEXT_INPUT(event:Event):void{
			super.dispatchEvent(new Event(COEvent.INPUT_TEXT));
		}
		private function PRESS_ENTER(event:Event):void{
			super.dispatchEvent(new Event(COEvent.PRESS_ENTER));
		}
		public function get text():String{
			return textField.text;
		}
		public function set text(value:String):void{
			textField.text = value;
		}
		public function isPassword():void{
			textField.isPassword();
		}
		
		public function set color(value:uint):void{
			textField.color = value;
		}
		public function set restrict(value:String):void{
			textField.restrict = value;
		}
		public function set maxChars(value:int):void{
			textField.maxChars = value;
		}
		public function setFocus():void{
			textField.setFocus();
		}
	}
	
}
