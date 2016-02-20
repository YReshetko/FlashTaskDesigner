package source.EnvInterface.EnvPanel {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class LabelPanel extends Sprite{
		private static const textSize:Number = 11;
		private static const bold:Boolean = true;
		private static const textColor:uint = 0x363636;
		
		private static const defaultColor:uint = 0xA3A3A3;
		private static const selectColor:uint = 0xD3D3D3;
		
		private static const startX:Number = 3;
		
		private var endX:Number;
		private var id:int;
		private var panelLabel:String;
		public function LabelPanel(label:String) {
			super();
			panelLabel = label;
			var W:Number = addLabel(label);
			endX = W + startX;
			drawLabel(defaultColor);
		}
		private function addLabel(label:String):Number{
			var field:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = textSize;
			format.bold = true;
			field.textColor = textColor;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.defaultTextFormat = format;
			field.text = label;
			field.mouseEnabled = false;
			super.addChild(field);
			field.x = startX;
			field.y = 1;
			return field.width;
		}
		private function drawLabel(color:uint):void{
			super.graphics.clear();
			var H:Number = BlockPanels.hLabel;
			super.graphics.lineStyle(1, 0x474747, 1);
			super.graphics.beginFill(color, 1);
			super.graphics.moveTo(0, H);
			super.graphics.lineTo(3, H - 10);
			super.graphics.curveTo(5, H - 11, 7, H -12);
			super.graphics.lineTo(endX, H -12);
			super.graphics.curveTo(endX + 18, H - 10, endX + 20, H);
			super.graphics.endFill();
		}
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		public function get label():String{
			return panelLabel;
		}
		public function set select(value:Boolean):void{
			if(value) drawLabel(selectColor);
			else drawLabel(defaultColor);
		}
	}
	
}
