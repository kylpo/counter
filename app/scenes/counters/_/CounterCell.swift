//
//  CounterCell.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import SwiftUI

private class VM: ObservableObject {
    let counter: Counter
    @Published var name: String
    
    init(counter: Counter) {
        self.counter = counter
        
        if let name = counter.name {
            self.name = name
        }
        else {
            self.name = ""
        }
    }
}

struct CounterCell: View {
//    let counter: Counter
    @ObservedObject private var vm: VM
    
    init(counter: Counter) {
        vm = VM(counter: counter)
    }
    
    var body: some View {
        HStack {
            Text(vm.name)
//            Text(counter.color)
        }
    }
}

//struct CounterCell_Previews: PreviewProvider {
//    let counter = Counter()
//
//    static var previews: some View {
//        CounterCell()
//    }
//}
