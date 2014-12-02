package face2wind.uiComponents
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import face2wind.uiComponents.enum.PageType;
	import face2wind.uiComponents.enum.TextInputType;
	
	import face2wind.lib.Reflection;
	import face2wind.view.BaseSprite;
	
	/**
	 * 分页组件
	 * @author face2wind
	 */
	public class Page extends BaseSprite
	{
		public function Page(_newSkin:int = 1)
		{
			super();
			_skin = _newSkin;
		}
		
		/**
		 * 皮肤有改动 
		 */		
		private var skinChange:Boolean = false;
		private var _skin:int = PageType.NORMAL;
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
			propertyChange();
		}
		
		/**
		 * 输入文本框皮肤有改动 
		 */		
		private var textinputSkinChange:Boolean = false;
		private var _textinputSkin:int = TextInputType.NORMAL;
		/**
		 * 输入文本框皮肤类型 
		 */
		public function get textinputSkin():int
		{
			return _textinputSkin;
		}
		/**
		 * @private
		 */
		public function set textinputSkin(value:int):void
		{
			if(_textinputSkin == value)
				return;
			
			_skin = value;
			textinputSkinChange = true;
			propertyChange();
		}
		
		/**
		 * 页数改变的回调函数
		 */		
		public var pageChangeCallBack:Function = null;
		
		/**
		 * 页数文本 
		 */		
		private var pageTxt:TextInput;
		
		/**
		 * 第一页按钮 
		 */		
		private var firstPageBtn:SimpleButton;
		
		/**
		 * 最后一页按钮 
		 */		
		private var lastPageBtn:SimpleButton;
		
		/**
		 * 下一页按钮 
		 */		
		private var nextPageBtn:SimpleButton;
		
		/**
		 * 上一页按钮 
		 */		
		private var prePageBtn:SimpleButton;
		
		private var _curPage:int = 1;
		/**
		 * 当前页数 
		 */
		public function get curPage():int
		{
			return _curPage;
		}
		/**
		 * @private
		 */
		public function set curPage(value:int):void
		{
			if(_curPage == value)
				return;
			_curPage = value;
			pageChange = true;
			propertyChange();
		}

		/**
		 * 页数改变 
		 */		
		private var pageChange:Boolean = false;
		/**
		 * 最大页数改变 
		 */	
		private var maxPageChange:Boolean = false;
		private var _maxPage:int = 1;
		/**
		 * 最大页数 
		 */
		public function get maxPage():int
		{
			return _maxPage;
		}
		/**
		 * @private
		 */
		public function set maxPage(value:int):void
		{
			if(_maxPage == value)
				return;
			_maxPage = value;
			if(_curPage > _maxPage)
				curPage = _maxPage;
			maxPageChange = true;
			propertyChange();
		}

		/**
		 * 按钮布局更新 
		 */		
		private var buttonLayoutChange:Boolean = false;
		private var _showFirstLastBtn:Boolean = false;
		/**
		 * 是否显示‘第一个’，‘最后一个’按钮 
		 */
		public function get showFirstLastBtn():Boolean
		{
			return _showFirstLastBtn;
		}
		/**
		 * @private
		 */
		public function set showFirstLastBtn(value:Boolean):void
		{
			if(_showFirstLastBtn == value)
				return;
			
			_showFirstLastBtn = value;
			buttonLayoutChange = true;
			propertyChange();
		}

		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			firstPageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_firstPageBtn");
			addChild(firstPageBtn);
			
			lastPageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_lastPageBtn");
			addChild(lastPageBtn);
			
			nextPageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_nextPageBtn");
			addChild(nextPageBtn);
			
			prePageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_prePageBtn");
			addChild(prePageBtn);
			
			pageTxt = new TextInput(textinputSkin);
			pageTxt.align = TextFormatAlign.CENTER;
			pageTxt.resize(70, 24);//firstPageBtn.height);
			pageTxt.text = "1/1";
			pageTxt.editable = false;
			addChild(pageTxt);
			
			buttonLayoutChange = true;
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			if(pageChange)
			{
				pageChange = false;
				pageTxt.text = curPage+"/"+maxPage;
				if(null != pageChangeCallBack)
					pageChangeCallBack.apply(this,[curPage]);
			}
			if(maxPageChange)
			{
				maxPageChange = false;
				pageTxt.text = curPage+"/"+maxPage;
			}
			if(skinChange)
			{
				skinChange = false;
				if(firstPageBtn)
				{
					firstPageBtn.removeEventListener(MouseEvent.CLICK , onFirstHandler);
					if(contains(firstPageBtn))
						removeChild(firstPageBtn);
				}
				if(lastPageBtn)
				{
					lastPageBtn.removeEventListener(MouseEvent.CLICK , onLastHandler);
					if(contains(lastPageBtn))
						removeChild(lastPageBtn);
				}
				if(prePageBtn)
				{
					prePageBtn.removeEventListener(MouseEvent.CLICK , onPreHandler);
					if(contains(prePageBtn))
						removeChild(prePageBtn);
				}
				if(nextPageBtn)
				{
					nextPageBtn.removeEventListener(MouseEvent.CLICK , onNextHandler);
					if(contains(nextPageBtn))
						removeChild(nextPageBtn);
				}
				firstPageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_firstPageBtn");
				addChild(firstPageBtn);
				lastPageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_lastPageBtn");
				addChild(lastPageBtn);
				nextPageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_nextPageBtn");
				addChild(nextPageBtn);
				prePageBtn = Reflection.createSimpleButtonInstance("page_" + skin + "_prePageBtn");
				addChild(prePageBtn);
				
				if(hasShow)
				{
					firstPageBtn.addEventListener(MouseEvent.CLICK , onFirstHandler);
					lastPageBtn.addEventListener(MouseEvent.CLICK , onLastHandler);
					prePageBtn.addEventListener(MouseEvent.CLICK , onPreHandler);
					nextPageBtn.addEventListener(MouseEvent.CLICK , onNextHandler);
				}
				buttonLayoutChange = true;
			}
			if(textinputSkinChange)
			{
				textinputSkinChange = false;
				pageTxt.skin = textinputSkin;
			}
			if(buttonLayoutChange)
			{
				buttonLayoutChange = false;
				var split:int = 5; //按钮之间的间隔
				if(showFirstLastBtn)
				{
					addChild(firstPageBtn);
					addChild(lastPageBtn);
					prePageBtn.x = firstPageBtn.width + split;
				}
				else
				{
					if(contains(firstPageBtn))
						removeChild(firstPageBtn);
					if(contains(lastPageBtn))
						removeChild(lastPageBtn);
				}
				pageTxt.y = (prePageBtn.height-pageTxt.height)/2; //调整文本和按钮垂直居中
				pageTxt.x = prePageBtn.x + prePageBtn.width + split;
				nextPageBtn.x = pageTxt.x + pageTxt.width + split;
				lastPageBtn.x = nextPageBtn.x + nextPageBtn.width + split;
			}
		}
		
		protected function onFirstHandler(event:MouseEvent):void
		{
			curPage = 1;
		}
		
		protected function onLastHandler(event:MouseEvent):void
		{
			curPage = maxPage;
		}
		
		protected function onPreHandler(event:MouseEvent):void
		{
			if(curPage > 1)
				curPage = curPage -1;
		}
		
		protected function onNextHandler(event:MouseEvent):void
		{
			if(curPage < maxPage)
				curPage = curPage + 1;
		}
		
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			firstPageBtn.addEventListener(MouseEvent.CLICK , onFirstHandler);
			lastPageBtn.addEventListener(MouseEvent.CLICK , onLastHandler);
			prePageBtn.addEventListener(MouseEvent.CLICK , onPreHandler);
			nextPageBtn.addEventListener(MouseEvent.CLICK , onNextHandler);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			firstPageBtn.removeEventListener(MouseEvent.CLICK , onFirstHandler);
			lastPageBtn.removeEventListener(MouseEvent.CLICK , onLastHandler);
			prePageBtn.removeEventListener(MouseEvent.CLICK , onPreHandler);
			nextPageBtn.removeEventListener(MouseEvent.CLICK , onNextHandler);
		}
	}
}