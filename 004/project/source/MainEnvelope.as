package source
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.NativeWindowDisplayStateEvent;
	import source.EnvInterface.EnvMenu.Menu;
	import source.EnvEvents.Events;
	import flash.events.Event;
	import source.EnvInterface.EnvPanel.PanelSpace;
	import source.EnvKonstraktion.InitKonstraction;
	import source.EnvEvents.MenuComand;
	import source.EnvLoader.LoadFiles;
	import source.EnvUtils.EnvString.ConvertString;
	import source.EnvInterface.EnvPanel.Panel;
	import source.EnvLoader.SaveFiles;
	import flash.events.MouseEvent;
	import flash.display.InteractiveObject;
	import flash.filesystem.File;
	import source.Components.MessageWindow;
	import source.Components.MessageText;
	import source.EnvUtils.EnvUpdater.Updater;
	import source.SocketConnection.SocketController;
	import source.WindowInterface.MainTaskDownloader;
	import source.SocketConnection.SocketInterfaceController;
	import source.SocketConnection.SocketUpload;
	import source.utils.FindeFileName;
	import source.EnvInterface.EnvMenu.VisualPreloader;

	public class MainEnvelope extends BaseStartClass
	{
		public static var wStage:Number;
		public static var hStage:Number;
		public static var STAGE:Stage;
		public static var message:MessageWindow;
		
		public static var globalPreloader:VisualPreloader;
		
		private var arrTask:Array;
		private var currentID:int;
		private var openLoading:Boolean = false;
		private var updater:Updater;
		private var socketController:SocketController;
		public function MainEnvelope()
		{
			super();
			STAGE = stage;
			globalPreloader = new VisualPreloader();
			globalPreloader.close();
			super.addEventListener(Events.WINDOW_INIT_COMPLATE, INIT_HANDLER);
			super.addEventListener(Events.ADD_DL_REQUISIT_TO_UPLOAD_FORM, FILL_UPLOAD_FORM);
		}
		//Инициализация слушателей объектов
		private function INIT_HANDLER(e:Event):void
		{

			designer.addEventListener(Events.SAVE_TASK, DESIGNER_SAVE_TASK);

			envLoader.addEventListener(Events.LOAD_TEXT_FILE, LOADER_LOAD_TEXT_FILE);
			envLoader.addEventListener(Events.LOAD_FILE, LOADER_LOAD_FILE);
			envLoader.addEventListener(Events.LOAD_MUCH_FILE, LOADER_MUCH_FILE);
			envLoader.addEventListener(Events.OPEN_MUCH_FILE, LOADER_OPEN_MUCH_FILE);

            envLoader.loadMuchFiles(["Analogy.swf"], "Modules")

			envMenu.addEventListener(Events.LINK_DISPATCH_STATUS, LINK_DISPATCHED);

			taskBase.addEventListener(Events.ADD_SELECTED_TASK, GET_TASK_FOR_ADD_DESIGNER);
			super.addEventListener(Events.TEMP_FILE_SAVE_COMPLATE, GET_TASK_FOR_TEMP_ADD_DESIGNER);
			
			message = new MessageWindow(super.errorContainer, super.windowWidth, super.windowHeight);
			
			wStage = super.windowWidth;
			hStage = super.windowHeight;
			
			
			updater = new Updater();
			updater.addEventListener(Updater.RESTART_DESSIGNER, RESTART_DESSIGNER);
			socketController = new SocketController(super.containerForWindow, super.windowWidth, super.windowHeight - Menu.MENU_HEIGHT);
			socketController.addEventListener(SocketUpload.UPLOAD_TASK, UPLOAD_TASK);
		}
		private function RESTART_DESSIGNER(event:Event):void{
			super.closeWindow();
		}
		//Метод прослушивания команд меню
		private function LINK_DISPATCHED(e:Event):void
		{
			var inStatus:* = e.target.currentLinkStatus;
			if (inStatus == null)
			{
				return;
			}
			switch (inStatus)
			{
				case MenuComand.OPEN_TASK :
					envLoader.loadOneFile("*.txt", "Задание");
					return;
				case MenuComand.OPEN_LIBRARY :
					designer.changeVisible();
					return;
				case MenuComand.IMPORT_FILE :
					envLoader.openMuchFile('*.jpg;*.png;*.gif;*.swf;*.mp3;*.pas');
					socketController.clearUpload(SocketInterfaceController.IMPORT_IMAGE);
					return;
				case MenuComand.SAVE_TASK :
					designer.saveTask();
					return;
				case MenuComand.SAVE_CURRENT_TASK :
					designer.saveTask(false);
					return;
				case MenuComand.CREATE_NEW_TASK :
					designer.createNewTask();
					socketController.clearUpload(SocketInterfaceController.NEW_TASK);
					return;
				case MenuComand.OPEN_MANAGER :
					taskBase.changeVisible();
					return;
				case MenuComand.OPEN_ONLINE_BASE :
					super.onlineBase.open = !super.onlineBase.open;
					return;
				case MenuComand.OPEN_SETTINGS :
					designer.pSettingsVisible();
					return;
				case MenuComand.OPEN_COLOR_PICKER :
					designer.colorPickerVisible();
					return;
				case MenuComand.OPEN_PAINT_PANEL :
					designer.paintVisible()
					return;
				case MenuComand.OPEN_LAYER_PANEL :
					designer.layerVisible();
					return;
				case MenuComand.OPEN_TASK_TREE_PANEL :
					designer.treeVisible();
					return;
				case MenuComand.CLEAR_ALL_TASK :
					designer.clearAllTask();
					socketController.clearUpload(SocketInterfaceController.CLEAR_TASK);
					return;
				case MenuComand.CLEAR_CURRENT_TASK :
					designer.clearCurrentTask();
					return;
				case MenuComand.TEST_TASK :
					designer.testTask();
					return;
				case MenuComand.TEST_CURRENT_TASK :
					designer.testTask(false);
					return;
				case MenuComand.DL_SAVER :
					prepareDLArchive();
					return;
				case MenuComand.DIFICULT_DL_SAVER :
					askSaveDifficultArchive();
					return;
				case MenuComand.OPEN_BASE_IMAGE_PANEL :
					designer.imageBaseVisible();
					return;
				case MenuComand.STANDART_PANELS_POSITION :
					envPanel.applySetPanel('STANDART');
					return;
				case MenuComand.OPEN_BASE_FIGURE :
					designer.figugeBaseVisible();
					return;
				case MenuComand.OPEN_TOOLS :
					designer.toolsPanelVisible();
					return;
				case MenuComand.OPEN_MAIN_SCENE :
					designer.sceneVisible();
					return;
				case MenuComand.OPEN_SOCKET_SERVER_CONNECTION :
					openSocketConnector();
					return;
				case MenuComand.SET_BLACK_ON_COLOR :
					designer.setBlackOnColor();
					return;
				case MenuComand.SET_COLOR_ON_BLACK :
					designer.setColorOnBlack();
					return;
				case MenuComand.SET_IMAGE_TAN_ON_IMAGE :
					designer.userTanOnPicture();
					return;
					
			}
		}
		//Методы инициализации слушателей загрузчика
		//Загрузка текстового файла
		private function LOADER_LOAD_TEXT_FILE(e:Event):void
		{
			designer.setTask(e.target.outObject.data);
			//var arrFile:Array = ConvertString.getNamesFileFromTask(e.target.outObject.data);
			var arrFile:Array = FindeFileName.names(e.target.outObject.data);
			trace(this + ' array images = ' + arrFile);
			if (arrFile.length != 0)
			{
				envLoader.loadMuchFiles(arrFile, e.target.outObject.path);
			}
			else
			{
				designer.loadTaskInDesigner();
				if (openLoading)
				{
					startLoadArrTask();
				}
			}
		}
		//Окончание загрузки всех графических файлов
		private function LOADER_MUCH_FILE(e:Event):void
		{
			designer.setPicture(e.target.outObject);
			designer.loadTaskInDesigner();
			if (openLoading)
			{
				startLoadArrTask();
			}
		}
		//Загрузка произвольного файла
		private function LOADER_LOAD_FILE(e:Event):void
		{

		}
		private function LOADER_OPEN_MUCH_FILE(e:Event):void
		{
			designer.importPicture(e.target.outObject);
		}
		private function DESIGNER_SAVE_TASK(e:Event):void
		{
			var inObject:Object = e.target.getTask();
			envSaver.saveTask(inObject);
		}
		private function GET_TASK_FOR_ADD_DESIGNER(e:Event):void
		{
			arrTask = taskBase.getTaskArray();
			startLoadPackage();
			
		}
		private function GET_TASK_FOR_TEMP_ADD_DESIGNER(event:Event):void{
			arrTask = super.arrLoadTempTask;
			startLoadPackage();
		}
		private function startLoadPackage():void{
			var i:int;
			for (i=0; i<arrTask.length; i++)
			{
				trace(this + ': PATH TO FILE = ' + arrTask[i]);
			}
			currentID = -1;
			openLoading = true;
			startLoadArrTask();
		}
		
		private function startLoadArrTask():void
		{
			++currentID;
			if (currentID < arrTask.length)
			{
				if (currentID!=0)
				{
					designer.createNewTask();
				}
				envLoader.loadLocalTextFile(arrTask[currentID]);
			}
			else
			{
				openLoading = false;
				currentID = -1;
				arrTask = null;
			}
		}
		
		private function askSaveDifficultArchive():void{
			var outObject:Object = new Object();
			outObject.type = MessageWindow.WARNING;
			outObject.text = MessageText.DIFFICULT_ARCHIVE;
			outObject.button = ['Да','Нет'];
			outObject.dispather = ['onPrepareArchive','onNothing'];
			message.message = outObject;
			message.addEventListener('onPrepareArchive', createDiffArchive);
		}
		private function createDiffArchive(event:Event):void{
			//trace(this + ': DINAMIC DISPATHC');
			message.removeEventListener('onPrepareArchive', createDiffArchive);
			prepareDLArchive(true);
		}
		private var remValue:Boolean;
		private function prepareDLArchive(value:Boolean = false):void{
			if(super.dlSaver.isOpen()){
				super.dlSaver.close();
			}else{
				if(designer.isCorrectPosition){
					if(value){
						var difContent:Array = designer.allSeparateTask;
						super.dlSaver.difficultArchive = difContent;
					}else{
						var desContent:Array = designer.getContent();
						super.dlSaver.open(desContent[0], desContent[1]);
					}
				}else{
					remValue = value;
					var outObject:Object = new Object();
					outObject.type = MessageWindow.WARNING;
					outObject.text = MessageText.NOT_CORRECT_POSITION_TASK;
					outObject.button = ['Исправить', 'Продолжить', 'Отменить'];
					outObject.dispather = ['onCorrectTask', 'onComplateSave', 'onNothing'];
					message.addEventListener('onCorrectTask', CORRECT_TASK);
					message.addEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK);
					message.message = outObject;
				}
			}
		}
		private function CORRECT_TASK(event:Event):void{
			message.removeEventListener('onCorrectTask', CORRECT_TASK);
			message.removeEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK);
			designer.normalizePosition();
		}
		private function ON_COMPLATE_SAVE_TASK(event:Event):void{
			message.removeEventListener('onCorrectTask', CORRECT_TASK);
			message.removeEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK);
			if(remValue){
				var difContent:Array = designer.allSeparateTask;
				super.dlSaver.difficultArchive = difContent;
			}else{
				var desContent:Array = designer.getContent();
				super.dlSaver.open(desContent[0], desContent[1]);
			}
		}
		
		
		
		//	Открытие соединения с сокет-сервером
		private function openSocketConnector():void{
			//if(socketController == null) socketController = new SocketController(super.containerForWindow, super.windowWidth, super.windowHeight - Menu.MENU_HEIGHT);
			if(socketController.isOpen) socketController.close();
			else socketController.open();
		}
		private function FILL_UPLOAD_FORM(event:Event):void{
			trace(this + ': task ID: ' + MainTaskDownloader.tempSaver.tid);
			trace(this + ': task path: ' + MainTaskDownloader.tempSaver.path);
			socketController.setRequisit(MainTaskDownloader.tempSaver.tid, MainTaskDownloader.tempSaver.path);
		}
		private function UPLOAD_TASK(event:Event):void{
			socketController.uploadContent = designer.getContent();
		}
	}

}