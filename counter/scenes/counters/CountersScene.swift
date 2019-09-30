//
//  CountersScene.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import SwiftUI
import CoreData

//extension Counter: Identifiable {}

struct CountersScene: View {
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    @FetchRequest(entity: Counter.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Counter.name, ascending: true)])
    var counters: FetchedResults<Counter>
    
    func deleteAll() {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Counter> = Counter.fetchRequest()

        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try moc.fetch(fetchRequest)

            for item in items {
                moc.delete(item)
            }

            // Save Changes
            try moc.save()

        } catch {
            // Error Handling
            // ...
        }
    }
    
    var body: some View {
        NavigationView {
        List(counters, id: \.name) { counter in
//            ForEach(counters) { counter in
                CounterCell(counter: CounterModelImpl(counter))
        }.navigationBarTitle("Counters")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: deleteAll) {
                        Image(systemName: "minus")
                    }
                    Button(action: {
                    let newCounter = Counter(context: self.moc)
                    newCounter.name = "testing"
                    try! self.moc.save()
                    }) {
                        Image(systemName: "plus.circle")
                    }
            })
//        }
        }
    }
}

struct CountersScene_Previews: PreviewProvider {
    static var previews: some View {
        CountersScene()
    }
}
