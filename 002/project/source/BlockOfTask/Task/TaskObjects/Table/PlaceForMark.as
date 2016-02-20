package source.BlockOfTask.Task.TaskObjects.Table {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.display.MovieClip;

	public class PlaceForMark extends Sprite{
		private var wPlace:Number;
		private var hPlace:Number;
		private var maskSprite:Sprite = new Sprite();
		private var container:Sprite = new Sprite()
		private var flag:Boolean = true;
		public function PlaceForMark(W:Number, H:Number) {
			super();
			super.addChild(maskSprite);
			super.addChild(container);
			container.mask = maskSprite;
			setSize(W, H);
		}
		private function setSize(W:Number, H:Number):void{
			wPlace = W;
			hPlace = H;
			Figure.insertRect(maskSprite, W, H);
			//Figure.insertRect(container, W, H);
		}
		public function set variant(value:Boolean):void{
			flag = value;
		}
		public function putAns():void{
			
			var ans:MovieClip;
			if(flag){
				ans = new GREENMARK();
			}else{
				ans = new REDCROSS();
			}
			var W:Number = container.width;
			container.addChild(ans);
			ans.height = hPlace - 6;
			ans.scaleX = ans.scaleY;
			ans.y = 3;
			ans.x = W+3;
			trace(this + ': PUT ANS = ' + ans);
			if(container.width>wPlace){
				container.x = wPlace - container.width - 20;
			}
		}

	}
	
}
