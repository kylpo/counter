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

// View Machine
final class CounterCellVM: ObservableObject {
    // Note: explicitly defining this is needed if you don't have a @Published to do it for you.
    // This was a gotcha for me because calling self.objectWillChange.send() did not error, even when I hadn't instantiated it
    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    private var counter: CounterModel
    let onUpdate: () -> Void

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
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.counter = counter
        self.onUpdate = onUpdate
        
        self.name = counter.name
    }
    
    func incrementAction() {
        value += 1
        onUpdate()
//        try! moc.save()
    }
}

// Presentational View
private struct CounterCellView: View {
    @ObservedObject private var vm: CounterCellVM
    let onUpdate: () -> Void
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
        vm = CounterCellVM(counter: counter, onUpdate: onUpdate)
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


// Connected View (controller/container)
struct CounterCell: View {
    let counter: CounterModel
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    func handleUpdate() {
        try! moc.save()
    }

    var body: some View {
        // TODO?: add onChange to moc.save() so it doesn't need to be mocked for Preview?
        CounterCellView(counter: counter, onUpdate: handleUpdate)
    }
}

//struct CounterCell_Previews: PreviewProvider {
//    let counter = Counter()
//
//    static var previews: some View {
//        CounterCell()
//    }
//}
