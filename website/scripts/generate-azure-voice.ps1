param(
  [string]$Voice = "en-US-JennyNeural",
  [string]$Style = "friendly"
)

$ErrorActionPreference = "Stop"

if (-not $env:AZURE_SPEECH_KEY) {
  throw "Set AZURE_SPEECH_KEY before running this script."
}

if (-not $env:AZURE_SPEECH_REGION) {
  throw "Set AZURE_SPEECH_REGION before running this script, for example: eastus"
}

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root "assets\voice"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$scenes = @(
  "Welcome to TurnReady. Think of it as an AI operations assistant for property maintenance. It helps property teams lower costs, prevent emergencies, keep tenants happier, and reduce wasted labor.",
  "Here is where TurnReady becomes powerful. When a resident reports a burst pipe, flooding, smoke, a sewer backup, carbon monoxide, or a broken lock, the system recognizes the urgency and pushes the work order toward emergency response.",
  "Next, TurnReady reduces the typing and guessing. It suggests the maintenance category, the priority, the worker skill code, the response window, the resident update, and even the parts a worker may need before arriving.",
  "Visual AI is part of the product roadmap. Maintenance photos can become damage summaries, before-and-after proof, repair verification, and cleaner documentation for the property team.",
  "Smart sensors make the system proactive. Leak sensors, humidity sensors, temperature alerts, access events, smoke alerts, and carbon monoxide signals can eventually create work orders before a small issue becomes expensive damage.",
  "Finally, the AI command center connects daily maintenance to business results. Managers can see repeat issues, urgent risk, labor waste, and cost-saving opportunities before they turn into bigger problems."
)

function ConvertTo-SsmlText([string]$Text) {
  return [System.Security.SecurityElement]::Escape($Text)
}

for ($i = 0; $i -lt $scenes.Count; $i++) {
  $sceneNumber = $i + 1
  $escapedText = ConvertTo-SsmlText $scenes[$i]
  $ssml = @"
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="en-US">
  <voice name="$Voice">
    <mstts:express-as style="$Style">
      <prosody rate="-6%" pitch="-1%">
        $escapedText
      </prosody>
    </mstts:express-as>
  </voice>
</speak>
"@

  $uri = "https://$env:AZURE_SPEECH_REGION.tts.speech.microsoft.com/cognitiveservices/v1"
  $outFile = Join-Path $outDir "scene-$sceneNumber.mp3"

  Invoke-WebRequest `
    -Uri $uri `
    -Method Post `
    -Headers @{
      "Ocp-Apim-Subscription-Key" = $env:AZURE_SPEECH_KEY
      "X-Microsoft-OutputFormat" = "audio-24khz-96kbitrate-mono-mp3"
      "User-Agent" = "TurnReadyWebsite"
    } `
    -ContentType "application/ssml+xml" `
    -Body $ssml `
    -OutFile $outFile

  Write-Host "Created $outFile"
}
