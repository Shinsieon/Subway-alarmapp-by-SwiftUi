//
//  WaitingView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/26.
//

import SwiftUI
import MapKit
import AVFoundation

struct WaitingView: View {
    @State var isAnimating: Bool = true
    @State var distance : Double = 0.0
    @State var isArrived = false
    @State var isAlarmOn = false
    @ObservedObject var selectedStation: selectedStationVM
    @State var selectedDistance : String
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 300)
                .foregroundColor(Color.blue.opacity(0.3))
                .blur(radius: 10)
                .offset(x: -100, y : -150)
            Circle()
                .frame(width: 400)
                .foregroundColor(Color("lineColor").opacity(0.3))
                .blur(radius: 10)
                .offset(x: -50, y: 100)
            RoundedRectangle(cornerRadius: 30, style : .continuous)
                .frame(width: 500, height: 500)
                .foregroundStyle(LinearGradient(colors : [.purple, .mint], startPoint: .top, endPoint: .leading))
                .offset(x : 300)
                .opacity(0.5)
                .blur(radius : 30)
                .rotationEffect(.degrees(30))
            
            Circle()
                .stroke(Color.black.opacity(0.4), lineWidth: 10)
                .frame(width: 260, height: 260, alignment: .center)
                //.offset(x : isAnimating ? 0 : -UIScreen.main.bounds.size.width)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses:true)
                    , value: 1)
            VStack{
                if(selectedStation.get().count>0){
                    Text("\(selectedStation.get()[0].name)역까지")
                    Text("\(String(format: "%.3f", distance)) km 남았습니다")
                    
                    Text(isArrived ? "\(selectedDistance) 전에 깨워드릴게요" : "asd")
                            .font(.system(size:15))
                            .foregroundColor(Color("lineColor"))
                            .onReceive(timer) { _ in
                                if(isAlarmOn == true){
                                    AudioServicesPlaySystemSound(SystemSoundID(1322))
                                }
                            }
                    }
                    Button("중지" , action : {
                        self.isAlarmOn = false
                    })
                }else{
                    Text("목적지 정보가 \n     없습니다")
                        .font(.system(size: 30, weight: .heavy))
                        .frame(alignment: .center)
                }
            }
            .font(.system(size: 20))
        }
        .onAppear{
            calcDistance()
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                if(isArrived == false && isAlarmOn == false){
                    calcDistance()
                }
            }
        }
    }
    func calcDistance(){
        if(selectedStation.get().count>0){
            let curLocation = CLLocationCoordinate2D(latitude: locationInfo.get().center.latitude, longitude: locationInfo.get().center.longitude)
            let desLocation = CLLocationCoordinate2D(latitude: selectedStation.get()[0].lat, longitude: selectedStation.get()[0].lng)
            
            distance = Double(curLocation.distance(to : desLocation)/1000)
            
            var selDistance =  selectedDistance.replacingOccurrences(of: "km", with: "")
            selDistance = selDistance.replacingOccurrences(of: "m", with: "")
            var DselDistance = Double(selDistance)!
            if(DselDistance > 1.5) {
                DselDistance = DselDistance/1000
            }
            if(distance <= DselDistance){
                isArrived = true
                isAlarmOn = true
            }
        }
    }
}
class HapticManager {
    
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
extension CLLocationCoordinate2D {
    /// Returns the distance between two coordinates in meters.
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }
    
}
struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        let selStation = selectedStationVM()
        let selectedDistance = "100m"
        WaitingView(selectedStation: selStation, selectedDistance: selectedDistance)
    }
}
