package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	
	public interface ICharisStageCommand {
		function moveTo(i:int, j:int):void;
		function drawTo(i:int, j:int):void;
		function drawCircle():void;
		function fillSector():void;
		function moveToZero():void;
		function wormMode():void;
		function turtleMode():void;
		function changeMode():void;
		function restart():void;
		function getRobot():ICharisRobot;
	}
	
}
