package source.Task.PaintSystem.DrawObjects {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseFigure extends Sprite{
		public static var FIGURE_EDIT:String = 'onEditFigure';
		private var arrFigure:Array = new Array();
		private var outArray:Array;
		public function BaseFigure(inContainer:Sprite) {
			super();
			inContainer.addChild(super);
		}
		public function addFigure(inArray:Array):void{
			var i:int;
			var l:int;
			var minX:Number;
			var minY:Number;
			var maxX:Number;
			var maxY:Number;
			maxX = minX = inArray[0][0];
			maxY = minY = inArray[0][1];
			l = inArray.length;
			for(i=1;i<l;i++){
				if(inArray[i][0]<minX) minX = inArray[i][0];
				if(inArray[i][2]<minX) minX = inArray[i][2];
				
				if(inArray[i][1]<minY) minY = inArray[i][1];
				if(inArray[i][3]<minY) minY = inArray[i][3];
				
				if(inArray[i][0]>maxX) maxX = inArray[i][0];
				if(inArray[i][2]>maxX) maxX = inArray[i][2];
				
				if(inArray[i][1]>maxY) maxY = inArray[i][1];
				if(inArray[i][3]>maxY) maxY = inArray[i][3];
			}
			var deltaX:Number = minX + (maxX - minX)/2;
			var deltaY:Number = minY + (maxY - minY)/2;
			var outArr:Array = new Array();
			outArr.push([inArray[0][0]-deltaX, inArray[0][1]-deltaY]);
			for(i=1;i<l;i++){
				outArr.push([inArray[i][0]-deltaX, inArray[i][1]-deltaY, inArray[i][2]-deltaX, inArray[i][3]-deltaY]);
			}
			
			var ID:int = arrFigure.length;
			arrFigure.push(new FIGURE(outArr));
			super.addChild(arrFigure[ID]);
			arrFigure[ID].addEventListener(FIGURE.DELETE_FIGURE, REMOVE_FIGURE);
			arrFigure[ID].addEventListener(FIGURE.FIGURE_EDIT, EDIT_FIGURE);
			arrFigure[ID].x = deltaX;
			arrFigure[ID].y = deltaY;
		}
		public function get rectangles():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrFigure.length;
			for(i=0;i<l;i++){
				outArr.push(arrFigure[i].getBounds(super));
			}
			return outArr;
		}
		public function set printingImages(value:Array):void{
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				arrFigure[i].setImage(value[i][0], value[i][1]);
			}
		}
		
		
		public function get listFigure():XMLList{
			if(arrFigure.length==0) return null;
			var outXml:XMLList = new XMLList('<OBJECTS/>');
			var i:int;
			var l:int;
			l = arrFigure.length;
			for(i=0;i<l;i++){
				outXml.appendChild(arrFigure[i].settingsList);
			}
			return outXml;
		}
		public function clear():void{
			while(arrFigure.length>0){
				super.removeChild(arrFigure[0]);
				arrFigure[0].clear();
				arrFigure.shift();
			}
		}
		private function REMOVE_FIGURE(event:Event):void{
			trace(this + 'REMOVE FIGURE');
			var figure:FIGURE = event.target as FIGURE;
			var i:int;
			var l:int;
			l = arrFigure.length;
			for(i=0;i<l;i++){
				if(figure == arrFigure[i]){
					figure.clear();
					super.removeChild(figure);
					arrFigure.splice(i, 1);
					return;
				}
			}
		}
		public function set enabled(value:Boolean):void{
			var i:int;
			var l:int;
			l = arrFigure.length;
			for(i=0;i<l;i++){
				arrFigure[i].mouseEnabled = value;
				arrFigure[i].mouseChildren = value;
			}
			super.mouseChildren = value;
			super.mouseEnabled = value;
		}
		private function EDIT_FIGURE(event:Event):void{
			var figure:FIGURE = event.target as FIGURE;
			var deltaX:Number = figure.x;
			var deltaY:Number = figure.y;
			var inArray:Array = figure.points;
			outArray = new Array();
			var i:int;
			var l:int;
			l = inArray.length;
			outArray.push([inArray[0][0]+deltaX, inArray[0][1]+deltaY, 0, 0]);
			for(i=1;i<l;i++){
				outArray.push([inArray[i][0]+deltaX, inArray[i][1]+deltaY, inArray[i][2]+deltaX, inArray[i][3]+deltaY]);
			}
			REMOVE_FIGURE(event);
			super.dispatchEvent(new Event(FIGURE_EDIT));
		}
		public function get points():Array{
			return outArray;
		}
	}
	
}
