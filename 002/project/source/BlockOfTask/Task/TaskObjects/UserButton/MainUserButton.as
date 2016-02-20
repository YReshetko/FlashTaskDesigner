package source.BlockOfTask.Task.TaskObjects.UserButton {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class MainUserButton extends OneUserButton{
		public static var CLICK_BUTTON:String = 'onClickButton';
		
		private var asDontKnow:Boolean = false;
		private var asRestart:Boolean = false;
		private var asUnderstand:Boolean = false;
		private var asCheck:Boolean = false;
		
		private var asGoToTask:Number = 0;
		private var startAnimation:String = '';
		
		private var asTrue:Boolean = false;
		private var asFalse:Boolean = false;
		
		public function MainUserButton(xml:XMLList, id:int, container:Sprite) {
			super(xml, id, container);
			applySettings(xml);
			super.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
		}
		private function applySettings(xml:XMLList):void{
			if(xml.USEAS.@button.toString()!=''){
				switch (xml.USEAS.@button.toString()){
					case "dontKnow": asDontKnow = true; break;
					case "restart": asRestart = true; break;
					case "understand": asUnderstand = true; break;
					case "check": asCheck = true; break;
				}
			}
			if(xml.GOTOTASK.@id.toString()!='') asGoToTask = parseInt(xml.GOTOTASK.@id.toString());
			if(xml.STARTANIMATION.@mark.toString()!='') startAnimation = xml.STARTANIMATION.@mark.toString();
			
			if(xml.COMPLATE.@task.toString()!=''){
				switch (xml.COMPLATE.@task.toString()){
					case "true": asTrue = true; break;
					case "false": asFalse = true; break;
				}
			}
		}
		private function BUTTON_MOUSE_DOWN(event:MouseEvent):void{
			super.dispatchEvent(new Event(CLICK_BUTTON));
		}
		
		public function get buttonSettings():Object{
			var outObject:Object = new Object();
			outObject.dontKnow = asDontKnow;
			outObject.restart = asRestart;
			outObject.understand = asUnderstand;
			outObject.check = asCheck;
			outObject.gotoTask = asGoToTask;
			outObject.startAnimation = startAnimation;
			outObject.asTrue = asTrue;
			outObject.asFalse = asFalse;
			return outObject;
		}
	}
	
}
