package source.Components {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Button extends Sprite{
		private var field:Label = new Label();
		private var wButton:Number = 100;
		private var hButton:Number = 20;
		private var fMask:Sprite = new Sprite
		
		private static var outColor:uint = 0xEDEDED;
		private static var overColor:uint = 0xA0A0A0;
		private static var downColor:uint = 0x6D6D6D;
		
		private var currentColor:uint;
		
		public function Button(label:String) {
			super();
			currentColor = outColor;
			field.text = label;
			initButton();
		}
		private function initButton():void{
			super.addChild(field);
			super.addChild(fMask);
			field.mask = fMask;
			drawButton();
			field.mouseEnabled = false;
			super.addEventListener(MouseEvent.MOUSE_OUT, MOUSE_OUT);
			super.addEventListener(MouseEvent.MOUSE_OVER, MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_UP, MOUSE_UP);
			super.addEventListener(MouseEvent.CLICK, CLICK);
		}
		
		
		private function MOUSE_OUT(event:MouseEvent):void{
			currentColor = outColor;
			drawButton();
		}
		private function MOUSE_OVER(event:MouseEvent):void{
			currentColor = overColor;
			drawButton();
		}
		private function MOUSE_DOWN(event:MouseEvent):void{
			currentColor = downColor;
			drawButton();
		}
		private function MOUSE_UP(event:MouseEvent):void{
			currentColor = overColor;
			drawButton();
		}
		private function CLICK(event:MouseEvent):void{
			super.dispatchEvent(new Event(COEvent.CLICK));
		}
		
		public function setSize(width:Number, height:Number):void{
			wButton = width;
			hButton = height;
			drawButton();
		}
		override public function set width(value:Number):void{
			wButton = value;
			drawButton();
		}
		override public function set height(value:Number):void{
			hButton = value;
			drawButton();
		}
		
		private function drawButton():void{
			super.graphics.clear();
			fMask.graphics.clear();
			super.graphics.lineStyle(1, 0xD0D0D0, 1);
			fMask.graphics.lineStyle(1, 0xD0D0D0, 1);
			super.graphics.beginFill(currentColor, 1);
			fMask.graphics.beginFill(currentColor, 1);
			super.graphics.drawRect(0, 0, wButton, hButton);
			fMask.graphics.drawRect(0, 0, wButton, hButton);
			super.graphics.endFill();
			fMask.graphics.endFill();
			if(field.width>wButton-4){
				field.x = 2;
			}else{
				field.x = (wButton-field.width)/2 + 2;
			}
		}
	}
	
}
