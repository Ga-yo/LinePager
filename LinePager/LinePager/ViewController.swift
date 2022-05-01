//
//  ViewController.swift
//  LinePager
//
//  Created by 이가영 on 2022/05/01.
//

import UIKit

class ViewController: PagerViewController {

    init() {
        super.init(title: ["프로필", "채팅", "동네생활"],
                   viewControllers: [RedViewController(), BludViewController(), BlackViewController()],
                   height: 48)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

