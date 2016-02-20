package source.utils.PlayerTimer {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	public class TimerViewer extends Sprite{
		private var timerField:TextField;
		public function TimerViewer(hContainer:Number) {
			super();
			timerField = setField();
			super.addChild(timerField);
			timerField.x = 25;
			timerField.y = hContainer - 27.5;
			fieldEnabled(false);
		}
		
		private function setField():TextField{
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xFF0000;//	цвет текста только чёрный
			textFormat.size = 18;//	размер шрифта
			textFormat.bold = true;
			textFormat.align = "center";//	выравнивание по центру
			field.width = 50;
			field.height = 25;
			field.type = TextFieldType.DYNAMIC;
			field.mouseEnabled = false;
			field.defaultTextFormat = textFormat;
			field.border = true;
			field.background = true;
			return field;
		}
		public function fieldEnabled(f:Boolean):void{
			timerField.visible = f;
		}
		public function setNewTime(s:String):void{
			timerField.text = s;
		}
	}
}