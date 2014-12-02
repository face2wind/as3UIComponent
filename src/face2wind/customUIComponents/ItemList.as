package face2wind.customUIComponents
{
	import flash.events.MouseEvent;
	
	import face2wind.customUIComponents.item.ItemRenderer;
	import face2wind.uiComponents.ScrollPane;
	import face2wind.uiComponents.enum.ScrollBarType;
	import face2wind.uiComponents.enum.ScrollBarVisibleType;
	
	import face2wind.lib.ObjectPool;
	import face2wind.view.BaseSprite;
	
	/**
	 * 可自定义item类对象的列表控件
	 * @author Face2wind
	 */
	public class ItemList extends BaseSprite
	{
		/**
		 * 构造函数 
		 * @param scrollSkin 设置滚动条样式（默认是ScrollBarType.NORMAL）
		 */		
		public function ItemList(newScrollSkin:int = 1)
		{
			super();
			scrollPanelSkin = newScrollSkin;
		}
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			itemList = [];
			
			scrollPanel = new ScrollPane(scrollPanelSkin);
			addChild(scrollPanel);
		}
		
		/**
		 * 垂直布局 
		 */		
		public static var VERTICAL:int = 1;
		
		/**
		 * 水平布局 
		 */		
		public static var HORIZONTAL:int = 2;
		
		/**
		 * 先水平，再垂直（水平布局到列表宽度后换行）
		 */		
		public static var HORIZONTAL_TO_VERTICAL:int = 3;
		
		/**
		 * 先垂直，再水平（垂直布局到列表高度后换列）
		 */		
		public static var VERTICAL_TO_HORIZONTAL:int = 4;
		
		private var _layoutType:int = VERTICAL;
		/**
		 *  布局类型（ItemList类定义）
		 */
		public function get layoutType():int
		{
			return _layoutType;
		}
		/**
		 * @private
		 */
		public function set layoutType(value:int):void
		{
			if(_layoutType == value)
				return;
			_layoutType = value;
			layoutChange = true;
			propertyChange();
		}
		
		private var _itemRender:Class;
		/**
		 * 子项视图类型
		 */
		public function get itemRender():Class
		{
			return _itemRender;
		}
		/**
		 * @private
		 */
		public function set itemRender(value:Class):void
		{
			if(null == value)
				return;
//			if(value is ItemRenderer)
			_itemRender = value;
		}
		
		/**
		 * 子项之间的竖向间隔
		 */		
		public var verticalSpacing:int = 2;
		
		/**
		 * 子项之间的横向间隔
		 */		
		public var horizontalSpacing:int = 2;
		
		/**
		 * 滚动条
		 */		
		private var scrollPanel:ScrollPane;
		
		/**
		 * 列表项数组
		 */		
		private var itemList:Array;
		
		/**
		 * 由于动态创建列表内容，此值定义当前显示的item个数
		 */		
		private var curShowItemNum:int = 0;
		
		public override function setActualSize(newWidth:Number, newHeight:Number):void
		{
			super.setActualSize(newWidth,newHeight);
			sizeChange = true;
			layoutChange = true;
			propertyChange();
		}
		
		/**
		 * 选中指定下标的列表项（只允许单个选中）
		 * @param index
		 *
		 */		
		public function selectIndex(index:int):void
		{
			var item:ItemRenderer = getItemAt(index) as ItemRenderer;
			if(null == item)
				return;
			
			while(0 < selectList.length)
			{
				var tmpItem:ItemRenderer = selectList.shift() as ItemRenderer;
				if(tmpItem != item)
					tmpItem.selected = false;
			}
			_selectIndexList = [];
			item.selected = true;
			if(-1 == selectList.indexOf(item))
				selectList.push(item);
			_selectIndexList.push(itemList.indexOf(item));
			rebuildLayout();
		}
		
		/**
		 * 选中指定下标的列表项（允许多个选中，之前选中的不会被unselect）
		 * @param index
		 */
		public function selectIndexEnableMultiSelect(index:int):void
		{
			var item:ItemRenderer = getItemAt(index) as ItemRenderer;
			if(null == item)
				return;
			
			item.selected = true;
			if(-1 == selectList.indexOf(item))
				selectList.push(item);
			_selectIndexList.push(itemList.indexOf(item));
			rebuildLayout();
		}
		
		public function selectAll():void
		{
			for (var i:int = 0; i < itemList.length; i++) 
			{
				var item:ItemRenderer = itemList[i] as ItemRenderer;
				item.selected = true;
			}
			rebuildLayout();
		}
		
		/**
		 * 全部不选中
		 *
		 */		
		public function unselectAll():void
		{
			while(0 < selectList.length)
			{
				var tmpItem:ItemRenderer = selectList.shift() as ItemRenderer;
				tmpItem.selected = false;
			}
			_selectIndexList = [];
		}
		
		private var _dataProvider:Array;
		/**
		 * 数据源（数组形式）
		 */
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		/**
		 * @private
		 */
		public function set dataProvider(value:Array):void
		{
			if(null == value)
				return;
			_dataProvider = value;
			curShowItemNum = _dataProvider.length;//暂时不做增量加载优化
			
			itemNumChange = true;
			layoutChange = true;
			listeningClick = true;
			propertyChange();
//			selectIndex(0); //每次重设数据源后都选中第一个
		}
		
		/**
		 * 列表项个数改变 
		 */		
		private var itemNumChange:Boolean = false;
		/**
		 * 重新加载列表数据
		 *
		 */		
		private function rebuildItems():void
		{
			if(null == itemRender)
			{
//				throw(new Error("ItemList对象初始化时未设置itemRender"));
				return;
			}
			var item:ItemRenderer;
			//删除多余的对象，重复利用已有对象
			while(curShowItemNum < itemList.length)
			{
				item = itemList.pop();
				if(scrollPanel.scrollContent.contains(item))
				{
					scrollPanel.scrollContent.removeChild(item);
					scrollPanel.updateContent();
				}
			}
			//若不足数量，则补足对应item
			while(curShowItemNum > itemList.length)
			{
				item = ObjectPool.getObject(itemRender) as ItemRenderer;
				scrollPanel.scrollContent.addChild(item);
				scrollPanel.updateContent();
				itemList.push(item);
			}
			//设置数据
			for (var i:int = 0; i < itemList.length; i++) 
			{
				item = itemList[i];
				item.data = dataProvider[i];
				item.itemIndex = i;
			}
		}
		
		/**
		 * 列表项被点击事件
		 * @param event
		 *
		 */		
		protected function onItemMouseClickedHandler(event:MouseEvent):void
		{
			var item:ItemRenderer = ItemRenderer(event.currentTarget);
			while(0 < selectList.length)
			{
				var tmpItem:ItemRenderer = selectList.shift() as ItemRenderer;
				if(tmpItem != item)
					tmpItem.selected = false;
			}
			_selectIndexList = [];
			if(-1 != selectList.indexOf(item))
				return;
			item.selected = true;
//			if(-1 == selectList.indexOf(item))
			selectList.push(item);
			selectIndexList.push(itemList.indexOf(item));
			rebuildLayout();
		}
		
		/**
		 * 布局样式改变 
		 */		
		private var layoutChange:Boolean = false;
		/**
		 * 根据布局类型重设item位置
		 *
		 */		
		private function rebuildLayout():void
		{
			if(1 > itemList.length)
				return;
			
			var item:*;
			var i:int;
			var rowSize:int = _w/((itemList[0] as ItemRenderer)._w+horizontalSpacing);//一行能放的item数量
			if(rowSize < 1) //一行放的个数不能少于1个
				rowSize = 1;
			switch(layoutType)
			{
				case VERTICAL:
				{
					var ypos:int = 0;
					for (i = 0; i < itemList.length; i++) 
					{
						item = itemList[i];// as ItemRenderer;
						item.y = ypos;
						ypos += item._h + verticalSpacing;
					}
					break;
				}
				case HORIZONTAL_TO_VERTICAL:
				default:
				{
					for (i = 0; i < itemList.length; i++) 
					{
						item = itemList[i];// as ItemRenderer;
						item.x = int(i%rowSize)*(item._w+horizontalSpacing);
						item.y = int(i/rowSize)*(item._h+verticalSpacing);
					}
					break;
				}
			}
			scrollPanel.updateContent();
			
			scrollBarVisibleChange = true;
			propertyChange();
		}

		/**
		 * 外部设置重新调整layout布局 
		 */		
		public function updateLayout():void
		{
			layoutChange = true;
			propertyChange();
		}
		
		private var _selectList:Array = [];
		/**
		 * 当前选中的对象列表（允许多个选中）
		 */
		public function get selectList():Array
		{
			if(null == _selectList)
				return [];
			return _selectList;
		}
		private var _selectIndexList:Array = [];
		/**
		 * 当前选中的对象下标列表（允许多个选中）
		 */
		public function get selectIndexList():Array
		{
			if(null == _selectIndexList)
				return [];
			return _selectIndexList;
		}
		
		private var scrollBarVisibleChange:Boolean = false;
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
		
		/**
		 * 滚动条皮肤改变 
		 */		
		private var scrollPanelskinChange:Boolean = false;
		private var _scrollPanelSkin:int = ScrollBarType.NORMAL;
		/**
		 * 滚动组件皮肤（水平垂直滚动条的皮肤会被同时设置为这个值） 
		 */
		public function get scrollPanelSkin():int
		{
			return _scrollPanelSkin;
		}
		/**
		 * @private
		 */
		public function set scrollPanelSkin(value:int):void
		{
			if(_scrollPanelSkin == value)
				return;
			
			_scrollPanelSkin = value;
			scrollPanelskinChange = true;
			propertyChange();
		}
		
		/**
		 * 大小改变 
		 */		
		private var sizeChange:Boolean = false;
		
		/**
		 * 当前显示列表子项个数
		 * @return
		 *
		 */		
		public function get itemNum():int
		{
			return curShowItemNum;
		}
		
		/**
		 * 获取制定下标的子项对象
		 * @param index
		 * @return
		 *
		 */		
		public function getItemAt(index:int):*
		{
			if(0 > index || curShowItemNum < (index+1) )
				return null;
			
			return itemList[index];
		}
		
		/**
		 * 根据数据源的某个属性的值进行精确查找
		 * @param property
		 * @param value
		 * @return
		 *
		 */		
		public function getItemByProperty(property:String, value:*):ItemRenderer
		{
			for(var i:uint; i<curShowItemNum; i++)
			{
				if(itemList[i].data[property] == value)
				{
					return itemList[i];
				}
			}
			return null;
		}
		
		/**
		 * 是否监听事件设置改变 
		 */		
		private var listeningClickChange:Boolean = false;
		private var _listeningClick:Boolean = false;
		/**
		 * 设置子对象是否监听点击事件
		 * @param value
		 *
		 */		
		private function set listeningClick(value:Boolean):void
		{
			if(_listeningClick == value)
				return;
			
			_listeningClick = value;
			listeningClickChange = true;
			propertyChange();
		}
		private function get listeningClick():Boolean
		{
			return _listeningClick;
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			if(scrollPanelskinChange)
			{
				scrollPanel.skin = scrollPanelSkin;
				scrollPanelskinChange = false;
			}
			if(scrollBarVisibleChange)
			{
				scrollPanel.vscrollBarVisableType = vscrollBarVisableType;
				scrollPanel.hscrollBarVisableType = hscrollBarVisableType;
				scrollBarVisibleChange = false;
			}
			if(sizeChange)
			{
				scrollPanel.setActualSize(_w , _h);
				sizeChange = false;
			}
			if(itemNumChange)
			{
				rebuildItems();
				itemNumChange = false;
			}
			if(layoutChange)
			{
				layoutChange = false;
				rebuildLayout();
			}
			if(listeningClickChange)
			{
				var i:int;
				var item:ItemRenderer;
				for (i = 0; i < itemList.length; i++) 
				{
					item = itemList[i] as ItemRenderer;
					if(listeningClick)
					{
						if(!item.hasEventListener(MouseEvent.CLICK))
							item.addEventListener(MouseEvent.CLICK , onItemMouseClickedHandler);
					}
					else
						item.removeEventListener(MouseEvent.CLICK , onItemMouseClickedHandler);
				}
				listeningClickChange = false;
			}
		}
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			listeningClick = true;
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			listeningClick = false;
		}
	}
}


