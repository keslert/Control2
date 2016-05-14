package  {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	public class Main {
		private var ROOT:Sprite;
		private var _r:Sprite;
		private var song:Song;
		private var boxLayer:BoxLayer;
		public function Main(rootMC:Sprite) {
			ROOT = rootMC;
			_r = new Sprite();
			ROOT.addChild(_r);
			addSong();
			createControls();
			createBoxLayer();
		}
		private function createControls() {
			GLOBAL.controller = new Controller();
			GLOBAL.controller.y = 372;
			_r.addChild(GLOBAL.controller);
		}
		private function createBoxLayer() {
			boxLayer = new BoxLayer(_r);
		}
		private function addSong() {
			GLOBAL.song = new Song();
		}
		public function keysDown(event: KeyboardEvent): void{
			trace(event.keyCode);
			if(event.keyCode==17) {
				GLOBAL.ctrlDown=true;
			} else if(event.keyCode==16) {
				GLOBAL.shftDown=true;
				GLOBAL.song.stop();
			} else if(event.keyCode==90) {
				GLOBAL.zDown=true;
			} else if(event.keyCode==67) {
				GLOBAL.cDown=true;
			} else if(event.keyCode==86) {
				GLOBAL.vDown=true;
			} else if(event.keyCode==66) {
				GLOBAL.bDown=true;
			} else if(event.keyCode==65) {
				GLOBAL.aDown=true;
			} 
			if(event.keyCode==37) {
				GLOBAL.controller.leftDown();
			} else if(event.keyCode==39) {
				GLOBAL.controller.rightDown();
			} else if(event.keyCode==38) {
				GLOBAL.controller.upDown();
			} else if(event.keyCode==40) {
				GLOBAL.controller.downDown();
			} else if(event.keyCode==80) {
				boxLayer.printOut();
			} else if(event.keyCode > 48 && event.keyCode < 58) {
				GLOBAL.controller.zSwitch(event.keyCode);
			} else if(event.keyCode==85) {
				boxLayer.undo();
			} else if(event.keyCode==69) {
				boxLayer.erase();
			}
		}
		public function keysUp(event: KeyboardEvent): void {
			if(event.keyCode==17) {
				GLOBAL.ctrlDown=false;
			} else if(event.keyCode==16) {
				GLOBAL.shftDown=false;
			} else if(event.keyCode==90) {
				GLOBAL.zDown=false;
			} else if(event.keyCode==67) {
				GLOBAL.cDown=false;
			} else if(event.keyCode==86) {
				GLOBAL.vDown=false;
			} else if(event.keyCode==66) {
				GLOBAL.bDown=false;
			} else if(event.keyCode==65) {
				GLOBAL.aDown=false;
			} 
		}
	}
}
