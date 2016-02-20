package source.BlockOfTask.Task.TaskObjects.UserButton {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	//import source.Task.OneTask;
	import flash.events.Event;
	
	public class ControllerUserButton extends EventDispatcher{
		public static var GET_BUTTON_SETTINGS:String = 'onGetButtonSettings';
		private var arrButton:Array = new Array();
		private var container:Sprite;
		private var remSettings:Object;
		public function ControllerUserButton(container:Sprite) {
			super();
			this.container = container;
		}
		public function addButton(inXml:XMLList = null):void{
			var id:int = arrButton.length;
			arrButton.push(new MainUserButton(inXml, id+1, this.container));
			(arrButton[id] as MainUserButton).addEventListener(MainUserButton.CLICK_BUTTON, CLICK_BUTTON);
		}
		private function CLICK_BUTTON(event:Event):void{
			var i:int; 
			var l:int;
			l = arrButton.length;
			for(i=0;i<l;i++){
				if((arrButton[i] as MainUserButton)==(event.target as MainUserButton)){
					remSettings = (arrButton[i] as MainUserButton).buttonSettings;
					super.dispatchEvent(new Event(GET_BUTTON_SETTINGS));
					return;
				}
			}
		}
		public function get buttonSettings():Object{
			return remSettings;
		}
		//	Блок работы с анимацией
		public function startLabelAnimation(value:String):void{
			if(value == '') return;
			var i:int;
			var l:int;
			l = arrButton.length;
			for(i=0;i<l;i++){
				(arrButton[i] as MainUserButton).startLabelAnimation(value);
			}
		}
	}
	
}
