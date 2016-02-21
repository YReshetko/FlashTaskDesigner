package source.Utilites {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class GetField {
		private static const sizeText:int = 14;
		private static const colorText:String = "0x000000";

		public static function drawLabel(str:String, size:int = sizeText, color:String = colorText):TextField{
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			field.textColor = parseInt(color);
			textFormat.size = size;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.text = str;
			field.setTextFormat(textFormat);
			field.mouseEnabled = false;
			return field;
		}
		public static function drawInput(Width:int, Height:int, Restrict = null, size:int = sizeText):TextField{
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = size;
			textFormat.align = 'center';
			field.border = true;
			field.borderColor = parseInt("0x000000");
			field.background = true;
			field.backgroundColor = parseInt("0xFFFFFF");
			field.type = TextFieldType.INPUT;
			field.restrict = Restrict;
			field.width = Width;
			field.height = Height;
			field.defaultTextFormat = textFormat;
			return field;
		}

	}
	
}
