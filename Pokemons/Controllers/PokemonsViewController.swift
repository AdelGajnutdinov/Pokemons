//
//  PokemonsViewController.swift
//  Pokemons
//
//  Created by Adel Gainutdinov on 14.08.2022.
//
import UIKit
import SnapKit

class PokemonsViewController: UIViewController {
    
    private var dataFetcher: DataFetcher!
    
    private var pokemons: [Pokemon]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var filteredPokemons: [Pokemon]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var isSearching = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var searchBar: DelayableSearchBar = {
        let searchBar = DelayableSearchBar()
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search"
        return searchBar
    }()
    
    private lazy var placeholderView = UIView(frame: CGRect(x: tableView.center.x, y: tableView.center.y, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    
    private lazy var placeholderTitleLabel: UILabel = UILabel()
    
    private lazy var placeholderMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var placeholderActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataFetcher = NetworkDataFetcher()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.cellIdentifier)
        
        searchBar.delayDelegate = self
        
        setupViews()
        setupConstraints()
        
        listAll()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.backgroundView = placeholderView
        placeholderView.addSubview(placeholderActivityIndicator)
        placeholderView.addSubview(placeholderTitleLabel)
        placeholderView.addSubview(placeholderMessageLabel)
        navigationItem.titleView = searchBar
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        placeholderActivityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(placeholderView)
            make.centerY.equalTo(placeholderView).offset(-self.view.bounds.height / 3.5)
        }
        placeholderTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(placeholderView)
            make.top.equalTo(placeholderActivityIndicator.snp.bottom).offset(16)
        }
        placeholderMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(placeholderView)
            make.top.equalTo(placeholderTitleLabel.snp.bottom).offset(16)
        }
    }
    
    private func setPlaceholderView(title: String, message: String) {
        placeholderTitleLabel.text = title
        placeholderMessageLabel.text = message
        tableView.backgroundView = placeholderView
    }
    
    private func removePlaceholderView() {
        tableView.backgroundView = nil
    }
    
    private func listAll() {
        let title = Constants.Text.searchInProgress
        let message = ""
        self.setPlaceholderView(title: title, message: message)
        placeholderActivityIndicator.startAnimating()
        
        dataFetcher.fetchPokemons() { [weak self] pokemons in
            sleep(1)
            self?.placeholderActivityIndicator.stopAnimating()
            self?.pokemons = pokemons
        }
    }
}

extension PokemonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentPokemons = !isSearching ? pokemons : filteredPokemons
        let pokemonsCount = currentPokemons?.count ?? 0
        return pokemonsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.cellIdentifier, for: indexPath) as? PokemonTableViewCell
        let currentPokemons = !isSearching ? pokemons : filteredPokemons
        cell?.pokemon = currentPokemons?[indexPath.row]
        return cell ?? UITableViewCell()
    }
}

extension PokemonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentPokemons = !isSearching ? pokemons : filteredPokemons
        
        guard let name = currentPokemons?[indexPath.row].name else { return }
        
        let alert = UIAlertController(title: Constants.Text.selectedTitle, message: name, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] action in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

extension PokemonsViewController: DelayableSearchBarDelegate {
    internal func search(with searchText: String?) {
        
        guard let searchText = searchText, !searchText.isEmpty else {
            isSearching = false
            self.tableView.reloadData()
            return
        }
        isSearching = true
        filteredPokemons = pokemons?.filter { $0.name.starts(with: searchText.lowercased()) }
        
        if filteredPokemons?.count == 0 {
            self.setPlaceholderView(title: Constants.Text.notFoundTitle,
                                    message: Constants.Text.notFoundMessage)
        }
        else {
            self.removePlaceholderView()
        }
    }
}
