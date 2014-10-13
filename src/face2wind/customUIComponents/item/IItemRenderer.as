package face2wind.customUIComponents.item
{
	/**
	 * 列表项接口对象 
	 * @author face2wind
	 */	 
	public interface IItemRenderer
	{
		/**
		 * 当前索引
		 */
		function get itemIndex():int;
		/**
		 * @private
		 */
		function set itemIndex(value:int):void;
		
		/**
		 * 显示内容
		 */
		function get label():String;
		/**
		 * @private
		 */
		function set label(value:String):void;
		
		/**
		 * 是否选中
		 */
		function get selected():Boolean;
		/**
		 * @private
		 */
		function set selected(value:Boolean):void;
		/**
		 * 设置数据源 
		 * @param value
		 * 
		 */		
		function set data(value:Object): void;
		/**
		 * 设置数据源 
		 * @param value
		 * 
		 */		
		function get data(): Object;
	}
}