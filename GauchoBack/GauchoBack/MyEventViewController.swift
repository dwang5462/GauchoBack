//
//  MyEventViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/17/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit

class MyEventViewController: UIViewController {

    @IBOutlet weak var eventTitle: UILabel!
    
    
    var titleString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTitle.text = self.titleString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
