//
//  DashboardViewController.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var table_view:UITableView!
    var sizingCells:Dictionary<String,PersonListCell> = [:]
    var dataSource:[UserDetailFetchResult] = []
    var filteredDataSource:[UserDetailFetchResult] = []
    let searchController = UISearchController.init(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doRegistrations()
        self.setupNavBtns()
        self.prepareData()
        self.setupSearchController()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table_view.tableHeaderView = searchController.searchBar
        self.searchController.searchBar.delegate = self
    }
    
    func prepareData(){
        UserDetails.getRecordsAsResults { (_ results:[UserDetailFetchResult], _ error:Error?) in
            if let _ = error{
                
            }
            else{
                self.dataSource = results
                self.table_view.dataSource = self
                self.table_view.delegate = self
                self.table_view.reloadData()
            }
        }
    }
    
    func doRegistrations(){
        let cells = ["PersonListCell"]
        
        for cell in cells{
            let nib = UINib.init(nibName: cell, bundle: nil)
            self.table_view.register(nib, forCellReuseIdentifier: cell)
            sizingCells[cell] = nib.instantiate(withOwner: self, options: nil) [0] as? PersonListCell
        }
    }
    
    
    func getIdentifier(indexPath:IndexPath) -> String{
        return "PersonListCell"
    }
    
    func setupNavBtns(){
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 35))
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(DashboardViewController.addClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func addClick(sender:UIButton){
    /*    let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddViewController")
        self.navigationController?.pushViewController(controller, animated: true)
 */
    
        AddViewController.present(self, { (addController) in
            self.prepareData()
            }) { (addConroller) in
                
        }
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
extension DashboardViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let identifier = self.getIdentifier(indexPath: indexPath)
        let model = self.dataSource[indexPath.row]
        let sizing = sizingCells[identifier]
        sizing?.configure(result: model)
        let target = CGSize.init(width: UIScreen.main.bounds.width, height: 0.5 * UIScreen.main.bounds.width)

        let size = sizing?.preferredSizeFittingTargetSize(targetSize: target)
        return (size?.height)!
    }
}
extension DashboardViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && self.searchController.searchBar.text != ""{
            return self.filteredDataSource.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = self.getIdentifier(indexPath: indexPath)
        
        let cell = table_view.dequeueReusableCell(withIdentifier: identifier) as! PersonListCell
        var model = self.dataSource[indexPath.row]
        if self.searchController.isActive && self.searchController.searchBar.text != ""{
            model = self.filteredDataSource[indexPath.row]
        }
        cell.configure(result: model)
        return cell
    }
}
extension DashboardViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.filterDataSource(searchController.searchBar.text!)
    }
    
    func filterDataSource(_ searchText:String){
        self.filteredDataSource = self.dataSource.filter { (userFetchResult) -> Bool in
            if (userFetchResult.rawData.first?.userText.contains(searchText))!{
                return true
            }
            if userFetchResult.rawData.count > 1{
                if userFetchResult.rawData[1].userText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != ""{
                    if userFetchResult.rawData[1].userText.contains(searchText){
                        return true
                    }
                }
            }
            
            return false
        }
        self.table_view.reloadData()
    }
}
extension DashboardViewController:UISearchBarDelegate{
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.prepareData()
    }
}
