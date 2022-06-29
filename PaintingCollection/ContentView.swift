//
//  ContentView.swift
//  PaintingCollection
//
//  Created by Anna-Alexandra Danchenko on 15.06.2022.
//

import SwiftUI
import Shimmer
import RemoteImage

struct ContentView: View {
    @State var results: PaintingInfo? = nil
    @State var isLoading: Bool = true
    var body: some View {
        ZStack (alignment: .bottom){
            ScrollView {
                VStack (alignment: .leading) {
                    let imageUrl = URL(string: results?.primaryImageSmall  ?? "картинка")
                    //                    ZStack {
                    //                        if isLoading {
                    //                            Color(hex: 0xE0E0E0)
                    //                                .cornerRadius(25)
                    //                                .shimmering(active: true, duration: 1.0, bounce: false)
                    //                                .transition(.opacity)
                    //                        }
                    
                    if (imageUrl != nil) {
                        RemoteImage(type: .url(imageUrl!), errorView: { error in
                            Text(error.localizedDescription)
                        }, imageView: { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(25)
                                .transition(.scale(scale: 0.1, anchor: .center))

//                                .task {
//                                    isLoading = false
//                                }
                            
                        }, loadingView: {
                            Color(hex: 0xE0E0E0)
                                .cornerRadius(25)
                                .shimmering(active: true, duration: 1.0, bounce: false)
                                .frame(height:550, alignment: .center)
                        }
                        )
                        .frame(height:550, alignment: .center)
                    } else {
                        Color(hex: 0xE0E0E0)
                            .cornerRadius(25)
                            .shimmering(active: true, duration: 1.0, bounce: false)
                            .transition(.opacity)
                            .frame(height:550, alignment: .center)
                            .task {
                                let randomID = getRandomElement()
                                await loadData(id: randomID) { (value) in
                                    results = value }
                            }
                    }
                    
//                    if isLoading == false {
                    
                    Text("\(results?.artistDisplayName ?? "Unknown") b.  \(results?.artistBeginDate ?? "Unknown")")
                        .font(.title)
                        .fontWeight(.light)
                    Text("\(results?.title ?? "Unknown"), \(results?.objectDate ?? " ")")
                        .font(.title3)
                        .fontWeight(.light)
                        .minimumScaleFactor(0.3)
                        .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    Text(results?.objectName ?? "  ") // ?? -- если слева оказался nil то возьми то что справа
                        .fontWeight(.light)
                    
//                    } else {
//                        Color(hex: 0xE0E0E0)
//                            .cornerRadius(25)
//                            .shimmering(active: true, duration: 1.0, bounce: false)
//                            .transition(.opacity)
//                            .frame(height:550, alignment: .center)
//                    }
                    
                }
            }
            Button {
                isLoading = true
                Task {
                    let randomID = getRandomElement()
                    await loadData(id: randomID) { (value) in
                        results = value
                    }
                    
                }
            } label: {
                Text("Press Me")
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(width: 200)
            }
            .padding()
            .background(
                RadialGradient(
                    gradient: Gradient(
                        colors: [Color(hex: 0xB09B71), Color(hex: 0xD8CCA3)]
                    ),
                    center: .center,
                    startRadius: 0,
                    endRadius: 100
                )
            )
            .cornerRadius(35)
        }
        .padding()
        .task {
            let randomID = getRandomElement()
            await loadData(id: randomID) { (value) in
                results = value
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

