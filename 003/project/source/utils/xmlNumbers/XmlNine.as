package source.utils.xmlNumbers {
	
	public class XmlNine {
		private static var figure:XMLList;
		public static function get xml():XMLList {
			figure= XmlSix.xml;
			figure.COLOR.X = figure.BLACK.X = 642.35.toString();
			figure.COLOR.Y = figure.BLACK.Y = 439.5.toString();
			figure.COLOR.R = figure.BLACK.R = 8;
			return figure;
		}

	}
	
}
