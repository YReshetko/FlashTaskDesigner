package source.Components {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.MainEnvelope;
	
	public class RoundButton extends Sprite{
		
		
		
		public static var DOWN_TREANGLE:String = 'down';
		public static var UP_TREANGLE:String = 'up';
		public static var LEFT_TREANGLE:String = 'left';
		public static var RIGHT_TREANGLE:String = 'right';
		public static var NONE_TREANGLE:String = 'none';
		
		private var outColor:uint;
		private var overColor:uint;
		private var downColor:uint;
		private var radius:Number;
		private var initTreangle:String;
		
		private var currentColor:uint;
		
		private var treangleContainer:Sprite;
		public function RoundButton(radius:Number = 10, 
									initTreangle:String = 'down',
									outColor:uint = 0xD6D6D6,
									overColor:uint = 0xE6E6E6,
									downColor:uint = 0xD0D0D0) {
			super();
			this.radius = radius;
			this.initTreangle = initTreangle;
			this.outColor = outColor;
			this.overColor = overColor;
			this.downColor = downColor;
			init();
		}
		private function init():void{
			currentColor = outColor;
			drawCircle();
			if(initTreangle!=NONE_TREANGLE){
				drawTreangle();
				switch(initTreangle){
					case UP_TREANGLE: treangleContainer.rotation = -90; break;
					case LEFT_TREANGLE: treangleContainer.rotation = 180; break;
					case DOWN_TREANGLE: treangleContainer.rotation = 90; break;
				}
			}
			super.addEventListener(MouseEvent.MOUSE_OVER, BUTTON_OVER);
			super.addEventListener(MouseEvent.MOUSE_OUT, BUTTON_OUT);
			super.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_DOWN);
			super.mouseChildren = false;
		}
		private function BUTTON_OVER(event:MouseEvent):void{
			currentColor = overColor;
			drawCircle();
		}
		private function BUTTON_OUT(event:MouseEvent):void{
			currentColor = outColor;
			drawCircle();
		}
		private function BUTTON_DOWN(event:MouseEvent):void{
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, BUTTON_UP);
			currentColor = downColor;
			drawCircle();
		}
		private function BUTTON_UP(event:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BUTTON_UP);
			currentColor = outColor;
			drawCircle();
		}
		public function set radiusButton(value:Number):void{
			this.radius = value;
			treangleContainer.x = radius;
			 treangleContainer.y = radius + 2;
			drawCircle();
		}
		private function drawCircle():void{
			super.graphics.clear();
			super.graphics.lineStyle(0.1, 0x6D6D6D, 0.7);
			super.graphics.beginFill(currentColor, 1);
			super.graphics.drawCircle(radius, radius+2, radius);
			super.graphics.endFill();
		}
		private function drawTreangle():void{
			treangleContainer = new Sprite();
			treangleContainer.graphics.lineStyle(0.1, 0x666666, 0.7, true);
			treangleContainer.graphics.beginFill(0x6D6D6D, 1);
			treangleContainer.graphics.moveTo(-3, -3);
			treangleContainer.graphics.lineTo(3, 0);
			treangleContainer.graphics.lineTo(-3, 3);
			treangleContainer.graphics.lineTo(-3, -3);
			treangleContainer.graphics.endFill();
			super.addChild(treangleContainer);
			treangleContainer.x = radius;
			treangleContainer.y = radius+2;
		}

	}
	
}
