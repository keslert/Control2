package  {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	public class Engine {
		private var ROOT:Sprite;
		private var r:Sprite;
		public function Engine(rootMC:Sprite) {
			ROOT = rootMC;
			r = new Sprite();
			ROOT.addChild(r);
			addLines();
			addLevelDesign();
			addGUI();
		}
		private function addLines():void {
			GLOBAL.hero=new Hero(r,150,200);
		}
		
		private function addLevelDesign():void {
			GLOBAL.levelDesign = new LevelDesign(r);
		}
		private function addGUI():void {
			GLOBAL.gui = new GUI();
			GLOBAL.gui.setScore(0);
			GLOBAL.gui.setPercentage(100);
			ROOT.addChild(GLOBAL.gui);
		}		
		public function keysDown(event: KeyboardEvent): void{
			if(event.keyCode==38 || event.keyCode==65) {
				GLOBAL.hero.upPressed();
			} else if(event.keyCode==40 || event.keyCode==90) {
				GLOBAL.hero.downPressed();
			}
			
		}
		public function keysUp(event: KeyboardEvent): void{
			if(event.keyCode==38 || event.keyCode==65 ) {
				GLOBAL.hero.upReleased();
			} else if(event.keyCode==40 || event.keyCode==90) {
				GLOBAL.hero.downReleased();
			}
		}
	}
}
