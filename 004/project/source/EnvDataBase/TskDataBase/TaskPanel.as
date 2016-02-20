package source.EnvDataBase.TskDataBase {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvInterface.EnvPanel.Panel;
	import source.EnvEvents.Events;
	import source.EnvComponents.EnvButton.SimpleButton;
	import flash.events.Event;
	import source.EnvDataBase.TskDataBase.TskPlayer.TaskPlayer;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class TaskPanel extends Sprite{
		//	Высота кнопок панели
		public static const butHeight:Number = 22;
		//	Процент разделения окна здесь указывается процент окна под плеер
		public static const percentPosition:int = 70;
		private static const yPlayer:int = 30;
		//	ширина окна отображения (входной параметр)
		private var winWidth:Number;
		//	высота окна отображения (входной параметр)
		private var winHeight:Number;
		//	контенер плеера
		private var playerContainer:Sprite;
		//	контенер отображения контенера плеера и панели инструментов
		private var lookContainer:Sprite = new Sprite;
		//	контенер отображения панели заданий и кнопок
		private var taskContainer:Sprite = new Sprite;
		//	ссылка на панель заданий
		private var taskPanel:Panel;
		//	кнопка загрузки базы в дерево
		private var loadButton:SimpleButton;
		//	кнопка открытия менеджера базы (разработка отложена)
		private var reloadButton:SimpleButton;
		//	кнопка просмотра задания в плеере
		private var lookButton:SimpleButton;
		//	кнопка добавления задания в текущий список в конструкторе
		private var addButton:SimpleButton;
		//	редактировать задание (обнулить текущее дерево заданий)
		private var editButton:SimpleButton;
		//	отметить задание для добавления или редактирования
		private var markButton:SimpleButton;
		public function TaskPanel(winWidth:Number, winHeight:Number) {
			super();
			//	Запоминаем размеры окна
			this.winWidth = winWidth;
			this.winHeight = winHeight;
			//	отрисовываем фон панели
			initBackground();
			//	инициализируем контенеры панели
			initContainer();
		}
		//	метод отрисовки фона
		private function initBackground():void{
			Figure.insertRect(super, this.winWidth, this.winHeight);
		}
		//	метод инициализации контенеров
		private function initContainer():void{
			super.addChild(lookContainer);
			super.addChild(taskContainer);
			taskContainer.x = (winWidth/100)*percentPosition;
		}
		//	метод получения панели (происходит из класса BaseStartClass)
		public function setPanel(panel:Panel):void{
			//	запоминаем панель
			taskPanel = panel;
			//	делаем её не динамической
			taskPanel.activeHandler(false);
			//	удаляем возможность переносить панель
			taskPanel.removeDragble();
			//	устанавливаем размеры панели
			taskPanel.setSizePanel(((winWidth/100)*(100-percentPosition)) - Panel.deltaXY*2, (winHeight-butHeight*3));
			//	перемещаем панель в контенер окна
			taskContainer.addChild(taskPanel);
			//	размещаем панель так чтобы осталось место для двух кнопок над ней, 
			//	которые перекроют полосу перемещения панели
			taskPanel.y = butHeight-Panel.dragPanelHeight;
			//	инициализируем кнопки
			initButton();
		}
		//	метод инициализации кнопок
		private function initButton():void{
			//	вычисляем ширину кнопок относительно процентной состаляющей размера контенера отображения
			var butWidth:Number = ((winWidth/100)*(100-percentPosition))/2;
			//	определяем кнопки, размер и заголовок
			loadButton = new SimpleButton(butWidth, butHeight, 'Загрузить');
			reloadButton = new SimpleButton(butWidth, butHeight, 'Обновить');
			lookButton = new SimpleButton(butWidth, butHeight, 'Посмотреть');
			addButton = new SimpleButton(butWidth, butHeight, 'Добавить');
			editButton = new SimpleButton(butWidth, butHeight, 'Редактировать');
			markButton = new SimpleButton(butWidth, butHeight, 'Снять выделение');
			//	добавляем кнопки в контенер
			taskContainer.addChild(loadButton);
			taskContainer.addChild(reloadButton);
			taskContainer.addChild(lookButton);
			taskContainer.addChild(addButton);
			taskContainer.addChild(editButton);
			taskContainer.addChild(markButton);
			//	определяем позиции кнопок
			reloadButton.x = addButton.x = markButton.x = butWidth;
			addButton.y = lookButton.y = winHeight-butHeight*2;
			editButton.y = markButton.y = winHeight-butHeight;
			//	делаем кнопки задизеблеными
			lookButton.enabled(false);
			addButton.enabled(false);
			editButton.enabled(false);
			markButton.enabled(false);
			
			
			loadButton.addEventListener(MouseEvent.MOUSE_DOWN, LOAD_TREE_MOUSE_DOWN);
			
			lookButton.addEventListener(MouseEvent.MOUSE_DOWN, LOOK_TASK_MOUSE_DOWN);
			addButton.addEventListener(MouseEvent.MOUSE_DOWN, ADD_TASK_MOUSE_DOWN);
			
			taskContainer.addEventListener(MouseEvent.ROLL_OVER, TASK_TREE_MOUSE_OVER);
		}
		//	Метод установки плеера в окно менеджера
		internal function addPlayer(inPlayer:TaskPlayer):void{
			//	определение контенера отображения плеера
			playerContainer = new Sprite();
			//	добавление плеера в свой контенер отображения
			playerContainer.addChild(inPlayer);
			//	добавление контенера плеера в контенер окна
			lookContainer.addChild(playerContainer);
			//	расчёт размера окна для отображения плеера
			var wPlayContainer:Number = (winWidth/100)*percentPosition;
			//	позиционирование сонтенера плеера
			playerContainer.x = (wPlayContainer-playerContainer.width)/2;
			playerContainer.y = yPlayer;
			//	отрисовка фона контенера плеера
			//Figure.insertRect(playerContainer, playerContainer.width, playerContainer.height, 0, 0, 0x000000, 1, 0xFFFFFF);
		}
		private function LOAD_TREE_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.LOAD_TASK_TREE_FROM_DB));
		}
		private function LOOK_TASK_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.LOOK_SELECTED_TASK));
		}
		private function ADD_TASK_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(Events.ADD_SELECTED_TASK));
		}
		//	Метод блокировки кнопки "Загрузить"
		public function loadButtonEnabled(f:Boolean):void{
			loadButton.enabled(f);
		}
		//	Метод блокировки кнопок связанных с выделенными заданиями в дереве
		public function funcBottonEnabled(f:Boolean):void{
			lookButton.enabled(f);
			addButton.enabled(f);
			editButton.enabled(f);
			markButton.enabled(f);
		}
		private function TASK_TREE_MOUSE_OVER(e:MouseEvent):void{
			Mouse.show();
		}
	}
	
}
