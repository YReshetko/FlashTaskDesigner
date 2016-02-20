package source.SocketConnection {
	import flash.display.Sprite;
	import source.Components.Label;
	import source.Components.Field;
	import source.Components.Button;
	import source.Components.CheckBox;
	import source.Components.COEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	public class SocketRegistration extends Sprite{
		
		public static var REGISTRATION:String = 'onRegistration';
		
		private var nameLabel:Label = new Label();
		
		private var loginLabel:Label = new Label();
		private var passLabel:Label = new Label();
		private var confirmPassLabel:Label = new Label();
		
		private var userNameLabel:Label = new Label();
		private var userLastNameLabel:Label = new Label();
		
		private var statusLabel:Label = new Label();
		
		private var loginField:Field = new Field();
		private var passField:Field = new Field();
		private var confirmPassField:Field = new Field();
		
		private var userNameField:Field = new Field();
		private var userLastNameField:Field = new Field();
		
		private var statusField:CheckBox = new CheckBox();
		
		private var regButton:Button = new Button('Зарегистрировать');
		
		private var regArray:Array;
		
		public function SocketRegistration() {
			super();
			init();
		}
		private function init():void{
			super.addChild(nameLabel);
			nameLabel.text = 'Зарегистировать нового автора'
			nameLabel.x = - nameLabel.width/2;
			
			super.addChild(loginLabel);
			super.addChild(passLabel);
			super.addChild(confirmPassLabel);
			
			super.addChild(userNameLabel);
			super.addChild(userLastNameLabel);
			
			super.addChild(statusLabel);
			
			loginLabel.text = 'Логин';
			loginLabel.x = - loginLabel.width - 5;
			
			passLabel.text = 'Пароль';
			passLabel.x = - passLabel.width - 5;
			
			confirmPassLabel.text = 'Подтвердить пароль';
			confirmPassLabel.x = -confirmPassLabel.width - 5;
			
			userNameLabel.text = 'Имя';
			userNameLabel.x = -userNameLabel.width - 5;
			
			userLastNameLabel.text = 'Фамилия';
			userLastNameLabel.x = -userLastNameLabel.width - 5;
			
			statusLabel.text = 'Статус';
			statusLabel.x = -statusLabel.width - 5;
			
			statusField.samples = [ {'name':'Редактор'		, 'data':'3'},
								    {'name':'Автор'			, 'data':'2'},
								  	{'name':'Администратор'	, 'data':'1'}];
			
			super.addChild(loginField);
			super.addChild(passField);
			
			super.addChild(confirmPassField);
			
			super.addChild(userNameField);
			super.addChild(userLastNameField);
			
			super.addChild(regButton);
			
			super.addChild(statusField);
			
			loginField.x = 5;
			passField.x = 5;
			confirmPassField.x = 5;
			
			userNameField.x = 5;
			userLastNameField.x = 5;
			
			statusField.x = 5;
			
			passField.isPassword();
			confirmPassField.isPassword();
			
			loginLabel.y = loginField.y = 55;
			passLabel.y = passField.y = 80;
			
			confirmPassLabel.y = confirmPassField.y = 105;
			
			userNameLabel.y = userNameField.y = 130;
			userLastNameLabel.y = userLastNameField.y = 155;
			
			statusLabel.y = statusField.y = 180;
			
			
			
			regButton.width = regButton.width + 50;
			regButton.x = - regButton.width/2;
			regButton.y = 205;
			
			
			loginField.addEventListener(COEvent.PRESS_ENTER, LOGIN_PRESS_ENTER);
			passField.addEventListener(COEvent.PRESS_ENTER, PASS_PRESS_ENTER);
			confirmPassField.addEventListener(COEvent.PRESS_ENTER, CONFIRM_PASS_PRESS_ENTER);
			
			userNameField.addEventListener(COEvent.PRESS_ENTER, NAME_PRESS_ENTER);
			userLastNameField.addEventListener(COEvent.PRESS_ENTER, LAST_NAME_PRESS_ENTER);
			
			confirmPassField.addEventListener(COEvent.FIELD_FOCUS_OUT, PASSWORD_OUT);
			passField.addEventListener(COEvent.FIELD_FOCUS_OUT, PASSWORD_OUT);
			
			regButton.addEventListener(MouseEvent.CLICK, REG_BUTTON);
		}
		
		private function LOGIN_PRESS_ENTER(event:Event):void{
			passField.setFocus();
		}
		private function PASS_PRESS_ENTER(event:Event):void{
			confirmPassField.setFocus();
		}
		private function CONFIRM_PASS_PRESS_ENTER(event:Event):void{
			userNameField.setFocus();
		}
		private function NAME_PRESS_ENTER(event:Event):void{
			userLastNameField.setFocus();
		}
		private function LAST_NAME_PRESS_ENTER(event:Event):void{
			switch(''){
				case loginField.text:
					loginField.setFocus();
				return;
				case passField.text:
					passField.setFocus();
				return;
				case confirmPassField.text:
					confirmPassField.setFocus();
				return;
				case userNameField.text:
					userNameField.setFocus();
				return;
			}
		}
		private function PASSWORD_OUT(event:Event):void{
			checkPasswords();
		}
		private function REG_BUTTON(event:MouseEvent):void{
			checkPasswords(true);
			if(loginField.text == '' || passField.text == '' || confirmPassField.text == '' ||
			   userNameField.text == '' || userLastNameField.text == '') return;
			var command:int = 2;
			var inXml:XMLList = new XMLList('<REGISTRATION/>');
			inXml.USER = loginField.text;
			inXml.PASSWORD = passField.text;
			inXml.NAME = userNameField.text;
			inXml.LASTNAME = userLastNameField.text;
			inXml.STATUS = statusField.data;
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(inXml.toString());
			var size:int = ba.length;
			regArray = [command, size, ba];
			super.dispatchEvent(new Event(REGISTRATION));
		}
		public function get data():Array{
			return regArray;
		}
		private function checkPasswords(value:Boolean = false):void{
			if(value){
				if(passField.text == '' || confirmPassField.text == '') {
					selectPassFields('red');
					return;
				}
				if(passField.text != confirmPassField.text) {
					selectPassFields('red');
					return;
				}
			}else{
				if(passField.text == '' || confirmPassField.text == '') {
					selectPassFields('normal');
					return;
				}
				if(passField.text == confirmPassField.text){
					selectPassFields('green');
				}else{
					selectPassFields('red');
				}
			}
		}
		public function selectPassFields(value:String):void{
			var currentColor:uint;
			switch(value){
				case 'red':
					currentColor = 0xDD0000;
					initHandlerField();
				break;
				case 'green':
					currentColor = 0x00DD00;
				break;
				case 'normal':
					currentColor = 0xD0D0D0;
				break;
			}
			confirmPassField.color = passField.color = currentColor;
		}
		private function initHandlerField(value:Boolean = true):void{
			if(value){
				passField.addEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
				confirmPassField.addEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
			}else{
				passField.removeEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
				confirmPassField.removeEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
			}
		}
		private function FIELD_IN_FOCUS(event:Event):void{
			 initHandlerField(false);
			 selectPassFields('normal');
		}

	}
	
}
