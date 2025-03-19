//
//  ResumeModel.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import Foundation
import SwiftUI

// MARK: - Resume
struct Resume: Identifiable, Codable {
    let id: UUID
    var template: Template
    var sections: [Section]
    var title: String

    init(title: String, template: Template, sections: [Section] = []) {
        self.id = UUID()
        self.title = title
        self.template = template
        self.sections = sections
    }
}

// MARK: - Section
enum SectionType: String, Codable, CaseIterable {
    case summary
    case experience
    case education
    case skills
    case certifications
    case physicalAbilities
    case custom

    var localizedName: String {
        switch self {
        case .summary:
            return "Summary"
        case .experience:
            return "Experience"
        case .education:
            return "Education"
        case .skills:
            return "Skills"
        case .certifications:
            return "Certifications"
        case .physicalAbilities:
            return "Physical Abilities"
        case .custom:
            return "Custom"
        }
    }
}
struct Section: Identifiable, Codable {
    let id: UUID
    var sectionType: SectionType
    var fields: [Field]

    init(sectionType: SectionType, fields: [Field] = []) {
        self.id = UUID()
        self.sectionType = sectionType
        self.fields = fields
    }
}

// MARK: - Field
enum FieldType: String, Codable {
    case text
    case multilineText
    case date
    case number
    // Add more as needed (e.g., boolean, selection)
}

struct Field: Identifiable, Codable {
    let id: UUID
    let fieldType: FieldType
    var fieldName: String //"jobTitle"
    var content: String //"Software Engineer at X Company"

    init(fieldType: FieldType, fieldName: String, content: String = "") {
        self.id = UUID()
        self.fieldType = fieldType
        self.fieldName = fieldName
        self.content = content
    }
}

// MARK: - Template
struct Template: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String //  Store the name of image

    init(name: String, imageName: String = "") {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
    }
}

// MARK: - Preview Data (for Xcode Previews)
let sampleTemplates = [
    Template(name: "Template 1", imageName: "doc.text.fill"),
    Template(name: "Template 2", imageName: "doc.richtext"),
    Template(name: "Pro Template", imageName: "doc.text.fill") //Could add isPro Field
]

let sampleResume = Resume(
    title: "My Resume",
    template: sampleTemplates[0],
    sections: [
        Section(sectionType: .summary, fields: [
            Field(fieldType: .multilineText, fieldName: "summary", content: "Highly motivated software engineer...")
        ]),
        Section(sectionType: .experience, fields: [
            Field(fieldType: .text, fieldName: "jobTitle", content: "Software Engineer"),
            Field(fieldType: .text, fieldName: "company", content: "Acme Corp"),
            Field(fieldType: .date, fieldName: "startDate", content: "2021-06-01"),
            Field(fieldType: .date, fieldName: "endDate", content: "2023-12-31"),
            Field(fieldType: .multilineText, fieldName: "responsibilities", content: "Developed and maintained iOS applications...")
        ]),
        Section(sectionType: .education, fields: [
            Field(fieldType: .text, fieldName: "institution", content: "University of Example"),
            Field(fieldType: .text, fieldName: "degree", content: "Bachelor of Science in Computer Science"),
            Field(fieldType: .date, fieldName: "graduationDate", content: "2021-05-01")
        ]),
        Section(sectionType: .skills, fields: [
            Field(fieldType: .text, fieldName: "skill", content: "Swift"),
            Field(fieldType: .text, fieldName: "skill", content: "SwiftUI"),
            Field(fieldType: .text, fieldName: "skill", content: "Git")
        ]),
        Section(sectionType: .certifications, fields: [
            Field(fieldType: .text, fieldName: "certification", content: "AWS Certified Developer - Associate")
        ]),
        Section(sectionType: .physicalAbilities, fields: [
            Field(fieldType: .text, fieldName: "ability", content: "Lift up to 50 lbs"),
             Field(fieldType: .text, fieldName: "ability", content: "Work in all weather")
        ])
    ]
)
