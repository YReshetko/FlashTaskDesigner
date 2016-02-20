package source.Task.TaskObjects.PaintPicture {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;

	public class PaintObjectController extends EventDispatcher{
		private var view:PaintViewPanel;
		public function PaintObjectController(xml:XMLList, container:Sprite) {
			super();
			view = new PaintViewPanel();
			container.addChild(view);
			initPanel(xml);
			view.addEventListener(PaintView.GET_SETTINGS, PUSH_SETTINGS);
		}
		private function initPanel(xml:XMLList):void{
			
			view.drawPanel(parseFloat(xml.WIDTH), parseFloat(xml.HEIGHT));
			view.x = parseFloat(xml.X);
			view.y = parseFloat(xml.Y);
			 
		}
		
		private function PUSH_SETTINGS(event:Event):void{
			super.dispatchEvent(new Event(PaintView.GET_SETTINGS));
		}
		public function get object():PaintView{
			return view as PaintView;
		}
		
		public function setChild(content:ByteArray, name:String):void{
			view.setBackgroundImage(content, name);
		}
		/*public function get authorImage():Array{
			return view.authorImage;
		}*/
		public function get authorBitmap():Bitmap{
			return view.authorBitmap;
		}
		public function get authorByteArray():ByteArray{
			return view.authorByteArray;
		}
		public function get authorFileName():String{
			return view.authorFileName;
		}
		public function get listPosition():XMLList{
			return view.listPosition;
		}

	}
	
}
