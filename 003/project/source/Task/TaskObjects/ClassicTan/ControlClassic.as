package source.Task.TaskObjects.ClassicTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import source.Task.OneTask;
	import flash.events.Event;
	
	public class ControlClassic extends EventDispatcher{
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var arrSet:Array = new Array();
		private var remTarget:TanExample;
		public function ControlClassic(blackContainer:Sprite, colorContainer:Sprite) {
			super();
			this.blackContainer = blackContainer;
			this.colorContainer = colorContainer;
		}
		public function addTaskSets(inXml:XMLList):void{
			var currentXML:XMLList;
			for each(var sample:XML in inXml.SET){
				currentXML = new XMLList(sample);
				addSets(currentXML);
			}
		}
		public function addSets(inXml:XMLList = null):void{
			var str:String;
			var ID:int;
			ID = arrSet.length;
			arrSet.push(new OneSet(blackContainer, colorContainer, inXml));
			arrSet[ID].addEventListener(BaseTan.GET_SETTINGS, GET_SETTINGS);
			arrSet[ID].addEventListener(OneSet.REMOVE_SET, ON_REMOVE_SET);
			arrSet[ID].addEventListener(BaseTan.COPY_OBJECT, ON_COPY_OBJECT);
		}
		private function ON_REMOVE_SET(e:Event):void{
			var i:int;
			var l:int;
			l = arrSet.length;
			for(i=0;i<l;i++){
				if(arrSet[i].remove){
					arrSet[i].clear();
					arrSet[i].removeEventListener(BaseTan.GET_SETTINGS, GET_SETTINGS);
					arrSet[i].removeEventListener(OneSet.REMOVE_SET, ON_REMOVE_SET);
					arrSet[i].removeEventListener(BaseTan.COPY_OBJECT, ON_COPY_OBJECT);
					arrSet.splice(i,1);
					return;
				}
			}
		}
		private function GET_SETTINGS(e:Event):void{
			remTarget = e.target.remember;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():TanExample{
			return remTarget;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<CLASSIC/>');
			var addXml:XMLList;
			var i:int;
			var l:int;
			l = arrSet.length;
			for(i=0;i<l;i++){
				addXml = arrSet[i].listPosition;
				addXml.@id = (i+1).toString();
				outXml.appendChild(addXml);
			}
			return outXml;
		}
		public function ON_COPY_OBJECT(e:Event):void{
			var inXmlList:XMLList = e.target.listPosition;
			var i:int;
			var outXML:XMLList = new XMLList('<SET/>');
			for each (var sample:XML in inXmlList.TAN){
				//trace(this + ': COPY SAMPLE = ' + sample);
				sample.COLOR.X = parseFloat(sample.COLOR.X) + 20;
				sample.COLOR.Y = parseFloat(sample.COLOR.Y) + 20;
				sample.BLACK.X = parseFloat(sample.BLACK.X) + 20;
				sample.BLACK.Y = parseFloat(sample.BLACK.Y) + 20;
				outXML.appendChild(sample);
			}
			outXML.appendChild(inXmlList.TYPECOLOR);
			outXML.appendChild(inXmlList.TYPEBLACK);
			addSets(outXML);
		}
	}
}
