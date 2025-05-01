//
//  RentVC.swift
//  kickBoardApp
//
//  Created by Lee on 4/28/25.
//
//
import Foundation
import UIKit
import NMapsMap


class RentVC: UIViewController {

    let rentView = RentView()

//    var locationManager = CLLocationManager()
//    let geoCoder = CLGeocoder()

    override func loadView() {
        view = rentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
