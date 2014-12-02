package face2wind.customUIComponents.item
{
	import face2wind.view.BaseSprite;
	
	/**
	 * 列表子项基类
	 * @author Face2wind
	 */
	public class ItemRenderer extends BaseSprite implements IItemRenderer
	{
		public function ItemRenderer()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
		}
		
		private var _itemIndex:int = 0;
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		
		private var _label:String = "";
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
		}
		
		private var _selected:Boolean = false;
		/**
		 * 当前项被选中后的处理函数 
		 * @return 
		 * 
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
		}
		
		public function set data(value:Object):void
		{
			//交给子类覆盖
		}
		public function get data():Object
		{
			//交给子类覆盖
			return null;
		}
		
		public override function resume():void
		{
			super.resume();
			
		}
		
		public override function dispose():void
		{
			super.dispose();
			
		}
	}
}
