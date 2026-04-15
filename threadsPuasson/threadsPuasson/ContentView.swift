import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State var time_dir: String = ""
    @State var intens: [String] = ["", "", ""]
    
    var isEnabled: Bool {
        return !time_dir.isEmpty &&
        Double(time_dir) != nil &&
        Double(time_dir)! > 0 &&
        Double(time_dir)! < 100_000 &&
        intens.allSatisfy { !$0.isEmpty && Double($0) != nil && Double($0)! > 0 }
    }
    
    var body: some View {
        VStack {
            VStack {
                if selectedTab == 0 {
                    InputFormView(time_dir: $time_dir, intens: $intens)
                } else {
                    ChartView(time_dir: time_dir, intens: intens)
                }
                
                HStack(spacing: 15) {
                    TabButton(icon: "info", isSelected: selectedTab == 0)
                        .foregroundColor(.blue)
                        .onTapGesture { withAnimation(.spring()) { selectedTab = 0 } }
                    TabButton(icon: "chart.bar", isSelected: selectedTab == 1)
                        .foregroundColor(isEnabled ? .green : .red)
                        .onTapGesture {
                            if isEnabled {
                                withAnimation(.spring) { selectedTab = 1 }
                            }
                        }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                        .glassEffect()
                )
                .padding(.bottom, 10)
            }
            .padding()
        }
    }
    
}

struct TabButton: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 23, weight: .regular))
            .scaleEffect(isSelected ? 1.2 : 1)
            .frame(width: 55, height: 45)
            .background(
                Capsule()
                    .fill(isSelected ? Color.white.opacity(0.13) : Color.clear)
            )
    }
}


#Preview {
    ContentView()
}
