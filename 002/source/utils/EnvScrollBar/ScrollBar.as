package source.utils.EnvScrollBar {
	import flash.events.Event;
	
	public class ScrollBar extends Scroller{
		//	Переменная слушателя скроллирования
		public static var SCROLLING:String = 'onScrolling';
		//	переменная высоты активного окна
		private var windowHeight:Number;
		//	возвращаемая переменная позиции листа
		private var currentListY:Number;
		public function ScrollBar() {
			//	инициализация суперкласса скроллинга
			super();
			//	инициализация слушателя передвижения ползунка
			super.addEventListener(Scroller.SCROLL_CHANGE_POSITION, CHANGE_POSITION);
		}
		//	установка параметров панели при изменении рабочего окна панели
		public function setSettings(listHeight:Number, windowHeight:Number, listY:Number):void{
			//	установка высоты активного окна панели
			this.windowHeight = windowHeight + 1;
			//	отрисовка скроллинга по высоте окна
			super.setHeight(this.windowHeight);
			//	определение высоты части бара, по которой перемещается ползунок
			var funcBG:Number = this.windowHeight - Scroller.wBar*2;
			//	определение и установка высоты ползунка
			super.hScroll =  (windowHeight/listHeight)*funcBG;
			//	перерисовка ползунка в суперклассе
			super.initScroll();
			//	установка ползунка на нужную позицию относительно смещения листа с данными
			dragBar.y = Scroller.wBar + ((-1) * listY * hScroll)/windowHeight;
			if(dragBar.y > botBut.y-hScroll){
				dragBar.y = botBut.y-hScroll;
				CHANGE_POSITION(null);
			}
		}
		//	метод слушателя смещения ползунка в суперклассе
		private function CHANGE_POSITION(e:Event):void{
			//	вычисление текущего положения листа
			currentListY = (-1) * ((dragBar.y - Scroller.wBar)*windowHeight)/dragBar.height;
			//	диспатч события того что произошёл скроллинг листа
			super.dispatchEvent(new Event(SCROLLING));
		}
		//	метод получения данных о текущем положении листа
		public function getListPosition():Number{
			return currentListY;
		}
	}
	
}
