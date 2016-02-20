package source.BlockOfTask.Task.TaskObjects.Line {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	
	public class LineController extends EventDispatcher{
		private var container:Sprite;
		private var arrLine:Array = new Array();
		public function LineController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addLine(xml:XMLList):void{
			arrLine.push(new OneLine(xml, this.container));
		}

	}
	
}
