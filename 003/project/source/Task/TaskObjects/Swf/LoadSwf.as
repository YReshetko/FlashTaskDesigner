package source.Task.TaskObjects.Swf {
	import flash.display.Sprite
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.system.LoaderContext;

	public class LoadSwf extends SwfObject{
		private var myXML:XMLList;
		private var fileName:String;
		private var remByteArr:ByteArray;
		private var arrData:Array;
		public function LoadSwf(xml:XMLList, swfCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			super(swfCont, colorCont, blackCont);
			myXML = xml;
			fileName = xml.NAME.toString();
		}
		public function set data(value:Array):void{
			arrData = value;
		}
		public function set content(value:ByteArray):void{
			remByteArr = value;
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			loader.contentLoaderInfo.addEventListener(Event.INIT, LOAD_PICTURE_COMPLATE);
			loader.loadBytes(value, context);
			
		}
		private function LOAD_PICTURE_COMPLATE(e:Event):void{
			//trace(this + ': LOAD BYTES INIT = ' + e.target.content);
			super.addObject(e.target.content, fileName);
			super.setParametrs(myXML);
			if(arrData!=null) super.setDessigned(myXML.SETTINGS, arrData);
		}
		public function get listSettings():XMLList{
			if(super.type == 'TanSWF') return super.hardList;
			return super.simpleList;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<SWFOBJECT/>');
			outXml.TYPE = super.type;
			outXml.NAME = this.fileName;
			if(super.type == 'TanSWF'){
				outXml.XBLACK = super.blackX;
				outXml.YBLACK = super.blackY;
				outXml.XCOLOR = super.colorX;
				outXml.YCOLOR = super.colorY;
				outXml.STOP = super.stopFrame;
				outXml.PLAYAFTERPOS = super.playAfterPos;
				outXml.PLAYAFTERTASK = super.playAfterTask;
				outXml.METHODAFTERPOS = super.methodAfterPos;
				outXml.METHODAFTERTASK = super.methodAfterTask;
				outXml.WIDTH = super.width;
				outXml.HEIGHT = super.height;
				outXml.ALPHA = super.Alpha
			}else{
				outXml.X = super.X;
				outXml.Y = super.Y;
			}
			outXml.appendChild(new XML('<SHOWING action="false" />'));
			outXml.appendChild(new XML('<VANISHING action="false" />'));
			if(super.type == 'ModulSWF'){
				var settingsXml:XMLList = new XMLList('<SETTINGS/>');
				settingsXml.appendChild(new XMLList(super.modulSettings));
				outXml.appendChild(settingsXml);
			}
			return outXml;
		}
		public function get content():ByteArray{
			return remByteArr;
		}
		public function get name():String{
			return this.fileName;
		}
	}
}