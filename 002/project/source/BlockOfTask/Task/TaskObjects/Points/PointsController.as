package source.BlockOfTask.Task.TaskObjects.Points {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	
	public class PointsController extends EventDispatcher{
		private var container:Sprite;
		private var labelAnimation:String = '';
		private var arrPoint:Array = new Array();
		public function PointsController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addPoint(xml:XMLList):void{
			trace(this + ': XML POINTS = ' + xml);
			var ID:int = arrPoint.length;
			arrPoint.push(new SystemPoint(xml, this.container));
			arrPoint[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			arrPoint[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as SystemPoint).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function CHECK_TASK(e:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get isDraw():Boolean{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(arrPoint[i].isDraw) return true;
			}
			return false;
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(!arrPoint[i].FullProverka()) return false;
			}
			return true;
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				(arrPoint[i] as SystemPoint).showAnswer();
			}
		}
	}
	
}
