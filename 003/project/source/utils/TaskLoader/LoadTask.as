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
		private var xmlTask:XMLList;
		public function LoadTask(lib:Library, container:Sprite, flFile:String, dbUrl:String) {
			super();
			
			libContent = lib;
			libContent.clearLib();
			
			flashFile = flFile;
			baseImageURL = dbUrl;
			loadTask(container);
		}
		public function loadTask(cont:Sprite){
			loader = new Preloader();
			loader.stageContainer = cont;
			loader.addEventListener(Preloader.TEXT_LOAD_COMPLATE, TASK_LOAD);
			loader.loadText(flashFile+taskFileName);
		}
		private function TASK_LOAD(e:Event){
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
			loadImgeFromWebfiles();
		}
		private function loadImgeFromBD(){
			loader.addEventListener(Preloader.TEXT_LOAD_COMPLATE, CONFIG_LOAD);
			loader.addEventListener(Preloader.TEXT_LOAD_ERROR, CONFIG_ERROR);
			loader.loadText(baseImageURL+imageFileConfig);
		}
		private function CONFIG_ERROR(e:Event){
			loader.removeEventListener(Preloader.TEXT_LOAD_COMPLATE, CONFIG_LOAD);
			loader.removeEventListener(Preloader.TEXT_LOAD_ERROR, CONFIG_ERROR);
			loadImgeFromWebfiles();
		}
		private function CONFIG_LOAD(e:Event){
			loader.removeEventListener(Preloader.TEXT_LOAD_COMPLATE, CONFIG_LOAD);
			loader.removeEventListener(Preloader.TEXT_LOAD_ERROR, CONFIG_ERROR);
			renameArr = GetOutFileName.getRealyNameFromConfig(loader.file, contentObject.dbImage);
			var loadArr:Array = new Array();
			for(var i:int = 0; i<renameArr.length; i++){
				loadArr.push(renameArr[i][1]);
			}
			loader.addEventListener(Preloader.IMAGES_LOAD_COMPLATE, DB_IMAGES_LOADED);
			loader.loadImages(loadArr, baseImageURL);
		}
		private function DB_IMAGES_LOADED(e:Event){
			loader.removeEventListener(Preloader.IMAGES_LOAD_COMPLATE, DB_IMAGES_LOADED);
			var inObject:Object = loader.image;
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
			libContent.setArrFile(inObject.arrBitmap, newNames);
			loadImgeFromWebfiles();
		}
		private function loadImgeFromWebfiles(){
			if(contentObject.webImage.length>0){
				loader.addEventListener(Preloader.IMAGES_LOAD_COMPLATE, WEB_IMAGES_LOADED);
				loader.loadImages(contentObject.webImage, flashFile);
				return;
			}
			loadSWFFromWebfiles();
		}
		private function WEB_IMAGES_LOADED(e:Event){
			loader.removeEventListener(Preloader.IMAGES_LOAD_COMPLATE, WEB_IMAGES_LOADED);
			libContent.setArrFile(loader.image.arrBitmap, loader.image.arrName);
			loadSWFFromWebfiles();
		}
		private function loadSWFFromWebfiles(){
			if(contentObject.webSwf.length>0){
				loader.addEventListener(Preloader.SWF_LOAD_COMPLATE, WEB_SWF_LOADED);
				loader.loadSWF(contentObject.webSwf, flashFile);
				return
			}
			dispatchComplate()
		}
		private function WEB_SWF_LOADED(e:Event){
			loader.removeEventListener(Preloader.SWF_LOAD_COMPLATE, WEB_SWF_LOADED);
			libContent.setArrFile(loader.swf.arrContent, loader.swf.arrName);
			dispatchComplate()
		}
		private function dispatchComplate(){
			super.dispatchEvent(new Event(TASK_LOAD_COMPLATE));
		}
		public function set task(value:XMLList):void{
			xmlTask = value;
		}
		public function get task():XMLList{
			return xmlTask;
		}
	}
	
}
