package source.PlayerLib {
	import flash.utils.ByteArray;
	
	public class Library {
		private var contentArr:Array;
		public function Library() {
			contentArr = new Array();
		}
		public function setFile(content:ByteArray, name:String):void{
			contentArr.push([content, name]);
		}
		public function setArrFile(contArr:Array, nameArr:Array):void{
			var i:int;
			for(i=0;i<contArr.length;i++){
				//trace(this + ': CONTENT = ' + contArr[i] + '; NAME = ' + nameArr[i]);
				contentArr.push([contArr[i], nameArr[i]]);
			}
		}
		public function getFile(name:String):ByteArray{
			var i:int;
			var l:int = contentArr.length;
			for(i=0;i<l;i++){
				if(contentArr[i][1] == name) return contentArr[i][0];
			}
			return null;
		}
		public function getArrFile(name:Array, except:Array = null):Array{
			var outArr:Array = new Array();
			var outObj:Object;
			var inArr:Array = name;
			var i:int; 
			var j:int; 
			var l:int; 
			var k:int;
			if(except!=null){
			k = except.length;
				for(j=0;j<k;j++){
					for(i=0;i<inArr.length;i++){
						if(except[j] == inArr[i]){
							inArr.splice(i, 1);
							--i;
						}
					}
				}
			}
			l = inArr.length
			k = contentArr.length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(contentArr[j][1] == inArr[i]){
						outObj = new Object();
						outObj.name = inArr[i];
						outObj.byteArray = contentArr[j][0];
						outArr.push(outObj);
					}
				}
			}
			return outArr;
		}
		public function clearLib():void{
			while(contentArr.length>0){
				contentArr.shift();
			}
		}
	}
	
}
