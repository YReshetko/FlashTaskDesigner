package source.Task.TaskObjects.UserButton {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.OneTask;
	import flash.events.Event;
	
	public class ControllerUserButton extends EventDispatcher{
		private var arrButton:Array = new Array();
		private var container:Sprite;
		private var remTarget:MainUserButton;
		public function ControllerUserButton(container:Sprite) {
			super();
			this.container = container;
		}
		public function addButton(inXml:XMLList = null):void{
			var id:int = arrButton.length;
			arrButton.push(new MainUserButton(inXml, id+1, this.container));
			(arrButton[id] as OneUserButton).addEventListener(OneUserButton.GET_SETTINGS, PUSH_SETTINGS);
			(arrButton[id] as OneUserButton).addEventListener(OneUserButton.COPY_OBJECT, COPY_OBJECT);
			(arrButton[id] as OneUserButton).addEventListener(OneUserButton.REMOVE_OBJECT, REMOVE_OBJECT);
		}
		private function PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as MainUserButton;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function COPY_OBJECT(event:Event):void{
			var list:XMLList = (event.target as OneUserButton).listPosition;
			list.@x = parseFloat(list.@x) + 10;
			list.@y = parseFloat(list.@y) + 10;
			this.addButton(list);
		}
		private function REMOVE_OBJECT(event:Event):void{
			var i:int;
			var l:int;
			l = this.arrButton.length;
			for(i=0;i<l;i++){
				if((arrButton[i] as OneUserButton)==(event.target as OneUserButton)){
					this.container.removeChild(arrButton[i]);
					arrButton.splice(i, 1);
					return;
				}
			}
		}
		public function get remember():MainUserButton{
			return remTarget;
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrButton.length;
			for(i=0;i<l;i++){
				outArr.push(arrButton[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
	}
	
}
