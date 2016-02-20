package source.Components {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ButtonMark extends Sprite{
		public static var OPEN:String = 'onOpen';
		public static var CLOSE:String = 'onClose';
		
		private static const inColor:uint = 0xE6E6E6;
		private static const outColor:uint = 0xD0D0D0;
		
		private var currentColor:uint = 0xD0D0D0;
		
		private var isSelect:Boolean = false;
		
		private var wMark:Number = 0;
		private var hMark:Number = 0;
		
		private var label:Label;
		public function ButtonMark(value:String = '') {
			super();
			text = value;
		}
		public function set text(value:String):void{
			if(value=='') return;
			label = new Label();
			label.fieldSize = 10;
			label.text = value;
			wMark = label.width;
			hMark = label.height;
			super.addChild(label);
			label.x = hMark/2;
			super.mouseChildren = false;
			draw();
			initHandler();
		}
		private function draw():void{
			super.graphics.clear();
			super.graphics.lineStyle(0.1, 0x666666, 0.7, true);
			super.graphics.beginFill(currentColor, 1);
			super.graphics.drawCircle(hMark/2, hMark/2, hMark/2);
			super.graphics.drawCircle(hMark/2+wMark, hMark/2, hMark/2);
			super.graphics.endFill();
			super.graphics.beginFill(currentColor, 1);
			super.graphics.lineStyle(0.1, 0x666666, 0.7, true);
			super.graphics.moveTo(hMark/2, 0);
			super.graphics.lineTo(hMark/2+wMark, 0);
			super.graphics.lineStyle(0.1, 0x666666, 0, true);
			super.graphics.lineTo(hMark/2+wMark, hMark);
			super.graphics.lineStyle(0.1, 0x666666, 0.7, true);
			super.graphics.lineTo(hMark/2, hMark);
			super.graphics.lineStyle(0.1, 0x666666, 0, true);
			super.graphics.lineTo(hMark/2, 0);
			super.graphics.endFill();
		}
		
		private function initHandler():void{
			super.addEventListener(MouseEvent.CLICK, MARK_CLICK);
		}
		
		private function MARK_CLICK(event:MouseEvent):void{
			select = !select;
		}
		
		public function set select(value:Boolean):void{
			if(isSelect == value) return;
			isSelect = value;
			if(value) currentColor = inColor;
			else currentColor = outColor;
			this.draw();
			if(value) super.dispatchEvent(new Event(OPEN));
			else super.dispatchEvent(new Event(CLOSE));
		}
		public function get select():Boolean{
			return isSelect;
		}
		
		override public function set width(value:Number):void{
			wMark = value;
			draw();
		}
		override public function get width():Number{
			return this.label.width;
		}
		override public function set height(value:Number):void{
			hMark = value;
			draw();
		}
		override public function get height():Number{
			return this.label.height;
		}

	}
	
}
