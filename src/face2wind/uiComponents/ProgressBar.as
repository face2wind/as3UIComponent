package face2wind.uiComponents
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	
	import face2wind.uiComponents.enum.ProgressBarType;
	import face2wind.uiComponents.enum.ProgressTxtType;
	
	import face2wind.lib.Reflection;
	import face2wind.view.BaseSprite;
	
	/**
	 * 进度条组件<br/>
	 * 直接读取对应的mc，mc里的进度条和背景相对位置要预先调好，这里会根据相对位置来动态改变<br/>
	 * 通过curValue和maxValue设置显示的进度数字，或者直接设置rate
	 * @author face2wind
	 */
	public class ProgressBar extends BaseSprite
	{
		/**
		 * 皮肤MC 
		 */		
		private var allMc:MovieClip = null;
		
		/**
		 * 进度条前景（在mc里固定好，位置调到适配背景就好）
		 */		
		private var progressBarMc:MovieClip = null;
		
		/**
		 * 进度条背景（在mc里固定好，位置是(0,0)）
		 */		
		private var backgroundMc:MovieClip = null;
		
		/**
		 * 进度条和背景的原始偏移值，用于拉伸时计算 
		 */		
		private var originalOffset:Point = null;
		
		/**
		 * 进度文本信息 
		 */		
		private var rateText:CustomTextfield = null;
		
		public function ProgressBar(newSkin:int = 1)
		{
			super();
			_skin = newSkin;
			_w = 100;
		}
		
		private var _skin:int = ProgressBarType.NORMAL;
		
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
		
		private var _rate:Number = 0;
		/**
		 * 当前进度，和curValue是互斥关系
		 */
		public function get rate():Number
		{
			return _rate;
		}
		/**
		 * @private
		 */
		public function set rate(value:Number):void
		{
			if(_rate == value)
				return;
			
			_rate = value;
			_curValue = _rate*_maxValue;
			rateChange = true;
			propertyChange();
		}
		
		private var _curValue:Number = 0;
		/**
		 * 当前值（用于显示和计算进度）和rate是互斥关系
		 */
		public function get curValue():Number
		{
			return _curValue;
		}
		/**
		 * @private
		 */
		public function set curValue(value:Number):void
		{
			if(_curValue == value)
				return;
			
			_curValue = value;
			_rate = _curValue/maxValue;
			rateChange = true;
			propertyChange();
		}
		
		private var _maxValue:Number = 100;
		/**
		 * 最大值（用于显示和计算进度）和rate是互斥关系
		 */
		public function get maxValue():Number
		{
			return _maxValue;
		}
		/**
		 * @private
		 */
		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			_rate = _curValue/maxValue;
			rateChange = true;
			propertyChange();
		}

		private var _txtType:int = ProgressTxtType.RATE;
		/**
		 * 进度显示类型，默认 ProgressTxtType.RATE
		 */
		public function get txtType():int
		{
			return _txtType;
		}
		/**
		 * @private
		 */
		public function set txtType(value:int):void
		{
			if(_txtType == value)
				return;
			
			_txtType = value;
			updateTxt = true;
			propertyChange();
		}

		private var _precision:int = 0;
		/**
		 * 进度显示精确度（保留小数点后面几位，默认0） 
		 */
		public function get precision():int
		{
			return _precision;
		}
		/**
		 * @private
		 */
		public function set precision(value:int):void
		{
			if(_precision == value)
				return;
			
			_precision = value;
			updateTxt = true;
			propertyChange();
		}

		
		/**
		 * 重写宽度设定，直接设置到_w里，布局时用到 
		 * @param value
		 * 
		 */		
		public override function set width(value:Number):void
		{
			if(_w == value)
				return;
			
			_w = value;
			sizeChange = true;
			propertyChange();
		}
		
		/**
		 * 屏蔽高度设定（避免无谓的拉伸） 
		 * @param value
		 */		
		public override function set height(value:Number):void
		{
			if(_h == value)
				return;
			
			_h = value;
			sizeChange = true;
			propertyChange();
		}

		public override function setActualSize(newWidth:Number, newHeight:Number):void
		{
			super.setActualSize(newWidth, newHeight);
			sizeChange = true;
			propertyChange();
		}
		
		/**
		 * 宽高改变 
		 */		
		private var sizeChange:Boolean = false;
		
		/**
		 * 皮肤改变 
		 */		
		private var skinChange:Boolean = false;
		
		/**
		 * 进度变化 
		 */		
		private var rateChange:Boolean = false;
		
		/**
		 * 进度条文本变化 
		 */		
		private var updateTxt:Boolean = false;
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖 
		 * 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			rateText = new CustomTextfield();
//			rateText.border = true;
			rateText.align = TextFormatAlign.CENTER;
			rateText.height = 20;
			rateText.size = 12;
			addChild(rateText);
			
			skinChange = true;
		}
		
		/**
		 * 属性变更，更新视图 
		 * 
		 */	
		protected override function update():void
		{
			super.update();
			var maxWidth:Number;
			if(skinChange)
			{
				skinChange = false;
				if(allMc && contains(allMc))
					removeChild(allMc);
				allMc = Reflection.createMovieClipInstance("progressBar_" + skin + "_mc");
				if(allMc)
				{
					addChildAt(allMc,0);
					backgroundMc = allMc["background"] as MovieClip;
					progressBarMc = allMc["progressBar"] as MovieClip;
					if(null == backgroundMc || null == progressBarMc)
					{
						throw new Error("ProgressBar hasn't this skin : " + skin);
						return;
					}
					if(0 == _h)
						_h = backgroundMc.height;
					
				}
				sizeChange = true;
			}
			if(sizeChange)
			{
				sizeChange = false;
				backgroundMc.width = _w;
				backgroundMc.height = _h;
				progressBarMc.height = _h - progressBarMc.y*2;
				maxWidth = _w - progressBarMc.x*2;
				
				rateText.x = progressBarMc.x;
				rateText.y = progressBarMc.y + (progressBarMc.height-rateText.height)/2;
				rateText.width = maxWidth;
				
				rateChange = true;
			}
			if(rateChange)
			{
				rateChange = false;
				maxWidth = _w - progressBarMc.x*2;
				progressBarMc.width = rate*maxWidth;
				
				updateTxt = true;
			}
			if(updateTxt)
			{
				updateTxt = false;
				if(ProgressTxtType.HIDE == txtType)
				{
					if(contains(rateText))
						removeChild(rateText);
				}
				else
				{
					if(!contains(rateText))
						addChild(rateText);
					if(ProgressTxtType.RATE == txtType)
					{
						if(0 == precision)
							rateText.text = int(100*rate)+"%";
						else
							rateText.text = (100*rate).toFixed(precision)+"%";
					}
					else if(ProgressTxtType.VALUE == txtType)
					{
						if(0 == precision)
							rateText.text = int(curValue) + "/" + int(maxValue);
						else
							rateText.text = curValue.toFixed(precision) + "/" + maxValue.toFixed(precision);
					}
				}
			}
		}
	}
}