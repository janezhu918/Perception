import Foundation

final class DataPersistenceManager {
    private init() {}
    
    public static func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public static func filepathToDocumentsDirectory(filename: String) -> URL {
        return documentsDirectory().appendingPathComponent(filename)
    }
    
    public static func filepathToTempDirectory(filename: String) -> URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent(filename)
    }
}
