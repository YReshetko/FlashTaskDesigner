package source.EnvLoader.DLArchive {
	
	public class FormatFiles {

		public static function getASPFile(width:Number, height:Number):String{
			var outString:String = '<!--#include virtual="engprocs.inc"-->';
			outString += '\r\n';
			outString += '<p></p>';
			outString += '\r\n';
			outString += '<div align="center">';
			outString += '\r\n';
			outString += '<%flash("images/tangram/tangram.swf", 1, '+width.toString()+', '+height.toString()+',0,"")%>';
			outString += '\r\n';
			outString += '</div>';
			return outString;
		}
		public static function getCFGFile():String{
			var outString:String = "TYPE = USERS";
			outString += '\r\n';
			outString += "CHECKER = 'D:\u005cDelTA\u005cCheckers\u005cMathCheck.exe $SOLUTION$ task.out $MAXPOINT$'";
			outString += '\r\n';
			outString += "CHECKFILES = {task.out}";
			outString += '\r\n';
			outString += "CHECKSUBJECT = FILE";
			outString += '\r\n';
			outString += "EXTTYPE = 'Пользовательская'";
			return outString;
		}
		public static function getOUTFile(value:int):String{
			var outString:String = '';
			if(value>1){
				outString = 'countby=return';
				outString += '\r\n';
				outString += '[1]';
				outString += '\r\n';
				outString += 'res=' + value.toString();
			}else{
				outString = 'countby=task';
				outString += '\r\n';
				outString += '[1]';
				outString += '\r\n';
				outString += 'ans1=' + value.toString();
			}
			outString += '\r\n';
			outString += 'score[1]=' + value.toString();
			outString += '\r\n';
			outString += 'total=score[1]';
			return outString;
		}
		public static function getXMLFile(rname:String, ename:String, author:String, group:String, date:String, cost:int):String{
			var outString:String = '';
			outString += '<task name="'+rname+'" ';
			outString += 'ename="'+ename+'" ';
			outString += 'author="'+author+', ';
			outString += group + ', ';
			outString += date + '" '
			outString += 'cost="'+cost.toString()+'" ';
			outString += 'type="10"/>';
			return outString;
		}
		public static function getBATFile(path:String, foldPath:String, folder:String, addString:String = ''):String{
			var outString:String = '';
			if(addString!=''){
				outString += addString;
				outString += '\r\n';
			}
			outString += '"' + path +'" u -r -y -ep1 "' + foldPath + '/' + folder + '.rar" "' + foldPath + '/' + folder + '"';
			outString += '\r\n';
			outString += ':mark1';
			outString += '\r\n';
			outString += 'echo Winrar ERROR';
			outString += '\r\n';
			outString += 'del %0';
			return outString;
		}
		public static function getDiffBATFile(path:String, foldPath:String, folder:String, arcive:String, addString:String = ''):String{
			var outString:String = '';
			if(addString!=''){
				outString += addString;
				outString += '\r\n';
			}
			outString += '"' + path +'" u -r -y -ep1 "' + foldPath + '/' + arcive + '.rar" "' + foldPath + '/' + folder + '"';
			outString += '\r\n';
			outString += ':mark1';
			outString += '\r\n';
			outString += 'echo Winrar ERROR';
			outString += '\r\n';
			outString += 'del %0';
			return outString;
		}
		public static function getBatForZip(path:String, foldPath:String, folder:String, arcive:String):String{
			var outString:String = '"' + path +'" u -r -y -ep1 "' + foldPath + '\u005c' + arcive + '.zip" "' + foldPath + '\u005c' + folder + '"';
			outString += '\r\n';
			outString += 'if not exist "' + foldPath + '\u005c' + arcive + '.zip" goto mark1';
			outString += '\r\n';
			outString += 'DEL /Q "'+foldPath + '\u005c' + folder+'"';
			outString += '\r\n';
			outString += 'RENAME "' + foldPath + '\u005c' + arcive + '.zip" "Position.txt"';
			return outString;
		}
	}
	
}
