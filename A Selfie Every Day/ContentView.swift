//
//  ContentView.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 06/11/21.
//

import SwiftUI


struct ContentView: View {
    @State private var isPresented = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack{
            Text("A selfie every day")
                .padding()
            Button("Open camera"){
                self.isPresented.toggle()
            }.padding()
            .background(Color.green)
            .foregroundColor(Color.white)
            .fullScreenCover(isPresented: $isPresented, onDismiss: didDismiss , content: CameraView.init )
            .alert("Image saved", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
        .onAppear(){
            UIApplication.shared.applicationIconBadgeNumber = 0
            NotificationManager.instance.requestAuth()
            NotificationManager.instance.scheduleNotification()
        }
    }
    
    func didDismiss(){
        self.showingAlert.toggle()
        print("closed camera")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
