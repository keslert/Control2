package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import mochi.as3.*;

	public class GUI extends MovieClip{
		
		private var F_delay:int;
		public function GUI() {
			topGameplodeBtn.addEventListener(MouseEvent.CLICK, openGameplodeWebpage);
		}
		public function setScore(score:int) {
			this.scoreText.text = ""+score;
		}
		public function setPercentage(n:int) {
			this.percentageText.text = ""+n+"%";
		}
		public function setCurrentStreak(n:int) {
			this.streakText.text = ""+n;
		}
		public function bonus(n:int):void {
			if(n==50) {
				this.streakMC.streak_in.bonusText.text = "x2";
				this.streakMC.streak_in.streakText.text = "50 streak";
				
			} else if(n==100) {
				this.streakMC.streak_in.bonusText.text = "x3";
				this.streakMC.streak_in.streakText.text = "100 streak";
			} else if(n==150) {
				this.streakMC.streak_in.bonusText.text = "x4";
				this.streakMC.streak_in.streakText.text = "150 streak";
			} else if(n==200) {
				this.streakMC.streak_in.bonusText.text = "x8";
				this.streakMC.streak_in.streakText.text = "200 streak";
			}
			GLOBAL.brickColor=GLOBAL.colors[int(n/50)];
			this.streakMC.play();
		}
		public function playMiss():void {
			this.missMC.play();
			GLOBAL.brickColor=GLOBAL.colors[0];
		}
		public function playEnd():void {
			this.endScore.gotoAndStop(2);
			startAd();
			F_delay = 0;
			this.addEventListener(Event.ENTER_FRAME,updateFinalScore);
		}
		private function updateFinalScore(e:Event):void {
			F_delay++;
			if(F_delay < 25) {
				endScore.F_missedText.text = getRandomText(GLOBAL.ss.getMissed());
			} else if(F_delay < 50) {
				endScore.F_missedText.text = GLOBAL.ss.getMissed();
				endScore.F_hitText.text = getRandomText(GLOBAL.ss.getHit());
			} else if(F_delay < 75) {
				endScore.F_hitText.text = GLOBAL.ss.getHit();
				endScore.F_bestStreakText.text = getRandomText(GLOBAL.ss.getBestStreak());
			} else if(F_delay < 100) {
				endScore.F_bestStreakText.text = GLOBAL.ss.getBestStreak();
				endScore.F_percentText.text = getRandomText(GLOBAL.ss.getPercentage())+"%";
			} else if(F_delay < 125) {
				endScore.F_percentText.text = GLOBAL.ss.getPercentage()+"%";
				endScore.F_scoreText.text = getRandomText(GLOBAL.ss.getScore());
			} else if(F_delay < 150) {
				endScore.F_scoreText.text = GLOBAL.ss.getScore();
				endScore.F_finalScoreText.text = getRandomText(GLOBAL.ss.getFinalScore());
			} else {
				endScore.F_finalScoreText.text = GLOBAL.ss.getFinalScore();
				this.removeEventListener(Event.ENTER_FRAME,updateFinalScore);
			}
			
		}
		private function getRandomText(size):String {
			var s:String = ""+size;
			var b:String = "";
			for(var i=0;i<s.length;i++) {
				b+=""+int(Math.random()*10);
			}
			return b;
		}
		public function restart():void {
			MochiAd.unload(clickAwayAdMC);
			endScore.gotoAndStop(1);
		}
		public function submitScore():void {
			var o:Object = { n: [2, 8, 0, 15, 0, 6, 7, 13, 0, 5, 11, 6, 5, 8, 1, 10], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"");
			MochiScores.showLeaderboard({boardID: boardID, score: GLOBAL.ss.getScore()});
		}
		private function startAd():void {
			MochiAd.showClickAwayAd( {
                id: "3a8698b0b9e90877",    // This is the game ID for displaying ads!
                clip: clickAwayAdMC        // We are displaying in a container (which is dynamic)
            } );
		}
		private function openGameplodeWebpage(event:MouseEvent):void {
			navigateToURL(new URLRequest("http://www.gameplode.com"), "_blank");
		}
	}
}
