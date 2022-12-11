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
    func search()
    func setup()
}

class SearchViewModel: NSObject, SearchViewModelProtocol {
    var publisher: Published<[(city: String, country: String)]>.Publisher { $results }
    var completer: MKLocalSearchCompleter
    @Published var results: [(city: String, country: String)]
    var locationCallBack: (CLLocation) -> ()
    
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
    func search() {
        
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
            
            buildCityTypeA(titleComponents, subtitleComponents){place in
                
                if place.city != "" && place.country != ""{
                    
                    searchResults.append(place)
                }
            }
            
            buildCityTypeB(titleComponents, subtitleComponents){place in
                
                if place.city != "" && place.country != ""{
                    
                    searchResults.append(place)
                }
            }
        }
        
        return searchResults
    }
    func buildCityTypeA(_ title: [String],_ subtitle: [String], _ completion: @escaping ((city: String, country: String)) -> Void){
        
        var city: String = ""
        var country: String = ""
        
        if title.count > 1 && subtitle.count >= 1 {
            city = title.joined(separator: ", ")
            country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
        }
      
        completion((city, country))
    }

    func buildCityTypeB(_ title: [String],_ subtitle: [String], _ completion: @escaping ((city: String, country: String)) -> Void){
        
        var city: String = ""
        var country: String = ""
        
        if title.count >= 1 && subtitle.count == 1 {
            
            city = title.first!
            country = subtitle.last!
        }
        
        completion((city, country))
    }
}

