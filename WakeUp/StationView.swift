//
//  StationView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/25.
//

import SwiftUI

struct StationView: View {
    @Environment(\.presentationMode)
        var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            Text("Settings Go Here")
            .navigationBarTitle("지하철역")
            .navigationBarItems(trailing: Button("닫기", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        StationView()
    }
}
