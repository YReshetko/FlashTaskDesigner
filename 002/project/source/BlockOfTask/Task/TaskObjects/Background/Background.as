package source.BlockOfTask.Task.TaskObjects.Background {
	import flash.display.Sprite;
	import source.PlayerLib.Library;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.display.Bitmap;
	
	public class Background extends Sprite{

		public function Background(xml:XMLList, container:Sprite, lib:Library) {
			super();
			container.addChild(super);
			super.x = parseFloat(xml.X.toString());
			super.y = parseFloat(xml.Y.toString());
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, IMAGE_LOAD_COMPLATE);
			//trace(this + ': bmp content: ' + lib.getFile(xml.@image.toString()))
			loader.loadBytes(lib.getFile(xml.@image.toString()), context);
		}
		private function IMAGE_LOAD_COMPLATE(e:Event):void{
			var value:Bitmap = e.target.content;
			super.addChild(value);
		}

	}
	
}
