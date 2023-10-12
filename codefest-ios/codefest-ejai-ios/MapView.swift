//
//  MapView.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import SwiftUI
import AVKit
import MapKit

struct MapView: View {
    
    @State var position: MapCameraPosition = .region(Location.region)
    @State var route: MKRoute?
    @State private var showARView = false
    @State var destination: CLLocation?

    @State var points = [PointOfInterest]()
    
    @State var region: MKCoordinateRegion = Location.region
    @Environment(LocationManager.self) private var locationManager
    
    
    
    var body: some View {
            Map(position: $position) {
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.green, lineWidth: 7)
                }
                    
                Marker("Bldg 170", systemImage: "building", coordinate: Location.building170)
                
                Marker("Bldg 130", systemImage: "building", coordinate: Location.building130)
                
                Annotation("Quest", coordinate: Location.chalet) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.indigo.opacity(0.5))
                            .frame(width: 80, height: 80)
                        
                        Button(action: {
                            fetchRoute(from: locationManager.lastKnownLocation, to: Location.chalet)
                            
                        }, label: {
                            Image(systemName: "pawprint")
                                .symbolEffect(.variableColor)
                                .padding()
                                .foregroundStyle(.yellow)
                                .background(.indigo)
                                .clipShape(.circle)
                        })
                    }
                }
            }
    
            .mapStyle(.hybrid(elevation: .realistic))
            
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
            }
            .overlay {
                VStack {
                    Spacer()
                    Button {
                        Task {
                            await getCameraPermission()                     
                            showARView.toggle()
                        }
                    } label: {
                        Text("Show AR")
                            .padding()
                            .foregroundColor(.indigo)
                            .background(.regularMaterial)
                            .buttonBorderShape(.capsule)
                    }
                }
                    .safeAreaInset(edge: .top) {
                }
                
            }
            .fullScreenCover(isPresented: $showARView, onDismiss: {
                print("dismiss")
            }, content: {
                if let destination = destination {
                    ARDirectionView(isARViewShown: $showARView, destination: destination)
                        .environment(locationManager)
                }
            })
    }
    
    func getCameraPermission() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            await AVCaptureDevice.requestAccess(for: .video)
        default:
            print(AVCaptureDevice.authorizationStatus(for: .video))
        }
    }
    
    
    private func fetchRoute(from source: CLLocationCoordinate2D?, to destination: CLLocationCoordinate2D) {
        guard route == nil else {
            position = locationManager.userLocation
            route = nil
            self.destination = nil
            return
        }
            let request = MKDirections.Request()
        let placemark: MKPlacemark
        if let source {
        placemark = MKPlacemark(coordinate: source)
        } else {
            placemark = locationManager.userLocation.item?.placemark ?? MKPlacemark(coordinate: Location.chalet)
        }
        self.destination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let sourceItem = MKMapItem(placemark: placemark)
        request.source = sourceItem
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .walking
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                position = .region(MKCoordinateRegion(center: sourceItem.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                getTravelTime()
            }
    }
    
    private func getTravelTime() {
        guard let route else { return }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
      //  travelTime = formatter.string(from: route.expectedTravelTime)
    }
}


#Preview {
    MapView()
}


enum Location {
    static let building170 = CLLocationCoordinate2DMake(38.71195, -90.44688)
    static let building130 = CLLocationCoordinate2DMake(38.70949, -90.44723)
    static let chalet = CLLocationCoordinate2DMake(38.702211, -90.447688)
    
    static let areaPoints = [MKMapPoint(CLLocationCoordinate2DMake(38.71649, -90.45047)), MKMapPoint(CLLocationCoordinate2DMake(38.71654, -90.43674)), MKMapPoint(CLLocationCoordinate2DMake(38.69989, -90.43713)), MKMapPoint(CLLocationCoordinate2DMake(38.69969, -90.45057))]
    
    static let points = [CLLocationCoordinate2DMake(38.71649, -90.45047),CLLocationCoordinate2DMake(38.71654, -90.43674), CLLocationCoordinate2DMake(38.69989, -90.43713), CLLocationCoordinate2DMake(38.69969, -90.45057)]
    
    
    static let region: MKCoordinateRegion = {
        let coordinates = [
            CLLocationCoordinate2DMake(38.71649, -90.45047),
            CLLocationCoordinate2DMake(38.71654, -90.43674),
            CLLocationCoordinate2DMake(38.69989, -90.43713),
            CLLocationCoordinate2DMake(38.69969, -90.45057)
        ]
        
        // Calculate the center of the region
        let center = CLLocationCoordinate2D(
            latitude: (coordinates.max(by: { $0.latitude < $1.latitude })!.latitude +
                       coordinates.min(by: { $0.latitude < $1.latitude })!.latitude) / 2,
            longitude: (coordinates.max(by: { $0.longitude < $1.longitude })!.longitude +
                        coordinates.min(by: { $0.longitude < $1.longitude })!.longitude) / 2
        )
        
        // Calculate the span of the region
        let span = MKCoordinateSpan(
            latitudeDelta: (coordinates.max(by: { $0.latitude < $1.latitude })!.latitude -
                            coordinates.min(by: { $0.latitude < $1.latitude })!.latitude),
            longitudeDelta: (coordinates.max(by: { $0.longitude < $1.longitude })!.longitude -
                             coordinates.min(by: { $0.longitude < $1.longitude })!.longitude)
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }()
    
}
