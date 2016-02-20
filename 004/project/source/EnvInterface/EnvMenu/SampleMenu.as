package source.EnvInterface.EnvMenu {
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.EnvEvents.Events;
	
	public class SampleMenu extends ListMenu{
		public static var OUT:String = 'butOut';
		public static var OVER:String = 'butOver';
		public static var DOWN:String = 'butDown';
		
		private static var linkSize:int = 13;
		private static var linkColor:uint = 0x000000;
		private static var linkFont:String = 'Arial';
		
		private var field:TextField;
		private var buttonContainer:Sprite = new Sprite();
		
		private var butWidth:int;
		private var butHeight:int;
		
		public var butStatus:String;
		public function SampleMenu(nameMenu:String) {
			super();
			initField();
			field.text = nameMenu;
			butStatus = OUT;
			initButton();
		}
		private function initField():void{
			field = new TextField();
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = linkFont;
			fieldFormat.size = linkSize;
			field.textColor = linkColor;
			field.defaultTextFormat = fieldFormat;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.mouseEnabled = false;
		}
		private function initButton():void{
			butWidth = field.width+2;
			butHeight = field.height+1
			Figure.insertRect(buttonContainer, butWidth, butHeight, 1, 0, 0x000000, 0);
			buttonContainer.addChild(field);
			field.x = (buttonContainer.width - field.width)/2;
			field.y = (buttonContainer.height - field.height)/2;
			super.addChild(buttonContainer);
			buttonContainer.y = (Menu.MENU_HEIGHT - buttonContainer.height)/2;
			buttonContainer.addEventListener(MouseEvent.ROLL_OUT, BUT_ROLL_OUT);
			buttonContainer.addEventListener(MouseEvent.ROLL_OVER, BUT_ROLL_OVER);
			buttonContainer.addEventListener(MouseEvent.MOUSE_DOWN, BUT_MOUSE_DOWN);
		}
		private function dispatchStatus():void{
			super.dispatchEvent(new Event(Events.MENU_CHANGE_STATUS));
		}
		private function BUT_ROLL_OUT(e:MouseEvent):void{
			butStatus = OUT;
			dispatchStatus();
		}
		private function BUT_ROLL_OVER(e:MouseEvent):void{
			butStatus = OVER;
			dispatchStatus();
		}
		private function BUT_MOUSE_DOWN(e:MouseEvent):void{
			butStatus = DOWN;
			dispatchStatus();
		}
		public function getWidthBut():int{
			return butWidth;
		}
		public function setStatus(inStatus:String):void{
			butStatus = inStatus;
			super.activList(false);
			switch(inStatus){
				case OUT:
					Figure.insertRect(buttonContainer, butWidth, butHeight, 1, 0, 0x000000, 0);
				break;
				case OVER:
					Figure.insertRect(buttonContainer, butWidth, butHeight, 1, 1, 0x6D6D6D, 1, 0xA6A6A6);
				break;
				case DOWN:
					Figure.insertRect(buttonContainer, butWidth, butHeight, 1, 1, 0xA6A6A6, 1, 0x6D6D6D);
					super.activList(true);
				break;
				default:
				trace(this+": STATUS OUT statusSpace");
				Figure.insertRect(buttonContainer, butWidth, butHeight, 1, 0, 0x000000, 0);
			}
		}
	}
	
}
