package face2wind.uiComponents
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import face2wind.uiComponents.enum.TabbarType;
	import face2wind.util.ColorUtil;
	
	import face2wind.event.ParamEvent;
	import face2wind.lib.Reflection;
	import face2wind.view.BaseButton;
	import face2wind.view.BaseSprite;
	import face2wind.view.SkinableSprite;
	
	/**
	 * 标签组件
	 * @author face2wind
	 */
	public class Tabbar extends BaseSprite
	{
		/**
		 * 标签切换事件 
		 */		
		public static const TAB_CHANGE:String = "Tabbar_TAB_CHANGE";
		
		public function Tabbar(newSkin:int = 1)
		{
			super();
			_skin = newSkin;
		}
		
		/**
		 * 标签按钮列表 
		 */		
		private var buttonList:Array = null;
		
		/**
		 * 按钮列表更新 
		 */		
		private var buttonListChange:Boolean = false;
		
		private var _lableList:Array = null;
		/**
		 * 标签文字列表 
		 */
		public function get lableList():Array
		{
			return _lableList;
		}
		/**
		 * @private
		 */
		public function set lableList(value:Array):void
		{
			_lableList = value;
			buttonListChange = true;
			propertyChange();
		}
		
		private var _widthList:Array = null;
		/**
		 * 标签宽度列表，和tabWidth互斥，设置了此属性会清掉tabWidth属性
		 */
		public function get widthList():Array
		{
			return _widthList;
		}
		/**
		 * @private
		 */
		public function set widthList(value:Array):void
		{
			tabWidth = 0;
			_widthList = value;
			buttonListChange = true;
			propertyChange();
		}

		private var _tabXpos:Number = 10;
		/**
		 * 标签的水平位移（有背景的时候就有必要了） 
		 */
		public function get tabXpos():Number
		{
			return _tabXpos;
		}
		/**
		 * @private
		 */
		public function set tabXpos(value:Number):void
		{
			if(_tabXpos == value)
				return;
			_tabXpos = value;
			buttonListChange = true;
			propertyChange();
		}
		
		private var _tabSplit:int = 3; 
		/**
		 * 按钮之间的间隔 
		 */
		public function get tabSplit():int
		{
			return _tabSplit;
		}
		/**
		 * @private
		 */
		public function set tabSplit(value:int):void
		{
			if(_tabSplit == value)
				return;
			
			_tabSplit = value;
			buttonListChange = true;
			propertyChange();
		}

		
		private var _tabWidth:Number = 80;
		/**
		 * 标签统一宽度，和widthList互斥，设置了此属性会清掉widthList属性
		 */
		public function get tabWidth():Number
		{
			return _tabWidth;
		}
		/**
		 * @private
		 */
		public function set tabWidth(value:Number):void
		{
			if(_tabWidth == value)
				return;
			
			_widthList = null;
			_tabWidth = value;
			buttonListChange = true;
			propertyChange();
		}
		
		/**
		 * 标签对应的容器列表 
		 */		
		public var containerList:Array = null;
		
		/**
		 * 当前显示的容器对象 
		 */		
		private var curContainer:DisplayObject = null;
		
		/**
		 * 当前选中的标签按钮 
		 */		
		private var curButton:BaseButton = null;
		
		/**
		 * 统一背景 
		 */		
		private var bgMc:Sprite;
		
		/**
		 * 背景有改动（或是素材改变，或是宽高改变） 
		 */		
		private var bgChange:Boolean = false;
		private var _bgSkin:String;
		/**
		 * 统一背景所用素材 
		 */
		public function get bgSkin():String
		{
			return _bgSkin;
		}
		/**
		 * @private
		 */
		public function set bgSkin(value:String):void
		{
			if(null == value || "" == value || _bgSkin == value)
				return;
			
			_bgSkin = value;
			bgChange = true;
			propertyChange();
		}
		
		private var _bgWidth:Number = 100;
		/**
		 * 统一背景宽度 
		 */
		public function get bgWidth():Number
		{
			return _bgWidth;
		}
		/**
		 * @private
		 */
		public function set bgWidth(value:Number):void
		{
			if(_bgWidth == value)
				return;
			_bgWidth = value;
			bgChange = true;
			propertyChange();
		}

		private var _bgHeight:Number = 100;
		/**
		 * 统一背景高度 
		 */
		public function get bgHeight():Number
		{
			return _bgHeight;
		}
		/**
		 * @private
		 */
		public function set bgHeight(value:Number):void
		{
			if(_bgHeight == value)
				return;
			_bgHeight = value;
			bgChange = true;
			propertyChange();
		}
		
		private var _skin:int = TabbarType.NORMAL;
		
		/**
		 * 按钮皮肤（皮肤类型在ButtonType里定义）
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
			_skin = value;
			skinChange = true;
			propertyChange();
		}

		private var _selectIndex:int = 0;
		/**
		 * 当前选中的下标 
		 */
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		/**
		 * @private
		 */
		public function set selectIndex(value:int):void
		{
			if(_selectIndex == value)
				return;
			
			_selectIndex = value;
			selectIndexChange = true;
			propertyChange();
		}

		
		/**
		 * 当前选中下标改变 
		 */		
		private var selectIndexChange:Boolean = false;
		
		/**
		 * 皮肤改变 
		 */		
		private var skinChange:Boolean = false;

		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			buttonList = [];
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			var btnNum:int;
			if(null == lableList)
				btnNum = 0;
			else
				btnNum = lableList.length;
			var tabBtn:BaseButton;
			var i:int;
			if(bgChange)
			{
				bgChange = false;
				if(null != bgSkin && "" != bgSkin)
				{
					if(bgMc && contains(bgMc))//背景不空，先清理掉
					{
						removeChild(bgMc);
					}
					bgMc = Reflection.createSpriteInstance(bgSkin);
					if(bgMc)
					{
						addChildAt(bgMc,0);
						bgMc.width = bgWidth;
						bgMc.height = bgHeight;
						if(0 < buttonList.length)
							bgMc.y = buttonList[0].height;
					}
				}
			}
			if(skinChange)
			{
				skinChange = false;
				for (i = 0; i < buttonList.length; i++) 
				{
					tabBtn = buttonList[i] as BaseButton;
					tabBtn.updateBtnSkins("tabbar_" + skin + "_btn_up","tabbar_" + skin + "_btn_down","tabbar_" + skin + "_btn_over");
				}
			}
			if(buttonListChange)
			{
				buttonListChange = false;
				while(btnNum > buttonList.length) //不够按钮数量，补足
				{
					tabBtn = new BaseButton("tabbar_" + skin + "_btn_up","tabbar_" + skin + "_btn_down","tabbar_" + skin + "_btn_over");
					buttonList.push(tabBtn);
				}
				for (i = 0; i < buttonList.length; i++) 
				{
					tabBtn = buttonList[i] as BaseButton;
					tabBtn.name = i+"";
					if(i < lableList.length)
						tabBtn.label = lableList[i] as String;
					if(i < btnNum) //应显示的按钮
					{
						addChild(tabBtn);
						if(0 < tabWidth) // 设定宽度 ===============================================
							tabBtn.width = tabWidth;
						else
						{
							if(widthList.length > i)
								tabBtn.width = widthList[i] as Number;
							else
								tabBtn.width = 80; //指定了用列表方式读取宽度，却没有数据，用默认值
						}
						// 设定坐标 ===============================================
						if(0 == i)
							tabBtn.x = tabXpos;
						else
							tabBtn.x = (buttonList[i-1] as BaseButton).x + (buttonList[i-1] as BaseButton).width + tabSplit;
						tabBtn.addEventListener(MouseEvent.CLICK , onTabBtnMouseClickedHandler);
					}
					else //应隐藏的按钮（不回收按钮，只是隐藏，下次要用直接拿）
					{
						if(contains(tabBtn))
							removeChild(tabBtn);
						tabBtn.removeEventListener(MouseEvent.CLICK , onTabBtnMouseClickedHandler);
					}
				}
			}
			if(selectIndexChange)
			{
				selectIndexChange = false;
				var curBtn:BaseButton = buttonList[selectIndex] as BaseButton;
				curBtn.lockOnSkin(SkinableSprite.MOUSE_DOWN_SKIN);
				curBtn.labelColor = ColorUtil.YELLOW;
				if(curButton)
				{
					curButton.unlockSkin();
					curButton.labelColor = ColorUtil.WHITE;
				}
				curButton = curBtn;
				if(curContainer && contains(curContainer))
					removeChild(curContainer);
				curContainer = null;
				if(containerList && selectIndex < containerList.length)
					curContainer = containerList[selectIndex] as DisplayObject;
				if(curContainer)
					addChild(curContainer);
				dispatchEvent(new ParamEvent(Tabbar.TAB_CHANGE , {index:selectIndex}));
			}
		}
		
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			
		}
		
		protected function onTabBtnMouseClickedHandler(event:MouseEvent):void
		{
			var curBtn:BaseButton = event.currentTarget as BaseButton;
			var curIndex:int = int(curBtn.name); //当前选中的下标
			selectIndex = curIndex;
		}
	}
}