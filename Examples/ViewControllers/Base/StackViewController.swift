//
//  StackViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 14/03/2024.
//

import UIKit

class StackViewController: UIViewController {
    
    var row: MenuViewController.Row!
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        stackView.backgroundColor = .systemGroupedBackground
        title = row.label
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
