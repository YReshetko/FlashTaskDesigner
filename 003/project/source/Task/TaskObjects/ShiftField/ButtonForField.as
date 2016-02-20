package source.Task.TaskObjects.ShiftField {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ButtonForField extends Sprite{
		
		public static var REPLACE_LEFT:String = 'onReplaceLeft';
		public static var REPLACE_RIGHT:String = 'onReplaceRight';
		
		public static var REPLACE_TOP:String = 'onReplaceTop';
		public static var REPLACE_BOTTOM:String = 'onReplaceBottom';
		
		private var lButton:ArrowButtonForShiftLeft = new ArrowButtonForShiftLeft();
		private var rButton:ArrowButtonForShiftRight = new ArrowButtonForShiftRight();
		public function ButtonForField(type:String) {
			super();
			initButt();
			switch (type){
				case 'bottom':
				initBottomListeners();
				break;
				case 'right':
				initRightListeners();
				break;
			}
		}
		private function initButt():void{
			super.addChild(lButton);
			super.addChild(rButton);
			lButton.x = (-1) * lButton.width - 5;
			rButton.x = 5;
			
			lButton.y  = rButton.y = (-1) * (lButton.height/2);
		}
		private function initRightListeners():void{
			lButton.addEventListener(MouseEvent.MOUSE_DOWN, BOTT_BOTTOM_MD);
			rButton.addEventListener(MouseEvent.MOUSE_DOWN, BOTT_TOP_MD);
		}
		private function BOTT_BOTTOM_MD(event:MouseEvent):void{
			super.dispatchEvent(new Event(REPLACE_BOTTOM));
		}
		private function BOTT_TOP_MD(event:MouseEvent):void{
			super.dispatchEvent(new Event(REPLACE_TOP));
		}
		private function initBottomListeners():void{
			lButton.addEventListener(MouseEvent.MOUSE_DOWN, BOTT_LEFT_MD);
			rButton.addEventListener(MouseEvent.MOUSE_DOWN, BOTT_RIGHT_MD);
		}
		private function BOTT_LEFT_MD(event:MouseEvent):void{
			super.dispatchEvent(new Event(REPLACE_LEFT));
		}
		private function BOTT_RIGHT_MD(event:MouseEvent):void{
			super.dispatchEvent(new Event(REPLACE_RIGHT));
		}

	}
	
}
