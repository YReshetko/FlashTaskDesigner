package source.utils.xmlClassic {
	
	public class XmlClassicKvadrat {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="0"><POINTS><POINT id="0" x="-40" y="0"/><POINT id="1" x="0" y="-40"/><POINT id="2" x="40" y="0"/><POINT id="3" x="0" y="40"/><POINT id="4" x="-40" y="0"/></POINTS><WIDTH>81</WIDTH><HEIGHT>81</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><CUT>false</CUT><COLOR><X>57</X><Y>139</Y><R>0</R><COLOR>65535</COLOR><CONTOUR>0</CONTOUR><FILL>1</FILL><DELETE>0</DELETE><SYMMETRY>4</SYMMETRY></COLOR><BLACK><X>56</X><Y>139</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>');
			return figure;
		}

	}
	
}
