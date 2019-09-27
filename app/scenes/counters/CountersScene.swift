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
//    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    @FetchRequest(entity: Counter.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Counter.name, ascending: true)])
    var counters: FetchedResults<Counter>
    
    var body: some View {
        NavigationView {
        List(counters, id: \.name) { counter in
//            ForEach(counters) { counter in
                CounterCell(counter: counter)
            }.navigationBarTitle("Counters")
            .navigationBarItems(trailing: Button(action: {
                print("tapped")
            }) {
                Image(systemName: "plus.circle")
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
