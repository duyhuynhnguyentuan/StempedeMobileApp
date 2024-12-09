//
//  ButtonModifier.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import SwiftUI

import SwiftUI

struct ButtonModifier: ViewModifier {
    let buttonHeight: CGFloat
    let backgroundColor: Color
    let buttonWidht: CGFloat
    
    init(buttonHeight: CGFloat = 44, backgroundColor: Color = .primary, buttonWidth: CGFloat = 352) {
        self.buttonHeight = buttonHeight
        self.backgroundColor = backgroundColor
        self.buttonWidht = buttonWidth
    }
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: buttonWidht, height: buttonHeight)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

struct ButtonWithBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 352, height: 32)
            .background(.white)
            .cornerRadius(8)
    }
}
//
//#Preview {
//    ButtonModifier()
//}
