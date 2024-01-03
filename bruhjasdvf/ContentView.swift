//
//  ContentView.swift
//  bruhjasdvf
//
//  Created by Kavin Saravanan on 12/14/23.
//

import SwiftUI

struct TodoItem: Identifiable, Encodable, Decodable {
    var id = UUID()
    let todo: String
    let dateAdded: String
}

struct ContentView: View {
    let gray = Color(red: 0.4627, green: 0.8392, blue: 1.0)

    @State private var newTodo = ""
    @State private var allTodos: [TodoItem] = []
    
    var body: some View {
        NavigationView{
            VStack() {
                HStack {
                    TextField("Add todo...", text: $newTodo).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action:  {
                        guard !self.newTodo.isEmpty else { return }
                        let timezone = TimeZone(identifier: "Europe/Rome")!
                        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
                        let date = Date(timeInterval: seconds, since: Date())
                        //let date = Date()
                        let formattedDate = date.formatted(.iso8601.year().month().day())
                        self.allTodos.append(TodoItem(todo: self.newTodo, dateAdded: formattedDate))
                        self.newTodo = ""
                        self.saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 5)
                }.padding()
                List {
                    ForEach(allTodos) { todoItem in
                        VStack() {
                            Text(todoItem.todo)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(todoItem.dateAdded)
                                .font(.system(size: 12, weight: .light))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top], 5)
                                .foregroundColor(.gray)

                        }
                    }.onDelete(perform: deleteTodo)
                }
            }
            .navigationTitle("Todos")
        }.onAppear(perform: loadTodos)
    }
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: "todosKey")
    }
    
    private func loadTodos() {
        if let todosData = UserDefaults.standard.value(forKey: "todosKey") as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
                self.allTodos = todosList
            }
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
        saveTodos()
    }
}
    
    

#Preview {
    ContentView()
}
