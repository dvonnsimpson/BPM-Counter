//
//  CounterViewModel.swift
//  BPM Counter
//
//  Created by Donovan Simpson on 5/5/24.
//

import Foundation

final class CounterViewModel: ObservableObject {
    @Published var bpm: Int = 1
    var elapsedArray: [CFTimeInterval] = []
    
    func calculateBPM(lastBeat: CFTimeInterval, currentBeat: CFTimeInterval, noteMeasurement: Int) {
        let timeElapsed = currentBeat - lastBeat
        elapsedArray.append(timeElapsed)
        
        let averageTimeElapsed = (elapsedArray.reduce(0.0) { $0 + $1 }) / Double(elapsedArray.count)
        
        let doubleBpm = ((60.0/averageTimeElapsed) * (4.0 / Double(noteMeasurement))).rounded()
        bpm = Int(doubleBpm)
    }
    
    func clearElapsedArray() {
        bpm = 0
        elapsedArray = []
    }
}
