//
//  ViewController.swift
//  TagView
//
//  Created by HQL on 15/12/14.
//  Copyright © 2015年 FJH. All rights reserved.
//

import UIKit
import SnapKit
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
        myTagView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view.snp_edges).offset(UIEdgeInsetsMake(64, 0, 0, 0))
        }
//        tagView.frame = CGRectMake(0, 64, self.view.frame.width, self.view.frame.height)
        myTagView.maxTagNumber = 10;
        
        let btn = UIButton()
        btn.backgroundColor = UIColor.yellowColor()
        view.addSubview(btn)
        btn.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.centerY.equalTo(self.view.snp_centerY)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        btn.addTarget(self, action: Selector("pushBtnClick:"), forControlEvents: .TouchUpInside)
        
        print(("jjfly尼玛死了" as NSString ).length)
        
        
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

