package source.Task.TaskObjects.ShiftField {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.OneTask;
	import flash.events.Event;
	
	public class ShiftFieldController extends EventDispatcher{
		private var container:Sprite;
		private var arrShiftField:Array = new Array();
		private var remTarget:OneShiftField;
		public function ShiftFieldController(value:Sprite) {
			super();
			container = value;
		}
		public function addShiftField(value:XMLList = null):void{
			var ID:int = arrShiftField.length;
			arrShiftField.push(new OneShiftField(container, value));
			arrShiftField[ID].addEventListener(OneShiftField.GET_SETTINGS, PUSH_SETTINGS);
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as OneShiftField;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():OneShiftField{
			return remTarget;
		}
		public function set child(value:*):void{
			var remSprite:Sprite = value.tanColor;
			var i:int;
			var l:int;
			l = arrShiftField.length;
			for(i=0;i<l;i++){
				if(remSprite.hitTestObject(arrShiftField[i])){
					(arrShiftField[i] as OneShiftField).child = value;
					return;
				}
			}
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrShiftField.length;
			for(i=0;i<l;i++){
				outArr.push(arrShiftField[i].listPosition);
				outArr[i].@id = i;
			}
			return outArr;
		}

	}
	
}
