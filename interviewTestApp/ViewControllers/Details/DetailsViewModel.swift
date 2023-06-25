//
//  DetailsViewModel.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 25/06/23.
//

import Foundation

protocol DetailsViewModelProtocol: AnyObject {
    var selectedItem: Photo {get set}
    var author: String {get}
    var imageURL: String {get}
}

class DetailsViewModel: DetailsViewModelProtocol {
    internal var selectedItem: Photo
    
    init(selectedItem: Photo) {
        self.selectedItem = selectedItem
    }
    
    var author: String {
        return selectedItem.author ?? ""
    }
    
    var imageURL: String {
        return selectedItem.downloadURL ?? ""
    }
}
