//
//  ContentView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct ContentView: View {
    @State private var resume: Resume = sampleResume // Use @State for local state
    var body: some View {
        ResumeEditorView(resume: resume)
            .onAppear{
                printFonts()
            }
    }
    func printFonts() {
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family), Fonts: \(names)")
            }
        }
}

#Preview {
    ContentView()
}
