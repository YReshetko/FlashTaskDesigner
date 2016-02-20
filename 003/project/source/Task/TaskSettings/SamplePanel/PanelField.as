package source.Task.TaskSettings.SamplePanel {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class PanelField extends Sprite{
		public static var GET_TEXT_PROPERTY:String = 'onGetTextProperty';
		private var fieldLabel:PanelLabel;
		private var field:TextField = new TextField();
		private var fieldType:String = '';
		private var fieldVar:String = '';
		private var fieldWidth:Number = 150;
		private var fieldHeight:Number = 18;
		private var fieldPosition:Number = 0;
		private var fieldMultiline:Boolean = false;
		private var fieldAlign:String = 'center';
		public function PanelField(inXml:XML) {
			super();
			if(inXml.@label.toString()!='') {
				fieldLabel = new PanelLabel(inXml.@label.toString());
				super.addChild(fieldLabel);
				//fieldPosition = fieldLabel.width;
			}
			if(inXml.@width.toString()!='') fieldWidth = parseFloat(inXml.@width);
			if(inXml.@height.toString()!='') fieldHeight = parseFloat(inXml.@height);
			if(inXml.@multiline.toString()=='true') fieldMultiline = true;
			if(inXml.@align.toString()!='') fieldAlign = inXml.@align.toString();
			fieldVar = inXml.@variable.toString();
			fieldType = inXml.@type.toString();
			createField();
			this.property = inXml.toString();
		}
		private function createField():void{
			var format:TextFormat = new TextFormat();
			format.size = 13;
			format.bold = true;
			format.align = fieldAlign;//TextFormatAlign.CENTER;
			field.width = fieldWidth;
			field.height = fieldHeight;
			field.border = true;
			field.multiline = fieldMultiline;
			field.type = TextFieldType.INPUT;
			field.defaultTextFormat = format;
			super.addChild(field);
			field.x = fieldPosition+5;
			if(fieldLabel!=null) fieldLabel.x = field.x + field.width + 5
			//field.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			field.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
		}
		public function set property(value:String):void{
			field.text = value;
		}
		public function get property():String{
			return field.text;
		}
		public function get variable():String{
			return fieldVar;
		}
		public function get type():String{
			return fieldType;
		}
		/*private function FIELD_TEXT_INPUT(e:TextEvent){
			startTimer();
		}*/
		private function FIELD_KEY_DOWN(e:KeyboardEvent):void{
			startTimer();
		}
		private function startTimer():void{
			var timer:Timer = new Timer(10,1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_START);
			timer.start();
		}
		private function TIMER_START(e:TimerEvent):void{
			super.dispatchEvent(new Event(GET_TEXT_PROPERTY));
		}
	}
	
}
