import AppKit

class MatrixFilters: Filters {
    var matrix: [Int]
    var divisor: Int
    
    init(matrix: [Int], divisor: Int) {
        self.matrix = matrix
        self.divisor = divisor
    }
    
    override func processImage(buffer: UnsafeMutableBufferPointer<UInt8>,
                               width: Int,
                               height: Int,
                               colorSpace: CGColorSpace,
                               bitmapInfo: CGBitmapInfo) -> NSImage {
        
        let matrixSize = Int(sqrt(Double(matrix.count)))
        let matrixOffset = (matrixSize - 1) / 2
        
        let resultBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: width * height * 4)
        
        defer { resultBuffer.deallocate() }
        
        for y in 0..<height {
            for x in 0..<width {
                var r = 0
                var g = 0
                var b = 0
                var count = 0
                
                for i in 0..<matrix.count {
                    let row = (i / matrixSize) - matrixOffset
                    let col = (i % matrixSize) - matrixOffset
                    let pixelX = x + col
                    let pixelY = y + row
                    
                    if pixelX >= 0 && pixelX < width && pixelY >= 0 && pixelY < height {
                        let index = (pixelY * width + pixelX) * 4
                        r += Int(buffer[index]) * matrix[i]
                        g += Int(buffer[index+1]) * matrix[i]
                        b += Int(buffer[index+2]) * matrix[i]
                        count += 1
                    }
                }
                
                let index = (y * width + x) * 4
                resultBuffer[index] = UInt8(max(0, min(255, r / divisor)))
                resultBuffer[index+1] = UInt8(max(0, min(255, g / divisor)))
                resultBuffer[index+2] = UInt8(max(0, min(255, b / divisor)))
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
