//
//  Helpers.swift
//  3W Restos
//
//  Created by etudiant04 on 17/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import Foundation
import MapKit

enum Price {
    case €, €€, €€€
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias CompletionBlock<T> = (Result<T>)->()

func getRegionMap(at coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    return region
}
