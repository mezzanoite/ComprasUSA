//
//  StateService.swift
//  RafaelSoares
//
//  Created by Rafael Soares on 27/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import Foundation
import CoreData

class StateHelper {
    
    static func loadStates(context: NSManagedObjectContext) -> [State] {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let statesDataSource = try context.fetch(fetchRequest)
            return statesDataSource
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}


