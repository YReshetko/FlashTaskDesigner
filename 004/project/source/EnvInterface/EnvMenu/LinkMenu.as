package source.EnvInterface.EnvMenu {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvEvents.Events;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class LinkMenu extends Sprite{
		public static var LINK_HEIGHT:int = 18;
		
		private static var linkSize:int = 12;
		private static var linkColor:uint = 0x000000;
		private static var linkFont:String = 'Arial';
		
		private var field:TextField;
		private var type:String;
		private var linkWidth:Number;
		public var dispatchStatus:String;
		public function LinkMenu(inLabel:String, dispatchStatus:String) {
			super();
			this.dispatchStatus = dispatchStatus;
			initField();
			field.text = inLabel;
			initBackground();
			initHandler();
		}
		private function initBackground():void{
			linkWidth = field.width+20;
			Figure.insertRect(super, linkWidth, LINK_HEIGHT, 1, 0, 0x000000, 1, 0xFFFFFF);
		}
		private function initField():void{
			field = new TextField();
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = linkFont;
			fieldFormat.size = linkSize;
			field.textColor = linkColor;
			//field.border = true;
			field.defaultTextFormat = fieldFormat;
			super.addChild(field);
			field.autoSize = TextFieldAutoSize.LEFT;
			field.mouseEnabled = false;
			field.x = 20;
		}
		public function getWidth():Number{
			return linkWidth;
		}
		public function setWidth(w:Number):void{
			linkWidth = w;
			Figure.insertRect(super, linkWidth, LINK_HEIGHT, 1, 0, 0x000000, 1, 0xFFFFFF);
		}
		private function initHandler():void{
			super.addEventListener(MouseEvent.ROLL_OUT, LINK_ROLL_OUT);
			super.addEventListener(MouseEvent.ROLL_OVER, LINK_ROLL_OVER);
			super.addEventListener(MouseEvent.MOUSE_DOWN, LINK_MOUSE_DOWN);
		}
		private function LINK_ROLL_OUT(e:MouseEvent):void{
			Figure.insertRect(super, linkWidth, LINK_HEIGHT, 1, 0, 0x000000, 1, 0xFFFFFF);
			changeColorText(0x000000);
		}
		private function LINK_ROLL_OVER(e:MouseEvent):void{
			Figure.insertRect(super, linkWidth, LINK_HEIGHT, 1, 0, 0x000000, 1, 0x0000FF);
			changeColorText(0xFFFFFF);
		}
		private function changeColorText(color:uint):void{
			field.textColor = color;
		}
		private function LINK_MOUSE_DOWN(e:MouseEvent):void{
			//trace(this + ": LINK MOUSE DOWN");
			super.dispatchEvent(new Event(Events.LINK_DISPATCH_STATUS));
		}
	}
	
}
