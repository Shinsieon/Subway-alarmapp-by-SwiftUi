//
//  MapView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/22.
//

import SwiftUI
import MapKit

var mapInit = false
var hasSetRegion = false
struct MapView: View {
    @State public var manager = CLLocationManager()
    @StateObject public var managerDelegate = locationDelegate()
    @State var tracking : MapUserTrackingMode = .follow
    //서울 좌표(초기값)
    var body: some View {
        ZStack{
            Map(coordinateRegion: $managerDelegate.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: managerDelegate.pins){ pin in
                MapMarker(coordinate: pin.location.coordinate, tint: .red)
            }
                .frame(maxWidth: .infinity, maxHeight: 200)
            Image(systemName: "location.circle.fill")
                .onTapGesture{
                    managerDelegate.updateLocation()
                }
                .foregroundColor(Color("lineColor"))
                .font(.system(size : 30))
                .offset(x: 150, y: 70)
                .opacity(0.7)
                
        }
        .cornerRadius(15)
        .onAppear{
            manager.delegate = managerDelegate
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                managerDelegate.updateLocation()
            }
        }
        .onDisappear{
            //Timer.invalidate()
        }
    }
}

class locationDelegate : NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var pins : [Pin] = []
    @Published var location: CLLocation?
    
    @Published var region = locationInfo.get()
    
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus ==  .authorizedWhenInUse{
            manager.startUpdatingLocation()
        }else{
            manager.requestWhenInUseAuthorization()
        }
    }
    func updateLocation(){
        print("updating")
        region = MKCoordinateRegion(center : self.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        locationInfo.set(_loc : region)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation]) {
        if let location = locations.last {
            if mapInit == false {
                self.location = location
                updateLocation()
                mapInit.toggle()
            }
            if hasSetRegion == false{
                region = MKCoordinateRegion(center : location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                hasSetRegion = true
            }else{
                
            }
        }
        //pins.append(Pin(location:locations.last!))
    }
}
struct Pin : Identifiable {
    var id = UUID().uuidString
    var location : CLLocation
}

struct viewTitleButtonStyle : ButtonStyle{
    var labelColor = Color.white
    var backgroundColor = Color("lineColor")
      
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal,10)
            .padding(.vertical,5)
            .foregroundColor(labelColor)
            .background(Capsule().fill(backgroundColor))
            .font(.system(size: 15))
            .frame(width: 80,height:50)
            .offset(x: 0, y: -80)
            .opacity(0.7)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
