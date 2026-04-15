import SwiftUI
import Charts

struct ChartView: View {
    let time_dir: String
    let intens: [String]
    let roads: [String] = ["Первая", "Вторая", "Третья", "Все"]
    
    @State private var r: [[Double]] = [[], [], [], []]
    @State private var selectedRoad: String = "Первая"
    @State private var showStatsSheet = false  // Состояние для модального окна
    
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("График результатов")
                        .font(.largeTitle)
                        .padding()
                        .glassEffect()
                        .padding(.horizontal, 65)
                    
                    Button(action: {r = generate_data()}) {
                        Image(systemName: "arrow.trianglehead.clockwise")
                            .font(.title)
                            .foregroundStyle(.green)
                            .contentShape(Rectangle())
                            .frame(width: 60, height: 60)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .glassEffect()
                    
                    Button(action: { showStatsSheet = true }) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.title)
                            .foregroundStyle(.blue)
                            .contentShape(Rectangle())
                            .frame(width: 60, height: 60)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .glassEffect()
                }
                
                Picker("Выберите полосу:", selection: $selectedRoad) {
                    ForEach(roads, id: \.self) { road in
                        Text(road)
                    }
                }
                .pickerStyle(.segmented)
                .cornerRadius(30)
                .tint(selectedRoad == roads[0] ? .blue :
                      selectedRoad == roads[1] ? .purple :
                      selectedRoad == roads[2] ? .orange : .red)
                .scaleEffect(1.2)
                .padding(.horizontal, 30)
                .padding()
                .frame(minWidth: 100)
            }
            
            VStack{
                let selectedIndex = roads.firstIndex(of: selectedRoad) ?? 0
                let events = r[selectedIndex]
                let chartData = getChartData(from: events)
                
                Chart(chartData, id: \.time) { item in
                    LineMark(
                        x: .value("Время", item.time),
                        y: .value("Количество заявок", item.count)
                    )
                    .foregroundStyle(colorForRoad(selectedRoad))
                    .interpolationMethod(.stepEnd)
                    
                    PointMark(
                        x: .value("Время", item.time),
                        y: .value("Количество заявок", item.count)
                    )
                    .foregroundStyle(colorForRoad(selectedRoad))
                    .symbolSize(30)
                }
                .chartXAxisLabel("Время (часы)", position: .bottom)
                .chartYAxisLabel("Количество заявок", position: .leading)
                .padding()
                .frame(height: 500)
                

                Text("Всего событий: \(events.count)")
                .font(.title3)
                .padding(10)
                .glassEffect()
            }
        }
        .onAppear {
            r = generate_data()
        }
        .sheet(isPresented: $showStatsSheet) {
            StatsSheetView(intens: intens, r: r)
        }
    }
    
    func getChartData(from events: [Double]) -> [(time: Double, count: Int)] {
        var data: [(time: Double, count: Int)] = []
        
        for (index, time) in events.enumerated() {
            data.append((time: time, count: index + 1))
        }
        
        return data
    }
    
    func colorForRoad(_ road: String) -> Color {
        switch road {
        case "Первая":
            return .blue
        case "Вторая":
            return .purple
        case "Третья":
            return .orange
        case "Все":
            return .green
        default:
            return .gray
        }
    }
    
    func generate_data() -> [[Double]] {
        var result: [[Double]] = []
        
        guard let timeDirValue = Double(time_dir) else {
            return [[], [], [], []]
        }
        
        for i in 0..<4 {
            var time: Double = 0
            var events: [Double] = []
            
            var intensityValue: Double = 0.0
            
            if i != 3 {
                guard i < intens.count else { continue }
                guard let value = Double(intens[i]) else { continue }
                intensityValue = value
            } else {
                guard intens.count >= 3 else { continue }
                guard let val0 = Double(intens[0]),
                      let val1 = Double(intens[1]),
                      let val2 = Double(intens[2]) else { continue }
                intensityValue = val0 + val1 + val2
            }
            
            while time <= timeDirValue {
                let random = Double.random(in: 0.0001...1)
                time += (-1 / intensityValue * log(random))
                if time <= timeDirValue {
                    events.append(time)
                }
            }
            result.append(events)
        }
        
        return result
    }
}



#Preview {
    ChartView(time_dir: "12", intens: ["1", "2", "3"])
}
