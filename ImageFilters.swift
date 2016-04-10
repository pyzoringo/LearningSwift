//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!
let assignmentImage = RGBAImage(image: image)!
var pixel = assignmentImage.pixels[1]

// Step 2: Create a simple filter
// Here is a simple blur filter, taking a pixel, average it with surrounding 8 pixels, and output the image


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

/* Step 3&4: Create the image processor, create predefined filters
 
    The filters are encapsulated in a class called: ImagePaocessor
    This ImageProcessor class is saved in ImageProcessor.swift under Sources document
 
    filters: 1. contrastFilter(strengthFrom0To10 strength: Double)
             It changes the contrast of the image to certain degree, has a default strength of 5
          2. brightnessFilter(strengthFrom0To10 strength: Double)
             It changes the brightness of the image to certain degree, has a default strength of 8
          3. grayscaleConverter()
             It converts the image to grayscale image
          4. smoothFilter()
             It blur the entire image
          5. evilFilter(evilDegreeFrom1To10 strength: Double)
             It makes the image appear more green to a certain degree, has a default strength of 5
*/


// Step5: Apply predefined filters

    // Original Image
image
    // Apply Contrast Filter
ImageProcessor().contrastFilter(strengthFrom0To10: 8)

    // Apply Brightness Filter
ImageProcessor().brightnessFilter(strengthFrom0To10: 3)

    // Change the image to grayscale
ImageProcessor().grayscaleConverter()

    // Blue the image
ImageProcessor().smoothFilter()

    // Make the image become evil
ImageProcessor().evilFilter(evilDegreeFrom1To10: 5)





//Apply several filter at the same time
ImageProcessor(targetUIImage: image).contrastFilter(strengthFrom0To10: 5).brightnessFilter(strengthFrom0To10: 4)






