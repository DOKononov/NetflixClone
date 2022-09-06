//
//  HeaderView.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 1.09.22.
//

import UIKit

class HeaderView: UIView {

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    private let gradient: CAGradientLayer = {
       let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        return gradient
    }()
    
    private let playButtom: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitleColor(UIColor.label, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupViews() {
        addSubview(imageView)
        layer.addSublayer(gradient)
        addSubview(playButtom)
        addSubview(downloadButton)
    }
    
    private func setupLayouts() {
        imageView.frame = bounds
        gradient.frame = bounds
        
        playButtom.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(100)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-70)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(100)
        }
    }
    


}
