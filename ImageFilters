//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!
let assignmentImage = RGBAImage(image: image)!
var pixel = assignmentImage.pixels[1]



// Step 2: Create a simple filter
// Here is a simple blur filter, taking a pixel, average it with surrounding 8 pixels, and output the image

/*
 func createGroupIndexArray(centerIndex: Int) -> [Int] {
 let width = assignmentImage.width
 let groupIndex = [centerIndex-width-1, centerIndex-width, centerIndex-width+1,
 centerIndex-1, centerIndex, centerIndex+1,
 centerIndex+width+1, centerIndex+width, centerIndex+width+1]
 return groupIndex
 }

 for y in 1..<assignmentImage.height - 1 {
 for x in 1..<assignmentImage.width - 1{
 let centerIndex = y * assignmentImage.width + x
 var centerPixel = assignmentImage.pixels[centerIndex]
 let groupPixelsIndex = createGroupIndexArray(centerIndex)
 var localRedSum = 0, localGreenSum = 0, localBlueSum = 0
 for pixelIndex in groupPixelsIndex {
 let currentPixel = assignmentImage.pixels[pixelIndex]
 localRedSum += Int(currentPixel.red)
 localGreenSum += Int(currentPixel.green)
 localBlueSum += Int(currentPixel.blue)
 }
 centerPixel.red = UInt8(localRedSum/9)
 centerPixel.green = UInt8(localGreenSum/9)
 centerPixel.blue = UInt8(localBlueSum/9)
 assignmentImage.pixels[centerIndex] = centerPixel
 }
 }
 
 let smoothedImage = assignmentImage.toUIImage()
 */


class ImageProcessor {
    let filename: String
    init(filename: String) {
        self.filename = filename
    }
    var targetImage: RGBAImage {
        return RGBAImage(image: UIImage(named: filename)!)!
    }
    var height: Int {
        return targetImage.height
    }
    var width: Int {
        return targetImage.width
    }
}


class ColorMap: ImageProcessor {
    let color: String
    init(filename: String, color: String) {
        self.color = color
        super.init(filename: filename)
    }
    func printMap() -> [UInt8] {
        var map = [UInt8](count: width*height, repeatedValue: 0)
        for y in 0..<height {
            for x in 0..<width {
                let index = y*width+x
                let pixel = targetImage.pixels[index]
                switch self.color {
                case "red":
                    map[index] = pixel.red
                case "green":
                    map[index] = pixel.green
                case "blue":
                    map[index] = pixel.blue
                default:
                    map[index] = 0
                }
            }
        }
        return map
    }
}



class Filters: ImageProcessor {
    func contrastFilter(strengthFrom0To10 strength: Double) -> UIImage {
        let redMap = ColorMap(filename: filename, color: "red").printMap()
        let greenMap = ColorMap(filename: filename, color: "green").printMap()
        let blueMap = ColorMap(filename: filename, color: "blue").printMap()
        let contrastRGBAImage = targetImage
        for y in 0..<height {
            for x in 0..<width {
                let index = y*width+x
                let redFactor = strength/10.0*(259.0*(Double(redMap[index])+255.0))/((255.0)*(259.0-Double(redMap[index])))*((Double(redMap[index])-128)+128)
                let newRed = UInt8(min(255, max(0, redFactor)))
                let blueFactor = strength/10.0*(259.0*(Double(blueMap[index])+255.0))/((255.0)*(259.0-Double(blueMap[index])))*((Double(blueMap[index])-128)+128)
                let newBlue = UInt8(min(255, max(0, blueFactor)))
                let greenFactor = strength/10.0*(259.0*(Double(greenMap[index])+255.0))/((255.0)*(259.0-Double(greenMap[index])))*((Double(greenMap[index])-128)+128)
                let newGreen = UInt8(min(255, max(0, greenFactor)))
                contrastRGBAImage.pixels[index].red = newRed
                contrastRGBAImage.pixels[index].blue = newBlue
                contrastRGBAImage.pixels[index].green = newGreen
            }
        }
        return contrastRGBAImage.toUIImage()!
    }
}

let contrastUIImage10 = Filters(filename: "sample").contrastFilter(strengthFrom0To10: 10.0)
let contrastUIImage05 = Filters(filename: "sample").contrastFilter(strengthFrom0To10: 5)



/*
func evilImage(myUIImage: UIImage) -> UIImage {
    let myImage = RGBAImage(image: myUIImage)!
    for y in 0..<myImage.height {
        for x in 0..<myImage.width {
            let pixelIndex = y * myImage.width + x
            var currentPixel = myImage.pixels[pixelIndex]
            let pixelGreen = currentPixel.green
            let evilPixel = UInt8((1-exp(-Double(pixelGreen)/255.0*3))*256.0)
            currentPixel.green = evilPixel
            myImage.pixels[pixelIndex] = currentPixel
        }
    }
    return myImage.toUIImage()!
}

let aEvilImage = evilImage(image)
 */


