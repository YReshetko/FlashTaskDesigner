package source.Task.TaskTree {
	
	public class PositionSample extends ProbabPositionTask{
		private var levelPosition:int = 0;
		public function PositionSample() {
			super();
		}
		public function set select(value:Boolean):void{
			if(value) super.gotoAndStop(2);
			else super.gotoAndStop(1);
		}
		public function get select():Boolean{
			if(super.currentFrame == 2) return true;
			return false;
		}
		public function set level(value:int):void{
			levelPosition = value;
		}
		public function get level():int{
			return levelPosition;
		}
	}
	
}
