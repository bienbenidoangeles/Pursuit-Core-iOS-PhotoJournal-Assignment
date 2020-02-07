//
//  SettingsTableViewController.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Bienbenido Angeles on 1/31/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

struct UserDefaultKeys {
    static let selectDirection = "Scroll Direction"
    static let backgroundColor = "Background Color"
}

struct Color : CustomStringConvertible{
    var description: String{
        return "Red: \(red), Green: \(green), Blue: \(blue)"
    }
    
    var red:CGFloat
    var green:CGFloat
    var blue:CGFloat

//    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
//        self.red = red
//        self.green = green
//        self.blue = blue
//    }
}

protocol SettingsButtonPressed: AnyObject {
    func settingsParameters(_ scrollDirection: Int, _ bgColor: [CGFloat])
}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var delegate: SettingsButtonPressed?
    
    var selectDirection = 0{
        didSet{
            UserDefaults.standard.set(selectDirection, forKey: UserDefaultKeys.selectDirection)
        }
    }
    
    var color = Color(red: 0.0, green: 0.0, blue: 0.0){
        didSet{
            UserDefaults.standard.set([color.red, color.green, color.blue], forKey: UserDefaultKeys.backgroundColor)
            print("SET:", color.description)
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSliderMinMaXVal()
        if let colorsSaved = UserDefaults.standard.object(forKey: UserDefaultKeys.backgroundColor) as? [CGFloat] {
            print("GET:", color.description)
            redSlider.value = Float(colorsSaved[0])
            color.red = colorsSaved[0]
            greenSlider.value = Float(colorsSaved[1])
            color.green = colorsSaved[1]
            blueSlider.value = Float(colorsSaved[2])
            color.blue = colorsSaved[2]

            //view.backgroundColor = UIColor(displayP3Red: colorsSaved[0], green: colorsSaved[1], blue: colorsSaved[2], alpha: 1.0)
        }
       
        if let indexSaved = UserDefaults.standard.object(forKey: UserDefaultKeys.selectDirection) as? Int {
            segmentedControl.selectedSegmentIndex = indexSaved
        }
    
    }
    
    func configureSliderMinMaXVal(){
        redSlider.minimumValue = 0.0
        redSlider.maximumValue = 1.0
        greenSlider.minimumValue = 0.0
        greenSlider.maximumValue = 1.0
        blueSlider.minimumValue = 0.0
        blueSlider.maximumValue = 1.0
    }
    
    func updateUI(){
        //view.backgroundColor = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) else {
            return
        }
        tableView(self.tableView, willDisplay: cell, forRowAt: IndexPath(row: 1, section: 0))
    }
    
    @IBAction func scrollDirectionChoosed(_ sender: UISegmentedControl) {
        selectDirection = sender.selectedSegmentIndex
        delegate?.settingsParameters(selectDirection, [color.red, color.green, color.blue])
    }
    
    @IBAction func redSlider(_ sender: UISlider) {
        color.red = CGFloat(sender.value)
        delegate?.settingsParameters(selectDirection, [color.red, color.green, color.blue])
    }
    
    @IBAction func greenSlider(_ sender: UISlider) {
        color.green = CGFloat((sender.value))
        delegate?.settingsParameters(selectDirection, [color.red, color.green, color.blue])
    }
    
    @IBAction func blueSlider(_ sender: UISlider) {
        color.blue = CGFloat((sender.value))
        delegate?.settingsParameters(selectDirection, [color.red, color.green, color.blue])
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "BackGroundCell"{
            cell.backgroundColor = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
        }
    }
}
