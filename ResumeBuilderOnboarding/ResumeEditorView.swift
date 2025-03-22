//
//  ResumeEditorView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct ResumeEditorView: View {
    @State private var resume: Resume
    @State private var isProUser: Bool
    @State private var showAlert: Bool = false
    @State private var itemToDelete: DeleteItem? = nil
    @State private var showingTemplateSheet = false

    enum DeleteItem {
        case section(Int)
        case field(sectionIndex: Int, fieldIndex: Int)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Template:")
                            .font(.headline)
                        Text(resume.template.name)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                } header: {
                    Text("Template")
                }

                // Display existing sections or an empty state message
                if resume.sections.isEmpty {
                    Section {
                        Text("Tap 'Add Section' to start building your resume.")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(resume.sections.indices, id: \.self) { sectionIndex in
                        Section {
                            SectionView(section: $resume.sections[sectionIndex], isPro: !isProUser && resume.sections[sectionIndex].sectionType != .education, onDelete: { fieldIndex in
                                itemToDelete = .field(sectionIndex: sectionIndex, fieldIndex: fieldIndex)
                                showAlert = true
                            })
                        } header: {
                            Text(resume.sections[sectionIndex].sectionType.localizedName)
                        }

                    }
                }

                Section {
                    HStack {
                        Button("Add Section") {
                            let newSection = Section(sectionType: .custom, fields: [Field(fieldType: .text, fieldName: "New Field", content: "")])
                            resume.sections.append(newSection)
                        }

                        Button("Remove Section") {
                            if !resume.sections.isEmpty {
                                itemToDelete = .section(resume.sections.count - 1)
                                showAlert = true
                            }
                        }
                        .foregroundColor(.red) // Make the remove button red
                    }
                }
            }
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
            .alert(isPresented: $showAlert) {
                switch itemToDelete {
                case .section(let index):
                    return Alert(
                        title: Text("Delete Section"),
                        message: Text("Are you sure you want to delete this section?"),
                        primaryButton: .destructive(Text("Delete")) {
                            resume.sections.remove(at: index)
                            itemToDelete = nil
                        },
                        secondaryButton: .cancel() {
                            itemToDelete = nil
                        }
                    )
                case .field(let sectionIndex, let fieldIndex):
                    return Alert(
                        title: Text("Delete Field"),
                        message: Text("Are you sure you want to delete this field?"),
                        primaryButton: .destructive(Text("Delete")) {
                            resume.sections[sectionIndex].fields.remove(at: fieldIndex)
                            itemToDelete = nil
                        },
                        secondaryButton: .cancel() {
                            itemToDelete = nil
                        }
                    )
                case .none:
                    return Alert(title: Text("Error"), message: Text("Nothing to delete"))
                }

            }
            .sheet(isPresented: $showingTemplateSheet) {
                TemplateSelectionView(selectedTemplate: $resume.template, isProUser: isProUser)
            }
            .onChange(of: resume.template) { oldValue, newValue in
                resume.sections = newValue.defaultSections()
            }
        }
        .onAppear{
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
