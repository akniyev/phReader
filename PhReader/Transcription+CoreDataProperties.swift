//
//  Transcription+CoreDataProperties.swift
//  
//
//  Created by Gasan Akniev on 26.12.2020.
//
//

import Foundation
import CoreData


extension Transcription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transcription> {
        return NSFetchRequest<Transcription>(entityName: "Transcription")
    }

    @NSManaged public var name: String?
    @NSManaged public var transcription: String?

}
