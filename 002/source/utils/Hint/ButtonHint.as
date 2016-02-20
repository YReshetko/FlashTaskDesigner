package source.utils.Hint {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.MovieClip;
	
	public class ButtonHint extends Sprite{
		private var field:TextField;
		private var hintArrow:HintArrow;
		private var hintMiddle:HintMiddle;
		private var hintLeft:HintLeft;
		private var hintRight:HintRight;
		public function ButtonHint(label:String) {
			initTextField(label);
			buildHint();
		}
		
		private function initTextField(value:String):void{
			field = new TextField();
			var format:TextFormat = new TextFormat();
			format.color = 0x333333;
			format.size = 12;
			format.font = "Arial";
			format.bold = true;
			
			field.autoSize = TextFieldAutoSize.LEFT;
			//field.border = true;
			field.defaultTextFormat = format;
			field.text = value;
		}
		
		private function buildHint():void{
			hintArrow = new HintArrow();
			hintMiddle = new HintMiddle();
			hintLeft = new HintLeft();
			hintRight = new HintRight();
			
			(hintMiddle as MovieClip).width = field.textWidth;
			
			(hintArrow as MovieClip).x = -(hintArrow as MovieClip).width/2;
			(hintArrow as MovieClip).y = -(hintArrow as MovieClip).height;
			
			(hintMiddle as MovieClip).x = -(hintMiddle as MovieClip).width/2;
			(hintMiddle as MovieClip).y = (hintArrow as MovieClip).y - (hintMiddle as MovieClip).height;
			
			(hintLeft as MovieClip).y = (hintMiddle as MovieClip).y;
			(hintLeft as MovieClip).x = (hintMiddle as MovieClip).x - (hintLeft as MovieClip).width;
			
			(hintRight as MovieClip).y = (hintMiddle as MovieClip).y;
			(hintRight as MovieClip).x = (hintMiddle as MovieClip).x + (hintMiddle as MovieClip).width;
			
			field.x = -field.width/2;
			field.y = (hintMiddle as MovieClip).y;
			(hintMiddle as MovieClip).alpha = (hintArrow as MovieClip).alpha = (hintLeft as MovieClip).alpha = (hintRight as MovieClip).alpha = 0.85;
			super.addChild(hintArrow);
			super.addChild(hintLeft);
			super.addChild(hintRight);
			super.addChild(hintMiddle);
			super.addChild(field);
		}

	}
	
}
