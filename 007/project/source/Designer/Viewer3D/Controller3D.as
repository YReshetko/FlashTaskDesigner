package source.Designer.Viewer3D {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.SpreadMethod;
	
	import source.Utilit.CuterPict;
	public class Controller3D {
		private var myModel3D:Model3D;
		private var myView3D:View3D;
		public function Controller3D(wScene:int, hScene:int, viewSprite:Sprite) {
			myModel3D = new Model3D();
			myView3D = new View3D(myModel3D, wScene, hScene);
			
			viewSprite.addChild(myView3D);
		}
		public function updateScene(obj:Object){
			//trace("Class "+this+": colColumn = " + obj.colColumn );
			var outArr:Array = new Array;
			var promArr:Array;
			var i,j,k:int;
			var ID:int = 0;
			for(i=0;i<obj.colColumn;i++){
				for(j=0;j<obj.colLine;j++){
					outArr.push(new Array);
				}
			}
			for(k=0;k<obj.arrBmpData.length;k++){
				if(obj.arrBmpData[k] == null){
					for(i=0;i<outArr.length;i++){
						outArr[i].push(null);
					}
				}else{
					promArr = CuterPict.cutPict(obj.arrBmpData[k], obj.colColumn, obj.colLine);
					for(i=0;i<outArr.length;i++){
						outArr[i].push(promArr[i]);
					}
				}
			}
			myModel3D.setParametrs(outArr, obj.colColumn, obj.colLine);
		}
		
	}
	
}
