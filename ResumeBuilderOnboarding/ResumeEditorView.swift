//
//  ResumeEditorView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

// --- SectionView (MUST be defined BEFORE ResumeEditorView) ---
struct SectionView: View {
    @Binding var section: Section
    let isPro: Bool
    let onDelete: (Int) -> Void // Callback for deletion

    var body: some View {
        VStack(alignment: .leading) {
            Text(section.sectionType.localizedName) //Section header
                .font(.headline)
                .padding(.bottom, 4)
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

// --- ResumeEditorView ---
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
            ScrollView{ //Use scroll view
                VStack(alignment: .leading) {
                    Text("Resume Editor (Try It Out)")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom)

                    // Template Selection (Placeholder)
                    HStack {
                        Text("Template:")
                            .font(.headline)
                        Text(resume.template.name)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.bottom)

                    if resume.sections.isEmpty {
                        Text("Tap 'Add Section' to start building your resume.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(resume.sections.indices, id: \.self) { sectionIndex in
                            VStack(alignment: .leading) { // Put each section in a VStack
                                Text(resume.sections[sectionIndex].sectionType.localizedName)
                                    .font(.headline)
                                    .padding(.bottom, 4)

                                SectionView(section: $resume.sections[sectionIndex], isPro: !isProUser && resume.sections[sectionIndex].sectionType != .education, onDelete: { fieldIndex in
                                    itemToDelete = .field(sectionIndex: sectionIndex, fieldIndex: fieldIndex)
                                    showAlert = true
                                })
                            }
                        }
                    }

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
                        .foregroundColor(.red)
                    }
                    .padding(.top)

                    Text("Note: Create an account to save your resume and unlock all features.") //Keep the text.
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                .padding() //Padding for the whole content.
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
        .onAppear {
            loadResume()
        }
    }

    init(resume: Resume = sampleResume, isProUser: Bool = false) {
        self._resume = State(initialValue: resume)
        self._isProUser = State(initialValue: isProUser)
    }

    func saveResume() { /* (Implementation remains the same) */ }
    func loadResume() { /* (Implementation remains the same) */ }
}


#Preview {
    ResumeEditorView(isProUser: false)
}
#Preview {
    ResumeEditorView(isProUser: true)
}
