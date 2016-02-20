package source.utils {
	
	public class TreeConverter {
		private static var execConst:Array = ['TASK', 'RANDOM', 'EQUIVALENT', 'NOMORE'];
		public static function convert(value:String):Array {
			var inXml:XMLList = new XMLList(value);
			var head:XMLList = getHeadXml(inXml);
			head.TEST = false;
			head.CHECK = false;
			var outArr:Array = getArrTasks(inXml, head);
			return outArr;
		}
		
		//	Получение шапки заданий
		private static function getHeadXml(value:XMLList):XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@version = '1.1';
			outXml.@copyrights = 'http://dl.gsu.by';
			for each(var sample:XML in value.elements()){
				if(notIqualTree(sample.name().toString())){
					outXml.appendChild(sample);
				}
			}
			return outXml;
		}
		private static function notIqualTree(value:String):Boolean{
			var i:int;
			var l:int;
			l = execConst.length;
			for(i=0;i<l;i++){
				if(value == execConst[i])return false;
			}
			return true;
		}
		//	получение массива заданий
		private static function getArrTasks(xml:XMLList, head:XMLList):Array{
			var outArr:Array = new Array();
			var currentXml:XMLList;
			var sample:XML;
			var currentID:int;
			currentXml = new XMLList(head.toString());
			currentID = 1;
			for each(sample in xml.TASK){
				currentXml.appendChild(sample);
				sample.@level = 1;
				sample.@id = currentID;
				if(sample.MNIMOE.toString()!='true'){
					outArr.push(new XMLList(currentXml));
					currentXml = new XMLList(head.toString());
					currentID = 1;
				}else{
					++currentID;
				}
			}
			return outArr;
		}
	}
	
}
