package source.SocketConnection {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import source.Components.ButtonMark;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import source.Components.LoaderBar;
	import source.Components.Label;
	
	public class SocketController extends SocketInterfaceController{
		
		private var socket:Socket;
		
		private var container:Sprite;
		private var endConnection:Timer;
		
		private var currentSendIndex:int = 0;
		//	Массив команд отправляемых на сервер
		private var stackCommand:Array = new Array();
		//	Статус получения пользователя от сервера
		private var getUser:Boolean = false;
		
		private var arrCurrentFile:ByteArray;
		private var indCurrentFile:int;
		private var lengCurrentFile:int;
		private static var lengthSendingBytes:int = 128;
		
		private var loader:LoaderBar;
		private var processLabel:Label = new Label();
		public function SocketController(container:Sprite, width:Number, height:Number) {
			super(width);
			Figure.insertRect(super, width, height);
			this.container = container;
			addHandler();
		}
		
		/*******************************************/
		/* Блок отправки данных и получения ответа */
		/*******************************************/
		private function sendDataToServer():void{
			super.message = 'Отправка';
			switch(currentSendIndex){
				case 0:
					initProcess();
					socket.writeInt(stackCommand[0][0]);
				break;
				case 1:
					socket.writeInt(stackCommand[0][1]);
				break;
				case 2:
					if(stackCommand[0][1]>lengthSendingBytes){
						prepareLongFileToSend();
					}else{
						socket.writeBytes(stackCommand[0][2]);
					}
				break;
			}
			socket.flush();
		}
		private function prepareLongFileToSend():void{
			arrCurrentFile = stackCommand[0][2];
			lengCurrentFile = stackCommand[0][1];
			indCurrentFile = 0;
			openLoader();
			sendSampleFile();
			
		}
		private function sendSampleFile():void{
			iterLoader();
			if(lengCurrentFile - indCurrentFile>=lengthSendingBytes){
				socket.writeBytes(arrCurrentFile, indCurrentFile, lengthSendingBytes);
			}else{
				var lastLength:int = lengCurrentFile - indCurrentFile;
				socket.writeBytes(arrCurrentFile, indCurrentFile, lastLength);
			}
			indCurrentFile = indCurrentFile + lengthSendingBytes;
			socket.flush();
			
		}
		private function SOCKET_GET_DATA(event:ProgressEvent):void{
			if(getUser){
				var user:XMLList = new XMLList(socket.readUTF());
				super.changeName = user.@name.toString();
				super.status = parseInt(user.@status.toString());
				getUser = false;
				super.message = 'Пользователь ' + user.@name.toString() + ' авторизован'
				return;
			}
			var command:int = socket.readByte();
			switch(command){
				case SocketInputCommand.NEXT_DATA:
					++currentSendIndex;
					sendDataToServer();
				break;
				case SocketInputCommand.NEXT_COMMAND:
					closeLoader();
					super.message = 'Следующая тройка данных';
					stackCommand.shift();
					currentSendIndex = 0;
					if(stackCommand.length != 0) sendDataToServer();
					else process = '';
				break;
				case SocketInputCommand.NEXT_PART_FILE:
					if(indCurrentFile>=lengCurrentFile){
						super.message = 'Критическая ошибка! Перебор длины файла';
						return;
					}
					sendSampleFile();
				break;
				case SocketInputCommand.GET_USER:
					getUser = true;
				break;
				case SocketInputCommand.EXCEPTION_GET_DATA:
					super.message = 'Ошибка сервера при получении данных'
				break;
				case SocketInputCommand.USER_DONT_AUTHORIZE:
					super.message = 'Не удалось авторизовать пользователя!';
					super.message = 'Проверьте логин и пароль!';
				break;
				case SocketInputCommand.USER_DONT_REGISTRATION:
					super.message = 'Не удалось зарегистрировать нового пользователя!';
				break;
				case SocketInputCommand.USER_IS_REGISTRATION:
					super.message = 'Пользователь зарегистрирован';
				break;
				case SocketInputCommand.ERROR_FIND_TSK_FOLDER:
					super.message = 'На сервере не найден каталог с данным номером';
					while(stackCommand.length>0){
						stackCommand.shift();
					}
					super.message = 'Массив данных очищен';
				break;
			}
		}
		/*******************************************/
		
		private function addHandler():void{
			super.addEventListener(SocketConnector.CONNECT, CONNECT_TO_SERVER);
			super.addEventListener(SocketAuthorization.AUTHORIZATION, AUTHORIZATION);
			super.addEventListener(SocketRegistration.REGISTRATION, REGISTRATION);
			super.addEventListener(SocketInterfaceController.CONNECTION_CLOSE, CLOSE_SOCKET);
		}
		
		private function REGISTRATION(event:Event):void{
			var flag:Boolean = (stackCommand.length == 0);
			stackCommand.push(super.registration);
			if(flag) sendDataToServer();
		}
		private function AUTHORIZATION(event:Event):void{
			var flag:Boolean = (stackCommand.length == 0);
			stackCommand.push(super.authorization);
			if(flag) sendDataToServer();
		}
		
		//	Группа методов соединения с сервером и определение недоступности серевере
		private function CONNECT_TO_SERVER(event:Event):void{
			var ip:String = super.host.IP.toString();
			var port:int = parseInt(super.host.PORT.toString());
			super.addEventListener(Event.ENTER_FRAME, WAIT_CONNECT);
			
			initEndTimer(true);
			socket = new Socket();
			socket.addEventListener(IOErrorEvent.IO_ERROR, SOCKET_IO_ERROR);
			socket.connect(ip, port);
		}
		private function WAIT_CONNECT(event:Event):void{
			if(socket.connected){
				initEndTimer(false);
				super.removeEventListener(Event.ENTER_FRAME, WAIT_CONNECT);
				super.status = 0;
				socket.addEventListener(ProgressEvent.SOCKET_DATA, SOCKET_GET_DATA);
				super.message = 'Подключение к серверу прошло успешно';
			}
		}
		private function initEndTimer(value:Boolean):void{
			if(value){
				endConnection = new Timer(10000, 1);
				endConnection.addEventListener(TimerEvent.TIMER, END_CONNECTION);
				endConnection.start();
			}else{
				if(endConnection == null) return;
				endConnection.stop();
				endConnection.removeEventListener(TimerEvent.TIMER, END_CONNECTION);
				endConnection = null;
			}
		}
		private function SOCKET_IO_ERROR(error:IOErrorEvent):void{
			super.message = 'Ошибка подключения к серверу';
			END_CONNECTION();
		}
		private function END_CONNECTION(event:TimerEvent = null):void{
			initEndTimer(false);
			super.removeEventListener(Event.ENTER_FRAME, WAIT_CONNECT);
			super.status = -1;
			socket = null;
			super.message = 'Подключиться к серверу не удалось';
		}
		
		//	Методы открытия панели
		public function open():void{
			this.container.addChild(super);
		}
		public function close():void{
			if(this.container.contains(super)) this.container.removeChild(super);
		}
		public function get isOpen():Boolean{
			return this.container.contains(super);
		}
		
		
		public function set uploadContent(value:Array):void{
			var flag:Boolean = (stackCommand.length == 0);
			var size:int;
			var ba:ByteArray;
			var contentArray:Array = value[1];
			ba = new ByteArray();
			ba.writeUTFBytes(super.tid);
			size = ba.length;
			stackCommand.push([SocketOutputCommand.SET_FOLDER_TSK, size, ba]);
			
			ba = new ByteArray();
			ba.writeUTFBytes(value[0]);
			
			contentArray.unshift(['Position.txt', ba]);
			
			var i:int;
			var l:int;
			l = contentArray.length;
			for(i=0;i<l;i++){
				ba = new ByteArray();
				ba.writeUTFBytes(contentArray[i][0]);
				stackCommand.push([SocketOutputCommand.SET_FILE_NAME, ba.length, ba]);
				
				stackCommand.push([SocketOutputCommand.SET_FILE, (contentArray[i][1] as ByteArray).length, (contentArray[i][1] as ByteArray)]);
			}
			ba = new ByteArray();
			ba.writeUTFBytes('COMPLATE');
			stackCommand.push([SocketOutputCommand.COMPLATE_UPLOAD, ba.length, ba]);
			if(flag) sendDataToServer();
		}
		
		
		
		private function openLoader():void{
			if(loader==null){
				loader = new LoaderBar();
				loader.height = 19;
			}
			loader.percent = 0;
			super.addChild(loader);
			loader.y = 25;
			loader.x = super.width/2;
		}
		private function closeLoader():void{
			if(loader == null) return;
			if(super.contains(loader))super.removeChild(loader);
		}
		private function iterLoader():void{
			if(loader == null) return;
			loader.percent = indCurrentFile/lengCurrentFile;
		}
		
					
		private function initProcess():void{
			switch(stackCommand[0][0]){
				case SocketOutputCommand.SOCKET_AUTHORIZATION:
					process = 'авторизация';
				break;
				case SocketOutputCommand.SOCKET_REGISTRATION:
					process = 'регистрация';
				break;
				case SocketOutputCommand.SET_FILE:
				break;
				case SocketOutputCommand.SET_FILE_NAME:
					process = 'отправляется файл ' + (stackCommand[0][2] as ByteArray).toString();
				break;
				case SocketOutputCommand.SET_FOLDER_TSK:
					process = 'поиск задачи с номером ' + (stackCommand[0][2] as ByteArray).toString();
				break;
				case SocketOutputCommand.COMPLATE_UPLOAD:
					process = 'завершение загрузки';
				break;
			}
		}
		private function set process(value:String):void{
			if(!super.contains(processLabel)){
				super.addChild(processLabel);
				processLabel.y = 46;
				processLabel.fieldSize = 12;
			}
			if(value == ''){
				processLabel.text = 'Никаких действий не выполняется';
			}else{
				processLabel.text = 'Выполняется: ' + value + '. Осталось процессов: ' + stackCommand.length + '.';
			}
			processLabel.x = super.width/2 - processLabel.width/2;
			super.message = processLabel.text;
		}
		
		
		
		private function CLOSE_SOCKET(event:Event):void{
			while(stackCommand.length>0){
				stackCommand.shift();
			}
			if(socket!=null) socket.close();
			closeLoader();
			currentSendIndex = 0;
			super.status = -1;
			super.changeName = '';
			processLabel.text = 'Сервер отключён';
		}
	}
	
}
