package source.EnvUtils.EnvString {
	
	public class ConvertString {
		private static const extFile:Array = new Array('.png', '.PNG', '.Png', '.pNg', '.pnG', '.PNg', '.pNG', '.PnG',
													   '.jpg', '.JPG', '.Jpg', '.jPg', '.jpG', '.JPg', '.jPG', '.JpG',
													   '.bmp', '.BMP', '.Bmp', '.bMp', '.bmP', '.BMp', '.bMP', '.BmP',
													   '.swf', '.SWF', '.Swf', '.sWf', '.swF', '.SWf', '.sWF', '.SwF',
													   '.flv', '.FLV', '.Flv', '.fLv', '.flV', '.FLv', '.fLV', '.FlV',
													   '.txt', '.TXT', '.Txt', '.tXt', '.txT', '.TXt', '.tXT', '.TxT',
													   '.gif', '.GIF', '.Gif', '.gIf', '.giF', '.GIf', '.gIF', '.GiF',
													   '.pas', '.PAS', '.Pas', '.pAs', '.paS', '.PAs', '.pAS', '.PaS');
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
			var arrDivider:Array = new Array(" ", ",", "|", "#", ">", "<", ".", "!", "@", "[", "]", "{", "}", "'", '"', "(", ")", "*", ":", ";", "^", "~");
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
		
		
		
		public static function changeWordInText(inText:String, arr:Array):String{
			var oldName:String = arr[0];
			var newName:String = arr[1];
			var outText:String = inText;
			var firstPart:String;
			var lastPart:String;
			while(outText.indexOf(oldName)!= -1){
				//trace("[Class ConvertString]: OLD NAME = " + oldName);
				//trace("[Class ConvertString]: INDEX = " + outText.indexOf(oldName));
				firstPart = outText.substring(0, outText.indexOf(oldName));
				lastPart = outText.substring(outText.indexOf(oldName) + oldName.length, outText.length);
				outText = firstPart+newName+lastPart;
			}
			return outText;
		}
		
		
		public static function checkSwfName(value:String):Boolean{
			if(value.indexOf('.swf')==-1 && value.indexOf('.SWF')==-1) return true;
			return false;
		}
		public static function checkMp3Name(value:String):Boolean{
			if(value.indexOf('.mp3')==-1 && value.indexOf('.MP3')==-1) return true;
			return false;			
		}
		public static function checkPasName(value:String):Boolean{
			if(value.indexOf('.pas')==-1 && value.indexOf('.PAS')==-1) return true;
			return false;			
		}
		
		public static function nameFormat(str:String):String{
			var name:String = str.substring(0, str.lastIndexOf('.'));
			var extension:String = str.substring(str.lastIndexOf('.'), str.length);
			var i:int;
			var l:int;
			l = name.length;
			var outName:String = '';
			var currentSymbol:String
			for(i=0;i<l;i++){
				currentSymbol = name.charAt(i);
				if(CompareSymbol(currentSymbol)){
					outName += getChangeSymbol(currentSymbol);
				}else{
					outName += '_';
				}
			}
			outName += extension;
			return outName;
		}
		private static function getChangeSymbol(inSymbol:String):String{
			var rusSymbol:Array = new Array('а','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ь','ъ','ы','э','ю','я','А','Б','В','Г','Д','Е','Ё','Ж','З','И','Й','К','Л','М','Н','О','П','Р','С','Т','У','Ф','Х','Ц','Ч','Ш','Щ','Ь','Ъ','Ы','Э','Ю','Я');
			var engSymbol:Array = new Array('a','b','v','g','d','e','yo','zh','z','i','j','k','l','m','n','o','p','r','s','t','oo','f','h','zc','ch','sh','shi','y','jy','i','je','ju','ja','A','B','V','G','D','E','YO','ZH','Z','I','J','K','L','M','N','O','P','R','S','T','OO','F','H','ZC','CH','SH','SHI','Y','JY','I','JE','JU','JA');
			var outObject:Object = new Object();
			var i:int;
			var l:int;
			l = rusSymbol.length;
			for(i=0;i<l;i++){
				if(inSymbol == rusSymbol[i]) return engSymbol[i];
			}
			return inSymbol;
		}
		
		
		public static function getDBFileFromTask(str:String):Array{
			var outArr:Array = new Array();
			var currentStr:String = str;
			var fileId:String;
			var index:int = currentStr.indexOf('ID_DB_');
			var i:int;
			while(index!=-1){
				if(!CompareSymbol(currentStr.charAt(index-1))){
					fileId = '';
					i = index+6;
					while(CompareSymbol(currentStr.charAt(i))){
						fileId += currentStr.charAt(i);
						++i;
					}
					outArr.push(fileId);
					currentStr = currentStr.substring(i, currentStr.length);
				}else{
					currentStr = currentStr.substring(index + 6, currentStr.length);
				}
				index = currentStr.indexOf('ID_DB_');
			}
			return uniqArray(outArr);
		}
	}
	
}
