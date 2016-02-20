package source.EnvKonstraktion.PictLibrary {
	import source.EnvInterface.EnvPanel.Panel;
	import source.EnvEvents.Events;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvUtils.EnvString.ConvertString;
	import source.EnvUtils.ByteUtils.CheckByteArray;
	import source.MainEnvelope;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	
	public class Library extends Sprite{
		private static const startPosition:int = 3;
		//	Ссылочная переменная на панель сцены
		private var panel:Panel;
		private var paintPanel:Panel;
		//	Массив экземпляров для библиотеки
		private var arrSample:Array = new Array();
		//	Параетр для переименовывания картинок (следующий номер)
		private var currentRenameID:int = 0;
		//	Контенер для перемещения картинок из библиотеки на сцену
		private var dragContainer:Sprite;
		//	Контур вынесения образца картинки
		private var outputSample:Sprite;
		//	Параметры текущего выносимого образца библиотеки
		private var currentName:String;
		private var currentBitmap:ByteArray;
		private var currentSwf:ByteArray;
		//	Конструктор
		public function Library(panel:Panel, pPanel:Panel) {
			super();
			//	Запоминаем вошедшую панель в ссылку
			this.panel = panel;
			paintPanel = pPanel;
			//	Добавляем текущий объект в контенер панели
			panel.mainContainer.addChild(super);
			this.panel.addEventListener(Events.PANEL_IS_CHANGE, PANEL_CHANGE);
		}
		//	Метод добавления контенера перемещения происходит после инициализации Konstraction.swf
		public function setDragContainer(container:Sprite):void{
			dragContainer = container;
		}
		//	Изменение визуализации панели (видимость/невидимость)
		public function changVisible():void{
			panel.visible = !panel.visible;
		}
		//	Записываем новую пачку картинок (возвращает массив переименовки)
		public function setPicture(bitmapArray:Array, arrayByteArray:Array, nameArray:Array):Array{
			//	Массив переименования входящего контента
			var outArray:Array = new Array();
			//	Имена файлов
			var inFileName:String;
			var sampleFileName:String;
			var oldName:String;
			var newName:String;
			//	Массивы байт файлов
			var inFileBA:ByteArray;
			var sampleFileBA:ByteArray;
			//	Индексы
			var i:int;
			var j:int;
			//	длина массива входящего контента (число загружаемых файлов)
			var l:int = bitmapArray.length;
			//	Флаг продолжения анализа
			var flag:Boolean;
			//	длина массива образцов библиотеки
			var k:int;
			for(i=0;i<l;i++){
				//	записываем текущие параметры просматриваемого загруженного файла
				k = arrSample.length;
				inFileName = nameArray[i];
				inFileBA = arrayByteArray[i];
				//	по умолчанию считаем что загружаемой картинки нет в библиотеке
				flag = true;
				//	ЭТАП 1: Проверяем все байтовые массивы библиотеки на совпадение 
				//	с текущим загруженным объектом
				for(j=0;j<k;j++){
					//	Сохраняем параметры текущего объекта библиотеки (имя и байтовый массив)
					sampleFileName = arrSample[j].getLabel();
					sampleFileBA = arrSample[j].getByteArray();
					//	Если совпадение байтовых массивов найдено
					if(CheckByteArray.checkByteArray(inFileBA, sampleFileBA)){
						//	Помечаем, что обработка не пойдёт дальше ЭТАПА 1.
						flag = false;
						//	Записываем Смену имени в исходящий массив
						if(inFileName!=sampleFileName)outArray.push([inFileName, sampleFileName]);
						//	Заканчиваем цикл.
						break;
					}
				}
				//	Если такой контент ещё не загружен
				if(flag){
					//	ЭТАП 2: Коррекция имени загружаемого файла в соответствии с нашим форматом
					oldName = inFileName;
					//trace(this + ': OLD NAME = ' + oldName);
					newName = ConvertString.nameFormat(inFileName);
					//trace(this + ': CONVERTING NAME = ' + newName);
					newName = getUniqName(newName);
					
					//	ЭТАП 3: Запись изменённого имени и запись контента в библиотеку
					if(oldName != newName) outArray.push([oldName, newName]);
					setNewSample(newName, bitmapArray[i], inFileBA);
				}
			}
			
			/**********ИСПОЛЬЗУЕМЫЕ МЕТОДЫ***********/
			//	Сравнение двух байтовых массивов
			//CheckByteArray.checkByteArray(oldBA, arrBA[i])
			//	Запись образца в библиотеку
			//setNewSample(newName, arrBMP[i], arrBA[i]);
			//	проверка на совпадение имён с библиотекой
			//getUniqName(arrN[i])
			//	Заполнение выходящего массива
			//outArray.push([oldName, newName]);
			//	Взятие байтового массива по имени из библиотеки
			//getByteArrays([oldName])[0][1]
			/****************************************/
			trace(this + ': SEP PICTURE COMPLATE');
			PANEL_CHANGE(null);
			panel.updatePanel();
			//	Возвращаем матрицу изменения имён
			return outArray;
		}
		//	Метод добавления в библиотеку нового экземпляра контента
		private function setNewSample(name:String, bitmap:*, byteArray:ByteArray):void{
			//	Длина массива 
			var ID:int = arrSample.length;
			//	Создаём новый экземпляр лейбла для библиотеки
			if(ConvertString.checkSwfName(name) /*&& ConvertString.checkMp3Name(name)*/ && ConvertString.checkPasName(name)){
				arrSample.push(new Sample(name, bitmap, byteArray));
			}else{
				if(ConvertString.checkSwfName(name)){
					arrSample.push(new PasSample(name, new Bitmap(), byteArray));
				}else{
					arrSample.push(new SwfSample(name, bitmap, byteArray));
				}
			}
			//	Добавляем лейбл библиотеки в контенер отображения
			super.addChild(arrSample[ID]);
			//	Устанавливаем параметры позиции объекта библиотеки
			if(ID>0){
				arrSample[ID].y = arrSample[ID-1].y + arrSample[ID-1].height + 5;
			}
			arrSample[ID].x = startPosition;
			arrSample[ID].addEventListener(Events.SAMPLE_FROM_LIBRARY_MOUSE_DOWN, ADD_SAMPLE_ON_SCENE);
		}
		//	Метод возвращения набора данных картинок с именами для передачи их в конструктор
		//	Формат ввода: Массив имён картинок
		//	Формат вывода: Массив векторов, каждый вектор на первой позиции содержит имя картинки, 
		//	на второй Bitmap картинки
		public function getArrayData(inArray:Array, flag:Boolean = false):Array{
			var i:int;
			var j:int;
			var lengInArray:int = inArray.length;
			var lengSampleArray:int = arrSample.length;
			var outArray:Array = new Array();
			var currentFileName:String;
			for(i=0;i<lengInArray;i++){
				for(j=0;j<lengSampleArray;j++){
					currentFileName = arrSample[j].getLabel();
					if(inArray[i] == currentFileName){
						if(ConvertString.checkSwfName(currentFileName)){
							if(flag){
								outArray.push([arrSample[j].getBitmap(), currentFileName]);
							}else{
								outArray.push([currentFileName, arrSample[j].getBitmap()]);
							}
						}else{
							if(flag){
								outArray.push([arrSample[j].getSwf(), currentFileName]);
							}else{
								outArray.push([currentFileName, arrSample[j].getSwf()]);
							}
						}
						break;
					}
				}
			}
			return outArray;
		}
		//	Метод возвращения набора данных картинок с именами для сохранения задания
		//	Формат ввода: Массив имён картинок
		//	Формат вывода: Массив векторов, каждый вектор на первой позиции содержит имя картинки, 
		//	на второй ByteArray картинки
		public function getByteArrays(inArray:Array, flag:Boolean = false):Array{
			var i:int;
			var j:int;
			var lengInArray:int = inArray.length;
			var lengSampleArray:int = arrSample.length;
			var outArray:Array = new Array();
			var currentFileName:String;
			for(i=0;i<lengInArray;i++){
				for(j=0;j<lengSampleArray;j++){
					currentFileName = arrSample[j].getLabel();
					if(inArray[i] == currentFileName){
						if(flag){
							outArray.push([arrSample[j].getByteArray(), currentFileName]);
						}else{
							outArray.push([currentFileName, arrSample[j].getByteArray()]);
						}
						break;
					}
				}
			}
			return outArray;
		}
		//	Получение уникального имени картинки для записи в библиотеку
		//	Если такое имя найдено, то к старому прибавляется строка _<Номер изменения>__
		private function getUniqName(value:String):String{
			var i:int;
			var l:int;
			var inName:String = value.substring(0, value.lastIndexOf("."));
			var inExtention:String = value.substring(value.lastIndexOf("."), value.length);
			var currentName:String;
			var currentExtention:String;
			var currentFile:String;
			
			var checkName:String = inName;
			var currentID:int = 0;
			
			l = arrSample.length;
			for(i=0;i<arrSample.length;i++){
				currentFile = arrSample[i].getLabel();
				currentName = currentFile.substring(0, currentFile.lastIndexOf("."));
				currentExtention = currentFile.substring(currentFile.lastIndexOf("."), currentFile.length);
				if(inExtention == currentExtention){
					if(checkName == currentName){
						++currentID;
						checkName = inName+'_'+currentID.toString();
						i = 0;
					}
				}
			}
			var outName:String = checkName+inExtention;
			return outName;
		}
		private function PANEL_CHANGE(e:Event):void{
			var inObject:Object = panel.getSizeSettings();
			var _W:Number = inObject.width - Panel.deltaXY*2 - startPosition*2;
			var i:int;
			var leng:int = arrSample.length;
			for(i=0;i<leng;i++){
				arrSample[i].drawBackground(_W);
			}
		}
		
		private var currentX:Number;
		private var currentY:Number;
		private function ADD_SAMPLE_ON_SCENE(e:Event):void{
			panel.activeHandler(false);
			currentName = e.target.getLabel();
			if(ConvertString.checkSwfName(currentName)){
				currentBitmap = e.target.getByteArray();
			}else{
				try{
					currentSwf = e.target.getByteArray();
					//trace(this + ': CURRENT SWF = ' + currentSwf);
				}catch(e:Error){
					trace(this + ': GET ERROR = ' + e);
					return;
				}
			}
			outputSample = new Sprite();
			var countur:Sprite = Figure.returnRect(20, 15, 1, 0.5, 0x000000, 0);
			outputSample.addChild(countur);
			countur.x = -countur.width/2;
			countur.y = -countur.height/2;
			dragContainer.addChild(outputSample);
			//trace(this + ': ADD DRAG CONTAINER');
			outputSample.startDrag(true);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, STAGE_MOUSE_MOVE);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, OUTPUT_SAMPLE_MOUSE_UP);
			//trace(this + ': ADD LISTENER');
		}
		private function STAGE_MOUSE_MOVE(e:MouseEvent):void{
			e.updateAfterEvent();
		}
		private function OUTPUT_SAMPLE_MOUSE_UP(e:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, STAGE_MOUSE_MOVE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, OUTPUT_SAMPLE_MOUSE_UP);
			//trace(this + ': PLACE TARGET ON SCENE');
			panel.activeHandler(true);
			if(!outputSample.hitTestObject(panel.maskPanel)){
				if(outputSample.hitTestObject(paintPanel.maskPanel) && paintPanel.visible){
					super.dispatchEvent(new Event(Events.ADD_PICTURE_IN_PAINT));
				}else{
					currentX = outputSample.x;
					currentY = outputSample.y;
					super.dispatchEvent(new Event(Events.ADD_PICTURE_IN_DESIGNER));
				}
			}
			outputSample.stopDrag();
			dragContainer.removeChild(outputSample);
			outputSample = null;
		}
		public function getAddedSample():Object{
			var outObject:Object = new Object();
			outObject.x = currentX;
			outObject.y = currentY;
			outObject.name = currentName;
			if(ConvertString.checkSwfName(currentName)){
				outObject.bitmap = currentBitmap;
			}else{
				outObject.swf = currentSwf;
			}
			return outObject;
		}
	}
	
}
