package source.Player.Objects {
	import flash.display.Sprite;
	public class BootR extends Sprite {
		private var imgSprite:Sprite = new Sprite;
		private var WIDTH:int;
		private var HEIGHT:int;
		private var ID:int;
		private var TargetID:int;
		private var TargetedID:int = -1;
		public function BootR(_W:int, _H:int, _id:int) {
			WIDTH = _W;
			HEIGHT = _H;
			ID = _id;
			this.addChild(imgSprite);
		}
		public function setTargetID(_id:int){
			TargetID = _id;
		}
		public function setSprite(spr:Sprite){
			imgSprite.addChild(spr);
			spr.x = 0;
			spr.y = 0;
		}
		public function setTargetedID(_id:int){
			TargetedID = _id;
		}
		public function getTargetedID():int{
			return TargetedID;
		}
		public function Asced():Boolean{
			var flag:Boolean = true;
			if(TargetID!=TargetedID){
				flag = false;
			}
			return flag;
		}
	}
}