//
//  ResumeFormView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 22/03/2025.
import SwiftUI

struct ResumeFormView: View {
    @Binding var resume: Resume
    @Binding var isProUser: Bool
    @State private var showAlert: Bool = false
    @State private var itemToDelete: DeleteItem? = nil

    enum DeleteItem {
        case section(Int)
        case field(sectionIndex: Int, fieldIndex: Int)
    }

    var body: some View {
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
                    .foregroundColor(.red)
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
    }
}
#Preview{
    ResumeFormView(resume: .constant(sampleResume), isProUser: .constant(false))
}
