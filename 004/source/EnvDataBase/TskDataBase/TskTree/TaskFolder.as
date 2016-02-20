package source.EnvDataBase.TskDataBase.TskTree {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class TaskFolder extends Sprite{
		//	переменная для определения слушателя перерисовки подкаталогов
		public static var FOLDER_UPDATE:String = 'onUpdateFolder';
		//	начальная позиция дочерних объектов
		private var xField:Number = 20;
		//	массив дочерних каталогов
		private var arrFolder:Array = new Array();
		//	массив дочерних файлов
		private var arrFile:Array = new Array();
		//	имя текущего каталога
		private var folderName:String;
		//	переменная определения открыт ли данный каталог
		private var openFolder:Boolean = false;
		//	метки каталога (папка открыта, закрыта, текстовая надпись)
		private var labelOpen:opFold;
		private var labelClose:closeFolder;
		private var fieldLabel:TextField = new TextField();
		//	спрайт, фиксирующий клик по каталогу
		public var listenSprite:Sprite = new Sprite();
		
		public function TaskFolder(name:String) {
			super();
			//	запоминаем имя каталога
			folderName = name;
			//	инициализируем метку каталога
			initLabel();
			//	слушаем нажатие клавиш мыши над каталогом
			listenSprite.addEventListener(MouseEvent.MOUSE_DOWN, FOLDER_MOUSE_DOWN);
			listenSprite.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, FOLDER_RIGHT_MOUSE_DOWN);
		}
		//	отрисовка надписи каталога и картинок папок
		private function initLabel():void{
			var fieldFormat:TextFormat = new TextFormat();
			fieldFormat.font = 'Arial';
			fieldFormat.size = 12;
			fieldFormat.bold = true;
			fieldLabel.textColor = 0x000000;
			fieldLabel.defaultTextFormat = fieldFormat;
			fieldLabel.autoSize = TextFieldAutoSize.LEFT;
			fieldLabel.text = folderName;
			fieldLabel.mouseEnabled = false;
			super.addChild(fieldLabel);
			fieldLabel.x = xField;
			labelOpen = new opFold();
			labelClose = new closeFolder();
			super.addChild(labelOpen);
			super.addChild(labelClose);
			labelOpen.visible = false;
			labelOpen.mouseEnabled = labelClose.mouseEnabled = false;
			Figure.insertRect(listenSprite, super.width, super.height, 1, 0, 0x000000, 0);
			super.addChild(listenSprite);
		}
		//	метод возвращения имени каталога
		public function getName():String{
			return folderName;
		}
		//	метод установки задания в каталог
		public function setFile(Path:String, task:TaskFile):void{
			//	проверяем есть ли промежуточный каталог до задания
			var index:int = Path.indexOf('/');
			//	если нет
			if(index == -1){
				//	устанавливаем задание в данный каталог
				arrFile.push(task);
				//	отрисовываем текущий каталог
				CHILD_FOLDER_MOUSE_DOWN(null);
			//	если есть промежуточный каталог
			}else{
				//	проверяем существует ли он в данном каталоге
				var fName:String = Path.substring(0, index);
				var curFolder:TaskFolder = checkFolder(fName);
				//	если не существует
				if(curFolder==null){
					//	создаём его
					var ID:int = arrFolder.length;
					arrFolder.push(new TaskFolder(fName));
					//	и устанавливаем в него задание (с обрезанным путём)
					arrFolder[ID].setFile(Path.substring(index+1, Path.length), task);
					//	слушаем событие перерисовки каталога
					arrFolder[ID].addEventListener(FOLDER_UPDATE, CHILD_FOLDER_MOUSE_DOWN);
					//	запускаем перерисовку текущего каталога
					CHILD_FOLDER_MOUSE_DOWN(null);
				//	еслии каталог существует
				}else{
					//	устанавливаем в него задание
					curFolder.setFile(Path.substring(index+1, Path.length), task);
				}
			}
		}
		//	метод проверки на существование подкаталога
		private function checkFolder(name:String):TaskFolder{
			var i:int;
			var leng:int = arrFolder.length;
			for(i=0;i<leng;i++){
				if(name == arrFolder[i].getName()){
					return arrFolder[i];
				}
			}
			return null;
		}
		//	метод перерисовки каталога в зависимости от того открыт ли он
		public function updateFolder():void{
			var i:int;
			var lengFile:int = arrFile.length;
			var lengFolder:int = arrFolder.length;
			labelOpen.visible = openFolder;
			labelClose.visible = !openFolder;
			if(openFolder){
				for(i=0;i<lengFolder;i++){
					super.addChild(arrFolder[i]);
					if(i!=0) arrFolder[i].y = arrFolder[i-1].y + arrFolder[i-1].height;
					else arrFolder[i].y = 17;
					arrFolder[i].x = xField;
				}
				for(i=0;i<lengFile;i++){
					super.addChild(arrFile[i]);
					if(i!=0){
						arrFile[i].y = arrFile[i-1].y + arrFile[i-1].height;
					}else{
						if(lengFolder!=0){
							arrFile[i].y = arrFolder[lengFolder-1].y + arrFolder[lengFolder-1].height;
						}else{
							arrFile[i].y = 17;
						}
							
					}
					arrFile[i].x = xField;
				}
			}else{
				for(i=0;i<lengFolder;i++){
					if(super.contains(arrFolder[i])){
						super.removeChild(arrFolder[i]);
					}
				}
				for(i=0;i<lengFile;i++){
					if(super.contains(arrFile[i])){
						super.removeChild(arrFile[i]);
					}
				}
			}
		}
		
		//	метод нажатия на текущий каталог
		private function FOLDER_MOUSE_DOWN(e:MouseEvent):void{
			//	изменение метки открытия каталога
			openFolder = !openFolder;
			//	запуск метода перерисовки и диспатча изменения состояния каталога
			CHILD_FOLDER_MOUSE_DOWN(null);
		}
		//	метод запускающий перерисовку каталога и диспатч изменения
		private function CHILD_FOLDER_MOUSE_DOWN(e:Event):void{
			updateFolder();
			super.dispatchEvent(new Event(FOLDER_UPDATE));
		}
		//	метод слушателя нажатия правой кнопки мыши над каталогом
		private function FOLDER_RIGHT_MOUSE_DOWN(e:MouseEvent):void{
			//	запуск метода выделения файлов
			selectFiles();
		}
		
		//	метод выделения всех файлов которые лежат в дочерних каталогах + свои файлы
		public function selectFiles():void{
			var i:int;
			var leng:int = arrFolder.length;
			for(i=0;i<leng;i++){
				arrFolder[i].selectFiles();
			}
			leng = arrFile.length;
			for(i=0;i<leng;i++){
				arrFile[i].setSelect();
			}
		}
		//	метод очистки каталога
		public function clearFolder():void{
			var i:int;
			var leng:int = arrFolder.length;
			//	очищаем дочерние каталоги
			for(i=0;i<leng;i++){
				arrFolder[i].clearFolder();
				if(super.contains(arrFolder[i])){
					super.removeChild(arrFolder[i]);
				}
			}
			//	удаляем все дочерние каталоги
			while (arrFolder.length>0){
				arrFolder[0] = null;
				arrFolder.shift();
			}
			//	удаляем все дочерние файлы
			while (arrFile.length>0){
				if(super.contains(arrFile[0])){
					super.removeChild(arrFile[0]);
				}
				arrFile[0] = null;
				arrFile.shift();
			}
		}
	}
	
}
