class SharpenFilter: MatrixFilters {
    init() {
        super.init(matrix: [-1, -1, -1,
                            -1,  9, -1,
                            -1, -1, -1], divisor: 1)
    }
}
