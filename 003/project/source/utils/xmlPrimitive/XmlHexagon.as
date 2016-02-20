package source.utils.xmlPrimitive {
	
	public class XmlHexagon {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			var str:String = '<USERTAN type="line" id="0"><POINTS>'
			var posArray:Array = new Array();
			var fi:int = 0;
			var r:int = 60/Math.sqrt(3);
			var x:Number;
			var y:Number;
			var i:int;
			var l:int;
			for(i=0;i<6;i++){
				x = r*Math.cos(i*Math.PI/3);
				y = r*Math.sin(i*Math.PI/3);
				posArray.push([x, y]);
			}
			l = posArray.length;
			for(i=0;i<l;i++){
				str += '<POINT id="'+i+'" x="'+posArray[i][0]+'" y="'+posArray[i][1]+'"/>'
			}
			str += '<POINT id="'+l+'" x="'+posArray[0][0]+'" y="'+posArray[0][1]+'"/>'
			str += '</POINTS><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>260</X><Y>140</Y><R>0</R><COLOR>16737792</COLOR><CONTOUR>1</CONTOUR><FILL>1</FILL><SYMMETRY>2</SYMMETRY></COLOR><BLACK><X>260</X><Y>140</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>';
			figure = new XMLList(str);
			return figure;
		}

	}
	
}
