//
//  Filter.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

let NCUBE = 4
let defaultCubeLength = NCUBE*NCUBE*NCUBE
let defaultFilterImage = UIImage(named: "DefaultImage")
	
let SCOPE: Float = 2.0

struct RGB {
    var r:Float = 0.0
	var g:Float = 0.0
	var b:Float = 0.0
	var a:Float = 1.0
    
    init(_ nr:Float, _ ng:Float, _ nb:Float) {
        r = nr
        g = ng
        b = nb
    }
    
    init(h:Float, s:Float, v:Float) {
    	// convert to rgb
    	let color = UIColor(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(v), alpha: CGFloat(1.0))
    	var nr : CGFloat = 0.0
    	var ng : CGFloat = 0.0
    	var nb : CGFloat = 0.0
    	var na : CGFloat = 0.0
    	color.getRed(&nr, green:&ng, blue:&nb, alpha:&na)
        
        r = Float(nr)
        g = Float(ng)
        b = Float(nb)
    }
}

class Filter: NSObject {
	var image: UIImage?
    var cube = [RGB](count:defaultCubeLength, repeatedValue:RGB(0,0,0))
	// data structure for CIFilter:cube3d
    var cubeData: NSData?
	
	var filter: CIFilter!
	
	private func fillCubeWithGradient() {
        for ib in 0..<NCUBE {
			for ig in 0..<NCUBE {
				for ir in 0..<NCUBE {
					let idx = (ir + ig * NCUBE + ib * NCUBE*NCUBE)
                    cube[idx].r = Float(ir) / Float(NCUBE-1)
					cube[idx].g = Float(ig) / Float(NCUBE-1)
					cube[idx].b = Float(ib) / Float(NCUBE-1)
					cube[idx].a = Float(1.0)
				}
			}
		}
	}

    func updateCubeData() {
        
        // Create filter structure
        cubeData = NSData(bytes: cube, length: defaultCubeLength * sizeof(RGB))
	}
	
	// MARK: Public interface
	
	// base initializer
    override init() {
		filter = CIFilter(name: "CIColorCube")
        super.init()
        fillCubeWithGradient()
        updateCubeData()
	}
	
	convenience init(newCube : [RGB]) {
		assert(newCube.count == defaultCubeLength, "Invalid cube size")
        self.init()
        cube = newCube
        updateCubeData()
        
        // set filterImage
        image = processUIImage(defaultFilterImage!)
	}
    
    convenience init(mod : (Int, RGB)) {
        self.init()
        cube[mod.0] = mod.1
        updateCubeData()
        
        // set filterImage
        image = processUIImage(defaultFilterImage!)
    }
    
    convenience init(cents : [RGB]) {
        self.init()
        
        for ib in 0..<NCUBE {
			for ig in 0..<NCUBE {
				for ir in 0..<NCUBE {
					let idx = (ir + ig * NCUBE + ib * NCUBE*NCUBE)
                    var mu = [Float](count: cents.count, repeatedValue: 0.0)
					var idist = [Float](count: cents.count, repeatedValue: 0.0)
					let ci = cube[idx]
                    var sd : Float = 0.0
					// calc inverse distances
					for ic in 0..<cents.count {
						let c = cents[ic]
						idist[ic] = 1.0 / ( pow(ci.r-c.r,2) + pow(ci.g-c.g,2) + pow(ci.b-c.b,2) )
                    	sd = sd + powf(idist[ic], SCOPE)
					}
					// calc membership
					for i in 0..<cents.count {
						mu[i] = powf(idist[i], SCOPE) / sd
					}
					// reconstruct
					var newc = RGB(0,0,0)
					for i in 0..<cents.count {
						newc.r += mu[i] * cents[i].r
						newc.g += mu[i] * cents[i].g
						newc.b += mu[i] * cents[i].b
					}
					cube[idx] = newc
				}
			}
		}
		
        updateCubeData()
        
        // set filterImage
        image = processUIImage(defaultFilterImage!)
    }
	
    convenience init(cents ct : [String: RGB]) {
        let c = [RGB](ct.values)
        self.init(cents:c)
    }
    
    func addColor(c: RGB) {
    	//xxx
    }
    
	func getImage()->UIImage {
		return image!
	}
	
	func process(inImage: CIImage) -> CIImage {
		filter.setValue(inImage, forKey: kCIInputImageKey)
		filter.setValue(NCUBE, forKey: "inputCubeDimension")
        filter.setValue(cubeData, forKey: "inputCubeData")
 
		let outputImage = filter.outputImage
 		return outputImage!
	}
    
    // Alot of stuff repeated here...
    func processUIImage(inImage: UIImage) -> UIImage {
        let ciImage = CIImage(CGImage: inImage.CGImage!)
        let outputImage = process(ciImage)
        let context = CIContext(options:nil)
        let cgimg = context.createCGImage(outputImage, fromRect: outputImage.extent)
        let newImage = UIImage(CGImage: cgimg, scale: 1.0, orientation:.Up)
        
        return newImage
    }

}
