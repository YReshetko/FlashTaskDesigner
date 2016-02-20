package source.EnvInterface.WorkScene.DLCourses {
	import flash.display.Sprite;
	import source.Components.Label;
	import source.EnvInterface.WorkScene.TskTree.TaskFile;
	import source.EnvInterface.WorkScene.TskTree.TaskFolder;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MYCourse extends Sprite{
		public static var UPDATE_PANEL:String = 'onUpdatePanel';
		private static const yPosition:int = 3;
		private static const xPosition:int = 3;
		private var label:Label = new Label();
		private var cid:String;
		private var courseArray:Array;
		private var arrTask:Array = new Array();
		private var arrFolder:Array = new Array();
		private var arrFile:Array = new Array();
		private var labelOpen:opFold = new opFold();
		private var labelClose:closeFolder = new closeFolder();
		public function MYCourse(value:Array) {
			super();
			var name:String = value[0].link.substring(0,value[0].link.indexOf('/'));
			startInit(name);
			addTask(value);
		}
		private function startInit(name:String):void{
			super.addChild(labelClose);
			super.addChild(label);
			label.text = name;
			label.fieldSize = 12;
			label.x = labelClose.width + 5;
			labelClose.addEventListener(MouseEvent.CLICK, OPEN_COURSE);
		}
		
		
		
		private function addTask(value:Array):void{
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				addTaskTree(value[i].nid, value[i].tid, value[i].link.substring(value[i].link.indexOf('/')+1, value[i].link.length), value[i].name, value[i].cid);
			}
		}
		private function addTaskTree(nid:String, tid:String, link:String, name:String, cid:String):void{
			var TID:int
			//	Определяем имя каталога
			var nameFolder:String;
			if(link.indexOf('/')!=-1) {
				nameFolder = link.substring(0, link.indexOf('/'));
				
				//	запоминаем индекс массива с которым надо будет работать
				TID = arrTask.length;
				//	добавляем в массив заданий новое задание
				arrTask.push(new TaskFile(name, tid, cid, nid));
				//	слушаем события связанные с деревом заданий
				/*arrTask[TID].addEventListener(Events.FILE_CLICK, ARR_FILE_CLICK);
				arrTask[TID].addEventListener(Events.FILE_SELECT, ARR_FILE_SELECT);
				arrTask[TID].addEventListener(Events.FILE_DESELECT, ARR_FILE_DESELECT);
				arrTask[TID].addEventListener(Events.FILE_FOCUS_OUT, ARR_FILE_FOCUS_OUT);*/
				//	Проверяем существует ли каталог курса задания которое пришло
				var curFolder:TaskFolder = checkFolder(nameFolder);
				//	Если не существует
				if(curFolder==null){
					//	запоминаем номер массива каталогов курсов, с которым будем работать
					var ID:int = arrFolder.length;
					//	добавление в массив нового каталога
					arrFolder.push(new TaskFolder(nameFolder));
					//	установка в каталог задания и пути к заданию
					arrFolder[ID].setFile(link.substring(link.indexOf('/')+1, link.length), arrTask[TID]);
					//	помещение каталога в список отображения
					//super.addChild(arrFolder[ID]);
					//	позицианирование каталога в зависимости от его порядкового номера
					if(ID!=0) arrFolder[ID].y = arrFolder[ID-1].y+arrFolder[ID-1].height;
					else arrFolder[ID].y = yPosition + 18;
					arrFolder[ID].x = xPosition + 18;
					//	добавление слушателя нажатия левой кнопки мыши над каталогом
					arrFolder[ID].addEventListener(TaskFolder.FOLDER_UPDATE, FOLDER_MOUSE_DOWN);
				//	Если такой каталог курса существует
				}else{
					//	Устанавливаем пришедшее задание в каталог
					curFolder.setFile(link.substring(link.indexOf('/')+1, link.length), arrTask[TID]);
				}
			}else {
				nameFolder = link;
				//	запоминаем индекс массива с которым надо будет работать
				TID = arrTask.length;
				//	добавляем в массив заданий новое задание
				arrTask.push(new TaskFile(name, tid, cid, nid));
				arrFile.push(arrTask[TID]);
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
				else arrFolder[i].y = yPosition + 18;
			}
			leng = arrFile.length;
			if(leng == 0) {
				updatePanel();
				return;
			}
			if(arrFolder.length==0) arrFile[0].y = yPosition + 18;
			else arrFile[0].y = arrFolder[arrFolder.length-1].y+arrFolder[arrFolder.length-1].height;
			arrFile[0].x = xPosition + 18;
			for(i=1;i<leng;i++){
				arrFile[i].y = arrFile[i-1].y+arrFile[i-1].height;
				arrFile[i].x = xPosition + 18;
			}
			updatePanel();
			//treePanel.updatePanel();
		}
		
		private function OPEN_COURSE(event:MouseEvent):void{
			super.removeChild(labelClose);
			labelClose.removeEventListener(MouseEvent.CLICK, OPEN_COURSE);
			var i:int;
			var l:int;
			l = arrFolder.length;
			for(i=0;i<l;i++){
				super.addChild(arrFolder[i]);
				if(i!=0) arrFolder[i].y = arrFolder[i-1].y+arrFolder[i-1].height;
				else arrFolder[i].y = yPosition + 18;
			}
			
			l = arrFile.length;
			if(l != 0) {
				super.addChild(arrFile[0]);
				if(arrFolder.length==0) arrFile[0].y = yPosition + 18;
				else arrFile[0].y = arrFolder[arrFolder.length-1].y+arrFolder[arrFolder.length-1].height;
				arrFile[0].x = xPosition + 18;
				for(i=1;i<l;i++){
					super.addChild(arrFile[i]);
					arrFile[i].y = arrFile[i-1].y+arrFile[i-1].height;
					arrFile[i].x = xPosition + 18;
				}
			}
			
			super.addChild(labelOpen);
			labelOpen.addEventListener(MouseEvent.CLICK, CLOSE_COURSE);
			updatePanel();
		}
		private function CLOSE_COURSE(event:MouseEvent):void{
			super.removeChild(labelOpen);
			labelOpen.removeEventListener(MouseEvent.CLICK, CLOSE_COURSE);
			var i:int;
			var l:int;
			l = arrFolder.length;
			for(i=0;i<l;i++){
				super.removeChild(arrFolder[i]);
			}
			l = arrFile.length;
			for(i=0;i<l;i++){
				super.removeChild(arrFile[i]);
			}
			super.addChild(labelClose);
			labelClose.addEventListener(MouseEvent.CLICK, OPEN_COURSE);
			updatePanel();
		}
		private function updatePanel():void{
			super.dispatchEvent(new Event(UPDATE_PANEL));
		}
		
		
		
		public function get myTasks():Array{
			var outArray:Array = new Array();
			var arr:Array;
			var i:int;
			var l:int;
			var j:int;
			var ID:int;
			l = arrFolder.length;
			for(i=0;i<l;i++){
				arr = arrFolder[i].treeTask;
				for(j=0;j<arr.length;j++){
					ID = outArray.length;
					outArray.push(arr[j]);
					outArray[ID].link = label.text + '/' + outArray[ID].link;
				}
			}
			l = arrFile.length;
			var fileObject:Object;
			for(i=0;i<l;i++){
				fileObject = arrFile[i].fileLink;
				ID = outArray.length;
				outArray.push({link:fileObject.name, name:fileObject.name, nid:fileObject.nid, tid:fileObject.tid, cid:fileObject.cid});
				outArray[ID].link = label.text + '/' + outArray[ID].link;
			}
			return outArray;
		}
	}
	
}
