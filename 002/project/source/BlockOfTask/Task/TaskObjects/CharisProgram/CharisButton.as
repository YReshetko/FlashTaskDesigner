package source.BlockOfTask.Task.TaskObjects.CharisProgram {
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import flash.events.Event;

    import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.CharisCommandFactory;
    import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.LeftRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.RightRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.DownRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.UpRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.LeftDownRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.LeftUpRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.RightDownRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.RightUpRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpLeftRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpRightDownRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpRightRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpDownRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpUpRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpLeftDownRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpLeftUpRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpRightUpRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.JumpZeroRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.BarRC;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.IRobotCommand;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.ChangeModeRC;
	import flash.display.MovieClip;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.CircleRC;
	import source.utils.Hint.ButtonHint;
	import source.utils.Figure;

	public class CharisButton extends Sprite{
		public static const EXECUTE_COMMAND:String = "onExecuteCommand";
		private var clip:*;
		private var label:String;
		private var selectSprite:Sprite;
		private static var commands:Array = [{label: "Рисовать влево (Left/L)", 					name:"CharisLeftButton", 			command:new LeftRC(),			command1:new LeftRC()},
											 {label: "Рисовать вправо (Right/R)", 					name:"CharisRightButton", 			command:new RightRC(),			command1:new RightRC()},
											 {label: "Рисовать вниз (Down/D)", 						name:"CharisDownButton", 			command:new DownRC(),			command1:new DownRC()},
											 {label: "Рисовать вверх (Up/U)", 						name:"CharisUpButton", 				command:new UpRC(),				command1:new UpRC()},
											 {label: "Рисовать диагональ (LeftDown/LD)", 			name:"CharisLeftDownButton", 		command:new LeftDownRC(),		command1:new LeftDownRC()},
											 {label: "Рисовать диагональ (LeftUp/LU)", 				name:"CharisLeftUpButton", 			command:new LeftUpRC(),			command1:new LeftUpRC()},
											 {label: "Рисовать диагональ (RightDown/RD)", 			name:"CharisRightDownButton", 		command:new RightDownRC(),		command1:new RightDownRC()},
											 {label: "Рисовать диагональ  (RightUp/RU)", 			name:"CharisRightUpButton", 		command:new RightUpRC(),		command1:new RightUpRC()},
											 {label: "Прыжок влево (JumpLeft/JL)", 					name:"CharisJumpLeftButton", 		command:new JumpLeftRC(),		command1:new JumpLeftRC()},
											 {label: "Прыжок вправо (Jump/J)",						name:"CharisJumpRightButton", 		command:new JumpRightRC(),		command1:new JumpRightRC()},
											 {label: "Прыжок вниз (JumpDown/JD)", 					name:"CharisJumpDownButton", 		command:new JumpDownRC(),		command1:new JumpDownRC()},
											 {label: "Прыжок вверх (JumpUp/JU)", 					name:"CharisJumpUpButton", 			command:new JumpUpRC(),			command1:new JumpUpRC()},
											 {label: "Прыжок по диагонали (JumpLeftDown/JLD)", 		name:"CharisJumpLeftDownButton", 	command:new JumpLeftDownRC(),	command1:new JumpLeftDownRC()},
											 {label: "Прыжок по диагонали  (JumpLeftUp/JLU)", 		name:"CharisJumpLeftUpButton", 		command:new JumpLeftUpRC(),		command1:new JumpLeftUpRC()},
											 {label: "Прыжок по диагонали (JumpRightDown/JRD)", 	name:"CharisJumpRightDownButton", 	command:new JumpRightDownRC(),	command1:new JumpRightDownRC()},
											 {label: "Прыжок по диагонали (JumpRightUp/JRU)", 		name:"CharisJumpRightUpButton", 	command:new JumpRightUpRC(),	command1:new JumpRightUpRC()},
											 {label: "Отмена команды", 								name:"CharisBackUpButton", 			command:null,					command1:null},
											 {label: "Отмена отмены", 								name:"CharisBackDownButton", 		command:null,					command1:null},
											 {label: "Залить сектор (Bar/B)",						name:"CharisFillButton", 			command:new BarRC(),			command1:new BarRC()},
											 {label: "Смена режима (Worm/Turtle/W/T)", 				name:"CharisWormTortue", 			command:new ChangeModeRC(),		command1:new ChangeModeRC()},
											 {label: "В начало (JumpZero/JZ)", 						name:"CharisJumpZeroButton", 		command:new JumpZeroRC(),		command1:new JumpZeroRC()},
											 {label: "Рисовать окружность (Circle/C)", 				name:"CharisCircleButton", 			command:new CircleRC(),			command1:new CircleRC()}];
		private var _command:IRobotCommand;
		private var _command1:IRobotCommand;
		private var _container:Sprite;
		private var hint:ButtonHint;
		public function CharisButton() {
			super();
			initHandlers();
		}
		public function setAlpha(value:Number):void{
            trace(this + " - current clip = " + clip);
            try{
                clip.background.alpha = value;
            } catch (error:TypeError){
                trace(error);
            }

		}
		public function set button(sample:*):void{
			while(super.numChildren>0){
				super.removeChildAt(0)
			}
			clip = sample;
			selectSprite = new Sprite();
			Figure.insertRect(selectSprite, (clip as MovieClip).width, (clip as MovieClip).height, 1, 0, 0, 0.4, 0x00FF00);
			super.addChild(clip);
		}
        public function get button():*{
            return clip;
        }
		override public function set name(text:String):void{
			label = text;
			hint = getHint();
		}
		override public function get name():String{
			return label;
		}
		private function initHandlers():void{
			super.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_OVER, BUTTON_MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_OUT, BUTTON_MOUSE_OUT);
		}
		private function BUTTON_MOUSE_DOWN(event:MouseEvent):void{
			super.dispatchEvent(new Event(EXECUTE_COMMAND));
		}
		private function BUTTON_MOUSE_OVER(event:MouseEvent):void{
			container.addChild(hint);
			hint.x = super.x + super.width/2;
			hint.y = super.y;
		}
		private function BUTTON_MOUSE_OUT(event:MouseEvent):void{
			if(container.contains(hint)) container.removeChild(hint);
		}
		public function get command():IRobotCommand{
			if(_command == null){
				findCommand();
			}
			return _command;
		}
		public function get command1():IRobotCommand{
			if(_command1 == null){
				findCommand1();
			}
			return _command1;
		}
		private function findCommand():void{
            _command = CharisCommandFactory.getCommandByButton(this);
		}
		private function findCommand1():void{
            _command1 = CharisCommandFactory.getCommandByButton(this);
		}
		
		public function goToFrame(i:int):void{
			(clip as MovieClip).gotoAndStop(i);
		}
		private function get container():Sprite{
			if(_container==null){
				_container = (super.parent as Sprite);
			}
			return _container;
		}
		private function getHint():ButtonHint{
			var i:int;
			var l:int;
			l = commands.length;
			for(i=0;i<l;i++){
				if(label == commands[i].name){
					return new ButtonHint(commands[i].label);
				}
			}
			return new ButtonHint("unknown");
		}
		
		public function select():void{
			super.addChild(selectSprite);
		}
		public function deSelect():void{
			if(super.contains(selectSprite)){
				super.removeChild(selectSprite);
			}
		}

	}
	
}
