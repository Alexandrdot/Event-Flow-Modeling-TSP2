import SwiftUI

struct InputFormView: View {
    @Binding var time_dir: String
    @Binding var intens: [String]
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "timer")
                    .frame(width: 55, height: 55)
                    .foregroundColor(.green)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(30)
                ClearableTextField(placeholder: "Введите директивное время", text: $time_dir)
                    .cornerRadius(30)
            }
            .padding(.bottom, 10)
            
            ForEach(0..<3, id: \.self) { index in
                HStack {
                    Image(systemName: "figure.run.square.stack")
                        .foregroundColor(.pink)
                        .frame(width: 55, height: 55)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    ClearableTextField(placeholder: "Введите интенсивность \(index + 1)", text: $intens[index])
                }
            }
        }
        .font(.title)
        .padding(.bottom, 20)
    }
}

struct ClearableTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(25)
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                text = ""
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.scale)
                    }
                }
            )
            .animation(.easeInOut, value: text.isEmpty)
    }
}


//#Preview {
//    InputFormView(time_dir: "100", intens: ["0.33", "0.55", "0.77"])
//}
