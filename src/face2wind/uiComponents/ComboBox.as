package face2wind.uiComponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import face2wind.customUIComponents.ItemList;
	import face2wind.uiComponents.enum.ComboBoxType;
	import face2wind.uiComponents.item.ComboBoxItemRenderer;
	
	import face2wind.enum.LayerEnum;
	import face2wind.event.ParamEvent;
	import face2wind.lib.Reflection;
	import face2wind.manager.LayerManager;
	import face2wind.manager.StageManager;
	import face2wind.view.BaseButton;
	import face2wind.view.BaseSprite;
	
	/**
	 * 下拉组件
	 * @author face2wind
	 */
	public class ComboBox extends BaseSprite
	{
		/**
		 * 选中内容改变事件 
		 */		
		public static const SELECT_CHANGE:String = "ComboBox_SELECT_CHANGE";
		
		/**
		 * 构造函数，输入按钮皮肤（皮肤类型在ComboBoxType里定义）
		 * @param newSkin
		 * 
		 */		
		public function ComboBox(newSkin:int = 1)
		{
			super();
			_skin = newSkin;
		}
		
		/**
		 * 点击下拉按钮 
		 */		
		private var downBtn:BaseButton;
		
		/**
		 * 点击缩回按钮 
		 */		
		private var upBtn:BaseButton;
		
		/**
		 * 当前显示的项对象 
		 */		
		private var curItem:ComboBoxItemRenderer;
		
		/**
		 * 下拉列表 
		 */		
		private var downList:ItemList;
		
		/**
		 * 下拉背景图 
		 */		
		private var downListBg:Sprite;
		
		/**
		 * 下拉容器 
		 */		
		private var downSp:BaseSprite;
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			downBtn = new BaseButton("comboBox_" + skin + "_downBtn_up", "comboBox_" + skin + "_downBtn_down", "comboBox_" + skin + "_downBtn_over");
			addChild(downBtn);
			upBtn = new BaseButton("comboBox_" + skin + "_upBtn_up", "comboBox_" + skin + "_upBtn_down", "comboBox_" + skin + "_upBtn_over");
			curItem = new ComboBoxItemRenderer();
			curItem.skin = skin;
			curItem.isDownItem = false;
			addChild(curItem);
			
			if(0 == _h)
				_h = downBtn.height; //改完皮肤，高度重新设置为按钮高度
			if(0 == _w)
				_w = 160;
			actualSizeChange = true;
			
			downList = new ItemList();
			downList.itemRender = ComboBoxItemRenderer;
			downList.setActualSize(_w , downListHight);
//			downList.move(0,4);
			
			downListBg = Reflection.createSpriteInstance("comboBox_" + skin + "_downListBg");
			
			downSp = new BaseSprite();
			downSp.addChild(downListBg);
			downSp.addChild(downList);
		}
		
		private var _skin:int = ComboBoxType.NORMAL;
		
		/**
		 * 按钮皮肤（皮肤类型在ComboBoxType里定义）
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
		
		public override function set height(value:Number):void
		{
			_h = value;
			actualSizeChange = true;
			propertyChange();
		}
		
		public override function set width(value:Number):void
		{
			_w = value;
			actualSizeChange = true;
			propertyChange();
		}
		
		/**
		 * 下拉高度改变 
		 */		
		private var downListHightChange:Boolean = false;
		private var _downListHight:Number = 160;
		/**
		 * 下拉列表高度 
		 */
		public function get downListHight():Number
		{
			return _downListHight;
		}
		/**
		 * @private
		 */
		public function set downListHight(value:Number):void
		{
			_downListHight = value;
			downListHightChange = true;
			propertyChange();
		}

		
		public override function setActualSize(newWidth:Number, newHeight:Number):void
		{
			super.setActualSize(newWidth,newHeight);
			actualSizeChange = true;
			propertyChange();
		}
		
		private var _dataProvider:Array = null;
		/**
		 * 下拉数据，有两种格式：<br/>
		 * [string, string...] 包含字符串的数组<br/>
		 * [{text:string, ...}, {text:string, ...}] 包含obj的数组，obj里要有一个text属性用于显示的文本
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
			if(null == value || _dataProvider == value)
				return;
			
			_dataProvider = value;
			dataChange = true;
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
			_selectIndex = value;
			selectIndexChange = true;
			propertyChange();
		}

		/**
		 * 皮肤改变 
		 */		
		private var skinChange:Boolean = false;
		
		/**
		 * 大小改变 
		 */		
		private var actualSizeChange:Boolean = false;
		
		/**
		 * 下拉数据改变 
		 */		
		private var dataChange:Boolean = false;
		
		/**
		 * 选中下标改变 
		 */		
		private var selectIndexChange:Boolean = false;
		
		private var _downListListing:Boolean;
		public function set downListListing(value:Boolean):void
		{
			_downListListing = value;
			var listLen:int = downList.itemNum;
			
			for (var i:int = 0; i < listLen; i++) 
			{
				var tmpItem:ComboBoxItemRenderer = downList.getItemAt(i) as ComboBoxItemRenderer;
				if(_downListListing)
					tmpItem.addEventListener(ComboBoxItemRenderer.CLICKED, onListItemClickedHandler);
				else
					tmpItem.removeEventListener(ComboBoxItemRenderer.CLICKED, onListItemClickedHandler);
			}
		}
		
		/**
		 * 下拉列表项点击事件 
		 * @param event
		 * 
		 */		
		protected function onListItemClickedHandler(event:ParamEvent):void
		{
			onStageMouseClickedHandler(null);
			if(curItem.data == event.param.data)
				return;
			
			curItem.data = event.param.data;
			dispatchEvent(new ParamEvent(ComboBox.SELECT_CHANGE, event.param));
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			var listLen:int = downList.itemNum;
			var tmpItem:ComboBoxItemRenderer;
			var i:int;
			if(skinChange)
			{
				skinChange = false;
				downBtn.updateBtnSkins("comboBox_" + skin + "_downBtn_up", "comboBox_" + skin + "_downBtn_down", "comboBox_" + skin + "_downBtn_over");
				upBtn.updateBtnSkins("comboBox_" + skin + "_upBtn_up", "comboBox_" + skin + "_upBtn_down", "comboBox_" + skin + "_upBtn_over");
				curItem.skin = skin;
				if(downListBg && downSp.contains(downListBg))
					downSp.removeChild(downListBg);
				downListBg = Reflection.createSpriteInstance("comboBox_" + skin + "_downListBg");
				downSp.addChildAt(downListBg,0);
				for (i = 0; i < listLen; i++) 
				{
					tmpItem = downList.getItemAt(i) as ComboBoxItemRenderer;
					tmpItem.isDownItem = true;
					tmpItem.skin = skin;
				}
				if(0 == _h)
					_h = downBtn.height; //改完皮肤，高度重新设置为按钮高度
			}
			if(actualSizeChange)
			{
				actualSizeChange = false;
				curItem.setActualSize(_w - downBtn.width ,_h);
				downBtn.height = _h;
				downBtn.x = _w - downBtn.width;
				upBtn.height = _h;
				upBtn.x = downBtn.x;
				for (i = 0; i < listLen; i++) 
				{
					tmpItem = downList.getItemAt(i) as ComboBoxItemRenderer;
					tmpItem.isDownItem = true;
					tmpItem.setActualSize(_w ,_h);
				}
				downList.updateLayout();
				downListBg.width = _w;
				downListBg.height = _h*listLen;
			}
			if(downListHightChange)
			{
				downListHightChange = false;
				downList.setActualSize(_w , downListHight);
			}
			if(dataChange)
			{
				dataChange = false;
				downListListing = false; //删除所有子项事件监听
				downList.dataProvider = dataProvider;
				downListListing = true; //恢复事件监听
				listLen = downList.itemNum;
				if(0 < dataProvider.length)
					curItem.data = dataProvider[0];
				else
					curItem.data = null;
				_selectIndex = 0;
				for (i = 0; i < listLen; i++) 
				{
					tmpItem = downList.getItemAt(i) as ComboBoxItemRenderer;
					tmpItem.isDownItem = true;
					tmpItem.setActualSize(_w ,_h);
				}
				downList.updateLayout();
				downListBg.height = _h*listLen + 4;//downList.y*2;
			}
			if(selectIndexChange)
			{
				selectIndexChange = false;
				if(selectIndex < dataProvider.length)
					curItem.data = dataProvider[selectIndex];
			}
		}
		
		/**
		 * 鼠标点击事件 
		 * @param event
		 * 
		 */		
		protected function onComboboxMouseClickedHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			if(contains(downBtn)) //当前是下拉功能
			{
				var layer:BaseSprite = LayerManager.getInstance().getLayer(LayerEnum.TOP_LAYER);
				var globalPoint:Point = localToGlobal(new Point(curItem.x,curItem.y));
				globalPoint.y += _h;
				downSp.move(globalPoint.x,globalPoint.y);
				layer.addChild(downSp);
				removeChild(downBtn);
				addChild(upBtn);
			}
			else
			{
				onStageMouseClickedHandler(null);
			}
		}
		
		/**
		 * 场景或者隐藏按钮鼠标点击事件 
		 * @param event
		 * 
		 */		
		protected function onStageMouseClickedHandler(event:MouseEvent):void
		{
			if(upBtn && contains(upBtn))
				removeChild(upBtn);
			if(upBtn && !contains(upBtn))
				addChild(downBtn);
			var layer:BaseSprite = LayerManager.getInstance().getLayer(LayerEnum.TOP_LAYER);
			if(layer.contains(downSp))
				layer.removeChild(downSp);
		}
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			addEventListener(MouseEvent.CLICK , onComboboxMouseClickedHandler);
			StageManager.getInstance().stage.addEventListener(MouseEvent.CLICK , onStageMouseClickedHandler);
			downListListing = true;
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			removeEventListener(MouseEvent.CLICK , onComboboxMouseClickedHandler);
			StageManager.getInstance().stage.removeEventListener(MouseEvent.CLICK , onStageMouseClickedHandler);
			downListListing = false;
		}
	}
}