//
//  FilterTableViewController.swift
//  yelp
//
//  Created by christopher ketant on 10/22/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

protocol FilterSettingsDelegate: class {
    func searchWithFilters(sort: YelpSortMode?, categories: [String]?, deals: Bool?)
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: FilterSettingsDelegate?
    @IBOutlet weak var tableView: UITableView!
    var isDistanceExpanded: Bool = false
    var isSortExpanded: Bool = false
    var isAllCategories: Bool = false
    var isDeals: Bool?
    
    var distRowCount: Int = 1
    var sortRowCount: Int = 1
    var categoryRowCount: Int = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Filters"
        self.navigationItem.titleView = titleLabel
    }

    // MARK: Table view delegate + data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel: UILabel = UILabel()
        headerLabel.frame = CGRect(x: 10, y: headerLabel.frame.origin.y, width: headerLabel.frame.size.width, height: headerLabel.frame.size.height)
        headerLabel.textColor = UIColor.darkGray
        if section == 1{
            headerLabel.text =  " Distance"
        }else if section == 2{
            headerLabel.text = " Sort By"
        }else if section == 3{
            headerLabel.text = " Category"
        }else{
            return nil
        }
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return self.distRowCount
        }else if section == 2{
            return self.sortRowCount
        }else if section == 3{
            return self.categoryRowCount
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleSwitch", for: indexPath) as! SimpleSwitchTableViewCell
            cell.switchLabel.text = "Offering a Deal"
            cell.filterSwitch.tag = 100
        }else if indexPath.section == 1{
            if self.isDistanceExpanded {
                let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! SelectOptionTableViewCell
                if indexPath.row == 0{
                    // selected option
                    cell.optionLabel.text = "Auto"
                }else if indexPath.row == 1{
                    cell.optionLabel.text = "0.3"
                }else if indexPath.row == 2{
                    cell.optionLabel.text = "1"
                }else if indexPath.row == 3{
                    cell.optionLabel.text = "5"
                }else if indexPath.row == 4{
                    cell.optionLabel.text = "20"
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chevron", for: indexPath) as! ChevronOptionTableViewCell
                cell.chevronLabel.text = "Auto"
                return cell
            }
        }else if indexPath.section == 2{
            if self.isSortExpanded{
                let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! SelectOptionTableViewCell
                if indexPath.row == 0{
                    // selected option
                    cell.optionLabel.text = "Auto"
                }else if indexPath.row == 1{
                    cell.optionLabel.text = "0.3"
                }else if indexPath.row == 2{
                    cell.optionLabel.text = "1"
                }else if indexPath.row == 3{
                    cell.optionLabel.text = "5"
                }else if indexPath.row == 4{
                    cell.optionLabel.text = "20"
                }
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chevron", for: indexPath) as! ChevronOptionTableViewCell
                cell.chevronLabel.text = "Best Match"
                return cell
            }
        }else if indexPath.section == 3{
            if indexPath.row == self.categoryRowCount-1 && !self.isAllCategories{
                let cell = tableView.dequeueReusableCell(withIdentifier: "all", for: indexPath) as! AllTableViewCell
                cell.tag = 999
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "simpleSwitch", for: indexPath) as! SimpleSwitchTableViewCell
                cell.switchLabel.text = Categories.categories[indexPath.row]["name"]
                cell.tag = (indexPath.row + 400)
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "simpleSwitch", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1{
            self.isDistanceExpanded = !self.isDistanceExpanded
            if self.isDistanceExpanded {
                self.distRowCount = 5
                self.insertDistRows(expanded: true)
            }else{
                self.distRowCount = 1
                self.insertDistRows(expanded: false)
            }

        }else if indexPath.section == 2{
            self.isSortExpanded = !self.isSortExpanded
            if self.isSortExpanded {
                self.sortRowCount = 4
                self.insertSortRows(expanded: true)
            }else{
                self.sortRowCount = 1
                self.insertSortRows(expanded: false)
            }
        }else if indexPath.section == 3{
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.tag == 999 {
                self.categoryRowCount = Categories.categories.count
                self.isAllCategories = true
                insertCategoryRows()
            }
        }
    }
    
    // Mark: Utils
    
    fileprivate func insertDistRows(expanded: Bool) {
        var insertArr: [IndexPath]!
        var delArr: [IndexPath]!
        if expanded {
            insertArr = [IndexPath(row: 0, section: 1),
                       IndexPath(row: 1, section: 1),
                       IndexPath(row: 2, section: 1),
                       IndexPath(row: 3, section: 1),
                       IndexPath(row: 4, section: 1)
            ]
            delArr = [IndexPath(row: 0, section: 1)]
        } else {
            delArr = [IndexPath(row: 0, section: 1),
                         IndexPath(row: 1, section: 1),
                         IndexPath(row: 2, section: 1),
                         IndexPath(row: 3, section: 1),
                         IndexPath(row: 4, section: 1)
            ]
            insertArr = [IndexPath(row: 0, section: 1)]
        }
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: delArr, with: .automatic)
        self.tableView.insertRows(at: insertArr, with: .automatic)
        self.tableView.endUpdates()
        
    }
    
    fileprivate func insertSortRows(expanded: Bool) {
        var insertArr: [IndexPath]!
        var delArr: [IndexPath]!
        if expanded {
            insertArr = [IndexPath(row: 0, section: 2),
                                          IndexPath(row: 1, section: 2),
                                          IndexPath(row: 2, section: 2),
                                          IndexPath(row: 3, section: 2),
            ]
            delArr = [IndexPath(row: 0, section: 2)]
        }else{
            delArr = [IndexPath(row: 0, section: 2),
                         IndexPath(row: 1, section: 2),
                         IndexPath(row: 2, section: 2),
                         IndexPath(row: 3, section: 2),
            ]
            insertArr = [IndexPath(row: 0, section: 2)]
        }
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: delArr, with: .automatic)
        self.tableView.insertRows(at: insertArr, with: .automatic)
        self.tableView.endUpdates()
    }
    
    fileprivate func insertCategoryRows(){
        var insertArr = [IndexPath]()
        var delArr = [IndexPath]()
        for i in (0..<Categories.categories.count){
            insertArr.append(IndexPath(row: i, section: 3))
        }
        delArr = [IndexPath(row: 0, section: 3),
                  IndexPath(row: 1, section: 3),
                  IndexPath(row: 2, section: 3),
                  IndexPath(row: 3, section: 3),
        ]
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: delArr, with: .automatic)
        self.tableView.insertRows(at: insertArr, with: .automatic)
        self.tableView.endUpdates()
    }
    
    // Mark: Actions
    
    @IBAction func cancel(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func search(sender: UIBarButtonItem){
        delegate?.searchWithFilters(sort: nil, categories: nil, deals: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchChange(sender: UISwitch){
        if sender.tag == 100 {
            self.isDeals = sender.isOn
        }
    }
}
