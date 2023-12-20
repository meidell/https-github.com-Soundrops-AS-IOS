

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext()  -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    //for User Entity
    class func saveObject(name: String, gender: String, age: String, organisation: String, id: String, audio: Int, country: String, myID: String, mymail: String, myaccept: String) -> Bool {


        let context = CoreDataHandler.getContext()
        let entity  = NSEntityDescription.entity(forEntityName: "User", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)

        manageObject.setValue(age, forKey: "age")
        manageObject.setValue(name, forKey: "name")
        manageObject.setValue(gender, forKey: "gender")
        manageObject.setValue(organisation, forKey: "organisation")
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(audio, forKey: "audio")
        manageObject.setValue(country, forKey: "country")
        manageObject.setValue(myID, forKey: "channel")
        manageObject.setValue(mymail, forKey: "email")
        manageObject.setValue(myaccept, forKey: "accept")

        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }


    class func deleteObject() {

        let context = CoreDataHandler.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
    
    
    class func fetchObject() -> [User]? {
        let context = CoreDataHandler.getContext()
        var user:[User]? = nil
        do {
            user = try context.fetch(User.fetchRequest())
            return user
        }catch{
            return user
        }
    }
    
    

    ///for Channels entity
    class func saveObjectChannel(name: String) -> Bool {
        let context = CoreDataHandler.getContext()
        let entity  = NSEntityDescription.entity(forEntityName: "Channels", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)

        manageObject.setValue(name, forKey: "name")

        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }


    class func deleteObjectChannels() {

        let context = CoreDataHandler.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Channels")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }


    class func fetchObjectChannels() -> [Channels]? {

        let context = CoreDataHandler.getContext()
        var channel:[Channels]? = nil
        do {
            channel = try context.fetch(Channels.fetchRequest())
            return channel
        }catch{
            return channel
        }
    }

    

}
