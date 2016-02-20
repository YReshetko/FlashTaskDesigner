package source.utils {
	
	public class TaskSettings {

		public static function getArrLevel(xml:XMLList):Array {
			var outArray:Array = new Array();
			var str:String;
			var level:String;
			for each(var sample:XML in xml.elements()){
				str = sample.name().toString();
				if(str == 'TASK'){
					level = sample.@level.toString();
					if(parseInt(level)<=0) level = '1';
					outArray.push(parseInt(level));
				}
			}
			return outArray;
		}
		public static function updateButton(arrLevel:Array, ID:int, test:Boolean, isCheck:Boolean = false):Object{
			var rest:Boolean = true;
			var under:Boolean = true;
			var know:Boolean = true;
			var check:Boolean = false;
			if(arrLevel.length == 1){
				rest = true;
				under = false;
				know = false;
				check = false;
			}else{
				if(test){
					check = isCheck;
					know = !isCheck;
				}else{
					if(arrLevel[ID] == 1) under = false;
					if(ID == arrLevel.length-1) {
						know = false;
					}
					if(ID<arrLevel.length-1){
						if(arrLevel[ID]>=arrLevel[ID+1]){
							know = false
						}
					}
				}
			}
			var outObject:Object = new Object();
			outObject.rest = rest;
			outObject.under = under;
			outObject.know = know;
			outObject.check = check;
			return outObject;
		}
	}
	
}
