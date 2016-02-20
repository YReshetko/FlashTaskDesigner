package source.EnvInterface.EnvMenu {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	public class LinkLine extends Sprite{
		private static const lineHeight:int = 18;
		private var startWidth:Number = 10;
		private var lineY:int = 8;
		private var deltaX:int = 3;
		public function LinkLine() {
			super();
			drawFon();
		}	
		public function getWidth():Number{
			return startWidth;
		}
		public function setWidth(w:Number):void{
			startWidth = w;
			drawFon();
		}
		private function drawFon():void{
			Figure.insertRect(super, startWidth, lineHeight, 1, 0, 0x000000, 1, 0xFFFFFF);
			Figure.insertLine(super, deltaX, lineY, startWidth - deltaX*2, lineY, 0.4, 1); 
		}
	}
	
}
