package source.utils.ColorPicker.addSettings {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PaintedObject extends Sprite{
		public static var OBJECT_SELECT:String = 'onObjectSelect';
		private var butLabel:*;
		private var objVariable:String;
		private var objColor:uint;
		private var objType:Boolean = true;
		public function PaintedObject(inXml:XML) {
			super();
			switch(inXml.@label.toString()){
				case 'line':
					butLabel = new PickerLine();
				break;
				case 'fill':
					butLabel = new PickerFill();
				break;
				case 'text':
					butLabel = new PickerText();
				break;
				default:
					objType = false;
					butLabel = new PickerOther();
					butLabel.label.text = inXml.@label.toString();
			}
			super.addChild(butLabel);
			butLabel.gotoAndStop(1);
			
			objVariable = inXml.@variable.toString();
			objColor = uint(inXml.toString());
			
			butLabel.addEventListener(MouseEvent.MOUSE_DOWN, BUT_MOUSE_DOWN);
		}
		private function BUT_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(OBJECT_SELECT));
		}
		public function set select(value:Boolean):void{
			if(value) butLabel.gotoAndStop(2);
			else butLabel.gotoAndStop(1);
		}
		public function get select():Boolean{
			if(butLabel.currentFrame == 2) return true;
			return false;
		}
		public function get variable():String{
			return objVariable;
		}
		public function get color():uint{
			return objColor;
		}
		public function set color(value:uint):void{
			objColor = value;
		}
		public function get type():Boolean{
			return objType;
		}
	}
	
}
