//
//  AppListViewController.swift
//  AppStore
//
//  Created by paytalab on 9/12/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Alamofire

class AppListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        let network = AppNetwork(manager: NetworkManager())
        let query = "카카오"
        
        Task {
            let result = await network.fetchAppList(term: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                                                    limit: 20)
            print(result)
        }
        
        Task {
            let result = await network.fetchAppDetail(id: 362057947)
            print(result)
        }
    }


}

