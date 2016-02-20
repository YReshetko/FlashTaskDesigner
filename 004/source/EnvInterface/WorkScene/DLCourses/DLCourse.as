package source.EnvInterface.WorkScene.DLCourses {
	import flash.display.Sprite;
	import source.Components.Label;
	import flash.events.MouseEvent;
	import source.WindowInterface.MainTaskDownloader;
	import source.utils.DataBaseUpdate.DLConnection;
	import flash.events.Event;
	import source.EnvInterface.WorkScene.TskTree.TaskFolder;
	import source.EnvInterface.WorkScene.TskTree.TaskFile;
	import source.EnvEvents.Events;
	
	public class DLCourse extends Sprite{
		public static var UPDATE_PANEL:String = 'onUpdatePanel';
		public static var NEW_COURSE:String = 'onSaveNewCourse';
		//	Стартовая позиция дерева задач
		private static const yPosition:int = 3;
		private static const xPosition:int = 3;
		private var downloadLabel:DownloaderLbl = new DownloaderLbl();
		private var label:Label = new Label();
		private var cid:String;
		private var courseArray:Array;
		private var indicate:LoginIndicate = new LoginIndicate();
		private var arrTask:Array = new Array();
		private var arrFolder:Array = new Array();
		private var labelOpen:opFold = new opFold();
		private var labelClose:closeFolder = new closeFolder();
		public function DLCourse(cid:String, name:String) {
			super();
			this.cid = cid;
			startInit(name);
		}
		private function startInit(name:String):void{
			super.addChild(downloadLabel);
			super.addChild(label);
			downloadLabel.width = downloadLabel.height = 18;
			label.text = name;
			label.fieldSize = 12;
			label.x = downloadLabel.width + 5;
			downloadLabel.addEventListener(MouseEvent.CLICK, DOWNLOAD_COURSE);
		}
		private function DOWNLOAD_COURSE(event:MouseEvent):void{
			downloadLabel.removeEventListener(MouseEvent.CLICK, DOWNLOAD_COURSE);
			super.removeChild(downloadLabel);
			super.addChild(indicate);
			indicate.width = indicate.height = 18;
			MainTaskDownloader.dlConnection.addEventListener(DLConnection.CONNECTION_COMPLATE, COURSE_LOAD);
			MainTaskDownloader.dlConnection.getTreeCourse(cid);
		}
		private function COURSE_LOAD(event:Event):void{
			MainTaskDownloader.dlConnection.removeEventListener(DLConnection.CONNECTION_COMPLATE, COURSE_LOAD);
			var inObject:Object = MainTaskDownloader.dlConnection.data;
			var outString:String;
			var inArray:Array = new Array();
			for(var value:Object in inObject.data){
				inArray.push({key:value, title:inObject.data[value].title, nid:inObject.data[value].nid, name:inObject.data[value].name, tid:inObject.data[value].tid, deep:inObject.data[value].deep});
			}
			inArray.sortOn('key', Array.NUMERIC);
			collectLinks(inArray);
		}
		private function collectLinks(value:Array):void{
			var i:int;
			var j:int;
			var l:int = value.length;
			courseArray = new Array();
			var remLink:String;
			var remDeep:int;
			var remName:String;
			for(i=0;i<l;i++){
				if(value[i].name != null){
					remName = value[i].name;
					remLink = value[i].name;
					remDeep = parseInt(value[i].deep);
					--remDeep;
					j=i-1;
					while(remDeep>0&&j>=0){
						if(parseInt(value[j].deep) == remDeep && value[j].name == null){
							--remDeep;
							remLink = value[j].title + '/' +remLink;
						}
						--j;
					}
					//remLink = remLink.substring(0, remLink.length-1);
					courseArray.push({link:remLink, name:remName, nid:value[i].nid, tid:value[i].tid});
				}
			}
			for(i=0;i<courseArray.length;i++){
				//trace(this + ': nid = ' + courseArray[i].nid + ', tid = ' + courseArray[i].tid + ', link = ' + courseArray[i].link + ', name = ' + courseArray[i].name);
				addTaskTree(courseArray[i].nid, courseArray[i].tid, courseArray[i].link, courseArray[i].name);
			}
			
			super.removeChild(indicate);
			super.addChild(labelClose);
			labelClose.addEventListener(MouseEvent.CLICK, OPEN_COURSE);
		}
		
		private function addTaskTree(nid:String, tid:String, link:String, name:String):void{
			//	Определяем имя каталога
			var nameFolder:String;
			if(link.indexOf('/')!=-1) nameFolder = link.substring(0, link.indexOf('/'));
			else nameFolder = link;
			//	запоминаем индекс массива с которым надо будет работать
			var TID:int = arrTask.length;
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
				arrFolder[ID].addEventListener(TaskFolder.GET_NEW_COURSE, SAVE_NEW_COURSE);
			//	Если такой каталог курса существует
			}else{
				//	Устанавливаем пришедшее задание в каталог
				curFolder.setFile(link.substring(link.indexOf('/')+1, link.length), arrTask[TID]);
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
			super.addChild(labelClose);
			labelClose.addEventListener(MouseEvent.CLICK, OPEN_COURSE);
			updatePanel();
		}
		private function updatePanel():void{
			super.dispatchEvent(new Event(UPDATE_PANEL));
		}
		
		
		private function SAVE_NEW_COURSE(event:Event):void{
			var arr:Array = event.target.addedbleCourse;
			var i:int;
			var l:int;
			l = arr.length;
			for(i=0;i<l;i++){
				//trace(this + ': arr[' + i + '] = {link:' + arr[i].link + ', name:' + arr[i].name + ', tid:' + arr[i].tid + ', cid:' + arr[i].cid + ', nid:' + arr[i].nid + '};');
			}
			newCourse = event.target.addedbleCourse;
			super.dispatchEvent(new Event(NEW_COURSE));
		}
		private var remCourse:Array;
		public function set newCourse(value:Array):void{
			remCourse = value;
		}
		public function get newCourse():Array{
			return remCourse;
		}
	}
	
}
