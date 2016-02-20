package source.Task.TaskObjects.Palitra {
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class Brush extends LibBrush{
		private var currentColor:uint;
		public function Brush(startColor:uint = 0x000000) {
			super();
			super.mouseChildren = false;
			super.mouseEnabled = false;
			super.tabEnabled = false;
			super.tabChildren = false;
			
			color = startColor;
		}
		public function set color(value:uint):void{
			currentColor = value;
			var inColor:ColorTransform = super.fillBrush.transform.colorTransform; 
			inColor.color = currentColor;
			super.fillBrush.transform.colorTransform = inColor;
		}
		public function get color():uint{
			return currentColor;
		}
		public function clear():void{
			super.parent.removeChild(super);
		}
	}
	
}
