//
//  GalleryService.swift
//  MemeCreator
//
//  Created by Fahad Alarefi on 8/4/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class GalleryService{
    
    // MARK: options
    let populateGallery = false // set to true to init gallery with dummy photos for demo
    
    // MARK: Category handling
    func fetchedResultsControllerForCategoryList() throws -> NSFetchedResultsController<Category> {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
        fetchRequest.fetchBatchSize = 15
        
        let context = persistentContainer.viewContext
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try resultsController.performFetch()
        
        return resultsController
    }
    
    func addCategory(withName name: String, andOrderIndex orderIndex: Int) throws -> Category{
        let context = persistentContainer.viewContext
        
        let category = Category(context: context)
        category.name = name
        category.orderIndex = orderIndex as NSNumber
        
        try context.save()
        
        return category
    }
    
    func renameCategory(_ category: Category, withNewName newName: String) throws {
        category.name = newName
        
        let context = persistentContainer.viewContext
        try context.save()
    }
    
    func delete(_ category: Category) throws {
        let context = persistentContainer.viewContext
        context.delete(category)
        
        try context.save()
    }
    
    func delete(_ meme: Meme) throws {
        let context = persistentContainer.viewContext
        context.delete(meme)
        
        try context.save()
    }
    
    func reindex(_ categories: Array<Category>, shiftForward: Bool) throws {
        for category in categories {
            let currentOrderIndex = category.orderIndex!.intValue
            if shiftForward {
                category.orderIndex = (currentOrderIndex + 1) as NSNumber
            }
            else {
                category.orderIndex = (currentOrderIndex - 1) as NSNumber
            }
        }
        
        let context = persistentContainer.viewContext
        try context.save()
    }
    
    // MARK: Memes handling
    
    func fetchedResultsControllerForMemes(in category: Category) throws -> NSFetchedResultsController<Meme> {
        let fetchRequest: NSFetchRequest<Meme> = Meme.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: dateKey, ascending: true)]
        
        let context = persistentContainer.viewContext
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try resultsController.performFetch()
        
        return resultsController
    }
    
    func addMeme(inCategory category: Category, memeUIImage meme: UIImage, memeBackgroundUsed memeName: String?, withTopText topText: String?, withBottomText bottomText: String?) throws -> Meme {
        let context = persistentContainer.viewContext
        
        let memeInfo = Meme(context: context)
        memeInfo.top_text = topText
        memeInfo.bottom_text = bottomText
        memeInfo.created_at = Date()
        memeInfo.category = category
        let imageObj = MemeImage(context: context)
        imageObj.image = UIImagePNGRepresentation(meme) as Data?
        memeInfo.meme = imageObj
        
        try context.save()
        
        return memeInfo
    }
    
    // MARK: Private var accessors
    
    func memeBackgroundsCount() -> Int {
        return memeBackgrounds.count
    }
    
    func memeBackgroundName(atIndex index: Int) -> String{
        return memeBackgrounds[index]
    }
    
    // MARK: Populate (dummy)
    
    func defaultCategory(context: NSManagedObjectContext) -> Category? {
        // NOT NEEDED ANYMORE
        // need to make sure that there is at least one category (this should be run when the app is first time opened)
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        //fetchRequest.predicate = NSPredicate(format: "isDefault == %@", NSNumber(booleanLiteral: true))
        fetchRequest.fetchLimit = 1
        
        guard let count = try? context.count(for: fetchRequest), count > 0 else {
            let category = Category(context: context)
            category.name = defaultCategoryName
            category.isDefault = true
            
            return category
        }
        
        var cat: Category? = nil
        
        do{
            let result = try context.fetch(fetchRequest)
            cat = result[0]
        } catch {
            print("failed to fetch a default category")
        }
        
        return cat
    }
    
    func randomCategory(context: NSManagedObjectContext) -> Category? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        var category: Category? = nil
        guard let count = try? context.count(for: fetchRequest), count > 0 else {
            return category
        }
        
        do{
            let result = try context.fetch(fetchRequest)
            let random = arc4random_uniform(UInt32(result.count))
            category = result[Int(random)]
        }catch{
            print("failed to fetch a random category")
        }
        
        
        return category
    }
    
    func populateModel(){
        let sampleImagesDataURL = Bundle.main.url(forResource: "SampleImages", withExtension: "plist")!
        let sampleImagesData = try! Data(contentsOf: sampleImagesDataURL)
        let sampleImages = try! PropertyListSerialization.propertyList(from: sampleImagesData, options: [], format: nil) as! Array<String>
        
        let fetchRequest: NSFetchRequest<Meme> = Meme.fetchRequest()
        let context = self.persistentContainer.newBackgroundContext()
        guard let count = try? context.count(for: fetchRequest), count == 0 else {
            return
        }
        
        for sampleImageName in sampleImages{
            if let category = self.randomCategory(context: context){
                let memeInfo = Meme(context: context)
                memeInfo.top_text = "Test text"
                memeInfo.bottom_text = "Test text"
                memeInfo.created_at = Date()
                memeInfo.category = category
                if let img = UIImage(named: sampleImageName) {
                    let imageObj = MemeImage(context: context)
                    imageObj.image = UIImagePNGRepresentation(img) as Data?
                    memeInfo.meme = imageObj
                }
            }
        }
        
        try! context.save()
    }
    
    // MARK: Initialization
    private init() {
        // prepare meme backgrounds
        let memeBackgroundsDataURL = Bundle.main.url(forResource: "MemeBackgrounds", withExtension: "plist")!
        let memeBackgroundsData = try! Data(contentsOf: memeBackgroundsDataURL)
        memeBackgrounds = try! PropertyListSerialization.propertyList(from: memeBackgroundsData, options: [], format: nil) as! Array<String>
        
        persistentContainer = NSPersistentContainer(name: "Model")
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let someError = error as NSError? {
                fatalError("Error loading persistent store \(someError)")
            }
            
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            if self.populateGallery == true{
                self.populateModel()
            }
            
        })
        
    }
    
    
    
    // MARK: Private
    private let persistentContainer: NSPersistentContainer
    private let memeBackgrounds: Array<String>
    
    // MARK: Properties (Private, Constant, Static)
    private let nameKey = "name"
    private let dateKey = "created_at"
    private let defaultCategoryName = "General"
    static let shared = GalleryService()
    
}
