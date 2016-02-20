package source.utils.xmlPrimitive {
	
	public class XmlLargeTriangle {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="0"><POINTS><POINT id="0" x="-60" y="-30"/><POINT id="1" x="-60" y="30"/><POINT id="2" x="60" y="30"/><POINT id="3" x="-60" y="-30"/></POINTS><POINTS><POINT id="0" x="60" y="-30"/><POINT id="1" x="60" y="30"/><POINT id="2" x="-60" y="30"/><POINT id="3" x="60" y="-30"/></POINTS><WIDTH>121</WIDTH><HEIGHT>61</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><ISDINAMYC>false</ISDINAMYC><CUT>false</CUT><COLOR><X>120</X><Y>145</Y><R>4</R><COLOR>16711680</COLOR><CONTOUR>1</CONTOUR><FILL>1</FILL><DELETE>0</DELETE><TYPE>1</TYPE><SYMMETRY>1</SYMMETRY></COLOR><BLACK><X>120</X><Y>145</Y><R>4</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE><TYPE>1</TYPE></BLACK></USERTAN>')
			return figure;
		}

	}
	
}
