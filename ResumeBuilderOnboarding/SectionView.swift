//
//  SectionView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 22/03/2025.
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
                            onDelete(fieldIndex)
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
        .padding(.bottom)
    }
}
