package source.utils.TaskLoader {
	import Preloader;
	import Converter;
	import source.utils.GetOutFileName;
	import flash.events.Event;
	import source.PlayerLib.Library;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;

	public class LoadTask extends EventDispatcher{
		public static var TASK_LOAD_COMPLATE:String = 'onTaskLoadComplate';
		
		private static const taskFileName:String = 'Position.txt';
		private static const imageFileConfig:String = 'Config.txt';
		
		private var libContent:Library;
		private var flashFile:String;
		private var baseImageURL:String;
		private var contentObject:Object;
		private var loader:Preloader;
		private var renameArr:Array;
		private var tableContent:Array;
		private var xmlTask:XMLList;
		private var distributArr:Array;
		private var currentPack:int;
		public function LoadTask(lib:Library, container:Sprite, flFile:String, dbUrl:String) {
			super();
			
			libContent = lib;
			libContent.clearLib();
			
			flashFile = flFile;
			baseImageURL = dbUrl;
			loadTask(container);
		}
		public function loadTask(cont:Sprite):void{
			loader = new Preloader();
			loader.stageContainer = cont;
			loader.addEventListener(Preloader.TEXT_LOAD_COMPLATE, TASK_LOAD);
			loader.loadText(flashFile+taskFileName);
		}
		private function TASK_LOAD(e:Event):void{
			loader.removeEventListener(Preloader.TEXT_LOAD_COMPLATE, TASK_LOAD);
			setTask(loader.file);
		}
		public function setTask(task:String):void{
			this.task = Converter.getXMLTask(task);
			contentObject = GetOutFileName.getImagesName(this.task);
			if(contentObject.dbImage.length!=0) {
				loadImgeFromBD();
				return;
			}
			//loadImgeFromWebfiles();
			createTableContent();
		}
		private function loadImgeFromBD():void{
			loader.addEventListener(Preloader.TEXT_LOAD_COMPLATE, CONFIG_LOAD);
			loader.addEventListener(Preloader.TEXT_LOAD_ERROR, CONFIG_ERROR);
			loader.loadText(baseImageURL+imageFileConfig);
		}
		private function CONFIG_ERROR(e:Event):void{
			loader.removeEventListener(Preloader.TEXT_LOAD_COMPLATE, CONFIG_LOAD);
			loader.removeEventListener(Preloader.TEXT_LOAD_ERROR, CONFIG_ERROR);
			//loadImgeFromWebfiles();
		}
		private function CONFIG_LOAD(e:Event):void{
			loader.removeEventListener(Preloader.TEXT_LOAD_COMPLATE, CONFIG_LOAD);
			loader.removeEventListener(Preloader.TEXT_LOAD_ERROR, CONFIG_ERROR);
			renameArr = GetOutFileName.getRealyNameFromConfig(loader.file, contentObject.dbImage);
			var loadArr:Array = new Array();
			//for(var i:int = 0; i<renameArr.length; i++){
				//loadArr.push(renameArr[i][1]);
				//trace(this + ': DB IMAGE[' + i + '] = ' + renameArr[i])
				
			//}
			//trace(this + ': baseImageURL = ' + baseImageURL);
			//trace(this + ': Webfiles CONTENT = ' + contentObject.webImage)
			//loader.addEventListener(Preloader.IMAGES_LOAD_COMPLATE, DB_IMAGES_LOADED);
			//loader.loadContent(loadArr, baseImageURL);
			createTableContent();
		}
		
		
		private function createTableContent():void{
			tableContent = new Array();
			var i:int;
			var j:int;
			var l:int;
			var path:String;
			if(contentObject.dbImage.length!=0){
				l = renameArr.length;
				for(i=0;i<l;i++){
					path = baseImageURL+renameArr[i][1];
					contentInTable = {'nameInFile':renameArr[i][0], 'realName':renameArr[i][1], 'path':path};
				}
			}
			if(contentObject.webImage.length!=0){
				l = contentObject.webImage.length;
				for(i=0;i<l;i++){
					path = flashFile+contentObject.webImage[i];
					contentInTable = {'nameInFile':contentObject.webImage[i], 'realName':contentObject.webImage[i], 'path':path};
				}
			}
			if(contentObject.dbSwf.length!=0){
				l = contentObject.dbSwf.length
				for(i=0;i<l;i++){
					path = baseImageURL+'Modules/'+contentObject.dbSwf[i];
					contentInTable = {'nameInFile':contentObject.dbSwf[i], 'realName':contentObject.dbSwf[i], 'path':path};
				}
			}
			/*l = tableContent.length;
			for(i=0;i<l;i++){
				trace(this + ': tableContent[' + i + '] = ' + tableContent[i].nameInFile + '; ' + tableContent[i].realName + '; ' + tableContent[i].path);
			}*/
			
			
			var taskXML:String;
			var ID:int = -1;
			
			var mediateObj:Object;
			
			distributArr = new Array();
			
			for each(var sample:XML in xmlTask.TASK){
				taskXML = sample.toString();
				++ID;
				distributArr[ID] = new Array();
				for(i=0;i<tableContent.length;i++){
					if(taskXML.indexOf(tableContent[i].nameInFile)!=-1){
						mediateObj = tableContent[i];
						tableContent.splice(i,1);
						--i;
						distributArr[ID].push(mediateObj);
					}
				}
			}
			
			
			/*for(i=0;i<distributArr.length;i++){
				trace(this + ': TASK ' + i + ' CONTENT');
				for(j=0;j<distributArr[i].length;j++){
					trace(this + ': TASK[' + i + '] = ' + distributArr[i][j].nameInFile + '; ' + distributArr[i][j].realName + '; ' + distributArr[i][j].path);
				}
			}*/
			currentPack = -1;
			loadContent();
		}
		
		private function set contentInTable(inObject:Object):void{
			var i:int;
			var l:int;
			l = tableContent.length;
			for(i=0;i<l;i++){
				if(tableContent[i].nameInFile == inObject.nameInFile) return;
			}
			tableContent.push(inObject);
		}
		
		private function loadContent():void{
			++currentPack;
			var currentContent:Array = new Array();
			var i:int;
			var l:int;
			if(currentPack == distributArr.length){
				trace(this + ': LOAD CONTENT COMPLATE');
			}else{
				if(distributArr[currentPack].length == 0) {
					super.dispatchEvent(new Event(TASK_LOAD_COMPLATE));
					loadContent();
					return;
				}
				loader.addEventListener(Preloader.IMAGES_LOAD_COMPLATE, CONTENT_LOAD_COMPLATE);
				l = distributArr[currentPack].length;
				for(i=0;i<l;i++){
					currentContent.push(distributArr[currentPack][i].path);
				}
				loader.loadContent(currentContent);
			}
		}
		private function CONTENT_LOAD_COMPLATE(event:Event):void{
			loader.removeEventListener(Preloader.IMAGES_LOAD_COMPLATE, CONTENT_LOAD_COMPLATE);
			var inObject:Object = loader.content;
			var oldNames:Array = inObject.arrName;
			var oldByteArr:Array = inObject.arrByteArray;
			var newNames:Array = new Array();
			var newByteArr:Array = new Array();
			var i:int;
			var j:int;
			for(i=0;i<oldNames.length;i++){
				for(j=0;j<distributArr[currentPack].length;j++){
					if(oldNames[i] == distributArr[currentPack][j].path){
						newNames.push(distributArr[currentPack][j].nameInFile);
						newByteArr.push(oldByteArr[i]);
						break;
					}
				}
			}
			libContent.setArrFile(newByteArr, newNames);
			super.dispatchEvent(new Event(TASK_LOAD_COMPLATE));
			loadContent();
		}
		
		
		
		
		
		
		
		/*private function DB_IMAGES_LOADED(e:Event){
			loader.removeEventListener(Preloader.IMAGES_LOAD_COMPLATE, DB_IMAGES_LOADED);
			var inObject:Object = loader.content;
			var oldNames:Array = inObject.arrName;
			var newNames:Array = new Array();
			var i,j:int;
			for(i=0;i<oldNames.length;i++){
				for(j=0;j<renameArr.length;j++){
					if(oldNames[i] == renameArr[j][1]){
						newNames.push(renameArr[j][0]);
						break;
					}
				}
			}
			libContent.setArrFile(inObject.arrByteArray, newNames);
			loadImgeFromWebfiles();
		}
		private function loadImgeFromWebfiles(){
			//trace(this + ': LOAD FROM WEBFILES = ' + contentObject.webImage);
			if(contentObject.webImage.length>0){
				loader.addEventListener(Preloader.IMAGES_LOAD_COMPLATE, WEB_IMAGES_LOADED);
				loader.loadContent(contentObject.webImage, flashFile);
				return;
			}
			loadSWFFromDL();
		}
		private function WEB_IMAGES_LOADED(e:Event){
			//trace(this + ': LOADED CONTENT = ' + loader.content.arrByteArray, loader.content.arrName)
			loader.removeEventListener(Preloader.IMAGES_LOAD_COMPLATE, WEB_IMAGES_LOADED);
			libContent.setArrFile(loader.content.arrByteArray, loader.content.arrName);
			loadSWFFromDL();
		}
		
		
		private function loadSWFFromDL():void{
			trace(this + ': LOAD FROM DB = ' + contentObject.dbSwf);
			if(contentObject.dbSwf.length>0){
				loader.addEventListener(Preloader.IMAGES_LOAD_COMPLATE, DB_SWF_LOADED);
				loader.loadContent(contentObject.dbSwf, baseImageURL+'/Modules/');
				return
			}
			dispatchComplate();
		}
		private function DB_SWF_LOADED(e:Event){
			loader.removeEventListener(Preloader.IMAGES_LOAD_COMPLATE, DB_SWF_LOADED);
			libContent.setArrFile(loader.content.arrByteArray, loader.content.arrName);
			//trace(this + ': LOADED CONTENT = ' + loader.content.arrByteArray, loader.content.arrName)
			dispatchComplate();
		}
		private function dispatchComplate(){
			trace(this + ': LOAD COMPLATE')
			super.dispatchEvent(new Event(TASK_LOAD_COMPLATE));
		}*/
		public function set task(value:XMLList):void{
			xmlTask = value;
		}
		public function get task():XMLList{
			return xmlTask;
		}
	}
	
}
