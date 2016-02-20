package source.EnvKonstraktion {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import source.EnvKonstraktion.PictLibrary.Library;
	import source.EnvInterface.EnvPanel.Panel;
	import source.EnvEvents.Events;
	import source.EnvUtils.EnvString.ConvertString;
	import source.EnvKonstraktion.TestInPlayer.TestPlayer;
	import source.EnvKonstraktion.ImageDataBase.MainImageDB;
	import source.EnvUtils.EnvDraw.Figure;
	import source.EnvKonstraktion.FigureLibrary.FigureController;
	import flash.geom.Point;
	import source.MainEnvelope;
	import source.Components.MessageText;
	import source.Components.MessageWindow;
	import source.EnvLoader.LoadFiles;

	
	public class InitKonstraction extends Sprite{
		public var panelName:String = 'БИБЛИОТЕКА';
		private static const nameDes:String = 'Designer.swf';
		private var stageW:Number;
		private var stageH:Number;
		private var loaderDes:Loader = new Loader();
		
		private var designer:Object = new Object();
		
		private var pictLibrary:Library;
		private var figureLibrary:FigureController;
		private var imageDataBase:MainImageDB;
		
		private var testPlayer:TestPlayer;
		
		private var currentTask:String;
		
		private var mainPanel:Panel;
		private var backGroundDess:Sprite = new Sprite();
		private var toolsPanel:ToolsPanel;
		private var panel:Panel;
		private var colorPanel:Panel;
		private var toolPanel:Panel;
		private var paintPanel:Panel;
		private var layerPanel:Panel;
		private var treePanel:Panel;
		private var deltaXYDessigner:int = - 500;
		//	Массив передачи контента в конструктор
		private var arrData:Array;
		public function InitKonstraction(mainPanel:Panel) {
			super();
			this.mainPanel = mainPanel;
			Figure.insertRect(backGroundDess, 3000, 3000, 1, 0, 0, 1, 0xEFEFEF);
			mainPanel.mainContainer.addChild(backGroundDess);
			mainPanel.mainContainer.addChild(super);
			super.x = super.y = (-1)*deltaXYDessigner;
			super.addChild(loaderDes);
			
		}
		public function initSystemPanel(inPanel:Array):void{
			panel = inPanel[0];
			colorPanel = inPanel[1];
			toolPanel = inPanel[2];
			paintPanel = inPanel[3];
			layerPanel = inPanel[4];
			treePanel = inPanel[5];
			imageDataBase = new MainImageDB(inPanel[6]);
			figureLibrary = new FigureController(inPanel[7]);
			figureLibrary.addEventListener(FigureController.ADD_FIGURE, ADD_FIGURE_IN_DESIGNER);
		}
		public function initWindowSize(width:Number, height:Number):void{
			stageW = width;
			stageH = height;
		}
		public function initTestPlayer(container:Sprite):void{
			testPlayer = new TestPlayer(container, stageW, stageH);
		}
		public function start():void{
			loaderDes.contentLoaderInfo.addEventListener(Event.INIT, DESIGNER_INIT);
			loaderDes.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, DESIGNER_IO_ERROR);
			loaderDes.load(new URLRequest(nameDes));
		}
		private function DESIGNER_INIT(e:Event):void{
			loaderDes.contentLoaderInfo.removeEventListener(Event.INIT, DESIGNER_INIT);
			loaderDes.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, DESIGNER_IO_ERROR);
			designer = e.target.content;
			//designer.initStage(inStage);
			designer.settingsContainer = panel.mainContainer;
			designer.colorPickerContainer = colorPanel.mainContainer;
			designer.paintContainer = paintPanel.mainContainer;
			designer.layerContainer = layerPanel.mainContainer;
			designer.treeContainer = treePanel.mainContainer;
			/*panel.y = 40;
			colorPanel.y = 40;*/
			initLibrary();
			initTools();
			super.dispatchEvent(new Event(Events.DESIGNE_INIT_COMPLATE));
			trace(this + ': INIT DESIGNER COMPLATE = ' + designer);
			if(mainPanel.mainContainer.scaleX==1){
				mainPanel.toPosition(deltaXYDessigner, deltaXYDessigner);
			}
			if(this.mainPanel.mainContainer.scaleX!=1){
				designer.scale = this.mainPanel.mainContainer.scaleX;
			}
		}
		private function DESIGNER_IO_ERROR(e:IOErrorEvent):void{
			trace(this+": ERROR EVENT");
		}
		private function initLibrary():void{
			super.dispatchEvent(new Event(Events.GET_PANEL_FOR_SETTINGS));
			super.dispatchEvent(new Event(Events.GET_DRAG_CONTAINER));
			imageDataBase.addEventListener(Events.ADD_PICTURE_IN_DESIGNER, LIBRARY_ADD_PICTURE);
		}
		public function setPanel(panel:Panel):void{
			pictLibrary = new Library(panel, paintPanel);
			/*panel.x = designer.width+5;
			panel.y = 30;*/
			//changeVisible();
			pictLibrary.addEventListener(Events.ADD_PICTURE_IN_DESIGNER, LIBRARY_ADD_PICTURE);
			pictLibrary.addEventListener(Events.ADD_PICTURE_IN_PAINT, PAINT_ADD_PICTURE);
		}
		public function setDragContainer(container:Sprite):void{
			pictLibrary.setDragContainer(container);
			imageDataBase.setDragContainer(container);
		}
		public function changeVisible():void{
			pictLibrary.changVisible();
		}
		private function LIBRARY_ADD_PICTURE(e:Event):void{
			var inObject:Object = e.target.getAddedSample();
			var point:Point = mainPanel.mainContainer.globalToLocal(new Point(inObject.x, inObject.y));
			if(ConvertString.checkSwfName(inObject.name) && ConvertString.checkPasName(inObject.name)){
				designer.addPictAsTan(inObject.name, inObject.bitmap, point.x + deltaXYDessigner, point.y + deltaXYDessigner);
				//trace(this + ': CONTENT = ' + inObject.bitmap);
			}else if(ConvertString.checkPasName(inObject.name)){
				trace(this + ': CONTENT = ' + inObject.swf);
				try{
					designer.addSwfObject(inObject.name, inObject.swf, point.x + deltaXYDessigner, point.y + deltaXYDessigner)
				}catch(e:Error){
					trace(this + ': ERROR ADD =' + e);
				}
			}else{
				trace(this + " pas program = " + inObject.bitmap);
				designer.addCharisProgram(inObject.name, inObject.bitmap);
			}
		}
		private function PAINT_ADD_PICTURE(e:Event):void{
			var inObject:Object = pictLibrary.getAddedSample();
			if(!ConvertString.checkSwfName(inObject.name)) return;
			designer.addPictureInPaint(inObject.bitmap, inObject.name);
		}
		
		
		
		private function ADD_FIGURE_IN_DESIGNER(event:Event):void{
			trace(this, figureLibrary.sample, mainPanel.maskPanel, mainPanel.visible);
			if(!figureLibrary.sample.hitTestObject(mainPanel.maskPanel) || !mainPanel.visible){
				figureLibrary.clear();
			}else{
				var globalPoint:Point = new Point(figureLibrary.sample.x, figureLibrary.sample.y);
				var localPoint:Point = mainPanel.mainContainer.globalToLocal(globalPoint);
				designer.addFigure(figureLibrary.content, localPoint.x + deltaXYDessigner, localPoint.y + deltaXYDessigner);
				figureLibrary.clear();
			}
		}

		
		public function setTask(str:String):void{
			currentTask = str;
		}
		public function setPicture(inObject:Object, isUserContent:Boolean = false):void{
			var arrChange:Array = pictLibrary.setPicture(inObject.arrBitmap, inObject.arrByteArray, inObject.arrName);
			trace(this + ": ARR CHANGE NAME = " + arrChange);
			if(isUserContent) return;
			if(arrChange.length!=0){
				var i:int;
				for(i=0;i<arrChange.length;i++){
					currentTask = ConvertString.changeWordInText(currentTask, arrChange[i]);
				}
			}
			trace(this + ": NEW TASK = " + currentTask);
		}
		
		public function importPicture(inObject:Object):void{
			pictLibrary.setPicture(inObject.arrBitmap, inObject.arrByteArray, inObject.arrName);
		}
		
		public function loadTaskInDesigner():void{
			var arrPictName:Array = ConvertString.getNamesFileFromTask(currentTask);
			var arrDBPicture:Array = ConvertString.getDBFileFromTask(currentTask);
			//trace(this + 'DATA BASE IMAGE ID = |' + arrDBPicture + '|');
			arrData = pictLibrary.getByteArrays(arrPictName);
			if(arrDBPicture.length==0){
				designer.loadTaskFromFileList(currentTask, arrData);
			}else{
				imageDataBase.loadDBFiles(arrDBPicture);
				imageDataBase.addEventListener(Events.LOAD_MUCH_FILE, LOAD_FILES_FROM_DB);
			}
		}
		private function LOAD_FILES_FROM_DB(e:Event):void{
			imageDataBase.removeEventListener(Events.LOAD_MUCH_FILE, LOAD_FILES_FROM_DB);
			var arrDBContent:Array = imageDataBase.getByteArrays();
			var i:int;
			var l:int;
			l = arrDBContent.length;
			for(i=0;i<l;i++){
				arrData.push(arrDBContent[i]);
			}
			designer.loadTaskFromFileList(currentTask, arrData);
		}
		
		public function createNewTask():void{
			designer.createNewTask();
		}
		
		private var saveList:String;
		private var saveData:Array;
		private var saveValue:Boolean;
		public function get isCorrectPosition():Boolean{
			return designer.isCorrectPosition;
		}
		public function normalizePosition():void{
			designer.normalizePosition();
		}
		public function saveTask(value:Boolean = true):void{
			if(!designer.isCorrectPosition){
				saveValue = value;
				if(!designer.checkPaintColors){
					correctColorPalitra();
					return;
				}
				var outObject:Object = new Object();
				outObject.type = MessageWindow.WARNING;
				outObject.text = MessageText.NOT_CORRECT_POSITION_TASK;
				outObject.button = ['Исправить', 'Продолжить', 'Отменить'];
				outObject.dispather = ['onCorrectTask', 'onComplateSave', 'onNothing'];
				MainEnvelope.message.addEventListener('onCorrectTask', CORRECT_TASK);
				MainEnvelope.message.addEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK);
				MainEnvelope.message.message = outObject;
			}else{
				saveValue = value;
				if(!designer.checkPaintColors){
					correctColorPalitra();
					return;
				}
				var taskArr:Array =  this.getContent(value)
				saveList = taskArr[0];
				saveData = taskArr[1];
				super.dispatchEvent(new Event(Events.SAVE_TASK));
			}
		}
		private function CORRECT_TASK(event:Event):void{
			MainEnvelope.message.removeEventListener('onCorrectTask', CORRECT_TASK);
			MainEnvelope.message.removeEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK);
			designer.normalizePosition();
		}
		private function ON_COMPLATE_SAVE_TASK(event:Event):void{
			MainEnvelope.message.removeEventListener('onCorrectTask', CORRECT_TASK);
			MainEnvelope.message.removeEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK);
			if(!designer.checkPaintColors){
				correctColorPalitra();
				return;
			}
			var taskArr:Array =  this.getContent(saveValue)
			saveList = taskArr[0];
			saveData = taskArr[1];
			super.dispatchEvent(new Event(Events.SAVE_TASK));
		}
		
		private function correctColorPalitra():void{
			var outObject:Object = new Object();
			outObject.type = MessageWindow.WARNING;
			outObject.text = MessageText.NOT_CORRECT_COLOR;
			outObject.button = ['Продолжить', 'Отменить'];
			outObject.dispather = ['onComplateSave', 'onNothing'];
			MainEnvelope.message.addEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK_AFTER_COLOREDIT);
			MainEnvelope.message.message = outObject;
		}
		private function ON_COMPLATE_SAVE_TASK_AFTER_COLOREDIT(event:Event):void{
			MainEnvelope.message.removeEventListener('onComplateSave', ON_COMPLATE_SAVE_TASK_AFTER_COLOREDIT);
			var taskArr:Array =  this.getContent(saveValue)
			saveList = taskArr[0];
			saveData = taskArr[1];
			super.dispatchEvent(new Event(Events.SAVE_TASK));
		}
		
		
		
		public function getContent(value:Boolean = true):Array{
			setPicture(designer.getUserContent(), true);
			
			var outArr:Array = new Array();
			if(value){
				outArr[0] = designer.getTaskFile();
			}else{
				outArr[0] = designer.getCurrentTaskFile();
			}
			var arrNameFile:Array = correctArrFiles(ConvertString.getNamesFileFromTask(outArr[0]));
			outArr[1] = pictLibrary.getByteArrays(arrNameFile);
			return outArr;
		}
		private function correctArrFiles(inValue:Array):Array{
			var value:Array = inValue;
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			l = value.length;
			k = LoadFiles.modules.length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(value[i] == LoadFiles.modules[j]){
						value.splice(i, 1);
						i = i-1;
						break;
					}
				}
			}
			return value;
		}
		public function getTask():Object{
			var outObject:Object = new Object();
			outObject.task = saveList;
			outObject.data = saveData;
			return outObject;
		}
		public function get allSeparateTask():Array{
			var tasksArr:Array = designer.taskForDificultArchive;
			var outArr:Array = new Array();
			var nameArr:Array;
			var i:int;
			var l:int;
			l = tasksArr.length;
			for(i=0;i<l;i++){
				nameArr = correctArrFiles(ConvertString.getNamesFileFromTask(tasksArr[i]));
				outArr.push([tasksArr[i], pictLibrary.getByteArrays(nameArr)]);
			}
			return outArr;
		}
		
		public function pSettingsVisible():void{
			panel.visible = !panel.visible;
		}
		public function colorPickerVisible():void{
			colorPanel.visible = !colorPanel.visible;
		}
		public function paintVisible():void{
			paintPanel.visible = !paintPanel.visible;
		}
		public function layerVisible():void{
			this.layerPanel.visible = !this.layerPanel.visible;
		}
		public function treeVisible():void{
			treePanel.visible = !treePanel.visible;
		}
		public function imageBaseVisible():void{
			imageDataBase.changeVisible();
		}
		public function toolsPanelVisible():void{
			toolPanel.visible = !toolPanel.visible;
		}
		public function figugeBaseVisible():void{
			figureLibrary.panelVisible();
		}
		public function sceneVisible():void{
			mainPanel.visible = !mainPanel.visible;
		}
		public function clearAllTask():void{
			designer.allTaskClear();
		}
		public function clearCurrentTask():void{
			designer.currentTaskClear();
		}
		public function set sizeMainScene(value:Number):void{
			this.mainPanel.mainContainer.scaleX = value/100;
			this.mainPanel.mainContainer.scaleY = value/100;
			mainPanel.toPosition(deltaXYDessigner*(value/100), deltaXYDessigner*(value/100));
			designer.scale = value/100;
		}
		private function initTools():void{
			toolsPanel = new ToolsPanel;
			toolPanel.mainContainer.addChild(toolsPanel);
			toolsPanel.addEventListener(ToolsPanel.TOOL_SELECT, TOOL_IS_SELECT);
		}
		private function TOOL_IS_SELECT(e:Event):void{
			designer.createdObject = toolsPanel.currentComand;
		}
		
		public function testTask(value:Boolean = true):void{
			if(testPlayer.isOpen){
				testPlayer.close()
				return;
			}
			if(value){
				saveList = designer.getTaskFile();
			}else{
				saveList = designer.getCurrentTaskFile();
			}
			var arrNameFile:Array = ConvertString.getNamesFileFromTask(saveList);
			var arrDBPicture:Array = ConvertString.getDBFileFromTask(saveList);
			saveData = pictLibrary.getByteArrays(arrNameFile, true);
			if(arrDBPicture.length==0){
				testPlayer.open(saveList, saveData);
			}else{
				imageDataBase.loadDBFiles(arrDBPicture, false);
				imageDataBase.addEventListener(Events.LOAD_MUCH_FILE, LOAD_FILES_FOR_PLAYER);
			}
		}
		private function LOAD_FILES_FOR_PLAYER(e:Event):void{
			imageDataBase.removeEventListener(Events.LOAD_MUCH_FILE, LOAD_FILES_FOR_PLAYER);
			var arrDBContent:Array = imageDataBase.getByteArrays(false);
			var i:int;
			var l:int;
			l = arrDBContent.length;
			for(i=0;i<l;i++){
				saveData.push(arrDBContent[i]);
			}
			testPlayer.open(saveList, saveData);
		}
		
		
		public function showGreed():void{
			designer.greed = true;
		}
		public function hideGreed():void{
			designer.greed = false;
		}
		
		
		public function setBlackOnColor():void{
			designer.setBlackOnColor();
		}
		public function setColorOnBlack():void{
			designer.setColorOnBlack();
		}
		public function userTanOnPicture():void{
			designer.userTanOnPicture();
		}
	}
	
}
