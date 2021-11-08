//
//  CameraView.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 08/11/21.
//

import SwiftUI
import AVFoundation

struct CameraView: View {

    @StateObject var camera = CameraModel()

    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all, edges: .all)
            VStack{
                Spacer()
                HStack{
                if camera.isTaken{
                    Button(action: {
                    }, label: {
                        Text("Save")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                        
                    }).padding(.leading)
                    Spacer()
                } else {
                        Button(action: {
                            camera.isTaken.toggle()
                        }, label: {
                            ZStack{
                                Circle().fill(Color.white).frame(width: 70, height: 70)
                                Circle().stroke(Color.white, lineWidth: 2).frame(width: 75, height: 75)
                            }
                        })
                    }
                }
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

class CameraModel: ObservableObject {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    
    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if(status){
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front)
            let input = try AVCaptureDeviceInput(device: device!)
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
        } catch{
            print(error.localizedDescription)
        }
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
