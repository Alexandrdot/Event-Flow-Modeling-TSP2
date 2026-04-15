import SwiftUI

struct StatsSheetView: View {
    let intens: [String]
    let r: [[Double]]
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Статистика времени ожидания")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if intens.count >= 3,
                       let lambda1 = Double(intens[0]),
                       let lambda2 = Double(intens[1]),
                       let lambda3 = Double(intens[2]) {
                        
                        let lambdaSum = lambda1 + lambda2 + lambda3
                        let mt = 1 / lambdaSum
                        let sigma = mt
                        
                        GroupBox("Теоретические значения") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Интенсивность суперпозиции Λ: \(String(format: "%.3f", lambdaSum)) авт/час")
                                Text("Математическое ожидание mt: \(String(format: "%.3f", mt)) час")
                                Text("Среднеквадратическое отклонение σt: \(String(format: "%.3f", sigma)) час")
                                Text("Функция плотности: f(t) = Λ * e^(-Λt)")
                                Text("Функция распределения: F(t) = 1 - e^(-Λt)")
                            }
                            .padding(.vertical, 5)
                        }
                        
                        GroupBox("Вероятности ожидания") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("P(t ≤ 0.1  часа) = \(String(format: "%.4f", 1 - exp(-lambdaSum * 0.1)))")
                                Text("P(t ≤ 0.5 часа) = \(String(format: "%.4f", 1 - exp(-lambdaSum * 0.5)))")
                                Text("P(t ≤ 1.0 часа) = \(String(format: "%.4f", 1 - exp(-lambdaSum * 1.0)))")
                                Text("P(t ≤ 2.0 часа) = \(String(format: "%.4f", 1 - exp(-lambdaSum * 2.0)))")
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    
                    GroupBox("Экспериментальные значения (симуляция)") {
                        VStack(alignment: .leading, spacing: 10) {
                            if let firstEvent = r[3].first {
                                Text("Первая машина на дороге: \(String(format: "%.3f", firstEvent)) час")
                            }
                            if let firstEvent = r[0].first {
                                Text("Первая машина на полосе 1: \(String(format: "%.3f", firstEvent)) час")
                            }
                            if let firstEvent = r[1].first {
                                Text("Первая машина на полосе 2: \(String(format: "%.3f", firstEvent)) час")
                            }
                            if let firstEvent = r[2].first {
                                Text("Первая машина на полосе 3: \(String(format: "%.3f", firstEvent)) час")
                            }
                            
                            Text("Всего событий на дороге: \(r[3].count)")
                        }
                    
                    .padding(.vertical, 5)
                }
                    
                    GroupBox("Входные данные") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Интенсивность полосы 1: \(intens[0]) авт/час")
                            Text("Интенсивность полосы 2: \(intens[1]) авт/час")
                            Text("Интенсивность полосы 3: \(intens[2]) авт/час")
                            if let totalIntens = Double(intens[0])! + Double(intens[1])! + (Double(intens[2]) ?? 0) as? Double {
                                Text("Общая интенсивность: \(String(format: "%.3f", totalIntens)) авт/час")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .padding(30)
        .frame(minWidth: 500, minHeight: 600)
    }
}
