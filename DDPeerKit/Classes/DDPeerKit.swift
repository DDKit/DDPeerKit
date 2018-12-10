//
//  DDPeerKit.swift
//  DDChartRoom
//
//  Created by 风荷举 on 2018/11/28.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import MultipeerConnectivity

public class DDPeerKit: NSObject
{
    var peerID: MCPeerID!
    
    private var serviceType: String = "dd_my_peerKit"
    
    public var advertiser: MCNearbyServiceAdvertiser?
    
    public var session: MCSession?
    
    public var browser: MCNearbyServiceBrowser?
    
    private var searchedPeerIDs: [(_:MCPeerID,_:MCSessionState)] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.searchListChange?(self!.searchedPeerIDs)
            }
        }
    }
    
    public var searchListChange: (([(_:MCPeerID,_:MCSessionState)])->Void)?
    
    public var receiveData: ((_ : MCSession, _ : Data, _ : MCPeerID)->Void)?
    
    public var receiveStream: ((_ : MCSession, _ : InputStream, _ : String, _ : MCPeerID)->Void)?
    
    public var startReceivingResource: ((_ : MCSession, _ : String, _ : MCPeerID, _ : Progress)->Void)?
    
    public var finishReceivingResource: ((_ : MCSession, _ : String, _ : MCPeerID, _ : URL?, _ : Error?)->Void)?
    
    public init(_ serviceid: String, name: String? = nil) {
        peerID = MCPeerID(displayName: name ?? UIDevice.current.name)
        serviceType = serviceid
        isStart = true
    }
    
    public var isStart: Bool = false {
        didSet {
            if advertiser == nil {
                advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                       discoveryInfo: nil,
                                                       serviceType: serviceType)
                advertiser?.delegate = self
            }
            
            if browser == nil {
                browser = MCNearbyServiceBrowser(peer: peerID,
                                                 serviceType: serviceType)
                browser?.delegate = self
            }
            
            if session == nil {
                session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
                session?.delegate = self
            }
            
            if isStart {
                browser?.startBrowsingForPeers()
                advertiser?.startAdvertisingPeer()
            } else {
                browser?.stopBrowsingForPeers()
                advertiser?.stopAdvertisingPeer()
            }
        }
    }
}



extension DDPeerKit: MCNearbyServiceAdvertiserDelegate
{
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session!)
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(#function)
        print("\(advertiser)")
        print("\(error)")
    }
}

extension DDPeerKit: MCSessionDelegate
{
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        searchedPeerIDs = searchedPeerIDs.map({
            if $0.0 == peerID { return (peerID,state)  }
            return $0
        })
    }
    
    // 接受 Data 数据
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receiveData?(session,data,peerID)
    }
    
    // 数据 字节流
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        receiveStream?(session,stream,streamName,peerID)
    }
    
    // 接受文件 开始
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        startReceivingResource?(session,resourceName,peerID,progress)
    }
    
    // 接受文件 结束
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        finishReceivingResource?(session,resourceName,peerID,localURL,error)
    }

}

extension DDPeerKit: MCNearbyServiceBrowserDelegate
{
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if searchedPeerIDs.map({$0.0 == peerID}).count == 0 {
            searchedPeerIDs.append((peerID,.notConnected))
        }
        DispatchQueue.main.async { [weak self] in
            self!.searchListChange?(self!.searchedPeerIDs)
        }
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        searchedPeerIDs = searchedPeerIDs.filter({$0.0 != peerID})
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(#function)
        print("\(browser)")
        print("\(error)")
    }
}

