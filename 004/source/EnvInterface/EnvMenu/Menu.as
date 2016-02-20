package source.EnvInterface.EnvMenu {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.EnvEvents.Events;
	import source.EnvEvents.MenuComand;
	import flash.events.FocusEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import source.MainEnvelope;
	
	public class Menu extends Sprite{
		//	Инициализация постоянных
		//	Высота главного меню
		public static var MENU_HEIGHT:int = 22;
		//	Инициализация остальных объектов
		private var menuWidth:int;
		//	Кнопка закрытия
		private var butClose:closeButton;
		//	Кнопка сворачивания
		private var butMinim:minimizeButton;
		
		private var arrMenu:Array = new Array();
		
		private var currentMenuStatus:Boolean = false;
		public var currentLinkStatus:String;
		private var notOpenMenu:Boolean = false;
		
		private var slider:SceneSizeSlider = new SceneSizeSlider();
		private var preloader:VisualPreloader;
		private var greedSelector:SceneGreed;
		public function Menu(menuContainer:Sprite, menuWidth:int) {
			super();
			super.focusRect = false;
			preloader = MainEnvelope.globalPreloader;
			//	помещаем родительский контенер в пришедший
			menuContainer.addChild(super);
			//	запоминаем ширину экрана
			this.menuWidth = menuWidth;
			//	инициируем фон панели меню
			initMenuBackground();
			//	инициируем кнопки закрытия и минимизации приложения
			initButton();
			initMenu();
			super.addEventListener(MouseEvent.MOUSE_OVER, MENU_MOUSE_OVER);
			GET_SIZE_SCENE(null);
		}
		//	метод отрисовки фона меню
		private function initMenuBackground():void{
			source.EnvUtils.EnvDraw.Figure.insertRect(super, menuWidth, MENU_HEIGHT);
			source.EnvUtils.EnvDraw.Figure.insertLine(super, 1, MENU_HEIGHT-1, menuWidth-2, MENU_HEIGHT-1,1,1,0xFFFFFF);
		}
		//	метод инициализации кнопок
		private function initButton():void{
			butClose = new closeButton();
			super.addChild(butClose);
			butClose.y = MENU_HEIGHT/2;
			butClose.x = menuWidth - butClose.width;
			butMinim = new minimizeButton();
			super.addChild(butMinim);
			butMinim.y = MENU_HEIGHT/2;
			butMinim.x = menuWidth - butMinim.width*2;
			butClose.addEventListener(MouseEvent.CLICK, CLOSE_CLICK);
			butMinim.addEventListener(MouseEvent.CLICK, MINIM_CLICK);
		}
		private function CLOSE_CLICK(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.WINDOW_CLOSE));
		}
		private function MINIM_CLICK(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.WINDOW_MINIMIZE));
		}
		private function initMenu():void{
			arrMenu.push(new SampleMenu('Файл'));
			arrMenu[0].addLinkMenu('Открыть', MenuComand.OPEN_TASK);
			arrMenu[0].addLinkMenu('---');
			arrMenu[0].addLinkMenu('Сохранить', MenuComand.SAVE_TASK);
			arrMenu[0].addLinkMenu('Сохранить текущее', MenuComand.SAVE_CURRENT_TASK);
			arrMenu[0].addLinkMenu('---');
			arrMenu[0].addLinkMenu('Архив для DL', MenuComand.DL_SAVER);
			arrMenu[0].addLinkMenu('Архив пакета для DL', MenuComand.DIFICULT_DL_SAVER);
			arrMenu[0].addLinkMenu('---');
			arrMenu[0].addLinkMenu('Заменить задание', MenuComand.OPEN_SOCKET_SERVER_CONNECTION);
			arrMenu[0].addLinkMenu('---');
			arrMenu[0].addLinkMenu('Новое задание', MenuComand.CREATE_NEW_TASK);
			arrMenu[0].addLinkMenu('---');
			arrMenu[0].addLinkMenu('Импорт в библиотеку', MenuComand.IMPORT_FILE);
			
			arrMenu.push(new SampleMenu('Очистка'));
			arrMenu[1].addLinkMenu('Очистить пакет', MenuComand.CLEAR_ALL_TASK);
			arrMenu[1].addLinkMenu('Очистить текущее', MenuComand.CLEAR_CURRENT_TASK);
			arrMenu.push(new SampleMenu('Тестирование'));
			arrMenu[2].addLinkMenu('Тестировать пакет', MenuComand.TEST_TASK);
			arrMenu[2].addLinkMenu('Тестировать текущее', MenuComand.TEST_CURRENT_TASK);
			
			arrMenu.push(new SampleMenu('Управление'));
			arrMenu[3].addLinkMenu('Чёрные на цветные', MenuComand.SET_BLACK_ON_COLOR);
			arrMenu[3].addLinkMenu('Цветные на чёрные', MenuComand.SET_COLOR_ON_BLACK);
			arrMenu[3].addLinkMenu('---');
			arrMenu[3].addLinkMenu('Совместить таны и картинку', MenuComand.SET_IMAGE_TAN_ON_IMAGE);
			
			arrMenu.push(new SampleMenu('Окно'));
			arrMenu[4].addLinkMenu('Библиотека', MenuComand.OPEN_LIBRARY);
			arrMenu[4].addLinkMenu('Настройки', MenuComand.OPEN_SETTINGS);
			arrMenu[4].addLinkMenu('Панель рисования', MenuComand.OPEN_PAINT_PANEL);
			arrMenu[4].addLinkMenu('Цвет', MenuComand.OPEN_COLOR_PICKER);
			arrMenu[4].addLinkMenu('Слои', MenuComand.OPEN_LAYER_PANEL);
			arrMenu[4].addLinkMenu('Дерево задач', MenuComand.OPEN_TASK_TREE_PANEL);
			arrMenu[4].addLinkMenu('Инструменты', MenuComand.OPEN_TOOLS);
			arrMenu[4].addLinkMenu('Сцена', MenuComand.OPEN_MAIN_SCENE);
			
			arrMenu[4].addLinkMenu('---');
			arrMenu[4].addLinkMenu('База картинок', MenuComand.OPEN_BASE_IMAGE_PANEL);
			arrMenu[4].addLinkMenu('База фигур', MenuComand.OPEN_BASE_FIGURE);
			arrMenu[4].addLinkMenu('Менеджер базы данных', MenuComand.OPEN_MANAGER);
			arrMenu[4].addLinkMenu('База заданий OnLine', MenuComand.OPEN_ONLINE_BASE);
			
			arrMenu.push(new SampleMenu('Расстановка'));
			arrMenu[5].addLinkMenu('Стандартная', MenuComand.STANDART_PANELS_POSITION);
			arrMenu[0].x = 30;
			var i:int;
			for(i=0;i<arrMenu.length;i++){
				super.addChild(arrMenu[i]);
				if(i!=0) arrMenu[i].x =  arrMenu[i-1].x +  arrMenu[i-1].getWidthBut() + 3;
				arrMenu[i].finalyList();
				arrMenu[i].addEventListener(Events.MENU_CHANGE_STATUS, MENU_CHANGED);
				arrMenu[i].addEventListener(Events.LINK_DISPATCH_STATUS, LINK_DISPATCHED);
			}
			
			super.addChild(slider);
			slider.x = arrMenu[arrMenu.length-1].x + 100;
			slider.addEventListener(SceneSizeSlider.GET_PERCENT, GET_SIZE_SCENE);
			
			greedSelector = new SceneGreed();
			super.addChild(greedSelector);
			greedSelector.y = 1;
			greedSelector.x = slider.x + slider.width + 10;
			greedSelector.addEventListener(SceneGreed.HIDE_GREED, HIDE_GREED);
			greedSelector.addEventListener(SceneGreed.SHOW_GREED, SHOW_GREED);
			
			super.addChild(preloader);
			preloader.y = 1;
			preloader.x = greedSelector.x + greedSelector.width + 10;
		}
		private function MENU_CHANGED(e:Event):void{
			//trace(this+": MENU Status = " + e.target.butStatus);
			//stage.focus = super;
			var remStatus:Object = e.target.butStatus;
			if(remStatus == SampleMenu.DOWN && notOpenMenu){
				remStatus == SampleMenu.OVER;
				currentMenuStatus = false;
				notOpenMenu = false;
				super.removeEventListener(FocusEvent.FOCUS_OUT, STAGE_FOCUS_OUT);
			}else{
				if(remStatus == SampleMenu.DOWN){
					currentMenuStatus = true;
					super.addEventListener(FocusEvent.FOCUS_OUT, STAGE_FOCUS_OUT);
				}
			}
			closeMenu();
			if(currentMenuStatus){
				e.target.setStatus(SampleMenu.DOWN);
			}else{
				e.target.setStatus(remStatus);
			}
		}
		private function STAGE_FOCUS_OUT(e:FocusEvent):void{
			//trace(this+': Focus OUT, not Open = ' + notOpenMenu);
			notOpenMenu = true;
			super.removeEventListener(FocusEvent.FOCUS_OUT, STAGE_FOCUS_OUT);
			currentMenuStatus = false;
			var focusTimer:Timer = new Timer(100, 1);
			focusTimer.addEventListener(TimerEvent.TIMER, FOCUS_TIMER_COMPLATE);
			focusTimer.start();
			
		}
		private function FOCUS_TIMER_COMPLATE(e:TimerEvent):void{
			closeMenu();
			notOpenMenu = false;
		}
		private function closeMenu():void{
			var i:int;
			for(i=0;i<arrMenu.length;i++){
				arrMenu[i].setStatus(SampleMenu.OUT);
			}
		}
		private function LINK_DISPATCHED(e:Event):void{
			//trace(this + ": MENU DISPATCH STATUS OF LINK");
			currentLinkStatus = e.target.currentLinkStatus;
			super.dispatchEvent(new Event(Events.LINK_DISPATCH_STATUS));
			STAGE_FOCUS_OUT(null);
		}
		private function MENU_MOUSE_OVER(event:MouseEvent):void{
			Mouse.show();
		}
		
		private var scenePercent:Number = 100;
		private function GET_SIZE_SCENE(event:Event):void{
			scenePercent = this.slider.scale;
			super.dispatchEvent(new Event(SceneSizeSlider.GET_PERCENT));
		}
		public function get percent():Number{
			return scenePercent;
		}
		
		
		private function HIDE_GREED(event:Event):void{
			super.dispatchEvent(new Event(SceneGreed.HIDE_GREED));
		}
		private function SHOW_GREED(event:Event):void{
			super.dispatchEvent(new Event(SceneGreed.SHOW_GREED));
		}
	}
	
}
