package source.SocketConnection {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.controls.UIScrollBar;
	import fl.controls.ScrollBarDirection;
	
	public class SocketLog extends Sprite{
		
		private var log:TextField = new TextField();
		private var scroll:UIScrollBar;
		public function SocketLog() {
			super();
			init();
			//autoFill();
		}
		private function init():void{
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.bold = true;
			log.defaultTextFormat = format;
			log.setTextFormat(format);
			log.border = false;
			log.background = false;
			log.multiline = true;
			log.width = 700;
			log.height = 250;
			super.addChild(log);
			log.x = -350;
			log.wordWrap = true;
			scroll = new UIScrollBar();
			scroll.scrollTarget = log;
			scroll.direction = ScrollBarDirection.VERTICAL;
			super.addChild(scroll);
			scroll.x = 350;
			scroll.height = 250;
			scroll.width = 7;
		}
		private function autoFill():void{
			var i:int;
			var l:int;
			l = 50;
			for(i=0;i<l;i++){
				message = 'Auto message #'+i;
			}
		}
		public function set message(value:String):void{
			var date:Date = new Date();
			log.appendText('['+date.toUTCString()+'] ' + value + '\n');
			
			log.scrollV = log.numLines;
			scroll.validateNow();
		}
	}
	
}
