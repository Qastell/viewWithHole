//
//  ViewController.swift
//  imagePicker
//
//  Created by Кирилл Романенко on 16.01.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let imageView: ViewWithHole = {
        let imageView = ViewWithHole()
        
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setView()
    }

    func setView() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView))
        imageView.addGestureRecognizer(tapImageView)
        imageView.isUserInteractionEnabled = true
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
    @objc func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showAlert()
    }

    //Show alert to selected the media source type.
    private func showAlert() {

        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) { [weak self] in

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            self?.imageView.image = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


class ViewWithHole: UIImageView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = bounds.size.width
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), cornerRadius: layer.cornerRadius)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: radius, height: radius), cornerRadius: radius / 2)
        path.append(circlePath)
        path.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        fillLayer.opacity = 0.5
        layer.addSublayer(fillLayer)
    }
    
}
