//
//  ModalViewController.swift
//  CoreDataTest
//
//  Created by Pedro Ésli Vieira do Nascimento on 14/10/21.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var glucoseLevelTextField: UITextField!
    var complitionHandler: ((Int,UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { action in
            self.showImagePickerController(fromCamera: false)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { action in
            self.showImagePickerController(fromCamera: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let text = glucoseLevelTextField.text,
              let glucoseLevel = Int(text) else{
                  return
              }
        complitionHandler?(glucoseLevel, imageView.image)
        dismiss(animated: true)
    }
}

extension ModalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func showImagePickerController(fromCamera: Bool = false){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        //Para poder editar a imagem antes de ser selecionada
        imagePickerController.allowsEditing = true
        if fromCamera{
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = editedImage
        print("\(editedImage.size.width), \(editedImage.size.height)")
        dismiss(animated: true, completion: nil)
    }
}
