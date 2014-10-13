package face2wind.uiComponents.enum
{
	/**
	 * 滚动条位置类型（同时设置垂直滚动条和水平滚动条相对于滚动组件的位置，用于ScrollPanel）
	 * @author face2wind
	 */
	public class ScrollBarPositionType
	{
		/**
		 * 垂直滚动条在左边，水平滚动条在上面
		 */		
		public static const LEFT_TOP:int = 1;
		
		/**
		 * 垂直滚动条在左边，水平滚动条在下面
		 */		
		public static const LEFT_BOTTOM:int = 2;
		
		/**
		 * 垂直滚动条在右边，水平滚动条在上面
		 */		
		public static const RIGHT_TOP:int = 3;
		
		/**
		 * 垂直滚动条在右边，水平滚动条在下面
		 */		
		public static const RIGHT_BOTTOM:int = 4;
		
		/**
		 * 垂直、水平滚动条的位置都是手动设置，默认都放在(0,0)位置
		 */		
		public static const MANUALLY:int = 5;
	}
}