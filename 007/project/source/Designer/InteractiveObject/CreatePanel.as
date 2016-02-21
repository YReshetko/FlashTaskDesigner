package source.Designer.InteractiveObject {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class CreatePanel extends Sprite{
		private static var wPanel:int = 120;
		private static var hPolosa:int = 10;
		private static var hPanel:int = 40;
		private static var wField:int = 40;
		private static var maxInput:int = 5;
		
		private var numCol:int;
		private var numLin:int;
		
		private var polosaSprite:Sprite = new Sprite;
		private var panelSprite:Sprite = new Sprite;
		
		private var fieldColumn:TextField = new TextField();
		private var fieldLine:TextField = new TextField();

		public function CreatePanel(numCol:int, numLin:int) {
			super();
			
			this.numCol = numCol;
			this.numLin = numCol;
			addPolosa();
			addPanel();
			addLabel(0, "Столбцы:");
			addLabel(20, "Строки:");
			addField(0, fieldColumn, numCol.toString());
			addField(20, fieldLine, numLin.toString());
			addListeners();
		}
		private function addPolosa(){
			polosaSprite.graphics.lineStyle(0.1,0x000000,1);
			polosaSprite.graphics.beginFill(0x333333,1);
			polosaSprite.graphics.drawRect(0,0,wPanel,hPolosa);
			polosaSprite.graphics.endFill();
			super.addChild(polosaSprite);
		}
		private function addPanel(){
			panelSprite.graphics.lineStyle(0.1,0x000000,1);
			panelSprite.graphics.beginFill(0x999999,1);
			panelSprite.graphics.drawRect(0,0,wPanel,hPanel);
			panelSprite.graphics.endFill();
			super.addChild(panelSprite);
			panelSprite.y = hPolosa;
		}
		private function addLabel(yLbl:int, nameLbl:String){
			var field:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			panelSprite.addChild(field);
			field.y = yLbl;
			field.text = nameLbl;
			textFormat.size = 14;
			textFormat.bold = true;
			field.setTextFormat(textFormat);
			field.width = field.textWidth + 10;
			field.height = field.textHeight + 10;
			field.border = false;
			field.background = false;
			field.mouseEnabled = false;
		}
		private function addField(yF:int, field:TextField, textDef:String){
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 14;
			textFormat.bold = true;
			field.restrict = "12345";
			field.maxChars = 1;
			field.border = true;
			field.background = true;
			field.type = TextFieldType.INPUT;
			field.text = textDef;
			field.setTextFormat(textFormat);
			panelSprite.addChild(field);
			field.width = wField;
			field.height = fieldColumn.textHeight+3;
			field.x = wPanel - wField - 3;
			field.y = yF;
		}
		private function addListeners(){
			polosaSprite.addEventListener(MouseEvent.MOUSE_DOWN, POLOSA_MOUSE_DOWN);
			polosaSprite.addEventListener(MouseEvent.MOUSE_UP, POLOSA_MOUSE_UP);
			
			fieldColumn.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			fieldLine.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
		}
		private function POLOSA_MOUSE_DOWN(e:MouseEvent){
			this.startDrag();
		}
		private function POLOSA_MOUSE_UP(e:MouseEvent){
			this.stopDrag();
		}
		private function FIELD_TEXT_INPUT(e:TextEvent){
			var TIMER:Timer = new Timer(10,1);
			TIMER.addEventListener(TimerEvent.TIMER, TIMER_EVENT);
			TIMER.start();
		}
		private function TIMER_EVENT(e:TimerEvent){
			if(numCol.toString() == fieldColumn.text && numLin.toString() == fieldLine.text){
				return
			}
			if(fieldColumn.text == "" || fieldLine.text == "")return;
			numCol = parseInt(fieldColumn.text);
			numLin = parseInt(fieldLine.text);
			super.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT));
		}
		
		public function getSettings():Array{
			return [numCol, numLin];
		}
	}
	
}
