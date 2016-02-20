package source.Task.TaskObjects.CheckBox.BoxType {
	import flash.display.Sprite;
	import source.utils.Components.Mark;
	import source.utils.Components.Field;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import source.utils.Components.RoundMark;

	public class RoundBox extends FieldClass{
		private var mark:RoundMark = new RoundMark();
		//private var field:Field = new Field();
		public function RoundBox() {
			super();
			initBox();
		}
		private function initBox():void{
			super.addChild(mark);
			super.addChild(field);
			field.input = false;
			field.height = 20;
			field.width = 5;
			mark.y = -mark.height/2;
			field.y = -field.height/2;
			field.x = mark.width + 10;
			field.addEventListener(Field.TEXT_INPUT, FIELD_INPUT_TEXT);
			field.doubleClickEnabled = true;
			field.addEventListener(MouseEvent.DOUBLE_CLICK, FIELD_DOUBLE_CLICK);
			//mark.addEventListener(MouseEvent.CLICK, MARK_CLICK);
		}
		public function correctFieldSize():void{
			field.correctSize();
			FIELD_DOUBLE_CLICK(null);
		}
		private function FIELD_INPUT_TEXT(event:Event):void{
			field.y = -field.height/2;
		}
		private function FIELD_DOUBLE_CLICK(event:MouseEvent):void{
			field.input = true;
			field.autoSize = true;
			field.setCursor();
		}
		public function close():void{
			field.input = false;
			field.autoSize = false;
		}
		public function isClose():Boolean{
			return !field.input;
		}
		public function set select(value:Boolean):void{
			mark.select = value;
		}
		public function get select():Boolean{
			return mark.select
		}
		public function get text():String{
			return field.text;
		}
		public function set text(value:String):void{
			field.text = value;
		}
	}
	
}
