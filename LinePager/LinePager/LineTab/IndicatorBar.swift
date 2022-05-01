//
//  IndicatorBar.swift
//  SOL-Plugin
//
//  Created by 60156672 on 2022/04/22.
//

import UIKit
import FlexLayout
import PinLayout

class IndicatorBar: UIView {
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let indicator = UIView().then {
        $0.backgroundColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(container)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.pin.all()
        container.flex.layout()
        
        configureLayout()
    }
    
    func configureLayout() {
        container.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define {
                $0.addItem(indicator).height(2)
            }
    }
}
