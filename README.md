# ralf-wiggum-rhoai-kitchen-sink

Ralf Wiggum Loop for RHOAI Workshops over all features.

## Harness

Created the [initial plan](write-a-ralf-wiggum-vectorized-sutherland.md) with claude then everything else with opencode.

```bash
npm i opencode-ai@latest
```

## Model

GLM-5.3-Flash

```bash
vi ~/.config/opencode/opencode.json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "maas": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "RedHat MaaS",
      "api": "https://maas.apps.<your-cluster-domain>/prelude-maas/glm-53-flash/v1",
      "env": [
        "OPENAI_API_KEY"
      ],
      "models": {
        "glm-53-flash": {
            "name": "glm-53-flash",
            "attachment": true,
            "modalities": {
              "input": ["text","image"],
              "output": ["text"]
            }
        }
    }
  },
  "permission": {
    "*": {
      "*": "allow"
    }
  }
}
```

## Method

see [CLAUDE.md](CLAUDE.md)
