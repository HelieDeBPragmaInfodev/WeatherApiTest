//
//  ViewController.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 27/06/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let weatherViewModel = WeatherAPIViewModel()
    
    private var tableView: UITableView = UITableView()
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    private var isFetching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.loadStoredCities {[weak self] in
            guard let self else { return }
            self.setUpUI()
            self.setUpObservers()
            self.weatherViewModel.fetchWeatherDataForStoredLocalization()
        }
    }
    
    override func viewDidLayoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
    }
    
    fileprivate func setUpUI() {
        navigationItem.title = "Weather"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        view.addSubview(tableView)
        refreshControl.addTarget(self, action: #selector(fetchWeatherData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    fileprivate func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addCityViewControllerDisappeared), name: NSNotification.Name(rawValue:"AddCityViewControllerDisappeared"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: NSNotification.Name(rawValue:"NewCityWeatherUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoadingIndicator), name: NSNotification.Name(rawValue:"FetchAllCitiesWeatherDone"), object: nil)
    }
    
    @objc func addButtonTapped() {
        print("Add button tapped!")
        let modalViewController = AddCityViewController()
        modalViewController.citiesList = weatherViewModel.getListOfCitiesToAdd()
        let navigationController = UINavigationController(rootViewController: modalViewController)
        modalViewController.modalPresentationStyle = .overFullScreen
        modalViewController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true, completion: nil)
        
    }
    
    @objc func fetchWeatherData() {
        weatherViewModel.fetchWeatherDataForStoredLocalization()
    }
    
    @objc func addCityViewControllerDisappeared() {
        
        weatherViewModel.loadStoredCities { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.weatherViewModel.fetchWeatherDataForStoredLocalization()
        }
    }
    
    @objc func refreshTableView() {
        weatherViewModel.loadStoredCities { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func stopLoadingIndicator() {
        refreshControl.endRefreshing()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.citiesStored.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        cell.leftImageView.image = UIImage(named: weatherViewModel.citiesStored[indexPath.row].iconName ?? "--")
        cell.cityNameLabel.text = weatherViewModel.citiesStored[indexPath.row].name
        cell.descriptionLabel.text = weatherViewModel.citiesStored[indexPath.row].descriptionWeather ?? "--"
        cell.tempLabel.text = weatherViewModel.citiesStored[indexPath.row].temp ?? "--"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityToDelete = weatherViewModel.citiesStored[indexPath.row]
            weatherViewModel.deleteCity(city: cityToDelete) { [weak self] isDeleted in
                if isDeleted {
                    self?.weatherViewModel.citiesStored.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: To be continued ...
        let citySelected = weatherViewModel.citiesStored[indexPath.row]    }
    
}


