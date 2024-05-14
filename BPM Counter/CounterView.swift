//
//  ContentView.swift
//  BPM Counter
//
//  Created by Donovan Simpson on 5/5/24.
//

import SwiftUI
import AVFoundation

struct CounterView: View {
    @StateObject private var viewModel = CounterViewModel()
    @State var count: Int = 0
    var number: Int = 50
    @State var rightSideNumber: Int = 4
    @State var leftSideNumber: Int = 4
    @State var taps: [Int] = []
    @State var rightSide: String = ""
    @State var leftSide: String = ""
    @State var soundOn: Bool = true
    @FocusState private var timeSigFocused: TimeSig?
    
    @State var isFirstTap = true
    @State var startTime = CACurrentMediaTime()
    @State var endTime = CACurrentMediaTime()
    
    let columns = [GridItem(.adaptive(minimum: 20))]
    
    
    var body: some View {
        VStack {
            HStack {
                Button("Reset") {
                    count = 0
                    taps = []
                    isFirstTap = true
                    viewModel.clearElapsedArray()
                }
                .buttonStyle(DefaultButton())
                
                Button {
                    soundOn.toggle()
                } label: {
                    soundOn ? Image(systemName: "bell") : Image(systemName: "bell.slash")
                }
                .buttonStyle(DefaultButton())
                
                HStack {
                    TextField("", value: $leftSideNumber, format: .number)
                        .focused($timeSigFocused, equals: .left)
                        .textFieldStyle(CustomBorder())
                        .keyboardType(.numberPad)
                        .padding()
                    
                    Text("\\")
                        .font(.title)
                        .foregroundStyle(.black)
                    
                    TextField("", value: $rightSideNumber, format: .number)
                        .focused($timeSigFocused, equals: .right)
                        .textFieldStyle(CustomBorder())
                        .keyboardType(.numberPad)
                        .padding()
                }
                .padding(.horizontal)
                
                    
            }

            
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .overlay {
                    VStack {
                        Text(isFirstTap ? "Tap to start" : "\(viewModel.bpm)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding()
                        
                        
                        LazyVGrid(columns: columns) {
                            ForEach(taps, id: \.self) { _ in
                                Image(systemName: "star")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding()
                    }
                }
                .foregroundStyle(.black)
                .padding(.top)
                .onTapGesture {
                    timeSigFocused = nil
                    count += 1
                    taps.append(count)
                    if soundOn {
                        AudioServicesPlaySystemSound(1306)
                    }
                    
                    if isFirstTap {
                        isFirstTap.toggle()
                        startTime = CACurrentMediaTime()
                    } else {
                        endTime = CACurrentMediaTime()
                        viewModel.calculateBPM(lastBeat: startTime, currentBeat: endTime, noteMeasurement: rightSideNumber)
                        startTime = endTime
                    }
                }
        }
        .padding()
    }
}

#Preview {
    CounterView()
}

enum TimeSig {
    case left
    case right
}

struct DefaultButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
}

struct CustomBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                Circle()
                    .stroke(.black, lineWidth:1)
            )
    }
}
