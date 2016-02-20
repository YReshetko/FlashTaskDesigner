package source.SocketConnection {
	import flash.display.Sprite;
	import source.Components.Label;
	import source.Components.Field;
	import source.Components.Button;
	import flash.events.MouseEvent;
	import source.Components.COEvent;
	import flash.events.Event;
	
	public class SocketAuthorization extends Sprite{
		
		public static var AUTHORIZATION:String = 'onAuthorization';
		
		private var nameLabel:Label = new Label();
		private var loginLabel:Label = new Label();
		private var passLabel:Label = new Label();
		private var loginField:Field = new Field();
		private var passField:Field = new Field();
		private var authButton:Button = new Button('Авторизоваться');
		
		private var outXml:XMLList;
		public function SocketAuthorization() {
			super();
			init();
		}
		private function init():void{
			super.addChild(nameLabel);
			nameLabel.text = 'Введите логин и пароль'
			nameLabel.x = - nameLabel.width/2;
			
			super.addChild(loginLabel);
			super.addChild(passLabel);
			
			loginLabel.text = 'Логин';
			loginLabel.x = - loginLabel.width - 25;
			
			passLabel.text = 'Пароль';
			passLabel.x = - passLabel.width - 25
			
			
			super.addChild(loginField);
			super.addChild(passField);
			
			loginField.x = -15;
			passField.x = -15;
			passField.isPassword();
			
			loginLabel.y = loginField.y = 55;
			passLabel.y = passField.y = 80;
			
			super.addChild(authButton);
			
			authButton.width = authButton.width + 50;
			authButton.x = - authButton.width/2;
			authButton.y = 105;
			
			loginField.addEventListener(COEvent.PRESS_ENTER, LOGIN_PRESS_ENTER);
			passField.addEventListener(COEvent.PRESS_ENTER, PASSWORD_PRESS_ENTER);
			authButton.addEventListener(MouseEvent.CLICK, AUTHORIZATION_CLICK);
		}
		private function LOGIN_PRESS_ENTER(event:Event):void{
			passField.setFocus();
		}
		private function PASSWORD_PRESS_ENTER(event:Event):void{
			if(loginField.text == '') {
				loginField.setFocus();
				return;
			}
			AUTHORIZATION_CLICK();
		}
		private function AUTHORIZATION_CLICK(event:MouseEvent = null):void{
			if(loginField.text == '') {
				loginField.color = 0xDD0000; 
				loginField.addEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
			}
			if(passField.text == '') {
				passField.color = 0xDD0000;
				passField.addEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
			}
			if(loginField.text == '' || passField.text == '') return;
			outXml = new XMLList('<AUTHORIZATION/>');
			outXml.USER = loginField.text;
			outXml.PASSWORD = passField.text;
			super.dispatchEvent(new Event(AUTHORIZATION));
		}
		private function FIELD_IN_FOCUS(event:Event):void{
			(event.target as Field).removeEventListener(COEvent.FIELD_FOCUS, FIELD_IN_FOCUS);
			(event.target as Field).color = 0xD0D0D0;
		}
		public function get data():XMLList{
			return outXml;
		}

	}
	
}
