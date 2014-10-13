package face2wind.uiComponents.controll
{
	import flash.events.EventDispatcher;
	
	import face2wind.uiComponents.RadioButton;

	/**
	 * 单选组件控制器
	 * @author face2wind
	 */
	public class RadioButtonGroup extends EventDispatcher
	{
		/**
		 * 存储当前组管理的单选按钮列表 
		 */		
		private var radioList:Array = null;
		
		public function RadioButtonGroup()
		{
			radioList = [];
		}
		
		/**
		 * 移除一个单选组件 
		 * @param param0
		 * 
		 */		
		public function removeItem(radio:RadioButton):void
		{
			var index:int = radioList.indexOf(radio);
			if(-1 != index)
				radioList.splice(index,1);
		}
		
		/**
		 * 增加一个单选组件对象到当前组 
		 * @param param0
		 * 
		 */		
		public function addItem(radio:RadioButton):void
		{
			if(radio)
				radioList.push(radio);
		}
		
		/**
		 * 选中某个单选按钮（此接口由单选按钮那边主动调用） 
		 * @param radio
		 * 
		 */		
		public function selectItem(radio:RadioButton):void
		{
			if(null == radio)
				return;
			if(curselectedItem == radio)
				return;
			
			if(null != curselectedItem)
				curselectedItem.selected = false;
			curselectedItem = radio;
			_curselectItemIndex = radioList.indexOf(curselectedItem);
		}
		
		/**
		 * 手动设定选中那个下标的单选按钮 
		 * @param index
		 * @return 
		 * 
		 */		
		public function selectItemWithIndex(index:int):RadioButton
		{
			if(index < 0 || index >= radioList.length) //过滤非法下标
				return null;
			if(index == radioList.indexOf(curselectedItem))//设置的目标已经选中，忽略
				return curselectedItem;
			
			if(null != curselectedItem)
				curselectedItem.selected = false;
			curselectedItem = radioList[index] as RadioButton;
			curselectedItem.selected = true;
			_curselectItemIndex = index;
			return curselectedItem;
		}
		
		private var _enable:Boolean = true;
		/**
		 * 是否可点击（若不可点击，则按钮会变灰） 
		 */
		public function get enable():Boolean
		{
			return _enable;
		}
		/**
		 * @private
		 */
		public function set enable(value:Boolean):void
		{
			_enable = value;
			for (var i:int = 0; i < radioList.length; i++) 
			{
				(radioList[i] as RadioButton).enable = _enable;
			}
		}
		
		private var _curselectItemIndex:int = -1;
		/**
		 * 当前选中的单选下标 （-1则表示没有选中，未初始化）
		 */
		public function get curselectItemIndex():int
		{
			return _curselectItemIndex;
		}
		
		/**
		 * 当前选中的单选按钮 
		 */		
		private var curselectedItem:RadioButton = null;

	}
}