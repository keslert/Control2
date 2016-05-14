package  {
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Line {
		private var nodes:Array;
		private var mc:Sprite;
		private var PARENT:Sprite;
		private var xDist:int;
		private var xStart:int;
		private var speed:int;
		public function Line(p:Sprite,x,y,speed:int,xDist:int) {
			PARENT=p;
			mc = new Sprite();
			PARENT.addChild(mc);
			this.xDist = xDist;
			xStart = x;
			nodes = [y,y,y,y,y,y,y,y,y,y,y,y];
			
			this.speed = speed;
			drawLines();
		}
		public function updateLine() {
			updateNodes();
		}
		private function updateNodes() {
			for(var i=nodes.length-1;i>0;i--) {
				nodes[i]=nodes[i-1];
			}
			drawLines();
		}
		private function drawLines() {
			mc.graphics.clear();
			for(var i=1;i<nodes.length;i++) {
				mc.graphics.lineStyle(3,int(GLOBAL.brickColor),1);
				mc.graphics.moveTo(xStart-((i-1)*xDist),nodes[i-1]);
				mc.graphics.lineTo(xStart-(i*xDist),nodes[i]);
			}
		}
		public function cleanup() {
			mc.graphics.clear();
		}
		public function increase() {
			nodes[0]-=speed;
		}
		public function decrease() {
			nodes[0]+=speed;
		}
	}
}
