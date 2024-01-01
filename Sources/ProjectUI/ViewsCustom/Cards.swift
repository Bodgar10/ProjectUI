//
//  Cards.swift
//  
//
//  Created by Bodgar Espinosa Miranda on 26/12/23.
//

import UIKit

public struct CardData {
    var title: String
    var subtitle: String
    var backgroundColor: UIColor
}

public final class Cards: UIView {
    
    public private(set) lazy var titlelabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public private(set) lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public convenience init(viewData: CardData) {
        self.init(frame: .zero)
        configure(with: viewData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(with data: CardData) {
        backgroundColor = data.backgroundColor
        titlelabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
    private func setUpView() {
        layer.withCornerRadius(.medium)
        layer.masksToBounds = true
        layer.borderWidth = LineThickness.light.rawValue
        
        addSubview(verticalStackView)
        
    }
    
}
