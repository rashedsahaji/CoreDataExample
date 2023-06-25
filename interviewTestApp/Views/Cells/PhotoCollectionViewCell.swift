//
//  PhotoCollectionViewCell.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "PhotoCollectionViewCell"
    
    //MARK: - View Property
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = UIColor(white: 0, alpha: 0.4)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(authorLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with photo: Photo) {
        imageView.setImage(with: photo.downloadURL ?? "")
        authorLabel.text = photo.author ?? ""
    }
    
}
