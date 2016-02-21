package source.Utilites {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	
	public class SettingPanel extends Sprite{
		private static const deltaX:int = 6;
		private static const deltaY:int = 6;
		private static const HWButton:int = 10;
		private static const HPlane:int = 18;
		
		private var dragPlain:Sprite = new Sprite;
		private var minimazeButton:Sprite = new Sprite;
		private var functionalSprite:Sprite = new Sprite;
		public function SettingPanel() {
			super();
			drawButton();
		}
		private function drawButton(){
			minimazeButton.graphics.lineStyle(1, 0x000000,1);
			minimazeButton.graphics.beginFill(0x969696, 1);
			minimazeButton.graphics.drawRect(0,0,HWButton,HWButton);
			minimazeButton.graphics.endFill();
			minimazeButton.graphics.lineStyle(2, 0x000000, 1);
			minimazeButton.graphics.moveTo(3, 2*(HWButton/3));
			minimazeButton.graphics.lineTo(HWButton-3, 2*(HWButton/3));
		}
		private function drawPlain(Width:int,str:String){
			dragPlain.graphics.lineStyle(1, 0x000000,1);
			dragPlain.graphics.beginFill(0x636363, 1);
			dragPlain.graphics.drawRect(0,0,Width,HPlane);
			dragPlain.graphics.endFill();
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			field.autoSize = TextFieldAutoSize.LEFT;
			textFormat.size = 12;
			field.textColor = parseInt("0xFFFFFF");
			field.text = str;
			field.setTextFormat(textFormat);
			dragPlain.addChild(field);
			field.x = 5;
			field.mouseEnabled = false;
		}
		private function drawMainSprite(Width:int, Height:int){
			functionalSprite.graphics.lineStyle(1, 0x000000,1);
			functionalSprite.graphics.beginFill(0xA6A6A6, 1);
			functionalSprite.graphics.drawRect(0,0,Width,Height);
			functionalSprite.graphics.endFill();
		}
		public function setSprite(str:String, spr:Sprite){
			drawPlain(spr.width + deltaX,str);
			drawMainSprite(spr.width + deltaX, spr.height + deltaY);
			initSprites();
			functionalSprite.addChild(spr);
			spr.x = deltaX/2;
			spr.y = deltaY/2;
			initHandler();
		}
		private function initSprites(){
			this.addChild(dragPlain);
			this.addChild(functionalSprite);
			this.addChild(minimazeButton);
			functionalSprite.y = HPlane;
			minimazeButton.y = (HPlane - HWButton)/2;
			minimazeButton.x = dragPlain.width - HWButton - 5;
		}
		private function initHandler(){
			minimazeButton.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			dragPlain.addEventListener(MouseEvent.MOUSE_DOWN, PLAIN_MOUSE_DOWN);
			dragPlain.addEventListener(MouseEvent.MOUSE_UP, PLAIN_MOUSE_UP);
		}
		private function BUTTON_MOUSE_DOWN(e:MouseEvent){
			functionalSprite.visible = !functionalSprite.visible;
		}
		private function PLAIN_MOUSE_DOWN(e:MouseEvent){
			this.startDrag();
			super.parent.setChildIndex(super, super.parent.numChildren - 1);
		}
		private function PLAIN_MOUSE_UP(e:MouseEvent){
			this.stopDrag();
		}
		public function closeDragPanel(){
			dragPlain.visible = false;
			minimazeButton.visible = false;
		}
	}
	
}
