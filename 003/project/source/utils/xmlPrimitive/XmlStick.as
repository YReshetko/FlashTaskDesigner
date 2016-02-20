package source.utils.xmlPrimitive {
	
	public class XmlStick {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="curve" id="0"><POINTS><POINT id="0" x="-10" y="-60" anchorX="NaN" anchorY="NaN"/><POINT id="1" x="-10" y="60" anchorX="-10" anchorY="0"/><POINT id="2" x="10" y="60" anchorX="0" anchorY="80"/><POINT id="3" x="10" y="-60" anchorX="10" anchorY="0"/><POINT id="4" x="-10" y="-60" anchorX="0" anchorY="-80"/></POINTS><WIDTH>11</WIDTH><HEIGHT>141</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>320</X><Y>100</Y><R>0</R><COLOR>65433</COLOR><CONTOUR>1</CONTOUR><FILL>1</FILL><SYMMETRY>1</SYMMETRY></COLOR><BLACK><X>320</X><Y>100</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>')
			return figure;
		}

	}
	
}
