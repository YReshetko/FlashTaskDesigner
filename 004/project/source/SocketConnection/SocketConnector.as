package source.SocketConnection {
	import flash.display.Sprite;
	import source.Components.Field;
	import source.Components.Label;
	import source.Components.Button;
	import source.Components.CheckBox;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class SocketConnector extends Sprite{
		
		public static var CONNECT:String = 'onConnect';
		
		private static const PORT:String = '2356';
		private var ipField:CheckBox;
		private var ipLabel:Label;
		private var nameLabel:Label;
		private var connectButton:Button;
		
		private var outXml:XMLList;
		public function SocketConnector() {
			super();
			init();
		}
		private function init():void{
			ipField = new CheckBox();
			ipField.samples = [{'name':'DL', 'data':'dl.gsu.by'},
							   {'name':'SC27', 'data':'10.4.253.2'},
							   {'name':'WM', 'data':'dl'},
							   {'name':'Home', 'data':'localhost'}]
			ipLabel = new Label();
			
			nameLabel = new Label();
			
			connectButton = new Button('Соединить');
			
			ipLabel.text = 'Выбор сети';
			nameLabel.text = 'Состояние соединения';
			super.addChild(nameLabel);
			nameLabel.x = -nameLabel.width/2;
			
			super.addChild(ipLabel);
			super.addChild(ipField);
			super.addChild(connectButton);
			ipLabel.y = ipField.y = connectButton.y = 30;
			ipField.x = ipLabel.width + 10;
			connectButton.x = ipField.x + ipField.width + 10;
			
			var deltaX:Number = (connectButton.x + connectButton.width)/2;
			ipLabel.x = ipLabel.x - deltaX;
			ipField.x = ipField.x - deltaX;
			connectButton.x = connectButton.x - deltaX;
			
			connectButton.addEventListener(MouseEvent.CLICK, CONNECT_TO_SERVER);
		}
		private function CONNECT_TO_SERVER(event:MouseEvent):void{
			outXml = new XMLList('<CONNECTION/>');
			outXml.PORT = PORT;
			outXml.IP = ipField.data;
			super.dispatchEvent(new Event(CONNECT));
		}
		public function get data():XMLList{
			return outXml;
		}

	}
	
}
