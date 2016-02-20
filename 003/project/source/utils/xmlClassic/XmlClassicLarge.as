package source.utils.xmlClassic {
	
	public class XmlClassicLarge {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="0"><POINTS><POINT id="0" x="-40" y="0"/><POINT id="1" x="40" y="-80"/><POINT id="2" x="40" y="80"/><POINT id="3" x="-40" y="0"/></POINTS><WIDTH>81</WIDTH><HEIGHT>161</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><CUT>false</CUT><COLOR><X>137</X><Y>140</Y><R>0</R><COLOR>65280</COLOR><CONTOUR>0</CONTOUR><FILL>1</FILL><DELETE>0</DELETE><SYMMETRY>1</SYMMETRY></COLOR><BLACK><X>137</X><Y>140</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>');
			return figure;
		}

	}
	
}
