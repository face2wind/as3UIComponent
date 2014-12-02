package face2wind.customUIComponents
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import face2wind.manager.StageManager;
	import face2wind.view.BaseSprite;

	public class Fps extends BaseSprite
	{
		private var diagramTimer:int;
		private var tfTimer:int;
		/**
		 * 内存使用文本 
		 */		
		private var mem:TextField;
		/**
		 * 曲线绘图背景 
		 */		
		private var diagram:BitmapData;
		private var skins:int = -1;
		/**
		 * 帧频文本 
		 */		
		private var fps:TextField;
		private var tfDelay:int = 0;
		private var skinsChanged:int = 0;
		/**
		 * 最大能显示的内存
		 */		
		static private const maxMemory:uint = 500000000; // 500M
		
		static private const tfDelayMax:int = 10;
		/**
		 * 显示曲线图的宽度 
		 */
		static private const diagramWidth:uint = 60;
		/**
		 * 显示曲线图的高度 
		 */		
		static private const diagramHeight:uint = 40;

		/**
		 * 全局舞台引用 
		 */		
		private var gameStage:Stage;
		
		public function Fps()
		{
		}

		protected override function createChildren():void
		{
			super.createChildren();
			gameStage = StageManager.getInstance().stage;
			
			fps = new TextField();
			mem = new TextField();
			
			mouseEnabled = false;
			mouseChildren = false;
			
			fps.defaultTextFormat = new TextFormat("Tahoma", 10, 0xff0000);
			fps.autoSize = TextFieldAutoSize.LEFT;
			fps.text = "FPS: " + Number(gameStage.frameRate).toFixed(2);
			fps.selectable = false;
			fps.x = 0;//-diagramWidth - 2;
			addChild(fps);
			mem.defaultTextFormat = new TextFormat("Tahoma", 10, 0x00ff00);
			mem.autoSize = TextFieldAutoSize.LEFT;
			mem.text = "MEM: " + bytesToString(System.totalMemory);
			mem.selectable = false;
			mem.x = 0;//-diagramWidth - 2;
			mem.y = 10;
			addChild(mem);
			
			diagram = new BitmapData(diagramWidth, diagramHeight, true
				, 0x0000ff);
			var _loc_2:Bitmap;
			_loc_2 = new Bitmap(diagram);
			_loc_2.y = 24;
			_loc_2.x = 2;//-diagramWidth;
			addChildAt(_loc_2, 0);
			
			diagramTimer = getTimer();
			tfTimer = getTimer();
		}

		/**
		 * 把占用内存大小转化成字符串
		 * @param byteSize 单位是比特
		 * @return 
		 * 
		 */		
		private function bytesToString(byteSize:uint):String
		{
			var _loc_2:String;
			if (byteSize < 1024)
			{
				_loc_2 = String(byteSize) + "b";
			}
			else if (byteSize < 10240)
			{
				_loc_2 = Number(byteSize / 1024).toFixed(2) + "kb";
			}
			else if (byteSize < 102400)
			{
				_loc_2 = Number(byteSize / 1024).toFixed(1) + "kb";
			}
			else if (byteSize < 1048576)
			{
				_loc_2 = Math.round(byteSize / 1024) + "kb";
			}
			else if (byteSize < 10485760)
			{
				_loc_2 = Number(byteSize / 1048576).toFixed(2) + "mb";
			}
			else if (byteSize < 104857600)
			{
				_loc_2 = Number(byteSize / 1048576).toFixed(1) + "mb";
			}
			else
			{
				_loc_2 = Math.round(byteSize / 1048576) + "mb";
			}
			return _loc_2;
		}

		private function onEnterFrame(param1:Event):void
		{
			if(!isOnshow) //已不在显示列表里，不处理
				return;
			
			tfDelay++;
			if (tfDelay >= tfDelayMax)
			{
				tfDelay = 0;
				var fpsNum:Number = 1000 * tfDelayMax / (getTimer() - tfTimer);
				fps.text = "FPS: " + fpsNum.toFixed(2);
				tfTimer = getTimer();
			}
			var _loc_2:* = 1000 / (getTimer() - diagramTimer);
			var curFrameRate:* = _loc_2 > gameStage.frameRate ? (1) : (_loc_2 / gameStage.frameRate); //当前帧率
			var _loc_4:* = skins == 0 ? (0) : (skinsChanged / skins);
			var memRate:* = System.totalMemory / maxMemory; //当前内存使用率
			mem.text = "MEM: " + bytesToString(System.totalMemory);
			diagramTimer = getTimer();
			diagram.scroll(1, 0);
			diagram.fillRect(new Rectangle(0, 0, 1, diagram.height), 0xaa000000);
			diagram.setPixel32(0, diagramHeight * (1 - curFrameRate), 0xffff0000);
			diagram.setPixel32(0, diagramHeight * (1 - _loc_4), 0xffffffff);
			diagram.setPixel32(0, diagramHeight * (1 - memRate), 0xff00ff00);
			return;
		}
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}
