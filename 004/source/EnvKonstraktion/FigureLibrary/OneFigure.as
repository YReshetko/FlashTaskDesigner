package source.EnvKonstraktion.FigureLibrary {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class OneFigure extends Sprite{
		public static var FIGURE_SELECT:String = 'onFigureSelect';
		private var type:String;
		private var points:Array = new Array();
		public function OneFigure(inXml:XMLList) {
			super();
			saveFigure(inXml);
			drawFigure();
			super.addEventListener(MouseEvent.MOUSE_DOWN, FIGURE_MOUSE_DOWN);
		}
		private function saveFigure(xml:XMLList):void{
			type = xml.@type.toString();
			var arr:Array = xml.toString().split(',');
			var i:int;
			var l:int;
			l = arr.length;
			//trace(this + ': TYPE = ' + type);
			//trace(this + ': array = ' + arr);
			if(type == 'line'){
				for(i=0;i<l;i=i+2){
					points.push([arr[i], arr[i+1]]);
				}
			}
			if(type == 'curve'){
				points.push([arr[0], arr[1], 'NaN', 'NaN']);
				for(i=4; i<l; i=i+4){
					points.push([arr[i], arr[i+1], arr[i+2], arr[i+3]]);
				}
			}
		}
		private function drawFigure():void{
			Figure.insertDiffCurve(super, points, 1, 1, 0x000000, 1, 0xAAEE00);
		}
		private function FIGURE_MOUSE_DOWN(event:MouseEvent):void{
			super.dispatchEvent(new Event(FIGURE_SELECT));
		}
		public function get content():Object{
			var outObject:Object = new Object();
			outObject.type = type;
			outObject.data = points;
			return outObject;
		}

	}
	
}
