//
//  Business.swift
//  TripPlanner
//
//  Created by Sahith Bhamidipati on 7/11/16.
//  Copyright © 2016 Sahith Bhamidipati. All rights reserved.
//

import UIKit
import MapKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let rating: Double?
    let reviewCount: NSNumber?
    let lat:CLLocationDegrees?
    let long:CLLocationDegrees?
    let mobileURL: NSURL?
    
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            if let coordinate = location!["coordinate"] as? NSDictionary {
                
                let latitude = coordinate["latitude"] as! CLLocationDegrees
                let longitude = coordinate["longitude"] as! CLLocationDegrees
                lat = latitude
                long = longitude
            } else {
                lat = nil
                long = nil
            }
        } else {
            lat = nil
            long = nil
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        rating = dictionary["rating"] as? Double
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
        let mobile = dictionary["mobile_url"] as? String
        if mobile != nil {
            mobileURL = NSURL(string: mobile!)
        }
        else {
            mobileURL = nil
        }
        
        
    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, lat: 37.5, long: 121.5, radius: 1604, completion: completion)
    }
    
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, lat: 37.5, long: 121.5, sort: sort, categories: categories, deals: deals, radius: 1604, offset: 1, completion: completion)
    }
}