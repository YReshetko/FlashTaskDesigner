package source.SocketConnection {
	import flash.display.Sprite;
	import source.Components.ButtonMark;
	import source.Components.Label;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;
	
	public class SocketInterfaceController extends Sprite{
		public static var CONNECTION_CLOSE:String = 'onConnectionClose';
		
		public static var CLEAR_TASK:int = 1;
		public static var IMPORT_IMAGE:int = 2;
		public static var NEW_TASK:int = 3;
		
		private var arrWindow:Array = new Array( [new ButtonMark('Соединение'), new SocketConnector()],
									  			 [new ButtonMark('Авторизация'), new SocketAuthorization()],
									  			 [new ButtonMark('Регистрация'), new SocketRegistration()],
												 [new ButtonMark('Отправка'), new SocketUpload()],
									  			 [new ButtonMark('Отключить'), new Sprite()],
												 [new ButtonMark('Лог'), new SocketLog()]);
		private var initWindow:Array = new Array([true , false , false, false, false, true], 	// 	Не подключён
												 [false, true  , false, false, true,  true],	//	Не авторизован
												 [false, true  , true ,  true, true,  true],	//	Админ
												 [false, true  , false, true , true,  true],	//	Автор
												 [false, true  , false, true , true,  true]);	//	Редактор
										
		private var statusArray:Array = ['Нет подключения',
										 'Подключён',
										 'Администратор',
										 'Автор',
										 'Редактор'];
		private var currentStatus:int = -2;
		
		private var workWindows:Array = new Array();
		
		private var labelNameUser:Label = new Label();
		private var nameUser:Label = new Label();
		
		private var labelUserStatus:Label = new Label();
		private var userStatus:Label = new Label();
		
		private var wWindow:Number;
		
		private var posY:Object = {'first':80,'second':110, 'third':150, 'fourth':170};
		
		private var hostConnection:XMLList;
		private var authorizationData:Array;
		private var registrationData:Array;
		
		public function SocketInterfaceController(width:Number) {
			super();
			wWindow = width;
			init();
			//trace(this + ': arr wind = ' + initWindow);
		}
		
		private function init():void{
			labelNameUser.text = 'Пользователь:';
			labelUserStatus.text = 'Статус';
			
			super.addChild(labelUserStatus);
			super.addChild(userStatus);
			
			labelUserStatus.x = wWindow/2 - labelUserStatus.width - 5;
			userStatus.x = wWindow/2 + 5;
			labelUserStatus.y = userStatus.y = posY.second;
			addHandler();
			status = -1;
		}
		
		private function addHandler():void{
			(arrWindow[0][1] as SocketConnector).addEventListener(SocketConnector.CONNECT, CONNECT_TO_SERVER);
			(arrWindow[1][1] as SocketAuthorization).addEventListener(SocketAuthorization.AUTHORIZATION, SERVER_AUTHORIZATION);
			(arrWindow[2][1] as SocketRegistration).addEventListener(SocketRegistration.REGISTRATION, SERVER_REGISTRATION);
			(arrWindow[3][1] as SocketUpload).addEventListener(SocketUpload.UPLOAD_TASK, UPLOAD_TASK);
			(arrWindow[5][0] as ButtonMark).addEventListener(MouseEvent.CLICK, CLOSE_CONNECTION);
		}
		
		//	Транзитные методы авторизации пользователя
		private function SERVER_REGISTRATION(event:Event):void{
			registrationData = (arrWindow[2][1] as SocketRegistration).data;
			super.dispatchEvent(new Event(SocketRegistration.REGISTRATION));
		}
		public function get registration():Array{
			return  registrationData;
		}
		
		//	Транзитные методы авторизации пользователя
		private function SERVER_AUTHORIZATION(event:Event):void{
			var inXml:XMLList = (arrWindow[1][1] as SocketAuthorization).data;
			var command:int = 1;
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(inXml.toString());
			var size:int = ba.length;
			authorizationData = [command, size, ba];
			super.dispatchEvent(new Event(SocketAuthorization.AUTHORIZATION));
		}
		public function get authorization():Array{
			return authorizationData;
		}
		
		
		//	Транзитные методы соединения с сервером
		private function CONNECT_TO_SERVER(event:Event):void{
			hostConnection = (arrWindow[0][1] as SocketConnector).data;
			super.dispatchEvent(new Event(SocketConnector.CONNECT));
		}
		private function CLOSE_CONNECTION(event:MouseEvent):void{
			super.dispatchEvent(new Event(CONNECTION_CLOSE));
		}
		public function get host():XMLList{
			return hostConnection;
		}
		
		
		public function set status(value:Number):void{
			if(currentStatus == value) return;
			(arrWindow[3][1] as SocketUpload).status = value;
			clear();
			currentStatus = value;
			var index:int = value+1;
			var i:int;
			var l:int;
			l = arrWindow.length;
			var overWidth:Number = 0;
			userStatus.text = statusArray[index];
			//trace(this + ': length window arr = ' + l + '; arr window[0] = ' + arrWindow[0]);
			for(i=0;i<l;i++){
				//trace(this + ': access to window = ' + initWindow[index][i]);
				if(initWindow[index][i]){
					//trace(this + ': add new Window');
					super.addChild(arrWindow[i][0]);
					arrWindow[i][0].x = overWidth;
					arrWindow[i][0].y = posY.third;
					
					overWidth += arrWindow[i][0].width + 10;
					workWindows.push(arrWindow[i]);
					arrWindow[i][0].addEventListener(ButtonMark.OPEN, WINDOW_OPEN);
					arrWindow[i][0].addEventListener(ButtonMark.CLOSE, WINDOW_CLOSE);
					(arrWindow[i][0] as ButtonMark).select = true;
				}
			}
			overWidth = (wWindow - overWidth)/2;
			l = workWindows.length;
			for(i=0;i<l;i++){
				workWindows[i][0].x = workWindows[i][0].x + overWidth;
			}
		}
		private function WINDOW_OPEN(event:Event):void{
			var i:int;
			var l:int;
			l = workWindows.length;
			for(i=0;i<l;i++){
				if(event.target == workWindows[i][0]){
					super.addChild(workWindows[i][1]);
					workWindows[i][1].x = this.wWindow/2;
					workWindows[i][1].y = posY.fourth;
				}else{
					if(workWindows[i][0].select) workWindows[i][0].select = false;
				}
			}
		}
		private function WINDOW_CLOSE(event:Event):void{
			var i:int;
			var l:int;
			l = workWindows.length;
			for(i=0;i<l;i++){
				if(event.target == workWindows[i][0]){
					if(super.contains(workWindows[i][1])) super.removeChild(workWindows[i][1]);
				}
			}
		}
		public function set changeName(value:String):void{
			if(value == ''){
				if(super.contains(labelNameUser)) super.removeChild(labelNameUser);
				if(super.contains(nameUser)) super.removeChild(nameUser);
				return;
			}
			super.addChild(labelNameUser);
			super.addChild(nameUser);
			nameUser.text = value;
			labelNameUser.x = wWindow/2 - labelNameUser.width - 5;
			nameUser.x =  wWindow/2 + 5;
			labelNameUser.y = nameUser.y = posY.first;
		}
		
		private function clear():void{
			while(workWindows.length>0){
				workWindows[0][0].removeEventListener(ButtonMark.OPEN, WINDOW_OPEN);
				workWindows[0][0].removeEventListener(ButtonMark.CLOSE, WINDOW_CLOSE);
				if(super.contains(workWindows[0][0])) super.removeChild(workWindows[0][0]);
				if(super.contains(workWindows[0][1])) super.removeChild(workWindows[0][1]);
				workWindows.shift();
			}
		}
		public function set message(value:String):void{
			(arrWindow[5][1] as SocketLog).message = value;
		}
		public function setRequisit(tid:String, name:String):void{
			(arrWindow[3][1] as SocketUpload).tid = tid;
			(arrWindow[3][1] as SocketUpload).taskName = name;
		}
		
		public function clearUpload(value:int):void{
			switch(value){
				case CLEAR_TASK:
					(arrWindow[3][1] as SocketUpload).clear();
				break;
				case IMPORT_IMAGE:
					if(currentStatus!=1 && currentStatus!=2) (arrWindow[3][1] as SocketUpload).clear();
				break;
		 		case NEW_TASK:
					if(currentStatus!=1) (arrWindow[3][1] as SocketUpload).clear();
				break;
			}
		}
		
		public function UPLOAD_TASK(event:Event):void{
			super.dispatchEvent(new Event(SocketUpload.UPLOAD_TASK));
		}
		public function get tid():String{
			return (arrWindow[3][1] as SocketUpload).tid;
		}
	}
	
}
