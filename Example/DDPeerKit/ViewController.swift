//
//  ViewController.swift
//  DDPeerKit
//
//  Created by duanchanghe@gmail.com on 12/10/2018.
//  Copyright (c) 2018 duanchanghe@gmail.com. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import DDPeerKit

class ViewController: UIViewController {

    let peer = DDPeerKit("DDChartRoom")

    @IBOutlet weak var tableView: UITableView!
    
    public var dataArr: [(MCPeerID,MCSessionState)] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = dataArr[indexPath.row].0.displayName
        var str = ""
        switch dataArr[indexPath.row].1 {
        case .notConnected:
            str = "未连接"
            break
        case .connecting:
            str = "连接中"
            break
        case .connected:
            str = "连接上"
        }
        cell.detailTextLabel?.text = str
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let p = dataArr[indexPath.row]
        switch p.1 {
        case .connected:
            _ = try? peer.session?.send(("mynameIsHamama".data(using: .utf8))!, toPeers: [p.0], with: .reliable)
            break
        case .connecting:
            break
        case .notConnected:
            peer.browser?.invitePeer(p.0, to: peer.session!, withContext: nil, timeout: 6)
            break
        }
    }
}


