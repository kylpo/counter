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
    
    @State private var dateRange = 0
    
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
            VStack {
                Picker(selection: $dateRange, label: Text("What is your favorite color?")) {
                    Text("Total").tag(0)
                    Text("Today").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
//            }
            List(counters, id: \.id) { counter in
                CounterCell(counter: CounterModelImpl(counter), showTotalCount: self.dateRange == 0)
                }}.navigationBarTitle("Counters")
                .navigationBarItems(trailing:
                    HStack {
                        Button(action: deleteAll) {
                            Image(systemName: "minus")
                        }
                        Button(action: {
                            _ = self.moc.create(name: "testing", color: .red)
                            self.moc.saveChanges()
                        }) {
                            Image(systemName: "plus.circle")
                        }
                })
        }
    }
}

struct CountersScene_Previews: PreviewProvider {
    static var previews: some View {
        CountersScene()
    }
}
