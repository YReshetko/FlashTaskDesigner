package source.utils.xmlPrimitive {
	
	public class XmlRound {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			var str:String = '<USERTAN type="curve" id="0"><POINTS>'
			var posArray:Array = new Array();
			var controlPos:Array = new Array();
			var r:int = 30;
			var r1:int = r/Math.cos(Math.PI/8);
			var x:Number;
			var y:Number;
			var i:int;
			var l:int;
			controlPos.push([0, 0]);
			for(i=0;i<8;i++){
				x = r*Math.cos(i*Math.PI/4);
				y = r*Math.sin(i*Math.PI/4);
				posArray.push([x, y]);
				x = r1*Math.cos(Math.PI/8 + i*Math.PI/4);
				y = r1*Math.sin(Math.PI/8 + i*Math.PI/4);
				controlPos.push([x, y]);
			}
			l = posArray.length;
			for(i=0;i<l;i++){
				if(i==0) str += '<POINT id="'+i+'" x="'+posArray[i][0]+'" y="'+posArray[i][1]+'" anchorX="NaN" anchorY="NaN"/>';
				else str += '<POINT id="'+i+'" x="'+posArray[i][0]+'" y="'+posArray[i][1]+'" anchorX="'+controlPos[i][0]+'" anchorY="'+controlPos[i][1]+'"/>'
			}
			str += '<POINT id="'+l+'" x="'+posArray[0][0]+'" y="'+posArray[0][1]+'" anchorX="'+controlPos[l][0]+'" anchorY="'+controlPos[l][1]+'"/>'
			str += '</POINTS><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>260</X><Y>50</Y><R>0</R><COLOR>3394764</COLOR><CONTOUR>1</CONTOUR><FILL>1</FILL><SYMMETRY>16</SYMMETRY></COLOR><BLACK><X>260</X><Y>50</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>';
			figure = new XMLList(str);
			return figure;
		}
	}
	
}
