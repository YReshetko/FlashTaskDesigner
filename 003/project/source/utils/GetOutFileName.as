package source.utils {
	import flash.external.ExternalInterface;
	public class GetOutFileName {

		public static function getImagesName(value:XMLList):Object {
			var webImage:Array = new Array();
			var dbImage:Array = new Array();
			var webSwf:Array = new Array();
			var str:String;
			var sample:XML;
			for each(sample in value..PICTURETAN){
				str = sample.IMAGE;
				if(str.indexOf('ID_DB')==0){
					dbImage.push(str);
				}else{
					webImage.push(str);
				}
			}
			for each(sample in value..SWFOBJECT){
				str = sample.NAME;
				webSwf.push(str);
			}
			var outObject:Object = new Object();
			outObject.webImage = webImage;
			outObject.dbImage = dbImage;
			outObject.webSwf = webSwf;
			return outObject;
		}
		public static function getBaseUrl():String{
			try{
				var baseURL:String=ExternalInterface.call("getBaseURL");
			}catch(e:Error){
				return '';
			}
			//	Проверяем базовый путь, если он нулевой, то ставим который нам удобен
			if(baseURL==null){baseURL = "http://dl.gsu.by"}
			//	Проверяем окончание базового пути слешем, если его нет, то приписываем
			if(baseURL.charAt(baseURL.length-1) != "/"){baseURL+="/"};
			return baseURL;
		}
		public static function getRealyNameFromConfig(config:String, arrFile:Array):Array{
			var i:int;
			var index:int;
			var indStr:String;
			var l:int = arrFile.length;
			var promStr:String;
			var name:String;
			var path:String;
			var outArr:Array = new Array();
			for(i=0;i<l;i++){
				indStr = 'ID='+arrFile[i].substring(6, arrFile[i].length);
				index = config.indexOf(indStr);
				if(index!=-1){
					promStr = config.substring(index, config.length);
					index = promStr.indexOf('FileName=');
					promStr = promStr.substring(index, promStr.length);
					name = promStr.substring(promStr.indexOf('=')+1, promStr.indexOf('&'));
					index = promStr.indexOf('Path=');
					promStr = promStr.substring(index, promStr.length);
					path = promStr.substring(promStr.indexOf('=')+1, promStr.indexOf('|'));
					path +='/'+name;
					outArr.push([arrFile[i], path]);
				}
			}
			return outArr;
		}
		
		
		public static function getIDBitmapName(inArr:Array, str:String):int{
			var i:int;
			var l:int;
			l = inArr.length;
			for(i=0;i<l;i++){
				if(inArr[i][0] == str) return i;
			}
			return -1;
		}
		public static function getArrayBitmap(inXml:XMLList, inArr:Array):Array{
			var outArr:Array = new Array();
			var objectName:Object = getImagesName(inXml);
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			l = objectName.webImage.length;
			k = inArr.length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(inArr[j][0] == objectName.webImage[i]){
						outArr.push([inArr[j][0], inArr[j][1]]);
						break;
					}
				}
			}
			l = objectName.dbImage.length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					if(inArr[j][0] == objectName.dbImage[i]){
						outArr.push([inArr[j][0], inArr[j][1]]);
						break;
					}
				}
			}
			return outArr;
		}
		
		public static function getArrayBitmapForSWF(inXml:XMLList, inArr:Array):Array{
			var checkXml:String = inXml.SETTINGS.toString();
			var i:int;
			var l:int;
			var outArr:Array = new Array();
			l = inArr.length;
			for(i=0;i<l;i++){
				if(checkXml.indexOf(inArr[i][0])!=-1)outArr.push([inArr[i][0], inArr[i][1]]);
			}
			return outArr;
		}
	}
	
}
