package source.BlockOfTask.Task.TaskObjects.Label {
	import flash.display.Sprite;
	
	public class CheckPoints extends Sprite{
		private var pointsHeight:Number;
		private var numLines:int = 0;
		private var startRadius:Number = 6;
		private var radius:Number;
		private var arrPoints:Array = new Array();
		public function CheckPoints(lines:Number, height:Number) {
			super();
			pointsHeight = height;
			this.lines = lines;
		}
		override public function set height(value:Number):void{
			pointsHeight = value;
			drawPoints();
		}
		public function set lines(value:int):void{
			numLines = value;
			if(numLines <= 0) numLines = 1;
			var newRadius:Number = pointsHeight/numLines;
			if((newRadius/2)>startRadius){
				radius = startRadius;
			}else{
				radius = Math.floor(newRadius/2);
			}
			drawPoints();
		}
		private function drawPoints():void{
			clear();
			var i:int;
			var deltaH:Number = pointsHeight/numLines;
			for(i=0;i<numLines;i++){
				arrPoints.push(new OneCheckPoint(OneCheckPoint.DEFAULT_STATE, radius));
				super.addChild(arrPoints[i]);
				(arrPoints[i] as OneCheckPoint).x = (-1)*(radius+2);
				(arrPoints[i] as OneCheckPoint).y = (deltaH*i)+(3*deltaH/5);
			}
		}
		
		public function setAnswer(index:int,value:Boolean):void{
			if(index<arrPoints.length && index>=0){
				if(value) (arrPoints[index] as OneCheckPoint).state = OneCheckPoint.TRUE_STATE;
				else (arrPoints[index] as OneCheckPoint).state = OneCheckPoint.FALSE_STATE;
			}
		}
		public function setDefault(index:int):void{
			(arrPoints[index] as OneCheckPoint).state = OneCheckPoint.DEFAULT_STATE;
		}
		public function clear():void{
			while(arrPoints.length>0){
				if(super.contains(arrPoints[0])) super.removeChild(arrPoints[0]);
				arrPoints[0].clear();
				arrPoints.shift();
			}
		}

	}
	
}
