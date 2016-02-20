package source.Task {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.TaskSettings.SettingsSystem;
	import flash.utils.ByteArray;
	import source.utils.ColorPicker.ColorPicker;
	import flash.events.Event;
	import source.Task.PaintSystem.PaintControl;
	import flash.display.Bitmap;
	import source.Task.TaskLayers.Layers;
	import source.Task.TaskTree.TreeController;
	import source.utils.xmlPrimitive.XmlSquare;
	import source.utils.xmlPrimitive.XmlSmalTriangle;
	import source.utils.xmlPrimitive.XmlRectangle;
	import source.utils.xmlPrimitive.XmlHexagon;
	import source.utils.xmlPrimitive.XmlRound;
	import source.utils.xmlPrimitive.XmlStick;
	import source.utils.xmlPrimitive.XmlLargeTriangle;
	import source.utils.xmlPrimitive.XmlSet;
	import source.utils.xmlNumbers.*;
	import source.utils.xmlClassic.*;
	import source.Task.Animation.ControllerAnimation;
	
	public class TaskSystem extends EventDispatcher {
		public static var TAKE_FRAME_SETTINGS:String = 'onTakeFrameSettings';
		
		public var sWidth:Number = 742;
		public var sHeight:Number = 530;
		
		private var arrOfTask:Array = new Array();
		private var currentID:int = -1;
		private var mainSprite:Sprite;
		private var settingsSystem:SettingsSystem;
		private var colorPicker:ColorPicker;
		public static var paintPanel:PaintControl;
		private var layerController:Layers;
		private var treeController:TreeController;
		
		private var isTask:Boolean = false;
		private var isTestAnimation:Boolean = true;
		private var isCheck:Boolean = false;
		private var autoDelivery:Boolean = false;
		private var isRandom:Boolean = false;
		private var numEquivalent:int = 0;
		private var noMore:int = 0;
		
		private var autoDeliveryDL:Boolean = true;
		private var deliveryTimer:String = '00.00';
		
		public static var animationController:ControllerAnimation;
		public function TaskSystem(inSprite:Sprite) {
			super();
			mainSprite = inSprite;
			animationController = new ControllerAnimation(mainSprite)
			mainSprite.mouseEnabled = false;
			settingsSystem = new SettingsSystem();
			colorPicker = new ColorPicker();
			paintPanel = new PaintControl();
			layerController = new Layers();
			treeController = new TreeController();
			paintPanel.addEventListener(PaintControl.ADD_FIGURE_ON_SCENE, ADD_FIGURE_ON_SCENE);
			layerController.addEventListener(Layers.LAYER_CHANGE, ON_LAYER_CHANGE);
			
			treeController.addEventListener(TreeController.TASK_SELECT, ON_TASK_SELECT);
			treeController.addEventListener(TreeController.TREE_CHANGE, ON_TREE_CHANGE);
			treeController.addEventListener(TreeController.CORRECT_TREE, ON_TREE_CORRECT);
			treeController.addEventListener(TreeController.REMOVE_TASK, ON_TASK_REMOVE);
			treeController.addEventListener(TreeController.DUPLICATE_TASK, ON_DUPLICATE_TASK);
			
			animationController.addEventListener(OneTask.GET_OBJECT_SETTINGS, ANIMATION_POINT_GET_SETTINGS);
			newTask();
			//settingsSystem.panel = inSprite;
			//colorPicker.container = inSprite;
			//paintPanel.container = inSprite;
			//layerController.container = inSprite;
			//treeController.container = inSprite;
			//addPrimitiveSet();
		}
		private function ON_LAYER_CHANGE(e:Event):void{
			arrOfTask[currentID].linkArray = layerController.transposition;
		}
		private function ON_TASK_SELECT(e:Event):void{
			var ID:int = e.target.ID;
			gotoTask(ID);
		}
		private function ON_TREE_CHANGE(e:Event):void{
			var ID:int = e.target.ID;
			var remTask:OneTask = arrOfTask[ID];
			arrOfTask.splice(ID,1);
			var newID:int = e.target.newID;
			arrOfTask.splice(newID,0,remTask);
			ON_TREE_CORRECT();
		}
		private function ON_TREE_CORRECT(e:Event = null):void{
			var correctLevel:Array = treeController.levels;
			var i:int;
			var l:int;
			l = correctLevel.length;
			for(i=0;i<l;i++){
				arrOfTask[i].tLevel = correctLevel[i];
			}
		}
		private function ON_TASK_REMOVE(e:Event):void{
			var id:int = e.target.ID;
			removeTask(id);
		}
		private function ON_DUPLICATE_TASK(e:Event):void{
			var id:int = e.target.ID;
			var inXml:XMLList = arrOfTask[id].listPosition;
			var arr:Array = arrOfTask[id].content
			this.gotoTask(id);
			newTask();
			arrOfTask[currentID].setBaseSettings(new XML(inXml),arr);
			updateTaskTree();
		}
		public function setNewTask(inXML:XMLList, arrData:Array):void{
			//trace(this + ': IN XML: = \n' + inXML) ;
			//trace(this + ': IN ARR DATA: = \n' + arrData) ;
			
			if(inXML.TEST.toString()=='true') this.task = true;
			if(inXML.CHECK.toString()=='true') this.check = true;
			if(inXML.TESTANIMATION.toString() != '') this.testAnimation = inXML.TESTANIMATION.toString() == 'true';
			if(inXML.DELIVERY.toString()=='true') this.delivery = true;
			if(inXML.EQUIVALENT.toString()!='') numEquivalent = parseInt(inXML.EQUIVALENT.toString());
			if(inXML.RANDOM.toString()=='true') isRandom = true;
			if(inXML.NOMORE.toString()!='') more = parseInt(inXML.NOMORE.toString());
			if(inXML.ISAUTODELIVERY.toString()!='') isAutoDelivery = inXML.ISAUTODELIVERY.toString() == 'true';
			if(inXML.TIMERDELIVERY.toString() != '') this.timerDelivery = inXML.TIMERDELIVERY.toString();
			
			
			if(inXML.WIDTH.toString()!=''){
				if(parseFloat(inXML.WIDTH)>this.stageWidth)this.stageWidth = parseFloat(inXML.WIDTH);
				if(parseFloat(inXML.HEIGHT)>this.stageHeight)this.stageHeight = parseFloat(inXML.HEIGHT);
			}
			for each(var sample:XML in inXML.TASK){
				arrOfTask[currentID].setBaseSettings(sample, arrData);
				newTask();
			}
			removeTask(currentID);
		}
		public function newTask():void{
			++currentID;
			arrOfTask.splice(currentID, 0, new OneTask(settingsSystem, colorPicker));
			updateTaskTree();
			this.gotoTask(currentID);
			layerController.layer = arrOfTask[currentID].getLayerArray();
			CREATE_PANEL_SETTINGS();
		}
		private function updateTaskTree():void{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrOfTask.length;
			for(i=0;i<l;i++){
				outArr.push(arrOfTask[i].levelAndName)
			}
			treeController.tree = outArr;
			treeController.taskSelect = currentID;
		}
		public function gotoTask(id:int):void{
			if(id>arrOfTask.length-1) {
				//	продиспатчить невозможность перехода к заданию
				return;
			}
			clearScene();
			this.mainSprite.addChild(arrOfTask[id]);
			currentID = id;
			CREATE_PANEL_SETTINGS();
			treeController.taskSelect = currentID;
			layerController.layer = arrOfTask[currentID].getLayerArray();
			//	продиспатчить событие смены задания
		}
		private function removeTask(inID:int):void{
			var id:int = inID;
			if(id<0 || id>arrOfTask.length-1) return;
			if(id == 0 && arrOfTask.length == 1) return;
			arrOfTask.splice(id, 1);
			if(id>arrOfTask.length-1) id = arrOfTask.length-1;
			gotoTask(id);
			updateTaskTree();
		}
		public function fullClear():void{
			while(arrOfTask.length>1){
				this.removeTask(0);
			}
			currentClear();
		}
		public function currentClear():void{
			this.newTask();
			var id:int = this.currentID-1;
			this.removeTask(id);
		}
		public function setDrawer(rect:Object, type:String):void{
			arrOfTask[currentID].setDrawer(rect, type);
		}
		private function clearScene():void{
			while(this.mainSprite.numChildren>0){
				this.mainSprite.removeChildAt(0);
			}
		}
		public function set settingsContainer(value:Sprite):void{
			settingsSystem.panel = value;
		}
		public function set colorPickerContainer(value:Sprite):void{
			colorPicker.container = value;
		}
		public function set paintContainer(value:Sprite):void{
			paintPanel.container = value;
		}
		public function set layerContainer(value:Sprite):void{
			layerController.container = value;
		}
		public function set treeContainer(value:Sprite):void{
			treeController.container = value;
		}
		
		public function reset():void{
			arrOfTask[currentID].reset();
		}
		public function addPictAsTan(name:String, bitmap:ByteArray, x:Number, y:Number):void{
			arrOfTask[currentID].addPictAsTan(name, bitmap, x, y);
		}
		public function addSwfObject(name:String, swf:ByteArray, x:Number, y:Number):void{
			arrOfTask[currentID].addSwfObject(name, swf, x, y);
		}
		public function addCharisProgram(name:String, text:ByteArray, width:Number, height:Number):void{
			arrOfTask[currentID].addCharisProgram(name, text, width, height);
		}
		public function addFigure(value:Object, x:Number, y:Number):void{
			arrOfTask[currentID].addFigure(value, x, y);
		}
		public function addClassicTan():void{
			arrOfTask[currentID].addComplect();
		}
		public function addPaintPanel():void{
			arrOfTask[currentID].addPalitra();
		}
		public function addButton():void{
			arrOfTask[currentID].addUserButton();
		}
		/***********************/
		/*Добавление примитивов*/
		/***********************/
		public function addPrimitiveSet():void{
			var arr:Array = XmlSet.xml;
			var i:int;
			var l:int;
			var inXml:XMLList
			l = arr.length;
			for(i=0;i<l;i++){
				inXml = arr[i];
				arrOfTask[currentID].addUserTan(inXml);
			}
		}
		public function addPrimitiveSquare():void{
			var xml:XMLList = XmlSquare.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addPrimitiveSmalTriangle():void{
			var xml:XMLList = XmlSmalTriangle.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addPrimitiveRectangle():void{
			var xml:XMLList = XmlRectangle.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addPrimitiveLargeTriangle():void{
			var xml:XMLList = XmlLargeTriangle.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addPrimitiveHexagon():void{
			var xml:XMLList = XmlHexagon.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addPrimitiveRound():void{
			var xml:XMLList = XmlRound.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addPrimitiveStick():void{
			var xml:XMLList = XmlStick.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		/***********************/
		public function addNumbersSet():void{
			var arr:Array = XmlNumSet.xml;
			var i:int;
			var l:int;
			var inXml:XMLList
			l = arr.length;
			for(i=0;i<l;i++){
				inXml = arr[i];
				arrOfTask[currentID].addUserTan(inXml);
			}
		}
		public function addNumberZero():void{
			var xml:XMLList = XmlZero.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberOne():void{
			var xml:XMLList = XmlOne.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberTwo():void{
			var xml:XMLList = XmlTwo.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberThree():void{
			var xml:XMLList = XmlThree.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberFour():void{
			var xml:XMLList = XmlFour.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberFive():void{
			var xml:XMLList = XmlFive.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberSix():void{
			var xml:XMLList = XmlSix.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberSeven():void{
			var xml:XMLList = XmlSeven.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberEight():void{
			var xml:XMLList = XmlEight.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addNumberNine():void{
			var xml:XMLList = XmlNine.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		
		public function addSymbolPlus():void{
			var xml:XMLList = XmlPlus.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addSymbolMinus():void{
			var xml:XMLList = XmlMinus.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addSymbolEqual():void{
			var xml:XMLList = XmlEqual.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		/***********************/
		public function addClassicSet():void{
			var arr:Array = XmlClassicSet.xml;
			var i:int;
			var l:int;
			var inXml:XMLList
			l = arr.length;
			for(i=0;i<l;i++){
				inXml = arr[i];
				arrOfTask[currentID].addUserTan(inXml);
			}
		}
		public function addRewordSet():void{
			var arr:Array = XmlClassicRewordSet.xml;
			var i:int;
			var l:int;
			var inXml:XMLList
			l = arr.length;
			for(i=0;i<l;i++){
				inXml = arr[i];
				arrOfTask[currentID].addUserTan(inXml);
			}
		}
		public function addClassicKvadrat():void{
			var xml:XMLList = XmlClassicKvadrat.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addClassicRomb():void{
			var xml:XMLList = XmlClassicRomb.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addClassicLarge():void{
			var xml:XMLList = XmlClassicLarge.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addClassicSred():void{
			var xml:XMLList = XmlClassicSred.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		public function addClassicSmal():void{
			var xml:XMLList = XmlClassicSmal.xml;
			arrOfTask[currentID].addUserTan(xml);
		}
		/***********************/
		
		private function ADD_FIGURE_ON_SCENE(e:Event):void{
			var inXml:XMLList = paintPanel.listSettings;
			var bitmap:Bitmap = paintPanel.bitmap;
			var name:String = paintPanel.nameBitmap;
			trace(this + ': BITMAP = ' + bitmap + ', NAME = ' + name);
			for each(var sample:XML in inXml.OBJECTS.FIGURE){
				//trace(this + ': SAMPLE = \n' + new XMLList(sample))
				if(inXml.OBJECTS.FIGURE.IMAGE.@x!=''){
					arrOfTask[currentID].addUserTan(new XMLList(sample), bitmap, name);
				}else{
					arrOfTask[currentID].addUserTan(new XMLList(sample));
				}
				
			}
		}
		public function addPictureInPaint(value:ByteArray, name:String):void{
			paintPanel.setImage(value, name);
		}
		
		public function set stageWidth(value:Number):void{
			if(value>2000) sWidth = 2000;
			else sWidth = value;
			super.dispatchEvent(new Event(TAKE_FRAME_SETTINGS));
		}
		public function get stageWidth():Number{
			return sWidth;
		}
		public function set stageHeight(value:Number):void{
			if(value>2000) sHeight = 2000;
			else sHeight = value;
			super.dispatchEvent(new Event(TAKE_FRAME_SETTINGS));
		}
		public function get stageHeight():Number{
			return sHeight;
		}
		
		
		public function set task(value:Boolean):void{
			isTask = value;
		}
		public function get task():Boolean{
			return isTask;
		}
		public function set check(value:Boolean):void{
			isCheck = value;
		}
		public function get check():Boolean{
			return isCheck;
		}
		public function set testAnimation(value:Boolean):void{
			isTestAnimation = value;
		}
		public function get testAnimation():Boolean{
			return isTestAnimation;
		}
		public function get random():Boolean{
			return isRandom;
		}
		public function set random(value:Boolean):void{
			isRandom = value;
		}
		public function set equivalent(value:int):void{
			numEquivalent = value;
		}
		public function get equivalent():int{
			return numEquivalent;
		}
		public function get more():int{
			return noMore;
		}
		public function set more(value:int):void{
			noMore = value;
		}
		
		public function set name(value:String):void{
			arrOfTask[currentID].tName = value;
			updateTaskTree();
		}
		public function get name():String{
			return arrOfTask[currentID].tName;
		}
		public function set health(value:int):void{
			arrOfTask[currentID].tHealth = value;
		}
		public function get health():int{
			return arrOfTask[currentID].tHealth;
		}
		public function set timer(value:String):void{
			arrOfTask[currentID].tTimer = value;
		}
		public function get timer():String{
			return arrOfTask[currentID].tTimer;
		}
		public function set isTimer(value:Boolean):void{
			arrOfTask[currentID].isTimer = value;
		}
		public function get isTimer():Boolean{
			return arrOfTask[currentID].isTimer;
		}
		public function set jump(value:int):void{
			arrOfTask[currentID].tJump = value;
		}
		public function get jump():int{
			return arrOfTask[currentID].tJump;
		}
		public function set mnimoe(value:Boolean):void{
			arrOfTask[currentID].tMnimoe = value;
		}
		public function get mnimoe():Boolean{
			return arrOfTask[currentID].tMnimoe;
		}
		
		public function set uniq(value:Boolean):void{
			arrOfTask[currentID].tUniq = value;
		}
		public function get uniq():Boolean{
			return arrOfTask[currentID].tUniq;
		}
		
		public function set icon(value:Boolean):void{
			arrOfTask[currentID].tIcon = value;
		}
		public function get icon():Boolean{
			return arrOfTask[currentID].tIcon;
		}
		public function set understand(value:Boolean):void{
			arrOfTask[currentID].tUnderstand = value;
		}
		public function get understand():Boolean{
			return arrOfTask[currentID].tUnderstand;
		}
		public function set restart(value:Boolean):void{
			arrOfTask[currentID].tRestart = value;
		}
		public function get restart():Boolean{
			return arrOfTask[currentID].tRestart;
		}
		public function set dontknow(value:Boolean):void{
			arrOfTask[currentID].tDontkonw = value;
		}
		public function get dontknow():Boolean{
			return arrOfTask[currentID].tDontkonw;
		}
		public function set openMarkCounter(value:Boolean):void{
			(arrOfTask[currentID] as OneTask).openMarkCounter = value;
		}
		public function get openMarkCounter():Boolean{
			return (arrOfTask[currentID] as OneTask).openMarkCounter;
		}
		public function set delivery(value:Boolean):void{
			autoDelivery = value;
		}
		public function get delivery():Boolean{
			return autoDelivery;
		}
		
		public function set isAutoDelivery(value:Boolean):void{
			autoDeliveryDL = value;
		}
		public function get isAutoDelivery():Boolean{
			return autoDeliveryDL;
		}
		
		public function set timerDelivery(value:String):void{
			deliveryTimer = value;
		}
		public function get timerDelivery():String{
			return deliveryTimer;
		}
		
		public function userContent():Object{
			var outObject:Object = new Object();
			var arrBitmap:Array = new Array();
			var arrBytes:Array = new Array();
			var arrFileName:Array = new Array();
			var i:int;
			var l:int;
			var l:int;
			l = arrOfTask.length;
			for(i=0;i<l;i++){
				if((arrOfTask[i] as OneTask).authorBitmap.length!=0){
					for(j=0;j<(arrOfTask[i] as OneTask).authorBitmap.length; j++){
						arrBitmap.push((arrOfTask[i] as OneTask).authorBitmap[j]);
						arrBytes.push((arrOfTask[i] as OneTask).authorByteArray[j]);
						arrFileName.push((arrOfTask[i] as OneTask).authorFileName[j]);
					}
				}
			}
			outObject.arrBitmap = arrBitmap;
			outObject.arrByteArray = arrBytes;
			outObject.arrName = arrFileName;
			return outObject;
		}
		private function settingsList():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ЗАДАНИЕ';
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="stageWidth" width="40">' + this.stageWidth.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="stageHeight" width="40">' + this.stageHeight.toString() + '</FIELD>');			
			var blockList:XMLList = new XMLList('<BLOCK label="размер сцены"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<MARK label="Тестовый режим" variable="task">'+this.task.toString()+'</MARK>');
			heightList = new XMLList('<MARK label="кнопка ПРОВЕРИТЬ" variable="check">'+this.check.toString()+'</MARK>');
			var animationList:XMLList = new XMLList('<MARK label="анимация смены заданий" variable="testAnimation">'+this.testAnimation.toString() + '</MARK>');
			blockList = new XMLList('<BLOCK label="параметры пакета"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			blockList.appendChild(animationList);
			outXml.appendChild(blockList);
			
			var randomXML:XMLList = new XMLList('<MARK label="случайный порядок" variable="random">'+this.random.toString()+'</MARK>');
			var equivalentXML:XMLList = new XMLList('<FIELD label="разбиение" type="number" variable="equivalent" width="40">' + this.equivalent.toString() + '</FIELD>');
			var moreXML:XMLList = new XMLList('<FIELD label="не более" type="number" variable="more" width="40">' + this.more.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="выборка заданий (только тестовый режим без мнимых заданий)"/>');
			blockList.appendChild(randomXML);
			blockList.appendChild(equivalentXML);
			blockList.appendChild(moreXML);
			outXml.appendChild(blockList);
			
			
			widthList = new XMLList('<FIELD label="" type="string" variable="name" width="400">' + this.name + '</FIELD>');
			blockList = new XMLList('<BLOCK label="название задания"/>');
			blockList.appendChild(widthList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<FIELD label="жизни" type="number" variable="health" width="40">'+this.health.toString()+'</FIELD>');
			heightList = new XMLList('<FIELD label="таймер" type="string" variable="timer" width="70">'+this.timer+'</FIELD>');			
			var isTimerList:XMLList = new XMLList('<MARK label="включить таймер" variable="isTimer">'+this.isTimer.toString()+'</MARK>');
			var additionalXml:XMLList = new XMLList('<FIELD label="прыжок" type="number" variable="jump" width="40">' + this.jump.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="контроль задания"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			blockList.appendChild(isTimerList);
			blockList.appendChild(additionalXml);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<MARK label="мнимость" variable="mnimoe">'+this.mnimoe.toString()+'</MARK>');
			heightList = new XMLList('<MARK label="однозначность" variable="uniq">'+this.uniq.toString()+'</MARK>');	
			additionalXml = new XMLList('<MARK label="иконки" variable="icon">'+this.icon.toString()+'</MARK>');	
			var markCounterList:XMLList = new XMLList('<MARK label="счётчик областей выделения" variable="openMarkCounter">'+this.openMarkCounter.toString()+'</MARK>');
			
			blockList = new XMLList('<BLOCK label="оформление"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			blockList.appendChild(additionalXml);
			blockList.appendChild(markCounterList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<MARK label="я понял" variable="understand">'+this.understand.toString()+'</MARK>');
			heightList = new XMLList('<MARK label="сначала" variable="restart">'+this.restart.toString()+'</MARK>');	
			additionalXml = new XMLList('<MARK label="не знаю" variable="dontknow">'+this.dontknow.toString()+'</MARK>');	
			blockList = new XMLList('<BLOCK label="удаление кнопок"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			blockList.appendChild(additionalXml);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<MARK label="использовать для автовыдачи" variable="delivery">'+this.delivery.toString()+'</MARK>');
			var listIsAutoDelivery:XMLList = new XMLList('<MARK label="авто-переход в автовыдаче DL" variable="isAutoDelivery">'+this.isAutoDelivery.toString()+'</MARK>');
			var deliveryTimerList:XMLList = new XMLList('<FIELD label="таймер смены заданий" type="string" variable="timerDelivery" width="70">'+this.timerDelivery+'</FIELD>');
			
			blockList = new XMLList('<BLOCK label="автовыдача"/>');
			
			blockList.appendChild(widthList);
			blockList.appendChild(listIsAutoDelivery);
			blockList.appendChild(deliveryTimerList);
			
			outXml.appendChild(blockList);
			
			return outXml;
		}
		public function CREATE_PANEL_SETTINGS():void{
			//trace(this + ': Settings ADDED = ' + settingsList());
			var outObject:Object = new Object();
			outObject.data = this;
			outObject.xml = settingsList();
			settingsSystem.addObject(outObject);
		}
		private function ANIMATION_POINT_GET_SETTINGS(value:Event):void{
			var outObject:Object = new Object();
			outObject.data = animationController.remember;
			outObject.xml = animationController.remember.listSettings;
			settingsSystem.addObject(outObject);
			this.colorPicker.object = animationController.remember;
		}
		public function get headListPosition():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@version = '1.2';
			outXml.@copyrights = 'http://dl.gsu.by';
			outXml.TEST = this.task;
			if(this.delivery) outXml.DELIVERY = 'true';
			outXml.ISAUTODELIVERY = isAutoDelivery.toString();
			if(isAutoDelivery) outXml.TIMERDELIVERY = this.timerDelivery;
			outXml.CHECK = this.check;
			outXml.TESTANIMATION = this.testAnimation;
			outXml.RANDOM = random.toString();
			if(equivalent>1) outXml.EQUIVALENT = equivalent.toString();
			if(more>0) outXml.NOMORE = more.toString();
			if (this.stageWidth.toString() != 'NaN') outXml.WIDTH = this.stageWidth.toString();
			if (this.stageHeight.toString() != 'NaN') outXml.HEIGHT = this.stageHeight.toString();
			return outXml;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = this.headListPosition;
			var i:int;
			var l:int;
			var addXml:XMLList;
			l = arrOfTask.length;
			for(i=0;i<l;i++){
				addXml = arrOfTask[i].listPosition;
				addXml.@id = (i+1).toString();
				outXml.appendChild(addXml);
			}
			return outXml;
		}
		public function get currentListPosition():XMLList{
			var outXml:XMLList = this.headListPosition;
			var i:int;
			var l:int;
			var addXml:XMLList;
			l = arrOfTask.length;
			var startIndex:int;
			var endIndex:int;
			startIndex = currentID;
			endIndex = currentID;
			for(i=currentID-1;i>=0;i--){
				if(arrOfTask[i].tLevel == arrOfTask[currentID].tLevel && arrOfTask[i].tMnimoe){
					startIndex = i;
				}else break;
			}
			if(arrOfTask[currentID].tMnimoe){
				for(i=currentID+1; i<l;i++){
					if(arrOfTask[i].tLevel == arrOfTask[currentID].tLevel && arrOfTask[i].tMnimoe){
						endIndex = i;
					}else{
						if(arrOfTask[i].tLevel != arrOfTask[currentID].tLevel){
							break;
						}else{
							endIndex = i;
							break;
						}
					}
				}
			}
			
			for(i=startIndex;i<=endIndex;i++){
				addXml = arrOfTask[i].listPosition;
				addXml.@id = ((i-startIndex)+1).toString();
				outXml.appendChild(addXml);
			}
			return outXml;
		}
		public function get isCorrectPosition():Boolean{
			var i:int;
			var l:int;
			l = arrOfTask.length;
			for(i=0;i<l;i++){
				if(!arrOfTask[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = arrOfTask.length;
			for(i=0;i<l;i++){
				arrOfTask[i].normalizePosition();
			}
		}
		
		public function setBlackOnColor():void{
			arrOfTask[currentID].setBlackOnColor();
		}
		public function setColorOnBlack():void{
			arrOfTask[currentID].setColorOnBlack();
		}
		public function userTanOnPicture():void{
			arrOfTask[currentID].userTanOnPicture();
		}
		
		public function get checkPaintColors():Boolean{
			var i:int;
			var l:int;
			l = arrOfTask.length;
			for(i=0;i<l;i++){
				if(!(arrOfTask[i] as OneTask).checkPaintColors) return false;
			}
			return true;
		}
	}
	
}
