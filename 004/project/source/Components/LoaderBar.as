package source.Components {
	import flash.display.Sprite;
	
	public class LoaderBar extends Sprite{
		private var wBar:Number = 250;
		private var hBar:Number = 25;
		
		private var contur:Sprite = new Sprite();
		private var fill:Sprite = new Sprite();
		
		private var label:Label = new Label();
		
		public function LoaderBar() {
			super();
			super.addChild(fill);
			super.addChild(contur);
			super.addChild(label);
			draw();
		}
		
		private function draw():void{
			contur.graphics.clear();
			contur.graphics.lineStyle(1, 0x000000, 1);
			contur.graphics.drawRect(0, 0, wBar, hBar);
			contur.graphics.lineStyle(1, 0xFFFFFF, 1);
			contur.graphics.drawRect(1, 1, wBar-2, hBar-2);
			
			fill.graphics.clear();
			fill.graphics.lineStyle(0.1, 0, 0);
			fill.graphics.beginFill(0x00FF00, 1);
			fill.graphics.drawRect(0, 0, wBar, hBar);
			fill.graphics.endFill();
			
			contur.x = -wBar/2;
			fill.x = -wBar/2;
			
			percent = 0;
		}
		
		override public function set width(value:Number):void{
			wBar = value;
			draw();
		}
		override public function set height(value:Number):void{
			hBar = value;
			draw();
		}
		
		public function set percent(value:Number):void{
			fill.scaleX = value;
			text = ((Math.ceil(value*10000))/100).toString() + ' %';
		}
		
		public function set text(value:String):void{
			label.text = value;
			label.x = -label.width/2;
		}
		
	}
	
}
