//
//  MapView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    //서울 좌표(초기값)
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    var body: some View {
        VStack{
            Map(coordinateRegion: $region)
                .frame(maxWidth: .infinity, maxHeight: 200)
                
        }
        .cornerRadius(15)
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
