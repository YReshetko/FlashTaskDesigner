package source.Task.TaskSettings.SamplePanel {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PanelLock extends Sprite{
		public static var GET_LOCK_PROPERTY:String = 'onGetLockProperty';
		private var lockLabel:MovieClip;
		
		private var lockVar:String = '';
		private var lockData:Boolean;
		private var lockPosition:Number = 0;
		public function PanelLock(inXml:XML) {
			super();
			lockVar = inXml.@variable.toString();
			lockLabel = new SizeLock();
			super.addChild(lockLabel);
			lockLabel.gotoAndStop(1);
			this.property = inXml.toString()=='true';
			lockLabel.addEventListener(MouseEvent.CLICK, LOCK_CLICK);
		}
		public function set property(value:Boolean):void{
			lockData = value;
			if(value){
				lockLabel.gotoAndStop(1);
			}else{
				lockLabel.gotoAndStop(2);
			}
		}
		public function get property():Boolean{
			return lockData;
		}
		public function get variable():String{
			return lockVar;
		}
		private function LOCK_CLICK(event:MouseEvent):void{
			this.property = !this.property;
			super.dispatchEvent(new Event(GET_LOCK_PROPERTY));
		}
	}
	
}
