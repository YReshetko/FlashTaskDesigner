package source.Utilit {
	
	public class Checker {

		public static function checkCoincid(obj:Object):Object {
			var Ethalon:Array = obj.Ethalon;
			var Current:Array = obj.Current;
			var i,j,k:int;
			var flag:Boolean = true;
			var outArr:Array = new Array;
			var outObj:Object = new Object();
			for(k=0;k<Current.length;k++){
				for(i=0;i<Ethalon.length;i++){
					for(j=0;j<Ethalon[i].length;j++){
						//trace("Проверяю "+Ethalon[i][j]+" и "+Current[k])
						if(equalTwoArr(Ethalon[i][j], Current[k])){
							outArr.push(i);
							//trace("Равны");
						}else{
							//trace("не равны")
						}
					}
				}
			}
			if(outArr.length!=Current.length){
				//trace("Длины не равны")
				flag = false;
			}else{
				for(i=1;i<outArr.length;i++){
					if(outArr[0]!=outArr[i]){
						flag = false;
						//trace("Не совпадают значения");
						break;
					}
				}
			}
			if(flag){
				outObj.flag = true;
				outObj.ID = outArr[0];
			}else{
				outObj.flag = false;
				outObj.ID = -1;
			}
			return outObj;
		}
		private static function equalTwoArr(arr1:Array, arr2:Array):Boolean{
			var flag:Boolean = true;
			var i:int;
			if(arr1.length != arr2.length){
				flag = false;
			}else{
				for(i=0;i<arr1.length;i++){
					if(arr1[i]!=arr2[i]){
						flag = false;
						break;
					}
				}
			}
			return flag;
		}

	}
	
}
