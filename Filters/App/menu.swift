import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var isApplyingFilter = false
    @State private var filterExecutionTime: TimeInterval = 0
    @State private var undoStack: [(NSImage, TimeInterval)] = [] // стек изменений
    private let allowedFileTypes: [UTType] = [.png, .jpeg]

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Изображение не выбрано")
            }
            
            if isApplyingFilter {
                ProgressView()
                Text("Применение фильтра...")
            }
            
            if filterExecutionTime > 0 {
                Text(String(format: "Фильтр применен за %.2f секунд", filterExecutionTime))
                Button(action: undoLastChange, label: {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Отменить")
                })
                .keyboardShortcut("z", modifiers: [.command])
            }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup {
                Button(action: openImage, label: {
                    Image(systemName: "folder")
                    Text("Открыть изображение")
                })
                .keyboardShortcut(.defaultAction)
                
                Button(action: deleteImage, label: {
                    Image(systemName: "trash")
                    Text("Удалить изображение")
                })
                .keyboardShortcut(.delete)
                .disabled(selectedImage == nil)
                
                Spacer()
                
                Menu("Выбрать действие") {
                    
                    Button("Инвертировать", action: applyInvertFilter)
                        .help("Инвертировать цвета изображения")
                    
                    Button("Оттенки серого", action: applyGrayScaleFilter)
                        .help(" ")
                    
                    Button("Сепия", action: applySepiaFilter)
                        .help(" ")
                    
                    Button("Увеличить яркость", action: applyBrightnessFilter)
                        .help("Увеличить яркость изображения")
                    
                    Divider()
                    
                    Button("Размыть", action: applyBlurFilter)
                        .help("Применить матричный фильтр к изображению")
                    
                    Button("Фильтр Гаусса", action: applyGaussianFilter)
                        .help("Применить матричный фильтр к изображению")
                    
                    Button("Фильтр Собеля", action: applySobelFilter)
                        .help("Применить матричный фильтр к изображению")
                }
                .help("Произвести действие над изображением")
                .disabled(selectedImage == nil)
            }
        }
    }

    private func openImage() {
        let dialog = NSOpenPanel()
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowedContentTypes = allowedFileTypes
        
        if dialog.runModal() == .OK {
            if let url = dialog.urls.first {
                selectedImage = NSImage(contentsOf: url)
                filterExecutionTime = 0
                undoStack = []
            }
        }
    }

    private func deleteImage() {
        selectedImage = nil
        filterExecutionTime = 0
        undoStack = []
    }

    private func applyInvertFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true
        
        let startTime = Date()
        let filter = InvertFilter()
        let resultImage = filter.processImage(image: image)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applyGrayScaleFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true
        
        let startTime = Date()
        let filter = GrayFilter()
        let resultImage = filter.processImage(image: image)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applySepiaFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true
        
        let startTime = Date()
        let filter = SepiaFilter()
        let resultImage = filter.processImage(image: image)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applyBrightnessFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true

        let startTime = Date()
        let filter = BrightnessFilter()
        let resultImage = filter.processImage(image: image)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applyBlurFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true

        let startTime = Date()
        let filter = BlurFilter()
        let resultImage = filter.processImage(image: image)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applyGaussianFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true

        let startTime = Date()
        let filter = GaussianFilter()
        let resultImage = filter.processImage(image: image)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applySharpenFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true

        let startTime = Date()
        let filter = SharpenFilter()
        let resultImage = filter.processImage(image: image)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }
    
    private func applySobelFilter() {
        filterExecutionTime = 0
        guard let image = selectedImage else { return }
        isApplyingFilter = true

        let startTime = Date()
        let filter = SobelFilter()
        let resultImage = filter.processImage(image: image)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let prevImage = self.selectedImage
            self.selectedImage = resultImage
            self.isApplyingFilter = false
            self.filterExecutionTime = Date().timeIntervalSince(startTime)
            self.undoStack.append((prevImage!, self.filterExecutionTime))
        }
    }

    private func undoLastChange() {
        guard let lastChange = undoStack.popLast() else { return }
        let prevImage = lastChange.0
    
        selectedImage = prevImage
        filterExecutionTime = 0
    }
}
