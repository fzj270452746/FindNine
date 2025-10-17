

import Foundation
import DateToolsSwift

struct YouxiJiluModel: Codable {
    var nineFenshu: Int
    var nineShijian: Date
    var nineYongshi: Int // seconds used
    var nineGameMode: GameMode // game mode

    func findFormattedDate() -> String {
        return nineShijian.format(with: "MM.dd HH:mm")
    }

    func findModeDisplayName() -> String {
        return nineGameMode.displayName()
    }
}

class JiluGuanliqi {
    static let shared = JiluGuanliqi()
    private let nineKey = "GameRecordsKey"
    
    private init() {}
    
    func findSaveRecord(nineRecord: YouxiJiluModel) {
        var nineRecords = findAllRecords()
        nineRecords.insert(nineRecord, at: 0)
        
        // Keep only last 50 records
        if nineRecords.count > 50 {
            nineRecords = Array(nineRecords.prefix(50))
        }
        
        if let nineData = try? JSONEncoder().encode(nineRecords) {
            UserDefaults.standard.set(nineData, forKey: nineKey)
        }
    }
    
    func findAllRecords() -> [YouxiJiluModel] {
        guard let nineData = UserDefaults.standard.data(forKey: nineKey),
              let nineRecords = try? JSONDecoder().decode([YouxiJiluModel].self, from: nineData) else {
            return []
        }
        return nineRecords
    }
    
    func findClearAllRecords() {
        UserDefaults.standard.removeObject(forKey: nineKey)
    }
}

