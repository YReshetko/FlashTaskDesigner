package source.utils {
	
	public class FindeFileName {
		private static var extation:Array = new Array('jpg', 'jpeg', 'png', 'bmp', 'swf', 'flv', 'txt', 'xml', 'gif', 'avi', 'pas');
		private static var symbol:String = ' <>(),#@|"'+"'";
		public static function names(value:String):Array {
			var regular:RegExp;
			var i:int;
			var j:int;
			var l:int;
			var outArray:Array = new Array();
			var indexArray:Array = new Array();
			var result:Array;
			var link:String;
			l = extation.length;
			for(i=0;i<l;i++){
				regular = new RegExp('\\.'+extation[i],'gi');
				while((result = regular.exec(value))!=null){
					link = result[0];
					indexArray.push(result.index+extation[i].length+1);
				}
			}
			l = indexArray.length;
			var str:String;
			var fileName:String;
			for(i=0;i<l;i++){
				str = value.substring(0, indexArray[i]);
				fileName = '';
				for(j=indexArray[i]-1;j>=0;j--){
					if(symbol.indexOf(str.charAt(j))==-1){
						fileName = str.charAt(j)+fileName;
					}else {
						if(checkUniq(outArray, fileName))outArray.push(fileName);
						break;
					}
				}
			}
			return outArray;
		}
		private static function checkUniq(arr:Array, value:String):Boolean{
			var i:int;
			var l:int;
			l = arr.length;
			for(i=0;i<l;i++){
				if(arr[i] == value) return false;
			}
			return true;
		}

	}
	
}
