//
//  CameraView.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 08/11/21.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var camera = CameraModel()

    var body: some View {
            ZStack{
                CameraPreview(camera: camera).ignoresSafeArea(.all, edges: .all)
                VStack{
                    Spacer()
                    HStack{
                    if camera.isTaken {
                        if !camera.picData.isEmpty {
                            Button(action: {
                                camera.savePic()
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Save")
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .clipShape(Capsule())
                                
                            }).padding()
                        } else {
                            Spacer()
                        }
                        Spacer()
                        Button(action: camera.retakePic, label: {
                            Text("Retake")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                            
                        }).padding()
                    } else {
                        Button(action: {
                            camera.takePic()
                        }, label: {
                            ZStack{
                                Circle().fill(Color.white).frame(width: 70, height: 70)
                                Circle().stroke(Color.white, lineWidth: 2).frame(width: 75, height: 75)
                            }
                        }).position(x: UIScreen.main.bounds.size.width - 100, y: (UIScreen.main.bounds.size.height / 2) - 15 )

                        Image("Face").scaledToFit().position(x: -120, y: 20 ).frame(width: 120, height: 160)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            camera.Check()
        })
    }
}

class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview = AVCaptureVideoPreviewLayer()
    @Published var picData = Data(count: 0)
    
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
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
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
    
    func takePic() {
        let captureSettings = AVCapturePhotoSettings()
        self.output.capturePhoto(with: captureSettings, delegate: self)
        withAnimation{ self.isTaken.toggle() }
    }
    
    func retakePic() {
        self.picData = Data(count: 0)
        self.session.startRunning()
        withAnimation{ self.isTaken.toggle() }
    }

    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.session.stopRunning()
        if let error = error {
            print(error.localizedDescription)
        }
        guard let imageData = photo.fileDataRepresentation() else {return}
        self.picData = imageData
    }
    
    func savePic() {
        let image = UIImage(data: self.picData)!
        SaveImageManager.instance.save(image: image)
        print("Saved image")
    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.transform = CGAffineTransform.init(rotationAngle: -90 * CGFloat.pi/180)
        view.frame.origin.x = 0
        view.frame.origin.y = 0
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CameraView()
                .previewInterfaceOrientation(.landscapeRight)
            CameraView()
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}

