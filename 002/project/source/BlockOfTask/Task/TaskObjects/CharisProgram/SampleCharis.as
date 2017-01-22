

package source.BlockOfTask.Task.TaskObjects.CharisProgram {
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.CharisStage;
	import source.BlockOfTask.Task.TaskObjects.Label.LabelClass;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.CharisEngineController;
	import flash.events.Event;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.IRobotCommand;
	import source.BlockOfTask.Task.SeparatTask;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.SchemStage;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.ICharisSimulation;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.CharisDontKnowSimulation;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.ProgramStage;
	
	public class SampleCharis extends Sprite{
		private static const EXAMPLE_PROGRAM:int = 1;
		private static const EXAMPLE_PICTURE:int = 2;
		private static const EXAMPLE_SCHEMA:int = 3;
		
		private static const TASK_PICTURE:int = 1;
		private static const TASK_SCHEMA:int = 2;
		private static const TASK_PROGRAM:int = 3;
		
		private var taskStage:CharisStage;
		private var taskSchem:SchemStage;
		
		private var exampleStage:CharisStage;
		private var exampleSchem:SchemStage;
		
		private var exampleField:LabelClass;
		private var taskProgram:ProgramStage;
		
		private var engine:CharisEngineController;
		private var additionalEngine:CharisEngineController;
		
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
		
		private var container:Sprite;
		
		private var xmlTaskEntity:XMLList;
		private var xmlExampleEntity:XMLList;
		
		private var taskFieldXml:XMLList;
		
		private var wormTurtleButton:CharisButton;
		
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
		
		private var simulation:ICharisSimulation;
		
		private var buttons:Array = [{clip:new CharisLeftButton(),			object:new CharisButton(), name:"CharisLeftButton", y:350, x:6},
									 {clip:new CharisRightButton(),			object:new CharisButton(), name:"CharisRightButton", y:350, x:56},
									 {clip:new CharisDownButton(),			object:new CharisButton(), name:"CharisDownButton", y:350, x:106},
									 {clip:new CharisUpButton(),			object:new CharisButton(), name:"CharisUpButton", y:350, x:156},
									 {clip:new CharisLeftDownButton(),		object:new CharisButton(), name:"CharisLeftDownButton", y:350, x:206},
									 {clip:new CharisLeftUpButton(),		object:new CharisButton(), name:"CharisLeftUpButton", y:350, x:256},
									 {clip:new CharisRightDownButton(),		object:new CharisButton(), name:"CharisRightDownButton", y:350, x:306},
									 {clip:new CharisRightUpButton(),		object:new CharisButton(), name:"CharisRightUpButton", y:350, x:356},
									 {clip:new CharisJumpLeftButton(),		object:new CharisButton(), name:"CharisJumpLeftButton", y:400, x:6},
									 {clip:new CharisJumpRightButton(),		object:new CharisButton(), name:"CharisJumpRightButton", y:400, x:56},
									 {clip:new CharisJumpDownButton(),		object:new CharisButton(), name:"CharisJumpDownButton", y:400, x:106},
									 {clip:new CharisJumpUpButton(),		object:new CharisButton(), name:"CharisJumpUpButton", y:400, x:156},
									 {clip:new CharisJumpLeftDownButton(),	object:new CharisButton(), name:"CharisJumpLeftDownButton", y:400, x:206},
									 {clip:new CharisJumpLeftUpButton(),	object:new CharisButton(), name:"CharisJumpLeftUpButton", y:400, x:256},
									 {clip:new CharisJumpRightDownButton(),	object:new CharisButton(), name:"CharisJumpRightDownButton", y:400, x:306},
									 {clip:new CharisJumpRightUpButton(),	object:new CharisButton(), name:"CharisJumpRightUpButton", y:400, x:356},
									 {clip:new CharisBackUpButton(),		object:new CharisButton(), name:"CharisBackUpButton", y:400, x:416},
									 {clip:new CharisBackDownButton(),		object:new CharisButton(), name:"CharisBackDownButton", y:400, x:466},
									 {clip:new CharisFillButton(),			object:new CharisButton(), name:"CharisFillButton", y:400, x:516},
									 {clip:new CharisWormTortue(),			object:new CharisButton(), name:"CharisWormTortue", y:400, x:566},
									 {clip:new CharisJumpZeroButton(),		object:new CharisButton(), name:"CharisJumpZeroButton", y:400, x:616},
									 {clip:new CharisCircleButton(),		object:new CharisButton(), name:"CharisCircleButton", y:400, x:666},
									 {clip:new CharisSimulationButton(),	object:new CharisButton(), name:"CharisSimulationButton", 	y:498, x:300}];
		
		public function SampleCharis(xml:XMLList, text:ByteArray, container:Sprite) {
			super();
			this.container = container;
			
			init(text, xml);
			startWork();
		}
		private function init(text:ByteArray, xml:XMLList):void{
			engine = new CharisEngineController(text);
			additionalEngine = new CharisEngineController(new ByteArray());
			parse(xml);
			
			taskStage = new CharisStage(ceilSize, cols, rows, fillColor, brashColor);
			taskStage.listPosition = xmlTaskEntity;
			taskSchem = new SchemStage(ceilSizeSchem, colsSchem, rowsSchem, fillColor, brashColor);
			taskSchem.listPosition = xmlTaskEntity;
			exampleStage = new CharisStage(ceilSize, cols, rows, fillColor, brashColor);
			exampleStage.listPosition = xmlExampleEntity;
			exampleSchem = new SchemStage(ceilSizeSchem, colsSchem, rowsSchem, fillColor, brashColor);
			exampleSchem.listPosition = xmlExampleEntity;
			
			if(taskFieldXml != null){
				taskProgram = new ProgramStage(taskFieldXml, this, this, this);  
			}
			
			exampleField = new LabelClass(labelXml, this, this, this);
			labelXml.replace("TEXT", "");
			
			super.addChild(taskStage);
			super.addChild(exampleStage);
			super.addChild(taskSchem);
			super.addChild(exampleSchem);
			reBuildCharisTask();
			if(taskProgram==null || (taskProgram!=null && isUseButtons)){
				var i:int;
				var l:int;
				l = buttons.length;
				for(i=0;i<l;i++){
					super.addChild(buttons[i].object as CharisButton);
					if((buttons[i].object as CharisButton).name == "CharisSimulationButton"){
						(buttons[i].object as CharisButton).addEventListener(CharisButton.EXECUTE_COMMAND, ON_USER_SIMULATION);
					}else{
						(buttons[i].object as CharisButton).addEventListener(CharisButton.EXECUTE_COMMAND, ON_EXECUTE_COMMAND);
					}
					if((buttons[i].object as CharisButton).name == "CharisWormTortue"){
						wormTurtleButton = (buttons[i].object as CharisButton);
					}
				}
			}else{
				taskProgram.addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK_BY_PROGRAM_TASK);
			}
		}
		private function reBuildCharisTask():void{
			taskStage.visible = exampleStage.visible = taskSchem.visible = exampleSchem.visible = exampleField.tanColor.visible = false;
			if(taskProgram != null) taskProgram.tanColor.visible = false;
			switch(taskType){
				case TASK_PICTURE:
				taskStage.visible = true;
				break;
				case TASK_SCHEMA:
				taskSchem.visible = true;
				break;
				case TASK_PROGRAM:
				if(taskProgram!=null)taskProgram.tanColor.visible = true;
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
		private function startWork():void{
			engine.setRobot(exampleStage.getRobot());
			engine.execute();
			engine.setRobot(exampleSchem.getRobot());
			engine.execute();
			engine.setRobot(taskStage.getRobot());
			additionalEngine.setRobot(taskSchem.getRobot());
		}
		private function ON_EXECUTE_COMMAND(event:Event):void{
			var currentCommand:IRobotCommand = (event.target as CharisButton).command;
			var currentCommand1:IRobotCommand = (event.target as CharisButton).command1;
			if(currentCommand != null){
				engine.addCommand(currentCommand);
				additionalEngine.addCommand(currentCommand1);
			}else{
				/*trace("Вывод оригинальной сцены (как в программе)");
				rightStage.print();
				trace("Вывод сцены учащегося");
				leftStage.print();*/
				var addCommand:String = (event.target as CharisButton).name;
				if(addCommand == "CharisBackUpButton"){
					taskStage.restart();
					taskSchem.restart();
					engine.backUp();
					additionalEngine.backUp();
				}
				if(addCommand == "CharisBackDownButton"){
					taskStage.restart();
					taskSchem.restart();
					engine.backDown();
					additionalEngine.backDown();
				}
			}
			if(taskStage.getIsTurtle()){
				wormTurtleButton.goToFrame(2);
			}else{
				wormTurtleButton.goToFrame(1);
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function CHECK_TASK_BY_PROGRAM_TASK(event:Event):void{
			taskStage.restart();
			taskSchem.restart();
			engine.text = additionalEngine.text = taskProgram.getTextField().text;
			engine.execute();
			additionalEngine.execute();
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function ON_USER_SIMULATION(event:Event):void{
            if(showMisstakes){

            } else{

            }
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
			labelXml = xml.LABEL;
			
			donotknowSimulation = (xml.@donotknowSimulation.toString() == "true")?true:false;
			isSimulation = (xml.@isSimulation.toString() == "true")?true:false;
			checkBySchem = (xml.@checkBySchem.toString() == "true")?true:false;
			checkByPicture = (xml.@checkByPicture.toString() == "true")?true:false;
			showMisstakes = (xml.@showMisstakes.toString() == "true")?true:false;
			otherImplimentation = (xml.@otherImplimentation.toString() == "true")?true:false;
			
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
			
			
			if(xml.TASKLABEL.toString()!="") taskFieldXml = xml.TASKLABEL.LABEL;
			
			//labelXml.text = "<![CDATA["+programText+"]]>";
			labelXml.appendChild(new XML('<TEXT><![CDATA['+engine.text+']]></TEXT>'));
			
			for each(var samp:XML in xml.ENTITY){
				if(samp.@isExample.toString() == "true"){
					xmlExampleEntity = new XMLList(samp);
				}else{
					xmlTaskEntity = new XMLList(samp);
				}
			}
			
			var i:int;
			var l:int;
			l = buttons.length;
			for(i=0;i<l;i++){
				(buttons[i].object as CharisButton).button = buttons[i].clip;
				(buttons[i].object as CharisButton).name = buttons[i].name;
				(buttons[i].object as CharisButton).x = buttons[i].x;
				(buttons[i].object as CharisButton).y = buttons[i].y;
				if(buttons[i].name == "CharisSimulationButton"){
					simulationButton = (buttons[i].object as CharisButton);
				}
			}
			for each(var but:XML in xml.BUTTON){
				for(i=0;i<l;i++){
					if(buttons[i].name == but.@name){
						(buttons[i].object as CharisButton).x = parseFloat(but.@x);
						(buttons[i].object as CharisButton).y = parseFloat(but.@y);
						if(but.@alpha.toString()!=""){
							(buttons[i].object as CharisButton).setAlpha(parseFloat(but.@alpha.toString()));
						}
						/*if(but.@alpha.toString()!=""){
							(buttons[i].object as CharisButton).setAlpha(parseFloat(but.@alpha.toString()));
						}*/
					}
				}
			}
			simulationButton.visible = isSimulation;
		}
		
		public function clear():void{
			
		}
		public function get stand():Boolean{
			if(otherImplimentation){
				if(taskStage.equal(exampleStage)){
					return !taskSchem.equal(exampleSchem);
				}
				return false;
			}
			if(checkBySchem){
				return taskSchem.equal(exampleSchem);
			}
			if(checkByPicture){
				return taskStage.equal(exampleStage);
			}
			switch(exampleType){
				case EXAMPLE_PROGRAM:
				case EXAMPLE_SCHEMA:
				return taskSchem.equal(exampleSchem);
				case EXAMPLE_PICTURE:
				return taskStage.equal(exampleStage);
			}
			return true;
		}
		
		public function showAnswer():void{
			if(donotknowSimulation){
				switch(taskType){
					case TASK_SCHEMA:
					simulation = new CharisDontKnowSimulation(exampleSchem, buttons, taskSchem); 
					break;
					case TASK_PICTURE:
					simulation = new CharisDontKnowSimulation(exampleSchem, buttons, taskStage);
					break;
				}
				if(simulation!=null){
					simulation.start();
				}
			}else{
				switch(taskType){
					case TASK_SCHEMA:
					taskSchem.restart();
					engine.setRobot(taskSchem.getRobot());
					engine.execute();
					break;
					case TASK_PICTURE:
					taskStage.restart();
					engine.setRobot(taskStage.getRobot());
					engine.execute();
					break;
				}
			}
			
		}
		public function get iconIndex():int{
			if(exampleType == EXAMPLE_PROGRAM && taskType == TASK_PICTURE){
				return 12;
			} else if(exampleType == EXAMPLE_PROGRAM && taskType == TASK_SCHEMA){
				return 13;
			} else if(exampleType == EXAMPLE_SCHEMA && taskType == TASK_SCHEMA){
				return 14;
			} else if(exampleType == EXAMPLE_SCHEMA && taskType == TASK_PICTURE){
				return 15;
			} else if(exampleType == EXAMPLE_PICTURE && taskType == TASK_SCHEMA){
				return 16;
			} else if(exampleType == EXAMPLE_PICTURE && taskType == TASK_PICTURE){
				return 17;
			} else if(taskType == TASK_PROGRAM){
				return 6;
			}
			return -1;
		}

	}
	
}
