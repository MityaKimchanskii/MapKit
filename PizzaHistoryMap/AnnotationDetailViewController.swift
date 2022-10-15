//
//  AnnotationDetailViewController.swift
//  PizzaHistoryMap
//
//  Created by Mitya Kim on 10/14/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

import UIKit

class AnnotationDetailViewController: UIViewController {
    
    var annotation:PizzaAnnotation!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pizzaPhoto: UIImageView!
    @IBOutlet weak var historyText: UITextView!
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = annotation.title
        pizzaPhoto.image = annotation.pizzaPhoto
        historyText.text = annotation.historyText
    }

    

}
