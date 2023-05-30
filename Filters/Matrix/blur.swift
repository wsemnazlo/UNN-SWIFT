class BlurFilter: MatrixFilters {
    init() {
        super.init(matrix: [1, 1, 1,
                            1, 1, 1,
                            1, 1, 1], divisor: 9)
    }
}
