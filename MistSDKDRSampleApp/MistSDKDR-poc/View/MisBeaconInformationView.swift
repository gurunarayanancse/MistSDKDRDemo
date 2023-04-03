import SwiftUI
import Kingfisher
///UI View to show the basic information of the MistPoint

struct MistBeaconInformationView: View {
    @ObservedObject var mistLocationManagerVM = MistLocationManagerVM()
    var body: some View {
        /// ```
        /// gets the URL from the MistMap object and safeky unwrap it
        /// Loads the image and make the content mode as fit
        /// Marks the postion in the map view
        ///```
        if let url = URL(string: mistLocationManagerVM.mistMap?.url ?? ""){
            GeometryReader { geometry in
                ZStack(alignment: .topLeading){
                    KFImage(url).resizable().aspectRatio(contentMode: .fit).onAppear{
                        updateRenderedMapscreen(geometry: geometry)
                    }.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        updateRenderedMapscreen(geometry: geometry)
                    }
                    Image(systemName: "person.fill")
                        .position(x : mistLocationManagerVM.mistPoint?.relativeX ?? 0,y: mistLocationManagerVM.mistPoint?.relativeY ?? 0)
                        .foregroundColor(Color.blue)
                }
                
            }
        }
    }
    
    func updateRenderedMapscreen(geometry : GeometryProxy){
        
        // get the ratio of screen and map
        let screenRatio = Double(geometry.size.width) / Double(geometry.size.height)
        let mapRatio = Double(mistLocationManagerVM.mistMap?.width ?? 0) / Double(mistLocationManagerVM.mistMap?.height ?? 0)
        
        var mapWidthOnScreen : Double = 0
        var mapHeightOnScreen : Double = 0
        
        // If map ratio is grater than the screen ratio, it should be scaled down other wise it can able to view as full mapview
        // Need to add the Edge case where out mapview is not scaled up when the screensize gets larger than image
        if mapRatio > screenRatio{
            mapWidthOnScreen = geometry.size.width
            mapHeightOnScreen = screenRatio *  Double((mistLocationManagerVM.mistMap?.height ?? 0))
        }
        else{
            mapWidthOnScreen = Double(mistLocationManagerVM.mistMap?.width ?? 0) + 25 // this 20 i added for temporary fix, it is not a correct way, need to look on it
            mapHeightOnScreen = Double(mistLocationManagerVM.mistMap?.height ?? 0)
        }
        
        //assign the scale factor to View model, so that our View model will give us the exact position to mark the userIcon in the map.
        mistLocationManagerVM.scaleX = (mapWidthOnScreen) / Double(mistLocationManagerVM.mistMap?.width ?? 0)
        mistLocationManagerVM.scaleY = mapHeightOnScreen / Double(mistLocationManagerVM.mistMap?.height ?? 0)
    }
}

struct MistBeaconInformationView_Previews: PreviewProvider {
    static var previews: some View {
        MistBeaconInformationView()
    }
}
