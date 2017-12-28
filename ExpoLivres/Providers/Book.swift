import CoreData

class Book: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var sku: String
    
    static let entityName = "Book"
    
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
    
    class func all(inContext context: NSManagedObjectContext) -> [Book] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            return try context.fetch(fetchRequest) as! [Book]
            
        } catch {
            print("Error fetching books: \(error)")
            return []
        }
    }
}
