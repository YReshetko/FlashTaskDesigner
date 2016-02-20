package source.utils.EnvScrollBar {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class Scroller extends Sprite{
		//	Переменная генерируемого события изменения ползунка
		public static var SCROLL_CHANGE_POSITION:String = 'onScrollChangePosition';
		//	высота смещения скроллинга при нажатии на кнопки
		private static const deltaH:int = 1;
		//	Цвет фона полосы прокрутки
		private static const bgColor:uint = 0xE0E0E0;
		//	Цвет границ частей скролинга
		private static const borderColor:uint = 0x6B6B6B;
		//	Цвета взаимодействия частей скроллинга с мышью
		private static const butOutColor:uint = 0xBFBFBF;
		private static const butOverColor:uint = 0xAFAFAF;
		private static const butDownColor:uint = 0x898989;
		//	Параметры рисования треугольников в кнопках скроллинга
		private static const topTreangle:Array = [[7.5, 2.5],[12.5, 12.5],[2.5, 12.5]];
		private static const botTreangle:Array = [[7.5, 12.5],[12.5, 2.5],[2.5, 2.5]];
		//	Стандартная ширина скролинга
		public static var wBar:Number = 15;
		//	Текущая высота скроллинга (общая)
		private var hBar:Number;
		//	Текущая высота ползунка
		internal var hScroll:Number;
		//	Контенеры отображения частей скроллинкга
		internal var topBut:Sprite = new Sprite();
		internal var botBut:Sprite = new Sprite();
		internal var bgBar:Sprite = new Sprite();
		internal var dragBar:Sprite = new Sprite();
		public function Scroller() {
			super();
			//	Инициализация контенеров и их прослушивания
			initContainers();
			//	Инициализация вида кнопок
			initButton();
		}
		//	Метод инициализации контенеров и их прослушивания
		private function initContainers():void{
		//	Добавление контенеров в объект
			super.addChild(bgBar);
			super.addChild(dragBar);
			super.addChild(topBut);
			super.addChild(botBut);
			//	Прослушивание взаимодействия кнопки вверх
			topBut.addEventListener(MouseEvent.MOUSE_DOWN, TOP_BUT_MOUSE_DOWN);
			topBut.addEventListener(MouseEvent.MOUSE_OVER, TOP_BUT_MOUSE_OVER);
			topBut.addEventListener(MouseEvent.MOUSE_OUT, TOP_BUT_MOUSE_OUT);
			topBut.addEventListener(MouseEvent.MOUSE_UP, TOP_BUT_MOUSE_UP);
			//	Прослушивание взаимодействия кнопки вниз
			botBut.addEventListener(MouseEvent.MOUSE_DOWN, BOT_BUT_MOUSE_DOWN);
			botBut.addEventListener(MouseEvent.MOUSE_OVER, BOT_BUT_MOUSE_OVER);
			botBut.addEventListener(MouseEvent.MOUSE_OUT, BOT_BUT_MOUSE_OUT);
			botBut.addEventListener(MouseEvent.MOUSE_UP, BOT_BUT_MOUSE_UP);
			//	Прослушивание взаимодействия ползунка скролинга
			dragBar.addEventListener(MouseEvent.MOUSE_DOWN, SCROLL_BUT_MOUSE_DOWN);
			dragBar.addEventListener(MouseEvent.MOUSE_OVER, SCROLL_BUT_MOUSE_OVER);
			dragBar.addEventListener(MouseEvent.MOUSE_OUT, SCROLL_BUT_MOUSE_OUT);
			dragBar.addEventListener(MouseEvent.MOUSE_UP, SCROLL_BUT_MOUSE_UP);
		}
		//	Отрисовка кнопок Вверх и Вниз
		private function initButton():void{
			Figure.insertRect(topBut, wBar, wBar, 1, 1, borderColor, 1, butOutColor);
			Figure.insertCurve(topBut, topTreangle);
			Figure.insertRect(botBut, wBar, wBar, 1, 1, borderColor, 1, butOutColor);
			Figure.insertCurve(botBut, botTreangle);
		}
		//	Установка высоты ползунка и его отрисовка
		public function setHeight(h:Number):void{
			hBar = h;
			Figure.insertRect(bgBar, wBar, hBar, 1, 1, borderColor, 1, bgColor);
			//	Метод расстановки кнопок по своим местам
			initBar();
		}
		//	Метод расстановки кнопок по своим местам
		private function initBar():void{
			bgBar.x = bgBar.y = 0;
			topBut.x = topBut.y = 0;
			botBut.x = 0; botBut.y = hBar - wBar;
		}
		//	Инициализация ползунка скроллинга (текущая отрисовка)
		public function initScroll():void{
			Figure.insertRect(dragBar, wBar, hScroll, 1, 1, borderColor, 1, butOutColor);
		}
		//	Методы обработки наведения и нажатия кнопки мыши над кнопкой Вверх
		private function TOP_BUT_MOUSE_DOWN(e:MouseEvent):void{
			Figure.insertRect(topBut, wBar, wBar, 1, 1, borderColor, 1, butDownColor);
			Figure.insertCurve(topBut, topTreangle);
			//	При нажатии запускаем ентер фрейм, который проигрывает смещение ползунка
			super.addEventListener(Event.ENTER_FRAME, TOP_BUT_ENTER_FRAME);
			//	Также запускаем слушателя сцены отпускания клавиши мыши
			stage.addEventListener(MouseEvent.MOUSE_UP, TOP_BUT_MOUSE_UP);
		}
		private function TOP_BUT_MOUSE_OVER(e:MouseEvent):void{
			Figure.insertRect(topBut, wBar, wBar, 1, 1, borderColor, 1, butOverColor);
			Figure.insertCurve(topBut, topTreangle);
		}
		private function TOP_BUT_MOUSE_OUT(e:MouseEvent):void{
			Figure.insertRect(topBut, wBar, wBar, 1, 1, borderColor, 1, butOutColor);
			Figure.insertCurve(topBut, topTreangle);
		}
		//	При отпускании мыши над сценой или над кнопкой удаляем ентерфрейм и поднятие мыши над сценой
		private function TOP_BUT_MOUSE_UP(e:MouseEvent):void{
			super.removeEventListener(Event.ENTER_FRAME, TOP_BUT_ENTER_FRAME);
			stage.removeEventListener(MouseEvent.MOUSE_UP, TOP_BUT_MOUSE_UP);
			TOP_BUT_MOUSE_OUT(null);
		}
		//	Метод проигрывания смещения ползунка во времени
		private function TOP_BUT_ENTER_FRAME(e:Event):void{
			//	Смещеть ползунок вверх на deltaH едениц
			var newY:Number = dragBar.y - deltaH;
			//	Проверяем не вышло ли новое положение за допустимые пределы
			if(newY < wBar) {
				//	Если вышло, то устанавливаем скрол в верхнее положение
				newY = wBar;
				//	Имитируем поднятие мыши
				TOP_BUT_MOUSE_UP(null);
			}
			//	Переводим ползунок в новое положение
			dragBar.y = newY;
			//	диспатчим смещение ползунка
			SCROLL_MOUSE_MOVE(null);
		}
		//	Методы обработки наведения и нажатия кнопки мыши над кнопкой Вниз
		//	Обработка точно такая же как и для первой кнопки (симетрично)
		private function BOT_BUT_MOUSE_DOWN(e:MouseEvent):void{
			Figure.insertRect(botBut, wBar, wBar, 1, 1, borderColor, 1, butDownColor);
			Figure.insertCurve(botBut, botTreangle);
			super.addEventListener(Event.ENTER_FRAME, BOT_BUT_ENTER_FRAME);
			stage.addEventListener(MouseEvent.MOUSE_UP, BOT_BUT_MOUSE_UP);
		}
		private function BOT_BUT_MOUSE_OVER(e:MouseEvent):void{
			Figure.insertRect(botBut, wBar, wBar, 1, 1, borderColor, 1, butOverColor);
			Figure.insertCurve(botBut, botTreangle);
		}
		private function BOT_BUT_MOUSE_OUT(e:MouseEvent):void{
			Figure.insertRect(botBut, wBar, wBar, 1, 1, borderColor, 1, butOutColor);
			Figure.insertCurve(botBut, botTreangle);
		}
		private function BOT_BUT_MOUSE_UP(e:MouseEvent):void{
			super.removeEventListener(Event.ENTER_FRAME, BOT_BUT_ENTER_FRAME);
			stage.removeEventListener(MouseEvent.MOUSE_UP, BOT_BUT_MOUSE_UP);
			BOT_BUT_MOUSE_OUT(null);
		}
		private function BOT_BUT_ENTER_FRAME(e:Event):void{
			var newY :Number= dragBar.y + deltaH;
			if(newY > botBut.y - hScroll) {
				newY = botBut.y-hScroll;
				BOT_BUT_MOUSE_UP(null);
			}
			dragBar.y = newY;
			SCROLL_MOUSE_MOVE(null);
		}
		//	Методы обработки наведения и нажатия кнопки мыши над ползунком
		private function SCROLL_BUT_MOUSE_DOWN(e:MouseEvent):void{
			Figure.insertRect(dragBar, wBar, hScroll, 1, 1, borderColor, 1, butDownColor);
			//	При нажатии определяем в какой области можно перетаскивать ползунок
			var dragHeight:Number = bgBar.height - 2*wBar - hScroll;
			var rect:Rectangle = new Rectangle(0, wBar, 0, dragHeight);
			//	Делаем его перетаскиваемым
			dragBar.startDrag(false, rect);
			//	Ставим слушателей на сцену для определения движения мыши с ползунком
			stage.addEventListener(MouseEvent.MOUSE_MOVE, SCROLL_MOUSE_MOVE);
			//	Ставим слушателей на сцену для определения момента отпускания мыши
			stage.addEventListener(MouseEvent.MOUSE_UP, SCROLL_BUT_MOUSE_UP);
		}
		private function SCROLL_BUT_MOUSE_OVER(e:MouseEvent):void{
			Figure.insertRect(dragBar, wBar, hScroll, 1, 1, borderColor, 1, butOverColor);
		}
		private function SCROLL_BUT_MOUSE_OUT(e:MouseEvent):void{
			Figure.insertRect(dragBar, wBar, hScroll, 1, 1, borderColor, 1, butOutColor);
		}
		//	Отпускание мыши
		private function SCROLL_BUT_MOUSE_UP(e:MouseEvent):void{
			//	удаляем слушатель движения и отпускания мыши над сценой
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, SCROLL_MOUSE_MOVE);
			stage.removeEventListener(MouseEvent.MOUSE_UP, SCROLL_BUT_MOUSE_UP);
			//	Запускаем метод сведения мыши с ползунка
			SCROLL_BUT_MOUSE_OUT(null);
			//	Диспатчим событие смещение ползунка
			SCROLL_MOUSE_MOVE(null);
			//	Останавливаем перетаскивание ползунка
			dragBar.stopDrag();
		}
		//	Метод движения ползунка по скрол бару
		private function SCROLL_MOUSE_MOVE(e:MouseEvent):void{
			//	Диспатчим событие о смещении ползунка
			super.dispatchEvent(new Event(SCROLL_CHANGE_POSITION));
		}
	}
	
}
