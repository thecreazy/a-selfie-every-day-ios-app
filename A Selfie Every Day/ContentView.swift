//
//  ContentView.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 06/11/21.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack{
            Text("A selfie every day")
                .padding()

            Button("Open camera"){
            
            }.padding()
                .background(Color.green)
                .foregroundColor(Color.white)
        }
        .onAppear(){
            UIApplication.shared.applicationIconBadgeNumber = 0
            NotificationManager.instance.requestAuth()
            NotificationManager.instance.scheduleNotification()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
