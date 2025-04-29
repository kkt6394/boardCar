//
//  ShareViewController.swift
//  kickBoardApp
//
//  Created by 김재우 on 4/28/25.
//

import UIKit
import NMapsMap
import SnapKit

class ShareViewController: UIViewController {
    
    let shareView = ShareView()

    override func loadView() {
        view = shareView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myView = NMFNaverMapView(frame: view.frame)
//                view.addSubview(myView)
        
        shareView.tableView.dataSource = self
        shareView.tableView.delegate = self
        shareView.tableView.register(ShareViewCell.self, forCellReuseIdentifier: "cell")
        shareView.tableView.rowHeight = 50
        
    }
    
}

extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShareViewCell
        return cell
    }
    
}


