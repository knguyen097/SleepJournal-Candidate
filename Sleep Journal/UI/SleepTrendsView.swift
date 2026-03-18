// Trends dashboard for summarizing recent sleep patterns.
//
// Displays a 7-day sleep chart, sleep threshold summary,
// mood counts, and recent journal notes.
import Charts
import SwiftUI

struct SleepTrendsView: View {
    @State private var entries: [SleepEntry] = []

    // View Layout: presents trend summaries derived from saved journal entries
    var body: some View {
        List {
            Section("7-Day Sleep Hours") {
                Chart(dayBuckets) { bucket in
                    BarMark(
                        x: .value("Day", bucket.day, unit: .day),
                        y: .value("Hours", bucket.hours)
                    )
                    .foregroundStyle(color(for: bucket.hours))
                }
                .frame(height: 220)
            }
            
            // Summarizes the most recent days into buckets that match the chart's color coding
            Section("Sleep Overview") {
                HStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)

                    Text("Poor Sleep (< 6 hrs)")
                    Spacer()
                    Text("\(poorSleepDays)")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 10, height: 10)

                    Text("Okay Sleep (6–7 hrs)")
                    Spacer()
                    Text("\(okaySleepDays)")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)

                    Text("Good Sleep (7+ hrs)")
                    Spacer()
                    Text("\(goodSleepDays)")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Mood Snapshot") {
                ForEach(DailyMood.allCases) { mood in
                    let count = entries.filter { $0.mood == mood }.count
                    HStack {
                        Text(mood.label)
                        Spacer()
                        Text("\(count)")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Recent Notes") {
                ForEach(entries.prefix(5)) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.notes.isEmpty ? "No notes" : entry.notes)
                            .font(.body)
                        Text(entry.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Trends")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Reload") {
                    loadEntries()
                }
            }
        }
        .onAppear {
            loadEntries()
        }
    }
    
    // Maps sleep duration to chart colors: red for < 6 hours, yellow for 6-7 hours, and green for 7+ hours
    private func color(for hours: Double) -> Color {
        if hours < 6 {
            return .red
        } else if hours < 7 {
            return .yellow
        } else {
            return .green
        }
    }
    
    private var poorSleepDays: Int {
        dayBuckets.filter { $0.hours < 6 }.count
    }

    private var okaySleepDays: Int {
        dayBuckets.filter { $0.hours >= 6 && $0.hours < 7 }.count
    }

    private var goodSleepDays: Int {
        dayBuckets.filter { $0.hours >= 7 }.count
    }
    
    // Groups entries by calendar day and shows one bar per day instead of one bar per entry
    private var dayBuckets: [SleepDayBucket] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.createdAt) }
        return grouped
            .map { day, dayEntries in
                let total = dayEntries.map(\.sleepHours).reduce(0, +)
                let average = total / Double(max(dayEntries.count, 1))
                return SleepDayBucket(day: day, hours: average)
            }
            .sorted(by: { $0.day < $1.day })
            .suffix(7)
            .map { $0 }
    }

    private func loadEntries() {
        entries = JournalStore.shared.loadEntries()
    }
}

private struct SleepDayBucket: Identifiable {
    let id = UUID()
    let day: Date
    let hours: Double
}
