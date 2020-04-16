//
//  NewsViewController.swift
//  ToDo
//
//  Created by Tran Le on 4/16/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func newsButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.nytimes.com/")! as URL, options: [:], completionHandler: nil)
    }
}
