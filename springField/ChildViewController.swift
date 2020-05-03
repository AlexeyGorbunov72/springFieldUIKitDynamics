//
//  ChildViewController.swift
//  NavTest
//
//  Created by Alexey on 02.05.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit

class ChildViewController: ViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        imageView.image = .init(imageLiteralResourceName: "putin")
        view.layer.cornerRadius = 20
        print("Subview is alive, bitches!")
    }
    

}
