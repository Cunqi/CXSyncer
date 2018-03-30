//
//  ViewController.swift
//  CXSyncDemo
//
//  Created by Cunqi Xiao on 3/29/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXSyncer

class Demo: CXSyncable {
    var data: Data {
        return UUID().uuidString.data(using: .utf8) ?? Data()
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        for _ in 0 ..< 1000 {
            let demo = Demo()
            CXSyncer.shared.submit(demo)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
