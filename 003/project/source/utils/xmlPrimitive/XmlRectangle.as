package source.utils.xmlPrimitive {
	
	public class XmlRectangle {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="0"><POINTS><POINT id="0" x="-60" y="-30"/><POINT id="1" x="60" y="-30"/><POINT id="2" x="60" y="30"/><POINT id="3" x="-60" y="30"/><POINT id="4" x="-60" y="-30"/></POINTS><WIDTH>121</WIDTH><HEIGHT>61</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>160</X><Y>50</Y><R>0</R><COLOR>65280</COLOR><CONTOUR>1</CONTOUR><FILL>1</FILL><SYMMETRY>2</SYMMETRY></COLOR><BLACK><X>160</X><Y>50</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>')
			return figure;
		}

	}
	
}
