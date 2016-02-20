package source.BlockOfTask.Task.TaskObjects.Line {
	import flash.display.Sprite;
	import flash.geom.*;
	public class OneLine extends Sprite{
		public function OneLine(xml:XMLList, container:Sprite) {
			super.graphics.lineStyle(parseInt(xml.THICK), xml.COLOR);
			super.x = parseFloat(xml.SPRITE_X);
			super.y = parseFloat(xml.SPRITE_Y);
			super.graphics.moveTo(0,0);
			super.graphics.lineTo(xml.POINT_X, xml.POINT_Y);
			container.addChild(super);
		}
	}
}