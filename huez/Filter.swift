//
//  Filter.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

class Filter: NSObject {
	private let image: UIImage
	
	init(imageName: String) {
        image =  UIImage(named: imageName)!
	}
	
	func getImage()->UIImage {
		return image
	}
}
