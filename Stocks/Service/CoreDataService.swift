//
//  CoreDataService.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    @Published var watchlist: [Stock] = []
    @Published var symbols: [Symbol] = []

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

    static var previewStock: Stock = {
        let viewContext = CoreDataService.preview.container.viewContext
        let stock = Stock(context: viewContext)
        stock.symbol = "AAPL"
        stock.name = "Apple Inc."
        stock.price = 140
        stock.changePercent = 1.99
        stock.logoURL = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png"
        return stock
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

    func filterSymbols(searchTerm: String) {
        let context = container.viewContext
        let request = Symbol.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS %@", searchTerm)
        do {
            symbols = try context.fetch(request)
        } catch { print("Error filtering symbols") }
        save()
    }

    func clearSymbols() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Symbol")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try container.viewContext.execute(deleteRequest)
            save()
        } catch {
            print("Error clearing symbols")
        }
    }

    func storeSymbols(symbols: Symbols) {
        clearSymbols()
        symbols.forEach { element in
            let symbol = Symbol(context: container.viewContext)
            symbol.name = element.name
            symbol.symbol = element.symbol
        }
        save()
        fetchSymbols()
    }

    func fetch() {
        let context = container.viewContext
        let request = Stock.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "userOrder", ascending: true)]
        do {
            watchlist = try context.fetch(request)
        } catch { print(error) }
    }

    func fetchSymbols() {
        let context = container.viewContext
        let request = Symbol.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "symbol", ascending: true)]
        do {
            symbols = try context.fetch(request)
        } catch { print(error) }
    }

    func add(symbol: String, name: String, logoURL: String) {
        let stock = Stock(context: container.viewContext)
        stock.symbol = symbol
        stock.name = name
        stock.logoURL = logoURL
        save()
    }

    func delete(offsets: IndexSet) {
        offsets.forEach {
            let stock = watchlist[$0]
            container.viewContext.delete(stock)
        }
        save()
    }

    func update(stock: Stock, quote: Quote) {
        stock.price = quote.latestPrice
        stock.change = quote.change ?? 0
        stock.changePercent = (quote.changePercent ?? 0) * 100
        save()
    }

    func move(source: IndexSet, destination: Int) {
        var revisedWatchlist: [Stock] = watchlist.map { $0 }
        revisedWatchlist.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride(from: revisedWatchlist.count - 1, through: 0, by: -1) {
            revisedWatchlist[reverseIndex].userOrder = Int16(reverseIndex)
        }
        save()
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
            fetch()
        }
    }
}
