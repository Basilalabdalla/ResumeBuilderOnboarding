//
//  ResumeEditorView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct ResumeEditorView: View {
    @State private var resume: Resume
    @State private var isProUser: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Resume Editor (Try It Out)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)

                // Template Selection (Placeholder)
                HStack {
                    Text("Template:")
                        .font(.headline)
                    Text(resume.template.name) // Display selected template name
                        .font(.headline)
                        .foregroundColor(.blue)
                    Spacer() // Push elements to the sides
                }
                .padding(.bottom)

                ForEach(resume.sections.indices, id: \.self) { sectionIndex in
                    SectionView(section: $resume.sections[sectionIndex], isPro: !isProUser && resume.sections[sectionIndex].sectionType != .education)
                }

                HStack {
                    Button("Add Section") {
                        // Corrected: Added fieldType: .text
                        let newSection = Section(sectionType: .custom, fields: [Field(fieldType: .text, fieldName: "New Field", content: "")])
                        resume.sections.append(newSection)
                    }

                    Button("Remove Section") {
                        if !resume.sections.isEmpty {
                            resume.sections.removeLast()
                        }
                    }
                }
                .padding(.top)


                Text("Note: Create an account to save your resume and unlock all features.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Resume Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { // Add a toolbar for the Save button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveResume()
                }
            }
        }
    }
    init(resume: Resume = sampleResume, isProUser: Bool = false) {
        self._resume = State(initialValue: resume)
        self.isProUser = isProUser
        loadResume() //load the resume in the init
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

struct SectionView: View {
    @Binding var section: Section  // Now takes a Binding
    let isPro: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(section.sectionType.localizedName)
                    .font(.headline)
                if isPro {
                    ProLabel()
                }
            }
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
                        } else {
                            TextField("Enter \(section.fields[fieldIndex].fieldName)", text: $section.fields[fieldIndex].content)
                                .textFieldStyle(.roundedBorder)
                        }
                        Button(action: {
                            section.fields.remove(at: fieldIndex)
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
                        Button(action: {
                            section.fields.remove(at: fieldIndex)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            Button("Add Field") {
                // Corrected: Added fieldType: .text
                let newField = Field(fieldType: .text, fieldName: "New Field", content: "")
                section.fields.append(newField)
            }
        }
        .padding(.bottom)
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

#Preview {
    ResumeEditorView(isProUser: false)
}
#Preview {
    ResumeEditorView(isProUser: true)
}
