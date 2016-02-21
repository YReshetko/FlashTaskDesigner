// ActionScript file
package source.Designer.Viewer3D.Objects3D{
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.materials.TextureMaterial;
	import flash.display.BitmapData;
	import flashx.textLayout.conversion.PlainTextExporter;
	import source.Utilit.RotationShem;
	
	public class myBox extends Object3DContainer{
		private static var arrPosition:Array = new Array([0,0,25,0,0,0],// Верхняя грань
														 [0,0,-25,Math.PI,0,0],//	Нижняя
														 [0,-25,0,-Math.PI/2,0,0],//	левая
														 [0,25,0,Math.PI/2,0,0],// правая
														 [-25,0,0,0,-Math.PI/2,0],//передняя
														 [25,0,0,0,Math.PI/2,0]);
		private static var arrDefMaterial:Array = new Array(0xff0000, 0x00ff00, 0x0000ff, 0xff00ff, 0x00ffff, 0xffff00);
		private var planArr:Array = new Array;
		private var promPlanArr:Array = new Array;
		public function myBox(inArr:Array){
			var i:int;
			for(i=0;i<6;i++){
				//trace("Class "+this+": Arr["+i+"] = |" +inArr[i]+"|");
				if(inArr[i]==null){
					planArr.push(addSimplePlan(arrPosition[i], arrDefMaterial[i]));
					this.addChild(planArr[planArr.length-1]);
				}else{
					planArr.push(addComplicatePlan(arrPosition[i], inArr[i]));
					this.addChild(planArr[planArr.length-1]);
				}
			}
		}
		private function addSimplePlan(arr:Array,mat):Plane{
			var material:FillMaterial = new FillMaterial(mat);
			var plan:Plane = new Plane(50,50);
			plan.setMaterialToAllFaces(material);
			plan.x = arr[0];
			plan.y = arr[1];
			plan.z = arr[2];
			plan.rotationX = arr[3];
			plan.rotationY = arr[4];
			plan.rotationZ = arr[5];
			return plan;
		}
		private function addComplicatePlan(arr:Array,mat:BitmapData):Plane{
			var material:TextureMaterial = new TextureMaterial(mat);
			var plan:Plane = new Plane(50,50);
			plan.setMaterialToAllFaces(material);
			plan.x = arr[0];
			plan.y = arr[1];
			plan.z = arr[2];
			plan.rotationX = arr[3];
			plan.rotationY = arr[4];
			plan.rotationZ = arr[5];
			return plan;
		}
	}
	
} 