package  {
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Hero {
		private var line1:Line;
		private var line2:Line;
		private var mc:Sprite;
		
		private var yStart:int;
		private var yDist:int;
		private var xStart:int;
		private var xDist:int;
		private var speed:int;
		private var r:Sprite;
		private var curY:int;
		private var up:Boolean;
		private var down:Boolean;
		private var mouse:Boolean = GLOBAL.mouse;
		public function Hero(r:Sprite,x,y) {
			this.r=r;
			xStart=x;
			yStart = y;
			yDist = 50;
			xDist = 2;
			speed = 7;
			
			if(mouse) {
				mc  = new Sprite();
				r.addChild(mc);
				mc.x = xStart+20;
				drawHero();
			}
			
			line1 = new Line(r,xStart,yStart-yDist,speed,xDist);
			line2 = new Line(r,xStart,yStart+yDist,speed,xDist);
			curY = yStart;
			up = false;
			down = false;
			
		}
		public function updateHero() {
			if(mouse) updateMouse();
			else updateLocation();
			line1.updateLine();
			line2.updateLine();
		}
		public function updateLocation():void {
			if(curY > yDist+speed && up) {
				curY -= speed;
				line1.increase();
				line2.increase();
			} else if(curY < 350 && down) {
				curY += speed;
				line1.decrease();
				line2.decrease();
			}
		}
		public function updateMouse():void {
			mc.y = r.mouseY;
			mc.x = r.mouseX;
			if(mc.y < 0) mc.y = 0;
			if(mc.y > 380) mc.y = 380;
			
			var vy = -int((curY-mc.y)/5);
			if(vy != 0) {
				curY += vy;
				line1.setY(curY-yDist);
				line2.setY(curY+yDist);
			}
		}
		public function checkBrick(brick:Brick):Boolean {
			if(brick.x < xStart) {
				if(!brick.isColored()) {
					var collected:Boolean=false;
					if(brick.y < curY+yDist && brick.y > curY-yDist)
						collected=true;
					brick.changeColor(collected);
					GLOBAL.ss.updateScore(collected);
				} else if(brick.x < -10) {
					brick.cleanup();
					return true;
				}
			}
			return false;
		}
		public function cleanup() {
			line1.cleanup();
			line2.cleanup();
		}
		public function upPressed():void {
			up = true;
			//down = false;
		}
		public function downPressed():void {
			down = true;
			//up = false;
		}
		public function upReleased():void {
			up = false;
		}
		public function downReleased():void {
			down = false;
		}
		private function drawHero():void {
			mc.graphics.lineStyle(3,0x222222,1);
			mc.graphics.drawCircle(0,0,3);
			
		}
	}
}