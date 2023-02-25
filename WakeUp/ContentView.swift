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
    @State private var selectedTime : String = "5분"
    @State private var selectedType : String = "소리"
    @State private var showStations = false
    @ObservedObject var selectedStation = selectedStationVM()
    @State private var selectedStationText = "도착역을 지정해주세요"
    var timeArray = ["5분","10분","15분","20분","25분","30분"]
    var alertTypeArray = ["소리", "진동"]
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                VStack{
                    Spacer()
                        .frame(height:100)
                    Text("안녕하세요 시언님. 어디로 가시나요?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 35, weight: .heavy))
                        .onAppear(){
                            withAnimation(.easeIn(duration: 1)){
                                fadeIn.toggle()
                            }
                        }
                        .opacity(fadeIn ? 1 : 0)
                    MapView()
                    HStack{
                        Button(selectedStationText, action:{self.showStations.toggle()})
                            .buttonStyle(inputButtonStyle())
                            .overlay(Image(systemName: "train.side.front.car")
                                .font(.system(size:25))
                                .foregroundColor(Color.white)
                                .padding(.horizontal,30) ,alignment: .leading)
                    }
                    .padding()
                    VStack{
                        Text("도착 몇 분 전에 깨워드릴까요?")
                            .font(.system(size: 25, weight: .heavy))
                        Picker("Choose a time", selection: $selectedTime){
                            ForEach(timeArray, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        Text("거리에 따른 시간을 계산하므로 실제 시간과는 차이가 있을 수 있습니다.")
                            .font(.system(size:12))
                            .foregroundColor(Color("lineColor"))
                        
                        Text("어떻게 깨워드릴까요?")
                            .font(.system(size: 25, weight: .heavy))
                            .padding()
                        Picker("choose alert type", selection: $selectedType){
                            ForEach(alertTypeArray, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Spacer()
                    Button("시작", action:{})
                        .buttonStyle(startButtonStyle())
                        .padding()
                    Spacer()
                }
                .padding()
                
                .sheet(isPresented: $showStations, onDismiss: {
                    if selectedStation.get().count>0 {
                        self.selectedStationText = selectedStation.get()[0].name
//                        self.destination.setDestination(_name: selStation.get()[0].name, _coordinate: CLLocationCoordinate2D(latitude : selStation.get()[0].lat, longitude : selStation.get()[0].lng))
//                        self.destinationNameLbl = self.destination.getDestinationName()
                    }
                }){
                    StationView(selectedStation: selectedStation)
                }
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
            .font(.system(size : 30))
            .frame(width: 100, height: 30)
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
