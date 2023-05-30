import AppKit

class SobelFilter: MatrixFilters {
    init() {
        super.init(matrix: [-1, 0, 1,
                            -2, 0, 2,
                            -1, 0, 1], divisor: 1)
    }

    override func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                               width: Int,
                               height: Int,
                               colorSpace: CGColorSpace,
                               bitmapInfo: CGBitmapInfo) -> NSImage {
        
        let matrixSize = matrix.count
        let matrixOffset = matrixSize / 2
        
        let resultBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: width * height * 4)
        
        defer { resultBuffer.deallocate() }

        for y in 0..<height {
            for x in 0..<width {
                var rX = 0
                var gX = 0
                var bX = 0
                var rY = 0
                var gY = 0
                var bY = 0

                for i in 0..<matrixSize {
                    let row = (i / matrixSize) - matrixOffset
                    let col = (i % matrixSize) - matrixOffset
                    let pixelX = x + col
                    let pixelY = y + row

                    if pixelX >= 0 && pixelX < width && pixelY >= 0 && pixelY < height {
                        let index = (pixelY * width + pixelX) * 4
                        rX += Int(buffer[index]) * matrix[i]
                        gX += Int(buffer[index+1]) * matrix[i]
                        bX += Int(buffer[index+2]) * matrix[i]
                        rY += Int(buffer[index]) * matrix[i]
                        gY += Int(buffer[index+1]) * matrix[i]
                        bY += Int(buffer[index+2]) * matrix[i]
                    }
                }

                let index = (y * width + x) * 4
                let r = Int(sqrt(Double(rX * rX + rY * rY)))
                let g = Int(sqrt(Double(gX * gX + gY * gY)))
                let b = Int(sqrt(Double(bX * bX + bY * bY)))
                resultBuffer[index] = UInt8(max(0, min(255, r)))
                resultBuffer[index+1] = UInt8(max(0, min(255, g)))
                resultBuffer[index+2] = UInt8(max(0, min(255, b)))
                resultBuffer[index+3] = buffer[index+3]
            }
        }

        let resultContext = CGContext(data: resultBuffer.baseAddress,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue)!
        
        return createImageFromContext(context: resultContext, width: width, height: height)
    }
}
