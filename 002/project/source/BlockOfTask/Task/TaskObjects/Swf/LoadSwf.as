package source.BlockOfTask.Task.TaskObjects.Swf {
	import flash.display.Sprite
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.system.LoaderContext;

	public class LoadSwf extends SwfObject{
		private var myXML:XMLList;
		private var fileName:String;
		private var currentID:int;
		private var currentByteArray:ByteArray;
		private var arrContent:Array;
		public function LoadSwf(xml:XMLList, swfCont:Sprite, colorCont:Sprite, blackCont:Sprite, flashFiles:String) {
			super(swfCont, colorCont, blackCont);
			super.pathFile = flashFiles;
			myXML = xml;
			fileName = xml.NAME.toString();
		}
		public function set content(value:ByteArray):void{
			currentID = -1;
			currentByteArray = value;
			arrContent = new Array();
			startLoad();
		}
		private function startLoad():void{
			++currentID;
			if(currentID==3){
				super.addObject(arrContent, "");
				super.setParametrs(myXML);
			}else{
				var loader:Loader = new Loader();
				var context:LoaderContext = new LoaderContext();
				context.allowCodeImport = true;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, CONTENT_LOAD_COMPLATE);
				loader.loadBytes(currentByteArray, context);
			}
		}
		private function CONTENT_LOAD_COMPLATE(e:Event):void{
			arrContent.push(e.target.content);
			startLoad();
		}
		public function get name():String{
			return fileName;
		}
	}
}