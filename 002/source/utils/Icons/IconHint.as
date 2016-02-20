package source.utils.Icons {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class IconHint extends TextField{

		public function IconHint(value:String) {
			super();
			super.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat();
			format.size = 13;
			format.bold = true;
			super.defaultTextFormat = format;
			super.border = true;
			super.background = true;
			super.backgroundColor = 0xFFCC66;
			super.borderColor = 0x000000;
			super.text = value;
			super.mouseEnabled = false;
		}

	}
	
}
