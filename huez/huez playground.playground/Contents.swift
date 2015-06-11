//: Playground - noun: a place where people can play

import UIKit

let orig = UIImage(named: "fanny.jpg")
let ci = CIImage(image: orig)
let f = CIFilter(name: "CIColorCube")
f.setValue(2, forKey: "inputCubeDimension")
let cube : [Float]
//cube = [0,0,0,1, 1,0,0,1, 0,1,0,1, 1,1,0,1, 0,0,1,1, 1,0,1,1, 0,1,1,1, 1,1,1,1]
  cube = [0,0,0,1, 1,0,0,1, 0,1,0,1, 0,1,0,1, 0,0,1,1, 0,0,1,1, 0,1,1,1, 1,1,1,1]

f.setValue(ci, forKey: "inputImage")
let cubeData = NSData(bytes: cube, length: cube.count * sizeof(Float))
f.setValue(cubeData, forKey: "inputCubeData")
let out = f.outputImage

