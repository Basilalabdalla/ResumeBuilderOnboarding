//
//  OnboardingData.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 19/03/2025.
import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String // We'll use system images for simplicity
    let isProFeature: Bool
}

let onboardingData: [OnboardingStep] = [
    OnboardingStep(title: "Create a Professional Resume in Minutes", description: "AI-Powered Assistance to Land Your Dream Job", imageName: "doc.text.magnifyingglass", isProFeature: false),
    OnboardingStep(title: "AI-Powered Suggestions", description: "Get intelligent suggestions for phrases, keywords, and bullet points as you type.", imageName: "lightbulb.fill", isProFeature: true),
    OnboardingStep(title: "Professionally Designed Templates", description: "Choose from a wide variety of modern and professional templates to create a resume that stands out.", imageName: "square.grid.2x2.fill", isProFeature: false),
     OnboardingStep(title: "ATS-Optimized Resumes", description: "Ensure your resume gets past Applicant Tracking Systems and into the hands of hiring managers.", imageName: "checkmark.circle.fill", isProFeature: true)
]
