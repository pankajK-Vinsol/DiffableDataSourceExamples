//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Pankaj kumar on 19/04/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    @IBOutlet weak var tableView: UITableView!
    var countries: [Country] = []
    var dataSource: UITableViewDiffableDataSource<Section, Country>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryNames = ["Afghanistan",
                            "Albania",
                            "Algeria",
                            "Andorra",
                            "Angola",
                            "Antigua and Barbuda",
                            "Argentina",
                            "Armenia",
                            "Australia",
                            "Austria",
                            "Azerbaijan",
                            "Bahamas",
                            "Bahrain",
                            "Bangladesh",
                            "Barbados",
                            "Belarus"]
        for name in countryNames {
            countries.append(Country(name: name))
        }
        
        dataSource = UITableViewDiffableDataSource
            <Section, Country>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath,
                country: Country) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = country.name
                return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        performSearch(searchQuery: nil)
    }
    
    func performSearch(searchQuery: String?) {
        let filteredCountries: [Country]
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            filteredCountries = countries.filter { $0.contains(query: searchQuery) }
        } else {
            filteredCountries = countries
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCountries, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CountryListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchQuery: searchText)
    }
}
