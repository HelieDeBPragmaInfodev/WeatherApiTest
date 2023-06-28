//
//  CDCity+CoreDataProperties.swift
//  WeatherApiTest
//
//  Created by Hélie de Bernis on 28/06/2023.
//
//

import Foundation
import CoreData


extension CDCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCity> {
        return NSFetchRequest<CDCity>(entityName: "CDCity")
    }

    @NSManaged public var name: String?
    @NSManaged public var lat: Float
    @NSManaged public var long: Float
    @NSManaged public var temp: String?
    @NSManaged public var descriptionWeather: String?
    @NSManaged public var iconName: String?

}

extension CDCity : Identifiable {

}
