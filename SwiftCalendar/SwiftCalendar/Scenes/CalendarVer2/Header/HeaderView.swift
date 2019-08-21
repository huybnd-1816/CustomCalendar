//
//  HeaderView.swift
//  SwiftCalendar
//
//  Created by nguyen.duc.huyb on 8/21/19.
//  Copyright © 2019 Sameer Poudel. All rights reserved.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    var didTapLeftButton: (() -> Void)?
    var didTapRightButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configHeaderView(_ title: String) {
        titleLabel.text = title
    }
    
    @IBAction private func handleLeftButtonTapped(_ sender: Any) {
        didTapLeftButton?()
    }
    
    @IBAction private func handleRightButtonTapped(_ sender: Any) {
        didTapRightButton?()
    }
}
