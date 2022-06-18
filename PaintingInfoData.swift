//
//  PaintingInfoData.swift
//  PaintingCollection
//
//  Created by Anna-Alexandra Danchenko on 18.06.2022.
//

import Foundation
import SwiftUI

func getRandomElement() -> Int {
    let randomID = objectIdsArray.randomElement()
    return randomID!
}

func loadData(id: Int, completion: @escaping ((PaintingInfo) -> Void)) async { // Notice the new async keyword in there – we’re telling Swift this function might want to go to sleep in order to complete its work.
    // step 1: creating URL we wanna read
    print("loading data \(id)")
    guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)") // We use the guard statement to transfer program control out of scope when certain conditions are not met.
 else {
        print("Invalid URL")
        return
    }
    // step 2 fetching data
    do { // пытается выполнить, если не выполняется, то выполняет catch
        let (data, _) = try await URLSession.shared.data(from: url) // we use the underscore here to ignore the second element of return tuple (in this case methadata). Our work is being done by data(from:) method.
        
        // step 3: decoding the result of that data into a Response struct.

        do {
            let decodedResponse = try JSONDecoder().decode(PaintingInfo.self, from: data)
            completion(decodedResponse)
        }
        catch {
            print("Error \(error)")
        }
    }
    catch {
        print("Invalid data")
    }
}
