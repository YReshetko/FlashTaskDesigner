package source{
	import flash.display.Stage;
	import flash.events.Event;
	import source.Task.TaskSystem;
	import flash.events.MouseEvent;
	import source.utils.DrawRectOnScene.SimpleDrawer;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import Converter;
	import source.utils.TreeConverter;
	import source.Task.TaskObjects.Label.CheckPoints;
	
	// Параметры SWF-файла
	[SWF(width="742", height="530")]
	
	public class DesignerMain extends InitScene {
		public static var STAGE:Stage;
		private var packageTask:TaskSystem;
		private var simpleDrawer:SimpleDrawer;
		private var currentObject:String = 'select';
		
		public static var currentScale:Number = 1;
		public function DesignerMain() {
			//trace(this + ': START INIT');
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			initDesigner();
		}
		private function test():void{
			var text:ByteArray = new ByteArray();
			var program:String =   "uses charis;\n\r";
			program += "begin\n\r";
			program += "  Right;\n\r";
			program += "  Down;\n\r";
			program += "  Down;\n\r";
			program += "  Down;\n\r";
			program += "  Down;\n\r";
			program += "  Right;\n\r";
			program += "  Right;\n\r";
			program += "  Right;\n\r";
			program += "  Right;\n\r";
			program += "  Down;\n\r";
			program += "  Left;\n\r";
			program += "  Up;\n\r";
			program += "  for i:=1 to n do    \n\r";
			program += "    begin    \n\r";
			program += "      down;    \n\r";
			program += "      right;    \n\r";
			program += "    end;    \n\r";
			program += "  for i:=1 to n do    \n\r";
			program += "    left;    \n\r";
			program += "  Pause;\n\r";
			program += "end.";
			text.writeMultiByte(program, "utf-8");
			this.addCharisProgram("1.pas", text);
		}
		private function onAdd(e:Event):void{
			//trace(this + ': ADDED TO STAGE');
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			STAGE = stage;
			//test();
		}
		private function initDesigner():void{
			packageTask = new TaskSystem(super.container);
			packageTask.addEventListener(TaskSystem.TAKE_FRAME_SETTINGS, SET_FRAME_SIZE);
			this.drawer = true;
			simpleDrawer = new SimpleDrawer();
			simpleDrawer.target = super.frame;
			simpleDrawer.addEventListener(SimpleDrawer.DRAW_OBJECT, CREATE_OBJECT);
			//createdObject = 'addClassicTan';
			//trace(this + ': INIT DES');
			//settingsContainer = this;
			//packageTask.addPrimitiveSet();
		}
		public function set drawer(value:Boolean):void{
			if(value){
				super.frame.addEventListener(MouseEvent.MOUSE_DOWN, FRAME_MOUSE_DOWN);
				super.frame.addEventListener(MouseEvent.CLICK, FRAME_CLICK);
				super.addEventListener(InitScene.RESET_SCENE, ON_RESET_SCENE);
			}else{
				super.frame.removeEventListener(MouseEvent.MOUSE_DOWN, FRAME_MOUSE_DOWN);
				super.frame.removeEventListener(MouseEvent.CLICK, FRAME_CLICK);
				super.removeEventListener(InitScene.RESET_SCENE, ON_RESET_SCENE);
			}
		}
		public function set createdObject(value:String):void{
			if(value == 'addClassicTan'){
				packageTask.addClassicTan();
				return;
			}
			if(value == 'addPalitra'){
				packageTask.addPaintPanel();
				return;
			}
			if(value == 'addButton'){
				this.addButton();
				return;
			}
			/*********************/
			if(value == 'primitiveSet'){
				packageTask.addPrimitiveSet();
				return;
			}
			if(value == 'primitiveKvadr'){
				packageTask.addPrimitiveSquare();
				return;
			}
			if(value == 'primitiveSmalTreug'){
				packageTask.addPrimitiveSmalTriangle();
				return;
			}
			if(value == 'primitiveRectangle'){
				packageTask.addPrimitiveRectangle();
				return;
			}
			if(value == 'primitiveLargeTreug'){
				packageTask.addPrimitiveLargeTriangle();
				return;
			}
			if(value == 'primitiveRound'){
				packageTask.addPrimitiveRound();
				return;
			}
			if(value == 'primitiveSixUgol'){
				packageTask.addPrimitiveHexagon();
				return;
			}
			if(value == 'primitivePalochka'){
				packageTask.addPrimitiveStick();
				return;
			}
			/*********************/
			if(value == 'NumberSet'){
				packageTask.addNumbersSet();
				return;
			}
			if(value == 'NumberZero'){
				packageTask.addNumberZero();
				return;
			}
			if(value == 'NumberOne'){
				packageTask.addNumberOne();
				return;
			}
			if(value == 'NumberTwo'){
				packageTask.addNumberTwo();
				return;
			}
			if(value == 'NumberThree'){
				packageTask.addNumberThree();
				return;
			}
			if(value == 'NumberFour'){
				packageTask.addNumberFour();
				return;
			}
			if(value == 'NumberFive'){
				packageTask.addNumberFive();
				return;
			}
			if(value == 'NumberSix'){
				packageTask.addNumberSix();
				return;
			}
			if(value == 'NumberSeven'){
				packageTask.addNumberSeven();
				return;
			}
			if(value == 'NumberEight'){
				packageTask.addNumberEight();
				return;
			}
			if(value == 'NumberNine'){
				packageTask.addNumberNine();
				return;
			}
			/*********************/
			if(value == 'SymbolPlus'){
				packageTask.addSymbolPlus();
				return;
			}
			if(value == 'SymbolMinus'){
				packageTask.addSymbolMinus();
				return;
			}
			if(value == 'SymbolEqual'){
				packageTask.addSymbolEqual();
				return;
			}
			/*********************/
			if(value == 'classicSet'){
				packageTask.addClassicSet();
				return;
			}
			if(value == 'classicRewordSet'){
				packageTask.addRewordSet();
				return;
			}
			if(value == 'classicLTreung'){
				packageTask.addClassicLarge();
				return;
			}
			if(value == 'classicSredTreung'){
				packageTask.addClassicSred();
				return;
			}
			if(value == 'classicSmalTreung'){
				packageTask.addClassicSmal();
				return;
			}
			if(value == 'classicKvadrat'){
				packageTask.addClassicKvadrat();
				return;
			}
			if(value == 'classicRomb'){
				packageTask.addClassicRomb();
				return;
			}
			/*********************/
			currentObject = value;
			if(value == 'select') {
				simpleDrawer.type = 'dotLine';
				return;
			}
			if(value == 'line') {
				simpleDrawer.type = 'line';
				return;
			}
			simpleDrawer.type = 'else';
			
		}
		public function addButton():void{
			packageTask.addButton();
		}
		public function createNewTask():void{
			packageTask.newTask();
		}
		private function FRAME_MOUSE_DOWN(event:MouseEvent):void{
			trace(this + ': FRAME MOUSE DOWN');
			simpleDrawer.selectObjects(event);
		}
		private function ON_RESET_SCENE(event:Event):void{
			packageTask.reset();
		}
		private function FRAME_CLICK(e:MouseEvent):void{
			packageTask.sWidth = super.stageWidth;
			packageTask.sHeight = super.stageHeight;
			packageTask.CREATE_PANEL_SETTINGS();
			//trace(this + ': CLICK')
		}
		private function SET_FRAME_SIZE(e:Event):void{
			super.stageWidth = packageTask.stageWidth;
			super.stageHeight = packageTask.stageHeight;
		}
		public function set scale(value:Number):void{
			currentScale = value;
		}
		private function CREATE_OBJECT(event:Event):void{
			var obj:Object = event.target.rectangle;
			var size:Number = 1/currentScale;
			if(size!=1){
				obj.width = obj.width*size;
				obj.height = obj.height*size;
			}
			packageTask.setDrawer(obj, currentObject);
		}
		public function set settingsContainer(value:Sprite):void{
			packageTask.settingsContainer = value;
		}
		public function set colorPickerContainer(value:Sprite):void{
			packageTask.colorPickerContainer = value;
		}
		public function set paintContainer(value:Sprite):void{
			packageTask.paintContainer = value;
		}
		public function set layerContainer(value:Sprite):void{
			packageTask.layerContainer = value;
		}
		public function set treeContainer(value:Sprite):void{
			packageTask.treeContainer = value;
		}
		public function addPictAsTan(name:String, bitmap:ByteArray, x:Number, y:Number):void{
			packageTask.addPictAsTan(name, bitmap, x, y);
		}
		public function addSwfObject(name:String, swf:ByteArray, x:Number, y:Number):void{
			packageTask.addSwfObject(name, swf, x, y);
		}
		public function addCharisProgram(name:String, text:ByteArray):void{
			packageTask.addCharisProgram(name, text, super.stageWidth, super.stageHeight);
		}
		public function addPictureInPaint(value:ByteArray, name:String):void{
			packageTask.addPictureInPaint(value, name);
		}
		public function addFigure(value:Object, x:Number, y:Number):void{
			packageTask.addFigure(value, x, y);
		}
		public function loadTaskFromFileList(currentTask:String, arrData:Array):void{
			var task:XMLList = Converter.getXMLTask(currentTask);
			packageTask.setNewTask(task, arrData);
		}
		public function allTaskClear():void{
			packageTask.fullClear();
		}
		public function currentTaskClear():void{
			packageTask.currentClear();
		}
		
		public function get isCorrectPosition():Boolean{
			return packageTask.isCorrectPosition;
		}
		public function normalizePosition():void{
			packageTask.normalizePosition();
		}
		
		public function getUserContent():Object{
			return packageTask.userContent();
		}
		public function getTaskFile():String{
			var outStr:String = packageTask.listPosition.toString();
			return outStr;
		}
		public function getCurrentTaskFile():String{
			var outStr:String = packageTask.currentListPosition.toString();
			return outStr;
		}
		public function get taskForDificultArchive():Array{
			var taskXml:String = packageTask.listPosition.toString();
			var outArr:Array = TreeConverter.convert(taskXml);
			var i:int;
			var l:int;
			l = outArr.length;
			return outArr;
		}
		
		public function setBlackOnColor():void{
			packageTask.setBlackOnColor();
		}
		public function setColorOnBlack():void{
			packageTask.setColorOnBlack();
		}
		public function userTanOnPicture():void{
			packageTask.userTanOnPicture();
		}
		
		public function get checkPaintColors():Boolean{
			return packageTask.checkPaintColors;
		}
	}
}
