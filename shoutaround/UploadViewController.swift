//
//  UploadViewController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/18/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

import UIKit
import AssetsLibrary
import GoogleMaps
import Alamofire
import SwiftyJSON


public var SelectedImageGPS: CLLocation?
public var SelectedImageData: UIImage?
public var GooglePlacesID = ["":""]
public var SearchResults = [String()]

class UploadViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var postCaption: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var LocationIcon: UIImageView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var placesCollectionView: UICollectionView!
    @IBOutlet weak var ratingsView: UICollectionView!
    
    @IBOutlet weak var emoticonView1: UICollectionView!
    @IBOutlet weak var emoticonView2: UICollectionView!
    @IBOutlet weak var emoticonView3: UICollectionView!
    @IBOutlet weak var emoticonView4: UICollectionView!
    @IBOutlet var emoticonViews: Array<UICollectionView>?

    // Photo and Location Manager
    let locationManager = CLLocationManager()
    let library = ALAssetsLibrary()
    let UploadLocationTag = UploadLocationTagList()
    let RatingsViewFlow = RatingsViewFlowLayout()
    let EmoticonViewFlow = EmoticonViewFlowLayout()
    

    
    override func viewDidLoad() {

        placesCollectionView.delegate = self
        placesCollectionView.setCollectionViewLayout(UploadLocationTag, animated: true)
        
        ratingsView.delegate = self
        ratingsView.decelerationRate = UIScrollViewDecelerationRateFast
        let nib = UINib(nibName: "RatingsViewCell", bundle: nil)
        ratingsView.registerNib(nib, forCellWithReuseIdentifier: "RatingsViewCell")
        ratingsView.setCollectionViewLayout(RatingsViewFlow, animated: true)
        
        for view in emoticonViews! {
            view.registerNib(nib, forCellWithReuseIdentifier: "RatingsViewCell")
            view.setCollectionViewLayout(EmoticonViewFlow, animated: true)
            view.delegate = self
            view.decelerationRate = UIScrollViewDecelerationRateFast
            
        }

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        // Show Camera
        
        if SelectedImageData == nil {
            showImagePicker()
        }
        self.tabBarController?.tabBar.hidden = true

        }
    
    
    @IBAction func UploadBack(sender: AnyObject) {
        
        showImagePicker()
        
    }
    
    func showImagePicker() {
        
        var image = UIImagePickerController()
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.delegate = self
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        SelectedImageData = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        
        library.assetForURL(url, resultBlock: {
            (asset: ALAsset!) in
            
            if asset.valueForProperty(ALAssetPropertyLocation) != nil {
                
                SelectedImageGPS = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation!
                
            } else {print("empty")}
            }, failureBlock: {
                (error: NSError!) in
                NSLog("Error!")
            }
        )
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        SelectedImageData = nil
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.selectedIndex = LastTab

        
    }
    
    
    override func viewDidAppear (animated: Bool) {
        
        
        // Selected Image
        uploadImage.image = SelectedImageData
        
        //Captions
        postCaption.delegate = self
        postCaption.text = "Caption Here"
        postCaption.textColor = UIColor.lightGrayColor()
        
        //Location
        
        if SelectedImageGPS?.coordinate.latitude != nil {
            reverseGPS(SelectedImageGPS!)
        } else {
            
            let myLocation = CLLocation(latitude: 0, longitude: 0)
            SelectedImageGPS = myLocation
        }

        
        
        var postLatitude:String! = String(format:"%.4f",(SelectedImageGPS?.coordinate.latitude)!)
        var postLongitude:String! = String(format:"%.4f",(SelectedImageGPS?.coordinate.longitude)!)
        
        locationLabel.text = "Lat,Long : " + postLatitude + "," + postLongitude
        LocationIcon.image = UIImage(named: "caps_lock_on_filled")
        
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        

        
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func reverseGPS(GPSLocation: CLLocation) {
        
        // Reverse GPS to get place adress
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()

        // var location:CLLocation = CLLocation(latitude: postlatitude, longitude: postlongitude)
        
        CLGeocoder().reverseGeocodeLocation(GPSLocation, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        
        let dataProvider = GoogleDataProvider()
        let searchRadius: Double = 100
        var searchedTypes = ["restaurant"]
        var searchTerm = "restaurant"
        var mypos: CLLocationCoordinate2D = CLLocationCoordinate2DMake((SelectedImageGPS?.coordinate.latitude)!,(SelectedImageGPS?.coordinate.longitude)!)
        
        print(mypos)
        
        dataProvider.fetchPlacesNearCoordinate(mypos, radius:searchRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                print(place.name)
                
            }
        }
        
        downloadRestaurantDetails(mypos, searchRadius: searchRadius, searchType: searchTerm)
        
        
    }
    
    func downloadRestaurantDetails(lat: CLLocationCoordinate2D, searchRadius:Double, searchType: String ) {
        let URL_Search = "https://maps.googleapis.com/maps/api/place/search/json?"
        let API_iOSKey = "AIzaSyBq2etZOLunPzzNt9rA52n3RKN-TKPLhec"
        
        let urlString = "\(URL_Search)location=\(lat.latitude),\(lat.longitude)&rankby=distance&type=\(searchType)&key=\(API_iOSKey)"
        let url = NSURL(string: urlString)!
        
     //   https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&radius=500&types=food&name=cruise&key=YOUR_API_KEY
        
        // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=41.9542116666667,-87.7055883333333&radius=100.0&rankby=distance&type=restaurant&key=AIzaSyBq2etZOLunPzzNt9rA52n3RKN-TKPLhec
        
        var temp = [String()]
        SearchResults.removeAll()
        GooglePlacesID.removeAll()
        temp.removeAll()
        
        Alamofire.request(.GET,url).responseJSON { (response) -> Void in

            
            if let value  = response.result.value {
                let json = JSON(value)
                
                if let results = json["results"].array {
                    for result in results {
                        if result["place_id"].string != nil {
                        if let placeIDs = result["place_id"].string{
                            if let names = result["name"].string{

                        GooglePlacesID[names] = placeIDs
                        temp.append(names)
                        }
                            }
                    }
                    }
                }
            }
            print(temp)
            SearchResults = temp
            self.placesCollectionView.reloadData()
            
        }


    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            print(containsPlacemark.name)
            
           // self.PlaceName.text = containsPlacemark.name
            
            
            /*
            print(locality)
            print(GPS)
            print(containsPlacemark.areasOfInterest)
            print(containsPlacemark.name)
            print(containsPlacemark.thoroughfare)
            print(containsPlacemark.subThoroughfare)
            
            
            public var name: String? { get } // eg. Apple Inc.
            public var thoroughfare: String? { get } // street name, eg. Infinite Loop
            public var subThoroughfare: String? { get } // eg. 1
            public var locality: String? { get } // city, eg. Cupertino
            public var subLocality: String? { get } // neighborhood, common name, eg. Mission District
            public var administrativeArea: String? { get } // state, eg. CA
            public var subAdministrativeArea: String? { get } // county, eg. Santa Clara
            public var postalCode: String? { get } // zip code, eg. 95014
            public var ISOcountryCode: String? { get } // eg. US
            public var country: String? { get } // eg. United States
            public var inlandWater: String? { get } // eg. Lake Tahoe
            public var ocean: String? { get } // eg. Pacific Ocean
            public var areasOfInterest: [String]? { get } // eg. Golden Gate Park
            */
            
            
        }
        
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.ratingsView {
         
            return Ratings.count
            
        } else if (collectionView == emoticonView1 || collectionView == emoticonView2 || collectionView == emoticonView3 || collectionView == emoticonView4 ){

            var rowindex = 0

            if collectionView == emoticonView1 {
                rowindex = 0
            } else if collectionView == emoticonView2 {
                rowindex = 1
            } else if collectionView == emoticonView3 {
                rowindex = 2
            } else if collectionView == emoticonView4 {
                rowindex = 3
            }
            
            return EmoticonArray[rowindex].count
            
        }
        
        
        else {
        
            return SearchResults.count
            
        }
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == placesCollectionView {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("uploadCollectionViewCell", forIndexPath: indexPath) as! uploadCollectionViewCell
        
        cell.placeButtons.setTitle(SearchResults[(indexPath as NSIndexPath).row], forState: .Normal)
        cell.UploadCellViewController = self
        
        return cell
            
        }else if collectionView == ratingsView {
            
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("RatingsViewCell", forIndexPath: indexPath) as! RatingsViewCell
            
        var rowindex = 0
            
        if collectionView == ratingsView {
                rowindex = 0
            }
        cell.RatingButton.setTitle(Ratings[(indexPath as NSIndexPath).row], forState: .Normal)
    
        
        return cell
            
        } else if (collectionView == emoticonView1 || collectionView == emoticonView2 || collectionView == emoticonView3 || collectionView == emoticonView4 ){
            
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("RatingsViewCell", forIndexPath: indexPath) as! RatingsViewCell
            
            var rowindex = 0
            
            if collectionView == emoticonView1 {
                rowindex = 0
            } else if collectionView == emoticonView2 {
                rowindex = 1
            } else if collectionView == emoticonView3 {
                rowindex = 2
            } else if collectionView == emoticonView4 {
                rowindex = 3
            }
            
          cell.ratingsView.alpha = 0.3
            
          cell.RatingButton.setTitle(EmoticonArray[rowindex][(indexPath as NSIndexPath).row], forState: .Normal)
            return cell
            
        }
            
        
            
            
            
        else {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("uploadCollectionViewCell", forIndexPath: indexPath) as! uploadCollectionViewCell
        return cell
            
        }
    }
    
    
    @IBAction func LocationPressed(sender: UIButton) {
        locationLabel.text = sender.titleLabel?.text
    
        
    }

    
    
}
