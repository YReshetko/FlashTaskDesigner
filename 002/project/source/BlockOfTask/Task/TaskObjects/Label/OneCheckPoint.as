package source.BlockOfTask.Task.TaskObjects.Label {
	import flash.display.Sprite;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.LineScaleMode;
	
	public class OneCheckPoint extends Sprite{
		public static var DEFAULT_STATE	:int = 0;
		public static var TRUE_STATE	:int = 1;
		public static var FALSE_STATE	:int = 2;
		
		private static const defaultColor	:Array = [0x888888, 0x222222];
		private static const trueColor		:Array = [0x00FF00, 0x006600];
		private static const falseColor		:Array = [0xFF0000, 0x990000];
		
		private var currentColor:Array;
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
			var colors:Array = [currentColor[0], currentColor[1]];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x22, 0xFF];
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
