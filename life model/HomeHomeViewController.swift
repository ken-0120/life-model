//
//  HomeHomeViewController.swift
//  life model
//
//  Created by student on 2024/07/130.
//

import UIKit

class HomeHomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if hasLaunchedBefore {
            performSegue(withIdentifier:"bbb", sender: nil)
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            performSegue(withIdentifier:"aaa", sender: nil)
        }
    }
}
