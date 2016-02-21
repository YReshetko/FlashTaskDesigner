package source.Designer {
	import flash.display.Sprite;
	import flash.text.TextField;
	import source.Utilites.GetField;
	import source.Utilites.SettingPanel;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import source.Utilites.PazzleEvent;
	import source.Utilites.CheckBox.MyCheckBox;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.sensors.Accelerometer;
	import flash.events.MouseEvent;
	
	public class UserInterface extends Sprite{
		private static var helper:Array = new Array(["Без подсказки", 			"WITHOUT HELP"],
													["С подсказкой", 			"WITH HELP"],
													["Образец перед глазами", 	"NEARBY"],
													["Образец на фоне", 		"SAMPLE BACKGRAUND"]);
													
		private static var position:Array = new Array(["Случайный порядок", 	"RANDOM"],
													  ["В одной стопке", 		"ONE COLUMN"],
													  ["Вокруг поля сбора", 	"AROUND FIELD"],
													  ["Авторская расстановка", "AUTHOR POSITION"]);
		private var settSprite:Sprite = new Sprite;
		
		private var mainLabel:TextField;
		
		private var numLine:TextField;
		private var numColumn:TextField;
		
		private var wPicture:TextField;
		private var hPicture:TextField;
		
		private var rJump:TextField;
		
		private var inputNumLine:TextField;
		private var inputNumColumn:TextField;
		
		private var inputWPicture:TextField;
		private var inputHPicture:TextField;
		
		private var inputJump:TextField;
		
		private var helpVarian:MyCheckBox;
		private var positionVarian:MyCheckBox;
		
		private var panel:SettingPanel = new SettingPanel();
		
		//private var openButton:folder = new folder();
		public function UserInterface(interfaceContainer:Sprite) {
			initPanelSettings();
			panel.setSprite("НАСТРОЙКИ", settSprite);
			interfaceContainer.addChild(panel);
			initHendler();
		}
		private function initPanelSettings(){
			mainLabel = GetField.drawLabel("Параметры разрезания");
			numLine = GetField.drawLabel("Линии");
			numColumn = GetField.drawLabel("Столбцы");
			
			inputNumLine = GetField.drawInput(40, 20, '0-9');
			inputNumColumn = GetField.drawInput(40, 20, '0-9');
			
			wPicture = GetField.drawLabel("Ширина");
			hPicture = GetField.drawLabel("Высота");
			
			inputWPicture = GetField.drawInput(40, 20, '.0123456789');
			inputHPicture = GetField.drawInput(40, 20, '.0123456789');
			
			rJump = GetField.drawLabel("Радиус прыжка");
			
			inputJump = GetField.drawInput(60, 20, '0-9');
			
			helpVarian = new MyCheckBox();
			helpVarian.addSample(helper);
			
			positionVarian = new MyCheckBox();
			positionVarian.addSample(position);
			 
			
			settSprite.addChild(mainLabel);
			settSprite.addChild(numLine);
			settSprite.addChild(numColumn);
			settSprite.addChild(inputNumLine);
			settSprite.addChild(inputNumColumn);
			
			settSprite.addChild(wPicture);
			settSprite.addChild(hPicture);
			settSprite.addChild(inputWPicture);
			settSprite.addChild(inputHPicture);
			
			settSprite.addChild(rJump);
			settSprite.addChild(inputJump);
			
			settSprite.addChild(positionVarian);
			settSprite.addChild(helpVarian);
			
			//settSprite.addChild(openButton);
			
			
			mainLabel.x = 20;
			numLine.y = 30;
			numColumn.y = 30;
			numColumn.x = 60;
			inputNumLine.y = 55;
			inputNumColumn.y = 55;
			inputNumColumn.x = 60;
			wPicture.y = 80;
			hPicture.y = 80;
			hPicture.x = 60;
			inputWPicture.y = 105;
			inputHPicture.y = 105;
			inputHPicture.x = 60;
			rJump.y = 130;
			inputJump.y = 130;
			inputJump.x = 100;
			helpVarian.y = 155;
			positionVarian.y = 180;
		}
		public function setSettings(inObject:Object){
			inputNumLine.text = inObject.numLine.toString();
			inputNumColumn.text = inObject.numColumn.toString();
			inputJump.text = inObject.jump.toString();
		}
		public function setSize(inObject:Object){
			inputWPicture.text = inObject.wPicture.toString();
			inputHPicture.text = inObject.hPicture.toString();
		}
		public function getSize():Object{
			var outObject:Object = new Object();
			outObject.wPicture = inputWPicture.text;
			outObject.hPicture = inputHPicture.text;
			return outObject;
		}
		public function getSettings():Object{
			var outObject:Object = new Object();
			outObject.numLine = parseInt(inputNumLine.text);
			outObject.numColumn = parseInt(inputNumColumn.text);
			outObject.helper = helpVarian.getCurrentData();
			outObject.positioner = positionVarian.getCurrentData();
			outObject.jump = parseInt(inputJump.text);
			return outObject;
		}
		private function initHendler(){
			//inputNumLine.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			inputNumLine.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			//inputNumColumn.addEventListener(KeyboardEvent.KEY_DOWN, FIELD_KEY_DOWN);
			inputNumColumn.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
			//openButton.addEventListener(MouseEvent.MOUSE_DOWN, FOLDER_MOUSE_DOWN);
			
			inputWPicture.addEventListener(TextEvent.TEXT_INPUT, SIZE_TEXT_INPUT);
			inputHPicture.addEventListener(TextEvent.TEXT_INPUT, SIZE_TEXT_INPUT);
			
			helpVarian.addEventListener(MyCheckBox.CHECK_BOX_CHANGED, CHECK_BOX_CHANGED);
			positionVarian.addEventListener(MyCheckBox.CHECK_BOX_CHANGED, CHECK_BOX_CHANGED);
			
			inputJump.addEventListener(TextEvent.TEXT_INPUT, FIELD_TEXT_INPUT);
		}
		/*private function FIELD_KEY_DOWN(e:KeyboardEvent){
			addTimer();
		}*/
		private function FIELD_TEXT_INPUT(e:TextEvent){
			addTimer(SETTINGS_TIME_OUT);
		}
		private function SIZE_TEXT_INPUT(e:TextEvent){
			addTimer(SIZE_TIME_OUT);
		}
		private function addTimer(method){
			var timeOut:Timer = new Timer(10,1);
			timeOut.addEventListener(TimerEvent.TIMER, method);
			timeOut.start();
		}
		private function SETTINGS_TIME_OUT(e:TimerEvent){
			this.dispatchEvent(new Event(PazzleEvent.SETTINGS_CHANGED));
		}
		private function SIZE_TIME_OUT(e:TimerEvent){
			this.dispatchEvent(new Event(PazzleEvent.SIZE_CHANGED));
		}
		/*private function FOLDER_MOUSE_DOWN(e:MouseEvent){
			this.dispatchEvent(new Event(PazzleEvent.OPEN_FILE));
		}*/
		private function CHECK_BOX_CHANGED(e:Event){
			this.dispatchEvent(new Event(PazzleEvent.SETTINGS_CHANGED));
		}
	}
	
}
