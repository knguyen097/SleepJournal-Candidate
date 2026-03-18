/// Displays a detailed view of a single SleepEntry.
///
///  This view presents all recorded data including:
///  - Sleep metrics (hours, quality, mood)
///  - Context (tags, location, weather)
///  - User-generated content (notes and optional photo)

import UIKit

final class SleepEntryDetailViewController: UIViewController {
    private let entry: SleepEntry
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()

    init(entry: SleepEntry) {
        self.entry = entry
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// View Setup
    /// Sets up the scrollable layout and populates all entry details.
    /// Uses a UIScrollView + UIStackView combination to allow flexible,
    /// vertically stacked content that adapts to different data lengths
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sleep Details"

        /// Scroll View
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        /// Content View
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        /// Stack View
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stack)

        /// Photo - Display attached photo if available, uses UIImageView for UIKit compatibility, image is scaled to fit and clipped for a clean UI appearance
        if let photoData = entry.photoData, let image = UIImage(data: photoData) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(imageView)
            imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        }
        
        /// Core Sleep Data - Displays basic sleep information such as date, quality, mood, and duration
        stack.addArrangedSubview(makeDetailLabel(title: "Date", value: dateFormatter.string(from: entry.createdAt), style: .body))
        stack.addArrangedSubview(makeDetailLabel(title: "Sleep", value: entry.sleepQuality.label, style: .body))
        stack.addArrangedSubview(makeDetailLabel(title: "Mood", value: entry.mood.label, style: .body))
        stack.addArrangedSubview(makeDetailLabel(title: "Hours", value: entry.sleepHours.formatted(), style: .body))
        
        /// Tags - Combine all selected tags into a readable string, falls back to "No tags" if none were selected
        let tagsText = entry.tags.isEmpty ? "No tags" : entry.tags.map { "\($0.emoji) \($0.label)" }.joined(separator: ", ")
        stack.addArrangedSubview(makeDetailLabel(title: "Tags", value: tagsText, style: .body))

        /// Location - Display readable location if available, otherwise show a fallback value
        if let location = entry.location {
            stack.addArrangedSubview(makeDetailLabel(title: "Location", value: location.name, style: .body))
        } else {
            stack.addArrangedSubview(makeDetailLabel(title: "Location", value: "None", style: .body))
        }

        /// Weather - Display capture weather data if it exists, provided fallback and error messages in the event of location unavailability
        if let weather = entry.weather {
            stack.addArrangedSubview(makeDetailLabel(title: "Weather", value: weather.summary, style: .body))
            stack.addArrangedSubview(makeDetailLabel(title: "Temperature", value: weather.temperatureF.map { "\($0)°F" } ?? "Unknown", style: .body))
            stack.addArrangedSubview(makeDetailLabel(title: "Wind", value: weather.wind ?? "Unknown", style: .body))
        } else {
            stack.addArrangedSubview(makeDetailLabel(title: "Weather", value: "Not captured", style: .body))
        }
        
        /// Notes - Display user entered notes, falls back to "None" if no notes were provided
        stack.addArrangedSubview(makeDetailLabel(title: "Notes", value: entry.notes.isEmpty ? "None" : entry.notes, style: .body))

        
        /// Constraints - Ensures layout relationships between ScrollView, ContentView, and StackView
        /// Meets these areas: full-width content, proper scrolling behavior, dynamic height based on content
        NSLayoutConstraint.activate([
            /// ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            /// ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            /// StackView Constraint
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    /// Creates a UILabel with consistent styling for detail rows
    /// Returns: Configured UILabel ready for stack insertion
    private func makeDetailLabel(title: String, value: String, style: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0

        let baseFont = UIFont.preferredFont(forTextStyle: style)
        let titleFont = UIFont.systemFont(ofSize: baseFont.pointSize, weight: .semibold)

        let attributed = NSMutableAttributedString(
            string: "\(title): ",
            attributes: [
                .font: titleFont,
                .foregroundColor: UIColor.label
            ]
        )

        attributed.append(
            NSAttributedString(
                string: value,
                attributes: [
                    .font: baseFont,
                    .foregroundColor: UIColor.label
                ]
            )
        )

        label.attributedText = attributed
        return label
    }
}
