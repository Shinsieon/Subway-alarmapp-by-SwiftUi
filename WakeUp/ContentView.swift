//
//  ContentView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/22.
//

import SwiftUI

struct ContentView: View {
    @State private var splashShow : Bool = true
    var body: some View {
        ZStack{
            VStack{
                ZStack(alignment: .leading){
                    MapView()
                    Button("현재 위치",action:{})
                        .buttonStyle(viewTitleButtonStyle())
                }
                
            }
            .padding()
            
//            if(splashShow){
//                Color.black
//            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                splashShow.toggle()
            })
        }
        .ignoresSafeArea(.all)
    }
}

struct viewTitleButtonStyle : ButtonStyle{
    var labelColor = Color.white
    var backgroundColor = Color("viewTitleButtonColor")
      
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal,10)
            .padding(.vertical,5)
            .foregroundColor(labelColor)
            .background(Capsule().fill(backgroundColor))
            .font(.system(size: 15))
            .frame(width: 80,height:50)
            .offset(x: 0, y: -80)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
