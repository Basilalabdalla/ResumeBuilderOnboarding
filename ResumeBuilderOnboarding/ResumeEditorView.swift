//
//  ResumeEditorView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct SectionView: View {
    @Binding var section: Section
    let isPro: Bool
    let onDelete: (Int) -> Void // Callback for deletion

    var body: some View {
        VStack(alignment: .leading) {

            if section.sectionType == .experience {
                ForEach(section.fields.indices, id:\.self) { fieldIndex in
                    HStack {
                        if section.fields[fieldIndex].fieldName == "responsibilities"{
                            TextEditor(text: $section.fields[fieldIndex].content)
                                .frame(minHeight: 100)
                                .border(Color.gray, width: 0.5)
                                .overlay(alignment: .topTrailing) {
                                    if isPro {
                                        ProLabel()
                                    }
                                }
                            // Simple Input Validation Example (check for empty field)
                            if section.fields[fieldIndex].content.isEmpty {
                                Text("This field cannot be empty.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        } else {
                            TextField("Enter \(section.fields[fieldIndex].fieldName)", text: $section.fields[fieldIndex].content)
                                .textFieldStyle(.roundedBorder)
                            if section.fields[fieldIndex].content.isEmpty{
                                Text("This field cannot be empty")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        Button(action: {
                            onDelete(fieldIndex) // Call the onDelete closure
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }

            } else {
                ForEach(section.fields.indices, id:\.self) { fieldIndex in
                    HStack{
                        TextField("Enter \(section.fields[fieldIndex].fieldName)", text: $section.fields[fieldIndex].content)
                            .textFieldStyle(.roundedBorder)
                        if section.fields[fieldIndex].content.isEmpty{
                            Text("This field cannot be empty")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        Button(action: {
                            onDelete(fieldIndex)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            Button("Add Field") {
                let newField = Field(fieldType: .text, fieldName: "New Field", content: "")
                section.fields.append(newField)
            }
        }
        .padding(.bottom) // Add some padding at the bottom of each section
    }
}



struct ProLabel: View {
    var body: some View {
        Text("Pro")
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.orange)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}


struct ResumeEditorView: View {
    @State private var resume: Resume
    @State private var isProUser: Bool
    @State private var showAlert: Bool = false
    @State private var itemToDelete: DeleteItem? = nil
    @State private var showingTemplateSheet = false // Add this line

    enum DeleteItem {
        case section(Int)
        case field(sectionIndex: Int, fieldIndex: Int)
    }

    var body: some View {
        NavigationView {
            Form {
                Section { // Corrected: Using Section's simpler initializer
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
                    Section { // Corrected empty state
                        Text("Tap 'Add Section' to start building your resume.")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(resume.sections.indices, id: \.self) { sectionIndex in
                        Section { // Corrected: Using Section's simpler initializer
                            SectionView(section: $resume.sections[sectionIndex], isPro: !isProUser && resume.sections[sectionIndex].sectionType != .education, onDelete: { fieldIndex in
                                itemToDelete = .field(sectionIndex: sectionIndex, fieldIndex: fieldIndex)
                                showAlert = true
                            })
                        } header: {
                            Text(resume.sections[sectionIndex].sectionType.localizedName).font(.headline)
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
                ToolbarItem(placement: .navigationBarLeading) { // Add this
                    Button("Templates") {
                        showingTemplateSheet = true
                    }
                }
            }
            .alert(isPresented: $showAlert) { // Confirmation Alert
                switch itemToDelete {
                case .section(let index):
                    return Alert(
                        title: Text("Delete Section"),
                        message: Text("Are you sure you want to delete this section?"),
                        primaryButton: .destructive(Text("Delete")) {
                            resume.sections.remove(at: index)
                            itemToDelete = nil // Reset after deletion
                        },
                        secondaryButton: .cancel() {
                            itemToDelete = nil // Reset if canceled
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
                    return Alert(title: Text("Error"), message: Text("Nothing to delete")) // Should never happen, but good practice
                }

            }
            .sheet(isPresented: $showingTemplateSheet) {
                TemplateSelectionView(selectedTemplate: $resume.template, isProUser: isProUser)
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
            print("Resume saved to: \(fileURL)") // For debugging
        } catch {
            print("Error saving resume: \(error)")
        }
    }
    func loadResume() {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent("resume.json")

            // Check if the file exists before trying to read from it
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let loadedResume = try decoder.decode(Resume.self, from: data)
                // Use the main thread since this is a UI Update
                DispatchQueue.main.async {
                    self.resume = loadedResume  //update our @State resume
                }
                print("Resume loaded from: \(fileURL)") // For debugging
            } else {
                print("Resume file does not exist.")
                // Load a sample resume or handle the case where no resume is saved
                DispatchQueue.main.async{
                    self.resume = sampleResume
                }
            }
        } catch {
            print("Error loading resume: \(error)")
            // Handle loading errors (e.g., show an alert, load a default resume)
            DispatchQueue.main.async {
                self.resume = sampleResume // Fallback to sample resume on error
            }
        }
    }
}
#Preview {
    ResumeEditorView(isProUser: false)
}
#Preview {
    ResumeEditorView(isProUser: true)
}
