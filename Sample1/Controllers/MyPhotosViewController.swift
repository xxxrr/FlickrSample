//
//  MyPhotosViewController.swift
//  Sample1
//
//  Created by Roopa Raman on 4/2/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import AVFoundation
class MyPhotosViewController: UIViewController {
    @IBOutlet weak var collectionView : UICollectionView?
    @IBOutlet weak var loadingView : UIView?
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBAction func upload(sender: UIButton){
        self.uploadPhoto()
    }
    
    var photosFromApi : Array<Photo> = Array()
    var photosArray : Array<Photo> = Array()
    //    var photos : Array<UIImage?> = Array()
    let loginServiceManager = LoginService()
    let photoServiceManager = PhotosServiceManager()
    var oAuthToken: String = ""
    var oAuthTokenSecret : String = ""
    var nsuid : String = ""
    var currentPageNo : Int = 1
    var activityIndicator : ActivityIndicatorView!
    var isLoading : Bool = false
    var isPhotoPickerDismissed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oAuthTokenSecret = UserDefaults.standard.value(forKey: "oAuthTokenSecret") as! String
        oAuthToken = UserDefaults.standard.value(forKey: "oAuthToken") as! String
        nsuid = UserDefaults.standard.value(forKey: "NSID") as! String
        
        self.activityIndicator = ActivityIndicatorView(center: self.view.center)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.loadingView?.isHidden = true
        if let layout = self.collectionView?.collectionViewLayout as? AdaptableCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isPhotoPickerDismissed {
            loadPhotos()
        }else{
            isPhotoPickerDismissed = false
        }
    }
    
    func uploadPhotoService(photo : UIImage){
        DispatchQueue.main.async(execute: {
            self.view.addSubview(self.activityIndicator.getActivityIndicatorWithTitle("Uploading Photo.."))
            self.activityIndicator.startAnimating()
        })
        photoServiceManager.uploadPhoto(oAuthToken: oAuthToken, oAuthTokenSecret: oAuthTokenSecret, photo: photo, success: {
            (response) in
            print(response)
            DispatchQueue.main.async(execute: {
                self.activityIndicator.stopAnimating()
                
            })
            self.loadPhotos()
        })
    }
    
    func loadPhotos(){
        self.currentPageNo = 1
        self.photosArray = Array()
        DispatchQueue.main.async(execute: {
            self.view.addSubview(self.activityIndicator.getActivityIndicatorWithTitle("Loding Photos.."))
            self.activityIndicator.startAnimating()
        })
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self!.photoServiceManager.getAllYourPhotos(page: self!.currentPageNo, oAuthToken: self!.oAuthToken, oAuthTokenSecret: self!.oAuthTokenSecret, success: { (response) in
                print(response)
                self!.currentPageNo = self!.currentPageNo + 1
                self!.photosFromApi = response
                for p in self!.photosFromApi{
                    let tempP = p
                    do{
                        let actualPhoto = try UIImage(data: Data(contentsOf: (p.url)))
                        tempP.photo = actualPhoto
                    }catch{
                        print("error in url")
                    }
                    self!.photosArray.append(tempP)
                    if (self?.photosFromApi.last == p) {
                        DispatchQueue.main.async(execute: {
                            self!.activityIndicator.stopAnimating()
                            self!.collectionView?.reloadData()
                        })
                    }
                }
                
                if(response.isEmpty){
                    DispatchQueue.main.async(execute: {
                        self!.activityIndicator.stopAnimating()
                    })
                    
                }
                
                
            })
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func loadSegment() {
        
        if (!self.isLoading) {
            self.isLoading = true
            DispatchQueue.main.async(execute: {
                self.loadingView?.isHidden = false
                UIApplication.shared.beginIgnoringInteractionEvents()
            })
            DispatchQueue.global(qos: .default).async { [weak self] in
                self!.photoServiceManager.getAllYourPhotos(page: self!.currentPageNo ,oAuthToken: self!.oAuthToken, oAuthTokenSecret: self!.oAuthTokenSecret, success: { (response) in
                    self!.currentPageNo = self!.currentPageNo + 1
                    print(response)
                    self!.isLoading = false
                    self!.photosFromApi = response
                    for p in self!.photosFromApi{
                        let tempP = p
                        do{
                            let actualPhoto = try UIImage(data: Data(contentsOf: (p.url)))
                            tempP.photo = actualPhoto
                        }catch{
                            print("error in url")
                        }
                        self!.photosArray.append(tempP)
                        if (self?.photosFromApi.last == p) {
                            DispatchQueue.main.async(execute: {
                                self!.loadingView?.isHidden = true
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self!.collectionView?.reloadData()
                            })
                        }
                    }
                    if(response.isEmpty){
                        DispatchQueue.main.async(execute: {
                            self!.activityIndicator.stopAnimating()
                        })
                        
                    }
                    
                })
            }
        }
    }
    
}
extension MyPhotosViewController : AdaptableCollectionViewLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let photo = photosArray[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: (photo.photo.size), insideRect: boundingRect)
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let photo = photosArray[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight : CGFloat = photo.heightForComment(font: font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
    
}

extension MyPhotosViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.configure(photosArray[indexPath.item])
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= (scrollView.contentSize.height / 4) {
            loadSegment()
        }
        
    }
    
}

extension MyPhotosViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.isPhotoPickerDismissed = true
        self.dismiss(animated: true) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let imageData = UIImageJPEGRepresentation(image, 0.6)
                let compressedJPGImage = UIImage(data: imageData!)
                self.uploadPhotoService(photo: compressedJPGImage!)
                
            }
        }
    }
    
    func uploadPhoto(){
        let alert = UIAlertController(title: nil, message: "Upload Photos from", preferredStyle: UIAlertControllerStyle.actionSheet)
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: {[weak self] (action)  in
            self?.openPhotoLibraryButton()
            
        })
        galleryAction.setValue(UIImage(named:"gallery"), forKey: "image")
        
        let camAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {[weak self] (action)  in
            self?.openCameraButton()
        })
        camAction.setValue(UIImage(named:"camera"), forKey: "image")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)]) , forKey: "attributedMessage")
        
        self.present(alert, animated: false, completion: nil)
        alert.addAction(galleryAction)
        alert.addAction(camAction)
        alert.addAction(cancelAction)
    }
}
