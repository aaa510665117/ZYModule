//
//  MyViewController.h
//  MobileHospital
//
//  Created by ZY on 2018/7/3.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "DropDownMenuList.h"

//是否是iPhone X
#define DDMis_iPhoneX          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//状态栏高度
#define DDMStatusBarHeight     (DDMis_iPhoneX ? 44.f : 20.f)
// 导航高度
#define DDMNavigationBarHeight 44.f

@interface DropDownMenuList()

@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic) CGRect buttonFrame;
@property(nonatomic, retain) NSArray *titleList;
@property(nonatomic, retain) NSArray *detailList;
@property(nonatomic, strong) NSArray *titleMatchList;

@property(nonatomic, strong) NSMutableArray * multiAry;            //多选后的结果

@end

@implementation DropDownMenuList

-(NSMutableArray *)multiAry
{
    if(!_multiAry)
    {
        _multiAry = [[NSMutableArray alloc]init];
    }
    return _multiAry;
}

-(UITableView *)myTableView
{
    if(!_myTableView)
    {
        _myTableView = [[UITableView alloc]init];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.layer.cornerRadius = 5;
//        _myTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _myTableView.layer.borderWidth = 0.8f;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTableView.separatorColor = [UIColor grayColor];
        _myTableView.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
        _myTableView.backgroundColor = [UIColor whiteColor];
        [_myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_myTableView flashScrollIndicators];//显示滚动条
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}

- (void)showDropDownMenu:(CGRect)buttonFrame arrayOfTitle:(NSArray *)titleArr arrayOfDetail:(NSArray *)detailArr{
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.01];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelf:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    self.buttonFrame = buttonFrame;
    if (self) {
        CGRect btnRect = buttonFrame;//按钮在视图上的位置
        CGFloat height = 0;//菜单高度
        if ( titleArr.count <= 4) {
            height = titleArr.count *35;
        }else{
            height = 200;
        }
        
        self.titleList = [NSArray arrayWithArray:titleArr];
        self.detailList = [NSArray arrayWithArray:detailArr];

        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10000);
        
        if((btnRect.origin.y+2+height) > ([UIScreen mainScreen].bounds.size.height-DDMStatusBarHeight-DDMNavigationBarHeight))
        {
            //向上弹出
            self.myTableView.frame = CGRectMake(btnRect.origin.x, btnRect.origin.y-2, btnRect.size.width, 0);
        }
        else
        {
            self.myTableView.frame = CGRectMake(btnRect.origin.x, btnRect.origin.y+btnRect.size.height+2, btnRect.size.width, 0);
        }
        
        [UIView beginAnimations:nil context:nil];//动画
        [UIView setAnimationDuration:0.2];
        //菜单视图的最终大小和位置
        if((btnRect.origin.y+2+height) > ([UIScreen mainScreen].bounds.size.height-DDMStatusBarHeight-DDMNavigationBarHeight))
        {
            //向上弹出
            self.myTableView.frame = CGRectMake(btnRect.origin.x, btnRect.origin.y-2-height, btnRect.size.width, height);
        }
        else
        {
            self.myTableView.frame = CGRectMake(btnRect.origin.x, btnRect.origin.y+btnRect.size.height+2, btnRect.size.width, height);
        }
        [UIView commitAnimations];
        [self addSubview:self.myTableView];

        //进行默认值定位
        if(_beginChoseStr.count != 0){
            long idx = [_titleList indexOfObject:[_beginChoseStr objectAtIndex:0]];
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [_myTableView scrollToRowAtIndexPath:scrollIndexPath
                                atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
        if(self.isCanMatchStr == YES)
        {
            UIView * headerView = [[UIView alloc]initWithFrame:self.buttonFrame];
            headerView.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
            headerView.layer.borderWidth = 1.0f;
            headerView.layer.cornerRadius = 3.0f;
            UIImageView * searchImg = [[UIImageView alloc]init];
            searchImg.translatesAutoresizingMaskIntoConstraints = NO;
            searchImg.image = [UIImage imageNamed:@"dd_search"];
            [headerView addSubview:searchImg];
            [searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView.mas_left).with.offset(10);
                make.centerY.equalTo(headerView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(15, 13));
            }];
            
            headerView.backgroundColor = [UIColor whiteColor];
            UITextField * searchTextField = [[UITextField alloc]init];
            [searchTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
            searchTextField.placeholder = @"关键字";
            searchTextField.textAlignment = NSTextAlignmentCenter;
            searchTextField.textColor = [UIColor lightGrayColor];
            searchTextField.font = [UIFont systemFontOfSize:12];
            [headerView addSubview:searchTextField];
            [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView.mas_left).with.offset(25);
                make.centerY.equalTo(headerView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.myTableView.frame.size.width-50, 25));
            }];
            [self addSubview:headerView];
        }
        
        //多选完成按钮
        if(self.isMultiSelect == YES)
        {
            UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(btnRect.origin.x, self.myTableView.frame.origin.y+self.myTableView.frame.size.height+5, self.myTableView.frame.size.width, 25)];
            footerView.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
            footerView.layer.cornerRadius = 3.0f;
            UIButton * doneBtn = [[UIButton alloc]init];
            doneBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
            doneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [doneBtn addTarget:self action:@selector(clickMultiDone) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:doneBtn];
            [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(footerView.mas_left).with.offset(0);
                make.right.equalTo(footerView.mas_right).with.offset(0);
                make.top.equalTo(footerView.mas_top).with.offset(0);
                make.bottom.equalTo(footerView.mas_bottom).with.offset(0);
            }];
            [self addSubview:footerView];
        }
    }
}

-(void)clickMultiDone
{
    if(_clickChoseMulti){
        _clickChoseMulti(_multiAry);
    }
    [self removeFromSuperview];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{}

-(void)textFieldTextChange:(UITextField *)textField{
    NSMutableArray * temp = [[NSMutableArray alloc]init];
    [_titleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str = obj;
        if([str containsString:textField.text])
        [temp addObject:str];
    }];
    _titleMatchList = temp;
    [self.myTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * str;
    if(_titleMatchList.count != 0){
        str =[_titleMatchList objectAtIndex:indexPath.row];
    }else{
        str =[_titleList objectAtIndex:indexPath.row];
    }
    CGSize size = [self getSizeFromString:str withFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(self.myTableView.frame.size.width-20, 10000)];
    return size.height+20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_titleMatchList.count != 0){
        return _titleMatchList.count;
    }
    return [self.titleList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if(_detailList.count == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.detailTextLabel.hidden = YES;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.frame = CGRectMake(10, 10, cell.contentView.frame.size.width-20, cell.contentView.frame.size.height-20);
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.textLabel.frame = CGRectMake(10, 10, 50, cell.contentView.frame.size.height-20);
            cell.detailTextLabel.frame = CGRectMake(cell.contentView.frame.size.width-60, 10, 40, cell.contentView.frame.size.height-20);
            cell.detailTextLabel.backgroundColor = [UIColor redColor];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    if(_titleMatchList.count != 0){
        cell.textLabel.text =[_titleMatchList objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text =[_titleList objectAtIndex:indexPath.row];
        if(_detailList.count != 0){
            cell.detailTextLabel.text = [_detailList objectAtIndex:indexPath.row];
        }
        //默认选中内容
        if(_beginChoseStr.count != 0){
            if([_beginChoseStr containsObject:[_titleList objectAtIndex:indexPath.row]]){
                cell.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1.0];
            }else{
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        
        //多选
        if(_isMultiSelect == YES)
        {
            if([self.multiAry containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]){
                cell.backgroundColor = [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:1.0];
            }else{
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    

    
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(_isMultiSelect == NO)
    {
        //单选
        if(_titleMatchList.count != 0){
            NSString * choseStr = [_titleMatchList objectAtIndex:indexPath.row];
            long idx = [_titleList indexOfObject:choseStr];
            if(_clickIndex){
                _clickIndex(idx);
            }
        }else{
            if(_clickIndex){
                _clickIndex(indexPath.row);
            }
        }
        [self removeFromSuperview];
    }
    else
    {
        //多选
        if(_titleMatchList.count != 0){
            NSString * choseStr = [_titleMatchList objectAtIndex:indexPath.row];
            long idx = [_titleList indexOfObject:choseStr];
            if([self.multiAry containsObject:[NSString stringWithFormat:@"%ld",idx]]){
                [self.multiAry removeObject:[NSString stringWithFormat:@"%ld",idx]];
            }else{
                [self.multiAry addObject:[NSString stringWithFormat:@"%ld",idx]];
            }
        }else{
            if([self.multiAry containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]){
                [self.multiAry removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
            }else{
                [self.multiAry addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
            }
            [_myTableView reloadData];
        }
    }

}

- (void)clickSelf:(UIView *)sender {
    //点击科室
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.myTableView]) {
        return NO;
    }
    return YES;
}

// 获取字符串的长度
- (CGSize)getSizeFromString:(NSString *)stringText withFont:(UIFont *)font constrainedToSize:(CGSize)maxSize
{
    if (stringText == nil || font == nil)
    {
        return CGSizeZero;
    }
    CGSize size = CGSizeZero;
    
    if ([stringText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGRect rect = [stringText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName] context:nil];
        size = CGSizeMake(rect.size.width, rect.size.height);
    }
    else
    {
        //        size = [stringText sizeWithFont:font constrainedToSize:maxSize];
        CGRect rect = [stringText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        size = CGSizeMake(rect.size.width, rect.size.height);
    }
    
    return size;
}

-(void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bubbleRect;
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGMutablePathRef bubblePath = CGPathCreateMutable();
    CGContextSetStrokeColorWithColor(c, [UIColor darkGrayColor].CGColor);
    CGContextSetLineWidth(c, 1);
    //绘制区域
    bubbleRect = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, self.myTableView.frame.size.height);
    //三角形顶点坐标
    float pointWeight = _isHasTriangle ? 5 : 0;
    float pointHigh = _isHasTriangle ? 5 : 0;
    float pointX = self.myTableView.frame.origin.x+self.myTableView.frame.size.width/2 + _triangleOrginX;
    float pointY = _isHasTriangle ? self.myTableView.frame.origin.y-pointHigh : self.myTableView.frame.origin.y;

    CGPathMoveToPoint(bubblePath, NULL, pointX, pointY);
    //起始点到三角形右下角
    CGPathAddLineToPoint(bubblePath, NULL, pointX+pointWeight, pointY+pointHigh);
    //三角形右下角 向右延伸至圆弧
    CGPathAddArcToPoint(bubblePath, NULL,
                        bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
                        bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+5,
                        5);
    
    CGPathAddArcToPoint(bubblePath, NULL,
                        bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
                        bubbleRect.origin.x+bubbleRect.size.width-5, bubbleRect.origin.y+bubbleRect.size.height,
                        5);
    CGPathAddArcToPoint(bubblePath, NULL,
                        bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
                        bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-5,
                        5);
    CGPathAddArcToPoint(bubblePath, NULL,
                        bubbleRect.origin.x, bubbleRect.origin.y,
                        bubbleRect.origin.x+5, bubbleRect.origin.y,
                        5);
    //最后圆弧到三角形左下角，准备进行闭合操作
    CGPathAddLineToPoint(bubblePath, NULL, pointX-pointWeight, pointY+pointHigh);
    
    CGPathCloseSubpath(bubblePath);
    CGContextSaveGState(c);
    CGContextAddPath(c, bubblePath);
    CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
    CGContextDrawPath(c, kCGPathFillStroke);
    CGContextClip(c);
    CGContextRestoreGState(c);
}

-(void)dealloc {
}
@end
