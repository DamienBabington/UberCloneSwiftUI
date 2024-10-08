//
//  CustomInputField.swift
//  UberCloneSwiftUI
//
//  Created by Damien Babington on 10/8/24.
//

import SwiftUI

struct CustomInputField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .foregroundStyle(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundStyle(.white)
            }            

            Rectangle()
                .foregroundStyle(Color(.init(white: 1, alpha: 0.3)))
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
        }
    }
}

#Preview {
    CustomInputField(text: .constant(""), title: "Email", placeholder: "name@example.com")
}
