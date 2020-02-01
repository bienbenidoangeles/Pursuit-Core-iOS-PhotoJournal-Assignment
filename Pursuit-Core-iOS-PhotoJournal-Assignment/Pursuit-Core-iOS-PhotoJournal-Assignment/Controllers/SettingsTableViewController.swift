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

class Color {
    var red:CGFloat
    var blue:CGFloat
    var green:CGFloat
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
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
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSliderMinMaXVal()
        if let colorsSaved = UserDefaults.standard.object(forKey: UserDefaultKeys.backgroundColor) as? [CGFloat] {
            view.backgroundColor = UIColor(displayP3Red: colorsSaved[0], green: colorsSaved[1], blue: colorsSaved[2], alpha: 1.0)
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
        view.backgroundColor = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
        
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
    
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
