//
//  ViewController.swift
//  TagView
//
//  Created by HQL on 15/12/14.
//  Copyright © 2015年 FJH. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arr = ["java程序猿" as NSString,"ios程序猿","php程序猿","php程序猿圆圆圆圆圆圆圆","php程序猿","php程序猿圆圆圆圆圆圆"] as NSArray
        let tagView = TagView(strArr: arr)
//        let tagView = TagView(strArr: nil)
        view.backgroundColor = UIColor.whiteColor()
        guard let myTagView = tagView else{
            return
        }
        view.addSubview(myTagView)
        myTagView.isEdit = true
        myTagView.addTagBackColor = UIColor.grayColor()
        myTagView.tagBackColor = UIColor.yellowColor()
        myTagView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height - 64)
        myTagView.maxTagNumber = 10;
        
        
        let btn = UIButton()
        btn.backgroundColor = UIColor.yellowColor()
        view.addSubview(btn)
        btn.frame = CGRectMake(view.center.x, view.center.y, 50, 50)
        btn.center = view.center
        btn.addTarget(self, action: Selector("pushBtnClick:"), forControlEvents: .TouchUpInside)
    }
    
    @objc private func pushBtnClick(btn:UIButton){
        let vc =  ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

