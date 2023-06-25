//
//  StoryBoardHelper.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 25/06/23.
//

import Foundation
import UIKit

enum StoryBoards: String {
    case main = "Main"
    
  private var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func instanceOf<T: UIViewController>(viewController: T.Type) -> T? {
       let x = String(describing: viewController.self)
        let vc = instance.instantiateViewController(withIdentifier: x) as? T
        vc?.modalPresentationStyle = .fullScreen
        return vc
    }
}
