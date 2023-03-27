//
//  MistLocationManager.swift
//  mistPOC
//
//  Created by Guru Narayanan on 24/03/23.
//

import Foundation
import MistSDK

class MistLocationManagerVM : NSObject,ObservableObject{
    let indoorLocationManager = IndoorLocationManager.sharedInstance(MistConstants.mistAccessToken)
    @Published var mistPoint : MistPoint?
    override init() {
        super.init()
        indoorLocationManager?.start(with: self)
    }
}


extension MistLocationManagerVM : IndoorLocationDelegate{
    func didUpdate(_ map: MistMap!) {
    }
    
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        mistPoint = relativeLocation
    }
    func didErrorOccur(with errorType: ErrorType, andMessage errorMessage: String!) {
        if(errorType ==  .noBeaconsDetected){
            mistPoint = nil
        }
    }
}
