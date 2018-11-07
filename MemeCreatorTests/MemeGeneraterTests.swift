//
//  MemeCreatorTests.swift
//  MemeCreatorTests
//
//  Created by Fahad Alarefi on 8/3/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import XCTest
@testable import MemeCreator

class MemeCreatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func countCategories() -> Int{
        var count = 0
        do{
            let fetchedResultsController = try GalleryService.shared.fetchedResultsControllerForCategoryList()
            count = fetchedResultsController.fetchedObjects?.count ?? 0
        } catch {
            XCTFail("failed to fetch categories list for count")
        }
        
        return count
    }
    
    func testAddCategory(){
        do{
            let category = try GalleryService.shared.addCategory(withName: "Unit Test Add Category", andOrderIndex: countCategories())
            XCTAssertEqual(category.name!, "Unit Test Add Category", "failed to add a category")
        }catch{
            XCTFail("failed to add a new category")
        }
    }
    
    func testRenameCategory(){
        do{
            
            let category = try GalleryService.shared.addCategory(withName: "Unit Test Category Unedited", andOrderIndex: countCategories())
            XCTAssertEqual(category.name!, "Unit Test Category Unedited", "failed to add a category")
            try GalleryService.shared.renameCategory(category, withNewName: "Unit Test Category Edited")
        }catch{
            XCTFail("failed to edit a category")
        }
    }
    
    func testDeleteCategory(){
        do{
            guard let category = try? GalleryService.shared.addCategory(withName: "Unit Test Category Delete", andOrderIndex: countCategories()) else{
                XCTFail("failed to add a category")
                return
            }
            
            XCTAssertEqual(category.name!, "Unit Test Category Delete", "failed to add a category")
            try GalleryService.shared.delete(category)
        }catch{
            XCTFail("failed to delete a category")
        }
    }
    
    func testFetchCategories(){
        testAddCategory()
        do{
            let fetchedResultsController = try GalleryService.shared.fetchedResultsControllerForCategoryList()
            let count = fetchedResultsController.fetchedObjects?.count ?? 0
            XCTAssertGreaterThan(count, 0, "failed to fetch an added category")
        } catch {
            XCTFail("failed to fetch categories list")
        }
    }
    
    func testAddMeme(){
        do{
            guard let category = try? GalleryService.shared.addCategory(withName: "Unit Test Add Meme", andOrderIndex: countCategories()) else{
                XCTFail("failed to add a category")
                return
            }
            guard let image = UIImage(named: "sampleImage1") else{
                XCTFail("failed to find a sample image for testing")
                return
            }
            
            _ = try GalleryService.shared.addMeme(inCategory: category, memeUIImage: image, memeBackgroundUsed: nil, withTopText: "test", withBottomText: "test")
        }catch{
            XCTFail("failed to add a meme")
        }
    }
    
    func testFetchMemes(){
        do{
            guard let category = try? GalleryService.shared.addCategory(withName: "Unit Test Fetch Memes", andOrderIndex: countCategories()) else{
                XCTFail("failed to add a category")
                return
            }
            
            guard let image = UIImage(named: "sampleImage1") else{
                XCTFail("failed to find a sample image for testing")
                return
            }
            
            do{
                _ = try GalleryService.shared.addMeme(inCategory: category, memeUIImage: image, memeBackgroundUsed: nil, withTopText: "test", withBottomText: "test")
            }catch{
                XCTFail("failed to add a meme")
                return
            }
            
            let fetchedResultsController = try GalleryService.shared.fetchedResultsControllerForMemes(in: category)
            let count = fetchedResultsController.fetchedObjects?.count ?? 0
            XCTAssertGreaterThan(count, 0, "failed to fetch an added meme")
        }catch{
            XCTFail("failed to fetch memes list")
        }
    }
    
    func testDeleteMeme(){
        do{
            guard let category = try? GalleryService.shared.addCategory(withName: "Unit Test Delete Meme", andOrderIndex: countCategories()) else{
                XCTFail("failed to add a category")
                return
            }
            
            guard let image = UIImage(named: "sampleImage1") else{
                XCTFail("failed to find a sample image for testing")
                return
            }
            
            var meme: Meme?
            
            do{
                meme = try GalleryService.shared.addMeme(inCategory: category, memeUIImage: image, memeBackgroundUsed: nil, withTopText: "test", withBottomText: "test")
            }catch{
                XCTFail("failed to add a meme")
                return
            }
            
            try GalleryService.shared.delete(meme!)
        }catch{
            XCTFail("failed to fetch memes list")
        }
    }
}
