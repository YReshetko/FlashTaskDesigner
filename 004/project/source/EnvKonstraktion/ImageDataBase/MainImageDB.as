package source.EnvKonstraktion.ImageDataBase {
	import source.EnvLoader.LoadFiles;
	import flash.events.EventDispatcher;
	import source.EnvEvents.Events;
	import flash.events.Event;
	import flash.display.Sprite;
	import source.EnvInterface.EnvPanel.Panel;
	import source.MainEnvelope;
	import flash.events.MouseEvent;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.utils.ByteArray;
	
	public class MainImageDB extends EventDispatcher{
		private static const config:String = 'DataBase/Images/Config.xml'
		private static const basePath:String = 'DataBase/Images';
		private var configLoader:LoadFiles;
		private var arrFolder:Array = new Array();
		private var container:Sprite = new Sprite();
		private var dragContainer:Sprite;
		private var outputSample:Sprite;
		private var panel:Panel;
		
		private var currentX:Number;
		private var currentY:Number;
		
		private var currentFile:String;
		private var currentBA:ByteArray;
		private var currentName:String;
		
		private var arrayName:Array;
		
		private var inXml:XML;
		public function MainImageDB(panel:Panel) {
			super();
			this.panel = panel;
			panel.mainContainer.addChild(container);
			configLoader = new LoadFiles();
			configLoader.addEventListener(Events.LOAD_TEXT_FILE, LOAD_FILE_COMPLATE);
			configLoader.loadLocalTextFile(config);
			
		}
		public function setDragContainer(container:Sprite):void{
			dragContainer = container;
		}
		private function LOAD_FILE_COMPLATE(e:Event):void{
			inXml = new XML(configLoader.outObject.data);
			for each(var sample:XML in inXml.DIR){
				arrFolder.push(new FolderImage(sample));
			}
			var i:int;
			var l:int;
			l = arrFolder.length;
			for(i=0;i<l;i++){
				container.addChild(arrFolder[i]);
				arrFolder[i].y = i*arrFolder[i].height+3;
				arrFolder[i].x = 3;
				arrFolder[i].addEventListener(FolderImage.FOLDER_CHANGE, FOLDER_CHANGE);
				arrFolder[i].addEventListener(FileImage.FILE_SELECT, ON_FILE_SELECT);
			}
		}
		private function FOLDER_CHANGE(e:Event):void{
			var i:int;
			var l:int;
			l = arrFolder.length;
			for(i=1;i<l;i++){
				arrFolder[i].y = arrFolder[i-1].y + arrFolder[i-1].height;
			}
			this.panel.updatePanel();
		}
		
		private function ON_FILE_SELECT(e:Event):void{
			panel.activeHandler(false);
			currentFile = e.target.path;
			currentName = e.target.bdName;
			outputSample = new Sprite();
			var countur:Sprite = Figure.returnRect(20, 15, 1, 0.5, 0x000000, 0);
			outputSample.addChild(countur);
			countur.x = -countur.width/2;
			countur.y = -countur.height/2;
			dragContainer.addChild(outputSample);
			outputSample.startDrag(true);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, SAMPLE_MOUSE_MOVE);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, SAMPLE_MOUSE_UP);
		}
		private function SAMPLE_MOUSE_MOVE(e:MouseEvent):void{
			e.updateAfterEvent();
		}
		private function SAMPLE_MOUSE_UP(e:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,  SAMPLE_MOUSE_MOVE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, SAMPLE_MOUSE_UP);
			panel.activeHandler(true);
			if(!outputSample.hitTestObject(panel.maskPanel)){
				currentX = outputSample.x;
				currentY = outputSample.y;
				loadCurrentFile();
			}
			outputSample.stopDrag();
			dragContainer.removeChild(outputSample);
			outputSample = null;
		}
		private function loadCurrentFile():void{
			configLoader.loadMuchFiles([currentFile], basePath);
			configLoader.addEventListener(Events.LOAD_MUCH_FILE, ON_LOAD_MUCH_FILE);
		}
		private function ON_LOAD_MUCH_FILE(e:Event):void{
			configLoader.removeEventListener(Events.LOAD_MUCH_FILE, ON_LOAD_MUCH_FILE);
			//trace(this + ': LOADED BYTE ARRAY = \n' + configLoader.outObject.arrByteArray);
			currentBA = configLoader.outObject.arrByteArray[0];
			super.dispatchEvent(new Event(Events.ADD_PICTURE_IN_DESIGNER));
		}
		public function getAddedSample():Object{
			var outObject:Object = new Object();
			outObject.bitmap = currentBA;
			outObject.name = currentName;
			outObject.x = currentX;
			outObject.y = currentY;
			return outObject;
		}
		
		
		
		private var outByteArray:Array;
		private var outNameArray:Array;
		public function loadDBFiles(names:Array, isForDesigner:Boolean = true):void{
			var i:int;
			var l:int;
			var arrFile:Array = new Array();
			var currentXML:XMLList;
			l = names.length;
			arrayName = new Array();
			for(i=0;i<l;i++){
				currentXML = inXml..FILE.(@ID == names[i]);
				if(currentXML[0].@name.toString()!=''){
					arrFile.push(currentXML[0].@path+'/'+currentXML[0].@name);
					arrayName.push([names[i], currentXML[0].@path+'/'+currentXML[0].@name]);
				}
			}
			configLoader.loadMuchFiles(arrFile, basePath);
			if(isForDesigner){
				configLoader.addEventListener(Events.LOAD_MUCH_FILE, ON_LOAD_MUCH_FILE_FOR_TASK);
			}else{
				configLoader.addEventListener(Events.LOAD_MUCH_FILE, ON_LOAD_MUCH_FILE_FOR_PLAYER);
			}
		}
		
		
		private function ON_LOAD_MUCH_FILE_FOR_TASK(e:Event):void{
			configLoader.removeEventListener(Events.LOAD_MUCH_FILE, ON_LOAD_MUCH_FILE_FOR_TASK);
			outByteArray = configLoader.outObject.arrByteArray;
			var arrName:Array = configLoader.outObject.arrName;
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			l = arrName.length;
			k = arrayName.length;
			outNameArray = new Array();
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(arrName[i] == arrayName[j][1]){
						outNameArray[i] = 'ID_DB_' + arrayName[j][0];
					}
				}
			}
			super.dispatchEvent(new Event(Events.LOAD_MUCH_FILE));
		}
		private function ON_LOAD_MUCH_FILE_FOR_PLAYER(e:Event):void{
			configLoader.removeEventListener(Events.LOAD_MUCH_FILE, ON_LOAD_MUCH_FILE_FOR_PLAYER);
			outByteArray = configLoader.outObject.arrByteArray;
			var arrName:Array = configLoader.outObject.arrName;
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			l = arrName.length;
			k = arrayName.length;
			outNameArray = new Array();
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(arrName[i] == arrayName[j][1]){
						outNameArray[i] = 'ID_DB_' + arrayName[j][0];
					}
				}
			}
			super.dispatchEvent(new Event(Events.LOAD_MUCH_FILE));
		}
		
		
		public function getByteArrays(isForDesigner:Boolean = true):Array{
			var outArray:Array = new Array();
			var i:int;
			for(i=0;i<outByteArray.length;i++){
				if(isForDesigner){
					outArray.push([outNameArray[i], outByteArray[i]]);
				}else{
					outArray.push([outByteArray[i], outNameArray[i]]);
				}
			}
			return outArray;
		}
		
		public function changeVisible():void{
			this.panel.visible = !this.panel.visible;
		}
	}
	
}
