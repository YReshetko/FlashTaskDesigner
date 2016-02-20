package source.Task.Animation.AroundPoint {
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class RoundPoint extends Sprite{
		public static var GET_POINT:String = 'onGetPoint';
		private static var R:Number = 50
		private static var r:Number = 37;
		private static var a:Number = 0.6;
		private var bgSprite:Sprite = new Sprite();
		private var arrLabel:Array = new Array();
		private var currentID:int;
		public function RoundPoint(value:Array) {
			super();
			initRound();
			initLabels(value);
		}
		private function initRound():void{
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xEEEEEE, 0x999999, 0x999999, 0xCCCCCC];
			var alphas:Array = [a, a, a, a];
			var ratios:Array = [0x22, 0x88, 0xCC, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(2*R, 2*R, 0, -1*R, -1*R);
			var spreadMethod:String = SpreadMethod.PAD;
			bgSprite.graphics.lineStyle(1, 0x000000, 0);
			bgSprite.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);        
			bgSprite.graphics.drawCircle(0, 0, R);
			bgSprite.graphics.endFill();
			super.addChild(bgSprite);
		}
		private function initLabels(value:Array):void{
			var i:int;
			var l:int;
			var fi:Number;
			l = value.length;
			fi = (2*Math.PI)/l;
			
			for(i=0;i<l;i++){
				arrLabel.push(new LabelPoint(value[i]));
				super.addChild(arrLabel[i]);
				arrLabel[i].x = r*Math.sin(Math.PI-fi*i);
				arrLabel[i].y = r*Math.cos(Math.PI-fi*i);
				(arrLabel[i] as LabelPoint).addEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN); 
			}
		}
		public function clear():void{
			while(arrLabel.length>0){
				if(super.contains(arrLabel[0])) super.removeChild(arrLabel[0]);
				if((arrLabel[0] as LabelPoint).hasEventListener(MouseEvent.MOUSE_DOWN)) (arrLabel[0] as LabelPoint).removeEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN); 
				arrLabel[0] = null;
				arrLabel.shift();
			}
			bgSprite.graphics.clear();
			if(super.contains(bgSprite)) super.removeChild(bgSprite);
		}
		private function LABEL_MOUSE_DOWN(event:MouseEvent):void{
			currentID = (event.target as LabelPoint).ID;
			super.dispatchEvent(new Event(GET_POINT));
		}
		public function get ID():int{
			return currentID;
		}

	}
	
}
