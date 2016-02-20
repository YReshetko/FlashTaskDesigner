package source.BlockOfTask.Task.TaskObjects.ShiftField {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.PlayerLib.Library;
	import source.BlockOfTask.Task.SeparatTask;
	
	public class ShiftFieldController extends EventDispatcher{
		private var container:Sprite;
		private var arrShiftField:Array = new Array();
		private var library:Library;
		public function ShiftFieldController(value:Sprite, library:Library) {
			super();
			container = value;
			this.library = library;
		}
		public function addShiftField(value:XMLList = null):void{
			var ID:int = arrShiftField.length;
			arrShiftField.push(new OneShiftField(container, value, this.library));
			arrShiftField[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
		}
		private function CHECK_TASK(event:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrShiftField.length;
			for(i=0;i<l;i++){
				if(!arrShiftField[i].complate) return false;
			}
			return true;
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrShiftField.length;
			for(i=0;i<l;i++){
				(arrShiftField[i] as OneShiftField).showAnswer();
			}
		}
		
	}
	
}
