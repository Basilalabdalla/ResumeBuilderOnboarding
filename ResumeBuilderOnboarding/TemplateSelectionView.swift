//
//  TemplateSelectionView.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct TemplateSelectionView: View {
    @Binding var selectedTemplate: Template
    @Environment(\.dismiss) var dismiss // To dismiss the sheet
    let isProUser: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(sampleTemplates) { template in
                    Button(action: {
                        selectedTemplate = template
                        dismiss()
                    }) {
                        HStack {
                            Text(template.name)
                            Spacer()
                            if template.name == "Pro Template" && !isProUser { // Simple Pro check
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TemplateSelectionView(selectedTemplate: .constant(sampleTemplates[0]), isProUser: false)
}
#Preview {
    TemplateSelectionView(selectedTemplate: .constant(sampleTemplates[0]), isProUser: true)
}
