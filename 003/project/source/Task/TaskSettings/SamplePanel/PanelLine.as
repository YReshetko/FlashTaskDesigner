package source.Task.TaskSettings.SamplePanel {
	import flash.display.Sprite;
	
	public class PanelLine extends Sprite{
		private var yPosition:Number = 12.5;
		public function PanelLine(name:String) {
			super();
			super.graphics.lineStyle(1, 0x9B9B9B, 1);
			super.graphics.moveTo(0, yPosition);
			super.graphics.lineTo(30, yPosition);
			var field:PanelLabel = new PanelLabel(name);
			super.addChild(field);
			field.x = 35;
			super.graphics.moveTo(field.x + field.width + 5, yPosition);
			super.graphics.lineTo(2000, yPosition);
			field.alpha = 0.6;
		}
		public function get variable():String{
			return 'none';
		}
	}
	
}
