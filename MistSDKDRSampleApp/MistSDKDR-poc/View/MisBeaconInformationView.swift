import SwiftUI

struct MistBeaconInformationView: View {
    @ObservedObject var mistLocationManagerVM = MistLocationManagerVM()
    var body: some View {
        if(mistLocationManagerVM.mistPoint == nil)
        {
           Text("Could not detect beacon")
        }
        else{
            VStack(alignment: .leading,spacing : 3){
                Text("x : \(mistLocationManagerVM.mistPoint?.x ?? 0)")
                Text("y : \(mistLocationManagerVM.mistPoint?.y ?? 0)")
                Text("lat : \(mistLocationManagerVM.mistPoint?.lat ?? 0)")
                Text("lng : \(mistLocationManagerVM.mistPoint?.lon ?? 0)")
            }
        }
    }
}

struct MistBeaconInformationView_Previews: PreviewProvider {
    static var previews: some View {
        MistBeaconInformationView()
    }
}
