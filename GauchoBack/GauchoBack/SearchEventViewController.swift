//
//  SearchEventViewController.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/4/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit

class SearchEventViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 250, 20))
    
    var pickerDataSource = ["Name", "Description", "Host", "Location", "Event Type"];
    
    @IBOutlet weak var searchTypePicker: UIPickerView!

    /*
    var pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
    pickerView.backgroundColor = .whiteColor()
    pickerView.showsSelectionIndicator = true
    
    var toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.Default
    toolBar.translucent = true
    toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    toolBar.sizeToFit()
    
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePicker")
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "canclePicker")
    
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.userInteractionEnabled = true
    
    textField.inputView = pickerView
    textField.inputAccessoryView = toolBar
    */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.searchTypePicker.dataSource = self;
        self.searchTypePicker.delegate = self;
        
        searchBar.placeholder = "Search by ..."
        self.navigationItem.titleView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(searchTypePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0)
        {
            self.view.backgroundColor = UIColor.whiteColor();
        }
        else if(row == 1)
        {
            self.view.backgroundColor = UIColor.redColor();
        }
        else if(row == 2)
        {
            self.view.backgroundColor =  UIColor.greenColor();
        }
        else
        {
            self.view.backgroundColor = UIColor.blueColor();
        }
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
