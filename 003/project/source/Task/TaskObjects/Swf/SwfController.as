package source.Task.TaskObjects.Swf {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import source.Task.OneTask;
	
	public class SwfController extends EventDispatcher{
		
		private var swfContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var arrSwf:Array = new Array();
		private var remTarget:*;
		public function SwfController(swfCont:Sprite, color:Sprite, black:Sprite) {
			super();
			this.swfContainer = swfCont;
			this.colorContainer = color;
			this.blackContainer = black;
		}
		public function addSwf(xml:XMLList, byteArray:ByteArray, content:Array = null):void{
			var ID:int = arrSwf.length;
			arrSwf.push(new LoadSwf(xml, this.swfContainer, this.colorContainer, this.blackContainer));
			if(content!=null) arrSwf[ID].data = content;
			arrSwf[ID].content = byteArray;
			arrSwf[ID].addEventListener(SwfObject.GET_SETTINGS, PUSH_SETTINGS);
            arrSwf[ID].addEventListener(SwfObject.GET_MODULE_SETTINGS, PUSH_MODULE_SETTINGS);
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as LoadSwf;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
        private function  PUSH_MODULE_SETTINGS(e:Event):void{
            var target:LoadSwf = e.target as LoadSwf;
            remTarget = target.innerObject;
            super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
        }
		public function get remember():*{
			return remTarget;
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrSwf.length;
			for(i=0;i<l;i++){
				outArr.push(arrSwf[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
		public function get content():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrSwf.length;
			for(i=0;i<l;i++){
				outArr.push([arrSwf[i].name, arrSwf[i].content]);
			}
			return outArr;
		}
		
		public function setImage(value:Object):Boolean{
			var i:int;
			var l:int;
			l = arrSwf.length;
			for(i=0;i<l;i++){
				if(arrSwf[i].type == 'ModulSWF'){
					try{
						arrSwf[i].image = value;
						return true;
					}catch(e:Error) {trace(this + ': Произошла ошибка добавления контента')}
				}
			}
			return false;
		}
	}
}
