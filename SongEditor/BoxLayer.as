package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class BoxLayer {
		private var song:Song;
		private var speed:int;
		private var _r:Sprite;
		private var blocks:Array;
		private var mc:Sprite;
		private var curBlock:Vector3D;
		private var copyStart:Vector3D;
		private var copyEnd:Vector3D;
		private var undoArray:Array;
		public function BoxLayer(_r:Sprite) {
			this._r = _r;
			this.song = GLOBAL.song;
			mc = new Sprite();
			mc.cacheAsBitmap = true;
			this._r.addChild(mc);
			blocks = new Array();
			speed=8;
			mc.addEventListener(Event.ENTER_FRAME,update);
			_r.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseClickDown);
			_r.stage.addEventListener(MouseEvent.MOUSE_UP,mouseClickUp);
			setup();
			drawLines();
		}
		private function update(e:Event):void {
			mc.x = -song.currentFrame*speed;
			if(curBlock!=null) {
				calcTail(curBlock);
			}
		}
		private function addBlock():void {
			var x1 = int(_r.mouseX/speed)*speed;
			var y1 = int(_r.mouseY/10)*10;
			var newX = song.currentFrame*speed+x1;
			var found:Boolean = false;
			for(var i:int=blocks.length-1;i>0;i--) {
				var v:Vector3D = blocks[i];
				if(v.x==newX && v.y==y1) found = true;
			}
			if(!found) {
				blocks.push(new Vector3D(newX,y1,GLOBAL.defaultZ));
				drawBlock(newX,y1,GLOBAL.defaultZ,0x333333);
			}
		}
		private function mouseClickDown(event:MouseEvent) {
			if(_r.mouseY > 0 && _r.mouseY < 370) {
				if(GLOBAL.ctrlDown)	addBlock();
				else if(GLOBAL.shftDown) {
					curBlock = findBlock();
				} else if(GLOBAL.zDown) {
					removeBlock();
				} else if(GLOBAL.cDown) {
					if(copyStart!=null)
						drawBlock(copyStart.x,copyStart.y,copyStart.z,0x222222);
					copyStart = findBlock();
					drawBlock(copyStart.x,copyStart.y,copyStart.z,0x00FF00);
				} else if(GLOBAL.vDown) {
					if(copyEnd!=null)
						drawBlock(copyEnd.x,copyEnd.y,copyEnd.z,0x222222);
					copyEnd = findBlock();
					drawBlock(copyEnd.x,copyEnd.y,copyEnd.z,0xFF0000);
				} else if(GLOBAL.bDown) {
					paste();
				} else if(GLOBAL.aDown) {
					addBeat();
				} 
			}
		}
		private function mouseClickUp(event:MouseEvent) {
			curBlock=null;
			GLOBAL.controller.clearZText();
		}
		private function addBeat():void {
			var v:Vector3D=findBlock();
			if(v!=null) {
				v.z *=-1;
				if(v.z < 0) drawBlock(v.x,v.y,v.z,0xCC6600);
				else drawBlock(v.x,v.y,v.z,0x222222);
			}
		}
		private function findBlock():Vector3D {
			var v:Vector3D;
			var ret_v:Vector3D;
			var l = blocks.length;
			var dist:Number;
			var s_dist:Number=30;
			for(var i:int=0;i<l;i++) {
				v=blocks[i];
				dist = calcDist(v);
				if(dist<s_dist) {
					ret_v=v;
					s_dist = dist;
				}
			}
			return ret_v;
		}
		private function removeBlock():void {
			var v:Vector3D;
			var l = blocks.length;
			var dist:Number;
			var s_dist:Number=30;
			var i_save:int;
			for(var i:int=0;i<l;i++) {
				dist = calcDist(blocks[i]);
				if(dist<s_dist) {
					v=blocks[i];
					s_dist = dist;
					i_save = i;
				}
			}
			if(v!=null) {
				blocks.splice(i_save,1);
				clearBlock(v.x,v.y,v.z);
			}
		}
		private function calcDist(v:Vector3D):Number {
			var x1 = v.x-mc.mouseX;
			var y1 = v.y-_r.mouseY;
			return Math.sqrt(x1*x1+y1*y1);
		}
		public function drawBlock(x1:int,y1:int,z1:int,color:int):void {
			mc.graphics.lineStyle(2,color,1);
			mc.graphics.moveTo(x1,y1);
			mc.graphics.lineTo(x1+Math.abs(z1)*8,y1);
			mc.graphics.drawRect(x1-5,y1-5,10,10);
		}
		private function calcTail(v:Vector3D):void {
			drawPath(v.x,v.y,v.z,true);
			v.z = int((mc.mouseX-v.x)/8);
			GLOBAL.controller.setZText(Math.abs(v.z));
			drawPath(v.x,v.y,v.z,false);
		}
		private function drawPath(x1:int,y1:int,z1:int,clean:Boolean):void {
			if(clean) mc.graphics.lineStyle(2,0x000000,1);
			else mc.graphics.lineStyle(2,0x333333,1);
			mc.graphics.moveTo(x1,y1);
			mc.graphics.lineTo(x1+Math.abs(z1)*8,y1);
		}
		private function clearBlock(x1:int,y1:int,z1:int):void {
			mc.graphics.lineStyle(2,0x000000,1);
			mc.graphics.moveTo(x1,y1);
			mc.graphics.lineTo(x1+Math.abs(z1)*8,y1);
			mc.graphics.drawRect(x1-5,y1-5,10,10);
		}
		private function drawLines() {
			for(var i:int=0;i<400;i++) {
				mc.graphics.lineStyle(1,0x333333,1);
				mc.graphics.moveTo(-mc.x+550+80*i,0);
				mc.graphics.lineTo(-mc.x+550+80*i,372);
			}
		}
		public function erase() {
			undoArray = new Array();
			if(copyStart!=null && copyEnd!=null && copyStart.x < copyEnd.x) {
				var l=blocks.length;
				var v:Vector3D;
				for(var i:int=l-1;i>-1;i--) {
					v=blocks[i];
					if(v.x >= copyStart.x && v.x <= copyEnd.x) {
						blocks.splice(i,1);
						clearBlock(v.x,v.y,v.z);
					}
				}
			}
		}
		private function paste() {
			undoArray = new Array();
			if(copyStart!=null && copyEnd!=null && copyStart.x <= copyEnd.x) {
				var l=blocks.length;
				var v:Vector3D;
				for(var i:int=0;i<l;i++) {
					v=blocks[i];
					if(v.x >= copyStart.x && v.x <= copyEnd.x) {
						addBlockFromPaste(v.x-copyStart.x,v.y,v.z);
					}
				}
			}
		}
		private function addBlockFromPaste(x1:int,y1:int,z1:int) {
			var newX:int = x1+int(mc.mouseX/speed)*speed;
			var v:Vector3D = new Vector3D(newX,y1,z1);
			blocks.push(v);
			undoArray.push(v);
			if(v.z < 0) drawBlock(v.x,v.y,v.z,0xCC6600);
			else drawBlock(v.x,v.y,v.z,0x222222);
		}
		public function undo() {
			if(undoArray!=null && undoArray.length > 0) {
				var l:int = undoArray.length;
				var v:Vector3D;
				for(var i:int=0;i<l;i++) {
					v=undoArray[i];
					clearBlock(v.x,v.y,v.z);
				}
				blocks.splice(blocks.length-i,i);
				undoArray = null;
			}
		}
		public function printOut():void {
			var s:String="var points=[\n";
			var len:int=blocks.length;
			var v:Vector3D;
			blocks.sort(blockSorter);
			for(var i:int=0;i<len;i++) {
				v=blocks[i];
				var frame = int((v.x-550)/speed);
				//frame,yposition,# blocks
				s+="["+frame+","+v.y+","+v.z+"],";
			}
			s=s.substring(0,s.length-1);
			s+="];";
			trace(s);
		}
		private function restoreBlock(frame:int,y1:int,z1:int):void {
			var newX = frame*speed+550;
			blocks.push(new Vector3D(newX,y1,z1));
			var color = (z1 > 0) ? 0x333333 : 0xCC6600;
			drawBlock(newX,y1,z1,color);
		}
		private function blockSorter(a, b):int 
		{ 
			if (a.x < b.x) 
			{ 
				return 1; 
			} 
			else if (a.x > b.x) 
			{ 
				return -1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
		private function setup():void {
			var points=[[3705,170,-29],[3694,200,5],[3686,270,5],[3675,330,5],[3665,280,5],[3657,230,5],[3651,180,5],[3643,120,5],[3634,70,5],[3623,40,5],[3611,70,5],[3600,120,5],[3590,170,5],[3570,190,-5],[3570,150,-5],[3557,230,-5],[3557,270,-5],[3546,190,-5],[3546,150,-5],[3539,70,-3],[3539,110,-3],[3504,150,-18],[3504,190,-18],[3488,110,-11],[3488,70,-11],[3481,170,1],[3478,220,1],[3462,260,-10],[3462,310,-10],[3453,200,-4],[3453,170,-4],[3445,200,-4],[3445,170,-4],[3409,250,-22],[3409,290,-22],[3392,200,-10],[3392,170,-10],[3381,190,-5],[3381,150,-5],[3368,230,-5],[3368,270,-5],[3357,150,-5],[3357,190,-5],[3350,70,-3],[3350,110,-3],[3315,150,-18],[3315,190,-18],[3299,110,-11],[3299,70,-11],[3292,170,1],[3289,220,1],[3273,260,-10],[3273,310,-10],[3264,200,-4],[3264,170,-4],[3256,170,-4],[3256,200,-4],[3220,290,-22],[3220,250,-22],[3203,170,-10],[3203,200,-10],[3191,330,4],[3189,270,4],[3186,210,4],[3183,150,4],[3180,90,4],[3177,40,4],[3172,110,1],[3166,210,-2],[3166,170,-2],[3159,170,-2],[3159,210,-2],[3149,260,1],[3141,330,1],[3130,280,-2],[3130,240,-2],[3118,240,-2],[3118,280,-2],[3106,280,-2],[3106,240,-2],[3100,160,1],[3094,280,1],[3085,170,-2],[3085,210,-2],[3079,280,1],[3073,210,-2],[3073,170,-2],[3066,210,-2],[3066,170,-2],[3052,190,1],[3046,280,1],[3036,170,-2],[3036,200,-2],[3024,170,-2],[3024,200,-2],[3014,170,-2],[3014,200,-2],[3004,310,5],[2978,60,14],[2955,320,13],[2932,60,14],[2909,320,16],[2886,60,14],[2875,210,3],[2861,320,-2],[2848,260,-2],[2836,180,1],[2829,100,1],[2827,100,1],[2820,180,1],[2813,270,-2],[2803,180,-2],[2795,110,-2],[2785,110,-2],[2770,110,1],[2763,200,1],[2754,160,-2],[2741,90,1],[2736,210,1],[2729,110,1],[2723,200,1],[2716,270,1],[2709,200,-2],[2699,110,1],[2693,110,1],[2685,170,-2],[2673,320,-2],[2660,260,-2],[2648,180,1],[2641,100,1],[2639,100,1],[2632,180,1],[2625,270,-2],[2615,180,-2],[2607,110,-2],[2597,110,-2],[2582,110,1],[2575,200,1],[2566,160,-2],[2553,90,1],[2548,210,1],[2541,110,1],[2535,200,1],[2528,270,1],[2519,200,-2],[2511,110,1],[2501,110,1],[2494,170,-2],[2484,320,-2],[2471,260,-2],[2460,180,-2],[2451,100,1],[2447,100,1],[2442,180,1],[2434,270,1],[2425,180,-2],[2418,110,-2],[2406,110,-2],[2394,110,1],[2387,200,1],[2376,160,-2],[2365,90,1],[2360,210,1],[2353,110,1],[2347,200,1],[2340,270,1],[2330,200,-3],[2323,110,1],[2314,110,1],[2306,170,-3],[2291,240,3],[2282,190,3],[2274,140,3],[2264,90,3],[2254,140,3],[2244,180,3],[2235,140,3],[2226,100,3],[2218,140,3],[2210,190,3],[2201,230,3],[2193,270,3],[2185,230,3],[2176,200,3],[2168,230,3],[2161,270,3],[2155,300,3],[2146,330,3],[2141,310,3],[2136,280,3],[2131,250,3],[2126,220,3],[2120,190,3],[2114,160,3],[2108,130,3],[2101,100,3],[2094,70,3],[2085,100,3],[2076,140,3],[2068,170,3],[2060,200,3],[2053,230,3],[2046,260,3],[2037,300,3],[2027,330,3],[2018,300,3],[2010,270,3],[2003,230,3],[1995,190,3],[1986,150,3],[1975,110,3],[1964,150,3],[1955,190,3],[1947,230,3],[1940,270,3],[1932,310,3],[1916,320,1],[1903,260,1],[1891,180,1],[1884,100,1],[1881,100,1],[1875,180,1],[1867,270,1],[1856,180,1],[1850,110,1],[1839,110,1],[1827,110,1],[1820,200,1],[1809,160,1],[1798,90,1],[1793,210,1],[1786,110,1],[1780,200,1],[1773,270,1],[1763,200,1],[1756,110,1],[1746,110,1],[1739,170,1],[1728,320,1],[1715,260,1],[1703,180,1],[1696,100,1],[1692,100,1],[1687,180,1],[1679,270,1],[1668,180,1],[1662,110,1],[1651,110,1],[1639,110,1],[1632,200,1],[1621,160,1],[1610,90,1],[1605,210,1],[1598,110,1],[1592,200,1],[1585,270,1],[1575,200,1],[1568,110,1],[1559,110,1],[1551,170,1],[1539,190,1],[1527,190,1],[1517,190,1],[1506,320,1],[1493,260,1],[1481,180,1],[1474,100,1],[1471,100,1],[1465,180,1],[1457,270,1],[1446,180,1],[1440,110,1],[1429,110,1],[1417,110,1],[1410,200,1],[1399,160,1],[1388,90,1],[1383,210,1],[1376,110,1],[1370,200,1],[1363,270,1],[1353,200,1],[1346,110,1],[1336,110,1],[1329,170,1],[1318,320,1],[1305,260,1],[1293,180,1],[1286,100,1],[1282,100,1],[1277,180,1],[1269,270,1],[1258,180,1],[1252,110,1],[1241,110,1],[1229,110,1],[1222,200,1],[1211,160,1],[1200,90,1],[1195,210,1],[1188,110,1],[1182,200,1],[1175,270,1],[1165,200,1],[1158,110,1],[1149,110,1],[1141,170,1],[1131,330,4],[1129,270,4],[1126,210,4],[1123,150,4],[1120,90,4],[1117,40,4],[1112,110,1],[1106,210,-2],[1106,170,-2],[1099,210,-2],[1099,170,-2],[1089,260,1],[1081,330,1],[1070,280,-2],[1070,240,-2],[1058,240,-2],[1058,280,-2],[1046,240,-2],[1046,280,-2],[1039,160,1],[1034,280,1],[1025,210,-2],[1025,170,-2],[1019,280,1],[1013,170,-2],[1013,210,-2],[1006,170,-2],[1006,210,-2],[992,190,1],[986,280,1],[976,200,-2],[976,170,-2],[964,170,-2],[964,200,-2],[954,170,-2],[954,200,-2],[942,330,4],[940,270,4],[937,210,4],[934,150,4],[931,90,4],[928,40,4],[923,110,1],[917,170,-2],[917,210,-2],[910,170,-2],[910,210,-2],[900,260,1],[892,330,1],[881,240,-2],[881,280,-2],[869,280,-2],[869,240,-2],[857,280,-2],[857,240,-2],[851,160,1],[845,280,1],[836,210,-2],[836,170,-2],[830,280,1],[824,210,-2],[824,170,-2],[817,210,-2],[817,170,-2],[803,190,1],[797,280,1],[787,170,-2],[787,200,-2],[775,170,-2],[775,200,-2],[765,170,-2],[765,200,-2],[727,320,1],[714,260,1],[702,180,1],[695,100,1],[692,100,1],[686,180,1],[678,270,1],[667,180,1],[661,110,1],[650,110,1],[638,110,1],[631,200,1],[620,160,1],[609,90,1],[604,210,1],[597,110,1],[591,200,1],[584,270,1],[574,200,1],[567,110,1],[557,110,1],[550,170,1],[539,320,1],[526,260,1],[514,180,1],[507,100,1],[503,100,1],[498,180,1],[490,270,1],[479,180,1],[473,110,1],[462,110,1],[450,110,1],[443,200,1],[432,160,1],[421,90,1],[416,210,1],[409,110,1],[403,200,1],[396,270,1],[386,200,1],[379,110,1],[370,110,1],[362,170,1],[352,320,1],[339,260,1],[327,180,1],[320,100,1],[316,100,1],[311,180,1],[303,270,1],[292,180,1],[286,110,1],[275,110,1],[263,110,1],[256,200,1],[245,160,1],[222,110,1],[216,200,1],[209,270,1],[199,200,1],[192,110,1],[186,110,1],[175,170,1],[163,230,1],[153,270,1],[141,270,1],[129,270,1],[117,270,1],[104,270,1],[90,270,1],[77,270,1],[65,230,1],[55,190,1],[44,190,1],[34,190,1]];
			var l:int=points.length;
			for(var i:int=0;i<l;i++) {
				restoreBlock(points[i][0],points[i][1],points[i][2]);
			}
		}
	}
}
