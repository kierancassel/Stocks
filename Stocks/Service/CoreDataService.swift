//
//  Persistence.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    @Published var stocks: [Stock] = []

    static var preview: CoreDataService = {
        let result = CoreDataService(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newStocks = Stock(context: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
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
        fetch()
    }

    func save() {
        let context = CoreDataService.shared.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            fetch()
        }
    }

    func fetch() {
        let context = container.viewContext
        let request = Stock.fetchRequest()
        do {
            stocks = try context.fetch(request)
        } catch { print(error) }
    }
}