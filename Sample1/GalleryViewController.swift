//
//  GalleryViewController.swift
//  Sample1
//
//  Created by Roopa Raman on 2/2/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import AVFoundation
class GalleryViewController: UIViewController {
    @IBOutlet weak var collectionView : UICollectionView?
    @IBOutlet weak var loadingView : UIView?
    @IBAction func logout(){
        UserDefaults.standard.removeObject(forKey: "oAuthToken")
        UserDefaults.standard.removeObject(forKey: "oAuthTokenSecret")
        UserDefaults.standard.removeObject(forKey: "NSID")
        let loginViewController : ViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController
    }
    
    var photosFromApi : Array<Photo> = Array()
    var photosArray : Array<Photo> = Array()
    //    var photos : Array<UIImage?> = Array()
    let photoServiceManager = PhotosServiceManager()
    var oAuthToken: String = ""
    var oAuthTokenSecret : String = ""
    var nsuid : String = ""
    var currentPageNo : Int = 1
    var activityIndicator : ActivityIndicatorView!
    var isLoading : Bool = false
    
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
        loadPhotos()
    }
    
    func loadPhotos(){
        DispatchQueue.main.async(execute: {
            self.view.addSubview(self.activityIndicator.getActivityIndicatorWithTitle("Loding Photos.."))
            self.activityIndicator.startAnimating()
        })
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self!.photoServiceManager.getAllPublicRecentPhotos(page: self!.currentPageNo, oAuthToken: self!.oAuthToken, oAuthTokenSecret: self!.oAuthTokenSecret, success: { (response) in
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
            })
            DispatchQueue.global(qos: .default).async { [weak self] in
                self!.photoServiceManager.getAllPublicRecentPhotos(page: self!.currentPageNo ,oAuthToken: self!.oAuthToken, oAuthTokenSecret: self!.oAuthTokenSecret, success: { (response) in
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
                                self!.collectionView?.reloadData()
                            })
                        }
                    }
                    
                    
                    
                })
            }
        }
    }
}
extension GalleryViewController : AdaptableCollectionViewLayoutDelegate {
    
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

extension GalleryViewController: UICollectionViewDataSource , UICollectionViewDelegate{
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

