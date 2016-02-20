package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.IRobotCommand;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisButton;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.CharisEngineController;
	import flash.utils.ByteArray;
	
	public class CharisDontKnowSimulation extends EventDispatcher implements ICharisSimulation{
		public static const ON_SIMULATION_COMPLATE:String = "onSimulationComplate";
		public static const COMMAND_TIMEOUT:int = 1000;
		private var buttons:Array;
		private var currentButton:CharisButton;
		private var sequenceButton:Vector.<String>;
		private var timer:Timer;
		private var engine:CharisEngineController;
		public function CharisDontKnowSimulation(schem:SchemStage, buttons:Array, targetStage:ICharisStageCommand) {
			super();
			targetStage.restart();
			this.buttons = buttons;
			sequenceButton = schem.buttonNames;
			engine = new CharisEngineController(new ByteArray());
			engine.setRobot(targetStage.getRobot());
			timer = new Timer(COMMAND_TIMEOUT);
			timer.addEventListener(TimerEvent.TIMER, TICK);
		}
		
		private function getCommandFromButton(value:String):IRobotCommand{
			var i:int;
			var l:int = buttons.length;
			for(i=0;i<l;i++){
				if(value == buttons[i].name){
					currentButton = (buttons[i].object as CharisButton);
					currentButton.select();
					return currentButton.command;
				}
			}
			return null;
		}
		public function start():void{
			timer.start();
		}
		private function TICK(event:TimerEvent):void{
			if(currentButton != null){
				currentButton.deSelect();
			}
			if(sequenceButton.length==0){
				stop();
			}else{
				var currentName:String = sequenceButton.shift();
				var command:IRobotCommand = getCommandFromButton(currentName);
				engine.addCommand(command);
			}
			
		}
		public function stop():void{
			timer.start();
			super.dispatchEvent(new Event(ON_SIMULATION_COMPLATE));
		}
		
		public function clear():void{
			
		}

	}
	
}
