//
//  RepriceViewController.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/17/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class RepriceViewController: SplitListsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor =
            UIColor(red: 47/255.0, green: 188/255.0, blue: 98/255.0, alpha: 1)
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
