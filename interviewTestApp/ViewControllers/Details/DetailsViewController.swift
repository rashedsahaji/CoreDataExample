//
//  DetailsViewController.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 25/06/23.
//

import UIKit

protocol DetailsViewControllerProtocol: UIViewController {
    var viewModel: DetailsViewModelProtocol! {get set}
}

class DetailsViewController: UIViewController, DetailsViewControllerProtocol {
    
    internal var viewModel: DetailsViewModelProtocol!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        // Bind the UI elements to the view model properties
        authorLabel.text = viewModel.author
        urlLabel.text = viewModel.imageURL
        
        
        // Load the image from cache or download it
        imageView.setImage(with: viewModel.imageURL)
    }
    
    class func configure(viewModel: DetailsViewModelProtocol) -> DetailsViewControllerProtocol {
        let detailVC = StoryBoards.main.instanceOf(viewController: DetailsViewController.self)!
        detailVC.viewModel = viewModel
        return detailVC
    }
}
