package source.Task.TaskSettings.SamplePanel {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class PanelLabel extends Sprite{
		private var field:TextField = new TextField();
		public function PanelLabel(inText:String) {
			super();
			
			var format:TextFormat = new TextFormat();
			field.autoSize = TextFieldAutoSize.LEFT;
			format.size = 14;
			format.bold = true;
			field.defaultTextFormat = format;
			field.text = inText;
			field.mouseEnabled = false;
			super.addChild(field);
		}
		public function set size(value:Number):void{
			var format:TextFormat = field.getTextFormat();
			format.size = value;
			field.setTextFormat(format);
			field.defaultTextFormat = format;
		}
		public function set textColor(value:uint):void{
			field.textColor = value;
		}

	}
	
}
