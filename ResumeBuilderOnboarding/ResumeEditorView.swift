//
//  ResumeEditorView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct ResumeEditorView: View {
    @State private var resume: Resume
    @State private var isProUser: Bool
    @State private var showingTemplateSheet = false

    var body: some View {
        NavigationView {
            ResumeFormView(resume: $resume, isProUser: $isProUser) // Use ResumeFormView
                .navigationTitle("Resume Editor")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveResume()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Templates") {
                            showingTemplateSheet = true
                        }
                    }
                }
                .sheet(isPresented: $showingTemplateSheet) {
                    TemplateSelectionView(selectedTemplate: $resume.template, isProUser: isProUser)
                }
                .onChange(of: resume.template) { oldValue, newValue in
                    resume.sections = newValue.defaultSections()
                }
        }
        .onAppear {
            loadResume()
        }
    }

    init(resume: Resume = sampleResume, isProUser: Bool = false) {
        self._resume = State(initialValue: resume)
        self._isProUser = State(initialValue: isProUser)
    }

    func saveResume() {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent("resume.json")
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(resume)
            try encodedData.write(to: fileURL)
            print("Resume saved to: \(fileURL)")
        } catch {
            print("Error saving resume: \(error)")
        }
    }

    func loadResume() {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent("resume.json")

            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let loadedResume = try decoder.decode(Resume.self, from: data)
                DispatchQueue.main.async {
                    self.resume = loadedResume
                }
                print("Resume loaded from: \(fileURL)")
            } else {
                print("Resume file does not exist.")
                DispatchQueue.main.async {
                    self.resume = sampleResume
                }
            }
        } catch {
            print("Error loading resume: \(error)")
            DispatchQueue.main.async {
                self.resume = sampleResume
            }
        }
    }
}
#Preview{
    ResumeEditorView()
}
