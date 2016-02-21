package source.Player.Objects {
	import flash.display.Sprite;
	public class TopL extends Sprite{
		private var imgSprite:Sprite = new Sprite;
		private var WIDTH:int;
		private var HEIGHT:int;
		private var ID:int;
		public function TopL(_W:int, _H:int, _id:int) {
			WIDTH = _W;
			HEIGHT = _H;
			ID = _id;
			this.addChild(imgSprite);
		}
		public function setSprite(spr:Sprite){
			imgSprite.addChild(spr);
		}
	}
}