package source.Utilites {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class PreLoader extends Sprite{
		private static const wDisplay:int = 730;
		private static const hDisplay:int = 494;
		
		private static const wBar:int = 300;
		private static const hBar:int = 15;
		
		private var borderBar:Sprite;
		private var fillBar:Sprite;
		
		private var labelPercent:TextField
		public function PreLoader() {
			super();
			initWindow();
		}
		private function initWindow(){
			drawRect();
			drawBar();
			addLabel();
			super.addChild(borderBar);
			super.addChild(fillBar);
			super.addChild(labelPercent);
			borderBar.x = fillBar.x = (wDisplay - wBar)/2;
			borderBar.y = fillBar.y = (hDisplay - hBar)/2;
			
			labelPercent.y = borderBar.y-30;
			labelPercent.x = borderBar.x + (wBar - labelPercent.width)/2;
			++fillBar.x;++fillBar.y;
			fillBar.scaleX = 0;
		}
		private function drawRect(){
			super.graphics.lineStyle(1, 0x000000,0);
			super.graphics.beginFill(0x6F6F6F, 1);
			super.graphics.drawRect(0,0,wDisplay, hDisplay);
			super.graphics.endFill();
		}
		private function drawBar(){
			borderBar = new Sprite;
			fillBar = new Sprite;
			
			borderBar.graphics.lineStyle(1, 0x000000,1);
			borderBar.graphics.beginFill(0xFFFFFF, 1);
			borderBar.graphics.drawRect(0,0,wBar+2, hBar+2);
			borderBar.graphics.endFill();
			
			fillBar.graphics.lineStyle(1, 0x000000,0);
			fillBar.graphics.beginFill(0x00FF00, 1);
			fillBar.graphics.drawRect(0,0,wBar, hBar);
			fillBar.graphics.endFill();
		}
		private function addLabel(){
			labelPercent = new TextField();
			var textFormat:TextFormat = new TextFormat();
			labelPercent.textColor = 0xFFFFFF;
			textFormat.bold = true;
			textFormat.size = 15;
			labelPercent.defaultTextFormat = textFormat;
			labelPercent.autoSize = TextFieldAutoSize.LEFT;
			labelPercent.text = "НАЧАЛО ЗАГРУЗКИ";
		}
		public function scaleBar(percent:Number){
			var str:String = (percent*100).toString().substring(0, 5);
			labelPercent.text = "ЗАГРУЗКА "+str+" %";
			labelPercent.x = borderBar.x + (wBar - labelPercent.width)/2;
			fillBar.scaleX = percent;
		}
		public function scaleBarMuchFile(percent:Number, totalFile:int, currentFile:int){
			var realPercent:Number = (currentFile)/totalFile+percent/totalFile;
			var str:String = (realPercent*100).toString().substring(0, 5);
			labelPercent.text = "ЗАГРУЗКА "+str+" % " + (currentFile+1) + " ИЗ " + totalFile;
			labelPercent.x = borderBar.x + (wBar - labelPercent.width)/2;
			fillBar.scaleX = realPercent;
		}
	}
	
}
