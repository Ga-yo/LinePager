//
//  LineTabCollectionViewCell.swift
//  SOL-Plugin
//
//  Created by 60156672 on 2022/04/22.
//

import UIKit
import FlexLayout
import PinLayout

final class LineTabCollectionViewCell: UICollectionViewCell {
    private let rootContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    private (set) var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .gray
    }
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.textColor = self.isSelected ? .black : .gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(rootContainer)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootContainer.pin.all()
        rootContainer.flex.layout()
    }
    
    func configureLayout() {
        rootContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define {
                $0.addItem(titleLabel)
            }
    }
}
