////
////  FormattingTextFieldSUI.swift
////  Examples
////
////  Created by Igor Vedeneev on 04.11.2021.
////
//
//import SwiftUI
//import AGInputControls
//
//
//@available(iOS 14.0, *)
//struct FormattingTextFieldSUI: View {
//    
//    @Binding var text: String
//    
//    var body: some View {
//        TextField("", text: $text)
//            .modifier(FormattedModifier(formatter: DefaultFormatter(mask: "### ## #"), text: $text))
//    }
//}
//
//
//@available(iOS 14.0, *)
//struct FormattedModifier: ViewModifier {
//    
//    let formatter: AGFormatter
//    @Binding var text: String
//    
//    func body(content: Content) -> some View {
//        ZStack(alignment: .leading) {
//            Text(formatter.mask)
//            content
//                .onChange(of: text, perform: { newValue in
//                    $text.wrappedValue = formatter.formattedText(text: text) ?? ""
//                })
//        }
//    }
//}
