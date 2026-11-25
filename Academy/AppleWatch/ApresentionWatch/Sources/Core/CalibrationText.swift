import Foundation

/// Short PT-BR passage read aloud during calibration (Fase 3), with a hand-counted
/// syllable gabarito.
///
/// IMPORTANT: `ptBR.syllableCount` was counted by hand, on paper, without an audio
/// recording to check it against — the exact failure mode the spec warns about for
/// gabaritos in general. Portuguese syllabification has real judgment calls
/// (diphthong vs. hiato, elision in fast speech), so treat this count as a
/// best-effort first pass and re-verify it against an actual recording before
/// trusting calibration results built on it.
public struct CalibrationText {
    public let text: String
    public let syllableCount: Int

    public static let ptBR = CalibrationText(
        text: """
        Hoje eu vou falar sobre um assunto simples. Quero explicar cada ideia \
        com calma, sem pressa, para que todos entendam bem. Isso ajuda bastante \
        numa apresentação.
        """,
        syllableCount: 54
    )
}
