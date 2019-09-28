//
//  CounterCell.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

private final class VM: ObservableObject {
    // Note: explicitly defining this is needed if you don't have a @Published to do it for you.
    // This was a gotcha for me because calling self.objectWillChange.send() did not error, even when I hadn't instantiated it
    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    var counter: CounterModel
    let moc: NSManagedObjectContext
    
    private(set) var name: String
    var value: Int {
        get {
            counter.value
        }
        set {
            self.objectWillChange.send()
            counter.value = newValue
        }
    }
    // todo color
    
    init(counter: CounterModel, moc: NSManagedObjectContext) {
        self.counter = counter
        self.moc = moc
        
        self.name = counter.name
    }
    
    func incrementAction() {
        value += 1
        try! moc.save()
    }
}

private struct CounterCellView: View {
    @ObservedObject private var vm: VM
    
    init(counter: CounterModel, moc: NSManagedObjectContext) {
        vm = VM(counter: counter, moc: moc)
    }
    
    var body: some View {
        Button(action: vm.incrementAction) {
            HStack {
                Text(vm.name)
                Spacer()
                Text("\(vm.value)")
            }
        }
    }
}

struct CounterCell: View {
    let counter: CounterModel
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext

    var body: some View {
        // TODO?: add onChange to moc.save() so it doesn't need to be mocked for Preview?
        CounterCellView(counter: counter, moc: moc)
    }
}

//struct CounterCell_Previews: PreviewProvider {
//    let counter = Counter()
//
//    static var previews: some View {
//        CounterCell()
//    }
//}
