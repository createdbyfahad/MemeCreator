//
//  CategoryDetailViewController.swift
//  MemeCreator
//

import UIKit


class CategoryDetailViewController: UITableViewController, UITextFieldDelegate {
	// MARK: IBAction
	@IBAction private func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
	}

	@IBAction private func save(_ sender: Any) {
		let orderIndex = delegate.initialOrderIndexForCategoryDetailViewController(self)
		do {
			_ = try GalleryService.shared.addCategory(withName: name, andOrderIndex: orderIndex)
            dismiss(animated: true, completion: nil)
		}
		catch _ {
			let alertController = UIAlertController(title: "Save failed", message: "Failed to save the gallery", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}

	// MARK: UITableViewDelegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		nameTextField.becomeFirstResponder()
	}

	// MARK: UITextFieldDelegate
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		name = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		nameTextField.resignFirstResponder()

		return false
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if selectedCategory != nil {
			navigationItem.title = "Edit Category"
			navigationItem.leftBarButtonItem = nil
			navigationItem.rightBarButtonItem = nil
		}
		else {
			navigationItem.title = "Add Category"
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CategoryDetailViewController.cancel(_:)))
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CategoryDetailViewController.save(_:)))
		}

		nameTextField.text = name
	}

	override func viewWillDisappear(_ animated: Bool) {
		defer {
			super.viewWillDisappear(animated)
		}

		guard let someCategory = selectedCategory else {
			return
		}

		do {
			try GalleryService.shared.renameCategory(someCategory, withNewName: name)
		}
		catch _ {
			let alertController = UIAlertController(title: "Save failed", message: "Failed to save gallery", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}

	// MARK: Properties
	var selectedCategory: Category? {
		didSet {
			if let someCategory = selectedCategory {
				name = someCategory.name!
			}
			else {
				name = CategoryDetailViewController.defaultName
			}
		}
	}
	var delegate: CategoryDetailViewControllerDelegate!

	// MARK: Properties (Private)
	private var name = CategoryDetailViewController.defaultName

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var nameTextField: UITextField!

	// MARK: Properties (Private Static Constant)
	private static let defaultName = "New Category"
}
