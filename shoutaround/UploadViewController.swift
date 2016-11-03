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
import Cosmos



public var SelectedImageData: UIImage?
public var SelectedImageGPS: CLLocation?
public var CurrentLocation: CLLocation?

public var SelectedLocationAdress: String?
public var SelectedLocationName: String?

public var GooglePlacesID = [String():String()]
public var SearchResults = [String()]
public var SearchLocations = [String():CLLocation()]
public var SearchLocationNames = [String():String()]


public var tags = [String()]
public var EmoticonLookup: [String:String] = ["":""]

public var SelectionEmoticonImageData: UIImage?
public var postRating: Double! = 0


class UploadViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, JOEmojiableDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var postCaption: UITextView!
    
    @IBOutlet weak var locationTextview: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationAdressLabel: UILabel!
    
    
    @IBOutlet weak var tagLabel: UITextView!
    @IBOutlet weak var LocationIcon: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var placesCollectionView: UICollectionView!
  //  @IBOutlet weak var ratingsView: RatingsView!


    
    @IBOutlet weak var starview: UIView!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var emoticonView1: EmoticonView!
    @IBOutlet weak var emoticonView2: EmoticonView!
    @IBOutlet weak var emoticonView3: EmoticonView!
    @IBOutlet weak var emoticonView4: EmoticonView!
    @IBOutlet var emoticonViews: Array<UICollectionView>?
    
    
    
    @IBOutlet weak var emoticonRating: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var StarRating: CosmosView!

 //   @IBOutlet weak var starSlider: UISlider!
    
    @IBOutlet weak var ratingCancel: UIButton!
    @IBOutlet weak var locationCancel: UIButton!
    
    
    
    
    
    
    @IBAction func locationIconPressed(sender: AnyObject) {
    
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
        
            SelectedLocationName = nil
            SelectedLocationAdress = nil
            SelectedImageGPS = nil
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()

                
            
            
        }
    
    }
    
    
    
    @IBAction func locationCanceled(sender: AnyObject) {
    
        self.locationLabel.text = nil
        self.locationTextview.text = nil
        self.locationAdressLabel.text = nil
        self.locationCancel.hidden = true

    
    }
    
    @IBAction func ratingCanceled(sender: AnyObject) {
    
        self.ratingLabel.text = nil
        self.emoticonRating.image = nil
        self.ratingCancel.hidden = true
        
    }
    
    
    @IBAction func StarSlider(sender: UISlider) {
        postRating = Double(lroundf(sender.value)) / 2
        self.ratingupdate()

    }

    // Photo and Location Manager
    let locationManager = CLLocationManager()
    let library = ALAssetsLibrary()
    let UploadLocationTag = UploadLocationTagList()
    let RatingsViewFlow = RatingsViewFlowLayout()
    let EmoticonViewFlow = EmoticonViewFlowLayout()
    var hideView : UIView?
    var selectedView: UICollectionView? = nil
    var displayedtags = [String()]{
        didSet
        {
            if displayedtags.count > 11 {
                
                displayedtags.removeLast()
                let alert = UIAlertController(title: "Tag Limit", message: "You have reached your tag limit of 10", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }
            self.updateTags()
        }
    }
    

    private func ratingupdate() {
        
        if postRating == 0 { ratingLabel.alpha = 0} else {ratingLabel.alpha = 1;
            
            //ratingLabel.layer.borderColor = UIColor.blackColor().CGColor; ratingLabel.layer.borderWidth = 1.0;
        }
        
        if postRating % 1 == 0.5 {
            ratingLabel.text = String(format:"%.1f", postRating) } else
        { ratingLabel.text = String(format:"%.1f", postRating) }
        
        if postRating < 3 {
            ratingLabel.textColor = UIColor.redColor()
        }
        else if postRating < 7 {
            ratingLabel.textColor = UIColor.orangeColor()
        }
        else if postRating > 7 {
            ratingLabel.textColor = UIColor.yellowColor()
        }
        
        
        
        
        if postRating > 0 || emoticonRating != nil {
            
            self.ratingCancel.hidden = false
        }
        
        //ratingLabel.layer.cornerRadius = self.ratingLabel.frame.size.width / 2;
        //ratingLabel.clipsToBounds = true;
        //self.ratingLabel.backgroundColor = UIColor(patternImage: UIImage(named: "star")!)

        
       // starSlider.setValue(Float(postRating * 2), animated: true)
       // StarRating.rating = postRating

        
    }
    
    
    
    
    func updateGPS(){
        
        var postLatitude:String! = String(format:"%.2f",(SelectedImageGPS?.coordinate.latitude)!)
        var postLongitude:String! = String(format:"%.2f",(SelectedImageGPS?.coordinate.longitude)!)
        var GPSLabelText:String?
        
        if SelectedLocationAdress == nil {
            GPSLabelText = "GPS (Lat,Long): " + " (" + postLatitude + "," + postLongitude + ")"
            locationLabel.text =  GPSLabelText!
            locationAdressLabel.text == ""
            
        } else {
            GPSLabelText = " (GPS: " + postLatitude + "," + postLongitude + ")"
            locationLabel.text =  GPSLabelText!
            locationAdressLabel.text = SelectedLocationAdress
            
        }
        locationTextview.text =  SelectedLocationName
        locationAdressLabel.sizeToFit()
        locationLabel.sizeToFit()
        locationCancel.hidden = false
        
        
    }

    
    /*
    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        //  print("A")
        
        let pointTapped: CGPoint = gestureRecognizer.locationInView(self.view)
        
        let positionOfSlider: CGPoint = starSlider.frame.origin
        let widthOfSlider: CGFloat = starSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(starSlider.maximumValue) / widthOfSlider)
        
        starSlider.setValue(Float(ceil(newValue)), animated: true)
        self.postRating = Double(lroundf(starSlider.value)) / 2
        self.ratingupdate()
    }
     */
    
    override func viewDidLoad() {
        
        var Button1Convert = CGRectMake(Button1.frame.minX, Button1.frame.minY + starview.frame.minY, Button1.frame.width, Button1.frame.height)
        
        
        var Button2Convert = CGRectMake(Button2.frame.minX, Button2.frame.minY + starview.frame.minY, Button2.frame.width, Button2.frame.height)

        
        // Hide Cancel Buttons
        
        self.ratingCancel.hidden = true
        self.locationCancel.hidden = true
        self.locationLabel.text = nil
        self.locationTextview.text = nil
        self.locationAdressLabel.text = nil
        
        let Button1Emoji             = JOEmojiableBtn(frame: Button1Convert)
        Button1Emoji.delegate        = self
        Button1Emoji.alpha = 0.15
        Button1Emoji.backgroundColor = UIColor(patternImage: self.ResizeImage(UIImage(named: "B1BW")!, targetSize: CGSizeMake(Button1Emoji.frame.width, Button1Emoji.frame.height)))
        Button1Emoji.dataset         = [
            JOEmojiableOption(image: "B1", name: "dislike"),
            JOEmojiableOption(image: "B2", name: "broken"),
            JOEmojiableOption(image: "B3", name: "he he"),
            JOEmojiableOption(image: "B4", name: "ooh"),
            JOEmojiableOption(image: "B5", name: "meh!"),
            JOEmojiableOption(image: "B6", name: "ahh!")
        ]
        
        self.view.addSubview(Button1Emoji)
        
        
        let Button2Emoji             = JOEmojiableBtn(frame: Button2Convert)
        Button2Emoji.delegate        = self
        Button2Emoji.alpha = 0.15
        Button2Emoji.backgroundColor = UIColor(patternImage: self.ResizeImage(UIImage(named: "G1BW")!, targetSize: CGSizeMake(Button2Emoji.frame.width, Button2Emoji.frame.height)))
            Button2Emoji.dataset         = [
            JOEmojiableOption(image: "G1", name: "dislike"),
            JOEmojiableOption(image: "G2", name: "broken"),
            JOEmojiableOption(image: "G3", name: "he he"),
            JOEmojiableOption(image: "G4", name: "ooh"),
            JOEmojiableOption(image: "G5", name: "meh!"),
            JOEmojiableOption(image: "G6", name: "ahh!")
        ]
        self.view.addSubview(Button2Emoji)

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sliderTapped:")
        //self.starSlider.addGestureRecognizer(tapGestureRecognizer)
        
        
        if postRating == 0 {
            ratingLabel.text = ""
            StarRating.rating = 0
        }
        
        StarRating.settings.fillMode = .Half
        StarRating.settings.minTouchRating = 0
        StarRating.didTouchCosmos = { rating in
            print(rating)
            postRating = rating
            self.ratingupdate()
        }
        

        let testFrame : CGRect = CGRectMake(0,0,1000,1000)
        hideView = UIView(frame: testFrame)
        // Create Blank View To Hide Load
        hideView!.backgroundColor = UIColor.whiteColor()
        hideView!.alpha=1
        self.view.addSubview(hideView!)
        
        
        
        
        
        placesCollectionView.delegate = self
        placesCollectionView.setCollectionViewLayout(UploadLocationTag, animated: true)
        
        let nib = UINib(nibName: "RatingsViewCell", bundle: nil)

        
        /*
        ratingsView.delegate = self
        ratingsView.decelerationRate = UIScrollViewDecelerationRateFast
        ratingsView.registerNib(nib, forCellWithReuseIdentifier: "RatingsViewCell")
        ratingsView.setCollectionViewLayout(RatingsViewFlow, animated: true)
        */
        
        for view in emoticonViews! {
            view.registerNib(nib, forCellWithReuseIdentifier: "RatingsViewCell")
            view.setCollectionViewLayout(EmoticonViewFlow, animated: true)
            view.delegate = self
            view.decelerationRate = UIScrollViewDecelerationRateFast
            
        }
        
        // Reverse Emoticon Lookup
        for (input,output) in EmoticonDictionary {
            EmoticonLookup[output] = input
        }
     
        // Do any additional setup after loading the view, typically from a nib.
        let lpgr1 = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        let lpgr2 = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        let lpgr3 = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        let lpgr4 = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        
        
        lpgr1.minimumPressDuration = 0.5
        lpgr2.minimumPressDuration = 0.5
        lpgr3.minimumPressDuration = 0.5
        lpgr4.minimumPressDuration = 0.5
        //lpgr.delaysTouchesBegan = true
        lpgr1.delegate = self
        lpgr2.delegate = self
        lpgr3.delegate = self
        lpgr4.delegate = self
        
        emoticonView1.addGestureRecognizer(lpgr1)
        emoticonView2.addGestureRecognizer(lpgr2)
        emoticonView3.addGestureRecognizer(lpgr3)
        emoticonView4.addGestureRecognizer(lpgr4)
        
    }
    
    
    
    
    
    override func viewDidAppear (animated: Bool) {
        

        
        /*
        if (self.ratingLabel == nil && emoticonRating == nil) {
            self.ratingCancel.hidden = true } else {
            self.ratingCancel.hidden = false}
        
        if self.locationLabel == nil {
            self.locationCancel.hidden = true} else{
            self.locationCancel.hidden = false}
        */
        
        // Selected Image
        uploadImage.image = SelectedImageData
        
        //Captions
        postCaption.delegate = self
        
        //Location
        
        if SelectedImageGPS?.coordinate.latitude != nil {
            reverseGPS(SelectedImageGPS!)
        } else {
            
            let myLocation = CLLocation(latitude: 0, longitude: 0)
            SelectedImageGPS = myLocation
        }
        
        updateGPS()

        
        
        //LocationIcon.image = UIImage(named: "caps_lock_on_filled")
        
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Show Camera
        
        if SelectedImageData == nil {
            showImagePicker()
        }
        self.tabBarController?.tabBar.hidden = true
        postCaption.delegate = self
        

        }
    
    
    func updateTags()   {
        
    // Loops through string in displayed tags, identifies source, updates tag label with displayed tags, highlights cells
        
        for emoticon:String in displayedtags{
            
            var cellcolor:UIColor?
            
            if Emote1Init.contains(emoticon){
                cellcolor = UIColor(red: 252/255, green: 189/255, blue: 0/255, alpha: 1.0)
            }
            if Emote2Init.contains(emoticon){
                cellcolor = UIColor.blackColor()
            }
            if Emote3Init.contains(emoticon){
                cellcolor = UIColor.redColor()
            }
            if Emote4Init.contains(emoticon){
                cellcolor = UIColor(red: 0/255, green: 189/255, blue: 252/255, alpha: 1.0)
            }
            else {
                cellcolor = UIColor.whiteColor()
            }
        }
        
        self.tagLabel.text = displayedtags.joinWithSeparator("")
        print(displayedtags)
        self.highlight()
        
        //self.view1.reloadData()

    }
    
    func highlight() {
        for collectionviews in self.emoticonViews!{
            for cell in collectionviews.visibleCells() as! [RatingsViewCell]{
                if tags.contains((cell.RatingButton.titleLabel!.text)!) {
                    cell.RatingButton.alpha = 1
                } else {cell.RatingButton.alpha = 0.3}
            }
        }
        
        /*
            for cell in ratingsView.visibleCells() as! [RatingsViewCell]{
                if tags.contains((cell.RatingButton.titleLabel!.text)!) {
                    cell.RatingButton.alpha = 1
                } else {cell.RatingButton.alpha = 0.3}
            }
        */

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
        self.hideView?.hidden = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        SelectedImageData = nil
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.selectedIndex = LastTab

        
    }

    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView == postCaption {
        
        if textView.text == "Caption Here" {
            textView.text = nil
        }
        
        textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == postCaption {

        if textView.text.isEmpty {
            textView.text = "Caption Here"
            textView.textColor = UIColor.lightGrayColor()
        }
        }
    }
    
 
    func textViewDidChange(textView: UITextView) {
        if textView == postCaption {

        if textView.text == "Caption Here" {
            textView.textColor = UIColor.lightGrayColor()} else
        {textView.textColor = UIColor.blackColor()}
        }
    }
        
    
    
    /*
    
    func textViewDidChange(textView: UITextView) {

        
        let char = textView.text.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(char, "\\b")
        let attributedString = NSMutableAttributedString(string: textView.text!)
        print(char)
        
        if (textView.text == " " || isBackSpace == -92) {
            let words = textView.text!.componentsSeparatedByString(" ")
            var temptags = [String()]
            
            for word in words {
                //if word.hasPrefix("#") {
                let lookupword = word.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let attributedLookupString = NSMutableAttributedString(string: lookupword)
                
                if EmoticonLookup[lookupword] == nil {
                    if word.hasPrefix("#"){
                        temptags.append(word)
                    }
                } else {
                    temptags.append((EmoticonLookup[lookupword])!)
                    
                    let longestWordRange = (textView.text! as NSString).rangeOfString(lookupword)
                    
                    attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
                    
                    if Emote1Init.contains(lookupword) {
                        attributedLookupString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
                    }
                    
                    
                }
            }
            tags = temptags
            self.displayedtags = tags
            textView.attributedText = attributedString
            
            //}
        }
        /*
         let  char = string.cStringUsingEncoding(NSUTF8StringEncoding)!
         let isBackSpace = strcmp(char, "\\b")
         
         if (isBackSpace == -92) {
         print("Backspace was pressed")
         }*/
        print("test")

        
        
    }

    */
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        

        let char = text.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(char, "\\b")
        let attributedString = NSMutableAttributedString(string: textView.text!)
        
        if textView == postCaption {

        if (text == " " || isBackSpace == -92) {
            let words = textView.text!.componentsSeparatedByString(" ")
            var temptags = [String()]
            for word in words {
                
                //if word.hasPrefix("#") {
                var lookupword = word.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let attributedLookupString = NSMutableAttributedString(string: lookupword)
                lookupword = lookupword.lowercaseString
                
                if EmoticonLookup[lookupword] == nil {
                    if word.hasPrefix("#"){
                        temptags.append(word)
                    }
                } else {
                    temptags.append((EmoticonLookup[lookupword])!)
                    
                    /*
                    let longestWordRange = (textView.text! as NSString).rangeOfString(lookupword)
                    
                    attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
                    
                    if Emote1Init.contains(lookupword) {
                        attributedLookupString.setAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName : UIColor.redColor()], range: longestWordRange)
 
                    }
                    */
                    
                }
            }
            tags = temptags
            self.displayedtags = tags
            textView.attributedText = attributedString
            }
            
            //}
        }
        
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
            return true
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
        var locationGPStemp = [CLLocation()]
        SearchResults.removeAll()
        SearchLocations.removeAll()
        SearchLocationNames.removeAll()
        GooglePlacesID.removeAll()
        temp.removeAll()
        
        Alamofire.request(.GET,url).responseJSON { (response) -> Void in

            
            if let value  = response.result.value {
                let json = JSON(value)
                
                if let results = json["results"].array {
                    for result in results {
                 
                        //print(result)
                        if result["place_id"].string != nil {
                        if let placeIDs = result["place_id"].string{
                            if let names = result["name"].string{
            
                        var locationGPStempcreate = CLLocation(latitude: result["geometry"]["location"]["lat"].double!, longitude: result["geometry"]["location"]["lng"].double!)
                        var locationAdress = result["vicinity"].string
                                
                                
                        GooglePlacesID[names] = placeIDs
                        SearchResults.append(names)
                        SearchLocations[names] = locationGPStempcreate
                        SearchLocationNames[names] = locationAdress
                            }
                    }
                    }
                }
            }
         //   print(temp)
         //   print(locationGPStemp)
         //   SearchResults = temp
            
            self.placesCollectionView.reloadData()

            
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
            SelectedLocationName = containsPlacemark.name
            SelectedLocationAdress = nil
            
            updateGPS()
            
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

    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        /*let customView = UIView(frame: CGRectMake(0, 0, 50, 50))
         customView.backgroundColor = UIColor.whiteColor()
         customView.tag = 1*/
        
        let p = gestureReconizer.locationInView(self.view)
        let subViews = self.view.subviews
        
        // Use Recognized instead of Began
        
        if gestureReconizer.state != UIGestureRecognizerState.Recognized {
            
            if CGRectContainsPoint(self.emoticonView1.frame, p) {
                selectedView = emoticonView1
            }
            
            if CGRectContainsPoint(self.emoticonView2.frame, p) {
                selectedView = emoticonView2
            }
            
            if CGRectContainsPoint(self.emoticonView3.frame, p) {
                selectedView = emoticonView3
            }
            
            if CGRectContainsPoint(self.emoticonView4.frame, p) {
                selectedView = emoticonView4
            }
            
            let point = self.selectedView!.convertPoint(p, fromView:self.view)
            let indexPath = self.selectedView!.indexPathForItemAtPoint(point)
            
            if let index = indexPath  {
                
                let cell = self.selectedView!.cellForItemAtIndexPath(index) as! RatingsViewCell
                
                var topright = CGPoint(x: cell.center.x + cell.bounds.size.width/2, y: cell.center.y - cell.bounds.size.height/2-25)
                var converttopright = self.view.convertPoint(topright, fromView:self.selectedView!)
                
                var label = UILabel(frame: CGRectMake(converttopright.x, converttopright.y, 100, 25))
                label.backgroundColor = UIColor.lightGrayColor()
                label.layer.cornerRadius = 10
                label.tag = 1
                
                self.view.addSubview(label)
                
                
                // do stuff with your cell, for example print the indexPath
                label.font = label.font.fontWithSize(15)
                label.textColor = UIColor.whiteColor()
                label.text = EmoticonDictionary[(cell.RatingButton.titleLabel?.text)!]
                cell.RatingButton.alpha = 1
                
            } else {
                print("Could not find index path")
            }
            
        }
         
            
        else if gestureReconizer.state != UIGestureRecognizerState.Changed {
            for subview in subViews{
                if (subview.tag == 1) {
                    subview.removeFromSuperview()
                }}
            
            let point = self.selectedView!.convertPoint(p, fromView:self.view)
            let indexPath = self.selectedView!.indexPathForItemAtPoint(point)
            
            if let index = indexPath  {
                
                let cell = self.selectedView!.cellForItemAtIndexPath(index) as! RatingsViewCell
                
                cell.RatingButton.alpha = 0.3
                
            } else {
                print("Could not find index path")
            }
            
            return
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*if collectionView == self.ratingsView {
         
            return Ratings.count
            
        } else*/
            
            
            if (collectionView == emoticonView1 || collectionView == emoticonView2 || collectionView == emoticonView3 || collectionView == emoticonView4 ){

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
            if SearchResults.count > 1 {
                return SearchResults.count}
            else {return 0}
            
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
            
        }
        /*
        else if collectionView == ratingsView {
            
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("RatingsViewCell", forIndexPath: indexPath) as! RatingsViewCell
            
            var rowindex = 0
            
            if collectionView == ratingsView {
                rowindex = 0}

            cell.RatingButton.setTitle(Ratings[(indexPath as NSIndexPath).row], forState: .Normal)
            cell.RatingButton.alpha = 0.3
    
            return cell
            
        } */
 
        else if (collectionView == emoticonView1 || collectionView == emoticonView2 || collectionView == emoticonView3 || collectionView == emoticonView4 ){
            
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
           
          cell.RatingButton.setTitle(EmoticonArray[rowindex][(indexPath as NSIndexPath).row], forState: .Normal)
          cell.RatingButton.alpha = 0.3
            
            return cell
            
        }
            
        else {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("uploadCollectionViewCell", forIndexPath: indexPath) as! uploadCollectionViewCell
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RatingsViewCell
        cell.cellViewController = self
        cell.EmoticonSelected(cell)
       // var cell = collectionView.cellForItemAtIndexPath(indexPath) as RatingsViewCell
        //cell.EmoticonSelected()
        
    }
    
    
    @IBAction func LocationPressed(sender: UIButton) {
        SelectedLocationName = sender.titleLabel?.text
        SelectedImageGPS = SearchLocations[(sender.titleLabel?.text)!]
        SelectedLocationAdress = SearchLocationNames[(sender.titleLabel?.text)!]
        
        updateGPS()

    }

    func singleTap(sender: JOEmojiableBtn) {
        print("Single tap action")
        
        if sender.frame.origin.x < (UIScreen.mainScreen().bounds.width)/2
        {
            emoticonRating.image = UIImage(named: "B1")
        }
        
        else if sender.frame.origin.x > (UIScreen.mainScreen().bounds.width)/2
        {
            emoticonRating.image = UIImage(named: "G1")
        }
        
        self.ratingCancel.hidden = false
        
       // labelInfo.text = "Single tap action"
    }

    
    func selectedOption(sender: JOEmojiableBtn, index: Int) {
        print("Option \(index) selected")
        emoticonRating.image = SelectionEmoticonImageData
    }
    
    func canceledAction(sender: JOEmojiableBtn) {
        print("User cancelled selection")
       // labelInfo.text = "User cancelled selection"
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CurrentLocation = locations[0]
        print(CurrentLocation)
        
        if CurrentLocation != nil {
            SelectedImageGPS = CLLocation(latitude: CurrentLocation!.coordinate.latitude, longitude: CurrentLocation!.coordinate.longitude)
            reverseGPS(CurrentLocation!)
            SelectedLocationName = nil
            SelectedLocationAdress = nil
            
            updateGPS()
            locationManager.stopUpdatingLocation()
       
        }

    }
    
    
}
