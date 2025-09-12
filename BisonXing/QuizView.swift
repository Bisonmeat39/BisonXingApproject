//
//  QuizView.swift
//  BisonXing
//
//  Created by You on 9/11/25.
//

import SwiftUI

struct QuizQuestion: Identifiable, Equatable {
    let id = UUID()
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String?
}

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var questions = QuizData.all.shuffled()
    @State private var current = 0
    @State private var selectedIndex: Int? = nil
    @State private var showResult = false
    @State private var score = 0
    @Namespace private var animation

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [.green, .black]),
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                header
                progressBar
                questionCard
                Spacer(minLength: 8)
                actionRow
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .navigationTitle("Bison Quiz")
            .navigationBarTitleDisplayMode(.inline)
        }
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button("Quit") {
//                    dismiss()
//                }
//                .tint(.green)
//            }
//        }
        .sheet(isPresented: $showResult) {
            QuizResultView(
                score: score,
                total: questions.count,
                onRestart: resetQuiz, onQuit: {dismiss()}
            )
            .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            Text("Question \(current + 1) of \(questions.count)")
                .font(.headline).foregroundStyle(.white.opacity(0.9))
            Spacer()
            Text("Score: \(score)")
                .font(.headline).foregroundStyle(.white.opacity(0.9))
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            let progress = CGFloat(current) / CGFloat(max(1, questions.count))
            ZStack(alignment: .leading) {
                Capsule().fill(.white.opacity(0.15))
                Capsule()
                    .fill(.white)
                    .frame(width: geo.size.width * progress)
                    .animation(.easeInOut(duration: 0.25), value: current)
            }
        }
        .frame(height: 10)
        .accessibilityLabel("Quiz progress")
    }

    private var questionCard: some View {
        let q = questions[current]
        return VStack(alignment: .leading, spacing: 16) {
            Text(q.prompt)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            VStack(spacing: 10) {
                ForEach(q.options.indices, id: \.self) { idx in
                    AnswerRow(
                        text: q.options[idx],
                        state: answerState(for: idx),
                        tapped: { handleSelection(idx) }
                    )
                }
            }

            if let selected = selectedIndex,
               let exp = q.explanation, !exp.isEmpty {
                let isCorrect = selected == q.correctIndex
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: isCorrect ? "checkmark.seal.fill" : "xmark.octagon.fill")
                        .foregroundStyle(isCorrect ? .green : .red)
                    Text(exp)
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.subheadline)
                }
                .padding(.top, 6)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }

    private var actionRow: some View {
        HStack {
            Button("Restart") {
                resetQuiz()
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .foregroundStyle(.white)

            Spacer()

            Button(current == questions.count - 1 ? "See Results" : "Next") {
                goNext()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(selectedIndex == nil)
        }
    }

    // MARK: - Logic

    private func handleSelection(_ idx: Int) {
        guard selectedIndex == nil else { return } // lock after first tap
        selectedIndex = idx
        if idx == questions[current].correctIndex {
            score += 1
        }
    }

    private func goNext() {
        if current == questions.count - 1 {
            showResult = true
        } else {
            withAnimation(.easeInOut) {
                current += 1
                selectedIndex = nil
            }
        }
    }

    private func resetQuiz() {
        questions = QuizData.all.shuffled()
        current = 0
        score = 0
        selectedIndex = nil
        showResult = false
    }

    private func answerState(for idx: Int) -> AnswerRow.State {
        guard let selected = selectedIndex else { return .idle }
        if idx == questions[current].correctIndex {
            return .correct(selected == idx)
        }
        if selected == idx {
            return .wrong
        }
        return .dimmed
    }
}

private struct AnswerRow: View {
    enum State {
        case idle
        case correct(Bool)     // Bool indicates whether this is the selected correct
        case wrong
        case dimmed
    }

    let text: String
    let state: State
    let tapped: () -> Void

    var body: some View {
        Button(action: tapped) {
            HStack {
                Image(systemName: iconName)
                    .opacity(iconOpacity)
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .background(background)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(border, lineWidth: 1)
            )
        }
        .disabled(isLocked)
    }

    private var isLocked: Bool {
        if case .idle = state { return false }
        return true
    }

    private var iconName: String {
        switch state {
        case .idle: return "circle"
        case .correct(let selected): return selected ? "checkmark.circle.fill" : "checkmark.circle"
        case .wrong: return "xmark.circle.fill"
        case .dimmed: return "circle"
        }
    }

    private var iconOpacity: Double {
        switch state {
        case .dimmed: return 0.4
        default: return 1.0
        }
    }

    private var background: some View {
        switch state {
        case .idle: return AnyView(Color.white.opacity(0.06))
        case .correct: return AnyView(Color.green.opacity(0.35))
        case .wrong: return AnyView(Color.red.opacity(0.35))
        case .dimmed: return AnyView(Color.white.opacity(0.03))
        }
    }

    private var border: Color {
        switch state {
        case .idle: return .white.opacity(0.15)
        case .correct: return .green.opacity(0.8)
        case .wrong: return .red.opacity(0.8)
        case .dimmed: return .white.opacity(0.08)
        }
    }
}

private struct QuizResultView: View {
    let score: Int
    let total: Int
    let onRestart: () -> Void
    let onQuit: () -> Void

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [.green, .black]),
                center: .center,
                startRadius: 50,
                endRadius: 500
            ).ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Results")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                Text("\(score) / \(total)")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(resultMessage)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                HStack{
                    
                    Button("Restart Quiz") {
                        onRestart()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    Button("Quit") {
                        onQuit()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                    .padding(.top, 6)
                }
                .padding()
            
        }
    }

    private var resultMessage: String {
        let pct = Double(score) / Double(max(1, total))
        switch pct {
        case 0.9...: return "Bison expert! You know your stuff."
        case 0.7..<0.9: return "Great job—strong understanding of bison safety and history."
        case 0.5..<0.7: return "Nice start. Review the sections and try again!"
        default: return "Keep learning—check the History, Preservation, and Safety pages."
        }
    }
}

// MARK: - Question Bank

enum QuizData {
    static let all: [QuizQuestion] = [
        QuizQuestion(
            prompt: "How fast can a bison run?",
            options: ["About 15 mph", "About 25 mph", "About 35 mph", "About 50 mph"],
            correctIndex: 2,
            explanation: "Bison can sprint up to ~35 mph—faster than most people."
        ),
        QuizQuestion(
            prompt: "What is the safest way to view bison?",
            options: [
                "Approach slowly from behind",
                "Feed them to keep them calm",
                "Observe from a distance and stay on marked trails",
                "Make loud noises so they know you’re there"
            ],
            correctIndex: 2,
            explanation: "Keep distance and stay on trails; never approach or feed wildlife."
        ),
        QuizQuestion(
            prompt: "Which behavior is a warning sign from a bison?",
            options: ["Grazing quietly", "Tail hanging loosely", "Pawing the ground and snorting", "Lying down"],
            correctIndex: 2,
            explanation: "Pawing, head shaking, and snorting often precede a charge."
        ),
        QuizQuestion(
            prompt: "If a bison charges, your best immediate move is to…",
            options: [
                "Run straight back as fast as you can",
                "Climb a tree or get behind solid cover",
                "Wave your arms and yell",
                "Lie down and play dead"
            ],
            correctIndex: 1,
            explanation: "Put a barrier between you and the animal—rock, tree, vehicle."
        ),
        QuizQuestion(
            prompt: "Why are bison important to prairie ecosystems?",
            options: [
                "They pollinate flowers",
                "Their grazing and movement shape plant communities",
                "They control rodent populations",
                "They spread coral reefs"
            ],
            correctIndex: 1,
            explanation: "Bison grazing patterns maintain grassland diversity and structure."
        ),
        QuizQuestion(
            prompt: "By 1900, North American bison populations…",
            options: [
                "Were unchanged from pre-colonial estimates",
                "Had grown due to conservation",
                "Had plummeted to near-extinction",
                "Were only found in Europe"
            ],
            correctIndex: 2,
            explanation: "Commercial hunting and habitat loss nearly wiped them out."
        ),
        QuizQuestion(
            prompt: "A key modern preservation strategy is…",
            options: [
                "Keeping bison exclusively in zoos",
                "Reintroducing and managing herds on protected lands",
                "Reducing genetic diversity",
                "Eliminating all human contact"
            ],
            correctIndex: 1,
            explanation: "Managed herds on public and tribal lands help restore ecosystems."
        ),
        QuizQuestion(
            prompt: "How should pets be handled near bison?",
            options: [
                "Let them roam to get used to wildlife",
                "Keep them leashed and close",
                "Carry them to appear bigger",
                "Encourage them to chase bison away"
            ],
            correctIndex: 1,
            explanation: "Unpredictable movements can trigger defensive behavior."
        ),
        QuizQuestion(
            prompt: "Which statement about bison is TRUE?",
            options: [
                "They are domesticated and docile",
                "They can pivot quickly despite their size",
                "They cannot run uphill",
                "They are primarily nocturnal"
            ],
            correctIndex: 1,
            explanation: "Bison can turn and accelerate quickly—don’t rely on outrunning them."
        ),
        QuizQuestion(
            prompt: "A good minimum distance from bison is…",
            options: ["10 feet", "25 feet", "50 feet", "100+ feet (30+ meters)"],
            correctIndex: 3,
            explanation: "Keep at least 100 feet (30 m) away; more is safer."
        ),
        QuizQuestion(prompt: "Why is it important to protect the Bison?", options: ["Because Bison meat is delicious.", "Because Bison play a key role in maintaining healthy grasslands.", "Because Bison are a symbol of resilience.", "Because Bison are cute."], correctIndex: 1, explanation: "Healthy grasslands are important to many other creatures. Bison are cute, though.")
    ]
}

#Preview {
    NavigationStack {
        QuizView()
    }
}
