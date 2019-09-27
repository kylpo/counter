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

private class VM: ObservableObject {
    let counter: Counter
    let moc: NSManagedObjectContext
    
    private(set) var name: String
    var value: Int {
        get {
            return Int(counter.value)
        }
        set {
            objectWillChange.send()
            counter.value = Int32(newValue)
        }
    }
    // todo color
    
    init(counter: Counter, moc: NSManagedObjectContext) {
        self.counter = counter
        self.moc = moc
        
//        self.value = Int(counter.value)
        
//        let cancellable = counter.value.publisher
        
        if let name = counter.name {
            self.name = name
        }
        else {
            self.name = ""
        }
    }
    
    func incrementAction() {
        value += 1
        try! moc.save()
    }
}

private struct CounterCellView: View {
    @ObservedObject private var vm: VM
    
    init(counter: Counter, moc: NSManagedObjectContext) {
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
    let counter: Counter
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
//    @ObservedObject private var vm: VM
//
//    init(counter: Counter) {
//        vm = VM(counter: counter, moc: self.moc)
//    }
    
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
