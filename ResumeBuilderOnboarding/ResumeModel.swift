//
//  ResumeModel.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import Foundation
import SwiftUI

// MARK: - Enums

enum SectionType: Codable, CaseIterable {
    case summary
    case experience
    case education
    case skills
    case certifications
    case physicalAbilities
    case custom
    case projects // Add the projects case

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
        case .projects: // Add localized name
            return "Projects"
        }
    }
}

enum FieldType: Codable {
    case text
    case multilineText
    //could add Date, number types.
}

enum Template: Codable, Identifiable, Equatable {  // Add Identifiable and Equatable
    case template1
    case template2
    case proTemplate // Added a Pro template

    var id: String { self.name } // Needed for Identifiable

    var name: String {
        switch self {
        case .template1:
            return "Template 1"
        case .template2:
            return "Template 2"
        case .proTemplate:
            return "Pro Template"
        }
    }

     var imageName: String { // Added for potential image previews
        switch self {
        case .template1:
            return "doc.text.fill"  //  SF Symbol name
        case .template2:
            return "doc.richtext"  //  SF Symbol name
        case .proTemplate:
            return "doc.text.fill" //  SF Symbol name - could use a different one
        }
    }
    // IMPORTANT: This function defines the default sections for each template
    func defaultSections() -> [Section] {
        switch self {
        case .template1:
            return [
                Section(sectionType: .summary, fields: [Field(fieldType: .multilineText, fieldName: "Summary", content: "")]),
                Section(sectionType: .experience, fields: [
                    Field(fieldType: .text, fieldName: "Job Title", content: ""),
                    Field(fieldType: .text, fieldName: "Company", content: ""),
                    Field(fieldType: .text, fieldName: "Start Date", content: ""),
                    Field(fieldType: .text, fieldName: "End Date", content: ""),
                    Field(fieldType: .multilineText, fieldName: "Responsibilities", content: "")
                ]),
                Section(sectionType: .education, fields: [
                    Field(fieldType: .text, fieldName: "Institution", content: ""),
                    Field(fieldType: .text, fieldName: "Degree", content: ""),
                    Field(fieldType: .text, fieldName: "Graduation Date", content: "")
                ]),
                Section(sectionType: .skills, fields: [Field(fieldType: .text, fieldName: "Skill", content: "")])
            ]
        case .template2:
            return [
                Section(sectionType: .summary, fields: [Field(fieldType: .multilineText, fieldName: "Summary", content: "")]),
                Section(sectionType: .skills, fields: [Field(fieldType: .text, fieldName: "Skill", content: "")]),
                Section(sectionType: .projects, fields: [
                    Field(fieldType: .text, fieldName: "Project Name", content: ""),
                    Field(fieldType: .multilineText, fieldName: "Description", content: "")
                ])
            ]
        case .proTemplate: // Example of a different set of sections
            return [
                Section(sectionType: .summary, fields:[Field(fieldType: .multilineText, fieldName: "summary", content: "")]),
                Section(sectionType: .experience, fields: [
                    Field(fieldType: .text, fieldName: "jobTitle", content: "Software Engineer"),
                    Field(fieldType: .text, fieldName: "company", content: "Acme Corp"),
                    Field(fieldType: .text, fieldName: "startDate", content: "2021-06-01"),
                    Field(fieldType: .text, fieldName: "endDate", content: "2023-12-31"),
                    Field(fieldType: .multilineText, fieldName: "responsibilities", content: "Developed and maintained iOS applications...\nCollaborated with cross-functional teams.\nImplemented new features and bug fixes.")
                ]),
                Section(sectionType: .education, fields: [
                    Field(fieldType: .text, fieldName: "institution", content: "University of Example"),
                    Field(fieldType: .text, fieldName: "degree", content: "Bachelor of Science in Computer Science"),
                    Field(fieldType: .text, fieldName: "graduationDate", content: "2021-05-01")
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
        }
    }
}

// MARK: - Structs

struct Field: Codable, Identifiable {
    let id = UUID()
    let fieldType: FieldType
    var fieldName: String
    var content: String
}

struct Section: Codable, Identifiable {
    let id = UUID()
    var sectionType: SectionType
    var fields: [Field]
}

struct Resume: Codable, Identifiable {
    let id = UUID() // Add an ID to the Resume
    var template: Template
    var sections: [Section]
    var title: String // Add other properties as needed

    // Initializer that uses the default sections from the template
    init(title: String, template: Template) {
        self.title = title
        self.template = template
        self.sections = template.defaultSections()
    }
}

// MARK: - Preview Data (for Xcode Previews)
let sampleTemplates = [
    Template.template1,
    Template.template2,
    Template.proTemplate
]

// Now uses the initializer
let sampleResume = Resume(title: "My Resume", template: .template1)
