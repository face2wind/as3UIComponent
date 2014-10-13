package face2wind.uiComponents
{
	import face2wind.uiComponents.enum.ScrollBarPositionType;
	import face2wind.uiComponents.enum.ScrollBarType;
	import face2wind.uiComponents.enum.ScrollBarVisibleType;
	
	import face2wind.event.ParamEvent;
	import face2wind.view.BaseSprite;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 可滚动容器，包括横竖滚动条，内容超出范围自动出现滚动条
	 * @author face2wind
	 */
	public class ScrollPane extends BaseSprite
	{
		/**
		 * 垂直滚动条 
		 */		
		private var vscrollBar:VScrollBar;
		
		/**
		 * 水平滚动条 
		 */		
		private var hscrollBar:HScrollBar;
		
		private var _scrollContent:BaseSprite;
		/**
		 * 滚动条容器 
		 */
		public function get scrollContent():BaseSprite
		{
			return _scrollContent;
		}
		
		public function ScrollPane(_newSkin:int = 1)
		{
			super();
			skin = _newSkin;
		}
		
		/**
		 * 遮罩对象（用于遮罩滚动容器） 
		 */		
		private var maskBg:Shape;
		
		private var _scrollBarPosition:int = ScrollBarPositionType.RIGHT_BOTTOM;
		/**
		 * 滚动条位置设置（同时设置垂直、水平滚动条，详见ScrollBarPositionType） 
		 */
		public function get scrollBarPosition():int
		{
			return _scrollBarPosition;
		}
		/**
		 * @private
		 */
		public function set scrollBarPosition(value:int):void
		{
			if(_scrollBarPosition == value)
				return;
			
			_scrollBarPosition = value;
			scrollBarPositionChange = true;
			propertyChange();
		}
		
		private var _vscrollBarVisableType:int = ScrollBarVisibleType.AUTOMATIC;
		/**
		 * 垂直滚动条显示隐藏规则，详见 ScrollBarVisibleType
		 */
		public function get vscrollBarVisableType():int
		{
			return _vscrollBarVisableType;
		}
		/**
		 * @private
		 */
		public function set vscrollBarVisableType(value:int):void
		{
			if(_vscrollBarVisableType == value)
				return;
			
			_vscrollBarVisableType = value;
			scrollBarVisibleChange = true;
			propertyChange();
		}

		
		private var _hscrollBarVisableType:int = ScrollBarVisibleType.AUTOMATIC;
		/**
		 * 水平滚动条显示隐藏规则，详见 ScrollBarVisibleType
		 */
		public function get hscrollBarVisableType():int
		{
			return _hscrollBarVisableType;
		}
		/**
		 * @private
		 */
		public function set hscrollBarVisableType(value:int):void
		{
			if(_hscrollBarVisableType == value)
				return;
			
			_hscrollBarVisableType = value;
			scrollBarVisibleChange = true;
			propertyChange();
		}
 
		private var _skin:int = ScrollBarType.NORMAL;
		/**
		 * 滚动组件皮肤（水平垂直滚动条的皮肤会被同时设置为这个值） 
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
			propertyChange();
		}

		/**
		 * scrollContent内容改变，增加或移除显示对象后，手动调用此函数更新显示 
		 * 
		 */		
		public function updateContent():void
		{
			scrollBarVisibleChange = true;
			actualSizeChange = true;
			propertyChange();
		}
		
		/**
		 * 滚动条位置设置改变 
		 */		
		private var scrollBarPositionChange:Boolean = false;
		
		/**
		 * 滚动条显示隐藏设置改变 
		 */		
		private var scrollBarVisibleChange:Boolean = false;
		
		/**
		 * 皮肤改变 
		 */		
		private var skinChange:Boolean = false;
		
		/**
		 * 手动设置的大小改变 
		 */		
		private var actualSizeChange:Boolean = false;
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_scrollContent = new BaseSprite();
			addChild(_scrollContent);
			
			maskBg = new Shape();
			maskBg.graphics.beginFill(0x000000);
			maskBg.graphics.drawRect(0,0,100,100);
			maskBg.graphics.endFill();
			addChild(maskBg);
			
			_scrollContent.mask = maskBg;
			
			vscrollBar = new VScrollBar();
			addChild(vscrollBar);
			
			hscrollBar = new HScrollBar();
			addChild(hscrollBar);
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			if(skinChange)
			{
				updateScrollBarSkin();
				skinChange = false;
			}
			if(actualSizeChange)
			{
				updateScrollBarSize();
				actualSizeChange = false;
			}
			if(scrollBarVisibleChange)
			{
				updateScrollBarVisible();
				scrollBarVisibleChange = false;
			}
			if(scrollBarPositionChange)
			{
				updateScrollBarPosition();
				scrollBarPositionChange = false;
			}
		}
		
		public override function setActualSize(newWidth:Number, newHeight:Number):void
		{
			super.setActualSize(newWidth,newHeight);
			actualSizeChange = true;
			scrollBarPositionChange = true;
			scrollBarVisibleChange = true;
			propertyChange();
		}
		
		/**
		 * 更新滚动条皮肤 
		 * 
		 */		
		private function updateScrollBarSkin():void
		{
			vscrollBar.skin = skin;
			hscrollBar.skin = skin;
		}
		
		/**
		 * 更新滚动条隐藏或显示 
		 */		
		private function updateScrollBarVisible():void
		{
			// 垂直滚动条 =====================================================
			if(ScrollBarVisibleType.HIDE == vscrollBarVisableType)
				vscrollBar.visible = false;
			else if(ScrollBarVisibleType.SHOW == vscrollBarVisableType)
				vscrollBar.visible = true;
			else if(ScrollBarVisibleType.AUTOMATIC == vscrollBarVisableType)
			{
				if(_h < scrollContent.height)
					vscrollBar.visible = true;
				else
					vscrollBar.visible = false;
			}
			
			// 水平滚动条 =====================================================
			if(ScrollBarVisibleType.HIDE == hscrollBarVisableType)
				hscrollBar.visible = false;
			else if(ScrollBarVisibleType.SHOW == hscrollBarVisableType)
				hscrollBar.visible = true;
			else if(ScrollBarVisibleType.AUTOMATIC == hscrollBarVisableType)
			{
				if(_w < scrollContent.width)
					hscrollBar.visible = true;
				else
					hscrollBar.visible = false;
			}
		}
		
		/**
		 * 更新滚动条位置 <br/>
		 * 滚动条和滚动容器不会重叠，滚动容器的宽高是_w和_h<br/>
		 * 遮罩位置也对应跟着移动
		 */		
		private function updateScrollBarPosition():void
		{
			if(ScrollBarPositionType.LEFT_BOTTOM == scrollBarPosition)
			{
				vscrollBar.move(0,0);
				hscrollBar.move(vscrollBar.width, _h);
				maskBg.x = vscrollBar.width;
				maskBg.y = 0;
			}
			else if(ScrollBarPositionType.RIGHT_BOTTOM == scrollBarPosition)
			{
				vscrollBar.move(_w,0);
				hscrollBar.move(0, _h);
				maskBg.x = 0;
				maskBg.y = 0;
			}
			else if(ScrollBarPositionType.LEFT_TOP == scrollBarPosition)
			{
				vscrollBar.move(0, hscrollBar.height);
				hscrollBar.move(vscrollBar.width, 0);
				maskBg.x = vscrollBar.width;
				maskBg.y = hscrollBar.height;
			}
			else if(ScrollBarPositionType.RIGHT_TOP == scrollBarPosition)
			{
				vscrollBar.move(_w, hscrollBar.height);
				hscrollBar.move(0,0);
				maskBg.x = 0;
				maskBg.y = hscrollBar.height;
			}
		}
		
		/**
		 * 更新滚动条大小 
		 */		
		private function updateScrollBarSize():void
		{
			maskBg.width = _w;
			maskBg.height = _h;
			
			hscrollBar.width = _w;
			hscrollBar.scrollWidth = scrollContent.width;
			
			vscrollBar.height = _h;
			vscrollBar.scrollHeight = scrollContent.height;
		}
		
		/**
		 * 垂直滚动条拖动 
		 * @param event
		 */		
		protected function onVScrollBarChangeHandler(event:ParamEvent):void
		{
//			trace("垂直滚动："+event.param.curRate);
			var yAddition:Number = 0;
			if(scrollBarPosition == ScrollBarPositionType.LEFT_TOP ||
				scrollBarPosition == ScrollBarPositionType.RIGHT_TOP) //滚动条在上面，要下偏移
				yAddition = hscrollBar.height;
			scrollContent.y = - event.param.curRate*scrollContent.height + yAddition;
		}
		
		/**
		 * 水平滚动条拖动 
		 * @param event
		 */		
		protected function onHScrollBarChangeHandler(event:ParamEvent):void
		{
//			trace("水平滚动："+event.param.curRate);
			var xAddition:Number = 0;
			if(scrollBarPosition == ScrollBarPositionType.LEFT_TOP ||
				scrollBarPosition == ScrollBarPositionType.LEFT_BOTTOM) //滚动条在左边，要右偏移
				xAddition = vscrollBar.width;
			scrollContent.x = - event.param.curRate*scrollContent.width + xAddition;
		}
		
		/**
		 * 鼠标滚轮事件 
		 * @param event
		 */		
		protected function onMouseWheelHandler(event:MouseEvent):void
		{
			var wheelNum:int = -event.delta;
			if(event.ctrlKey) //按下了CTRL键，水平滚动，否则垂直滚动
			{
				hscrollBar.scrollStep(wheelNum);
			}
			else
			{
				vscrollBar.scrollStep(wheelNum);
			}
		}
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			vscrollBar.addEventListener(Event.CHANGE , onVScrollBarChangeHandler);
			hscrollBar.addEventListener(Event.CHANGE , onHScrollBarChangeHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheelHandler);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			vscrollBar.removeEventListener(Event.CHANGE , onVScrollBarChangeHandler);
			hscrollBar.removeEventListener(Event.CHANGE , onHScrollBarChangeHandler);
			removeEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheelHandler);
		}
	}
}