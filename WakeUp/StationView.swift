//
//  StationView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/25.
//

import SwiftUI

struct StationView: View {
    @State private var searchText = ""
    @Environment(\.presentationMode)
        var presentationMode: Binding<PresentationMode>
    @State public var SubwayStations = [SubWayStations]()
    @ObservedObject var selectedStation: selectedStationVM
    @State private var subwayIcon : [String : String] = [
        "01호선" : "line1Icon" ,
        "02호선" : "line2Icon",
        "03호선" : "line3Icon",
        "04호선" : "line4Icon",
        "05호선" : "line5Icon",
        "06호선" : "line6Icon",
        "07호선" : "line7Icon",
        "08호선" : "line8Icon",
        "09호선" : "line9Icon",
        "경강선" : "gyeonggangLineIcon",
        "경의선" : "gyeonguiLineIcon",
        "경춘선" : "gyeongchunLineIcon",
        "공항철도" : "airportLineIcon",
        "김포도시철도" : "gimpoLineIcon",
        "분당선" : "bundangLineIcon",
        "서해선" : "seohaeLineIcon",
        "수인선" : "suinLineIcon",
        "신분당선" : "sinbundangLineIcon",
        "용인경전철" : "yonginLineIcon",
        "우이신설경전철" : "uiLineIcon",
        "의정부경전철" : "uLineIcon",
        "인천선" : "incheon1LineIcon",
        "인천2호선" : "incheon2LineIcon",
    ]
    var body: some View {
        NavigationView {
            VStack{
                SearchBar(dest : $searchText, isDisabled: false)
                    .padding(EdgeInsets(top :10, leading: 0, bottom: 10, trailing: 0))
                List{
                    ForEach(self.SubwayStations.filter{$0.name.contains(searchText) || searchText==""}){
                        item in HStack{
                            Text(item.name)
                            Spacer()
                            Image(subwayIcon[item.line, default : ""])
                                .renderingMode(Image.TemplateRenderingMode? .init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedStation.set(item: item)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("지하철역")
            .navigationBarItems(trailing: Button("닫기", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        .onAppear{
            @ObservedObject var datas = ReadData()
            self.SubwayStations = datas.subways
        }
    }
    
}
//stationJSON 데이터 읽기위한 클래스
class ReadData : ObservableObject{
    @Published var subways = [SubWayStations]()
    init(){
        loadData()
    }
    func loadData(){
        guard let url = Bundle.main.url(forResource: "StationJSON", withExtension: "json")
        else{
            print("Json file not found")
            return
        }
        let data = try? Data(contentsOf: url)
        let decoder = JSONDecoder()
        let subways = try? decoder.decode([SubWayStations].self, from : data!)
        self.subways = subways!
    }
}

class selectedStationVM : ObservableObject{
    @Published var subway = [SubWayStations]()
    
    func set(item : SubWayStations){
        self.subway = [item]
    }
    
    func get()->[SubWayStations]{
        return self.subway
    }
}

struct SearchBar: View {
    @Binding var dest : String
    var isDisabled : Bool
    var body : some View{
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("목적지(역)을 입력해주세요", text : $dest)
                    //.foregroundColor(.black)
                    .disabled(isDisabled)
                if !dest.isEmpty{
                    Button(action : {
                        self.dest = ""
                    }){
                        Image(systemName: "xmark.circle.fill")
                    }
                }else{
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom :4, trailing: 8))
            .background(Color.gray.opacity(0.1))
            //.foregroundColor(Color.black)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
struct SubWayStations : Decodable,Identifiable,Hashable{
    let line : String
    let name : String
    let code : QuantumValue
    let lat : Double
    let lng : Double
    var id : Double { lat }
}
//string 인지 int 인지 확실하지 않은 데이터이기 때문에 변환작업이 필요하다.
enum QuantumValue : Decodable, Hashable{
    case int(Int), string(String)
    
    init(from decoder : Decoder) throws{
        if let int = try? decoder.singleValueContainer().decode(Int.self){
            self = .int(int)
            return
        }
        if let string = try? decoder.singleValueContainer().decode(String.self){
            self = .string(string)
            return
        }
        throw QuantumError.missingValue
    }
    enum QuantumError : Error {
        case missingValue
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        let selStation = selectedStationVM()
        StationView(selectedStation: selStation)
    }
}
