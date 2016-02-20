package source.utils.xmlNumbers {
	
	public class XmlMinus {

		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure = new XMLList('<USERTAN type="line" id="1"><POINTS><POINT id="0" x="-25" y="-5"/><POINT id="1" x="-25" y="5"/><POINT id="2" x="25" y="5"/><POINT id="3" x="25" y="-5"/><POINT id="4" x="-25" y="-5"/></POINTS><WIDTH>51</WIDTH><HEIGHT>11</HEIGHT><ISDRAG>true</ISDRAG><ISROTATION>true</ISROTATION><COLOR><X>540</X><Y>323</Y><R>0</R><COLOR>16711680</COLOR><CONTOUR>0</CONTOUR><FILL>1</FILL><SYMMETRY>1</SYMMETRY></COLOR><BLACK><X>540</X><Y>323</Y><R>0</R><ALPHA>0</ALPHA><ALPHABG>0</ALPHABG><DELETE>0</DELETE></BLACK></USERTAN>')
			return figure;
		}

	}
	
}
