//
//  Filter.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

let NCUBE = 2
let defaultCubeLength = NCUBE*NCUBE*NCUBE

class Filter: NSObject {
	let image: UIImage
    var cube = [Float](count:defaultCubeLength*4, repeatedValue:0.0)
    //private var cube : [(Float,Float,Float,Float)]
    var cubeData: NSData
	
	var filter: CIFilter!
	
	private func initCube() {
        // Generate default cube
        for b in 0..<NCUBE {
			for g in 0..<NCUBE {
				for r in 0..<NCUBE {
					var idx = 4 * (r + g * NCUBE + b * NCUBE*NCUBE)
                    cube[idx+0] = Float(r) / Float(NCUBE-1)
					cube[idx+1] = Float(g) / Float(NCUBE-1)
					cube[idx+2] = Float(b) / Float(NCUBE-1)
					cube[idx+3] = Float(1.0)
				}
			}
		}
	}
	
	func adaptCube(hsv:[((h:Float, s:Float, v:Float),(h:Float, s:Float, v:Float))]) {
        var mix = [Float](count:defaultCubeLength*4, repeatedValue:0.0)
        for i in 0..<defaultCubeLength {
            var idx = 4 * i
            let a = mix[idx+3]
            mix[idx+0] = cube[idx+0]
            mix[idx+1] = cube[idx+1]
            mix[idx+2] = cube[idx+2]
            mix[idx+3] = cube[idx+3]
        }

        // Adapt cube
        let r,g,b,alpha : CGFloat
        var rc,gc,bc : CGFloat
        r=0;g=0;b=0; alpha=1;
        rc=0;gc=0;bc=0;

        let len = hsv.count
        for pattern in hsv {
            let center = pattern.0
            let col = pattern.1
            // convert to rgb
            let color = UIColor(hue: CGFloat(center.h), saturation: CGFloat(center.s), brightness: CGFloat(center.v), alpha: CGFloat(1.0))
            color.getRed(&r, green:&g, blue:&b, alpha:&alpha)
            let cout = UIColor(hue: CGFloat(col.h), saturation: CGFloat(col.s), brightness: CGFloat(col.v), alpha: CGFloat(1.0))
            cout.getRed(&rc, green:&gc, blue:&bc, alpha:&alpha)
            let ir = Int(round(Float(r) * Float(NCUBE-1)))
            let ig = Int(round(Float(g) * Float(NCUBE-1)))
            let ib = Int(round(Float(b) * Float(NCUBE-1)))
            var idx = 4 * (ir + ig * NCUBE + ib * NCUBE*NCUBE)
            mix[idx+0] = Float(rc)
            mix[idx+1] = Float(gc)
            mix[idx+2] = Float(bc)
            mix[idx+3] = Float(1.0)

        }
        // mix it!
        for i in 0..<defaultCubeLength {
        	var idx = 4 * i
        	let a = mix[idx+3]
        	/*
        	cube[idx+0] = cube[idx+0]*(1-a) + mix[idx+0]*a
        	cube[idx+1] = cube[idx+1]*(1-a) + mix[idx+1]*a
            cube[idx+2] = cube[idx+2]*(1-a) + mix[idx+2]*a
            */
            cube[idx+0] = mix[idx+0]
        	cube[idx+1] = mix[idx+1]
            cube[idx+2] = mix[idx+2]
            cube[idx+3] = mix[idx+3]
        }
    }
    
    func updateCubeData() {
        
        // Create filter structure
        cubeData = NSData(bytes: cube, length: defaultCubeLength*4*sizeof(Float))
		filter = CIFilter(name: "CIColorCube")
	}
	
	// MARK: Public interface
	
    init(imageName: String, hsv:[((h:Float, s:Float, v:Float),(h:Float, s:Float, v:Float))]) {
        image =  UIImage(named: imageName)!
        cubeData = NSData(bytes: cube, length: defaultCubeLength*4*sizeof(Float))
        super.init()
        initCube()
        adaptCube(hsv)
        updateCubeData()
	}
	
	func getImage()->UIImage {
		return image
	}
	
	func process(inImage: CIImage) -> CIImage {
		filter.setValue(inImage, forKey: kCIInputImageKey)
		filter.setValue(NCUBE, forKey: "inputCubeDimension")
        filter.setValue(cubeData, forKey: "inputCubeData")
 
		let outputImage = filter.outputImage
 		return outputImage
	}
}
