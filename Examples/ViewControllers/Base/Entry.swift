//
//  Entry.swift
//  Examples
//
//  Created by Igor Vedeneev on 14/03/2024.
//

import UIKit

final class Entry: UIView {
    
    let title: String
    let view: UIView
    let needsTrailingConstraint: Bool
    let height: CGFloat?
    
    init(title: String, targetView: UIView, needsTrailingConstraint: Bool = false, height: CGFloat? = nil) {
        self.title = title
        self.view = targetView
        self.needsTrailingConstraint = needsTrailingConstraint
        self.height = height
        super.init(frame: .zero)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if needsTrailingConstraint {
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
