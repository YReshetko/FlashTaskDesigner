package source.FuncPanel {
	import flash.display.Sprite;
	
	public class SamplePlace extends Sprite{
		private var ID:String = "";
		private var container:Sprite = new Sprite;
		public function SamplePlace(Height:Number, Width:Number, ID:String) {
			this.ID = ID;
			drawRect(Height, Width);
			this.addChild(container);
			container.x = -Width/2;
			container.y = -Height/2;
		}
		private function drawRect(H:Number, W:Number){
			container.graphics.lineStyle(1, 0x000000, 1);
			container.graphics.beginFill(0xEFEFEF, 1);
			container.graphics.drawRect(0,0,W,H);
			container.graphics.endFill();
		}
		public function getID():String{
			return ID;
		}
	}
	
}
