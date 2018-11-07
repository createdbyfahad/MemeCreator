//
//  SecondViewController.swift
//  MemeGenerater
//
//  Created by Fahad Alarefi on 8/3/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CategoryDetailViewControllerDelegate,  MemeBackgroundPickerControllerDelegate{
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var catPicker: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Properties (Private)
    private var categoryPickerView: UIPickerView = UIPickerView()
    private var categoriesResultsController: NSFetchedResultsController<Category>?
    private var topText: String?
    private var bottomText: String?
    private var picture: UIImage? {
        didSet{
            if let somePicture = picture {
                imageView.image = somePicture
            } else {
                imageView.image = nil
            }
        }
    }
    private var originalPicture: UIImage? {
        didSet {
            renderMeme()
        }
    }
    private var backgroundName: String?
    private var pickedCategory: Category? {
        didSet {
            if let someCategory = pickedCategory {
                catPicker.text = someCategory.name
            }
            else {
                catPicker.text = ""
            }
        }
    }
    
    // MARK: Properties (options)
    private var resizeMemeMaxSize:CGFloat = 700
    private var increaseTextSizeLabel = "Bigger"
    private var decreaseTextSizeLabel = "Smaller"
    private var defaultTextSize = 40
    private var maxTextSize = 58
    private var minTextSize = 22
    private var topTextSize: Int = 0 {
        didSet{
            renderMeme()
        }
    }
    private var bottomTextSize: Int = 0 {
        didSet{
            renderMeme()
        }
    }
    
    // MARK: Actions
    @IBAction func unwindToThisView(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func textFieldDidEnd(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func textField(_ sender: Any) {
        let textField = sender as! UITextField
        switch textField.tag {
        case 0:
            self.topText = textField.text
        case 1:
            self.bottomText = textField.text
        default:
            break
        }
        
        // rerender the image
        renderMeme()
        
    }
    
    @IBAction func redoMeme(_ sender: Any){
        // reset all variables
        self.topText = nil
        self.bottomText = nil
        self.pickedCategory = nil
        self.picture = nil
        self.originalPicture = nil
        self.imageView.image = nil
        self.topTextSize = defaultTextSize
        self.bottomTextSize = defaultTextSize
        self.bottomTextField.text = nil
        self.topTextField.text = nil
        self.categoryPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func saveMeme(_ sender: Any){
        
        guard let somePicture = self.picture else {
            let alertController = UIAlertController(title: "Failed to save", message: "Please choose an image first (by tapping below).", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let someCategory = self.pickedCategory else{
            let alertController = UIAlertController(title: "Failed to save", message: "Please choose a category first (or create a new one).", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // prepare the data to be added to core data
        do{
            _ = try GalleryService.shared.addMeme(inCategory: someCategory, memeUIImage: somePicture, memeBackgroundUsed: self.backgroundName, withTopText: self.topText, withBottomText: self.bottomText)
            let alertController = UIAlertController(title: "Save succeeded", message: "The new meme has been saved. Start a new meme?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Clear", style: .cancel) { (alert) in
                self.redoMeme(self)
            })
            
            alertController.addAction(UIAlertAction(title: "Return", style: .default, handler: nil))
                
            present(alertController, animated: true, completion: nil)
        } catch {
            let alertController = UIAlertController(title: "Save failed", message: "Failed to save the new meme", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    

    // MARK: UIPickerViewDataSource, UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let count = categoriesResultsController?.sections?[component].numberOfObjects ?? 0
        return count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 { return "" }
        return categoriesResultsController!.object(at: IndexPath(row: row - 1, section: 0)).name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0){
            pickedCategory = nil
        }else if let count = categoriesResultsController!.fetchedObjects?.count, count > 0{
            pickedCategory = categoriesResultsController!.object(at: IndexPath(row: row - 1, section: 0))
        }
    }
    
    
    // MARK: CategoryDetailViewControllerDelegate
    func initialOrderIndexForCategoryDetailViewController(_ categoryDetailViewController: CategoryDetailViewController) -> Int {
        return categoryPickerView.numberOfRows(inComponent: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCategorySegue" {
            let navigationController = segue.destination as! UINavigationController
            let categoryDetailViewController = navigationController.topViewController as! CategoryDetailViewController
            categoryDetailViewController.delegate = self
        }else if segue.identifier == "MemeBackgroundPickerSegue" {
            let MemeBackgroundPickerViewController = segue.destination as! MemeBackgroundPickerViewController
            MemeBackgroundPickerViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: MemeBackgroundPickerControllerDelegate
    func userDidPickMemeBackground(_ imageName: String) {
        self.picture = UIImage(named: imageName)
        self.originalPicture = UIImage(named: imageName)
        self.backgroundName = imageName
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // First check for an edited image, then the original image
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            originalPicture = image
            self.backgroundName = nil
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalPicture = image
            self.backgroundName = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: ImagePicker
    private func imagePickerControllerSourceTypeActionHandler(for sourceType: UIImagePickerControllerSourceType) -> (_ action: UIAlertAction) -> Void {
        return { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.mediaTypes = [kUTTypeImage as String] // Import the MobileCoreServices framework to use kUTTypeImage (see top of file)
            imagePickerController.allowsEditing = true
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func presentMemeBackgroundPicker(for sourceType: UIImagePickerControllerSourceType) -> (_ action: UIAlertAction) -> Void{
        return { (action) in
            self.performSegue(withIdentifier: "MemeBackgroundPickerSegue", sender: self)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let alertController = UIAlertController(title: "Image Source", message: "Pick Image Source", preferredStyle: .actionSheet)
        let checkSourceType = { (sourceType: UIImagePickerControllerSourceType, buttonText: String) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: self.imagePickerControllerSourceTypeActionHandler(for: sourceType)))
            }
        }
        
        checkSourceType(.photoLibrary, "Photo Library")
        
        // action for choosing the background
        alertController.addAction(UIAlertAction(title: "Choose from list", style: .default, handler: self.presentMemeBackgroundPicker(for: .camera)))
        
        
        if !alertController.actions.isEmpty {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryPickerView.reloadAllComponents()
    }
    
    
    @objc func catPickerDidFinish(_ sender: Any){
        view.endEditing(true)
    }
    
    
    // MARK: Handle Meme Actions
    @objc func changeTopTextFieldSize(_ sender: Any){
        let barButtonItem = sender as! UIBarButtonItem
        let title = barButtonItem.title!
        if(title == decreaseTextSizeLabel && topTextSize > minTextSize){
            topTextSize -= 2
        }else if(title == increaseTextSizeLabel && topTextSize < maxTextSize){
            topTextSize += 2
        }
        
    }
    
    @objc func changeBottomTextFieldSize(_ sender: Any){
        let barButtonItem = sender as! UIBarButtonItem
        let title = barButtonItem.title!
        if(title == decreaseTextSizeLabel && bottomTextSize > minTextSize){
            bottomTextSize -= 2
        }else if(title == increaseTextSizeLabel && bottomTextSize < maxTextSize){
            bottomTextSize += 2
        }
    }
    
    func renderMeme(){
        if let somePicture = originalPicture{
            let newPicture = applyTextOnMeme(inMeme: somePicture, withTopText: self.topText ?? "", withBottomText: self.bottomText ?? "", withTopTextSize: self.topTextSize, withBottomTextSize: self.bottomTextSize)
            picture = newPicture
        }
    }
    
    func resizeMemeWith(newSize: CGSize, meme: UIImage) -> UIImage {
        
        let horizontalRatio = newSize.width / meme.size.width
        let verticalRatio = newSize.height / meme.size.height
        
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: meme.size.width * ratio, height: meme.size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        meme.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newMeme = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newMeme!
    }
    
    func applyTextOnMeme(inMeme unscaledMeme: UIImage, withTopText topTextOrigianl: String, withBottomText bottomTextOriginal: String, withTopTextSize topTextSize: Int, withBottomTextSize bottomTextSize: Int) -> UIImage {
        let textColor = UIColor.white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        var meme = unscaledMeme
        
        if(unscaledMeme.size.height > resizeMemeMaxSize || unscaledMeme.size.width > resizeMemeMaxSize){
            // resize the meme if it's large
            meme = resizeMemeWith(newSize: CGSize(width: 700, height: 700), meme: unscaledMeme)
        }
        
        let topText = topTextOrigianl.uppercased()
        let bottomText = bottomTextOriginal.uppercased()
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(meme.size, false, scale)

        
        let topTextFontAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Impact", size: CGFloat(topTextSize))!,
            NSAttributedStringKey.foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.strokeWidth: -6
            ] as [NSAttributedStringKey : Any]
        
        let bottomTextFont = UIFont(name: "Impact", size: CGFloat(bottomTextSize))!
        
        let bottomTextFontAttributes = [
            NSAttributedStringKey.font: bottomTextFont,
            NSAttributedStringKey.foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.strokeWidth: -6
            ] as [NSAttributedStringKey : Any]
        
        let topTextPoint = CGPoint(x: 0, y: 10)
        let bottomTextPoint = CGPoint(x: 0, y: meme.size.height - (bottomTextFont.lineHeight) - 20)
        
        meme.draw(in: CGRect(origin: CGPoint.zero, size: meme.size))
        
        let topRect = CGRect(origin: topTextPoint, size: meme.size)
        let bottomRect = CGRect(origin: bottomTextPoint, size: meme.size)

        topText.draw(in: topRect, withAttributes: topTextFontAttributes)
        
        bottomText.draw(in: bottomRect, withAttributes: bottomTextFontAttributes)
        
        let newMeme = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newMeme!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the category list
        categoriesResultsController = try! GalleryService.shared.fetchedResultsControllerForCategoryList()
        categoriesResultsController?.delegate = self
        
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        if(imageView?.image == nil){
            // the view has no image, so present a choose background image modal?
            
        }
        
        var toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CreateViewController.catPickerDidFinish(_:)))]
        catPicker.inputView = categoryPickerView
        catPicker.inputAccessoryView = toolbar
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: decreaseTextSizeLabel, style: .done, target: self, action: #selector(CreateViewController.changeTopTextFieldSize(_:))), UIBarButtonItem(title: increaseTextSizeLabel, style: .done, target: self, action: #selector(CreateViewController.changeTopTextFieldSize(_:)))]
        topTextField.inputAccessoryView = toolbar
        
        toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: decreaseTextSizeLabel, style: .done, target: self, action: #selector(CreateViewController.changeBottomTextFieldSize(_:))), UIBarButtonItem(title: increaseTextSizeLabel, style: .done, target: self, action: #selector(CreateViewController.changeBottomTextFieldSize(_:)))]
        bottomTextField.inputAccessoryView = toolbar
        
        topTextSize = defaultTextSize
        bottomTextSize = defaultTextSize
        
        categoryPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    
    
    

}

