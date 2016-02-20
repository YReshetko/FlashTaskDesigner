package source.utils.xmlClassic {
	
	public class XmlClassicRomb {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="0"><POINTS><POINT id="0" x="-20" y="-20"/><POINT id="1" x="-60" y="20"/><POINT id="2" x="20" y="20"/><POINT id="3" x="60" y="-20"/><POINT id="4" x="-20" y="-20"/></POINTS><POINTS><POINT id="0" x="20" y="-20"/><POINT id="1" x="60" y="20"/><POINT id="2" x="-20" y="20"/><POINT id="3" x="-60" y="-20"/><POINT id="4" x="20" y="-20"/></POINTS><WIDTH>121</WIDTH><HEIGHT>41</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><CUT>false</CUT><COLOR><X>117</X><Y>79</Y><R>0</R><COLOR>16711935</COLOR><CONTOUR>0</CONTOUR><FILL>1</FILL><DELETE>0</DELETE><TYPE>1</TYPE><SYMMETRY>2</SYMMETRY></COLOR><BLACK><X>117</X><Y>79</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE><TYPE>1</TYPE></BLACK></USERTAN>');
			return figure;
		}

	}
	
}
