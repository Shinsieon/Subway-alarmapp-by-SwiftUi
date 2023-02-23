//
//  ContentView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/22.
//

import SwiftUI

struct ContentView: View {
    @State private var splashShow : Bool = true
    @State private var fadeIn = false
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                    Text("안녕하세요 시언님. 어디로 가시나요?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 35, weight: .heavy))
                        .onAppear(){
                            withAnimation(.easeIn(duration: 1)){
                                fadeIn.toggle()
                            }
                        }
                        .opacity(fadeIn ? 1 : 0)
                    ZStack(alignment: .leading){
                        MapView()
                        Button("현재 위치",action:{})
                            .buttonStyle(viewTitleButtonStyle())
                    }
                    HStack{
                        Button("도착역을 지정해주세요", action:{})
                            .buttonStyle(inputButtonStyle())
                            .overlay(Image(systemName: "train.side.front.car")
                                .font(.system(size:25))
                                .foregroundColor(Color.white)
                                .padding(.horizontal,30) ,alignment: .leading)
                    }
                    .padding()
                    Spacer()
//                    Button("시작", action:{})
//                        .buttonStyle(startButtonStyle())
                }
                .padding()
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: 200)
    //            if(splashShow){
    //                Color.black
    //            }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                    splashShow.toggle()
                })
            }
            .ignoresSafeArea(.all)
            
        }
        
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
            .opacity(0.8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct inputButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .frame(width: 300, height: 50)
            .font(.system(size:20,weight: .heavy))
            .background(Color("viewTitleButtonColor"))
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding(.horizontal,20)
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
//                    .overlay(Rectangle()
//                        .frame(height:4)
//                        .foregroundColor(Color("lineColor"))
//                             ,alignment: .bottom)
    }
}

struct startButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size : 20))
            .frame(width: 50, height: 50)
            .fontWeight(.bold)
            .foregroundStyle(LinearGradient(colors : [.blue, .indigo], startPoint: .top,endPoint: .bottom))
            .padding()
            .scaleEffect(configuration.isPressed ? 0.9:1)
            .background(.ultraThinMaterial, in : RoundedRectangle(cornerRadius: 25, style: .continuous))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
