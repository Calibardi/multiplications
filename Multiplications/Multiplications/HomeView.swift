//
//  HomeView.swift
//  Multiplications
//
//  Created by Lorenzo Ilardi on 15/04/25.
//

import SwiftUI

struct HomeView: View {
    private let appTittle: String = "Multiplications!"
    @State private var choosenTable: Int = 2
    @State private var numberOfQuestions: Int = 10
    @State private var viewState: ViewState = .starting
    
    var body: some View {
        switch viewState {
        case .starting:
            startingContent
        case .playing:
            Text("Playing!")
        }
    }
}

private extension HomeView {
    enum ViewState {
        case starting
        case playing
    }
    
    var startingContent: some View {
        return ZStack {
            appGradient
            VStack {
                Spacer()
                
                Text(appTittle)
                    .font(.largeTitle)
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Start")
                    Image(systemName: "chevron.right")
                    Spacer()
                }
                .frame(width: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal, 20)
                .onTapGesture {
                    print("tapped")
                }

                VStack {
                    Text("Choose a table to exercise with:")
                        .font(.subheadline)
                    tablePicker
                }
                .padding(.vertical, 20)
                .background(.thinMaterial)
                
                VStack {
                    Text("Choose the number of questions")
                        .font(.subheadline)
                    questionPicker
                }
                .padding(.vertical, 20)
                .background(.thinMaterial)
            }
        }
    }
    
    var tablePicker: some View {
        Picker(selection: $choosenTable) {
            ForEach(2..<13, id: \.self) { element in
                Text(element.description)
            }
        } label: {
            Text("Choose a table")
        }
        .pickerStyle(.palette)
        .frame(width: .infinity, height: 10)
        .padding()
    }
    
    var questionPicker: some View {
        Picker(selection: $numberOfQuestions) {
            ForEach([5, 10, 20], id: \.self) { element in
                Text(element.description)
            }
        } label: {
            Text("Choose the number of questions")
        }
        .pickerStyle(.palette)
        .frame(width: .infinity, height: 10)
        .padding()
    }
    
    var appGradient: some View {
        LinearGradient(
            colors: [.pink, .yellow, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
