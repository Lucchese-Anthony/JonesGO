//
//  ARDirectionalView.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI
import ARKit

struct ARDirectionView: View {
    @Binding var isARViewShown: Bool
    @Environment(\.dismiss) private var dismiss
    var destination: CLLocationCoordinate2D

    var body: some View {
        ARViewContainer(destination: destination)
            .edgesIgnoringSafeArea(.all)
            
    }
}
