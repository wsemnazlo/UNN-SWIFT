class GaussianFilter: MatrixFilters {
    init() {
        super.init(matrix: [1, 2, 1,
                            2, 4, 2,
                            1, 2, 1], divisor: 16)
    }
}
