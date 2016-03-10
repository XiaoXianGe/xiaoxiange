//
//  MKNumberBadgeView.h
//  
// Copyright 2009-2012 Michael F. Kamprath
// michael@claireware.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
// MKNumberBadgeView
// -----------------
//
// Use this class to display a badge containing an integer value.Similar to the app icon badges that the iPhone OS permits.
//
// Notes:
//    * When creating the view, the frame used should be larger than the expected visual size of the badge view. Use the alignment 
//      property to control the horizontal placement of the badge within the view's bounds. The badge will always be vertically
//      centered for the badge itself ignoring the size fo the shadow if it is enabled.
//    * The view's background color is automatically set to clear. If you change the background color, you may get curious results.
//
/**
 *  徽章 (Badge) 效果的视图控件
 */
#import <UIKit/UIKit.h>


@interface MKNumberBadgeView : UIView 
{
	NSUInteger _value;
}

// Text format for the badge, defaults to just the number
//文本格式的徽章,违约数量
@property (retain,nonatomic) NSString *textFormat;

// Adjustment offset for the text in the badge
//调整抵消文本的徽章
@property (assign,nonatomic) CGPoint adjustOffset;

// The current value displayed in the badge. Updating the value will update the view's display
//当前值显示在徽章。更新值将更新视图的显示
@property (assign,nonatomic) NSUInteger value;

// Indicates whether the badge view draws a dhadow or not.
//指示是否徽章的观点吸引了dhadow
@property (assign,nonatomic) BOOL shadow;

// The offset for the shadow, if there is one.
//阴影的偏移量,如果有一个。
@property (assign,nonatomic) CGSize shadowOffset;

// The base color for the shadow, if there is one.
//基本色的影子,如果有的话。
@property (retain,nonatomic) UIColor * shadowColor;

// Indicates whether the badge view should be drawn with a shine
//表明徽章视图是否应该被光芒
@property (assign,nonatomic) BOOL shine;

// The font to be used for drawing the numbers. NOTE: not all fonts are created equal for this purpose.
// Only "system fonts" should be used.
//字体用于绘画的数字。注意:并不是所有的字体都是平等的。
//只应该使用“系统字体”
@property (retain,nonatomic) UIFont* font;

// The color used for the background of the badge.
//用于徽章的背景颜色。
@property (retain,nonatomic) UIColor* fillColor;

// The color to be used for drawing the stroke around the badge.
//颜色用于画中风徽章。
@property (retain,nonatomic) UIColor* strokeColor;

// The width for the stroke around the badge.
//在徽章中风的宽度
@property (assign,nonatomic) CGFloat strokeWidth;

// The color to be used for drawing the badge's numbers.
//用于绘制徽章的颜色号码。
@property (retain,nonatomic) UIColor* textColor;

// How the badge image hould be aligned horizontally in the view.
//徽章的形象应该如何保持一致水平的观点。
@property (assign,nonatomic) NSTextAlignment alignment;

// Returns the visual size of the badge for the current value. Not the same hing as the size of the view's bounds.
// The badge view bounds should be wider than space needed to draw the badge.
//返回当前值的徽章的视觉大小。不一样的兴视图的范围的大小。
//徽章视图边界应该是更广泛的比空间需要画出徽章。
@property (readonly,nonatomic) CGSize badgeSize;

// The number of pixels between the number inside the badge and the stroke around the badge. This value 
// is approximate, as the font geometry might effectively slightly increase or decrease the apparent pad.
//像素的数量在徽章数量和中风之间的徽章。这个值
//是近似的,因为字体几何可能有效地垫略增加或减少明显。
@property (nonatomic) NSUInteger pad;

// If YES, the badge will be hidden when the value is 0
//如果是的,徽章将被隐藏时,该值为0
@property (nonatomic) BOOL hideWhenZero;

@end
