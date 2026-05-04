# TurnReady Premium AI Voice Tour

The website currently uses browser speech as a fallback. For a smoother, more advanced American AI voice, generate MP3 narration files with Azure AI Speech and place them here:

```text
website/assets/voice/scene-1.mp3
website/assets/voice/scene-2.mp3
website/assets/voice/scene-3.mp3
website/assets/voice/scene-4.mp3
website/assets/voice/scene-5.mp3
website/assets/voice/scene-6.mp3
```

After those files exist and are pushed to GitHub, the website will automatically use them before falling back to browser voice.

Recommended Azure neural voices:

```text
en-US-JennyNeural
en-US-AriaNeural
en-US-GuyNeural
```

Recommended style:

```text
friendly
```

Recommended pacing:

```text
rate="-6%"
pitch="-1%"
```

Important: do not put your Azure Speech key inside `index.html`. Generate the MP3 files locally, then upload only the MP3 files.
