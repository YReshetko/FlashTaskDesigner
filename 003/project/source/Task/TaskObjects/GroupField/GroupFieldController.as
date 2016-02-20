package source.Task.TaskObjects.GroupField {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	
	public class GroupFieldController extends EventDispatcher{
		private var groupFieldArr:Array = new Array();
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var remTarget:*;
		public function GroupFieldController(ColorContainer:Sprite, BlackContainer:Sprite) {
			super();
			this.colorContainer = ColorContainer;
			this.blackContainer = BlackContainer;
		}
		public function addGroupField(xml:XMLList, content:Array = null):void{
			var ID:int = groupFieldArr.length;
			groupFieldArr.push(new OneGroupField(xml, colorContainer, blackContainer, content));
			groupFieldArr[ID].addEventListener(GroupFieldModel.GET_SETTINGS, PUSH_SETTINGS);
			groupFieldArr[ID].addEventListener(GroupFieldModel.GET_SETTINGS_IN_OBJECT, PUSH_SETTINGS_IN_OBJECT);
			groupFieldArr[ID].addEventListener(BaseTan.REMOVE_TAN, REMOVE_OBJECT);
		}
		private function PUSH_SETTINGS(event:Event):void{
			remTarget = event.target as OneGroupField;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function PUSH_SETTINGS_IN_OBJECT(event:Event):void{
			remTarget = event.target.remember;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():*{
			return remTarget;
		}
		public function set child(value:*):void{
			var remSprite:Sprite = value.tanColor;
			var i:int;
			var l:int;
			var inXml:XMLList;
			var content:*;
			var name:String;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				if(remSprite.hitTestObject(groupFieldArr[i].tanColor)){
					inXml = value.listPosition;
					content = value.content;
					name = value.fileName;
					switch (inXml.name().toString()){
						case 'PICTURETAN':
						case 'USERTAN':
							inXml.BLACK.X = inXml.COLOR.X = groupFieldArr[i].width/2;
							inXml.BLACK.Y = inXml.COLOR.Y = groupFieldArr[i].height/2;
						break;
						case 'LABEL':
							inXml.X = 1;
							inXml.Y = 1;
						break;
					}
					groupFieldArr[i].xml(inXml, content, name);
					value.removeTan();
					return;
				}
			}
		}
		
		private function REMOVE_OBJECT(event:Event):void{
			var i:int;
			var l:int;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				if(event.target == groupFieldArr[i]){
					groupFieldArr[i].removeEventListener(GroupFieldModel.GET_SETTINGS, PUSH_SETTINGS);
					groupFieldArr[i].removeEventListener(GroupFieldModel.GET_SETTINGS_IN_OBJECT, PUSH_SETTINGS_IN_OBJECT);
					groupFieldArr[i].removeEventListener(BaseTan.REMOVE_TAN, REMOVE_OBJECT);
					groupFieldArr[i].clear();
					groupFieldArr.splice(i,1);
				}
			}
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				outArr.push(groupFieldArr[i].listPosition);
			}
			return outArr;
		}
		public function get isCorrectPosition():Boolean{
			var i:int;
			var l:int;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				if(!groupFieldArr[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				groupFieldArr[i].normalizePosition();
			}
		}
	}
	
}
