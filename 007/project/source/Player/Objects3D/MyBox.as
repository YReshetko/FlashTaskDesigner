package source.Player.Objects3D {
	import source.Designer.Viewer3D.Objects3D.myBox;
	import alternativa.engine3d.core.MouseEvent3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MyBox extends myBox{
		private var active:Boolean = false;
		public function MyBox(inArray:Array) {
			super(inArray);
			super.addEventListener(MouseEvent3D.CLICK, MESSAGE);
			//this.rotationZ = Math.PI/4;
		}
		private function MESSAGE(e:MouseEvent3D){
			//trace("Click");
			active = true;
			super.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		public function resetActive(){
			active = false;
		}
		public function getActive():Boolean{
			return active;
		}
	}
	
}
