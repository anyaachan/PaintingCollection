//
//  ContentView.swift
//  PaintingCollection
//
//  Created by Anna-Alexandra Danchenko on 15.06.2022.
//

import SwiftUI

struct ContentView: View {
    @State var results: PaintingInfo? = nil
    @State var randomID: Int = getRandomElement()
    var body: some View {
        ScrollView {
            VStack (alignment: .center) {
                let imageUrl = results?.primaryImage ?? "картинка"
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                }
            placeholder: {
                Text("Text")
            }
                Text(results?.title ?? "  ")
                    .font(.title)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                Text(results?.artistDisplayName ?? " ")
                Text(results?.objectName ?? "  ") // ?? -- если слева оказался nil то возьми то что справа
                
                Button("Get Random") {
                    Task {
                        randomID = getRandomElement()
                        await loadData(id: randomID) { (value) in
                            results = value
                        }
                    }
                }
            }
            .padding()
            .task {
                await loadData(id: randomID) { (value) in
                    results = value
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
