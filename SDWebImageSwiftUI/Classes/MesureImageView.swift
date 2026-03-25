import SDWebImage
import SwiftUI



public struct WebImageDebugOption {
    public static var enableDebug = false
    public static var maxFileSize: Int = 1024 * 300 * 3  //300kb
    public static var maxMemeoryCost: Int = 1024 * 1024 * 3  //3MB
}


struct MesureImageView: View {
    @ObservedObject private var imageManager: ImageManager
    
    public init(imageManager: ImageManager) {
        self.imageManager = imageManager
    }
    
    private var imageSize: CGSize {
        imageManager.image?.size ?? .zero
    }
    
    private var byteCount: Int {
        imageManager.image?.sd_imageData()?.count ?? 0
    }
    
    private var memoryCost: Int {
        
        Int(imageManager.image?.sd_memoryCost ?? 0)
    }
    
    var body: some View {
        let size = imageSize
        let fileSize = byteCount
        let memory = memoryCost
        VStack(spacing: 0){
            Spacer()
            Text("\(Int(size.width))x\(Int(size.height))")
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 10))
                .padding(.horizontal,1)
                .background(Capsule().fill(.black.opacity(0.6)))
            Text(formatFileSize(fileSize,memCost: false))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 10))
                .padding(.horizontal,1)
                .background(warningSize(count: fileSize))
            Text(formatFileSize(memory,memCost: true))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 10))
                .padding(.horizontal,1)
                .background(warningCost(count: memory))
            Spacer()
        }
    }
    
    
    @ViewBuilder
    private func warningSize(count: Int) -> some View {
        if count >= WebImageDebugOption.maxFileSize {
            Capsule().fill(.red)
        } else {
            Capsule().fill(.black.opacity(0.8))
        }
    }
    
    @ViewBuilder
    private func warningCost(count: Int) -> some View {
        if count >= WebImageDebugOption.maxMemeoryCost { 
            Capsule().fill(.red)
        } else {
            Capsule().fill(.black.opacity(0.8))
        }
    }
        
    
    
    func formatFileSize(_ fileSize: Int, memCost: Bool) -> String {
        let sizeInBytes = Double(fileSize)
        var result = ""
        if !memCost && sizeInBytes >= Double(WebImageDebugOption.maxFileSize) {
            result += "⚠️"
        }else if memCost && sizeInBytes >= Double(WebImageDebugOption.maxMemeoryCost){
            result += "⚠️"
        }
        
        if sizeInBytes > 1024 * 1024 {
            result += String(format: "%.2fM", sizeInBytes / 1024 / 1024)
        } else if sizeInBytes > 1024 {
            result += String(format: "%.2fKB", sizeInBytes / 1024)
        } else {
            result += String(format: "%.2fB", sizeInBytes)
        }
        return result
    }
}


