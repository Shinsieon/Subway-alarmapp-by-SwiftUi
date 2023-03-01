//
//  ContentView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/22.
//

import SwiftUI
import MapKit

class LocationInfo{
    var curLocation : MKCoordinateRegion
    init(){
        curLocation = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914),
            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    }
    func get() -> MKCoordinateRegion{
        return self.curLocation
    }
    
    func set(_loc : MKCoordinateRegion) {
        curLocation = _loc
    }
}

var locationInfo = LocationInfo()

struct ContentView: View {
    @State private var splashShow : Bool = true
    @State private var fadeIn = false
    @State private var selectedDistance : String = "100m"
    @State private var selectedType : String = "소리"
    @State private var showStations = false
    @State private var goToWaitingView = false
    @ObservedObject var selectedStation = selectedStationVM()
    @State private var selectedStationText = "도착역을 지정해주세요"
    @State private var startedCalculation :Bool = false
    @State private var presentAlert = false
    var distanceArray = ["100m","300m","500m","1km","1.5km"]
    var alertTypeArray = ["소리", "진동"]
    @State private var toast: FancyToast? = nil
    @State private var subwayColor : [String : String] = [
        "01호선" : "line1Color" ,
        "02호선" : "line2Color",
        "03호선" : "line3Color",
        "04호선" : "line4Color",
        "05호선" : "line5Color",
        "06호선" : "line6Color",
        "07호선" : "line7Color",
        "08호선" : "line8Color",
        "09호선" : "line9Color",
        "경강선" : "gyeonggangLineColor",
        "경의선" : "gyeonguiLineColor",
        "경춘선" : "gyeongchunLineColor",
        "공항철도" : "airportLineColor",
        "김포도시철도" : "gimpoLineColor",
        "분당선" : "bundangLineColor",
        "서해선" : "seohaeLineColor",
        "수인선" : "suinLineColor",
        "신분당선" : "sinbundangLineColor",
        "용인경전철" : "yonginLineColor",
        "우이신설경전철" : "uiLineColor",
        "의정부경전철" : "uLineColor",
        "인천선" : "incheon1LineColor",
        "인천2호선" : "incheon2LineColor",
    ]
    var body: some View {
        NavigationView{
            ZStack {
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
                
                VStack{
                    Spacer()
                        .frame(height:100)
                    Text("안녕하세요. 어디로 가시나요?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 35, weight: .heavy))
                        .onAppear(){
                            withAnimation(.easeIn(duration: 1)){
                                if(fadeIn==false) {
                                    fadeIn.toggle()
                                }
                            }
                        }
                        .opacity(fadeIn ? 1 : 0)
                    MapView()
                    HStack{
                        Button(selectedStationText, action:{self.showStations.toggle()})
                            .padding()
                            .frame(width: 300)
                            .foregroundStyle(Color("defaultFont").opacity(0.8))
                            .background(selectedStation.get().count>0 ? Color(subwayColor[selectedStation.get()[0].line]!).opacity(0.5) : .secondary.opacity(0.5),in : RoundedRectangle(cornerRadius: 12, style : .continuous)
                            )
                            .overlay(Image(systemName: "train.side.front.car")
                                .font(.system(size:25))
                                .foregroundColor(Color.white)
                                .padding(.horizontal,30) ,alignment: .leading)
                            
                    }
                    .padding()
                    VStack{
                        Text("언제쯤 깨워드릴까요?")
                            .font(.system(size: 25, weight: .heavy))
                        Picker("Choose a time", selection: $selectedDistance){
                            ForEach(distanceArray, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        Text("목적지와 현재 위치간의 거리를 계산합니다.")
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
                    NavigationLink(destination: WaitingView(selectedStation: selectedStation, selectedDistance : selectedDistance), isActive: $goToWaitingView){
                        let status = startedCalculation ? "중지" : "시작"
                        Button(status, action:{
                            if selectedStation.get().count==0{
                                toast = FancyToast(type: .info, title: "Info", message: "도착역을 지정해주세요")
                            }else{
                                if startedCalculation == true{
                                    presentAlert.toggle()
                                } else{
                                    self.goToWaitingView.toggle()
                                    fadeIn = true
                                    startedCalculation = true
                                }
                                
                            }
                        })
                        .buttonStyle(startButtonStyle())
                        .padding()
                    }
                    .alert("중지하고 다시 시작하시겠습니까?", isPresented: $presentAlert, actions:{
                        Button("Cancel", role: .cancel, action:{})
                        Button("OK", action:{
                            self.goToWaitingView.toggle()
                            fadeIn = true
                            startedCalculation = true
                        })
                    })
                    Spacer()
                    
                }
                .frame(width:360) //VStack
                    
                    
                .sheet(isPresented: $showStations, onDismiss: {
                    if selectedStation.get().count>0 {
                        self.selectedStationText = selectedStation.get()[0].name
                    }
                }){
                    StationView(selectedStation: selectedStation)
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        splashShow.toggle()
                    })
                }
                .toastView(toast: $toast)
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
