//
//  SearchViewModel.swift
//  Suny
//
//  Created by Samreth Kem on 12/10/22.
//

import Foundation
import MapKit

protocol SearchViewModelProtocol {
    var publisher: Published<[(city: String, country: String)]>.Publisher { get }
    var completer: MKLocalSearchCompleter { get set }
    var results: [(city: String, country: String)] { get set }
    var locationCallBack: (CLLocation) -> () { get set }
    func search(locationString: String)
    func setup()
}

class SearchViewModel: NSObject, SearchViewModelProtocol {
    var publisher: Published<[(city: String, country: String)]>.Publisher { $results }
    var completer: MKLocalSearchCompleter
    var locationCallBack: (CLLocation) -> ()
    @Published var results: [(city: String, country: String)]
    
    init(completer: MKLocalSearchCompleter, results: [(city: String, country: String)], locationCallBack: @escaping (CLLocation) -> Void) {
        self.completer = completer
        self.results = results
        self.locationCallBack = locationCallBack
    }
    
    func setup() {
        completer.delegate = self
        completer.region = MKCoordinateRegion(.world)
        completer.resultTypes = MKLocalSearchCompleter.ResultType([.address])
    }
    
    func search(locationString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { [weak self] placemarks, error in
            if let error {
                debugPrint(error.localizedDescription)
            }
            if let location = placemarks?.first?.location {
                self?.locationCallBack(location)
            }
        }
    }
}

extension SearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = self.getCityList(results: completer.results)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getCityList(results: [MKLocalSearchCompletion]) -> [(city: String, country: String)]{
        
        var searchResults: [(city: String, country: String)] = []
        
        for result in results {
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            
            buildPlace(titleComponents, subtitleComponents){ place in
                if place.city != "" && place.country != ""{
                    searchResults.append(place)
                }
            }
        }
        
        return searchResults
    }
    
    func buildPlace(_ title: [String],_ subtitle: [String], _ completion: @escaping ((city: String, country: String)) -> Void){
        
        var city: String = ""
        var country: String = ""
        
        if title.count > 1 && subtitle.count >= 1 {
            city = title.joined(separator: ", ")
            country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
        }
      
        completion((city, country))
    }
}

