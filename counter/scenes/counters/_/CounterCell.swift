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
    fileprivate var counter: CounterModel
    private var cancellable: AnyCancellable?

    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    var name: String {
        counter.name
    }
    var value: Int {
        counter.totalCount
    }
    // todo color
    
    init(counter: CounterModel) {
        self.counter = counter
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
}

// Presentational View
private struct CounterCellView: View {
    @ObservedObject private var vm: CounterCellVM
    let onUpdate: () -> Void
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
        vm = CounterCellVM(counter: counter)
    }
    
    var body: some View {
        NavigationLink(destination: CounterDetail(counter: vm.counter)) {
            HStack {
                Text(vm.name)
                Spacer()
                Text("\(vm.value)")
            }
        }
    }
}

// Connected View (controller/container)
struct CounterCellContainer: View {
    let counter: CounterModel
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    func handleUpdate() {
        try! moc.save()
    }

    var body: some View {
        CounterCellView(counter: counter, onUpdate: handleUpdate)
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
