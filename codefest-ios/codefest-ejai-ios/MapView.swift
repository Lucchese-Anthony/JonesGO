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
    
    @State var position: MapCameraPosition = .automatic
    @State var route: MKRoute?
    @State private var showARView = false
    @State var destination: CLLocationCoordinate2D?
    let session = URLSessionManager()
    
    @State var points = [Point]()
    
    @Environment(LocationManager.self) private var locationManager
    @State var isTed = false
    
    var body: some View {
            Map(position: $position) {
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(.cyan, lineWidth: 4)
                }

                ForEach(points) { point in
                    Annotation(point.description, coordinate: CLLocationCoordinate2D(latitude: point.lat, longitude: point.long)) {
                        ZStack {
                            Circle()
                                .foregroundStyle(.cyan.opacity(0.25))
                                .frame(width: 0, height: 40)
                            
                            Button {
                                fetchRoute(from: locationManager.lastKnownLocation ?? Location.building130, to: point.location2D)
                            } label: {
                                Image(systemName: "mappin.and.ellipse")
                                    .symbolEffect(.variableColor)
                                    .padding()
                                    .foregroundStyle(.yellow)
                                    .background(.indigo)
                                    .clipShape(.circle)
                                    .overlay(Circle().stroke(.yellow, lineWidth: 1.5))
                            }
                        }
                    }
                }
                
                Marker("Bldg 130", systemImage: "building", coordinate: Location.building130)
                    .tint(.cyan)
                Marker("Bldg 170", systemImage: "building", coordinate: Location.building170)
                    .tint(.cyan)
            }
            .navigationTitle("JonesGO")
        .onAppear {
            points = DataManager.pointsOfInterest
           // let region = Location.makeRegion(coordinates: points.compactMap { $0.location2D })
            Task {
                do {
                    let points = try await session.makeRequest([Point].self, path: .points, method: .get, body: nil)
                    self.points = points
                    DataManager.pointsOfInterest = points
                   // let region = Location.makeRegion(coordinates: points.compactMap { $0.location2D })
                 //   position = .automatic
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
        }
        .overlay {
            if destination != nil {
                VStack {
                    Spacer()
                    Button {
                        Task {
                            await getCameraPermission()
                            showARView.toggle()
                        }
                    } label: {
                        Text("AR View")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.indigo)
                            .background(.regularMaterial)
                            .buttonBorderShape(.capsule)
                    }.padding()
                }
                .safeAreaInset(edge: .top) {
                }
            }
        }
        .fullScreenCover(isPresented: $showARView, onDismiss: {
            destination = nil
        }, content: {
            if let destination = destination {
                let filename = isTed ? "ted" : "statue-of-liberty.usdz"
                ARContentView(filename: filename)
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    showARView = false
                                    isTed.toggle()
                                    self.destination = nil
                                    route = nil 
                                    position = .automatic
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                        .padding()
                                }
                             
                               
                            }
                            Spacer()
                        }
                    }
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
        let sourcePlacemark: MKPlacemark
        if let source {
            sourcePlacemark = MKPlacemark(coordinate: source)
        } else {
            sourcePlacemark = locationManager.userLocation.item?.placemark ?? MKPlacemark(coordinate: Location.chalet)
        }
        self.destination = destination
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
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
    
    static func makeRegion(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        
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
    }
    
    static let biggerRegion: MKCoordinateRegion = {
        let coordinates = [
            CLLocationCoordinate2DMake(38.71649, -90.45047),
            CLLocationCoordinate2DMake(38.71654, -90.43674),
            CLLocationCoordinate2DMake(38.69989, -90.43713),
            CLLocationCoordinate2DMake(38.69969, -90.45057)
        ]
        
        return makeRegion(coordinates: coordinates)
    }()
    
}
