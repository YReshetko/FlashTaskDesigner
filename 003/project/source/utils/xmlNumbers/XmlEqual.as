package source.utils.xmlNumbers {
	
	public class XmlEqual {

		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="2"><POINTS><POINT id="0" x="-25" y="-25"/><POINT id="1" x="-25" y="-15"/><POINT id="2" x="5" y="0"/><POINT id="3" x="-25" y="15"/><POINT id="4" x="-25" y="25"/><POINT id="5" x="25" y="0"/><POINT id="6" x="-25" y="-25"/></POINTS><WIDTH>51</WIDTH><HEIGHT>51</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>608</X><Y>324</Y><R>0</R><COLOR>16711680</COLOR><CONTOUR>0</CONTOUR><FILL>1</FILL><SYMMETRY>1</SYMMETRY></COLOR><BLACK><X>608</X><Y>324</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>')
			return figure;
		}

	}
	
}
