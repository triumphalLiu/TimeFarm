//
//  GuideViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import UIKit

class GuideViewController: UIViewController, UIScrollViewDelegate {
    //页面数量
    var numOfPages = 3
    
    override func viewDidLoad()
    {
        let frame = self.view.bounds
        //scrollView的初始化
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages), height:frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        for i in 0..<numOfPages{
            let imgfile = "help\(i+1).png"
            let image = UIImage(named:"\(imgfile)")
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x:frame.size.width * CGFloat(i), y:CGFloat(0),
                                   width:frame.size.width, height:frame.size.height)
            scrollView.addSubview(imgView)
        }
        scrollView.contentOffset = CGPoint.zero
        self.view.addSubview(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let twidth = CGFloat(numOfPages-1) * self.view.bounds.size.width
        if(scrollView.contentOffset.x > twidth)
        {
            if (!(UserDefaults.standard.bool(forKey: "everLaunched"))){
                self.presentingViewController!.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(true, forKey:"everLaunched")
            }
            else{
                self.presentingViewController!.dismiss(animated: true, completion: nil)
            }
        }
    }
}
