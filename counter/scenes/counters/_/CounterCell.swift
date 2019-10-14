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
    private var showTotalCount: Bool

    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    var name: String {
        counter.name
    }
    var value: Int {
        showTotalCount ? counter.totalCount : counter.todayCount
    }
    var color: CounterColor {
        counter.color
    }
    
    init(counter: CounterModel, showTotalCount: Bool) {
        self.counter = counter
        self.showTotalCount = showTotalCount
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
}

// Presentational View
private struct CounterCellView: View {
    @ObservedObject private var vm: CounterCellVM
    
    init(counter: CounterModel, showTotalCount: Bool) {
        vm = CounterCellVM(counter: counter, showTotalCount: showTotalCount)
    }
    
    var body: some View {
        NavigationLink(destination: CounterDetail(counter: vm.counter)) {
            HStack {
                Text(vm.name)
                    .foregroundColor(vm.color.value)
                Spacer()
                Text("\(vm.value)")
            }
        }
    }
}

// Connected View (controller/container)
struct CounterCellContainer: View {
    let counter: CounterModel
    let showTotalCount: Bool
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext

    var body: some View {
        CounterCellView(counter: counter, showTotalCount: showTotalCount)
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
