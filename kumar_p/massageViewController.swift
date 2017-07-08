//
//  massageViewController.swift
//  kumar_p
//
//  Created by Takuya Kudo on 2017/07/08.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import UIKit

class massageViewController: UIViewController {

    @IBOutlet weak var mylabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mylabel.text = "Hello";

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
