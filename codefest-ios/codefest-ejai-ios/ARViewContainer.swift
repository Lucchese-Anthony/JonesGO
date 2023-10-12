//
//  ARViewContainer.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI
import ARKit

struct ARViewContainer: UIViewRepresentable {
    var destination: CLLocation
    
    @Environment(LocationManager.self) private var locationManager
    
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        // Re-run the ARKit session.
        
        arView.session.run(configuration)
        //arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        func bearing(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
            let lat1 = source.latitude.degreesToRadians
            let lon1 = source.longitude.degreesToRadians
            
            let lat2 = destination.latitude.degreesToRadians
            let lon2 = destination.longitude.degreesToRadians
            
            let deltaLon = lon2 - lon1
            
            let y = sin(deltaLon) * cos(lat2)
            let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
            let radiansBearing = atan2(y, x)
            
            return radiansBearing.radiansToDegrees
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            let direction = bearing(from: parent.locationManager.lastKnownLocation ?? Location.building170, to: parent.destination.coordinate)
        
            let arrow = createArrow()
            arrow.eulerAngles.y = Float(-direction.degreesToRadians) // Negative because SceneKit's rotation is opposite.
            arrow.position = SCNVector3(0, 0, -0.5) // 0.5 meters in front of the device.

            node.addChildNode(arrow)
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            print(error.localizedDescription)
        }

        
        func createArrow() -> SCNNode {
            let shaft = SCNCylinder(radius: 0.01, height: 0.2)
            let shaftNode = SCNNode(geometry: shaft)
            shaftNode.position.y = Float(shaft.height/2)
            
            let head = SCNCone(topRadius: 0, bottomRadius: 0.03, height: 0.05)
            let headNode = SCNNode(geometry: head)
            headNode.position.y = Float(shaft.height + head.height/2)
            
            let arrow = SCNNode()
            arrow.addChildNode(shaftNode)
            arrow.addChildNode(headNode)
            
            return arrow
        }
    }
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
