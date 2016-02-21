package source.Utilit.Scene3D {
	import flash.display.Sprite;
	import alternativa.engine3d.containers.ConflictContainer;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.View;
	
	public class Scene3DBuild extends Sprite{
		
		private var container3D:ConflictContainer;
		private var cubeContainer:ConflictContainer;
		private var camera:Camera3D;
		
		public function Scene3DBuild(wScene:int, hScene:int) {
			container3D = new ConflictContainer();
			cubeContainer = new ConflictContainer();
			camera = new Camera3D();
			camera.view = new View(wScene, hScene);
			camera.view.hideLogo();
			super.addChild(camera.view);
			container3D.addChild(camera);
			container3D.addChild(cubeContainer);
		}
		public function setCameraPosition(_X:int, _Y:int, _Z:int){
			camera.x = _X;
			camera.y = _Y;
			camera.z = _Z;
			camera.lookAt(0,0,0);
		}
		public function getCameraPosition():Array{
			return [camera.x, camera.y, camera.z];
		}
		public function rendering(){
			camera.render();
		}
		public function setCubeRotation(xRotation:Number, yRotation:Number){
			cubeContainer.rotationX += xRotation;
			cubeContainer.rotationY += yRotation;
		}
		public function getCubeContainer():ConflictContainer{
			return cubeContainer;
		}
	}
	
}
