package face2wind.uiComponents.item
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import face2wind.customUIComponents.item.ItemRenderer;
	
	import face2wind.event.ParamEvent;
	import face2wind.lib.Reflection;
	import face2wind.uiComponents.CustomTextfield;
	
	/**
	 * 下拉组件子项（普通显示的项也在这里写）
	 * @author face2wind
	 */
	public class ComboBoxItemRenderer extends ItemRenderer
	{
		/**
		 * 点击选中事件 
		 */		
		public static const CLICKED:String = "ComboBoxItemRenderer_CLICKED";
		
		public function ComboBoxItemRenderer()
		{
			super();
		}
		
		/**
		 * 显示的文本 
		 */		
		private var textfeild:CustomTextfield;
		
		/**
		 * 普通背景 
		 */		
		private var itemUpBg:Sprite;
		
		/**
		 * 鼠标移上背景 
		 */		
		private var itemOverBg:Sprite;
		
		/**
		 * 下拉列表项鼠标移上背景 
		 */		
		private var listItemOver:Sprite;
		
		private var isDownItemChange:Boolean = false;
		private var _isDownItem:Boolean = true;
		/**
		 * 是否下拉的项，否则表示是combobox里的默认显示项对象 
		 */
		public function get isDownItem():Boolean
		{
			return _isDownItem;
		}
		/**
		 * @private
		 */
		public function set isDownItem(value:Boolean):void
		{
			if(_isDownItem == value)
				return;
			_isDownItem = value;
			isDownItemChange = true;
			propertyChange();
		}

		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			textfeild = new CustomTextfield();
			textfeild.x = 5;
			addChild(textfeild);
			
			isDownItemChange = true;
		}
		
		/**
		 * 皮肤改变 
		 */		
		private var skinChange:Boolean = false;
		private var _skin:int=1;
		/**
		 * 皮肤资源
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
		
		/**
		 * 大小被改变 
		 */		
		private var sizeChange:Boolean = false;
		/**
		 * 数据改变 
		 */		
		private var dataChange:Boolean = false;
		
		/**
		 * 文本内容 
		 */		
		private var _data:* = null;
		
		public override function setActualSize(newWidth:Number, newHeight:Number):void
		{
			super.setActualSize(newWidth, newHeight);
			sizeChange = true;
			propertyChange();
		}
		
		public override function get data():Object
		{
			return _data;
		}
		public override function set data(value:Object):void
		{
			if(null == value)
				return;
			_data = value;
			dataChange = true;
			propertyChange();
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
				skinChange = false;
				if(listItemOver && contains(listItemOver))
					removeChild(listItemOver);
				listItemOver = null;
				if(itemUpBg && contains(itemUpBg))
					removeChild(itemUpBg);
				itemUpBg = null;
				if(itemOverBg && contains(itemOverBg))
					removeChild(itemOverBg);
				itemOverBg = null;
				
				isDownItemChange = true; //改变皮肤后更新一遍
			}
			if(isDownItemChange)
			{
				isDownItemChange = false;
				
				if(isDownItem)
				{
					if(null == listItemOver)
					{
						listItemOver = Reflection.createSpriteInstance("ComboBox_"+skin+"_listItem_over");
						listItemOver.x = 3;
//						listItemOver.y = 3;
					}
					listItemOver.visible = false;
					addChildAt(listItemOver,0);
				}
				else
				{
					if(null == itemUpBg)
						itemUpBg = Reflection.createSpriteInstance("ComboBox_"+skin+"_item_up");
					addChildAt(itemUpBg,0);
					if(null == itemOverBg)
						itemOverBg = Reflection.createSpriteInstance("ComboBox_"+skin+"_item_over");
					if(contains(itemOverBg))
						removeChild(itemOverBg);
				}
				sizeChange = true;
			}
			if(sizeChange)
			{
				sizeChange = false;
				if(listItemOver)
				{
					listItemOver.width = _w - listItemOver.x*2;
					listItemOver.height = _h - listItemOver.y*2;
				}
				if(itemUpBg)
				{
					itemUpBg.width = _w;
					itemUpBg.height = _h;
				}
				if(itemOverBg)
				{
					itemOverBg.width = _w;
					itemOverBg.height = _h;
				}
				textfeild.y = (_h-textfeild.height)/2;
				textfeild.width = _w - 10;
			}
			if(dataChange)
			{
				dataChange = false;
				if(_data)
				{
					if(_data is String)
						textfeild.text = _data as String;
					else
						textfeild.text = _data.text as String;
				}
				else
					textfeild.text = "";
			}
		}
		
		
		/**
		 * 被加到显示列表时执行 
		 */		
		public override function onShowHandler():void
		{
			super.onShowHandler();
			addEventListener(MouseEvent.MOUSE_OVER , onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT , onMouseOutHandler);
			addEventListener(MouseEvent.CLICK , onMouseClickedHandler);
		}
		
		/**
		 * 从显示列表移除时执行 
		 */		
		public override function onHideHandler():void
		{
			super.onHideHandler();
			removeEventListener(MouseEvent.MOUSE_OVER , onMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT , onMouseOutHandler);
			removeEventListener(MouseEvent.CLICK , onMouseClickedHandler);
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			if(isDownItem)
			{
				if(itemOverBg && contains(itemOverBg))
					removeChild(itemOverBg);
				if(itemUpBg && contains(itemUpBg))
					removeChild(itemUpBg);
//				addChildAt(listItemOver,0);
				listItemOver.visible = true;
			}
			else
			{
				if(itemUpBg && contains(itemUpBg))
					removeChild(itemUpBg);
//				if(listItemOver && contains(listItemOver))
//					removeChild(listItemOver);
				if(listItemOver)
					listItemOver.visible = false;
				addChildAt(itemOverBg,0);
			}
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
			if(isDownItem)
			{
				if(itemOverBg && contains(itemOverBg))
					removeChild(itemOverBg);
				if(itemUpBg && contains(itemUpBg))
					removeChild(itemUpBg);
//				if(listItemOver && contains(listItemOver))
//					removeChild(listItemOver);
				if(listItemOver)
					listItemOver.visible = false;
			}
			else
			{
				if(itemOverBg && contains(itemOverBg))
					removeChild(itemOverBg);
//				if(listItemOver && contains(listItemOver))
//					removeChild(listItemOver);
				if(listItemOver)
					listItemOver.visible = false;
				addChildAt(itemUpBg,0);
			}
		}
		
		protected function onMouseClickedHandler(event:MouseEvent):void
		{
			if(isDownItem)
			{
				event.stopImmediatePropagation();
				dispatchEvent(new ParamEvent(ComboBoxItemRenderer.CLICKED, {data:_data, index:itemIndex}));
			}
		}
	}
}