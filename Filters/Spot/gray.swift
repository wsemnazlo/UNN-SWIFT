import AppKit

class GrayFilter: Filters {
    override func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                               width: Int,
                               height: Int,
                               colorSpace: CGColorSpace,
                               bitmapInfo: CGBitmapInfo) -> NSImage {
        
        for i in stride(from: 0, to: buffer.count, by: 4) {
            let red = Double(buffer[i])
            let green = Double(buffer[i+1])
            let blue = Double(buffer[i+2])
            let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
            buffer[i] = UInt8(luminance)
            buffer[i+1] = UInt8(luminance)
            buffer[i+2] = UInt8(luminance)
        }
        
        let resultContext = CGContext(data: buffer.baseAddress,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: Int(width) * 4,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue)!
        
        return createImageFromContext(context: resultContext, width: width, height: height)
    }
}
