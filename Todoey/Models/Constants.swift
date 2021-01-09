//
//  Constants.swift
//  Todoey
//
//  Created by Matt Nutt on 07/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct K {
        
    static let segue = "goToItems"
    
    struct search {
        static let title = "title"
        static let format = "title CONTAINS[cd] %@"
    }
    
    struct relationships {
        static let items = "items"
        static let parent = "parentCategory"
    }
    
    struct new {
        static let item = "Add New Todoey Item"
        static let category = "Add New Category"
        static let buttonItem = "Add Item"
        static let buttonCategory = "Add Category"
        static let placeholderItem = "Create new item"
        static let placeholderCategory = "Create new category"
        static let emptyField = "Empty Text Field, details not saved."
        
    }

    struct cells {
        static let category = "CategoryCell"
        static let item = "ToDoItemCell"
    }

    struct error {
        static let fetch = "######### Error fetching context data ########"
        static let save = "######### Error saving context data ########"
        static let decode = "######### Error decoding item array ########"
        static let encode = "######### Error encoding item array ########"
    }
    
}


