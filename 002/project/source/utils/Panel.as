package source.utils {
	import flash.display.Sprite;
	import source.utils.Figure;
	import source.MainPlayer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.geom.Point;
	import flash.events.Event;
	import source.utils.EnvScrollBar.ScrollBar;
	
	public class Panel extends Sprite{
		public static var PANEL_IS_DRAG:String = 'onPanelIsDrag';
		public static var PANEL_DRAG_COMPLATE:String = 'onPanelDragComplate';
		public static var PANEL_IS_CHANGE:String = 'onPanelIsChange';
		//	Параметры шрифта подписи панели
		private static const defFont:String = 'Arial';
		private static const defColor:uint = 0x3A3A3A;
		private static const defBold:Boolean = true;
		private static const defSize:int = 12;
		//	Цвета различных частей панели
		private static const defColorDragPanel:uint = 0x9A9A9A;
		private static const defColorFuncBG:uint = 0xF0F0F0;
		private static const selectColorFuncBG:uint = 0x0000FE;
		//	Размер панели по умолчанию
		private var defaultHeight:int = 400;
		private var defaultWidth:int = 250;
		//	Определяем переменные запоминающие размер панели до внесения в блок
		private var oldWPanel:Number;
		private var oldHPanel:Number
		//	Размер бортика панели (для масштабирования)
		public static var deltaXY:int = 3;
		//	Высота полосы перетаскивания панели
		public static var dragPanelHeight:int = 18;
		
		//	Контейнеры
		//	Панель для перетаскивания
		private var dragPanel:Sprite = new Sprite();
		//	панель фона (на которой всё располагается)
		private var backgroundPanel:Sprite = new Sprite();
		//	контернер для главного контенера и для скроллинга
		public var functionalPanel:Sprite = new Sprite();
		//	маска основного контенера
		public var maskPanel:Sprite = new Sprite();
		//	маска надписи
		private var maskLabel:Sprite = new Sprite();
		//	Основной контейнер с содержимым панели
		public var mainContainer:Sprite = new Sprite();
		
		//	Вертикальный скроллинг
		private var scrolling:ScrollBar = new ScrollBar();
		
		//	Курсор для масштабирования панели
		private var sizeCursor:SizeCursor = new SizeCursor();
		//	Название панели
		private var labelPanel:String;
		
		//	Объект, содержащий позицию курсора в момент перемещения панели
		public var cursor:Object;
		
		//	Переменная, определяющая выделена ли панель
		private var isSelect:Boolean = false;
		//	Переменная, определяющая находится ли панель в блоке
		public var isInBlock:Boolean = false;
		public function Panel(namePanel:String) {
			super();
			//	Подготовка курсора масштабирования (снимаем чувствительность к взаимодействию с мышью)
			sizeCursor.mouseEnabled = false;
			sizeCursor.tabEnabled = false;
			//	Метод инициализации контенеров
			addContainers();
			//	Меотод отрисовки контенеров панели
			drawPanel();
			//	Метод инициализации надписи панели
			initLabel(namePanel);
			//	Метод инициализации слушателей панели
			initHandler();
		}
		/*
			Метод расстановки контенеров панели
		*/
		private function addContainers():void{
			super.addChild(backgroundPanel);
			super.addChild(functionalPanel);
			super.addChild(dragPanel);
			dragPanel.addChild(maskLabel);
			functionalPanel.addChild(mainContainer);
			functionalPanel.addChild(maskPanel);
			functionalPanel.y = backgroundPanel.y = maskPanel.y = dragPanelHeight;
			functionalPanel.x += deltaXY;
			functionalPanel.y += deltaXY;
			maskPanel.x+=deltaXY+0.5;
			maskPanel.y+=deltaXY+0.5;
			mainContainer.x = mainContainer.y = 1;
			maskPanel.x = maskPanel.y = 1;
		}
		/*
			Метод отрисовки графического содержимого контенеров панели
		*/
		private function drawPanel():void{
			Figure.insertRect(maskLabel, defaultWidth, dragPanelHeight, 1, 1, 0x000000, 1, defColorDragPanel);
			Figure.insertRect(dragPanel, defaultWidth, dragPanelHeight, 1, 1, 0x000000, 1, defColorDragPanel);
			Figure.insertRect(backgroundPanel, defaultWidth, defaultHeight);
			Figure.insertRect(functionalPanel, defaultWidth - deltaXY * 2, defaultHeight - deltaXY * 2, 1, 1, 0x000000, 1, defColorFuncBG);
			Figure.insertRect(maskPanel, defaultWidth - deltaXY * 2 - 2, defaultHeight - deltaXY * 2 - 2);
			
			mainContainer.mask = maskPanel;
		}
		/*
			Метод инициализации надписи панели и её маски
		*/
		private function initLabel(inLabel:String):void{
			labelPanel = inLabel;
			var field:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.font = defFont;
			format.bold = defBold
			format.size = defSize;
			field.textColor = defColor;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.defaultTextFormat = format;
			field.text = inLabel;
			field.mouseEnabled = false;
			dragPanel.addChild(field);
			field.mask = maskLabel;
		}
		/*
			Методы инициализации слушателей панели
		*/
		private function initHandler():void{
			//	Перемешение всей панели
			dragPanel.addEventListener(MouseEvent.MOUSE_DOWN, PANEL_MOUSE_DOWN);
			//	Наведение и сведение курсора мыши на часть фоновой панели для 
			//	последующего масштабирования
			this.activeHandler(true);
			//	Слушатель главного контенера на добавление в него содержимого
			mainContainer.addEventListener(Event.ADDED, MAIN_CONTAINER_CHANGE);
		}
		public function activeHandler(value:Boolean):void{
			if(value){
				backgroundPanel.addEventListener(MouseEvent.ROLL_OUT, BG_ROLL_OUT);
				backgroundPanel.addEventListener(MouseEvent.ROLL_OVER, BG_ROLL_OVER);
			}else{
				backgroundPanel.removeEventListener(MouseEvent.ROLL_OUT, BG_ROLL_OUT);
				backgroundPanel.removeEventListener(MouseEvent.ROLL_OVER, BG_ROLL_OVER);
			}
		}
		/*
			Группа методов отвечающая за перемещение панели по сцене конструктора
		*/
		public function PANEL_MOUSE_DOWN(e:MouseEvent = null):void{
			super.startDrag();
			super.parent.setChildIndex(super, super.parent.numChildren - 1);
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, PANEL_MOUSE_UP);
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, PANEL_MOUSE_MOVE);
		}
		private function PANEL_MOUSE_MOVE(e:MouseEvent):void{
			cursor = new Object();
			cursor.stageX = e.stageX;
			cursor.stageY = e.stageY;
			super.dispatchEvent(new Event(PANEL_IS_DRAG));
		}
		private function PANEL_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
			super.dispatchEvent(new Event(PANEL_IS_CHANGE));
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, PANEL_MOUSE_UP);
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, PANEL_MOUSE_MOVE);
			if(!this.isInBlock){
				if(super.y < 6) super.y = 6;
				if(super.x < 6 ) super.x = 6;
			}
			super.dispatchEvent(new Event(PANEL_DRAG_COMPLATE));
		}
		/*
			Метод наведения курсора на фоновый контенер панели
		*/
		private function BG_ROLL_OVER(e:MouseEvent):void{
			//	Если курсор в середине панели, то обработка не производится
			if(e.localX>deltaXY && e.localX<backgroundPanel.width-deltaXY && e.localY<=deltaXY) return;
			//	Если курсор на краю панели, на расстоянии deltaXY от края, то 
			//	скрываем курсор
			Mouse.hide();
			//	Добавляем собственный курсор на сцену
			super.parent.addChild(sizeCursor);
			//	запускаем метод движения мыши по краю панели (для перемещения нашего курсора )
			//	Чтобы до начала движения перерисовать вид курсора
			BG_MOUSE_MOVE(e);
			//	Добавляем слушатель перемещения курсора мыши по краю панели и нажатие мыши на край панели
			backgroundPanel.addEventListener(MouseEvent.MOUSE_MOVE, BG_MOUSE_MOVE);
			backgroundPanel.addEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
		}
		/*
			Метод отслеживающий движение курсора по краю фонового контенера панели
		*/
		private function BG_MOUSE_MOVE(e:MouseEvent):void{
			//	Перемещаем наш курсор в координаты мыши на сцене
			sizeCursor.x = e.stageX;
			sizeCursor.y = e.stageY;
			//	Проверяем не попал ли курсор дальше чем на расстояние бордира панели
			if(e.localX>deltaXY && e.localX<backgroundPanel.width-deltaXY && e.localY<=deltaXY){
				//	Если попал, то капускаем метод сведения курсора мыши с панели
				BG_ROLL_OUT(null);
				return;
			}
			//	Далее идёт проверка с какого именно края находится курсор мыши и 
			//	переводится в соответствующий кадр (положение)
			if(e.localX<=deltaXY && e.localY>=backgroundPanel.height - deltaXY){
				sizeCursor.gotoAndStop(2);
				return;
			}
			if(e.localX>deltaXY && e.localX<backgroundPanel.width-deltaXY && e.localY>=backgroundPanel.height - deltaXY){
				sizeCursor.gotoAndStop(3);
				return;
			}
			if(e.localX>=backgroundPanel.width-deltaXY && e.localY>=backgroundPanel.height - deltaXY){
				sizeCursor.gotoAndStop(4);
				return;
			}
			if(e.localX<=deltaXY && e.localY<backgroundPanel.height - deltaXY){
				sizeCursor.gotoAndStop(5);
				return;
			}
			sizeCursor.gotoAndStop(1);
			//	Обновляется сцена 
			e.updateAfterEvent();
		}
		/*
			Метод отслеживающий нажатие мыши во время движения мыши по краю панели для масштабирования
		*/
		private function BG_MOUSE_DOWN(e:MouseEvent):void{
			//	Старт движения курсора масштабирования
			sizeCursor.startDrag(true);
			//	Панель помещаем в верх списка отображения
			super.parent.setChildIndex(super, super.parent.numChildren - 1);
			//	Помещяем курсор выше панелей
			sizeCursor.parent.setChildIndex(sizeCursor, sizeCursor.parent.numChildren - 1);
			//	Удаляем слушателя края панели до начала масштабирования
			backgroundPanel.removeEventListener(MouseEvent.MOUSE_MOVE, BG_MOUSE_MOVE);
			backgroundPanel.removeEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
			backgroundPanel.removeEventListener(MouseEvent.ROLL_OUT, BG_ROLL_OUT);
			backgroundPanel.removeEventListener(MouseEvent.ROLL_OVER, BG_ROLL_OVER);
			//	Добавляем слушатель глобального отпускания мыши
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, STAGE_MOUSE_UP);
			//	Определяем слушателя перемещения мыши по сцене в зависимости от позиции курсора
			switch (sizeCursor.currentFrame){
				case 2:
					MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BOT_LEFT_SIZE);	
				break;
				case 1:
					MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, RIGHT_SIZE);
				break;
				case 4:
					MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BOT_RIGHT_SIZE);
				break;
				case 3:
					MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BOT_SIZE);
				break;
				case 5:
					MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, LEFT_SIZE);	
				break;
			}
		}
		//	ГРУППА МЕТОДОВ МАСШТАБИРОВАНИЯ ПАНЕЛИ ПО РАЗЛИЧНЫМ НАПРАВЛЕНИЯМ
		private function BOT_RIGHT_SIZE(e:MouseEvent):void{
			chengSizeRight(e.stageX);
			chengSizeBottom(e.stageY);
			reloadPanel();
		}
		private function RIGHT_SIZE(e:MouseEvent):void{
			chengSizeRight(e.stageX);
			reloadPanel();
		}
		private function BOT_SIZE(e:MouseEvent):void{
			chengSizeBottom(e.stageY);
			reloadPanel();
		}
		private function LEFT_SIZE(e:MouseEvent):void{
			chengSizeLeft(e.stageX);
			reloadPanel();
		}
		private function BOT_LEFT_SIZE(e:MouseEvent):void{
			chengSizeLeft(e.stageX);
			chengSizeBottom(e.stageY);
			reloadPanel();
		}
		//	Метод ресайза панели вправо
		private function chengSizeRight(inX:Number):void{
			if(super.x + 50<inX){
				defaultWidth = inX - super.x;
			}
		}
		//	Метод ресайза панели вниз
		private function chengSizeBottom(inY:Number):void{
			if(super.y + 50+dragPanelHeight<inY){
				defaultHeight = inY - super.y - dragPanelHeight;
			}
		}
		//	Метод ресайза панели влево
		private function chengSizeLeft(inX:Number):void{
			var endX:Number = super.x + defaultWidth;
			if(endX - inX>=50){
				super.x = inX;
				defaultWidth = endX - super.x;
			}else{
				if(inX<super.x){
					super.x = inX;
					defaultWidth = endX - super.x;	
				}
			}
		}
		/*
			Метод отслеживающий отпускание мыши во время для окончания масштабирования панели
		*/
		private function STAGE_MOUSE_UP(e:MouseEvent):void{
			//	Останавливаем движение курсора
			sizeCursor.stopDrag();
			//	Удаляем все слушатели сцены для окончания масштабирования панели
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, STAGE_MOUSE_UP);
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BOT_RIGHT_SIZE);
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, RIGHT_SIZE);
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BOT_SIZE);
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LEFT_SIZE);
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BOT_LEFT_SIZE);
			//	Зпускаем метод сведения мыши с панели
			BG_ROLL_OUT(null);
			//	Возвращаем слушателей наведения и сведения курсора мыши на край панели
			activeHandler(true);
			//	Панель возвращает событие окончания изменения масштабирования
			super.dispatchEvent(new Event(PANEL_IS_CHANGE));
		}
		/*
			Метод отслеживающий сведение курсора мыши с края панели
		*/
		private function BG_ROLL_OUT(e:MouseEvent):void{
			//	Если курсор находится в контенере, то удаляем его
			if(super.parent.contains(sizeCursor)){
				super.parent.removeChild(sizeCursor);
			}
			//	Показываем стандартный курсор мыши (стрелка)
			Mouse.show();
			//	Удаляем слушателей Движения мыши по краю панели и нажатие мыши на край панели
			backgroundPanel.removeEventListener(MouseEvent.MOUSE_MOVE, BG_MOUSE_MOVE);
			backgroundPanel.removeEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
		}
		
		/*
			Методы изменения прозрачности панели 
		*/
		override public function set visible(value:Boolean):void{
			super.visible = value;
			//	Возвращает событие изменения прозрачности панели
			super.dispatchEvent(new Event(PANEL_IS_CHANGE));
		}
		override public function get visible():Boolean{
			if(isInBlock){
				return functionalPanel.visible;
			}
			return super.visible;
		}
		/*
			Методы обновления скроллинга панели
		*/
		public function updatePanel():void{
			//	Если размер контенера больше размера видимой части, то
			if(mainContainer.height > maskPanel.height){
				//	добавляем скроллинг в панель
				//functionalPanel.addChild(scrolling);
				//	Устанавливаем размер скроллинга
				scrolling.setSettings(mainContainer.height, maskPanel.height, mainContainer.y);
				//	Устанавливаем позицию скроллинга
				scrolling.x = maskPanel.width - scrolling.width+2;
				//	Устанавливаем слушателя скроллинга
				scrolling.addEventListener(ScrollBar.SCROLLING, CHENGE_LIST_POSITION);
			}else{
				//	Если контента меньше размера видимой части, то 
				
				//	Если скроллинг установлен на панель
				if(functionalPanel.contains(scrolling)){
					//	удаляем скроллинг 
					functionalPanel.removeChild(scrolling);
					//	удаляем слушатель скроллирования
					scrolling.removeEventListener(ScrollBar.SCROLLING, CHENGE_LIST_POSITION);
				}
				//	восстанавливаем главный контенер в нулевую позицию
				mainContainer.y = 0;
			}
			super.dispatchEvent(new Event(PANEL_IS_CHANGE));
		}
		//	Метод слушателя скроллирования в панели
		private function CHENGE_LIST_POSITION(e:Event):void{
			mainContainer.y = scrolling.getListPosition();
		}
		//	Мeтод удаления возможности перемешать панель, вместе с полосой перетаскивания
		public function removeDragble():void{
			dragPanel.removeEventListener(MouseEvent.MOUSE_DOWN, PANEL_MOUSE_DOWN);
			dragPanel.removeEventListener(MouseEvent.MOUSE_UP, PANEL_MOUSE_UP);
			super.removeChild(dragPanel);
		}
		public function addDragble():void{
			dragPanel.addEventListener(MouseEvent.MOUSE_DOWN, PANEL_MOUSE_DOWN);
			dragPanel.addEventListener(MouseEvent.MOUSE_UP, PANEL_MOUSE_UP);
			super.addChild(dragPanel);
		}
		//	Метод слушателя изменения содержимого главного контенера
		private function MAIN_CONTAINER_CHANGE(e:Event):void{
			reloadPanel();
		}
		//	Метод рестарта панели
		public function reloadPanel():void{
			//	перерисовка панели в соответствии с новыми параметрами
			drawPanel();
			//	Метод обновления скроллинга панели
			updatePanel();
		}
		//	Метод устанавливающий размер панели		
		public function setSizePanel(W:Number, H:Number):void{
			defaultWidth = W;
			defaultHeight = H;
			drawPanel();
		}
		/*
			Методы возвращяющий размер панели в объекте
		*/
		public function getSizeSettings():Object{
			var outObject:Object = new Object();
			outObject.width = defaultWidth;
			outObject.height = defaultHeight;
			return outObject;
		}
		//	Метод возврашения ширины панели
		public function get WIDTH():Number{
			return defaultWidth;
		}
		//	Метод возврашения высоты панели
		public function get HEIGHT():Number{
			return defaultHeight;
		}
		//	Метод возврашения названия панели
		public function get label():String{
			return labelPanel;
		}
		
		
		//	Метод выделения панели при наведении или сведении
		public function set select(value:Boolean):void{
			isSelect = value;
			if(value){
				Figure.insertRect(backgroundPanel, defaultWidth, defaultHeight, 1, 1, 0x000000, 1, selectColorFuncBG);
			}else{
				Figure.insertRect(backgroundPanel, defaultWidth, defaultHeight);
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		
		//	метод получения главного контенера
		public function get container():Sprite{
			dragPanel.visible = false;
			backgroundPanel.visible = false;
			isInBlock = true;
			oldWPanel = this.WIDTH;
			oldHPanel = this.HEIGHT;
			return functionalPanel;
		}
		//	метод возвращения нормльного состояния панели
		public function returnContainer():void{
			dragPanel.visible = true;
			backgroundPanel.visible = true;
			functionalPanel.visible = true;
			isInBlock = false;
			this.visible = true;
			this.setSizePanel(oldWPanel, oldHPanel);
			super.addChild(functionalPanel);
			functionalPanel.y = dragPanelHeight;
			functionalPanel.x = deltaXY;
			functionalPanel.y += deltaXY;
			this.reloadPanel();
		}
		public function get oldSize():Object{
			var outObject:Object = new Object();
			outObject.width = oldWPanel;
			outObject.height = oldHPanel;
			return outObject;
		}
	}
}
