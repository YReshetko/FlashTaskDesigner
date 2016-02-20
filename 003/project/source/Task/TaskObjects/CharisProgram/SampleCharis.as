package source.Task.TaskObjects.CharisProgram {
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import source.Task.TaskObjects.CharisProgram.CharisSystem.CharisStage;
	import source.Task.TaskObjects.Label.LabelClass;
	import flash.errors.EOFError;
	import source.Task.TaskObjects.CharisProgram.CharisEngine.CharisEngineController;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.Event;
	import source.Task.OneTask;
	import source.Task.TaskObjects.Label.ExtendLabel;
	import source.Task.TaskObjects.CharisProgram.CharisSystem.SchemStage;
	import source.Task.TaskObjects.CharisProgram.CharisSystem.FieldStage;
	
	public class SampleCharis extends Sprite{
		public static const GET_SETTINGS:String = "onGetSettings";
		public static const TEXT_FIELD_GET_SETTINGS:String = "onTextFieldGetSettings";
		public static const TASK_TEXT_FIELD_GET_SETTINGS:String = "onTaskTextFieldGetSettings";
		
		private static const LABEL_PROGRAM:String = "Программа";
		private static const LABEL_PICTURE:String = "Рисунок";
		private static const LABEL_SCHEMA:String = "Схема";
		
		private static const EXAMPLE_PROGRAM:int = 1;
		private static const EXAMPLE_PICTURE:int = 2;
		private static const EXAMPLE_SCHEMA:int = 3;
		
		private static const TASK_PICTURE:int = 1;
		private static const TASK_SCHEMA:int = 2;
		private static const TASK_PROGRAM:int = 3;
		
		private var taskStage:CharisStage;
		private var taskSchem:SchemStage;
		
		private var taskProgram:FieldStage;
		
		private var exampleStage:CharisStage;
		private var exampleSchem:SchemStage;
		
		private var exampleField:LabelClass;
		
		private var engine:CharisEngineController;
		
		private var fileName:String;
		
		private var ceilSize:Number;
		private var cols:int;
		private var rows:int;
		
		private var ceilSizeSchem:Number;
		private var colsSchem:int;
		private var rowsSchem:int;
		
		private var leftX:Number;
		private var leftY:Number;
		private var rightX:Number;
		private var rightY:Number;
		private var taskType:int;
		private var exampleType:int;
		private var brashColor:uint;
		private var fillColor:uint;
		
		private var labelXml:XMLList;
		private var taskFieldXml:XMLList;
		
		private var container:Sprite;
		
		private var xmlTaskEntity:XMLList;
		private var xmlExampleEntity:XMLList;
		
		private var donotknowSimulation:Boolean;
		private var isSimulation:Boolean;
		private var checkBySchem:Boolean;
		private var checkByPicture:Boolean;
		private var showMisstakes:Boolean;
		private var otherImplimentation:Boolean;
		
		private var isUseButtons:Boolean;
		private var isCheckAutomaticly:Boolean;
		private var isUseShortCommands:Boolean;
		private var isUseFullCommand:Boolean;
		
		private var simulationButton:CharisButton;
		
		private var buttons:Array = [{clip:new CharisLeftButton(),			object:new CharisButton(), name:"CharisLeftButton", 		y:427, x:228, alpha: 0},
									 {clip:new CharisRightButton(),			object:new CharisButton(), name:"CharisRightButton", 		y:427, x:290, alpha: 0},
									 {clip:new CharisDownButton(),			object:new CharisButton(), name:"CharisDownButton", 		y:458, x:259, alpha: 0},
									 {clip:new CharisUpButton(),			object:new CharisButton(), name:"CharisUpButton", 			y:396, x:259, alpha: 0},
									 {clip:new CharisLeftDownButton(),		object:new CharisButton(), name:"CharisLeftDownButton", 	y:458, x:228, alpha: 0},
									 {clip:new CharisLeftUpButton(),		object:new CharisButton(), name:"CharisLeftUpButton",		y:396, x:228, alpha: 0},
									 {clip:new CharisRightDownButton(),		object:new CharisButton(), name:"CharisRightDownButton", 	y:458, x:290, alpha: 0},
									 {clip:new CharisRightUpButton(),		object:new CharisButton(), name:"CharisRightUpButton", 		y:396, x:290, alpha: 0},
									 {clip:new CharisJumpLeftButton(),		object:new CharisButton(), name:"CharisJumpLeftButton", 	y:538, x:39 , alpha: 0},
									 {clip:new CharisJumpRightButton(),		object:new CharisButton(), name:"CharisJumpRightButton", 	y:396, x:328, alpha: 0},
									 {clip:new CharisJumpDownButton(),		object:new CharisButton(), name:"CharisJumpDownButton", 	y:396, x:359, alpha: 0},
									 {clip:new CharisJumpUpButton(),		object:new CharisButton(), name:"CharisJumpUpButton", 		y:538, x:70 , alpha: 0},
									 {clip:new CharisJumpLeftDownButton(),	object:new CharisButton(), name:"CharisJumpLeftDownButton", y:538, x:101, alpha: 0},
									 {clip:new CharisJumpLeftUpButton(),	object:new CharisButton(), name:"CharisJumpLeftUpButton", 	y:538, x:163, alpha: 0},
									 {clip:new CharisJumpRightDownButton(),	object:new CharisButton(), name:"CharisJumpRightDownButton",y:538, x:194, alpha: 0},
									 {clip:new CharisJumpRightUpButton(),	object:new CharisButton(), name:"CharisJumpRightUpButton", 	y:538, x:132, alpha: 0},
									 {clip:new CharisBackUpButton(),		object:new CharisButton(), name:"CharisBackUpButton", 		y:498, x:349, alpha: 0},
									 {clip:new CharisBackDownButton(),		object:new CharisButton(), name:"CharisBackDownButton", 	y:498, x:382, alpha: 0},
									 {clip:new CharisFillButton(),			object:new CharisButton(), name:"CharisFillButton", 		y:427, x:328, alpha: 0},
									 {clip:new CharisWormTortue(),			object:new CharisButton(), name:"CharisWormTortue", 		y:396, x:397, alpha: 0},
									 {clip:new CharisJumpZeroButton(),		object:new CharisButton(), name:"CharisJumpZeroButton", 	y:427, x:259, alpha: 0},
									 {clip:new CharisCircleButton(),		object:new CharisButton(), name:"CharisCircleButton", 		y:427, x:359, alpha: 0},
									 {clip:new CharisSimulationButton(),	object:new CharisButton(), name:"CharisSimulationButton", 	y:498, x:300, alpha: 0}];
		
		public function SampleCharis(xml:XMLList, text:ByteArray, container:Sprite) {
			super();
			this.container = container;
			init(text, xml);
			runProgram();
		}
		private function init(text:ByteArray, xml:XMLList):void{
			engine = new CharisEngineController(text);
			parse(xml);
			
			taskStage = new CharisStage(ceilSize, cols, rows, fillColor, brashColor, false);
			taskStage.listPosition = xmlTaskEntity;
			taskSchem = new SchemStage(ceilSizeSchem, colsSchem, rowsSchem, fillColor, brashColor, false);
			taskSchem.listPosition = xmlTaskEntity;
			exampleStage = new CharisStage(ceilSize, cols, rows, fillColor, brashColor, true);
			exampleStage.listPosition = xmlExampleEntity;
			exampleSchem = new SchemStage(ceilSizeSchem, colsSchem, rowsSchem, fillColor, brashColor, true);
			exampleSchem.listPosition = xmlExampleEntity;
			
			exampleField = new LabelClass(labelXml, this, this, this);
			exampleField.reset();
			
			if(taskFieldXml==null){
				taskFieldXml = createNormalTaskProgramXml(labelXml);
			}
			taskProgram = new FieldStage(taskFieldXml, this, this, this);  
			taskProgram.reset();
			
			super.addChild(taskStage);
			super.addChild(exampleStage);
			super.addChild(taskSchem);
			super.addChild(exampleSchem);
			
			reBuildCharisTask();
			
			var i:int;
			var l:int;
			l = buttons.length;
			for(i=0;i<l;i++){
				super.addChild(buttons[i].object as CharisButton);
			}
			initHandlers();
		}
		
		private function reBuildCharisTask():void{
			taskStage.visible = false;
			exampleStage.visible = false;
			taskSchem.visible = false;
			exampleSchem.visible = false;
			exampleField.tanColor.visible = false;
			taskProgram.tanColor.visible = false;
			switch(taskType){
				case TASK_PICTURE:
				taskStage.visible = true;
				break;
				case TASK_SCHEMA:
				taskSchem.visible = true;
				break;
				case TASK_PROGRAM:
				taskProgram.tanColor.visible = true;
				break;
			}
			switch(exampleType){
				case EXAMPLE_PICTURE:
				exampleStage.visible = true;
				break;
				case EXAMPLE_PROGRAM:
				exampleField.tanColor.visible = true;
				break;
				case EXAMPLE_SCHEMA:
				exampleSchem.visible = true;
				break;
			}
		}
		
		private function initHandlers():void{
			taskStage.addEventListener(MouseEvent.MOUSE_DOWN, TASK_STAGE_MOUSE_DOWN);
			taskSchem.addEventListener(MouseEvent.MOUSE_DOWN, TASK_SCHEM_MOUSE_DOWN);
			exampleStage.addEventListener(MouseEvent.MOUSE_DOWN, EXAMPLE_STAGE_MOUSE_DOWN);
			exampleSchem.addEventListener(MouseEvent.MOUSE_DOWN, EXAMPLE_SCHEM_MOUSE_DOWN);
			exampleField.addEventListener(ExtendLabel.GET_SETTINGS, FIELD_GET_SETTINGS);
			taskProgram.addEventListener(ExtendLabel.GET_SETTINGS, TASK_FIELD_GET_SETTINGS);
		}
		private function TASK_STAGE_MOUSE_DOWN(event:MouseEvent):void{
			stageStartDrag(taskStage);
		}
		private function TASK_SCHEM_MOUSE_DOWN(event:MouseEvent):void{
			stageStartDrag(taskSchem);
		}
		private function EXAMPLE_STAGE_MOUSE_DOWN(event:MouseEvent):void{
			stageStartDrag(exampleStage);
		}
		private function EXAMPLE_SCHEM_MOUSE_DOWN(event:MouseEvent):void{
			stageStartDrag(exampleSchem);
		}
		private function stageStartDrag(target:Sprite):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, STAGE_MOUSE_UP);
			target.startDrag();
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function STAGE_MOUSE_UP(event:MouseEvent):void{
			stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, STAGE_MOUSE_UP);
		}
		private function FIELD_GET_SETTINGS(event:Event):void{
			super.dispatchEvent(new Event(TEXT_FIELD_GET_SETTINGS));
		}
		private function TASK_FIELD_GET_SETTINGS(event:Event):void{
			super.dispatchEvent(new Event(TASK_TEXT_FIELD_GET_SETTINGS));
		}
		public function clear():void{
			
		}
		public function reset():void{
			exampleField.reset();
			taskProgram.reset();
		}
		
		public function get textField():LabelClass{
			return exampleField;
		}
		public function get taskField():LabelClass{
			return taskProgram;
		}
		
		public function get sectorSize():Number{
			return ceilSize;
		}
		public function set sectorSize(value:Number):void{
			ceilSize = value;
			rebuildStages();
		}
		
		public function get sectorSizeSchem():Number{
			return ceilSizeSchem;
		}
		public function set sectorSizeSchem(value:Number):void{
			ceilSizeSchem = value;
			rebuildStages();
		}
		
		public function get numColumn():int{
			return cols;
		}
		public function set numColumn(value:int):void{
			cols = value;
			rebuildStages();
		}
		
		public function get numColumnSchem():int{
			return colsSchem;
		}
		public function set numColumnSchem(value:int):void{
			colsSchem = value;
			rebuildStages();
		}
		
		public function get numLines():int{
			return rows;
		}
		public function set numLines(value:int):void{
			rows = value;
			rebuildStages();
		}
		
		public function get numLinesSchem():int{
			return rowsSchem;
		}
		public function set numLinesSchem(value:int):void{
			rowsSchem = value;
			rebuildStages();
		}
		
		private function rebuildStages():void{
			taskSchem.numLines = exampleSchem.numLines = rowsSchem;
			taskStage.numLines = exampleStage.numLines = rows;
			taskSchem.numColumns = exampleSchem.numColumns = colsSchem;
			taskStage.numColumns = exampleStage.numColumns = cols;
			taskSchem.sectorSize = exampleSchem.sectorSize = ceilSizeSchem;
			taskStage.sectorSize = exampleStage.sectorSize = ceilSize;
			taskSchem.drawStage();
			exampleSchem.drawStage();
			taskStage.drawStage();
			exampleStage.drawStage();
			runProgram();
		}
		
		public function get colorFill():uint{
			return fillColor;
		}
		public function set colorFill(value:uint):void{
			fillColor = value;
			taskStage.colorFill = value;
			runProgram();
		}
		
		public function get colorBrush():uint{
			return brashColor;
		}
		public function set colorBrush(value:uint):void{
			brashColor = value;
			taskStage.colorBrush = value;
			runProgram();
		}
		
		public function set typeTask(value:String):void{
			switch(value){
				case LABEL_PICTURE:
				taskType = TASK_PICTURE;
				break;
				case LABEL_SCHEMA:
				taskType = TASK_SCHEMA;
				break;
				case LABEL_PROGRAM:
				taskType = TASK_PROGRAM;
				break;
			}
			reBuildCharisTask();
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		
		public function get typeTask():String{
			switch(taskType){
				case TASK_PICTURE:
				return LABEL_PICTURE;
				case TASK_SCHEMA:
				return LABEL_SCHEMA;
				case TASK_PROGRAM:
				return LABEL_PROGRAM;
			}
			return LABEL_PICTURE;
		}
		
		public function set typeExample(value:String):void{
			switch(value){
				case LABEL_PICTURE:
				exampleType = EXAMPLE_PICTURE;
				break;
				case LABEL_SCHEMA:
				exampleType = EXAMPLE_SCHEMA;
				break;
				case LABEL_PROGRAM:
				exampleType = EXAMPLE_PROGRAM;
				break;
			}
			reBuildCharisTask();
		}
		
		public function get typeExample():String{
			switch(exampleType){
				case EXAMPLE_PICTURE:
				return LABEL_PICTURE;
				case EXAMPLE_SCHEMA:
				return LABEL_SCHEMA;
				case EXAMPLE_PROGRAM:
				return LABEL_PROGRAM;
			}
			return LABEL_PROGRAM;
		}
		
		
		
		public function get dkSimulation():Boolean{
			return donotknowSimulation;
		}
		public function set dkSimulation(value:Boolean):void{
			donotknowSimulation = value;
		}
		
		public function get simulation():Boolean{
			return isSimulation;
		}
		public function set simulation(value:Boolean):void{
			isSimulation = value;
			simulationButton.visible = value;
		}
		
		public function get schemChecker():Boolean{
			return checkBySchem;
		}
		public function set schemChecker(value:Boolean):void{
			checkBySchem = value;
			if(value){
				pictureChecker = false;
				super.dispatchEvent(new Event(GET_SETTINGS));
			}
		}
		
		public function get pictureChecker():Boolean{
			return checkByPicture;
		}
		public function set pictureChecker(value:Boolean):void{
			checkByPicture = value;
			if(value){
				schemChecker = false;
				super.dispatchEvent(new Event(GET_SETTINGS));
			}
		}
		public function set isShowMisstakes(value:Boolean):void{
			showMisstakes = value;
		}
		
		public function get isShowMisstakes():Boolean{
			return showMisstakes;
		}
		
		public function set isOtherImplimentation(value:Boolean):void{
			otherImplimentation = value;
		}
		
		public function get isOtherImplimentation():Boolean{
			return otherImplimentation;
		}
		
		public function get buttonAlpha():Number{
			return buttons[0].object.alpha;
		}
		public function set buttonAlpha(value:Number):void{
			var i:int;
			var l:int = buttons.length;
			for(i=0;i<l;i++){
				buttons[i].object.alpha = value;
			}
		}
		
		
		public function set checkAutomaticly(value:Boolean):void{
			isCheckAutomaticly = value;
		}
		
		public function get checkAutomaticly():Boolean{
			return isCheckAutomaticly;
		}
		public function set useButtons(value:Boolean):void{
			isUseButtons = value;
		}
		
		public function get useButtons():Boolean{
			return isUseButtons;
		}
		
		public function set useShortCommands(value:Boolean):void{
			isUseShortCommands = value;
		}
		
		public function get useShortCommands():Boolean{
			return isUseShortCommands;
		}
		
		public function set useFullCommand(value:Boolean):void{
			isUseFullCommand = value;
		}
		
		public function get useFullCommand():Boolean{
			return isUseFullCommand;
		}
		
		private function runProgram():void{
			engine.setRobot(taskStage.getRobot());
			engine.execute();
			engine.setRobot(taskSchem.getRobot());
			engine.execute();
			engine.setRobot(exampleStage.getRobot());
			engine.execute();
			engine.setRobot(exampleSchem.getRobot());
			engine.execute();
		}
		private function parse(xml:XMLList):void{
			fileName = xml.@content;
			ceilSize = parseFloat(xml.@ceil_size);
			cols = parseInt(xml.@cols);
			rows = parseInt(xml.@rows);
			
			ceilSizeSchem = parseFloat(xml.@ceilSizeSchem);
			colsSchem = parseInt(xml.@colsSchem);
			rowsSchem = parseInt(xml.@rowsSchem);
			
			taskType = parseInt(xml.@taskType);
			exampleType = parseInt(xml.@exampleType);
			brashColor = xml.@brash_color;
			fillColor = xml.@fill_color;
			
			if(xml.@isUseButtons.toString() != ""){
				if(xml.@isUseButtons.toString() == "true") isUseButtons = true else isUseButtons = false;
			}else{
				isUseButtons = true;
			}
			if(xml.@isCheckAutomaticly.toString()!= ""){
				if(xml.@isCheckAutomaticly.toString() == "true") isCheckAutomaticly = true else isCheckAutomaticly = false;
			}else{
				isCheckAutomaticly = true;
			}
			
			
			if(xml.@isUseShortCommands.toString()!= ""){
				if(xml.@isUseShortCommands.toString() == "true") isUseShortCommands = true else isUseShortCommands = false;
			}else{
				isUseShortCommands = true;
			}
			
			if(xml.@isUseFullCommand.toString()!= ""){
				if(xml.@isUseFullCommand.toString() == "true") isUseFullCommand = true else isUseFullCommand = false;
			}else{
				isUseFullCommand = true;
			}

			
			labelXml = xml.LABEL;
			if(xml.TASKLABEL.toString()!="") taskFieldXml = xml.TASKLABEL.LABEL;
			
			donotknowSimulation = (xml.@donotknowSimulation.toString() == "true")?true:false;
			isSimulation = (xml.@isSimulation.toString() == "true")?true:false;
			checkBySchem = (xml.@checkBySchem.toString() == "true")?true:false;
			checkByPicture = (xml.@checkByPicture.toString() == "true")?true:false;
			showMisstakes = (xml.@showMisstakes.toString() == "true")?true:false;
			otherImplimentation = (xml.@otherImplimentation.toString() == "true")?true:false;
			
			//labelXml.text = "<![CDATA["+programText+"]]>";
			labelXml.appendChild(new XML('<TEXT><![CDATA['+engine.text+']]></TEXT>'));
			
			for each(var samp:XML in xml.ENTITY){
				if(samp.@isExample.toString() == "true"){
					xmlExampleEntity = new XMLList(samp);
				}else{
					xmlTaskEntity = new XMLList(samp);
				}
			}
			if(xmlExampleEntity == null){
				xmlExampleEntity = new XMLList('<ENTITY isExample="true" x="10" y="10"/>');
			}
			var i:int;
			var l:int;
			l = buttons.length;
			for(i=0;i<l;i++){
				(buttons[i].object as CharisButton).button = buttons[i].clip;
				(buttons[i].object as CharisButton).name = buttons[i].name;
				(buttons[i].object as CharisButton).x = buttons[i].x;
				(buttons[i].object as CharisButton).y = buttons[i].y;
				(buttons[i].object as CharisButton).alpha = buttons[i].alpha;
				if(buttons[i].name == "CharisSimulationButton"){
					simulationButton = (buttons[i].object as CharisButton);
				}
			}
			for each(var but:XML in xml.BUTTON){
				for(i=0;i<l;i++){
					if(buttons[i].name == but.@name){
						(buttons[i].object as CharisButton).x = parseFloat(but.@x);
						(buttons[i].object as CharisButton).y = parseFloat(but.@y);
						(buttons[i].object as CharisButton).alpha = parseFloat(but.@alpha);
					}
				}
			}
			simulationButton.visible = isSimulation;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ЧЯРИС';
			var sizeList:XMLList = new XMLList('<FIELD label="размер ячейки" type="number" variable="sectorSize" width="40">' + this.sectorSize.toString() + '</FIELD>');
			var colsList:XMLList = new XMLList('<FIELD label="количество столбцов" type="number" variable="numColumn" width="40">' + this.numColumn.toString() + '</FIELD>');
			var rowsList:XMLList = new XMLList('<FIELD label="количество строк" type="number" variable="numLines" width="40">' + this.numLines.toString() + '</FIELD>');
			var blockList:XMLList = new XMLList('<BLOCK label="координатная плоскость"/>');
			blockList.appendChild(sizeList);
			blockList.appendChild(colsList);
			blockList.appendChild(rowsList);
			outXml.appendChild(blockList);
			
			var sizeListSchem:XMLList = new XMLList('<FIELD label="размер ячейки" type="number" variable="sectorSizeSchem" width="40">' + this.sectorSizeSchem.toString() + '</FIELD>');
			var colsListSchem:XMLList = new XMLList('<FIELD label="количество столбцов" type="number" variable="numColumnSchem" width="40">' + this.numColumnSchem.toString() + '</FIELD>');
			var rowsListSchem:XMLList = new XMLList('<FIELD label="количество строк" type="number" variable="numLinesSchem" width="40">' + this.numLinesSchem.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="схема"/>');
			blockList.appendChild(sizeListSchem);
			blockList.appendChild(colsListSchem);
			blockList.appendChild(rowsListSchem);
			outXml.appendChild(blockList);
			
			var taskXml:XMLList = new XMLList('<CHECK/>');
			taskXml.@variable = 'typeTask';
			taskXml.appendChild(new XML('<DATA>'+LABEL_PICTURE+'</DATA>'));
			taskXml.appendChild(new XML('<DATA>'+LABEL_SCHEMA+'</DATA>'));
			taskXml.appendChild(new XML('<DATA>'+LABEL_PROGRAM+'</DATA>'));
			taskXml.appendChild(new XML('<CURRENTDATA>' + typeTask + '</CURRENTDATA>'));
			
			blockList = new XMLList('<BLOCK label="тип задания"/>');
			blockList.appendChild(taskXml);
			outXml.appendChild(blockList);
			
			
			
			taskXml = new XMLList('<CHECK/>');
			taskXml.@variable = 'typeExample';
			taskXml.appendChild(new XML('<DATA>'+LABEL_PROGRAM+'</DATA>'));
			taskXml.appendChild(new XML('<DATA>'+LABEL_PICTURE+'</DATA>'));
			taskXml.appendChild(new XML('<DATA>'+LABEL_SCHEMA+'</DATA>'));
			taskXml.appendChild(new XML('<CURRENTDATA>' + typeExample + '</CURRENTDATA>'));
			
			blockList = new XMLList('<BLOCK label="тип примера"/>');
			blockList.appendChild(taskXml);
			outXml.appendChild(blockList);
			
			
			var isOtherImplimentationXml:XMLList = new XMLList('<MARK label="сделать другую реализацию" variable="isOtherImplimentation">'+this.isOtherImplimentation.toString()+'</MARK>');
			var isShowMisstakesXml:XMLList = new XMLList('<MARK label="показывать ошибки" variable="isShowMisstakes">'+this.isShowMisstakes.toString()+'</MARK>');
			var pictureCheckerXml:XMLList = new XMLList('<MARK label="проверять по картинке" variable="pictureChecker">'+this.pictureChecker.toString()+'</MARK>');
			var schemCheckerXml:XMLList = new XMLList('<MARK label="проверять по схеме" variable="schemChecker">'+this.schemChecker.toString()+'</MARK>');
			var simulationXml:XMLList = new XMLList('<MARK label="симуляция схемы учащегося" variable="simulation">'+this.simulation.toString()+'</MARK>');
			var dkSimulationXml:XMLList = new XMLList('<MARK label="симуляция в Не знаю" variable="dkSimulation">'+this.dkSimulation.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="дополнительные настройки"/>');
			blockList.appendChild(simulationXml);
			blockList.appendChild(dkSimulationXml);
			blockList.appendChild(schemCheckerXml);
			blockList.appendChild(pictureCheckerXml);
			blockList.appendChild(isOtherImplimentationXml);
			blockList.appendChild(isShowMisstakesXml);
			outXml.appendChild(blockList);
			
			
			if(taskType == TASK_PROGRAM){
				var isCheckAutomaticlyXml:XMLList = new XMLList('<MARK label="проверять задание автоматически" variable="checkAutomaticly">'+this.checkAutomaticly.toString()+'</MARK>');
				var isUseButtonsXml:XMLList = new XMLList('<MARK label="использовать кнопки" variable="useButtons">'+this.useButtons.toString()+'</MARK>');
				var isUseShortCommandsXml:XMLList = new XMLList('<MARK label="использовать короткие команды" variable="useShortCommands">'+this.useShortCommands.toString()+'</MARK>');
				var isUseFullCommandXml:XMLList = new XMLList('<MARK label="использовать длинные команды" variable="useFullCommand">'+this.useFullCommand.toString()+'</MARK>');
				
				blockList = new XMLList('<BLOCK label="настройки для задания с полем ввода"/>');
				blockList.appendChild(isUseButtonsXml);
				blockList.appendChild(isCheckAutomaticlyXml);
				
				blockList.appendChild(isUseShortCommandsXml);
				blockList.appendChild(isUseFullCommandXml);
				outXml.appendChild(blockList);
			}
			
			var buttonAlphaXML:XMLList = new XMLList('<FIELD label="Прозрачность фона" type="number" variable="buttonAlpha" width="40">' + this.buttonAlpha.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="настройки кнопок"/>');
			blockList.appendChild(buttonAlphaXML);
			outXml.appendChild(blockList);
			
			return outXml;
		}
		
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="colorFill">' + this.colorFill.toString() + '</COLOR>'));
			outXml.appendChild(new XML('<COLOR label="line" variable="colorBrush">' + this.colorBrush.toString() + '</COLOR>'));
			//outXml.appendChild(new XML('<COLOR label="text" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<CHARIS/>');
			
			outXml.@content = fileName;
			outXml.@ceil_size = ceilSize;
			outXml.@cols = cols;
			outXml.@rows = rows;
			
			outXml.@ceilSizeSchem = ceilSizeSchem;
			outXml.@colsSchem = colsSchem;
			outXml.@rowsSchem = rowsSchem;
			
			outXml.@taskType = taskType;
			outXml.@exampleType = exampleType;
			outXml.@brash_color = brashColor;
			outXml.@fill_color = fillColor;
			
			outXml.@donotknowSimulation = donotknowSimulation;
			outXml.@isSimulation = isSimulation;
			outXml.@checkBySchem = checkBySchem;
			outXml.@checkByPicture = checkByPicture;
			outXml.@showMisstakes = showMisstakes;
			outXml.@otherImplimentation = otherImplimentation;
			
			outXml.@isUseButtons = isUseButtons;
			outXml.@isCheckAutomaticly = isCheckAutomaticly;
			
			outXml.@isUseShortCommands = isUseShortCommands;
			outXml.@isUseFullCommand = isUseFullCommand;
			
			var i:int;
			var l:int;
			l = buttons.length;
			for(i=0;i<l;i++){
				outXml.appendChild((buttons[i].object as CharisButton).listPosition);
			}
			
			var labelXML:XMLList = exampleField.listPosition;
			labelXML.replace("TEXT", "");
			
			switch(taskType){
				case TASK_PICTURE:
				outXml.appendChild(taskStage.listPosition);
				break;
				case TASK_SCHEMA:
				outXml.appendChild(taskSchem.listPosition);
				break;
				case TASK_PROGRAM:
				var taskProgramXML:XMLList = new XMLList("<TASKLABEL/>");
				taskProgramXML.appendChild(taskProgram.listPosition);
				outXml.appendChild(taskProgramXML);
				break;
			}
			switch(exampleType){
				case EXAMPLE_PICTURE:
				outXml.appendChild(exampleStage.listPosition);
				break;
				case EXAMPLE_SCHEMA:
				outXml.appendChild(exampleSchem.listPosition);
				break;
			}
			outXml.LABEL = labelXML;
			
			return outXml;
		}
		
		private function createNormalTaskProgramXml(value:XMLList):XMLList{
			var out:XMLList = value.copy();
			out.X = xmlTaskEntity.@x;
			out.TEXT = new XMLList("<TEXT><![CDATA[uses charis;\nbegin\n\n  pause;\nend.]]></TEXT>");
			//labelXml.replace("TYPE", "");
			out.appendChild(new XMLList('<CORRECTTEXT isUse="true"><![CDATA[uses charis;\nbegin\n\n  pause;\nend.]]></CORRECTTEXT>'));
			out.TYPE.@name = "INPUT";
			out.TYPE.appendChild(new XMLList("<TYPEINPUT>Nothing</TYPEINPUT>"));
			out.TYPE.appendChild(new XMLList("<CORRECTCOLOR>0xff00</CORRECTCOLOR>"));
			out.TYPE.appendChild(new XMLList("<INCORRECTCOLOR>0xff0000</INCORRECTCOLOR>"));
			out.TYPE.appendChild(new XMLList("<REGISTR>true</REGISTR>"));
			out.TYPE.appendChild(new XMLList("<DEFAULTTEXT><![CDATA[]]></DEFAULTTEXT>"));
			out.TYPE.appendChild(new XMLList("<MAXLENGTH>0</MAXLENGTH>"));
			out.TYPE.appendChild(new XMLList("<RESTRICT/>"));
			out.TYPE.appendChild(new XMLList("<MULTILINE>true</MULTILINE>"));
			out.TYPE.appendChild(new XMLList("<LASTSPACE>false</LASTSPACE>"));
			
			out.appendChild(new XMLList("<VARIABLE/>"));
            out.appendChild(new XMLList("<RANDOM/>"));
        	out.appendChild(new XMLList("<FORMULA/>"));
		
			out.appendChild(new XMLList('<SHOWING action="false"/>'));
       		out.appendChild(new XMLList('<ADDITIONAL_PARAMETERS number="0"/>'));
		
			trace(out);
			return out;
		}
	}
	
}
