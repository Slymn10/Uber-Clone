//
//  LocationCell.swift
//  Uber
//
//  Created by Süleyman Koçak on 12.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit
import MapKit
class LocationCell: UITableViewCell {
    static let cellID = "LocationCell"

    var placemark:MKPlacemark?{
        didSet{
            self.titleLabel.text = placemark?.name
            self.addressLabel.text = placemark?.address
        }
    }

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    private let addressLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        let stack = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical

        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
