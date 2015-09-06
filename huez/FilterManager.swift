//
//  FilterManager.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

let black_c   = RGB(0,0,0)
let white_c   = RGB(1,1,1)
let red_c     = RGB(1,0,0)
let green_c   = RGB(0,1,0)
let blue_c    = RGB(0,0,1)
let magenta_c = RGB(1,0,1)
let yellow_c  = RGB(1,1,0)
let cyan_c    = RGB(0,1,1)

let base = ["black":black_c, "white":white_c, "red":red_c, "green":green_c, "blue":blue_c, "magenta":magenta_c, "yellow":yellow_c, "cyan":cyan_c]

class FilterManager: NSObject {
	static let instance = FilterManager()
    private let filters: [Filter]
    private var currentFilter: Filter
    private var context: CIContext
    private var inImage: CIImage?
    
	override init() {
        // neutral
        let f0 = Filter(cents: base)
        // B and W
        let f1 = Filter(cents: [white_c, black_c])
        // BWr
        let f2 = Filter(cents: [white_c, black_c, RGB(0.8,0.1,0.1)])
        // BWRGB
        let f3 = Filter(cents: [RGB(0.0,0.0,0.0), RGB(1.0,1.0,1.0), RGB(1.0,0.0,0.0), RGB(0.0,1.0,0.0), RGB(0.0,0.0,1.0),])
        // full + blu
        var blu = base
        blu["b"] = blue_c
        let f4 = Filter(cents: blu)
        // full + blu
        var cents = base
        cents["black"] = RGB(0.0,0.0,0.3)
        cents["blue"] = RGB(0.0,0.0,7.0)
        let f5 = Filter(cents: cents)

		filters = [f0, f1, f2, f3, f4, f5]
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
		let newImage = UIImage(CGImage: cgimg, scale: 1.0, orientation:.Up)

		return newImage!
	}
}
