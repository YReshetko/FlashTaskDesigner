package source.utils.Components {
	import flash.display.Sprite;
	import source.utils.Figure;
	
	public class Mark extends Sprite{
		private static var a:int = 15;
		
		
		private var rect:Sprite = new Sprite();
		private var mark:Sprite = new Sprite();
		public function Mark() {
			super();
			drawRect();
			drawMark();
			this.select = false;
		}
		private function drawRect():void{
			Figure.insertRect(rect, a, a, 3, 1, 0x000000, 1, 0xFEFEFE);
			super.addChild(rect);
		}
		private function drawMark():void{
			Figure.insertCurve(mark, [[0,0], [Math.ceil(a/2)-1,a]], 1, 2, 0x00FF00, 0);
			Figure.insertCurve(mark, [[Math.ceil(a/2)-1,a], [a,0]], 1, 2, 0x00FF00, 0);
			
			super.addChild(mark);
			
		}
		public function set select(value:Boolean):void{
			mark.visible = value
		}
		public function get select():Boolean{
			return mark.visible;
		}
		

	}
	
}
