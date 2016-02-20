package source.EnvDataBase.TskDataBase.TskTree {
	import source.EnvInterface.EnvPanel.Panel;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.EnvEvents.Events;
	
	public class TaskTree extends Sprite{
		//	Стартовая позиция дерева задач
		private static const yPosition:int = 3;
		private static const xPosition:int = 3;
		//	Ссылка на панель в которой находится дерево
		private var treePanel:Panel;
		//	Массив каталогов в корне дерева
		private var arrFolder:Array = new Array();
		//	Массив всех заданий в дереве
		private var arrTask:Array = new Array();
		//	Массив выделенных заданий
		private var arrSelectedFile:Array = new Array();
		//	текущее выделенное задание
		private var currentFile:TaskFile;
		
		public function TaskTree(panel:Panel) {
			super();
			//	Запоминаем панель
			treePanel = panel
			//	добавляем в контенер панели супер класс для отображения дерева
			treePanel.mainContainer.addChild(super);
		}
		//	метод добавления задания в дерево
		public function setFile(nameCourse:String, Path:String, taskID:Number):void{
			//	определяем номер начала и конца названия самого задания
			var startNameIndex:int = Path.lastIndexOf('/')+1;
			var endNameIndex:int = Path.length;
			//	Определяем имя задания
			var nameTask:String = Path.substring(startNameIndex, endNameIndex);
			//	запоминаем индекс массива с которым надо будет работать
			var TID:int = arrTask.length;
			//	добавляем в массив заданий новое задание
			arrTask.push(new TaskFile(nameTask, taskID));
			//	слушаем события связанные с деревом заданий
			arrTask[TID].addEventListener(Events.FILE_CLICK, ARR_FILE_CLICK);
			arrTask[TID].addEventListener(Events.FILE_SELECT, ARR_FILE_SELECT);
			arrTask[TID].addEventListener(Events.FILE_DESELECT, ARR_FILE_DESELECT);
			arrTask[TID].addEventListener(Events.FILE_FOCUS_OUT, ARR_FILE_FOCUS_OUT);
			//	Проверяем существует ли каталог курса задания которое пришло
			var curFolder:TaskFolder = checkFolder(nameCourse);
			//	Если не существует
			if(curFolder==null){
				//	запоминаем номер массива каталогов курсов, с которым будем работать
				var ID:int = arrFolder.length;
				//	добавление в массив нового каталога
				arrFolder.push(new TaskFolder(nameCourse));
				//	установка в каталог задания и пути к заданию
				arrFolder[ID].setFile(Path, arrTask[TID]);
				//	помещение каталога в список отображения
				super.addChild(arrFolder[ID]);
				//	позицианирование каталога в зависимости от его порядкового номера
				if(ID!=0) arrFolder[ID].y = arrFolder[ID-1].y+arrFolder[ID-1].height;
				else arrFolder[ID].y = yPosition;
				arrFolder[ID].x = xPosition;
				//	добавление слушателя нажатия левой кнопки мыши над каталогом
				arrFolder[ID].addEventListener(TaskFolder.FOLDER_UPDATE, FOLDER_MOUSE_DOWN);
			//	Если такой каталог курса существует
			}else{
				//	Устанавливаем пришедшее задание в каталог
				curFolder.setFile(Path, arrTask[TID]);
			}
			// запускаем перерасстановку корневых каталогов в дереве
			FOLDER_MOUSE_DOWN(null)
		}
		//	Метод проверки существования каталога в корне дерева
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
		//	метод слушателя нажатия кнопки мыши над корневым каталогом
		//	производит перерасстановку каталогов в дереве
		private function FOLDER_MOUSE_DOWN(e:Event):void{
			var i:int;
			var leng:int = arrFolder.length;
			for(i=0;i<leng;i++){
				if(i!=0) arrFolder[i].y = arrFolder[i-1].y+arrFolder[i-1].height;
				else arrFolder[i].y = yPosition;
			}
			treePanel.updatePanel();
		}
		//	Метод очистки дерева заданий
		public function clearTree():void{
			var i:int;
			var folderLeng:int = arrFolder.length
			//	запускаем очистку всех папок
			if(folderLeng!=0){
				for(i=0;i<folderLeng;i++){
					arrFolder[i].clearFolder();
					super.removeChild(arrFolder[i]);
				}
			}
			//	удаляем все корневые каталоги
			while(arrFolder.length>0){
				arrFolder[0] = null;
				arrFolder.shift();
			}
			//	удаляем все файлы с заданиями
			while(arrTask.length>0){
				arrTask[0] = null;
				arrTask.shift();
			}
		}
		
		//	Метод слушателя клика по файлу (левая кнопка мыши)
		private function ARR_FILE_CLICK(e:Event):void{
			//	запоминаем файл на который кликнули
			currentFile = e.target as TaskFile;
			//	снимаем все выделения с файлов (групповое красное)
			while(arrSelectedFile.length>0){
				arrSelectedFile[0].removeSelect();
				arrSelectedFile.shift();
			}
			//	устанавливаем в текущий файл синий цвет клика
			currentFile.setClick();
			//	диспатчим событие о том что прошли изменения в выделении
			dispatchSelect();
		}
		//	метод слушателя группового выделения файлов (красный цвет)
		private function ARR_FILE_SELECT(e:Event):void{
			//	текущий файл не определён
			currentFile = null;
			//	добавляем в массив выделения объект, который продиспатчил событие
			arrSelectedFile.push(e.target as TaskFile);
			//	диспатчим событие о изменении выделения
			dispatchSelect();
		}
		//	метод слушателя снятия выделения отдельного файла
		private function ARR_FILE_DESELECT(e:Event):void{
			var i:int;
			var leng:int = arrSelectedFile.length;
			//	удаляем из середины массива ссылку на файл
			for(i=0;i<leng;i++){
				if(e.target == arrSelectedFile[i]){
					arrSelectedFile.splice(i,1);
				}
			}
			//	диспатчим событие о изменении выделения
			dispatchSelect();
		}
		//	метод снятия фокуса с задания в дереве
		private function ARR_FILE_FOCUS_OUT(e:Event):void{
			//	удаляем всё из массива ссылок
			while(arrSelectedFile.length>0){
				arrSelectedFile[0].removeSelect();
				arrSelectedFile.shift();
			}
			//	обнуляем ссылку на выделенный файл
			currentFile = null;
			//	диспатчим событие о изменении выделения
			dispatchSelect();
		}
		//	метод диспатча события изменения выделения
		private function dispatchSelect():void{
			super.dispatchEvent(new Event(Events.FILE_SELECT));
		}
		
		//	метод определяет выделен хотябы один файл или нет
		public function isFileSelect():Boolean{
			var outFlag:Boolean = false;
			if(arrSelectedFile.length>0) outFlag = true;
			if(currentFile != null) outFlag = true;
			return outFlag;
		}
		//	метод возвращает ссылки на файлы, которые были выделены
		public function getLinksOnFile():Array{
			var outArray:Array = new Array();
			if(currentFile != null) outArray.push(currentFile.getLink());
			for(var i:int = 0; i<arrSelectedFile.length;i++){
				outArray.push(arrSelectedFile[i].getLink());
			}
			return outArray;
		}
	}
	
}
