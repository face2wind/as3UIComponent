package face2wind.uiComponents
{
	import face2wind.uiComponents.enum.ScrollBarType;
	
	import face2wind.event.ParamEvent;
	import face2wind.lib.Reflection;
	import face2wind.manager.StageManager;
	import face2wind.view.BaseButton;
	import face2wind.view.BaseSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 垂直滚动条
	 * @author face2wind
	 */
	public class VScrollBar extends BaseSprite
	{
		public function VScrollBar(_newSkin:int = 1)
		{
			super();
			_skin = _newSkin;
			_h = 100; //初始化高度
			scrollHeight = 100; //初始化滚动高度
		}
		
		/**
		 * 向上滚动按钮 
		 */		
		private var upBtn:BaseButton = null;
		
		/**
		 * 向下滚动按钮 
		 */		
		private var downBtn:BaseButton = null;
		
		/**
		 * 拖动条按钮 
		 */		
		private var thumbBtn:BaseButton = null;
		
		/**
		 * 滚动条背景 
		 */		
		private var scrollBg:Sprite = null;
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			scrollBg = Reflection.createSpriteInstance("vscrollBar_"+skin+"_bg");
			addChild(scrollBg);
			
			upBtn = new BaseButton(
				"vscrollBar_"+skin+"_arrowUp_up",
				"vscrollBar_"+skin+"_arrowUp_down",
				"vscrollBar_"+skin+"_arrowUp_over");
			addChild(upBtn);
			downBtn = new BaseButton(
				"vscrollBar_"+skin+"_arrowDown_up",
				"vscrollBar_"+skin+"_arrowDown_down",
				"vscrollBar_"+skin+"_arrowDown_over");
			addChild(downBtn);
			thumbBtn = new BaseButton(
				"vscrollBar_"+skin+"_thumb_up",
				"vscrollBar_"+skin+"_thumb_down",
				"vscrollBar_"+skin+"_thumb_over");
			addChild(thumbBtn);
		}
		
		/**
		 * 皮肤有改动 
		 */		
		private var skinChange:Boolean = false;
		private var _skin:int = ScrollBarType.NORMAL;
		/**
		 * 皮肤类型 
		 */
		public function get skin():int
		{
			return _skin;
		}
		/**
		 * @private
		 */
		public function set skin(value:int):void
		{
			if(_skin == value)
				return;
			
			_skin = value;
			skinChange = true;
			layoutChange = true;
			propertyChange();
		}
		
		/**
		 * 屏蔽宽度设定（避免无谓的拉伸） 
		 * @param value
		 * 
		 */		
		public override function set width(value:Number):void
		{
		}
		
		/**
		 * 重写高度设定，直接设置到_h里，布局时用到 
		 * @param value
		 */		
		public override function set height(value:Number):void
		{
			if(_h == value)
				return;
			
			_h = value;
			layoutChange = true;
			propertyChange();
		}
		
		/**
		 * 暂存旧数据，用于变化时计算用 
		 */		
		private var _oldScrollHeight:Number = 0;
		private var _scrollHeight:Number = 0;
		/**
		 * 滚动条对应的容器高度（根据这个确定） 
		 */
		public function get scrollHeight():Number
		{
			return _scrollHeight;
		}
		/**
		 * @private
		 */
		public function set scrollHeight(value:Number):void
		{
			if(_scrollHeight == value)
				return;
			
			_oldScrollHeight = _scrollHeight;
			if(value > _h)
				_scrollHeight = value;
			else
				_scrollHeight = _h;
			
			layoutChange = true;
			propertyChange();
		}

		private var _curRate:Number = 0;
		/**
		 * 当前滚动条拖动的位置（当前位置相对容器总高度的百分比）
		 */
		public function get curRate():Number
		{
			return _curRate;
		}
		/**
		 * @private
		 */
		public function set curRate(value:Number):void
		{
			if(_curRate == value)
				return;
			
			_curRate = value;
			rateChange = true;
			propertyChange();
		}
		
		/**
		 * 布局改变 
		 */		
		private var layoutChange:Boolean = false;
		
		/**
		 * 开始拖动时，记录鼠标和滚动条的y偏差 
		 */		
		private var thumbStartMoveY:Number;
		
		/**
		 * 拖动进度改变 
		 */		
		private var rateChange:Boolean = false;
		
		/**
		 * 每次滚动的最小距离
		 */		
		private var scrollStepValue:Number = 30;

		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			if(skinChange)
			{
				updateSkins();
				skinChange = false;
			}
			if(layoutChange)
			{
				updateLayout();
				layoutChange = false;
			}
			if(rateChange)
			{
				rateChange = false;
				var targetY:Number = _curRate*scrollBg.height + scrollBg.y;
				if(targetY < upBtn.height)
					thumbBtn.y = upBtn.height;
				else if(targetY > (downBtn.y - thumbBtn.height))
					thumbBtn.y = downBtn.y - thumbBtn.height;
				else
					thumbBtn.y = targetY;
				_curRate = (thumbBtn.y-scrollBg.y)/scrollBg.height; //纠正一次进度
				dispatchEvent(new ParamEvent(Event.CHANGE, {curRate:_curRate}));
			}
		}
		
		/**
		 * 更新皮肤 
		 * 
		 */		
		private function updateSkins():void
		{
			if(scrollBg && contains(scrollBg))
				removeChild(scrollBg);
			scrollBg = Reflection.createSpriteInstance("vscrollBar_"+skin+"_bg");
			upBtn.updateBtnSkins("vscrollBar_"+skin+"_arrowUp_up",
				"vscrollBar_"+skin+"_arrowUp_down",
				"vscrollBar_"+skin+"_arrowUp_over");
			downBtn.updateBtnSkins(
				"vscrollBar_"+skin+"_arrowDown_up",
				"vscrollBar_"+skin+"_arrowDown_down",
				"vscrollBar_"+skin+"_arrowDown_over");
			thumbBtn.updateBtnSkins(
				"vscrollBar_"+skin+"_thumb_up",
				"vscrollBar_"+skin+"_thumb_down",
				"vscrollBar_"+skin+"_thumb_over");
		}
		
		/**
		 * 重新调整按钮、滚动条位置（根据按钮皮肤宽高以及滚动条对应的容器高度） <br/>
		 * 所有元素根据上滚按钮大小居中
		 */		
		private function updateLayout():void
		{
			upBtn.move(0,0);
			
			scrollBg.x = (upBtn.width-scrollBg.width)/2;
			scrollBg.y = upBtn.height;
			scrollBg.height = _h - upBtn.height - downBtn.height;
			
			downBtn.x = (upBtn.width-downBtn.width)/2;
			downBtn.y = scrollBg.y + scrollBg.height;
			
			thumbBtn.height = scrollBg.height*(_h/scrollHeight); // 滚动按钮高度/滚动条高度 = 当前要显示的内容高度/滚动背景总高度
			thumbBtn.x = scrollBg.x + (scrollBg.width-thumbBtn.width)/2;
			thumbBtn.y = scrollBg.y + (scrollBg.height-thumbBtn.height)*curRate;
			
			if(_oldScrollHeight > scrollHeight) //滚动内容从大变小，需要调整当前进度
				curRate = _oldScrollHeight*curRate/scrollHeight;
		}
		
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			upBtn.addEventListener(MouseEvent.CLICK , onUpBtnMouseClickedHandler);
			downBtn.addEventListener(MouseEvent.CLICK , onDownBtnMouseClickedHandler);
			thumbBtn.addEventListener(MouseEvent.MOUSE_DOWN , onThumbDownHandler);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP , onStageMouseUpHandler);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			upBtn.removeEventListener(MouseEvent.CLICK , onUpBtnMouseClickedHandler);
			downBtn.removeEventListener(MouseEvent.CLICK , onDownBtnMouseClickedHandler);
			thumbBtn.removeEventListener(MouseEvent.MOUSE_DOWN , onThumbDownHandler);
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP , onStageMouseUpHandler);
		}
		
		/**
		 * 控制滚动条滚动，默认滚动 scrollStepValue*times 的距离
		 * @param times
		 * 
		 */		
		public function scrollStep(times:Number = 1):void
		{
			var additionRate:Number = scrollStepValue*times/scrollHeight;
			additionRate = curRate + additionRate;
			curRate = ajustRateAddition(additionRate);
		}
		
		/**
		 * 调整一个百分比值增量值，使其大于等于0，小于等于1 
		 * @param rate
		 * @return 
		 * 
		 */		
		private function ajustRateAddition(rate:Number):Number
		{
			if(0 > rate)
				rate = 0;
			else if(1 < rate)
				rate = 1;
			return rate;
		}
		
		/**
		 * 鼠标拖动滚动条移动事件 
		 * @param event
		 * 
		 */		
		protected function onMouseThumbMoveHandler(event:MouseEvent):void
		{
			var targetY:Number = mouseY + thumbStartMoveY;
			if(targetY < upBtn.height)
				thumbBtn.y = upBtn.height;
			else if(targetY > (downBtn.y - thumbBtn.height))
				thumbBtn.y = downBtn.y - thumbBtn.height;
			else
				thumbBtn.y = targetY;
			_curRate = (thumbBtn.y-scrollBg.y)/scrollBg.height;
			dispatchEvent(new ParamEvent(Event.CHANGE, {curRate:_curRate}));
		}
		
		/**
		 * 向上滚动按钮按下 
		 * @param event
		 * 
		 */		
		protected function onUpBtnMouseClickedHandler(event:MouseEvent):void
		{
			scrollStep(-1);
		}
		
		/**
		 * 向下滚动按钮按下 
		 * @param event
		 * 
		 */	
		protected function onDownBtnMouseClickedHandler(event:MouseEvent):void
		{
			scrollStep(1);
		}
		
		/**
		 * 滚动条按下 
		 * @param event
		 * 
		 */		
		protected function onThumbDownHandler(event:MouseEvent):void
		{
			thumbStartMoveY = thumbBtn.y - mouseY;
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseThumbMoveHandler);
		}
		
		/**
		 * 场景弹起（弹起动作不一定在滚动条上派发） 
		 * @param event
		 * 
		 */		
		protected function onStageMouseUpHandler(event:MouseEvent):void
		{
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMouseThumbMoveHandler);
		}
	}
}