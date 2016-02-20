package source.utils.xmlPrimitive {
	
	public class XmlSmalTriangle {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="0"><POINTS><POINT id="0" x="30" y="-30"/><POINT id="1" x="-30" y="-30"/><POINT id="2" x="-30" y="30"/><POINT id="3" x="30" y="-30"/></POINTS><WIDTH>61</WIDTH><HEIGHT>61</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>50</X><Y>130</Y><R>0</R><COLOR>6684927</COLOR><CONTOUR>1</CONTOUR><FILL>1</FILL><SYMMETRY>1</SYMMETRY></COLOR><BLACK><X>50</X><Y>130</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>')
			return figure;
		}

	}
	
}
