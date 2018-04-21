//
//  UIViewController+CoreData.swift
//  RafaelSoares
//
//  Created by user138685 on 4/21/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
