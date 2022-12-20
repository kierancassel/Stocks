//
//  CoreDataManager.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Stocks")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    static var previewStock: Stock = {
        let viewContext = CoreDataManager.preview.container.viewContext
        let stock = Stock(context: viewContext)
        stock.symbol = "AAPL"
        stock.name = "Apple Inc"
        stock.price = 140
        stock.changePercent = 1.99
        stock.logoURL = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png"
        return stock
    }()
}
