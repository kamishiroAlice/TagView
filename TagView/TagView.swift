//
//  TagView.swift
//  TagView
//
//  Created by HQL on 15/12/14.
//  Copyright © 2015年 FJH. All rights reserved.
//

import UIKit

class TagLabel: UILabel {
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    convenience init(text:String,borderWidth:CGFloat,verticalMagin:CGFloat,borderColor:UIColor,textFont:UIFont){
        self.init()
        let rect = text.boundingRectWithSize(CGSizeMake(0, 0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : textFont], context: nil)
        print(rect)
        self.text = text
        self.layer.borderWidth = borderWidth;
        self.layer.cornerRadius = rect.height * 0.5 + verticalMagin;
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.CGColor
        self.textAlignment = .Center;
        self.font = textFont
        self.userInteractionEnabled = true
    }
}

class TagView: UIView,UIAlertViewDelegate,UITextFieldDelegate{
    /// 数据源
    var strArr = NSMutableArray()
    /// 字体
    var font:UIFont = UIFont.systemFontOfSize(13)
    /// 边框宽度
    var borderWidth:CGFloat = 0.5
    /// 边框颜色
    var borderColor = UIColor.lightGrayColor()
    /// 水平间距
    var horizonMagin:CGFloat = 10
    /// 垂直间距
    var verticalMagin:CGFloat = 5
    /// 标签间间距
    var tagMagin:CGFloat = 5
    /// 是否存在添加按钮
    var isEdit:Bool = false
    /// 最大标签个数
    var maxTagNumber:Int = 5
    /// 标签颜色
    var tagBackColor:UIColor = UIColor.whiteColor()
    /// 添加标签颜色
    var addTagBackColor:UIColor = UIColor.lightGrayColor()
    
    var tagTextLength:Int = 10
    
    private var deleteTag = 0
    
    /**
     遍历构造函数
     */
    
    init?(strArr:NSArray?){
        super.init(frame: CGRectZero)
        guard let dataSource = strArr else{
            return nil
        }
        self.strArr.addObjectsFromArray(dataSource as [AnyObject])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        if strArr.count > self.maxTagNumber {
            self.strArr.removeObjectsInRange(NSRange.init(location: self.maxTagNumber, length: self.strArr.count - self.maxTagNumber))
        }
        
        if self.strArr.count > 0 {
            
            for (index,value) in self.strArr.enumerate() {
                if let text = value as? NSString{
                    let tagLabel = TagLabel(text: text as String, borderWidth: self.borderWidth, verticalMagin: self.verticalMagin, borderColor: self.borderColor,textFont:self.font)
                    tagLabel.tag = index
                    tagLabel.backgroundColor = tagBackColor
                    self.addSubview(tagLabel)
                    getLabelFrame(tagLabel)
                    let recognizer = UILongPressGestureRecognizer(target: self, action: Selector("displayDeleteMenu:"))
                    tagLabel.addGestureRecognizer(recognizer)
                }
            }
            
            if self.isEdit && self.strArr.count < self.maxTagNumber {
                creatAddTag()
            }
        } else if self.isEdit {
            creatAddTag()
        }
        
    }
    
    /**
     计算frame
     
     - parameter label:
     */
    private func getLabelFrame(label:TagLabel){
        if let text = label.text {
            let rect = text.boundingRectWithSize(CGSizeMake(0, 0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.font], context: nil)
            print(rect)
            var LabelX: CGFloat
            var LabelY: CGFloat
            var LabelW: CGFloat
            var LabelH: CGFloat
            
            LabelW = rect.width + (self.horizonMagin * 2)
            LabelH = rect.height + (self.verticalMagin * 2) + 0.1
            
            if subviews.count > 1 {
                let lastView = subviews[subviews.count - 2]
                let estiWidth = CGRectGetMaxX(lastView.frame) + LabelW + (self.tagMagin * 2) * 2
                print("\(self.frame.width)")
                if estiWidth > self.frame.width {
                    LabelX = self.tagMagin * 2
                    LabelY = CGRectGetMaxY(lastView.frame) + (self.tagMagin * 2)
                }else {
                    LabelX = (CGRectGetMaxX(lastView.frame) + (self.tagMagin * 2))
                    LabelY = CGRectGetMinY(lastView.frame)
                }
            } else {
                LabelX = self.tagMagin * 2
                LabelY = self.frame.origin.y + (self.tagMagin * 2)
            }
            label.frame = CGRectMake(LabelX, LabelY, LabelW, LabelH)
        }
        
    }
    
    /**
     展示删除菜单
     
     - parameter recognizer: 长按手势
     */
    @objc private func displayDeleteMenu(recognizer:UILongPressGestureRecognizer){
        if recognizer.state == .Began{
            let menu = UIMenuController()
            if let recognizerView = recognizer.view{
                recognizerView.becomeFirstResponder()
                let menuItem = UIMenuItem(title: "删除", action: Selector("deleteTagLabel:"))
                deleteTag = recognizerView.tag
                menu.menuItems = [menuItem]
                menu.setTargetRect(CGRectMake(recognizerView.frame.width / 2.0, 0, 0, 0), inView: recognizerView)
                menu.setMenuVisible(true, animated: true)
                
            }
        }
    }
    
    /**
     删除按钮点击
     
     - parameter menuItem:
     */
    @objc private func deleteTagLabel(menuItem:UIMenuItem){
        self.strArr.removeObjectAtIndex(deleteTag)
        self.layoutSubviews()
    }
    
    /**
     创建添加按钮
     */
    private func creatAddTag(){
        let addLabel = TagLabel(text: "添加" as String, borderWidth: self.borderWidth, verticalMagin: self.verticalMagin, borderColor: self.borderColor,textFont:self.font)
        addLabel.backgroundColor = self.addTagBackColor
        self.addSubview(addLabel)
        getLabelFrame(addLabel)
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("addTagClick:"))
        addLabel.addGestureRecognizer(recognizer)
    }
    
    /**
     添加标签手势点击
     - parameter recognizer: 手势
     */
    @objc private func addTagClick(recognizer:UITapGestureRecognizer){
        let alertView = UIAlertView(title: "添加关键词", message: nil, delegate: self, cancelButtonTitle: "取消")
        alertView.addButtonWithTitle("确定")
        alertView.alertViewStyle = .PlainTextInput
        alertView.show()
        let textField = alertView.textFieldAtIndex(0)
        print(textField)
        textField?.placeholder = "不超过\(tagTextLength)个字"
        textField?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textFieldDidChange:"), name: "UITextFieldTextDidChangeNotification", object: textField)
    }
    
    /**
     限制textField字数
     - returns:
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        if (string as NSString).length == 0 {return true}
        let existedLength = (textField.text! as NSString).length;
        let selectedLength = range.length;
        let replaceLength = (string as NSString).length;
        
        if (existedLength - selectedLength + replaceLength > tagTextLength) {
            return false
        }
        return true
    }
    
    @objc private func textFieldDidChange(notification:NSNotification){
        if let textField = notification.object as? UITextField,let toBeString = textField.text{
            let toBeString = toBeString as NSString
            let lang = UIApplication.sharedApplication().textInputMode?.primaryLanguage
            print(lang)
            if lang == "zh-Hans" {
                if textField.markedTextRange == nil{
                    if toBeString.length > tagTextLength {
                        textField.text = (toBeString as NSString).substringToIndex(tagTextLength)
                    }
                }else{
                
                }
            }else{
                if (toBeString.length > tagTextLength){
                    textField.text = ((textField.text! as NSString).substringToIndex(tagTextLength)) as String
                }
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        print("tagView deinit")
    }
    
    /**
     alertView的代理
     
     - parameter alertView:   <#alertView description#>
     - parameter buttonIndex: 按钮的Index
     */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if buttonIndex == 1 {
            let textField = alertView.textFieldAtIndex(0)
            
            if let text = textField?.text{
                self.strArr.insertObject(text as NSString, atIndex: self.strArr.count)
                self.layoutSubviews()
                print(self.strArr)
            }
            
        }
    }

}
