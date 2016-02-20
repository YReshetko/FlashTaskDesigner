package source.Task.TaskSettings.SamplePanel.PanelChoise {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class CheckBoxSettings {
		public static const defaultBackgraund:Number = 0xA6A6A6;
		public static const selectBackgraund:Number = 0x969696;
		
		public static const labelSize:Number = 14;
		public static const labelColor:Number = 0x000000;
		public static const labelBold:Boolean = true;
		
		public static function drawBackgraund(inSprite:Sprite, Width, Height, currentBackgraund:Number):void{
			inSprite.graphics.clear();
			inSprite.graphics.lineStyle(0.1, 0xD3D3D3, 1);
			inSprite.graphics.beginFill(currentBackgraund, 1);
			inSprite.graphics.drawRect(0, 0, Width, Height);
			inSprite.graphics.endFill();
		}
		public static  function addLabel(str:String):TextField{
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = labelBold;
			textFormat.size = labelSize;
			textFormat.color = labelColor;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.defaultTextFormat = textFormat;
			field.text = str;
			field.mouseEnabled = false;
			return field;
		}
	}
	
}
