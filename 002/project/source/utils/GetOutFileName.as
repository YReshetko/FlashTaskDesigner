package source.utils {
	import flash.external.ExternalInterface;
	public class GetOutFileName {

		public static function getImagesName(value:XMLList):Object {
			var webImage:Array = new Array();
			var dbImage:Array = new Array();
			var dbSwf:Array = new Array();
			
			var additionalImage:Array;
			var str:String;
			var sample:XML;
			var i:int;
			var l:int;
			for each(sample in value..PICTURETAN){
				str = sample.IMAGE;
				if(str.indexOf('ID_DB')==0){
					dbImage.push(str);
				}else{
					webImage.push(str);
				}
			}
			for each(sample in value..USERTAN){
				if(sample.IMAGE.@name.toString()!=''){
					webImage.push(sample.IMAGE.@name.toString());
				}
			}
			for each(sample in value..BACKGROUND){
				if(sample.@image.toString()!=''){
					webImage.push(sample.@image.toString());
				}
			}
			for each(sample in value..PAINT){
				if(sample.BACKGROUNDFILENAME.toString()!=''){
					webImage.push(sample.BACKGROUNDFILENAME.toString());
				}
				if(sample.AUTHORFILENAME.toString()!=''){
					webImage.push(sample.AUTHORFILENAME.toString());
				}
			}
			for each(sample in value..CHARIS){
				if(sample.@content.toString()!=''){
					webImage.push(sample.@content.toString());
				}
			}
			for each(sample in value..SWFOBJECT){
				str = sample.NAME;
				if(sample.TYPE.toString() == 'ModulSWF'){
					dbSwf.push(str);
				}else{
					webImage.push(str);
				}
				additionalImage = getNamesFileFromTask(sample.toString());
				l = additionalImage.length;
				for(i=0;i<l;i++){
					if(additionalImage[i]!=undefined && additionalImage[i] != str){
						webImage.push(additionalImage[i]);
					}
				}
			}
			var outObject:Object = new Object();
			outObject.webImage = webImage;
			outObject.dbImage = dbImage;
			outObject.dbSwf = dbSwf;
			return outObject;
		}
		private static const extFile:Array = new Array('.png', '.PNG', '.Png', '.pNg', '.pnG', '.PNg', '.pNG', '.PnG',
													   '.jpg', '.JPG', '.Jpg', '.jPg', '.jpG', '.JPg', '.jPG', '.JpG',
													   '.bmp', '.BMP', '.Bmp', '.bMp', '.bmP', '.BMp', '.bMP', '.BmP',
													   '.swf', '.SWF', '.Swf', '.sWf', '.swF', '.SWf', '.sWF', '.SwF',
													   '.flv', '.FLV', '.Flv', '.fLv', '.flV', '.FLv', '.fLV', '.FlV',
													   '.txt', '.TXT', '.Txt', '.tXt', '.txT', '.TXt', '.tXT', '.TxT');
		public static function getNamesFileFromTask(inString:String):Array{
			var outArray:Array = new Array();
			var i:int;
			var j:int;
			var promStr:String;
			var nameFile:String;
			for(i=0;i<extFile.length;i++){
				promStr = inString;
				while(promStr.indexOf(extFile[i])!=-1){
					nameFile = extFile[i];
					for(j=promStr.indexOf(extFile[i])-1;j>=0;j--){
						if( CompareSymbol(promStr.charAt(j)) ){
							nameFile = promStr.charAt(j)+nameFile;
						}else{
							promStr = promStr.substring((promStr.indexOf(extFile[i])+extFile[i].length), promStr.length-1);
							//trace("Class TextUtilites ОБРЕЗАЕМ ТЕКСТ");
							break;
						}
					}
					//trace("Class TextUtilites ИМЯ ФАЙЛА: " + nameFile);
					outArray.push(nameFile);
				}
			}
			return uniqArray(outArray);
		}
		private static function CompareSymbol(str:String):Boolean{
			var arrDivider:Array = new Array(" ", ",", "|", "#", ">", "<", "!", "@", "[", "]", "{", "}", "'", '"', "(", ")", "*", ":", ";", "^", "~");
			var flag:Boolean = true;
			var i:int;
			for(i=0;i<arrDivider.length;i++){
				if(str == arrDivider[i]){
					flag = false;
					break;
				}
			}
			return flag;
		}
		private static function uniqArray(arr:Array):Array{
			var outArr:Array = new Array;
			var i:int;
			var j:int;
			var flag:Boolean = new Boolean;
			for(i=0; i<arr.length;i++){
				flag = true;
				for(j=0;j<outArr.length;j++){
					if(outArr[j] == arr[i]){
						flag = false;
						break;
					}
				}
				if(flag){
					outArr.push(arr[i]);
				}
			}
			return outArr;
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
		public static function getRealyNameFromConfig(config:String, inFile:Array):Array{
			var i:int;
			var index:int;
			var indStr:String;
			var arrFile:Array = uniqArray(inFile);
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
	}
	
}
