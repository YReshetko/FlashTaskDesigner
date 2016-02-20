package source.EnvInterface.EnvMenu {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	
	public class VisualPreloader extends Sprite{
		private static const wPreload:Number = 250;
		private static const hPreload:Number = 20;
		private static const hBar:Number = 7;
		private static const wBar:Number = 200;
		private var barBG:Sprite = new Sprite();
		private var barPR:Sprite = new Sprite();
		private var field:TextField = new TextField();
		
		public function VisualPreloader() {
			super();
			init();
		}
		private function init():void{
			//initPlane(super, wPreload, hPreload);
			initPlane(barBG, wBar, hBar, 0x909090, 0xD0D0D0);
			initPlane(barPR, wBar, hBar, 0x00FF00, 0x66FF00);
			super.addChild(barBG);
			super.addChild(barPR);
			barPR.x = barBG.x = (wPreload - wBar)/2+15;
			barPR.y = barBG.y = (hPreload - hBar)/2;
			super.addChild(field);
			field.x = 1;
			field.height = 15;
			field.y = 2.5;
			field.width = 25;
			var format:TextFormat = new TextFormat();
			format.size = 10;
			format.align = TextFormatAlign.RIGHT;
			field.defaultTextFormat = format;
			field.mouseEnabled = false;
		}
		public function open():void{
			super.visible = true;
			setPercent(1, 0);
		}
		public function close():void{
			super.visible = false;
			setPercent(1, 0);
		}
		public function setPercent(total:Number, current:Number):void{
			if(total!=0){
				barPR.scaleX = (current/total);
				field.text = Math.ceil((current/total)*100).toString() + '%';
			}else{
				barPR.scaleX = 0;
				field.text = 'Error'
			}
		}
		
		public static function initPlane(value:Sprite, w:Number, h:Number, topColor:uint = 0xC0C0C0, downColor:uint = 0xE9E9E9):void {
			value.graphics.clear();
			value.graphics.lineStyle(0.1, 0x000000, 0.4);
			var colors:Array = [topColor, downColor];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, h, Math.PI/2, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			value.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, spreadMethod);
			value.graphics.drawRect(0, 0, w, h);
			value.graphics.endFill();
		}
	}
	
}
