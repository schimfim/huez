//
//  FilterManager.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

class FilterManager: NSObject {
	static let instance = FilterManager()
    private let filters: [Filter]
    private var currentFilter: Filter
    private var context: CIContext
    private var inImage: CIImage?
	
	override init() {
        let f1 = Filter(imageName:"filter_001", hsv:[((0.0, 1.0, 1.0),(0.0, 0.3, 0.3))])
        let f2 = Filter(imageName:"filter_002", hsv:[   ((0.7, 1.0, 1.0),(0.3, 1.0, 1.0)),
            ((0.0, 1.0, 1.0),(0.0, 0.2, 1.0))])
        let f3 = Filter(imageName:"filter_003", hsv:[((0.0, 0.0, 0.0),(0.0, 0.0, 0.5))])
		filters = [f1, f2, f3]
		currentFilter = filters[0]
		
		context = CIContext(options:nil)
	}
	
	/*
		Public interface
	*/
	static func getInstance()->FilterManager {
		return instance
	}
	
	func getNumFilters() -> Int {
		return filters.count
	}
	
	func getFilterImageAtIndex(i: Int) -> UIImage {
		return filters[i].getImage()
	}
	
    func setInImage(newImage : UIImage) {
		inImage = CIImage(CGImage: newImage.CGImage)
	}
	
	func setCurrentFilter(i: Int) {
		currentFilter = filters[i]
	}
	
	func processCurrentFilter() -> UIImage {
		let outputImage = currentFilter.process(inImage!)
		let cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent())
		let newImage = UIImage(CGImage: cgimg)

		return newImage!
	}
}
