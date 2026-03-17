import CoreLocation
import SwiftUI

struct SleepEntryFormView: View {
    let onSave: (SleepEntry) -> Void
    let onCancel: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var currentStep = 0
    @State private var sleepHours: Double = 7.0
    @State private var sleepQuality: SleepQuality = .okay
    @State private var mood: DailyMood = .neutral
    @State private var selectedTags: Set<SleepTag> = []
    @State private var notes: String = ""

    @State private var weather: WeatherSnapshot?
    @State private var cachedWeather: WeatherSnapshot?
    @State private var isLoadingWeather = false
    @State private var weatherError: String?

    private let locationProvider = DeviceLocationProvider()
    private let weatherClient = WeatherClient()
    private let weatherCacheStore = WeatherCacheStore.shared

    var body: some View {
        Form {
            Section("Flow") {
                Picker("Step", selection: $currentStep) {
                    Text("Sleep").tag(0)
                    Text("Mood & Context").tag(1)
                }
                .pickerStyle(.segmented)
            }

            if currentStep == 0 {
                Section("Last Night") {
                    Stepper(value: $sleepHours, in: 0...14, step: 0.5) {
                        Text("Hours slept: \(sleepHours.formatted())")
                    }

                    Picker("Sleep quality", selection: $sleepQuality) {
                        ForEach(SleepQuality.allCases) { quality in
                            Text(quality.label).tag(quality)
                        }
                    }
                }
            } else {
                Section("How You Feel") {
                    Picker("Current mood", selection: $mood) {
                        ForEach(DailyMood.allCases) { moodOption in
                            Text(moodOption.label).tag(moodOption)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        ForEach(SleepTag.allCases) { tag in
                            Button {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            } label: {
                                HStack {
                                    Text("\(tag.emoji) \(tag.label)")
                                    Spacer()
                                    if selectedTags.contains(tag) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.indigo)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }

                Section("Weather Context") {
                    if let weatherError {
                        Text(weatherError)
                            .foregroundStyle(.red)
                    }
                    
                    if let weather {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(weather.summary)
                            Text("\(weather.temperatureF.map { "\($0)°F" } ?? "Unknown") • \(weather.wind ?? "No wind data")")
                                .foregroundStyle(.secondary)
                        }
                    } else if weatherError == nil {
                        Text("No weather attached yet.")
                            .foregroundStyle(.secondary)
                    }
                    
                    Button {
                        Task {
                            await loadWeather()
                        }
                    } label: {
                        HStack {
                            Text(isLoadingWeather ? "Fetching Weather..." : "Fetch Current Weather")
                            if isLoadingWeather {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isLoadingWeather)

                    if weatherError != nil {
                        Button("Retry Weather Fetch") {
                            Task {
                                await loadWeather()
                            }
                        }
                        .disabled(isLoadingWeather)
                    }

                    if let cachedWeather {
                        Button("Use Last Cached Weather") {
                            weather = cachedWeather
                            weatherError = nil
                        }
                        .disabled(isLoadingWeather)
                        Text("Cached: \(cachedWeather.fetchedAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No cached weather available.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if currentStep == 0 {
                Section {
                    Button("Next: Mood & Context") {
                        currentStep = 1
                    }
                }
            } else {
                Section {
                    Button("Back: Sleep") {
                        currentStep = 0
                    }
                }
            }
        }
        .navigationTitle("New Sleep Entry")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    onCancel()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveEntry()
                }
            }
        }
        .onAppear {
            cachedWeather = weatherCacheStore.load()
        }
    }

    private func saveEntry() {
        let sortedTags = SleepTag.allCases.filter { selectedTags.contains($0) }
        let entry = SleepEntry(
            id: UUID(),
            createdAt: Date(),
            sleepHours: sleepHours,
            sleepQuality: sleepQuality,
            mood: mood,
            tags: sortedTags,
            notes: notes,
            weather: weather
        )
        onSave(entry)
    }

    private func loadWeather() async {
        isLoadingWeather = true
        weatherError = nil
        defer { isLoadingWeather = false }

        guard let coordinate = await locationProvider.requestSingleLocation() else {
            if let cachedWeather {
                weather = cachedWeather
                weatherError = "Location unavailable. Showing last saved weather."
            } else {
                weather = nil
                weatherError = "Location unavailable. Please try again."
            }
            return
        }

        do {
            let snapshot = try await weatherClient.fetchCurrentWeather(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            weather = snapshot
            weatherCacheStore.save(snapshot)
            cachedWeather = snapshot
            weatherError = nil
        } catch {
            if let cachedWeather {
                weather = cachedWeather
                weatherError = "Unable to refresh weather. Showing last saved weather."
            } else {
                weather = nil
                weatherError = "Weather unavailable. Please try again."
            }
        }
    }
}
