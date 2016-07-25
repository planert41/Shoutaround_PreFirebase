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


public var SelectedImageGPS: CLLocation?
public var SelectedImageData: UIImage?

class UploadViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var postCaption: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var LocationIcon: UIImageView!
    @IBOutlet weak var locationView: UIView!

    // Photo and Location Manager
    let locationManager = CLLocationManager()
    let library = ALAssetsLibrary()
    
    override func viewDidLoad() {

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
        image.allowsEditing = true
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
        
        reverseGPS(SelectedImageGPS!)        
        
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
        let searchRadius: Double = 50
        var searchedTypes = ["restaurant"]
        var mypos: CLLocationCoordinate2D = CLLocationCoordinate2DMake((SelectedImageGPS?.coordinate.latitude)!,(SelectedImageGPS?.coordinate.longitude)!)
        
        print(mypos)
        
        dataProvider.fetchPlacesNearCoordinate(mypos, radius:searchRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                print("test")
                
            }
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

    
}
