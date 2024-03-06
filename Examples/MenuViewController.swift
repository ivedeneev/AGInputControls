//
//  MenuViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 05/03/2024.
//

import UIKit

final class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AGInputControls"
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Row(rawValue: indexPath.row)?.label
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row(rawValue: indexPath.row)!
        let vc = row.viewControllerClass.init()
        vc.row = row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    enum Row: Int, CaseIterable {
        case phone
        case otp
        case floatingLabel
        case formatting
        case padding
        
        var label: String {
            switch self {
            case .phone:
                "PhoneTextField"
            case .otp:
                "OTPTextField"
            case .floatingLabel:
                "FloatingLabelTextField"
            case .formatting:
                "FormattingTextField"
            case .padding:
                "PaddingTextField"
            }
        }
        
        var viewControllerClass: StackViewController.Type {
            switch self {
            case .phone:
                PhoneFieldViewController.self
            case .otp:
                StackViewController.self
            case .floatingLabel:
                FloatingLabelViewController.self
            case .formatting:
                StackViewController.self
            case .padding:
                StackViewController.self
            }
        }
    }
}
