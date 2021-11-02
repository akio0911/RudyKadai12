//
//  ContentView.swift
//  Kadai12
//

import SwiftUI

struct ContentView: View {
    @State var includedTax: Int = 0
    @State var inputExcludingTax: String = ""
    @AppStorage("tax_rate") private var inputTaxRate: String = ""

    var body: some View {
        ZStack {
            Color.white.opacity(0.01)
                .onTapGesture {
                    UIApplication.shared.closeKeyboard()
                }
            VStack(spacing: 30) {
                HStack {
                    Text("税抜金額")
                    InputTextFieldView(inputText: $inputExcludingTax)
                }
                HStack {
                    Text("消費税率")
                    InputTextFieldView(inputText: $inputTaxRate)
                }
                Button("計算") {
                    includedTax = calcIncludedTaxAmount(excludingTax: inputExcludingTax, taxRate: inputTaxRate) ?? 0
                    UIApplication.shared.closeKeyboard()
                }
                HStack {
                    Text("税抜金額")
                    Spacer()
                    Text("\(includedTax)　円")
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
    private func calcIncludedTaxAmount(excludingTax: String, taxRate: String) -> Int? {
        guard let exTax = Int(excludingTax) else { return nil }
        guard let taxRate = Int(taxRate) else { return nil }
        return Int(exTax * (100 + taxRate) / 100)
    }

}

struct InputTextFieldView: View {
    @Binding var inputText: String

    var body: some View {
        TextField("", text: Binding(
                    get: { inputText },
                    set: { inputText = $0.filter {"0123456789".contains($0)} }))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
