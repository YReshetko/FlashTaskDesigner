package source.Utilit {
	import alternativa.engine3d.containers.ConflictContainer;
	
	public class CubePositioner {

		public static function setCubePosition(arr:Array, arrCubeCont:Array, arrCube:Array, cubeContainer:ConflictContainer, posCube:int, mBox:Class) {
			//var arr:Array = myModel3D.getParametres()
			var numCol:int = arr[0];
			var numLin:int = arr[1];
			var bmpArr:Array = arr[2];
			var i,j:int;
			while(arrCube.length>0){
				arrCubeCont[0].removeChild(arrCube[0]);
				cubeContainer.removeChild(arrCubeCont[0]);
				arrCubeCont.shift();
				arrCube.shift();
			}
			for(i=0;i<bmpArr.length;i++){
				arrCube.push(new mBox(bmpArr[i]));
				arrCubeCont.push(new ConflictContainer);
			}
			var ID:int = 0;
			var correctX:Number = -(posCube*numCol-posCube)/2;
			var correctY:Number = (posCube*numLin-posCube)/2;
			for(i=0;i<numCol;i++){
				for(j=0;j<numLin;j++){
					arrCubeCont[ID].addChild(arrCube[ID]);
					cubeContainer.addChild(arrCubeCont[ID]);
					arrCubeCont[ID].x = correctX+posCube*i;
					arrCubeCont[ID].y = correctY-posCube*j;
					//trace("Class "+this+": arrCube["+ID+"].x = " + arrCube[ID].x + "; arrCube["+ID+"].y = " + arrCube[ID].y);
					++ID;
				}
			}
		}

	}
	
}
