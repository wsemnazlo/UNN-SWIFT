import AppKit

class Filters {
    func processImage(image: NSImage) -> NSImage {
        guard let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!) else { return image }

        let width = bitmap.size.width
        let height = bitmap.size.height

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        let context = CGContext(data: nil,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: Int(width) * 4,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)!

        context.draw(bitmap.cgImage!, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))

        let data = context.data!
        let buffer = UnsafeMutableBufferPointer<UInt8>(start: data.assumingMemoryBound(to: UInt8.self), count: Int(width) * Int(height) * 4)

        return processImage(buffer: buffer, width: Int(width), height: Int(height), colorSpace: colorSpace, bitmapInfo: bitmapInfo)
    }

    func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                      width: Int,
                      height: Int,
                      colorSpace: CGColorSpace,
                      bitmapInfo: CGBitmapInfo) -> NSImage {
        fatalError(" ")
    }

    func createImageFromContext(context: CGContext, width: Int, height: Int) -> NSImage {
        let resultCGImage = context.makeImage()!
        let resultImage = NSImage(cgImage: resultCGImage, size: NSSize(width: width, height: height))
        
        return resultImage
    }
}
