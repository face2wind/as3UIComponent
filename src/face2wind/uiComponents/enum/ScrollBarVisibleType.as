package face2wind.uiComponents.enum
{
	/**
	 * 滚动条显示类型（用于ScrollPanel组件）
	 * @author face2wind
	 */
	public class ScrollBarVisibleType
	{
		/**
		 * 始终隐藏 
		 */		
		public static const HIDE:int = 0;
		
		/**
		 * 始终显示
		 */		
		public static const SHOW:int = 1;
		
		/**
		 * 智能隐藏和显示（根据宽度或高度判断） 
		 */		
		public static const AUTOMATIC:int = 2;
	}
}