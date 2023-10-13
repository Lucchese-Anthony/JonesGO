//
//  ARContentView.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/13/23.
//

import SwiftUI
import ARKit
import RealityKit
import SceneKit

struct ARContentView: UIViewRepresentable {
    
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity()
        let arConfiguration = ARWorldTrackingConfiguration()

        if filename == "ted" {
            let texture = try! TextureResource.load(named: "Ed")
                  var material = SimpleMaterial()
            material.baseColor = try! .texture(.load(named: "Ed"))
            material.metallic = MaterialScalarParameter(floatLiteral: 1)
            material.roughness = MaterialScalarParameter(floatLiteral: 0.0)
    
            let planeMesh = MeshResource.generatePlane(width: 0.45, depth: 0.45) // Adjust size as needed
            let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
            //let modelComponent = ModelComponent(mesh: planeMesh, materials: [material])
                  // Create an anchor to set the entity in the AR space
                  anchor.addChild(planeEntity)
            arConfiguration.planeDetection = [.vertical]

        } else {
            arConfiguration.planeDetection = [.horizontal, .vertical]

            // Load the USDZ file
            let modelAnchor = try! ModelEntity.load(named: filename)
            
            // Create an anchor to set the entity in the AR space
            anchor.addChild(modelAnchor)
        }
        // Add the anchor to the ARView
        arView.scene.addAnchor(anchor)
        
        // Start AR session with world tracking (you can configure this as per your need)
        arView.session.run(arConfiguration)
        
        return arView
    
    }
    

}

