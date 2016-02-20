package source.BlockOfTask.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class TableFrame extends Sprite{
		private var frameArr:Array = new Array();
		private var id:int;
		public function TableFrame(width:Number, height:Number, color:uint = 0x0000BB) {
			super();
			drawFrame(width, height);
			var timer:Timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, FRAME_REVISIBLE);
			timer.start();
		}
		private function drawFrame(width:Number, height:Number):void{
			var rad:int = 0;
			var blue:int = 255;
			var color:String;
			var r:String;
			var b:String;
			for(var i:int=0;i<6;i++){
				frameArr.push(new Sprite());
				
				r = rad.toString(16);
				b = blue.toString(16)
				if(r.length==1) r = '0'+r;
				if(b.length==1) b = '0'+b;
				color = '0x'+r + '00' + b;
				trace(this + ' frame color = ' + r + '00' + b);
				(frameArr[i] as Sprite).graphics.lineStyle(0.1, 0, 0);
				(frameArr[i] as Sprite).graphics.beginFill(uint(color), 0.7);
				(frameArr[i] as Sprite).graphics.drawRect(0, 0, width, height);
				(frameArr[i] as Sprite).graphics.drawRect(5, 5, width-10, height-10);
				(frameArr[i] as Sprite).graphics.endFill();
				super.addChild(frameArr[i] as Sprite);
				(frameArr[i] as Sprite).visible = false;
				rad = rad + 51;
				blue = blue - 51;
			}
			id = 0;
			(frameArr[0] as Sprite).visible = true;
		}
		private function FRAME_REVISIBLE(event:TimerEvent):void{
			(frameArr[id] as Sprite).visible = false;
			trace(this + 'frame id = ' + id);
			id = id+1;
			if(id == 6) id = 0;
			(frameArr[id] as Sprite).visible = true;
		}

	}
	
}
