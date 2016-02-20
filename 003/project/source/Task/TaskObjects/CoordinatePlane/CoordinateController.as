package source.Task.TaskObjects.CoordinatePlane {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	
	public class CoordinateController extends EventDispatcher{
		private var container:Sprite;
		private var arrPlane:Array = new Array();
		//private var remTarget
		public function CoordinateController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addPlane(xml:XMLList):void{
			var ID:int = arrPlane.length;
			arrPlane.push(new OnePlane(this.container, xml));
		}

	}
	
}
