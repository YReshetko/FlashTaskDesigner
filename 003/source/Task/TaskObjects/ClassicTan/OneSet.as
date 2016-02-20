package source.Task.TaskObjects.ClassicTan {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import source.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import flash.events.Event;
	import source.utils.DefaultTanSettings;
	
	public class OneSet extends EventDispatcher{
		public static var REMOVE_SET:String = 'onRemoveSet';
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var arrTan:Array = new Array();
		private var remTarget:TanExample;
		private var isDelete:Boolean = false;
		public function OneSet(blackContainer:Sprite, colorContainer:Sprite, inXML:XMLList = null) {
			super();
			this.blackContainer = blackContainer;
			this.colorContainer = colorContainer;
			addSetTan(inXML);
		}
		private function addSetTan(inXML:XMLList = null):void{
			trace(this + ': IN SET XML = ' + inXML);
			var i:int;
			for(i=0;i<7;i++){
				arrTan.push(new TanExample((i+1),this.blackContainer, this.colorContainer));
				arrTan[i].addEventListener(BaseTan.GET_SETTINGS, GET_SETTINGS);
				arrTan[i].addEventListener(BaseTan.REMOVE_TAN, ON_REMOVE_TAN);
				arrTan[i].addEventListener(BaseTan.COPY_OBJECT, ON_COPY_SET);
			}
			addSettings(inXML);
		}
		private function ON_REMOVE_TAN(e:Event):void{
			isDelete = true;
			super.dispatchEvent(new Event(REMOVE_SET));
		}
		public function get remove():Boolean{
			return isDelete;
		}
		public function clear():void{
			while(arrTan.length>0){
				arrTan[0].clear();
				arrTan[0].removeEventListener(BaseTan.GET_SETTINGS, GET_SETTINGS);
				arrTan[0].removeEventListener(BaseTan.REMOVE_TAN, ON_REMOVE_TAN);
				arrTan[0].removeEventListener(BaseTan.COPY_OBJECT, ON_COPY_SET);
				arrTan.shift();
			}
		}
		private function addSettings(value:XMLList = null):void{
			var inXml:XMLList;
			if(value != null) inXml = value;
			else inXml = DefaultTanSettings.settings;
			
			var str:String;
			var ID:int;
			for each(var sample:XML in inXml.elements()){
				str = sample.name().toString();
				if(str == 'TAN'){
					ID = (parseInt(sample.@id)-1);
					arrTan[ID].settings = new XMLList(sample);
				}
			}
			if(inXml.TYPECOLOR.toString()!='' && inXml.TYPEBLACK.toString()!=''){
				trace(this + ': COLOR TYPE = ' + parseInt(inXml.TYPECOLOR))
				arrTan[5].typeC = parseInt(inXml.TYPECOLOR);
				trace(this + ': BLACK TYPE = ' + parseInt(inXml.TYPEBLACK))
				arrTan[5].typeB = parseInt(inXml.TYPEBLACK);
			}
			//correctSize();
		}
		private function GET_SETTINGS(e:Event):void{
			remTarget = e.target as TanExample;
			super.dispatchEvent(new Event(BaseTan.GET_SETTINGS));
		}
		public function get remember():TanExample{
			return remTarget;
		}
		
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<SET/>');
			var i:int;
			for(i=0;i<7;i++){
				outXml.appendChild(arrTan[i].listPosition);
			}
			outXml.TYPECOLOR = arrTan[5].typeC;
			outXml.TYPEBLACK = arrTan[5].typeB;
			return outXml;
		}
		
		private function ON_COPY_SET(e:Event):void{
			super.dispatchEvent(new Event(BaseTan.COPY_OBJECT));
		}
	}
	
}
