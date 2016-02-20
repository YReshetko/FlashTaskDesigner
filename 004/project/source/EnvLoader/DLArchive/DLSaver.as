package source.EnvLoader.DLArchive {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvEvents.Events;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class DLSaver extends Sprite{
		private var dlForm:DLForm;
		private var currentTask:String;
		private var currentContent:Array;
		private var difficultContent:Array;
		private var playerW:Number;
		private var playerH:Number;
		private var currentID:int;
		private var contentID:int;
		
		private var file:File = new File();
		private var currentFile:File;
		
		private var stream:FileStream;
		private var zipString:String;
		public function DLSaver(container:Sprite, width:Number, height:Number) {
			super();
			super.visible = false;
			container.addChild(super);
			Figure.insertRect(super, width, height);
			dlForm = new DLForm();
			super.addChild(dlForm);
			dlForm.x = (width - dlForm.width)/2
			dlForm.y = (height - dlForm.height)/2 - (height - dlForm.height)/4
			
			
		}
		public function isOpen():Boolean{
			return super.visible;
		}
		public function close(e:Event = null):void{
			super.visible = false;
			dlForm.dec();
			currentTask = '';
			currentContent = null;
			dlForm.removeEventListener(Events.SAVE_TASK, SAVE_ARCHIVE);
			dlForm.removeEventListener(Events.SAVE_TASK, SAVE_DIFFICULT);
			dlForm.removeEventListener(Events.WINDOW_CLOSE, close);
		}
		public function open(task:String, content:Array):void{
			zipString = '';
			dlForm.addEventListener(Events.SAVE_TASK, SAVE_ARCHIVE);
			dlForm.addEventListener(Events.WINDOW_CLOSE, close);
			currentTask = task;
			currentContent = content;
			var taskXml:XMLList = new XMLList(task);
			var sample:XML;
			var isTest:Boolean = taskXml.TEST.toString()=='true';
			var numTask:int = 0;
			var numMnim:int = 0;
			if(isTest){
				dlForm.type = 'тест';
				if(taskXml.CHECK.toString() == 'true') dlForm.checkBut = 'есть';
				else dlForm.checkBut = 'нет';
				for each(sample in taskXml.TASK){
					++numTask;
					if(sample.MNIMOE.toString()=='true') ++numMnim;
				}
				if(taskXml.DELIVERY.toString()=='true') dlForm.numPoint = 1;
				else {
					if(taskXml.NOMORE.toString()!=''){
						dlForm.numPoint = parseInt(taskXml.NOMORE.toString());
					}else{
						if(taskXml.EQUIVALENT.toString()!=''){
							var numPart:int = Math.floor(numTask/parseInt(taskXml.EQUIVALENT.toString()));
							var lastPart:int = numTask-(numPart*parseInt(taskXml.EQUIVALENT.toString()));
							if(lastPart>0) ++numPart;
							dlForm.numPoint = numPart;
						}else dlForm.numPoint = numTask - numMnim;
					}
				}
				if(dlForm.numPoint==1 && isTest && taskXml.DELIVERY.toString()!='true'){
					taskXml.TEST = 'false';
					currentTask = taskXml.toString();
				}
			}else{
				if(taskXml.CHECK.toString() == 'true') dlForm.checkBut = 'есть';
				else dlForm.checkBut = 'нет';
				for each(sample in taskXml.TASK){
					if(sample.@level.toString() == '1'){
						++numTask;
						if(sample.MNIMOE.toString()=='true') ++numMnim;
					}
				}
				if(numTask==1) dlForm.type = 'обучение';
				else dlForm.type = 'гибрид';
				dlForm.numPoint = numTask - numMnim;
			}
			if(taskXml.WIDTH.toString() != '' && taskXml.WIDTH.toString() != 'NaN')playerW = parseFloat(taskXml.WIDTH);
			else playerW = 742;
			if(taskXml.HEIGHT.toString() != '' && taskXml.HEIGHT.toString() != 'NaN')playerH = parseFloat(taskXml.HEIGHT);
			else playerH = 530;
			
			dlForm.update();
			super.visible = true;
		}
		
		
		
		private function SAVE_ARCHIVE(e:Event):void{
			file.browseForDirectory('Выберите каталог для сохранения архива');
			file.addEventListener(Event.SELECT, FOLDER_SELECT);
			file.addEventListener(Event.CANCEL, FOLDER_CLOSE);
		}
		private function FOLDER_SELECT(e:Event):void{
			FOLDER_CLOSE();
			currentFile = e.target as File
			currentFile = currentFile.resolvePath(currentFile.nativePath + '/' + dlForm.numFolder.toString());
			currentFile.createDirectory();
			currentFile = currentFile.resolvePath(currentFile.nativePath + '/task.asp');
			
			var asp:String = FormatFiles.getASPFile(playerW, playerH);
			var cfg:String = FormatFiles.getCFGFile();
			var out:String = FormatFiles.getOUTFile(dlForm.numPoint);
			var xml:String = FormatFiles.getXMLFile(dlForm.rname, dlForm.ename, dlForm.author, dlForm.group, dlForm.date, dlForm.numPoint);
			saveTextFile(asp, 'task.asp');
			saveTextFile(cfg, 'task.cfg');
			saveTextFile(out, 'task.out');
			saveTextFile(xml, 'task.xml');
			
			currentFile = currentFile.resolvePath(currentFile.parent.nativePath + '/webfiles');
			currentFile.createDirectory();
			currentFile = currentFile.resolvePath(currentFile.nativePath + '/Position.txt');
			saveTextFile(setAuthor(currentTask), 'Position.txt', 'utf');
			zipString = FormatFiles.getBatForZip(dlForm.winrar, currentFile.parent.nativePath.toString(), 'Position.txt', 'Position');
			
			if(currentContent.length!=0){
				currentID = 0;
				startSaveFile();
			}else{
				complateArchive();
			}
		}
		private function startSaveFile():void{
			currentFile = currentFile.resolvePath(currentFile.parent.nativePath+'/'+currentContent[currentID][0]);
			stream = new FileStream();
			stream.open(currentFile, FileMode.WRITE);
			stream.writeBytes(currentContent[currentID][1]);
			FILE_STREAM_COMPLATE(null);
		}
		private function FILE_STREAM_COMPLATE(e:Event):void{
			stream.close();
			if(currentID < currentContent.length-1){
				++currentID;
				startSaveFile();
			}else{
				complateArchive();
			}
			
		}
		private function complateArchive(value:Boolean = false):void{
			var bat:String;
			if(value){
				currentFile = currentFile.resolvePath(currentFile.parent.nativePath+'/run.bat');
				bat = FormatFiles.getDiffBATFile(dlForm.winrar, currentFile.parent.nativePath.toString(), dlForm.rname, dlForm.numFolder.toString(), zipString);
				saveTextFile(bat, '['+dlForm.numFolder.toString()+'] RUN.bat', 'dos');
			}else{
				currentFile = currentFile.resolvePath(currentFile.parent.parent.parent.nativePath+'/run.bat');
				bat = FormatFiles.getBATFile(dlForm.winrar, currentFile.parent.nativePath.toString(), dlForm.numFolder.toString(), zipString);
				saveTextFile(bat, '['+dlForm.numFolder.toString()+'] RUN.bat', 'dos');
			}
			try{
				currentFile.openWithDefaultApplication();
			}catch(e:Error){
				trace(this + ': ERROR ACCESS BAT FILE');
			}
			dlForm.inc();
			this.close();
		}
		
		private function saveTextFile(text:String, name:String, type:String = 'win'):void{
			currentFile = currentFile.resolvePath(currentFile.parent.nativePath + '/'+name);
			stream = new FileStream();
			stream.open(currentFile, FileMode.WRITE);
			switch(type){
				case 'win':
				stream.writeMultiByte(text, 'windows-1251');
				break;
				case 'utf':
				stream.writeUTFBytes(text);
				break;
				case 'dos':
				stream.writeMultiByte(text, 'cp866');
				break;
			}
			stream.close();
		}
		
		private function FOLDER_CLOSE(e:Event = null):void{
			file.removeEventListener(Event.SELECT, FOLDER_SELECT);
			file.removeEventListener(Event.CANCEL, FOLDER_CLOSE);
		}
		
		
		
		
		
		
		
		
		
		
		public function set difficultArchive(value:Array):void{
			dlForm.addEventListener(Events.SAVE_TASK, SAVE_DIFFICULT);
			dlForm.addEventListener(Events.WINDOW_CLOSE, close);
			difficultContent = value;
			currentID = -1;
			super.visible = true;
			dlForm.type = 'отдельные';
			dlForm.checkBut = 'нет';
			if(difficultContent[0][0].WIDTH.toString() != '' && difficultContent[0][0].WIDTH.toString() != 'NaN')playerW = parseFloat(difficultContent[0][0].WIDTH);
			else playerW = 742;
			if(difficultContent[0][0].HEIGHT.toString() != '' && difficultContent[0][0].HEIGHT.toString() != 'NaN')playerH = parseFloat(difficultContent[0][0].HEIGHT);
			else playerH = 530;
			dlForm.update();
			
			/*var i,l:int;
			l = difficultContent.length;
			for(i=0;i<l;i++){
				trace(this + '-------------------------------------');
				trace(this + ': TASK = ' + difficultContent[i][0]);
			}*/
		}
		private function SAVE_DIFFICULT(e:Event):void{
			file.browseForDirectory('Выберите каталог для сохранения архива');
			file.addEventListener(Event.SELECT, FOLDER_DIF_SELECT);
			file.addEventListener(Event.CANCEL, FOLDER_DIF_CLOSE);
		}
		private function FOLDER_DIF_SELECT(e:Event):void{
			FOLDER_DIF_CLOSE();
			currentFile = e.target as File
			currentFile = currentFile.resolvePath(currentFile.nativePath + '/' + dlForm.rname);
			currentFile.createDirectory();
			zipString = '';
			startDiffSaver();
		}
		private function startDiffSaver():void{
			++currentID;
			if(currentID == difficultContent.length){
				//	Обработка окончания сохранения каталгов и формирование архива
				complateArchive(true);
				trace(this + ': MISSION COMPLATED');
			}else{
				currentFile = currentFile.resolvePath(currentFile.nativePath + '/' + currentID.toString());
				currentFile.createDirectory();
				currentFile = currentFile.resolvePath(currentFile.nativePath + '/task.asp');
				var asp:String = FormatFiles.getASPFile(playerW, playerH);
				var cfg:String = FormatFiles.getCFGFile();
				var out:String = FormatFiles.getOUTFile(1);
				var xml:String = FormatFiles.getXMLFile(getNameTask(difficultContent[currentID][0]), '', dlForm.author, dlForm.group, dlForm.date, 1);
				saveTextFile(asp, 'task.asp');
				saveTextFile(cfg, 'task.cfg');
				saveTextFile(out, 'task.out');
				saveTextFile(xml, 'task.xml');
				currentFile = currentFile.resolvePath(currentFile.parent.nativePath + '/webfiles');
				currentFile.createDirectory();
				currentFile = currentFile.resolvePath(currentFile.nativePath + '/Position.txt');
				saveTextFile(setAuthor(difficultContent[currentID][0]), 'Position.txt', 'utf');
				zipString += FormatFiles.getBatForZip(dlForm.winrar, currentFile.parent.nativePath.toString(), 'Position.txt', 'Position');
				zipString += '\r\n';
				if(difficultContent[currentID][1].length!=0){
					contentID = 0;
					startSaveTaskContent();
				}else{
					currentFile = currentFile.resolvePath(currentFile.parent.parent.parent.nativePath);
					startDiffSaver();
				}
			}
		}
		private function startSaveTaskContent():void{
			currentFile = currentFile.resolvePath(currentFile.parent.nativePath+'/'+difficultContent[currentID][1][contentID][0]);
			stream = new FileStream();
			stream.open(currentFile, FileMode.WRITE);
			stream.writeBytes(difficultContent[currentID][1][contentID][1]);
			stream.close();
			if(contentID < difficultContent[currentID][1].length-1){
				++contentID;
				startSaveTaskContent();
			}else{
				currentFile = currentFile.resolvePath(currentFile.parent.parent.parent.nativePath);
				startDiffSaver();
			}
		}
		private function FOLDER_DIF_CLOSE(e:Event = null):void{
			file.removeEventListener(Event.SELECT, FOLDER_DIF_SELECT);
			file.removeEventListener(Event.CANCEL, FOLDER_DIF_CLOSE);
		}
		
		
		private function setAuthor(value:String):String{
			var taskXML:XMLList = new XMLList(value);
			taskXML.@author = dlForm.author;
			taskXML.@group = dlForm.group;
			taskXML.@date = dlForm.date;
			return taskXML.toString();
		}
		private function getNameTask(value:String):String{
			var taskXML:XMLList = new XMLList(value);
			var outName:String = 'Задание';
			if(taskXML.TASK.NAME.toString()!='') outName = taskXML.TASK.NAME.toString();
			return outName;
		} 
	}
	
}
