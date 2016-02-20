package source.BlockOfTask.PackageInfo {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	public class Info extends Sprite{
		public static var SHOW_ANSWER:String = "onShowAnswer";
		public static var BUG_REPORT:String = "onBugReport";
		
		private static const PASSWORD:String = "mpu";
		private var labelInfo:infoPackage = new infoPackage();
		private static const wInfo:int= 240;
		private static const hInfo:int = 100;
		private static const radius:int = 15;
		
		private var background:Sprite = new Sprite();
		private var maskBG:Sprite = new Sprite();
		
		private var typeLabel:TextField = new TextField();
		private var typeField:TextField = new TextField();
		
		private var inputPass:TextField = new TextField();
		private var showAnswerBut:ShowAnswer = new ShowAnswer();
		private var bugReport:BugReport = new BugReport();
		
		public function Info() {
			super();
			init();
		}
		private function init():void{
			background.graphics.lineStyle(1, 0xD6D6D6, 1);
			background.graphics.beginFill(0x666666, 1);
			background.graphics.drawRoundRect(0, 0, wInfo + radius, hInfo + radius, radius, radius);
			background.graphics.endFill();
			maskBG.graphics.lineStyle(1, 0, 1);
			maskBG.graphics.beginFill(0, 1);
			maskBG.graphics.drawRect(0, 0, wInfo, hInfo);
			maskBG.graphics.endFill();
			background.x = background.y = -1*radius + 6;
			background.mask = maskBG;
			background.addChild(typeLabel);
			background.addChild(typeField);
			
			background.addChild(inputPass);
			background.addChild(showAnswerBut);
			background.addChild(bugReport);
			inputPass.type = TextFieldType.INPUT;
			inputPass.border = true;
			inputPass.background = true;
			inputPass.displayAsPassword = true;
			inputPass.width = 70;
			inputPass.height = 20;
			
			maskBG.x = maskBG.y = 6;
			typeLabel.width = 3*(wInfo/7) - 10;
			typeLabel.height = hInfo - 30;
			typeField.width = 4*(wInfo/7) - 10;
			typeField.height = hInfo - 30;
			typeLabel.x = typeLabel.y = typeField.y = radius+5;
			typeField.x = typeLabel.x + typeLabel.width + radius+5;
			
			inputPass.x = 20
			showAnswerBut.x = 110;
			bugReport.x = showAnswerBut.x + showAnswerBut.width + 5;
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.bold = true;
			format.align = TextFormatAlign.RIGHT;
			typeLabel.defaultTextFormat = format;
			format.align = TextFormatAlign.LEFT;
			typeField.defaultTextFormat = format;
			typeLabel.mouseEnabled = typeField.mouseEnabled = false;
			typeLabel.text = 'Тип пакета:\nТип Выдачи:\nРазбиение:\nНа выполнение:';
			
			inputPass.y = bugReport.y = showAnswerBut.y = hInfo - showAnswerBut.height + 10;
			super.addChild(labelInfo);
			labelInfo.addEventListener(MouseEvent.MOUSE_DOWN, INFO_MOUSE_DOWN);
			showAnswerBut.addEventListener(MouseEvent.MOUSE_DOWN, SHOW_ANSWER_MOUSE_DOWN);
			bugReport.addEventListener(MouseEvent.MOUSE_DOWN, ON_BUG_REPORT);
		}
		private function close():void{
			if(super.contains(background)) super.removeChild(background);
			if(super.contains(maskBG)) super.removeChild(maskBG);
			labelInfo.x = labelInfo.y = 0;
		}
		private function open():void{
			super.addChild(background);
			super.addChild(maskBG);
			labelInfo.x = wInfo - labelInfo.width + 7;
			labelInfo.y = hInfo - labelInfo.height + 7;
			super.setChildIndex(labelInfo, super.numChildren-1);
		}
		private function INFO_MOUSE_DOWN(event:MouseEvent):void{
			if(super.contains(background)) close();
			else open();
		}
		private function SHOW_ANSWER_MOUSE_DOWN(event:MouseEvent):void{
			if(inputPass.text == PASSWORD){
				super.dispatchEvent(new Event(SHOW_ANSWER));
				close();
			}
		}
		private function ON_BUG_REPORT(event:MouseEvent):void{
			super.dispatchEvent(new Event(BUG_REPORT));
		}
		public function set data(value:Array):void{
			var outString:String = '';
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				outString += value[i] + '\n';
			}
			typeField.text = outString;
		}
		
		
		
	}
	
}
