import AppKit
class InvertFilter: Filters {
    override func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                               width: Int,
                               height: Int,
                               colorSpace: CGColorSpace,
                               bitmapInfo: CGBitmapInfo) -> NSImage {

        for i in stride(from: 0, to: buffer.count, by: 4) {
            buffer[i] = 255 - buffer[i]
            buffer[i+1] = 255 - buffer[i+1]
            buffer[i+2] = 255 - buffer[i+2]
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
