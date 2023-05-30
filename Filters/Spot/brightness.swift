import AppKit

class BrightnessFilter: Filters {
    override func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                               width: Int,
                               height: Int,
                               colorSpace: CGColorSpace,
                               bitmapInfo: CGBitmapInfo) -> NSImage {
        
        for i in stride(from: 0, to: buffer.count, by: 4) {
            let r = buffer[i]
            let g = buffer[i+1]
            let b = buffer[i+2]
            
            let brightness = UInt8(min(255, max(0, Int(r) + Int(g) + Int(b))))
            
            buffer[i] = UInt8(min(255, Int(r) + Int(brightness)))
            buffer[i+1] = UInt8(min(255, Int(g) + Int(brightness)))
            buffer[i+2] = UInt8(min(255, Int(b) + Int(brightness)))
        }
        
        let resultContext = CGContext(data: buffer.baseAddress,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue)!
        
        return createImageFromContext(context: resultContext, width: width, height: height)
    }
}
