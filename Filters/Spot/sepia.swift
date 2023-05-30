import AppKit

class SepiaFilter: Filters {
    override func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                               width: Int,
                               height: Int,
                               colorSpace: CGColorSpace,
                               bitmapInfo: CGBitmapInfo) -> NSImage {
        
        for i in stride(from: 0, to: buffer.count, by: 4) {
            let red = Double(buffer[i])
            let green = Double(buffer[i+1])
            let blue = Double(buffer[i+2])
            
            let r = 0.393 * red + 0.769 * green + 0.189 * blue
            let g = 0.349 * red + 0.686 * green + 0.168 * blue
            let b = 0.272 * red + 0.534 * green + 0.131 * blue
            
            buffer[i] = UInt8(min(r, 255))
            buffer[i+1] = UInt8(min(g, 255))
            buffer[i+2] = UInt8(min(b, 255))
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
