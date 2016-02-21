package source.Designer.Viewer3D {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import source.Designer.Viewer3D.Objects3D.myBox;
	import source.Utilit.CubePositioner;
	import source.Utilit.Scene3D.Scene3DBuild;
	
	public class View3D extends Scene3DBuild {
		private static var arrPosCube:Array = new Array(50, 55, 60, 70, 100);
		private var posCube:int = 50;
		
		private var myModel3D:Model3D;
		private var wScene:int;
		private var hScene:int;
		
		private var arrCube:Array = new Array;
		private var arrCubeCont:Array = new Array;
		
		private var listenerSprite:Sprite = new Sprite;
		private var remX:Number;
		private var remY:Number;
		public function View3D(myModel3D:Model3D, wScene:int, hScene:int) {
			super(wScene, hScene);
			super.setCameraPosition(0, 0, 300);
			this.myModel3D = myModel3D;
			this.wScene = wScene;
			this.hScene = hScene;
			this.myModel3D.addEventListener(Event.CHANGE, MODEL3D_CHANGE);
			super.addChild(listenerSprite);
			drawList();
			listenerSprite.doubleClickEnabled = true;
			listenerSprite.addEventListener(MouseEvent.MOUSE_DOWN, LIST_MOUSE_DOWN);
			listenerSprite.addEventListener(MouseEvent.MOUSE_UP, LIST_MOUSE_UP);
			listenerSprite.addEventListener(MouseEvent.MOUSE_OUT, LIST_MOUSE_UP);
			listenerSprite.addEventListener(MouseEvent.MOUSE_WHEEL, LIST_MOUSE_WHEEL);
			listenerSprite.addEventListener(MouseEvent.DOUBLE_CLICK, LIST_DOUBLE_CLICK);
		}
		private function MODEL3D_CHANGE(e:Event){
			//trace("Class "+this+" CHANGE 3D MODEL");
			CubePositioner.setCubePosition(myModel3D.getParametres(), arrCubeCont, arrCube, super.getCubeContainer(), posCube, myBox);
			super.rendering();
		}
		private function LIST_MOUSE_DOWN(e:MouseEvent){
			//trace("Class "+this+": MOUSE DOWN LIST");
			listenerSprite.addEventListener(MouseEvent.MOUSE_MOVE, LIST_MOUSE_MOVE);
			remX = e.localX;
			remY = e.localY;
		}
		private function LIST_MOUSE_UP(e:MouseEvent){
			listenerSprite.removeEventListener(MouseEvent.MOUSE_MOVE, LIST_MOUSE_MOVE);
		}
		private function LIST_MOUSE_MOVE(e:MouseEvent){
			if(e.localX-remX > 0){
				setCubeRotation(0, Math.PI/100);
			}
			if(e.localX-remX < 0){
				setCubeRotation(0, -Math.PI/100);
			}
			if(e.localY-remY > 0){
				setCubeRotation(Math.PI/100, 0);
			}
			if(e.localY-remY < 0){
				setCubeRotation(-Math.PI/100, 0);
			}
			remX = e.localX;
			remY = e.localY;
			super.rendering();
		}
		private function LIST_MOUSE_WHEEL(e:MouseEvent){
			var Z:int = super.getCameraPosition()[2];
			if(e.delta>0){
				if(Z>100){
					super.setCameraPosition(0, 0, Z-20);
				}
			}else{
				if(Z<1000){
					super.setCameraPosition(0, 0, Z+20);
				}
			}
			super.rendering();
		}
		private function LIST_DOUBLE_CLICK(e:MouseEvent){
			trace("Class "+ this +": DOUBLE CLICK");
			var i:int;
			if(posCube == arrPosCube[arrPosCube.length-1]){
				posCube = arrPosCube[0];
				MODEL3D_CHANGE(null);
			}else{
				for(i=0;i<arrPosCube.length;i++){
					if(posCube == arrPosCube[i]){
						posCube = arrPosCube[i+1];
						MODEL3D_CHANGE(null);
						return;
					}
				}
			}
		}
		private function drawList(){
			listenerSprite.graphics.lineStyle(1,0x000000,0);
			listenerSprite.graphics.beginFill(0x000000,0);
			listenerSprite.graphics.drawRect(0,0,wScene,hScene);
			listenerSprite.graphics.endFill();
		}

	}
	
}
