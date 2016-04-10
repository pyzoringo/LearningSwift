import UIKit


public class ImageProcessor {
    public var targetUIImage: UIImage
    public init(targetUIImage: UIImage) {
        self.targetUIImage = targetUIImage
    }
    public convenience init(){
        self.init(targetUIImage: UIImage(named: "sample")!)
    }
    public var targetRGBAImage: RGBAImage {
        return RGBAImage(image: targetUIImage)!
    }
    public var height: Int {
        return targetRGBAImage.height
    }
    public var width: Int {
        return targetRGBAImage.width
    }
}

public extension ImageProcessor {
    public func printMap(color: String) -> [UInt8] {
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
    public var redMap: [UInt8] {
        return printMap("red")
    }
    public var greenMap: [UInt8] {
        return printMap("green")
    }
    public var blueMap: [UInt8] {
        return printMap("blue")
    }
}

public extension ImageProcessor {
    public func contrastFilter(strengthFrom0To10 strength: Double = 5) -> ImageProcessor {
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
public extension ImageProcessor {
    public func brightnessFilter(strengthFrom0To10 strength: Double = 8) -> ImageProcessor {
        let redMap = self.redMap
        let greenMap = self.greenMap
        let blueMap = self.blueMap
        let brightnessRGBAImage = targetRGBAImage
        for y in 0..<height {
            for x in 0..<width {
                let index = y*width+x
                brightnessRGBAImage.pixels[index].red = UInt8(min(255, max(0, strength*Double(redMap[index])/5)))
                brightnessRGBAImage.pixels[index].blue = UInt8(min(255, max(0, strength*Double(blueMap[index])/5)))
                brightnessRGBAImage.pixels[index].green = UInt8(min(255, max(0, strength*Double(greenMap[index])/5)))
            }
        }
        return ImageProcessor(targetUIImage: brightnessRGBAImage.toUIImage()!)
    }
}



//let filteredImage = ImageProcessor(targetUIImage: image).contrastFilter(strengthFrom0To10: 2).contrastFilter(strengthFrom0To10: 3)
//let brightessImage = ImageProcessor().brightnessFilter(strengthFrom0To10: 10).contrastFilter(strengthFrom0To10: 10)

public extension ImageProcessor {
    public func grayscaleConverter() -> ImageProcessor {
        let redMap = self.redMap
        let greenMap = self.greenMap
        let blueMap = self.blueMap
        let grayscaleImage = targetRGBAImage
        for y in 0..<height {
            for x in 0..<width {
                let index = y*width+x
                let grayFactor = 0.02989*Double(redMap[index]) + 0.5870*Double(greenMap[index]) + 0.114*Double(blueMap[index])
                grayscaleImage.pixels[index].red = UInt8(grayFactor)
                grayscaleImage.pixels[index].green = UInt8(grayFactor)
                grayscaleImage.pixels[index].blue = UInt8(grayFactor)
            }
        }
        return ImageProcessor(targetUIImage: grayscaleImage.toUIImage()!)
    }
}
// let grayImage = ImageProcessor().grayscaleConverter()

public extension ImageProcessor {
    public func createGroupIndices (centerIndex: Int) -> [Int] {
        return [centerIndex-(width+1), centerIndex-width, centerIndex-(width-1),
                centerIndex-1, centerIndex, centerIndex+1,
                centerIndex+(width-1), centerIndex+width, centerIndex+(width+1)]
    }
    func smoothFilter() -> ImageProcessor {
        let redMap = self.redMap
        let greenMap = self.greenMap
        let blueMap = self.blueMap
        let smoothImage = targetRGBAImage
        for y in 1..<height-1 {
            for x in 1..<width-1 {
                let centerIndex = y*width+x
                let groupIndex = createGroupIndices(centerIndex)
                var localRedSum = 0
                var localGreenSum = 0
                var localBlueSum = 0
                for index in groupIndex {
                    localRedSum += Int(redMap[index])
                    localGreenSum += Int(greenMap[index])
                    localBlueSum += Int(blueMap[index])
                }
                smoothImage.pixels[centerIndex].red = UInt8(localRedSum/9)
                smoothImage.pixels[centerIndex].green = UInt8(localGreenSum/9)
                smoothImage.pixels[centerIndex].blue = UInt8(localBlueSum/9)
            }
        }
        return ImageProcessor(targetUIImage: smoothImage.toUIImage()!)
    }
}

//let smoothImage = ImageProcessor().smoothFilter()

public extension ImageProcessor {
    public func evilFilter(evilDegreeFrom1To10 strength: Double = 5) -> ImageProcessor {
        let evilImage = targetRGBAImage
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                var currentPixel = evilImage.pixels[index]
                let pixelGreen = currentPixel.green
                let evilPixelBuffer = ((1-exp(-Double(pixelGreen)/255.0*3))*256.0)*(strength/10+0.8)
                let evilPixel = UInt8(min(255,evilPixelBuffer))
                currentPixel.green = evilPixel
                evilImage.pixels[index] = currentPixel
            }
        }
        return ImageProcessor(targetUIImage: evilImage.toUIImage()!)
    }
}
