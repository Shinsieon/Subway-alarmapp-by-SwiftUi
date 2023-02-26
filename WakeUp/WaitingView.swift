//
//  WaitingView.swift
//  WakeUp
//
//  Created by 신시언 on 2023/02/26.
//

import SwiftUI

struct WaitingView: View {
    @State var isAnimating: Bool = true
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
        }
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}
