# Fixtures

`synthetic_5.wav` and `synthetic_12.wav` are synthesized sine-burst placeholders
(Hann-windowed tones separated by silence), not real speech. They exist only to
smoke-test the harness end-to-end — they're too clean to say anything about real
detector accuracy.

Fase 1's acceptance criterion (mean absolute error under 10%, across at least 5
files of *different voices*) requires real recorded speech:

- 16 kHz, mono `.wav`
- Someone reads a short passage; you count syllables by hand
- Add an entry to `groundtruth.json`: `{"file": "name.wav", "syllables": N}`

Drop new recordings in this folder and add their ground-truth entry — no code
changes needed to pick them up.
