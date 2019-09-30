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
    
//    @Published
    private var counter: CounterModel
    private var cancellable: AnyCancellable?

//    private var cancellables: [AnyCancellable] = []

    let onUpdate: () -> Void

    private(set) var name: String
//    @Published var value: Int
    var value: Int
        {
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
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
//        self.value = counter.value
        
        
//        self.value = CurrentValueSubject<Int, Never>(0)
        
//        counter.value
        
//        counter.name.publisher.assign(to: .name, on: self)
    }
    
    func incrementAction() {
        value += 1
        onUpdate()
    }
}

private typealias VM = CounterCellVM

// Presentational View
private struct CounterCellView: View {
    @ObservedObject private var vm: VM
    let onUpdate: () -> Void
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
        vm = VM(counter: counter, onUpdate: onUpdate)
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

private typealias PresentationalView = CounterCellView

// Connected View (controller/container)
struct CounterCellContainer: View {
    let counter: CounterModel
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    func handleUpdate() {
        try! moc.save()
    }

    var body: some View {
        PresentationalView(counter: counter, onUpdate: handleUpdate)
    }
}

typealias CounterCell = CounterCellContainer

//struct CounterCell_Previews: PreviewProvider {
//    let counter = Counter()
//
//    static var previews: some View {
//        CounterCell()
//    }
//}
