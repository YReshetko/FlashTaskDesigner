package source.BlockOfTask.Task.TaskObjects.PaintPicture {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;

	public class PaintObjectController extends EventDispatcher{
		private var view:PaintViewPanel;
		public function PaintObjectController(xml:XMLList, container:Sprite) {
			super();
			view = new PaintViewPanel();
			container.addChild(view);
			initPanel(xml);
		}
		private function initPanel(xml:XMLList):void{
			
			view.drawPanel(parseFloat(xml.WIDTH), parseFloat(xml.HEIGHT));
			view.x = parseFloat(xml.X);
			view.y = parseFloat(xml.Y);
			view.brushThink = parseFloat(xml.THICK.toString());
			for each(var sample:XML in xml.COLORES.COLOR){
				trace(this + 'COLOR = ' + sample);
				view.Color = uint(sample.text().toString());
			}
		}
		
		public function setChild(content:ByteArray):void{
			view.setBackgroundImage(content);
		}
	}
	
}
