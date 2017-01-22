package source {
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.MouseEvent;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import source.DBSaver.TempSaver;
	import source.EnvUtils.Logo.StartLogo;
	import source.EnvInterface.EnvMenu.Menu;
	import source.EnvEvents.Events;
	import source.EnvInterface.EnvPanel.PanelSpace;
	import source.EnvKonstraktion.InitKonstraction;
	import source.EnvEvents.MenuComand;
	import source.EnvLoader.LoadFiles;
	import source.EnvUtils.EnvString.ConvertString;
	import source.EnvInterface.EnvPanel.Panel;
	import source.EnvLoader.SaveFiles;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvDataBase.Manager.DlManager;
	import source.EnvDataBase.TskDataBase.TaskBase;
	import source.EnvLoader.DLArchive.DLSaver;
	import source.WindowInterface.MainTaskDownloader;
	import source.Components.MessageWindow;
	import source.Components.MessageText;
	import source.EnvInterface.EnvMenu.SceneSizeSlider;
	import flash.filesystem.File;
	import source.EnvInterface.EnvMenu.SceneGreed;
	
	public class BaseStartClass extends Sprite{
		private var startLogo:StartLogo;
		//	Определение контенеров
		//	Контенер фона
		private var backgroundContainer:Sprite = new Sprite();
		//	Конструктор
		private var developeContainer:Sprite = new Sprite();
		//	Панели
		private var panelContainer:Sprite = new Sprite();
		//	Контенер дополнительных окон
		private var windowContainer:Sprite = new Sprite();
		//	Ошибки
		internal var errorContainer:Sprite = new Sprite();
		//	Перемещение отдельных объектов
		public var dragContainer:Sprite = new Sprite();
		//	Меню
		private var menuContainer:Sprite = new Sprite();
		//	Переменные размеров окна приложения
		internal var windowHeight:int;
		internal var windowWidth:int;
		//	Переменная главного меню
		public var envMenu:Menu;
		public var envPanel:PanelSpace;
		
		//	Переменная конструктора
		public var designer:InitKonstraction;
		
		public var envLoader:LoadFiles;
		
		public var envSaver:SaveFiles;
		
		public var dlSaver:DLSaver;
		
		public var taskBase:TaskBase;
		public var onlineBase:MainTaskDownloader;
		public function BaseStartClass() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, baseWindowInit);
			//baseWindowInit();
		}
		private function baseWindowInit(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, baseWindowInit);
			//	блокируем масштабируемость объектов сцены
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//	выравнивание сцены идёт по верхнему левому краю
			stage.align = StageAlign.TOP_LEFT
			//	слушатель завершения процесса масштабирования окна приложения
			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, BASE_WINDOW_INIT_COMPLATE);
			//	развёртывание окна приложения на полную
			stage.nativeWindow.maximize();
			stage.stageFocusRect = false;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, STAGE_MOUSE_DOWN);
		}
		private function STAGE_MOUSE_DOWN(e:MouseEvent):void{
			//trace(this + ": TARGET MOUSE DOWN = " + e.target);
			stage.focus = e.target as InteractiveObject;
		}
		private function BASE_WINDOW_INIT_COMPLATE(e:NativeWindowDisplayStateEvent):void{
			//	удаляем слушатель масштабирования окна
			stage.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, BASE_WINDOW_INIT_COMPLATE);
			//	фиксируем переменные размера окна
			windowWidth = stage.nativeWindow.width;
			windowHeight = stage.nativeWindow.height;
			initLogo();
			initObjects();
		}
		private function initLogo():void{
			startLogo = new StartLogo();
			super.addChild(startLogo);
			startLogo.x = windowWidth/2;
			startLogo.y = windowHeight/2;
		}
		private function initObjects():void{
			//	инициализируем контенеры отображения
			initLoader();
			initSaver();
			initDLSaver();
			initMenu();
			//initManager();
			envPanel = new PanelSpace(panelContainer);
			initTaskBase();
			initOnlineBase();
			designer = new InitKonstraction(envPanel.addPanel('СЦЕНА'));
			designer.addEventListener(Events.DESIGNE_INIT_COMPLATE, DESIGNER_INIT_COMPLATE);
			designer.addEventListener(Events.GET_PANEL_FOR_SETTINGS, SET_PANEL);
			designer.addEventListener(Events.GET_DRAG_CONTAINER, SET_DRAG_CONTAINER);
			designer.initSystemPanel([envPanel.addPanel('НАСТРОЙКИ')		,
									  envPanel.addPanel('ЦВЕТ')				,
									  envPanel.addPanel('ИНСТРУМЕНТЫ')		,
									  envPanel.addPanel('ПАНЕЛЬ РИСОВАНИЯ')	,
									  envPanel.addPanel('СЛОИ')				,
									  envPanel.addPanel('ДЕРЕВО ЗАДАЧ')		,
									  envPanel.addPanel('БАЗА КАРТИНОК')	,
									  envPanel.addPanel('БАЗА ФИГУР')]);
			designer.initWindowSize(windowWidth, windowHeight-Menu.MENU_HEIGHT);
			designer.initTestPlayer(windowContainer);
			designer.start();
			MainTaskDownloader.tempSaver.addEventListener(TempSaver.SAVE_COMPLATE, LOAD_TEMP_FILE);
			MainTaskDownloader.tempSaver.addEventListener(TempSaver.SAVE_PACKAGE_COMPLATE, LOAD_TEMP_PACKAGE_FILE);
			SET_SCENE_PERCENT(null);
		}
		private function initTaskBase():void{
			taskBase = new TaskBase(windowWidth, windowHeight-Menu.MENU_HEIGHT*1.5, windowContainer,envPanel.addPanel(''));
		}
		private function initOnlineBase():void{
			onlineBase = new MainTaskDownloader(windowWidth, windowHeight-Menu.MENU_HEIGHT*1.5, windowContainer);
		}
		//	Метод инициализации загрузчика
		private function initLoader():void{
			envLoader = new LoadFiles();
		}
		//	Метод инициализации сохраняющего объекта
		private function initSaver():void{
			envSaver = new SaveFiles();
		}
		private function initDLSaver():void{
			dlSaver = new DLSaver(windowContainer, windowWidth, windowHeight-Menu.MENU_HEIGHT);
		}
		//	Метод инициализации главного меню
		private function initMenu():void{
			envMenu = new Menu(menuContainer, windowWidth);
			envMenu.addEventListener(Events.WINDOW_CLOSE, MENU_WINDOW_CLOSE);
			envMenu.addEventListener(Events.WINDOW_MINIMIZE, MENU_WINDOW_MINIMIZE);
			envMenu.addEventListener(SceneSizeSlider.GET_PERCENT, SET_SCENE_PERCENT);
			envMenu.addEventListener(SceneGreed.HIDE_GREED, HIDE_SCENE_GREED);
			envMenu.addEventListener(SceneGreed.SHOW_GREED, SHOW_SCENE_GREED);
		}
		private function HIDE_SCENE_GREED(event:Event):void{
			designer.hideGreed();
		}
		
		private function SHOW_SCENE_GREED(event:Event):void{
			designer.showGreed();
		}
		private function SET_SCENE_PERCENT(event:Event):void{
			designer.sizeMainScene = envMenu.percent;

		}
		
		public function closeWindow():void{
			stage.nativeWindow.close();
			var file:File = new File();
			file = File.applicationDirectory.resolvePath('Envelope.exe');
			try{
				file.openWithDefaultApplication();
			}catch(e:Error){
				trace(this + ': ERROR OPEN ENVELOPE');
			}
		}
		private function MENU_WINDOW_CLOSE(e:Event):void{
			stage.nativeWindow.close();
		}
		private function MENU_WINDOW_MINIMIZE(e:Event):void{
			stage.nativeWindow.minimize();
		}
		private function DESIGNER_INIT_COMPLATE(e:Event):void{
			super.removeChild(startLogo);
			startLogo = null;
			initContainer();
		}
		//	Метод добавления контенеров на сцену
		private function initContainer():void{
			//super.addChild(backgroundContainer);
			super.addChild(developeContainer);
			super.addChild(panelContainer);
			super.addChild(windowContainer);
			super.addChild(dragContainer);
			super.addChild(errorContainer);
			super.addChild(menuContainer);
			windowContainer.y = developeContainer.y = errorContainer.y = source.EnvInterface.EnvMenu.Menu.MENU_HEIGHT;
			//Figure.insertRect(backgroundContainer, windowWidth, windowHeight, 1, 1, 0x000000, 1, 0xFFFFFF);
			super.dispatchEvent(new Event(Events.WINDOW_INIT_COMPLATE));
		}
		//	Обобщённый метод добавления пнелей в классы
		private function SET_PANEL(e:Event):void{
			trace(this + ': SET PANEL ' + e.target.panelName + " IN OBJECT " + e.target);
			var newName:String = e.target.panelName;
			var panel:Panel = envPanel.addPanel(newName);
			e.target.setPanel(panel);
		}
		//	Метод для добавления в объекты контенера перемещения дополнительных объектов
		private function SET_DRAG_CONTAINER(e:Event):void{
			e.target.setDragContainer(dragContainer);
		}
		private function LOAD_TEMP_FILE(event:Event):void{
			super.dispatchEvent(new Event(Events.ADD_DL_REQUISIT_TO_UPLOAD_FORM));
			var inArr:Array = designer.getContent(false);
			var taskXml:XMLList = new XMLList(inArr[0]);
			taskXml = taskXml.TASK.OBJECTS;
			if(taskXml.hasComplexContent()){
				var outObject:Object = new Object();
				outObject.type = MessageWindow.WARNING;
				outObject.text = MessageText.IS_CREATE_NEW_TASK;
				outObject.button = ['С пустого','Поверх', 'Не загружать'];
				outObject.dispather = ['onFreeTask','onOverTask', 'onNothing'];
				MainEnvelope.message.message = outObject;
				MainEnvelope.message.addEventListener('onFreeTask', loadOneForFreeTask);
				MainEnvelope.message.addEventListener('onOverTask', loadOneForOverTask);
			}else{
				envLoader.loadLocalTextFile('temp/Position.txt');
			}
		}
		private function loadOneForFreeTask(event:Event):void{
			MainEnvelope.message.removeEventListener('onFreeTask', loadOneForFreeTask);
			MainEnvelope.message.removeEventListener('onOverTask', loadOneForOverTask);
			designer.createNewTask();
			envLoader.loadLocalTextFile('temp/Position.txt');
		}
		private function loadOneForOverTask(event:Event):void{
			MainEnvelope.message.removeEventListener('onFreeTask', loadOneForFreeTask);
			MainEnvelope.message.removeEventListener('onOverTask', loadOneForOverTask);
			envLoader.loadLocalTextFile('temp/Position.txt');
		}
		public var arrLoadTempTask:Array = new Array();
		private function LOAD_TEMP_PACKAGE_FILE(event:Event):void{
			var inArr:Array = designer.getContent(false);
			var taskXml:XMLList = new XMLList(inArr[0]);
			taskXml = taskXml.TASK.OBJECTS;
			if(taskXml.hasComplexContent()){
				var outObject:Object = new Object();
				outObject.type = MessageWindow.WARNING;
				outObject.text = MessageText.IS_CREATE_NEW_TASK;
				outObject.button = ['С пустого','Поверх', 'Не загружать'];
				outObject.dispather = ['onFreeTask','onOverTask', 'onNothing'];
				MainEnvelope.message.message = outObject;
				MainEnvelope.message.addEventListener('onFreeTask', loadForFreeTask);
				MainEnvelope.message.addEventListener('onOverTask', loadForOverTask);
			}else{
				complateLoadingTempTask();
			}
		}
		private function loadForFreeTask(event:Event):void{
			MainEnvelope.message.removeEventListener('onFreeTask', loadForFreeTask);
			MainEnvelope.message.removeEventListener('onOverTask', loadForOverTask);
			designer.createNewTask();
			complateLoadingTempTask();
		}
		private function loadForOverTask(event:Event):void{
			MainEnvelope.message.removeEventListener('onFreeTask', loadForFreeTask);
			MainEnvelope.message.removeEventListener('onOverTask', loadForOverTask);
			complateLoadingTempTask();
		}
		private function complateLoadingTempTask():void{
			while(arrLoadTempTask.length>0) arrLoadTempTask.shift();
			var i:int;
			var l:int;
			l = MainTaskDownloader.tempSaver.numTask;
			for(i=0;i<l;i++){
				arrLoadTempTask.push('temp/' + i + '/Position.txt');
			}
			super.dispatchEvent(new Event(Events.TEMP_FILE_SAVE_COMPLATE));
		}
		
		public function get containerForWindow():Sprite{
			return windowContainer;
		}
	}
	
}
