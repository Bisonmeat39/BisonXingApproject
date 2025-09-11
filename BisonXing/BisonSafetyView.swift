import SwiftUI

struct BisonSafetyView: View {
    var body: some View {
        ZStack {
            // Background
            RadialGradient(
                gradient: Gradient(colors: [.green, .black]),
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()

            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Video Player
                    YouTubeView(videoID: "AQdSIwIL1io")
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.horizontal)

                    // Safety Title
                    Text("Bison Safety Tips")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    // Tips
                    safetyTipsView
                        .padding(.horizontal)
                }
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Bison Safety") // ✅ Belongs outside the ScrollView
    }

    private var safetyTipsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            tip("Always maintain a safe distance. Bison are unpredictable and can run up to 35 mph.")
            tip("Never approach or feed them — even calm-looking animals can become aggressive.")
            tip("Stay on marked trails and avoid walking behind bison; they may not see you.")
            tip("If a bison charges, seek shelter behind a rock, tree, or vehicle—not run straight back.")
            tip("Keep pets leashed and children close — bison might perceive sudden movements as threats.")
        }
    }

    private func tip(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(text)
        }
        .font(.body)
    }
}

#Preview {
    NavigationStack {
        BisonSafetyView()
    }
}
