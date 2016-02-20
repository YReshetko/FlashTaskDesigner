package source.Task.TaskObjects.Label {
	import flash.display.Sprite;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.LineScaleMode;
	
	public class OneCheckPoint extends Sprite{
		public static var DEFAULT_STATE	:int = 0;
		public static var TRUE_STATE	:int = 1;
		public static var FALSE_STATE	:int = 2;
		
		private static const defaultColor	:uint = 0x888888;
		private static const trueColor		:uint = 0x00FF00;
		private static const falseColor		:uint = 0xFF0000;
		
		private var currentColor:uint;
		private var currentRadius:Number = 3;
		public function OneCheckPoint(state:int = 0, radius:Number = 3) {
			super();
			this.state = state;
			this.radius = radius;
		}
		public function set state(value:int):void{
			switch(value){
				case DEFAULT_STATE: currentColor = defaultColor; 	break;
				case TRUE_STATE: 	currentColor = trueColor; 		break;
				case FALSE_STATE: 	currentColor = falseColor; 		break;
			}
			draw();
		}
		public function set radius(value:Number):void{
			currentRadius = value;
			draw();
		}
		private function draw():void{
			var colors:Array = [currentColor, currentColor];
			var alphas:Array = [1, 0];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(2*currentRadius, 2*currentRadius, 0, -currentRadius, -currentRadius);
			var spreadMethod:String = SpreadMethod.PAD;
			clear();
			super.graphics.lineStyle(0.1, 0x000000, 1, false, LineScaleMode.NONE);
			super.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matr, spreadMethod);
			super.graphics.drawCircle(0, 0, currentRadius);
			super.graphics.endFill();
		}
		public function clear():void{
			super.graphics.clear();
		}
		
		
	}
}
