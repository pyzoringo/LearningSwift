
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
    var targetUIImage: UIImage
    init(targetUIImage: UIImage) {
        self.targetUIImage = targetUIImage
    }
    convenience init(){
        self.init(targetUIImage: image)
    }
    var targetRGBAImage: RGBAImage {
        return RGBAImage(image: targetUIImage)!
    }
    var height: Int {
        return targetRGBAImage.height
    }
    var width: Int {
        return targetRGBAImage.width
    }
}

extension ImageProcessor {
    func printMap(color: String) -> [UInt8] {
        var map = [UInt8](count: width*height, repeatedValue: 0)
        for y in 0..<height {
            for x in 0..<width {
                let index = y*width+x
                let pixel = targetRGBAImage.pixels[index]
                switch color {
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
    var redMap: [UInt8] {
        return printMap("red")
    }
    var greenMap: [UInt8] {
        return printMap("green")
    }
    var blueMap: [UInt8] {
        return printMap("blue")
    }
}

extension ImageProcessor {
    func contrastFilter(strengthFrom0To10 strength: Double) -> ImageProcessor {
        let redMap = self.redMap
        let greenMap = self.greenMap
        let blueMap = self.blueMap
        let contrastRGBAImage = targetRGBAImage
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
        return ImageProcessor(targetUIImage: contrastRGBAImage.toUIImage()!)
    }
}
extension ImageProcessor {
    func brightnessFilter(strengthFrom0To10 strength: Double) -> ImageProcessor {
        let redMap = self.redMap
        let greenMap = self.greenMap
        let blueMap = self.blueMap
        let brightnessRGBAImage = targetRGBAImage
        for y in 0..<height {
            for x in 0..<width {
                let index = y*width+x
                let newRed = UInt8(min(255, max(0, strength*Double(redMap[index])/5)))
                let newblue = UInt8(min(255, max(0, strength*Double(blueMap[index])/5)))
                let newgreen = UInt8(min(255, max(0, strength*Double(greenMap[index])/5)))
                brightnessRGBAImage.pixels[index].red = newRed
                brightnessRGBAImage.pixels[index].blue = newblue
                brightnessRGBAImage.pixels[index].green = newgreen
            }
        }
        return ImageProcessor(targetUIImage: brightnessRGBAImage.toUIImage()!)
    }
}

//let filteredImage = ImageProcessor(targetUIImage: image).contrastFilter(strengthFrom0To10: 2).contrastFilter(strengthFrom0To10: 3)
let brightessImage = ImageProcessor().brightnessFilter(strengthFrom0To10: 10).contrastFilter(strengthFrom0To10: 10)
