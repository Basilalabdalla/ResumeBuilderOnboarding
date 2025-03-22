//
//  ContentView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct ContentView: View {
    var body: some View {
        ResumeEditorView(resume: sampleResume, isProUser: false)
    }
}
#Preview {
    ContentView()
}
