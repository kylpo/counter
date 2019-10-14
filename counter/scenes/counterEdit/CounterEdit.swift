//
//  CounterEdit.swift
//  counter
//
//  Created by Kyle Poole on 10/14/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

// View Machine
final class CounterEditVM: ObservableObject {
    let onExit: () -> Void
    let manager: CounterManager
    let tickManager: TickManager
    let context: Context

    fileprivate var counter: CounterModel
    private var cancellable: AnyCancellable?

    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    let colors: [CounterColor] = CounterColor.allCases

    var name: String {
        get {
            counter.name
        }
        set {
            counter.name = newValue
        }
    }
    
    @Published var selectedColorIndex: Int {
        didSet { counter.color = colors[selectedColorIndex] }
    }

    init(counter: CounterModel, manager: CounterManager, tickManager: TickManager, context: Context, onExit: @escaping () -> Void) {
        self.counter = counter
        self.manager = manager
        self.tickManager = tickManager
        self.context = context
        self.onExit = onExit
        self.selectedColorIndex = 1 // todo: change to that of counter.color
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
    
    func cancelAction() {
        onExit()
    }
    
    func saveAction() {
        context.saveChangesAndWait()
        onExit()
    }
}

// Presentational View
private struct CounterEditView: View {
    @ObservedObject private var vm: CounterEditVM
    
    init(counter: CounterModel?, manager: CounterManager ,tickManager: TickManager, context: Context, onExit: @escaping () -> Void) {
        let counterToEdit = counter ?? manager.create(name: "", color: .none)
        vm = CounterEditVM(counter: counterToEdit, manager: manager, tickManager: tickManager, context: context, onExit: onExit)
    }
    
    var body: some View {
        NavigationView { // Needed for Picker
            VStack {
                Form {
                    TextField("Name", text: $vm.name)
                    
                    Picker(selection: $vm.selectedColorIndex, label: Text("Color")) {
                        ForEach(0 ..< vm.colors.count) {
                            Text(self.vm.colors[$0].rawValue).tag($0)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("Edit Counter")
            .navigationBarItems(leading: Button(action: vm.cancelAction) {
                Text("Cancel")
                }, trailing:
                
                Button(action: vm.saveAction) {
                    Text("Save")
                }
                
            )
        }
    }
}

// Connected View (controller/container)
struct CounterEditContainer: View {
    let counter: CounterModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext

    func handleExit() {
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        CounterEditView(counter: moc.counterManager.fetch(counter), manager: moc.counterManager, tickManager: moc.tickManager, context: moc as Context, onExit: handleExit)
    }
}

typealias CounterEdit = CounterEditContainer

//struct CountersDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        CountersScene()
//    }
//}
