package source.BlockOfTask.Task.TaskObjects.PaintPicture {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.PlayerLib.Library;
	
	public class PaintMainController extends EventDispatcher{
		private var container:Sprite;
		private var arrPaints:Array = new Array();
		private var remTarget:PaintView;
		private var library:Library;
		public function PaintMainController(container:Sprite, lib:Library) {
			super();
			library = lib;
			this.container = container;
		}
		
		public function addPaint(xml:XMLList):void{
			var ID:int = arrPaints.length;
			arrPaints.push(new PaintObjectController(xml, this.container));
			if(xml.BACKGROUNDFILENAME.toString()!='') (arrPaints[ID] as PaintObjectController).setChild(library.getFile(xml.BACKGROUNDFILENAME.toString()));
		}
		

	}
	
}
