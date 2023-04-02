import SwiftUI
import Kingfisher
///UI View to show the basic information of the MistPoint

struct MistBeaconInformationView: View {
    @ObservedObject var mistLocationManagerVM = MistLocationManagerVM()
    var body: some View {
        
        if let url = URL(string: mistLocationManagerVM.mistMap?.url ?? ""){
            ZStack(alignment: .center) {
                GeometryReader { geometry in
                    KFImage(url).resizable().aspectRatio(contentMode: .fill).onAppear(){
                        mistLocationManagerVM.scaleX = (geometry.size.width) / Double((mistLocationManagerVM.mistMap?.width ?? 0))
                        mistLocationManagerVM.scaleY = (geometry.size.height) / Double((mistLocationManagerVM.mistMap?.height ?? 0))
                    }
                }
                Image(systemName: "person.fill").resizable()
                    .frame(width: 20,height: 20)
                    .position(x : mistLocationManagerVM.mistPoint?.relativeX ?? 0,y: mistLocationManagerVM.mistPoint?.relativeY ?? 0)
                    .foregroundColor(Color.blue)
            }
        }
    }
   
}

struct MistBeaconInformationView_Previews: PreviewProvider {
    static var previews: some View {
        MistBeaconInformationView()
    }
}
