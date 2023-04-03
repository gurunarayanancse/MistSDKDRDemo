//
//  MistLocationManager.swift
//  mistPOC
//
//  Created by Guru Narayanan on 24/03/23.
//

import Foundation
import MistSDK

/// Class (ViewModel) to provide a service to detect and handle indoorLocationManager Class
///```
/// Steps:
/// 1. indoorLocationManager.
/// 2. Ask for the permission and check the status.
///     2.1 if permission granted we are good to go.
///     2.2 otherwise Open settings and ask the permission.
/// 3. Assign a deligate.
/// 4. Start a scanning process with start()
/// 4. implement didUpdateRelativeLocation.
///     1. asign that to publishable variable mistPoint so that the class using this ViewModel can access it.
/// 5. stop scanning when ever needed.
/// (Refer documentation for the further details)
///```
class MistLocationManagerVM : NSObject,ObservableObject{
    private let indoorLocationManager = IndoorLocationManager.sharedInstance(MistConstants.mistAccessToken)
    
    @Published var mistPoint : BeaconRelativePosition?
    @Published var mistMap : MistMap?
    
    var scaleX : Double = 1
    var scaleY : Double = 1
   
    override init() {
        super.init()
        indoorLocationManager?.start(with: self)
    }
    
    /// This metod Stops the Scanning process
    ///```
    /// Examle:
    /// 1. indoorLocationManager.
    /// 2. obj.stopScanning()
    ///```
    func stopScanning(){
        indoorLocationManager?.stop()
    }
    
    deinit{
        stopScanning()
    }
}


///delegate implementaion
extension MistLocationManagerVM : IndoorLocationDelegate{
    /// will get called when the map is changes while we move from one floor to another.
    func didUpdate(_ map: MistMap!) {
        mistMap = map
    }
    
    /// will get called when the current location of the device gets updated it will return Mistpoint, with this one we can derive all the requied information like spatial coordinates, latitude and longidue and more.
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        
        // Multiply x y coordinate with ppm and its scaleFactors, it will give the valid xy in pixels to be plotted on screen.
        let xWithPPM = relativeLocation.x * (mistMap?.ppm ?? 0) * scaleX
        let yWithPPM = relativeLocation.y * (mistMap?.ppm ?? 0) * scaleY
        
        mistPoint = BeaconRelativePosition(relativeX: xWithPPM, relativeY: yWithPPM)
    }
    
    /// it will get called when there is an error occured. - it is optional one
    func didErrorOccur(with errorType: ErrorType, andMessage errorMessage: String!) {
        if(errorType ==  .noBeaconsDetected){
            mistPoint = nil
        }
    }
    
    // it will get called when we recieved an organization information as a part of authendication via access token
    func didReceivedOrgInfo(withTokenName tokenName: String!, andOrgID orgID: String!) {
        
    }
}
