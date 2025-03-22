//
//  ProLabel.swift
//  ResumeBuilderOnboarding
//
//  Created by Admin on 22/03/2025.
import SwiftUI

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
