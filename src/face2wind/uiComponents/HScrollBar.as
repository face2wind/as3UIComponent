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
	 * 水平滚动条
	 * @author face2wind
	 */
	public class HScrollBar extends BaseSprite
	{
		public function HScrollBar(_newSkin:int = 1)
		{
			super();
			_skin = _newSkin;
			_w = 100; //初始化宽度
			scrollWidth = 100; //初始化滚动宽度
		}
		
		/**
		 * 向上滚动按钮 
		 */		
		private var leftBtn:BaseButton = null;
		
		/**
		 * 向下滚动按钮 
		 */		
		private var rightBtn:BaseButton = null;
		
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
			
			scrollBg = Reflection.createSpriteInstance("hscrollBar_"+skin+"_bg");
			addChild(scrollBg);
			
			leftBtn = new BaseButton(
				"hscrollBar_"+skin+"_arrowLeft_up",
				"hscrollBar_"+skin+"_arrowLeft_down",
				"hscrollBar_"+skin+"_arrowLeft_over");
			addChild(leftBtn);
			rightBtn = new BaseButton(
				"hscrollBar_"+skin+"_arrowRight_up",
				"hscrollBar_"+skin+"_arrowRight_down",
				"hscrollBar_"+skin+"_arrowRight_over");
			addChild(rightBtn);
			thumbBtn = new BaseButton(
				"hscrollBar_"+skin+"_thumb_up",
				"hscrollBar_"+skin+"_thumb_down",
				"hscrollBar_"+skin+"_thumb_over");
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
		 * 重写宽度设定，直接设置到_w里，布局时用到 
		 * @param value
		 * 
		 */		
		public override function set width(value:Number):void
		{
			if(_w == value)
				return;
			
			_w = value;
			layoutChange = true;
			propertyChange();
		}
		
		/**
		 * 屏蔽高度设定（避免无谓的拉伸） 
		 * @param value
		 */		
		public override function set height(value:Number):void
		{
		}
		
		/**
		 * 暂存上次的滚动宽度 
		 */		
		private var _oldScrollWidth:Number = 0;
		private var _scrollWidth:Number = 0;
		/**
		 * 滚动条对应的容器宽度（根据这个确定按钮和拖动条位置） 
		 */
		public function get scrollWidth():Number
		{
			return _scrollWidth;
		}
		/**
		 * @private
		 */
		public function set scrollWidth(value:Number):void
		{
			if(_scrollWidth == value)
				return;
			
			_oldScrollWidth = _scrollWidth;
			if(value > _w)
				_scrollWidth = value;
			else
				_scrollWidth = _w;
			
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
		private var thumbStartMoveX:Number;
		
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
				var targetX:Number = curRate*scrollBg.width + scrollBg.x;
				if(targetX < leftBtn.width)
					thumbBtn.x = leftBtn.width;
				else if(targetX > (rightBtn.x - thumbBtn.width))
					thumbBtn.x = rightBtn.x - thumbBtn.width;
				else
					thumbBtn.x = targetX;
				_curRate = (thumbBtn.x-scrollBg.x)/scrollBg.width;
				dispatchEvent(new ParamEvent(Event.CHANGE, {curRate:_curRate}));
				
				rateChange = false;
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
			scrollBg = Reflection.createSpriteInstance("hscrollBar_"+skin+"_bg");
			leftBtn.updateBtnSkins("hscrollBar_"+skin+"_arrowLeft_up",
				"hscrollBar_"+skin+"_arrowLeft_down",
				"hscrollBar_"+skin+"_arrowLeft_over");
			rightBtn.updateBtnSkins(
				"hscrollBar_"+skin+"_arrowRight_up",
				"hscrollBar_"+skin+"_arrowRight_down",
				"hscrollBar_"+skin+"_arrowRight_over");
			thumbBtn.updateBtnSkins(
				"hscrollBar_"+skin+"_thumb_up",
				"hscrollBar_"+skin+"_thumb_down",
				"hscrollBar_"+skin+"_thumb_over");
		}
		
		/**
		 * 重新调整按钮、滚动条位置（根据按钮皮肤宽高以及滚动条对应的容器高度） <br/>
		 * 所有元素根据上滚按钮大小居中
		 */		
		private function updateLayout():void
		{
			leftBtn.move(0,0);
			
			scrollBg.y = (leftBtn.height-scrollBg.height)/2;
			scrollBg.x = leftBtn.width;
			scrollBg.width = _w - leftBtn.height - rightBtn.height;
			
			rightBtn.y = (leftBtn.height-rightBtn.height)/2;
			rightBtn.x = scrollBg.x + scrollBg.width;
			
			thumbBtn.width = (_w/scrollWidth)*scrollBg.width;
			thumbBtn.y = scrollBg.y + (scrollBg.height-thumbBtn.height)/2;
			thumbBtn.x = scrollBg.x + (scrollBg.width-thumbBtn.width)*curRate;
			
			if(_oldScrollWidth > scrollWidth) //滚动内容从大变小，需要调整当前进度
				curRate = _oldScrollWidth*curRate/scrollWidth;
		}
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			leftBtn.addEventListener(MouseEvent.CLICK , onLeftBtnMouseClickedHandler);
			rightBtn.addEventListener(MouseEvent.CLICK , onRightBtnMouseClickedHandler);
			thumbBtn.addEventListener(MouseEvent.MOUSE_DOWN , onThumbDownHandler);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP , onStageMouseUpHandler);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			leftBtn.removeEventListener(MouseEvent.CLICK , onLeftBtnMouseClickedHandler);
			rightBtn.removeEventListener(MouseEvent.CLICK , onRightBtnMouseClickedHandler);
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
			var additionRate:Number = scrollStepValue*times/scrollWidth;
			additionRate = curRate + additionRate;
			curRate = ajustRateAddition(additionRate);
		}
		
		/**
		 * 调整一个百分比值增量值，使其大于等于0，小于等于1 
		 * @param rate
		 * @return 
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
			var targetX:Number = mouseX + thumbStartMoveX;
			if(targetX < leftBtn.width)
				thumbBtn.x = leftBtn.width;
			else if(targetX > (rightBtn.x - thumbBtn.width))
				thumbBtn.x = rightBtn.x - thumbBtn.width;
			else
				thumbBtn.x = targetX;
			_curRate = (thumbBtn.x-scrollBg.x)/scrollBg.width;
			dispatchEvent(new ParamEvent(Event.CHANGE, {curRate:_curRate}));
		}
		
		/**
		 * 向上滚动按钮按下 
		 * @param event
		 * 
		 */		
		protected function onLeftBtnMouseClickedHandler(event:MouseEvent):void
		{
			scrollStep(-1);
		}
		
		/**
		 * 向下滚动按钮按下 
		 * @param event
		 * 
		 */	
		protected function onRightBtnMouseClickedHandler(event:MouseEvent):void
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
			thumbStartMoveX = thumbBtn.x - mouseX;
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


