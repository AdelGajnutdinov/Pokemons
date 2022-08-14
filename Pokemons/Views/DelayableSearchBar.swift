//
//  DelayableSearchBar.swift
//  Pokemons
//
//  Created by Adel Gainutdinov on 14.08.2022.
//

import UIKit

protocol DelayableSearchBarDelegate {
    func search(with searchText: String?)
}

class DelayableSearchBar: UISearchBar {
    
    var delayDelegate: DelayableSearchBarDelegate?
    
    private var actionDelay: Double = 0.5
    
    private var timer: Timer?
    
    init() {
        super.init(frame: CGRect.zero)
        delegate = self
        searchTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldEditingChanged() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: actionDelay, target: self, selector: #selector(executeAction), userInfo: nil, repeats: false)
    }

    @objc private func executeAction() {
        delayDelegate?.search(with: self.text)
    }
    
    private func endEditing() {
        self.setShowsCancelButton(false, animated: true)
        self.timer?.invalidate()
        self.resignFirstResponder()
    }
}

extension DelayableSearchBar: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.setShowsCancelButton(true, animated: true)
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: actionDelay, target: self, selector: #selector(executeAction), userInfo: nil, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing()
    }
}

extension DelayableSearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing()
        self.executeAction()
        return true
    }
}
