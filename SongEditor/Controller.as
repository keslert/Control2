package  {
	import flash.events.*;
	import flash.display.MovieClip;
	
	public class Controller extends MovieClip{
		
		private var song:Song;
		private var scrollLocked:Boolean;
		
		public function Controller() {
			this.song = GLOBAL.song
			playBtn.addEventListener(MouseEvent.CLICK, playClicked);
			stopBtn.addEventListener(MouseEvent.MOUSE_DOWN, stopClicked);
			rewindBtn.addEventListener(MouseEvent.MOUSE_DOWN, rewindDown);
			forwardBtn.addEventListener(MouseEvent.MOUSE_DOWN, forwardDown);
			scrollbar.scrollBallBtn.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown);
			this.addEventListener(MouseEvent.MOUSE_UP, scrollUp);
			this.addEventListener(Event.ENTER_FRAME,update);
			scrollLocked=true;
			
		}
		private function update(e:Event) {
			frameText.text = ""+song.currentFrame;
			if(!scrollLocked) {
				var x1 = (scrollbar.mouseX) ? scrollbar.mouseX : 0;
				scrollbar.scrollBallBtn.x = x1;
				if(x1 > scrollbar.barMC.width) {
					scrollbar.scrollBallBtn.x = scrollbar.barMC.width;
				} else if(x1 < 0) {
					scrollbar.scrollBallBtn.x = 0;
				}
				var p:Number = scrollbar.scrollBallBtn.x/scrollbar.barMC.width;
				song.gotoAndPlay(int(p*3800));
			} else {
				scrollbar.scrollBallBtn.x = int(song.currentFrame/3800*scrollbar.barMC.width);
			}
			
		}
		private function playClicked(event:MouseEvent):void {
			song.play();
		}
		private function stopClicked(e:MouseEvent):void {
			song.stop();
		}
		private function rewindDown(e:MouseEvent):void {
			song.gotoAndStop(song.currentFrame-1);
		}
		private function forwardDown(e:MouseEvent):void {
			song.gotoAndStop(song.currentFrame+1);
		}
		private function scrollDown(e:MouseEvent):void {
			scrollLocked=false;
			song.stop();
		}
		private function scrollUp(e:MouseEvent):void {
			scrollLocked=true;
		}
		public function leftDown():void {
			song.gotoAndStop(song.currentFrame-5);
		}
		public function rightDown():void {
			song.gotoAndStop(song.currentFrame+5);
		}
		public function upDown():void {
			song.play();
		}
		public function downDown():void {
			song.stop();
		}
		public function setZText(n:int) {
			zText.text="z="+n;
		}
		public function clearZText():void {
			zText.text="";
		}
		public function zSwitch(n:int) {
			GLOBAL.defaultZ=n-48;
			curZText.text="cur z="+GLOBAL.defaultZ;
		}
	}
}
