import CoreData

class Book: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var sku: String
    
    static let entityName = "Book"
    
    
    class func createWith(title: String, sku: String, inContext context: NSManagedObjectContext) -> Book {
        let newBook = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Book
        
        newBook.title = title
        newBook.sku = sku
        
        return newBook
    }
    
    class func withSku(_ sku: String, inContext context: NSManagedObjectContext) -> Book? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "sku == %@", sku)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest) as! [Book]
            return results.first
            
        } catch {
            print("Error fetching books: \(error)")
            return nil
        }
    }
    
    class func deleteAll(inContext context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        
        let books = try! context.fetch(fetchRequest) as! [Book]
        
        for book in books {
            context.delete(book)
        }

    }
    
    class func insertFromDictionaries(_ bookDictionaries: [Dictionary<String, String>],
        inContext context: NSManagedObjectContext) throws
    {
        for bookDictionary in bookDictionaries {
            guard let title = bookDictionary["title"] else { throw AppError.parsingJSONAttribute(attribute: "title", forEntity: "Book") }
            guard let sku = bookDictionary["sku"] else { throw AppError.parsingJSONAttribute(attribute: "sku", forEntity: "Book") }
            let _ = Book.createWith(title: title, sku: sku, inContext: context)
        }
    }
}
