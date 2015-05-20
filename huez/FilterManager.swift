//
//  FilterManager.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

class FilterManager: NSObject {
	static var instance = FilterManager()
    private let filters: [Filter]
	
	private override init() {
		let f1 = Filter(imageName:"filter_001")
		let f2 = Filter(imageName:"filter_002")
		let f3 = Filter(imageName:"filter_003")
		filters = [f1, f2, f3]
	}
	
	/*
		Public interface
	*/
	func getNumFilters() -> Int {
		return filters.count
	}
	
	func getFilterImageAtIndex(i: Int) -> UIImage {
		return filters[i].getImage()
	}
}
