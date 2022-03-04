//
//  MTMapView+PP.swift
//  Lulla
//
//  Created by Mac on 2018. 7. 26..
//  Copyright © 2018년 pplus. All rights reserved.
//

import Foundation
import CoreLocation

//extension MTMapView {
//	
//	func setMapCenter(coordinate: CLLocationCoordinate2D?, zoomLevel: MTMapZoomLevel? = nil, animated: Bool) {
//		guard let coordinate = coordinate else { return }
//		
//		setMapCenter(latitude: coordinate.latitude, longitude: coordinate.longitude, zoomLevel: zoomLevel, animated: animated)
//	}
//	
//	func setMapCenter(latitude: Double?, longitude: Double?, zoomLevel: MTMapZoomLevel? = nil, animated: Bool) {
//		guard let latitude = latitude, let longitude = longitude else { return }
//		
//		let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude:latitude, longitude: longitude))
//		if let zoomLevel = zoomLevel {
//			setMapCenter(mapPoint, zoomLevel: zoomLevel, animated: animated)
//		} else {
//			setMapCenter(mapPoint, animated: animated)
//		}
//	}
//	
//}
