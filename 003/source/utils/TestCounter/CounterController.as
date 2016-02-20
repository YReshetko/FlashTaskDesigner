package source.utils.TestCounter {
	public class CounterController extends CounterViewr{
		private var numberOfTask:int;
		private var currentTask:int;
		private var arrComplateTask:Array = new Array();
		private var numberActiveTask:Array = new Array;
		private var startNum:int = 0;
		public function CounterController(numTask:int, W:Number) {
			super(W);
			numberOfTask = numTask;
			super.initPanel(numTask);
			currentTask = 0;
			setSuperText();
			super.changColorPoint(currentTask, "0xFFFF00");
		}
		private function setSuperText(){
			var s:String;
			s = numberOfTask.toString()+"\t/\t"+(currentTask+1).toString()+"\t/\t"+arrComplateTask.length.toString();
			super.setText(s);
		}
		public function setAnswer(value:Array, num:int){
			trace(this + ': SET ROUND ARRAY = ' + value + ', CURRENT TSAK = ' + num);
			var i,ID:int;
			ID = 0;
			arrComplateTask = new Array();
			for(i=0;i<=num;i++){
				if(value[i]!=undefined){
					if(value[i]){
						super.changColorPoint(ID, "0x0066FF");
						arrComplateTask.push(ID);
					}else{
						super.changColorPoint(ID, "0xFF0000");
					}
					++ID;
				}
			}
			currentTask = ID;
			super.changColorPoint(ID, "0xFFFF00");
			setSuperText();
			super.setCurrentPoint(currentTask);
		}
		public function getSettings():Array{
			return [numberOfTask, arrComplateTask.length.toString(), arrComplateTask];
		}
		public function getHiperLincs():String{
			var i,j:int;
			var flag:Boolean;
			var outString:String = "";
			for(i=0;i<numberOfTask;i++){
				if(checkIndexInside(i)){
					outString += "<a href='event:"+i+"'><font color='#006600'><b>"+(i+1) + ". Задание  - Выполнено</b></font></a>\n";
				}else{
					outString += "<a href='event:"+i+"'><font color='#FF0000'><b>"+(i+1) + ". Задание - Не выполнено</b></font></a>\n";
				}
			}
			return outString;
		}
		private function checkIndexInside(id:int):Boolean{
			var i,l:int;
			l = arrComplateTask.length;
			for(i=0;i<l;i++){
				if(arrComplateTask[i] == id) return true;
			}
			return false;
		}
	}
	
}