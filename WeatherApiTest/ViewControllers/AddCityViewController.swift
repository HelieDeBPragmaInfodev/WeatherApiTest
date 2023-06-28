//
//  AddCityViewController.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 27/06/2023.
//

import Foundation
import UIKit

class AddCityViewController: UIViewController {
    
    private let addCityViewModel = AddCityViewModel()
    
    var citiesList: [City] = []
    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
    }
    
    fileprivate func setUpUI () {
        title = "Add a City"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
}

extension AddCityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = citiesList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citySelected = citiesList[indexPath.row]
        addCityViewModel.saveNewCity(city: citySelected) {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("AddCityViewControllerDisappeared"), object: nil)
                
            }
        }
    }
}
