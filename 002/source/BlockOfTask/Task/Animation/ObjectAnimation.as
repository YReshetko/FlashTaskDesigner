package source.BlockOfTask.Task.Animation {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import source.MainPlayer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import source.utils.Color;
	
	public class ObjectAnimation extends EventDispatcher implements IObjectAnimation{
		public static var END_ANIMATION:String = 'onEndAnimation';
		public static var END_RECORD:String = 'onEndRecord';
		//	Контенер отображения линии и ключевых точек анимации
		private var lineContainer:Sprite = new Sprite();
		//	Контенер, в котором находится объект
		private var container:Sprite;
		//	Запоминаем объект анимации
		private var object:Sprite;
		//	Число шагов анимации
		private var numStep:Number = 1;
		//	Массив точек с траекторией движения
		private var arrAnimPoint:Array = new Array();
		//	Указатель на текущую точку
		private var indexPoint:int;
		//	Переменная идёт ли запись
		private var isRecordStart:Boolean = false;
		//	Таймер записи
		private var timerRecord:Timer;
		//	Стартовая позиция объекта до записи
		private var startX:Number;
		private var startY:Number;
		//	Массив ключевых точек анимации
		private var arrKeyPoint:Array = new Array();
		//	Точка текущего редактирования
		private var keyPoint:KeyPointAnimation;
		//	Номер текущей точки в массиве
		private var keyIndex:int;
		//	Время в секундах, через сколько начнётся анимация
		private var startIn:Number = 0;
		//	Логическая переменная, означающая зацикливание анимации
		private var isCicling:Boolean = false;
		//	Применять ли настройки первой точки до начала анимации объекта
		private var isFirstPointSettings:Boolean = false;
		//	Удалять ли объект по окончанию анимации
		private var isRemoveObject:Boolean = false;
		//	Метка анимации
		private var labelAnimation:String = '';
		//	Запоминаем класс аниммируемого объекта
		private var classObject:*;
		//	Множественный запуск анимации объекта
		private var multipleStart:Boolean = false;
		//	Число обращений к анимации
		private var numberAddres:int = 0;
		//	Статическая анимация
		private var staticAnimation:Boolean = true;
		public function ObjectAnimation(container:Sprite, object:Sprite, classObject:* = null) {
			super();
			this.container = container;
			this.object = object;
			this.classObject = classObject;
		}
		public function set objectClass(value:*):void{
			classObject = value;
		}
		//	Установка шага запоминания ключевых точек
		public function set step(value:Number):void{
			numStep = value;
		}
		public function get step():Number{
			return numStep;
		}
		//	Установка времени старта анимации
		public function get startFrom():Number{
			return startIn
		}
		public function set startFrom(value:Number):void{
			startIn = value;
		}
		//	Установка зацикливания анимации
		public function get cicling():Boolean{
			return isCicling;
		}
		public function set cicling(value:Boolean):void{
			isCicling = value;
		}
		//	Установка метки анимации
		public function get label():String{
			return labelAnimation;
		}
		public function set label(value:String):void{
			labelAnimation = value;
		}
		//	Установка параметра множественного запуска анимации объекта
		public function get multiple():Boolean{
			return this.multipleStart;
		}
		public function set multiple(value:Boolean):void{
			this.multipleStart = value;
		}
		//	Установка числа обращений к анимации
		public function set address(value:int):void{
			numberAddres = value;
		}
		public function get address():int{
			return numberAddres;
		}
		//	Установка анимации со второй точки
		public function set animationStatic(value:Boolean):void{
			staticAnimation = value;
		}
		public function get animationStatic():Boolean{
			return staticAnimation;
		}
		//	Запуск и остановка записи
		public function startRecord():void{
			startX = object.x;
			startY = object.y;
			//	Определяем статус текущей записи
			var ID:int = arrKeyPoint.length;
			//	Если анимации ещё нет, то записываем первую точку
			if(!this.hasAnimation){
				arrKeyPoint.push(new KeyPointAnimation(0, 0));
				(arrKeyPoint[ID] as KeyPointAnimation).rotation = object.rotation;
				(arrKeyPoint[ID] as KeyPointAnimation).scale = object.scaleX;
				(arrKeyPoint[ID] as KeyPointAnimation).alpha = object.alpha;
				lineContainer.addChild(arrKeyPoint[ID]);
				arrKeyPoint[ID].x = startX;
				arrKeyPoint[ID].y = startY;
				initPointHandler(arrKeyPoint[ID] as KeyPointAnimation);
			//	Иначе переводим объект в конечную точку анимации
			}else{
				object.x = arrKeyPoint[ID-1].x;
				object.y = arrKeyPoint[ID-1].y;
			}
			//	Удаляем прослушивателя изменения позиции всей анимации
			if(object.hasEventListener(MouseEvent.MOUSE_DOWN)) object.removeEventListener(MouseEvent.MOUSE_DOWN, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_DOWN);
			//	Добавляем слушателя для создания анимации по движению пользователя
			object.addEventListener(MouseEvent.MOUSE_DOWN, OBJECT_MOUSE_DOWN_START_ANIMATION);
			//	Выставляем статус процесса анимации
			isRecordStart = true;
		}
		//	Остановка записи анимации
		public function stopRecord():void{
			//	Выставляем статус отсутствия процесса анимации
			isRecordStart = false;
			//	Удаляем слушателя нажатяи на объект для записи анимации
			if(object.hasEventListener(MouseEvent.MOUSE_DOWN)) object.removeEventListener(MouseEvent.MOUSE_DOWN, OBJECT_MOUSE_DOWN_START_ANIMATION);
			//	Обнуляем таймер для вычисления ключевых точек анимации
			if(timerRecord != null){
				timerRecord.stop();
				if(timerRecord.hasEventListener(TimerEvent.TIMER)) timerRecord.removeEventListener(TimerEvent.TIMER, TIMER_RECORD);
				timerRecord = null;
			}
			//	Если длина массива ключевых точек = 1, то удаляем её
			if(arrKeyPoint.length == 1)removeAnimation();
			//	Удаляем слушателя остановки анимации
			if(MainPlayer.STAGE.hasEventListener(MouseEvent.MOUSE_UP)) MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, OBJECT_MOUSE_DOWN_STOP_ANIMATION);
			//	Если анимация есть, то добавляем слушателя изменения позиции всей анимации
			if(hasAnimation){
				object.addEventListener(MouseEvent.MOUSE_DOWN, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_DOWN);
			}
			super.dispatchEvent(new Event(END_RECORD));
		}
		//	Переменная отвечающая за то, идёт ли запись
		public function get isRecord():Boolean{
			return isRecordStart;
		}
		//	Отображение и скрытие линии движения объекта
		public function set line(value:Boolean):void{
			if(value){
				container.addChild(lineContainer);
			}else{
				if(line) container.removeChild(lineContainer);
			}
		}
		public function get line():Boolean{
			return container.contains(lineContainer);
		}
		//	Воспроизведение и остановка анимации
		public function play():void{
			//	Чистим массив, просчитанный для плавной анимации
			clearPointAnimation();
			if(this.staticAnimation){
				arrKeyPoint[0].rotation = object.rotation;
			}
			var ID:int = 0;
			var deltaX:Number;
			var deltaY:Number;
			var deltaR:Number;
			var deltaS:Number;
			var deltaA:Number;
			var deltaRed:Number;
			var deltaGreen:Number;
			var deltaBlue:Number;
			//	Число частей на которое делится отрезок анимации
			var sempleTime:int = Math.floor(24*step);
			var i:int;
			var j:int;
			var l:int;
			l = arrKeyPoint.length;
			//	вычисляем начальные значения цвета
			var r:Number;
			var g:Number;
			var b:Number;
			r = g = b = deltaRed = deltaGreen = deltaBlue = 0;
			if(this.classObject!=null){
				var colorObject:Object =  Color.getRGB((arrKeyPoint[0] as KeyPointAnimation).color);
				if(colorObject.error == ''){
					r = colorObject.red;
					g = colorObject.green;
					b = colorObject.blue;
				}
			}
			//	Добавляем в массив первую точку анимации (там где стоит объект)
			arrAnimPoint.push({'x':arrKeyPoint[0].x,
							   'y':arrKeyPoint[0].y,
							   'rotation':(arrKeyPoint[0] as KeyPointAnimation).rotation,
							   'scale':(arrKeyPoint[0] as KeyPointAnimation).scale,
							   'alpha':(arrKeyPoint[0] as KeyPointAnimation).alpha,
							   'block':(arrKeyPoint[0] as KeyPointAnimation).block,
							   'red': r, 'green': g, 'blue': b});
			//	Просчитываем позиции для каждого отрезка
			for(i=1;i<l;i++){
				//	Просчёт смещений по осям для текущего отрезка
				deltaX = (arrKeyPoint[i].x - arrKeyPoint[i-1].x)/sempleTime;
				deltaY = (arrKeyPoint[i].y - arrKeyPoint[i-1].y)/sempleTime;
				deltaR = (arrKeyPoint[i].rotation - arrKeyPoint[i-1].rotation)/sempleTime;
				deltaS = (arrKeyPoint[i].scale - arrKeyPoint[i-1].scale)/sempleTime;
				deltaA = (arrKeyPoint[i].alpha - arrKeyPoint[i-1].alpha)/sempleTime;
				//	Вычисляем смещение каждого спектра цвета
				if(this.classObject!=null){
					var newColor:Object = Color.getRGB((arrKeyPoint[i] as KeyPointAnimation).color);
					var oldColor:Object = Color.getRGB((arrKeyPoint[i-1] as KeyPointAnimation).color);
					deltaRed = (newColor.red - oldColor.red)/sempleTime;
					deltaGreen = (newColor.green - oldColor.green)/sempleTime;
					deltaBlue = (newColor.blue - oldColor.blue)/sempleTime;
					//trace(this + ': deltaRed = ' + deltaRed + '; deltaGreen = ' + deltaGreen + '; deltaBlue = ' + deltaBlue);
					
				}
				//	Запись в массив всех анимационных точек
				for(j=0;j<sempleTime;j++){
					ID = arrAnimPoint.length;
					arrAnimPoint.push({'x':arrAnimPoint[ID-1].x + deltaX, 
									   'y':arrAnimPoint[ID-1].y + deltaY,
							  		   'rotation':arrAnimPoint[ID-1].rotation + deltaR,
							           'scale':arrAnimPoint[ID-1].scale + deltaS,
							           'alpha':arrAnimPoint[ID-1].alpha + deltaA,
									   'red': arrAnimPoint[ID-1].red + deltaRed,
									   'green': arrAnimPoint[ID-1].green + deltaGreen,
									   'blue': arrAnimPoint[ID-1].blue + deltaBlue});
					if(j==0) {
						arrAnimPoint[ID-1].timeOut = (arrKeyPoint[i-1] as KeyPointAnimation).timeOut;
						arrAnimPoint[ID-1].block = (arrKeyPoint[i-1] as KeyPointAnimation).block.toString();
					}
					else {
						arrAnimPoint[ID-1].timeOut = 0;
						arrAnimPoint[ID-1].block = 'undefined';
					}
				}
			}
			arrAnimPoint[ID].timeOut = 0;
			//	Удаляем первую точку для более плавного перехода при зацикливании анимации
			arrAnimPoint.shift();
			//	Выставляем текущий индекс в массиве точек анимации
			indexPoint = -1;
			//	Запускаем цикл анимации
			object.addEventListener(Event.ENTER_FRAME, OBJECT_ENTER_FRAME);
		}
		//	Метод очищения массива точек промежуточной анимации
		private function clearPointAnimation():void{
			while(arrAnimPoint.length>0){
				arrAnimPoint.shift();
			}
		}
		//	Метод анимации смещения объектов
		private function OBJECT_ENTER_FRAME(event:Event):void{
			//	Повышаем указатель текущей точки смещения
			++indexPoint;
			var timeOutTimer:Timer;
			//	Если достигли окончания массива точек промежуточной анимации
			//	то останавливаем её
			if(indexPoint==arrAnimPoint.length){
				if(this.cicling){
					indexPoint = 0;
					object.x = arrAnimPoint[indexPoint].x;
					object.y = arrAnimPoint[indexPoint].y;
					object.rotation = arrAnimPoint[indexPoint].rotation;
					object.scaleX = arrAnimPoint[indexPoint].scale;
					object.scaleY = arrAnimPoint[indexPoint].scale;
					object.alpha = arrAnimPoint[indexPoint].alpha;
					if(arrAnimPoint[indexPoint].block!='undefined') {
						if(arrAnimPoint[indexPoint].block == 'true') object.mouseEnabled = false;
						else object.mouseEnabled = true;
					}
					//	Выставляем новый цвет
					if(this.classObject!=null){
						this.classObject.animationColor = Color.getColor(arrAnimPoint[indexPoint]);
					}
					if(arrAnimPoint[indexPoint].timeOut!=0){
						object.removeEventListener(Event.ENTER_FRAME, OBJECT_ENTER_FRAME);
						timeOutTimer = new Timer(1000*arrAnimPoint[indexPoint].timeOut, 1);
						timeOutTimer.addEventListener(TimerEvent.TIMER, TIME_OUT_TIMER);
						timeOutTimer.start();
					}
				}else{
					stop();
				}
			}else{
			//	Иначе смещаем объект в новую точку
				object.x = arrAnimPoint[indexPoint].x;
				object.y = arrAnimPoint[indexPoint].y;
				object.rotation = arrAnimPoint[indexPoint].rotation;
				object.scaleX = arrAnimPoint[indexPoint].scale;
				object.scaleY = arrAnimPoint[indexPoint].scale;
				object.alpha = arrAnimPoint[indexPoint].alpha;
				if(arrAnimPoint[indexPoint].block!='undefined') {
					if(arrAnimPoint[indexPoint].block == 'true') object.mouseEnabled = false;
					else object.mouseEnabled = true;
				}
				//	Выставляем овый цвет
				if(this.classObject!=null){
					this.classObject.animationColor = Color.getColor(arrAnimPoint[indexPoint]);
				}
				if(arrAnimPoint[indexPoint].timeOut!=0){
					object.removeEventListener(Event.ENTER_FRAME, OBJECT_ENTER_FRAME);
					timeOutTimer = new Timer(1000*arrAnimPoint[indexPoint].timeOut, 1);
					timeOutTimer.addEventListener(TimerEvent.TIMER, TIME_OUT_TIMER);
					timeOutTimer.start();
				}
			}
		}
		private function TIME_OUT_TIMER(event:TimerEvent):void{
			object.addEventListener(Event.ENTER_FRAME, OBJECT_ENTER_FRAME);
		}
		//	Остановка анимации
		public function stop():void{
			//	Если есть, то удаляем слушателя анимации
			if(object.hasEventListener(Event.ENTER_FRAME)) object.removeEventListener(Event.ENTER_FRAME, OBJECT_ENTER_FRAME);
			/*//	Смещение объекта в начальную позицию
			object.x = arrKeyPoint[0].x;
			object.y = arrKeyPoint[0].y;
			object.rotation = arrKeyPoint[0].rotation;
			object.scaleX = arrKeyPoint[0].scale;
			object.scaleY = arrKeyPoint[0].scale;
			object.alpha = arrKeyPoint[0].alpha;*/
			//	Очищаем массив промежуточных точек анимации
			clearPointAnimation();
			if(this.multiple){
				if(this.staticAnimation){
					arrKeyPoint[0].x = object.x;
					arrKeyPoint[0].y = object.y;
				}else{
					this.replaceKeyPoints();
				}
			}else{
				if(this.isRemoveObject){
					this.object.alpha = 0;
					this.object.visible = false;
				}
			}
			super.dispatchEvent(new Event(END_ANIMATION));
		}
		//	Удаление анимации
		public function removeAnimation():void{
			//	Чистим массив ключевых точек
			while(arrKeyPoint.length){
				//	Удаление точки со сцены
				lineContainer.removeChild(arrKeyPoint[0]);
				//	Очистка слушателей точки
				removePointHandler(arrKeyPoint[0] as KeyPointAnimation);
				//	Удаление нулевой точки
				arrKeyPoint.shift();
			}
			//	Чистим контенер отрисовки линии анимации
			lineContainer.graphics.clear();
			//	Удаляем слушателя смещения всей анимации
			if(object.hasEventListener(MouseEvent.MOUSE_DOWN)) object.removeEventListener(MouseEvent.MOUSE_DOWN, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_DOWN);
		}
		//	Метод проверки наличия анимации объекта
		public function get hasAnimation():Boolean{
			if(arrKeyPoint.length == 0) return false;
			return true;
		}
		//	Метод получения времени анимации
		public function get totalTime():Number{
			return 0;
		}
		
		
		
		/*
			МЕТОДЫ ОБРАБОТКИ ФАКТИЧЕСКОГО НАЧАЛА И ОКОНЧАНИЯ ЗАПИСИ АНИМАЦИИ
		*/
		//	Метод начала записи после нажатия на объекте
		private function OBJECT_MOUSE_DOWN_START_ANIMATION(event:MouseEvent):void{
			//	Удаляем слушателя старта анимации
			object.removeEventListener(MouseEvent.MOUSE_DOWN, OBJECT_MOUSE_DOWN_START_ANIMATION);
			//	Добавляем слушателя отпускания мыши для завершения записи
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, OBJECT_MOUSE_DOWN_STOP_ANIMATION);
			//	Установка таймера с просчётом времени записи
			timerRecord = new Timer(1000*step);
			//	Добавляем слушателя таймера
			timerRecord.addEventListener(TimerEvent.TIMER, TIMER_RECORD);
			//	Стартуем таймер
			timerRecord.start();
		}
		//	Таймер отсчитывающий запись ключевых точек анимации
		private function TIMER_RECORD(event:TimerEvent = null):void{
			//	Просчёт нового ID ключевой точки
			var ID:int = arrKeyPoint.length;
			//	Добавление новой ключевой точки в массив
			arrKeyPoint.push(new KeyPointAnimation(object.x - startX, object.y - startY));
			(arrKeyPoint[ID] as KeyPointAnimation).rotation = object.rotation;
			(arrKeyPoint[ID] as KeyPointAnimation).scale = object.scaleX;
			(arrKeyPoint[ID] as KeyPointAnimation).alpha = object.alpha;
			//	Добавление новой точки в контейнер отображения
			lineContainer.addChild(arrKeyPoint[ID]);
			//	Установка точки в нужные координаты
			arrKeyPoint[ID].x = object.x;
			arrKeyPoint[ID].y = object.y;
			//	Инициализация слушателей на точке
			initPointHandler(arrKeyPoint[ID] as KeyPointAnimation);
			//	Отрисовка линии анимации
			drawLine();
		}
		//	Метод окончания записи после отпускания объекта
		private function OBJECT_MOUSE_DOWN_STOP_ANIMATION(event:MouseEvent):void{
			//	Запись последней точки
			TIMER_RECORD();
			//	Установка объекта в стартовые координаты
			object.x = startX;
			object.y = startY;
			//	Остановка записи анимации
			stopRecord();
		}
		/*	
			ПЕРЕРИСОВКА ЛИНИИ АНИМАЦИИ
		*/
		private function drawLine():void{
			if(!this.hasAnimation) return;
			lineContainer.graphics.clear();
			lineContainer.graphics.lineStyle(0.1, 0x00BB00, 1, false, LineScaleMode.NONE);
			lineContainer.graphics.moveTo(arrKeyPoint[0].x, arrKeyPoint[0].y);
			var i:int;
			var l:int;
			l = arrKeyPoint.length;
			for(i=1;i<l;i++){
				lineContainer.graphics.lineTo(arrKeyPoint[i].x, arrKeyPoint[i].y);
			}
			
		}
		/*
			ИНИЦИАЛИЗАЦИЯ СЛУШАТЕЛЕЙ КЛЮЧЕВОЙ ТОЧКИ
		*/
		//	Метод инициализации слушателей точки
		private function initPointHandler(point:KeyPointAnimation):void{
			//	Движение точки
			point.addEventListener(KeyPointAnimation.POINT_MOVE, KEY_POINT_MOVE);
			//	Копирование точки
			point.addEventListener(KeyPointAnimation.POINT_COPY, KEY_POINT_COPY);
			//	Удаление точки
			point.addEventListener(KeyPointAnimation.POINT_REMOVE, KEY_POINT_REMOVE);
			//	Установка фокуса в точку
			point.addEventListener(KeyPointAnimation.FOCUS_IN, KEY_POINT_FOCUS_IN);
			//	Снятие фокуса с точки
			point.addEventListener(KeyPointAnimation.FOCUS_OUT, KEY_POINT_FOCUS_OUT);
		}
		//	Метод удаления слушателей точки
		private function removePointHandler(point:KeyPointAnimation):void{
			//	Удаление движения точки
			if(point.hasEventListener(KeyPointAnimation.POINT_MOVE)) 	point.removeEventListener(KeyPointAnimation.POINT_MOVE, KEY_POINT_MOVE);
			//	Удаление копирования точки
			if(point.hasEventListener(KeyPointAnimation.POINT_COPY)) 	point.removeEventListener(KeyPointAnimation.POINT_COPY, KEY_POINT_COPY);
			//	Удаление удаления точки
			if(point.hasEventListener(KeyPointAnimation.POINT_REMOVE)) 	point.removeEventListener(KeyPointAnimation.POINT_REMOVE, KEY_POINT_REMOVE);
			//	Удаление всавки фокуса на точку
			if(point.hasEventListener(KeyPointAnimation.FOCUS_IN)) 		point.removeEventListener(KeyPointAnimation.FOCUS_IN, KEY_POINT_FOCUS_IN);
			//	Удаление снятия фокуса с точки
			if(point.hasEventListener(KeyPointAnimation.FOCUS_OUT)) 	point.removeEventListener(KeyPointAnimation.FOCUS_OUT, KEY_POINT_FOCUS_OUT);
		}
		
		/*
			ГРУППА МЕТОДОВ ОБРАБОТКИ СМЕЩЕНИЯ ВСЕЙ АНИМАЦИИ С ОБЪЕКТОМ
		*/
		//	Нажатие кнопки мыши над таном после создания анимации
		//	Дле смещения всей анимации вместе с объектом
		private function OBJECT_CHANGE_LINE_ANIMATION_MOUSE_DOWN(event:MouseEvent):void{
			MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_UP);
			//if(line){
				//	Если линия анимации видна, то слущаем каждое движение мыши с нажатым объектом
				MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_MOVE);
			//}
		}
		//	Анализ перемещения объекта для перерисовки линии в режиме реального времени
		private function OBJECT_CHANGE_LINE_ANIMATION_MOUSE_MOVE(event:MouseEvent):void{
			//	Перестановка точек
			if(this.animationStatic){
				arrKeyPoint[0].x = object.x;
				arrKeyPoint[0].y = object.y;
			}else{
				replaceKeyPoints();
			}
		}
		//	Отпускание мыши после перерисовки линии
		private function OBJECT_CHANGE_LINE_ANIMATION_MOUSE_UP(event:MouseEvent):void{
			//	Удаление слушателей изменения позиции всей анимации
			//	При отпускании и при движении
			MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_UP);
			if(MainPlayer.STAGE.hasEventListener(MouseEvent.MOUSE_MOVE)) MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, OBJECT_CHANGE_LINE_ANIMATION_MOUSE_MOVE);
			//	На всякий случай ещё раз переставляем точки
			OBJECT_CHANGE_LINE_ANIMATION_MOUSE_MOVE(null);
		}
		//	Метод перестановки точек после смещения объекта
		private function replaceKeyPoints():void{
			var i:int;
			var l:int;
			l = arrKeyPoint.length;
			//	Перестановка всех точек в зависимости от их относительного смещения
			for(i=0;i<l;i++){
				arrKeyPoint[i].x = object.x + (arrKeyPoint[i] as KeyPointAnimation).X;
				arrKeyPoint[i].y = object.y + (arrKeyPoint[i] as KeyPointAnimation).Y;
			}
			//	Перерисовка линии
			drawLine();
		}
		/*
			ГРУППА СЛУШАТЕЛЕЙ СОБЫТИЙ ВЗАИМОДЕЙСТВИЯ С КЛЮЧЕВОЙ ТОЧКОЙ АНИМАЦИИ
		*/
		//	Реакция на перемещение ключевой точки
		private function KEY_POINT_MOVE(event:Event):void{
			//	Если точка нулевая, то обрабатываем смещение всех точек массива
			if(keyIndex==0){
				var i:int;
				var l:int;
				l = arrKeyPoint.length;
				for(i=1;i<l;i++){
					(arrKeyPoint[i] as KeyPointAnimation).X = (arrKeyPoint[i] as KeyPointAnimation).x - (arrKeyPoint[0] as KeyPointAnimation).x;
					(arrKeyPoint[i] as KeyPointAnimation).Y = (arrKeyPoint[i] as KeyPointAnimation).y - (arrKeyPoint[0] as KeyPointAnimation).y;
				}
				//	Если не нулевая, то обрабатываем только текущую точку
			}else{
				keyPoint.X = keyPoint.x - (arrKeyPoint[0] as KeyPointAnimation).x;
				keyPoint.Y = keyPoint.y - (arrKeyPoint[0] as KeyPointAnimation).y;
			}
			//	Устанавливаем объект в текущую точку
			object.x = keyPoint.x;
			object.y = keyPoint.y;
			//	Перерисовка линии анимации
			drawLine();
		}
		//	Выделение текущей точки
		private function KEY_POINT_FOCUS_IN(event:Event):void{
			//	Запоминаем точку, с которой будем работать
			keyPoint = event.target as KeyPointAnimation;
			var i:int;
			var l:int;
			l = arrKeyPoint.length;
			//	Запоминаем индекс текущей точки
			for(i=0;i<l;i++){
				if(arrKeyPoint[i] == keyPoint){
					keyIndex = i;
					break;
				}
			}
			//	Устанавливаем объект в текущую точку
			object.x = keyPoint.x;
			object.y = keyPoint.y;
			object.rotation = keyPoint.rotation;
			object.scaleX = keyPoint.scale;
			object.scaleY = keyPoint.scale;
			object.alpha = keyPoint.alpha;
			//	Сообщаем контроллеру анимации о выделении точки анимации
			//super.dispatchEvent(new Event(ControllerAnimation.GET_SETTINGS));
		}
		//	Снятие фокуса с точки
		private function KEY_POINT_FOCUS_OUT(event:Event):void{
			//	Возвращение точки на начальную позицию
			object.x = arrKeyPoint[0].x;
			object.y = arrKeyPoint[0].y;
			object.rotation = (arrKeyPoint[0] as KeyPointAnimation).rotation;
			object.scaleX = (arrKeyPoint[0] as KeyPointAnimation).scale;
			object.scaleY = (arrKeyPoint[0] as KeyPointAnimation).scale;
			object.alpha = (arrKeyPoint[0] as KeyPointAnimation).alpha;
			//	Обнуление параметров выделения текущей точки
			keyPoint = null;
			keyIndex = -1;
		}
		//	Удаление выделенной точки
		private function KEY_POINT_REMOVE(event:Event):void{
			//	Запоминаем индекс текущей точки
			var index:int = keyIndex;
			//	Удаляем точку из контенера
			lineContainer.removeChild(arrKeyPoint[index]);
			//	Удаляем слушателей точки
			removePointHandler(arrKeyPoint[index] as KeyPointAnimation);
			//	Удаляем точку из массива
			arrKeyPoint.splice(index, 1);
			//	Запускаем снятие фокуса с точки
			KEY_POINT_FOCUS_OUT(null);
			//	Перерисовка линии
			drawLine();
		}
		//	Копирование точки
		private function KEY_POINT_COPY(event:Event):void{
			//	Создаём объект новой точки в отдельной переменной
			var newKeyPoint:KeyPointAnimation = new KeyPointAnimation(keyPoint.X + 5, keyPoint.Y + 5);
			//	Выставляем точку на новые координаты (смещённые от копированной точки)
			newKeyPoint.x = keyPoint.x + 5;
			newKeyPoint.y = keyPoint.y + 5;
			//	Установка слушателей на точку
			initPointHandler(newKeyPoint);
			//	Добавление точки в контенер точек
			lineContainer.addChild(newKeyPoint);
			//	Добавление точки в массив ключевых точек
			arrKeyPoint.splice(keyIndex+1, 0, newKeyPoint);
			//	Перерисовка линии анимации
			drawLine();
		}
		
		//	Метод отдатия текущей точки для контроллера (для вывода настроек в панель)
		public function get currentPoint():KeyPointAnimation{
			return this.keyPoint;
		}
		
		/*
			БЛОК СОХРАНЕНИЯ И ЗАПИСИ НАСТРОЕК АНИМАЦИИ
		*/
		//	Установка настроек объекта анимации
		public function set listPosition(value:XMLList):void{
			this.removeAnimation();
			this.step = parseFloat(value.@step.toString());
			this.startFrom = parseFloat(value.@startTime.toString());
			this.cicling = value.@cicling.toString() == 'true';
			isFirstPointSettings = value.@firstPoint.toString() == 'true';
			isRemoveObject = value.@removeObject.toString() == 'true';
			if(value.@address.toString()!='') this.address = parseInt(value.@address);
			this.multiple = value.@multiple.toString()=='true';
			this.animationStatic = value.@static.toString()=='true';
			this.label = value.@label.toString();
			var xml:XMLList = value.POINTS;
			var ID:int;
			for each(var sample:XML in xml.KEYPOINT){
				ID = arrKeyPoint.length;
				arrKeyPoint.push(new KeyPointAnimation(0, 0));
				(arrKeyPoint[ID] as KeyPointAnimation).listPosition = new XMLList(sample);
				//	Добавление новой точки в контейнер отображения
				lineContainer.addChild(arrKeyPoint[ID]);
				//	Инициализация слушателей на точке
				initPointHandler(arrKeyPoint[ID] as KeyPointAnimation);
			}
			if(this.classObject!=null){
				if(value.POINTS.KEYPOINT.@color.toString()==''){
					var i:int;
					var l:int;
					l = arrKeyPoint.length;
					for(i=0;i<l;i++){
						arrKeyPoint[i].color = classObject.animationColor;
					}
				}
			}
			if(isFirstPointSettings){
				this.object.rotation = (arrKeyPoint[0] as KeyPointAnimation).rotation;
				this.object.alpha = (arrKeyPoint[0] as KeyPointAnimation).alpha;
				this.object.scaleX = (arrKeyPoint[0] as KeyPointAnimation).scale;
				this.object.scaleY = (arrKeyPoint[0] as KeyPointAnimation).scale;
				if((arrKeyPoint[0] as KeyPointAnimation).block) this.object.mouseEnabled = false;
			}
			stopRecord();
			replaceKeyPoints();
			if(label == ''){
				startAnimation()
			}
		}
		public function startAnimation():void{
			if(this.startFrom == 0) this.play();
			else{
				var timerStartFrom:Timer = new Timer(1000*this.startFrom, 1);
				timerStartFrom.addEventListener(TimerEvent.TIMER, TIMER_START_FROM);
				timerStartFrom.start();
			}
		}
		
		private function TIMER_START_FROM(event:TimerEvent):void{
			play();
		}
		
	}
	
}
