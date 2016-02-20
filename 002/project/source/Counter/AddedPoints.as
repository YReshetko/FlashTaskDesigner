package source.Counter {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class AddedPoints extends Sprite{
		public static var GO_TO_POSITION:String = 'onGoToPosition';
		private var arrPoint:Array = new Array();
		private var currentPosition:Number;
		public function AddedPoints(value:Sprite) {
			value.addChild(super);
			super.mouseEnabled = false;
			super.mouseChildren = false;
		}
		/*
			value.tasks - массив заданий 
				tasks[i].num - номер заданий
				tasks[i].type - тип 'O' - обычное 'M'- мнимое
			value.partition - разбиение массива на части, если 0, то нет разбиения
		*/
		public function set test(value:Object):void{
			var i:int; 
			var j:int; 
			var l:int;
			if(value.partition==0){
				l = value.tasks.length;
				for(i=0;i<l;i++){
					if(value.tasks[i].type == 'O'){
						arrPoint.push(new OnePoint(value.tasks[i].num.toString(), OnePoint.STATUS_DEFAULT));
					}else{
						arrPoint.push(new OnePoint(value.tasks[i].num.toString(), OnePoint.STATUS_DEFAULT, OnePoint.IMAGINARY_TYPE));
					}
					super.addChild(arrPoint[i]);
					arrPoint[i].y = TestControl.hPoints/2;
					if(i==0) arrPoint[i].x = arrPoint[i].width/2;
					else arrPoint[i].x = arrPoint[i-1].x + arrPoint[i-1].width + 3;
				}
			}else{
				
				l = value.tasks.length;
				for(i=0;i<l;i++){
					if(value.tasks[i].type == 'O'){
						arrPoint.push(new OnePoint(value.tasks[i].num.toString(), OnePoint.STATUS_DEFAULT));
					}else{
						arrPoint.push(new OnePoint(value.tasks[i].num.toString(), OnePoint.STATUS_DEFAULT, OnePoint.IMAGINARY_TYPE));
					}
					super.addChild(arrPoint[i]);
					arrPoint[i].y = TestControl.hPoints/2;
					if(i==0) arrPoint[i].x = arrPoint[i].width/2;
					else arrPoint[i].x = arrPoint[i-1].x + arrPoint[i-1].width + 7;
					super.graphics.lineStyle(1.5, 0, 1);
					super.graphics.moveTo(arrPoint[i].x + arrPoint[i].width/2 + 6, 3);
					super.graphics.lineTo(arrPoint[i].x + arrPoint[i].width/2 + 1, TestControl.hPoints - 3);
				}
			}
		}
		/*
			value.CurrentTask - номер текущего сданного задания
			value.CurrentStatus - логическая переменная сдано задание или нет
		*/
		public function set complate(value:Object):void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(value.CurrentTask == arrPoint[i].id){
					if(value.CurrentStatus){
						arrPoint[i].status = OnePoint.STATUS_SUCCESS;
					}else{
						arrPoint[i].status = OnePoint.STATUS_FAILD;
					}
				}
			}
		}
		/*
			value - номер следующего задания
		*/
		public function set task(value:int):void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(value == arrPoint[i].id){
					arrPoint[i].status = OnePoint.STATUS_SELECT;
					currentPosition = arrPoint[i].x;
					super.dispatchEvent(new Event(GO_TO_POSITION));
				}
			}
		}
		public function get position():Number{
			return currentPosition;
		}
	}
	
}
