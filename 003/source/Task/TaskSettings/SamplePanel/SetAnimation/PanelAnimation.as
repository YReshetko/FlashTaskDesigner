package source.Task.TaskSettings.SamplePanel.SetAnimation {
	import flash.display.Sprite;
	import source.Task.Animation.IObjectAnimation;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import source.Task.TaskSettings.SamplePanel.PanelLabel;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.events.MouseEvent;
	import source.Task.Animation.ObjectAnimation;
	import source.Task.TaskSettings.SamplePanel.PanelField;
	import flash.events.Event;
	import source.Task.TaskSettings.SamplePanel.PanelMark;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.errors.IOError;
	import flash.display.Loader;
	
	public class PanelAnimation extends Sprite{
		//	Текущий объект анимации
		private var objectAnimation:ObjectAnimation;
		//	Поле для заполнения шага записи
		private var stapField:PanelField;
		//	Поле запуска анимации через время в секундах
		private var startField:PanelField;
		//	Поле для записи метки анимации
		private var labelField:PanelField;
		//	Поле установки числа доступа к анимации
		private var addressField:PanelField;
		//	Поле для зацикливания анимации
		private var ciclingMark:PanelMark;
		//	Поле удаления объекта со сцены по окончанию анимации
		private var removeObjectMark:PanelMark;
		//	Поле установки настроек первой точки на объект
		private var applyFirsPointMark:PanelMark;
		//	Поле установки множественного проигрывания анимации
		private var multipleMark:PanelMark;
		//	Поле установки анимации со второй точки
		private var staticMark:PanelMark;
		//	Кнопка записи
		private var recordBut:MovieClip = new RecordButAnimation();
		//	Кнопка визуализации линии анимации
		private var lineBut:MovieClip = new LineButAnimation();
		//	Кнопка "Проигрывания" анимации
		private var playBut:PlayAnimation = new PlayAnimation();
		//	Кнопка остановки "Проигрывания" анимации
		private var stopBut:StopAnimation = new StopAnimation();
		//	Кнопка сохранения анимации
		private var saveAnimation:SaveAnimation = new SaveAnimation();
		//	Кнопка загрузки анимации
		private var loadAnimation:LoadAnimation = new LoadAnimation();
		//	Кнопка удаления анимации
		private var removeBut:RemoveAnimation = new RemoveAnimation();
		//	Кнопка сбора всех точек в одну
		private var pointInOne:PointInOneAnimation = new PointInOneAnimation();
		//	Объект загрузки и сохранения анимации из файла
		private var loadFileReference:FileReference = new FileReference();
		public function PanelAnimation(object:*, xml:XML) {
			super();
			
			//	Инициализация объекта анимации
			objectAnimation = object[xml.@variable.toString()];
			initAddFields();
			if(objectAnimation.hasAnimation) initPanelWithAnimation();
			else initPanelWithoutAnimation();
			objectAnimation.addEventListener(ObjectAnimation.END_RECORD, END_RECORD_ANIMATION);
		}
		private function initDefaultPanel():void{
			super.addChild(stapField);
			super.addChild(recordBut);
			super.addChild(lineBut);
			super.addChild(loadAnimation);
			
			super.addChild(startField);
			super.addChild(ciclingMark);
			
			super.addChild(labelField);
			
			recordBut.x = stapField.x + stapField.width + 5;
			lineBut.x = recordBut.x + recordBut.width + 5;
			loadAnimation.x = lineBut.x + lineBut.width + 5;
			
			startField.y = stapField.y + stapField.height + 5;
			ciclingMark.y = startField.y;
			ciclingMark.x = startField.x + startField.width + 5;
			
			labelField.y = startField.y + startField.height + 5;
			
			
			stapField.property = objectAnimation.step.toString();
			startField.property = objectAnimation.startFrom.toString();
			ciclingMark.property = objectAnimation.cicling;
			labelField.property = objectAnimation.label;
			
			recordBut.addEventListener(MouseEvent.CLICK, START_RECORD);
			lineBut.addEventListener(MouseEvent.CLICK, SHOW_LINE);
			loadAnimation.addEventListener(MouseEvent.CLICK, LOAD_ANIMATION);
			stapField.addEventListener(PanelField.GET_TEXT_PROPERTY, STAP_SETTINGS);
			startField.addEventListener(PanelField.GET_TEXT_PROPERTY, START_TIME);
			labelField.addEventListener(PanelField.GET_TEXT_PROPERTY, MARK_ANIMATION);
			ciclingMark.addEventListener(PanelMark.GET_MARK_PROPERTY, CICLING_MARK);
			reDownRecord();
			reDownLine();
		}
		//	Инициализация панели без записанной анимации
		private function initPanelWithoutAnimation():void{
			initDefaultPanel();
		}
		//	Инициализация панели с записанной анимацией
		private function initPanelWithAnimation():void{
			initDefaultPanel();
			super.addChild(playBut);
			super.addChild(stopBut);
			super.addChild(removeBut);
			super.addChild(saveAnimation);
			
			super.addChild(pointInOne);
			
			super.addChild(removeObjectMark);
			super.addChild(applyFirsPointMark);
			
			super.addChild(addressField);
			super.addChild(multipleMark);
			super.addChild(staticMark);
			
			removeObjectMark.y = ciclingMark.y;
			applyFirsPointMark.y = labelField.y;
			removeObjectMark.x = ciclingMark.x + ciclingMark.width+5;
			applyFirsPointMark.x = labelField.x + labelField.width + 5;
			
			staticMark.y = addressField.y = multipleMark.y = applyFirsPointMark.y + applyFirsPointMark.height + 5;
			staticMark.x = addressField.x + addressField.width + 5;
			multipleMark.x = staticMark.x + staticMark.width + 5;
			
			removeObjectMark.property = this.objectAnimation.removeComplated;
			applyFirsPointMark.property = this.objectAnimation.firstPoint;
			
			saveAnimation.x = loadAnimation.x + loadAnimation.width + 5;
			playBut.x = saveAnimation.x + saveAnimation.width + 10;
			stopBut.x = playBut.x + playBut.width + 5;
			
			pointInOne.x = stopBut.x + stopBut.width + 5;
			removeBut.x = pointInOne.x + pointInOne.width + 15;
			
			removeObjectMark.addEventListener(PanelMark.GET_MARK_PROPERTY, REMOVE_OBJECT);
			applyFirsPointMark.addEventListener(PanelMark.GET_MARK_PROPERTY, FIRST_POINT_SETTINGS);
			staticMark.addEventListener(PanelMark.GET_MARK_PROPERTY, SET_STATIC_ANIMATION);
			multipleMark.addEventListener(PanelMark.GET_MARK_PROPERTY, SET_MULTIPLE_ANIMATION);
			
			addressField.addEventListener(PanelField.GET_TEXT_PROPERTY, SET_ADDRESS);
			
			
			saveAnimation.addEventListener(MouseEvent.CLICK, SAVE_ANIMATION);
			playBut.addEventListener(MouseEvent.CLICK, PLAY_ANIMATION);
			stopBut.addEventListener(MouseEvent.CLICK, STOP_ANIMATION);
			removeBut.addEventListener(MouseEvent.CLICK, REMOVE_ANIMATION);
			pointInOne.addEventListener(MouseEvent.CLICK, POINT_IN_ONE_ANIMATION);
		}
		private function END_RECORD_ANIMATION(event:Event):void{
			reDownRecord();
		}
		//	Инициализация дополнительных полей
		private function initAddFields():void{
			var xml:XML = new XML('<FIELD label="Шаг (сек.)" type="number" variable="step" width="40">' + objectAnimation.step.toString() + '</FIELD>');
			stapField = new PanelField(xml);
			
			xml = new XML('<FIELD label="Запуск через (сек.)" type="number" variable="startFrom" width="40">' + objectAnimation.startFrom.toString() + '</FIELD>');
			startField = new PanelField(xml);
			
			xml = new XML('<MARK label="Зациклить" variable="cicling">'+objectAnimation.cicling.toString()+'</MARK>');
			ciclingMark = new PanelMark(xml);
			
			xml = new XML('<FIELD label="Метка" type="string" variable="startFrom" width="120">' + objectAnimation.label + '</FIELD>');
			labelField = new PanelField(xml);
			
			xml = new XML('<MARK label="Удалить объект" variable="removeComplated">'+objectAnimation.removeComplated.toString()+'</MARK>');
			removeObjectMark = new PanelMark(xml);
			
			xml = new XML('<MARK label="Настройки 1-ой точки" variable="firstPoint">'+objectAnimation.firstPoint.toString()+'</MARK>');
			applyFirsPointMark = new PanelMark(xml);
			
			xml = new XML('<FIELD label="Число запросов" type="number" variable="address" width="40">' + objectAnimation.address.toString() + '</FIELD>');
			addressField = new PanelField(xml);
			
			xml = new XML('<MARK label="Можественный запуск" variable="multiple">'+objectAnimation.multiple.toString()+'</MARK>');
			multipleMark = new PanelMark(xml);
			
			xml = new XML('<MARK label="Статическая анимация" variable="animationStatic">'+objectAnimation.animationStatic.toString()+'</MARK>');
			staticMark = new PanelMark(xml);
		}
		//--------------------------------------------------------------------------//
		/*
			ОБРАБОТЧИКИ НАЖАТИЯ КНОПОК НАСТРОЙКИ АНИМАЦИИ
		*/
		//	Изменение метки анимации
		private function MARK_ANIMATION(event:Event):void{
			objectAnimation.label = labelField.property;
		}
		//	Обработка изменения стартового времени анимации
		private function START_TIME(event:Event):void{
			objectAnimation.startFrom = parseFloat(startField.property);
		}
		//	Обработка изменения зацикливания анимации
		private function CICLING_MARK(event:Event):void{
			objectAnimation.cicling = ciclingMark.property;
		}
		//	Обработка изменения параметра удаления объекта
		private function REMOVE_OBJECT(event:Event):void{
			objectAnimation.removeComplated = removeObjectMark.property;
		}
		//	Обработка применения настроек первой точки к объекту
		private function FIRST_POINT_SETTINGS(event:Event):void{
			objectAnimation.firstPoint = applyFirsPointMark.property;
		}
		//	Обработка изменения шага анимации
		private function STAP_SETTINGS(event:Event):void{
			objectAnimation.step = parseFloat(stapField.property);
		}
		//	Обработчик нажатия кнопки начала записи
		private function START_RECORD(event:MouseEvent):void{
			objectAnimation.startRecord();
			reDownRecord();
		}
		//	Обработчик нажатия кнопки "показать линию нанимации"
		private function SHOW_LINE(event:MouseEvent):void{
			objectAnimation.line = !objectAnimation.line;
			reDownLine();
		}
		//	Проигрывание анимации
		private function PLAY_ANIMATION(event:MouseEvent):void{
			objectAnimation.play();
		}
		//	Остановка проигрывания анимации
		private function STOP_ANIMATION(event:MouseEvent):void{
			objectAnimation.stop();
		}
		//	Удаление анимации
		private function REMOVE_ANIMATION(event:MouseEvent):void{
			objectAnimation.removeAnimation();
		}
		//	Установка числа доступа к анимации
		private function SET_ADDRESS(event:Event):void{
			objectAnimation.address = parseInt(addressField.property);
		}
		//	Установка статической анимации
		private function SET_STATIC_ANIMATION(event:Event):void{
			objectAnimation.animationStatic = this.staticMark.property;
		}
		//	Установка множественного запуска анимации
		private function SET_MULTIPLE_ANIMATION(event:Event):void{
			objectAnimation.multiple = this.multipleMark.property;
		}
		//	Сбор всех точек анимации в первую
		private function POINT_IN_ONE_ANIMATION(event:MouseEvent):void{
			objectAnimation.replacePointInOne();
		}
		/**************************************/
		
		/*
			БЛОК ЗАГРУЗКИ И СОХРАНЕНИЯ ФАЙЛА АНИМАЦИИ
		*/
		//	Загрузка файла анимации
		private function LOAD_ANIMATION(event:MouseEvent):void{
			var fileFilter:FileFilter = new FileFilter('Анимация', '*.txt');
			loadFileReference.addEventListener(Event.SELECT, FILE_SELECT);
			try{
				loadFileReference.browse([fileFilter]);
			}
			catch(illegalOperation:IllegalOperationError){
				trace("Error");
				loadFileReference.removeEventListener(Event.SELECT, FILE_SELECT);
			}
			
		}
		private function FILE_SELECT(event:Event):void{
			loadFileReference.removeEventListener(Event.SELECT, FILE_SELECT);
			trace(this + ': File Select');
			loadFileReference.addEventListener(Event.COMPLETE,LOAD_ANIMATION_COMPLETE);
			loadFileReference.addEventListener(ErrorEvent.ERROR,LOAD_ANIMATION_ERROR);
			//	Попытка загрузить содержимое файла в плеер, 
			//	если всё пройдёт удачно, то содержимое будет храниться в свойстве data
			try{
				trace(this + ': Start File Load...')
				loadFileReference.load();
				trace(this + ': Load Method complate...');
			}
			//	Обработка недопустимости операции
			catch(illegalOperation:IllegalOperationError){
				trace(this + "Error Loading Pict...");
				loadFileReference.removeEventListener(Event.COMPLETE,LOAD_ANIMATION_COMPLETE);
				loadFileReference.removeEventListener(ErrorEvent.ERROR,LOAD_ANIMATION_ERROR);
			}
			catch(ioError:IOError){
				trace(this + "IOError...");
				loadFileReference.removeEventListener(Event.COMPLETE,LOAD_ANIMATION_COMPLETE);
				loadFileReference.removeEventListener(ErrorEvent.ERROR,LOAD_ANIMATION_ERROR);
			}
			catch(error:TypeError){
				trace(this + ': Type Error');
				loadFileReference.removeEventListener(Event.COMPLETE,LOAD_ANIMATION_COMPLETE);
				loadFileReference.removeEventListener(ErrorEvent.ERROR,LOAD_ANIMATION_ERROR);
			}
			//trace("SELECT...");
		}
		private function LOAD_ANIMATION_COMPLETE(event:Event):void{
			loadFileReference.removeEventListener(Event.COMPLETE,LOAD_ANIMATION_COMPLETE);
			loadFileReference.removeEventListener(ErrorEvent.ERROR,LOAD_ANIMATION_ERROR);
			trace(this + ': Load FILE complate');
			var xml:XMLList = new XMLList(event.target.data);
			trace(this + ' XML ANIMATION\n' + xml);
			//objectAnimation.listPosition = xml;
			objectAnimation.loadListPosition = xml;
			trace(this + ': INIT OBJECT ANIMATION');
		}
		private function LOAD_ANIMATION_ERROR(event:ErrorEvent):void{
			trace(this + 'LOAD ANIMATION ERROR');
			loadFileReference.removeEventListener(Event.COMPLETE,LOAD_ANIMATION_COMPLETE);
			loadFileReference.removeEventListener(ErrorEvent.ERROR,LOAD_ANIMATION_ERROR);
		}
		//	Сохранение файла анимации
		private function SAVE_ANIMATION(event:MouseEvent):void{
			var saveList:XMLList = objectAnimation.listPosition;
			loadFileReference.save(saveList.toString(), 'Animation.txt');
		}
		/**************************************/
		//--------------------------------------------------------------------------//
		/*
			МЕТОДЫ ПЕРЕРИСОВКИ ЗАЖИМНЫХ КНОПОК
		*/
		private function reDownRecord():void{
			if(objectAnimation.isRecord) recordBut.gotoAndStop(2);
			else recordBut.gotoAndStop(1);
		}
		private function reDownLine():void{
			if(objectAnimation.line) lineBut.gotoAndStop(2);
			else lineBut.gotoAndStop(1);
		}
		/**************************************/
		
		//	Очистка поля настроек
		private function clear():void{
			if(super.contains(stapField))	super.removeChild(stapField);
			if(super.contains(recordBut))	super.removeChild(recordBut);
			if(super.contains(lineBut))		super.removeChild(lineBut);
			if(super.contains(playBut))		super.removeChild(playBut);
			if(super.contains(stopBut))		super.removeChild(stopBut);
			if(super.contains(removeBut))	super.removeChild(removeBut);
			if(super.contains(startField))	super.removeChild(startField);
			if(super.contains(ciclingMark))	super.removeChild(ciclingMark);
			
			if(stapField.hasEventListener(PanelField.GET_TEXT_PROPERTY))	stapField.removeEventListener(PanelField.GET_TEXT_PROPERTY, STAP_SETTINGS);
			if(recordBut.hasEventListener(MouseEvent.CLICK))				recordBut.removeEventListener(MouseEvent.CLICK, START_RECORD);
			if(lineBut.hasEventListener(MouseEvent.CLICK))					lineBut.removeEventListener(MouseEvent.CLICK, SHOW_LINE);
			if(playBut.hasEventListener(MouseEvent.CLICK))					playBut.removeEventListener(MouseEvent.CLICK, PLAY_ANIMATION);
			if(stopBut.hasEventListener(MouseEvent.CLICK))					stopBut.removeEventListener(MouseEvent.CLICK, STOP_ANIMATION);
			if(removeBut.hasEventListener(MouseEvent.CLICK))				removeBut.removeEventListener(MouseEvent.CLICK, REMOVE_ANIMATION);
			if(startField.hasEventListener(PanelField.GET_TEXT_PROPERTY))	startField.removeEventListener(PanelField.GET_TEXT_PROPERTY, START_TIME);
			if(ciclingMark.hasEventListener(PanelMark.GET_MARK_PROPERTY))	ciclingMark.removeEventListener(PanelMark.GET_MARK_PROPERTY, CICLING_MARK);
		}
	}
	
}
