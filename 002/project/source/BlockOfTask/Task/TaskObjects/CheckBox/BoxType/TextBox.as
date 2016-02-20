package source.BlockOfTask.Task.TaskObjects.CheckBox.BoxType {
	import flash.display.Sprite;
	import source.utils.Components.PlaneSelect;
	import source.utils.Components.Field;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TextBox extends FieldClass{
		private var mark:PlaneSelect = new PlaneSelect();
		//private var field:Field = new Field();
		public function TextBox() {
			super();
			initBox();
		}
		private function initBox():void{
			super.addChild(mark);
			super.addChild(field);
			field.input = false;
			field.height = 20;
			field.width = 5;
			FIELD_INPUT_TEXT(null);
			mark.y = -mark.height/2;
			mark.x = -PlaneSelect.deltaMark;
			field.y = -field.height/2;
			field.addEventListener(Field.TEXT_INPUT, FIELD_INPUT_TEXT);
			field.doubleClickEnabled = true;
			field.addEventListener(MouseEvent.DOUBLE_CLICK, FIELD_DOUBLE_CLICK);
			//mark.addEventListener(MouseEvent.CLICK, MARK_CLICK);
		}
		public function correctFieldSize():void{
			field.correctSize();
			
			FIELD_DOUBLE_CLICK(null);
			FIELD_INPUT_TEXT(null);
			field.input = false;
			field.autoSize = false;
		}
		private function FIELD_INPUT_TEXT(event:Event):void{
			field.y = -field.height/2;
			mark.width = field.width;
			mark.height = field.height;
			mark.y = -mark.height/2;
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
		override public function set wField(value:Number):void{
			super.wField = value;
			mark.width = value;
		}
		override public function set hField(value:Number):void{
			super.hField = value;
			mark.height = value;
		}
	}
	
}
