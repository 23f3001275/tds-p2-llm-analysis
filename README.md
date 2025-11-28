# 🧠 LLM Analysis — Autonomous Quiz Solver Agent

An autonomous multi-tool agent built with **LangGraph**, **LangChain**, and **Google Gemini 2.5 Flash** to solve multi-step data-science quizzes.  
The agent scrapes quiz pages, downloads files, processes data, executes Python code, and submits answers—fully automatically.

---

## 🚀 Overview

This project was developed for the **Tools in Data Science (TDS)** course at IIT Madras.

The agent can:

- Render & scrape **JavaScript-heavy pages** (Playwright + Chromium)
- Download & process PDFs, CSVs, images
- Perform **OCR** (Tesseract)
- Perform **audio transcription** (SpeechRecognition + FFmpeg)
- Encode images to Base64
- Generate & execute Python code
- Install missing dependencies dynamically using `uv`
- Solve chained quiz URLs and submit answers
- Run on Hugging Face Spaces via Docker

---

## 🏗 Architecture


```
FastAPI → Agent (Gemini 2.5 Flash) → Tool Router
                       │
       ┌───────────────┴───────────────┬───────────────┬──────────────┐
       ▼                               ▼               ▼              ▼
Web Scraper                    Code Executor     File Downloader   POST Request Tool
(Playwright)                      (Python)           (Files)         (Submissions)
```


### Core Components

| File | Role |
|------|------|
| `main.py` | FastAPI server exposing `/solve` |
| `agent.py` | LangGraph-based autonomous agent |
| `tools/` | Tools for scraping, running code, downloading files, submitting requests, adding dependencies |
| `Dockerfile` | Deployable container with Playwright |
| `pyproject.toml` | Dependency specifications |

---

## 📂 Project Structure
```
LLM-Analysis-TDS-Project-2/
├── agent.py
├── main.py
├── tools/
│   ├── web_scraper.py
│   ├── download_file.py
│   ├── run_code.py
│   ├── send_request.py
│   ├── add_dependencies.py
│   ├── audio_transcribing.py
│   ├── image_content_extracter.py
│   ├── encode_image_to_base64.py
│   └── __init__.py
├── requirements.txt
├── shared_store.py
├── Dockerfile
└── README.md
```

---

## ⚙️ Installation (Using `venv`)

### 1. Clone the Repository

```
git clone https://github.com/23f3001275/tds-p2-llm-analysis.git
cd LLM-Analysis-TDS-Project-2
```

### 2. Create & Activate Virtual Environment

#### Windows:
```
python -m venv venv
venv\Scripts\activate
```

#### macOS / Linux:
```
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Python Dependencies
```
pip install -r requirements.txt
 ```

### 4. Install Binary Dependencies (VERY IMPORTANT)

These are required for OCR, audio transcription, and Playwright.

#### Windows

Install:

- [Tesseract OCR](https://github.com/UB-Mannheim/tesseract/wiki)
-FFmpeg
Install via Chocolatey:
```
choco install ffmpeg
```
-Playwright Chromium
```
playwright install chromium
```

#### macOS / Linux
```
sudo apt-get update
sudo apt-get install -y ffmpeg tesseract-ocr libtesseract-dev
playwright install --with-deps chromium
```
---

## 🔧 Environment Configuration

Create a `.env` file:
```
EMAIL=your.email@example.com
SECRET=your_secret_string
GOOGLE_API_KEY=your_gemini_api_key
```
[Get Gemini API Key](https://aistudio.google.com/app/apikey)

## ▶️ Running the Server

Run using Python:
```
python main.py
```
The service runs at:
```
http://0.0.0.0:7860
```
---

## 🌐 Usage

### Trigger the Autonomous Quiz Solver

Send a POST request:
```
curl -X POST http://localhost:7860/solve \
  -H "Content-Type: application/json" \
  -d '{
    "email": "your.email@example.com",
    "secret": "your_secret_string",
    "url": "https://tds-llm-analysis.s-anand.net/demo"
  }'
```

Expected response:
`{ "status": "ok" } `

The agent will continue solving in the background.

---

## 🛠 Tools Overview

| Tool | Purpose |
|------|---------|
| `get_rendered_html` | Render JS pages via Playwright |
| `download_file` | Download PDFs/CSVs/images |
| `run_code` | Execute generated Python using `uv run` |
| `add_dependencies` | Install missing packages using `uv add` |
| `send_request` | Submit quiz answers |
| `audio_transcribing` | Speech-to-text via SpeechRecognition + ffmpeg |
| `encode_image_to_base64` | Convert images to base64 |
| `image_content_extracter` | Extract text/content from images |
| `pytesseract` | OCR |

--- 

## 🐳 Deploying to Hugging Face (Docker)

This project **must** be deployed using **Docker Spaces** because it requires:

- Tesseract OCR binaries  
- FFmpeg  
- Chromium browser  
- Additional system libraries  

### 1. Create a Hugging Face Space
- Go to https://huggingface.co/spaces  
- Click **Create Space**  
- Choose **Docker** as the SDK

### 2. Add secrets under **Settings → Variables and secrets**

| Name | Value |
|------|--------|
| `EMAIL` | your email |
| `SECRET` | your secret |
| `GOOGLE_API_KEY` | your Gemini API key |

### 3. Push your code & Dockerfile
Upload:
- `main.py`
- `agent.py`
- `tools/`
- `requirements.txt`
- `Dockerfile`
- `shared_store.py`
- `README.md`

### 4. Hugging Face will auto-build and serve your API over HTTPS:

`https://huggingface.co/spaces/<username>/<space-name> `


Run container:
```
docker run -p 7860:7860 \
  -e EMAIL="your.email@example.com" \
  -e SECRET="your_secret_string" \
  -e GOOGLE_API_KEY="your_api_key" \
  llm-analysis-agent
```

## 🐳 Dockerfile (Included in Repo)

The Dockerfile installs:

- Playwright + Chromium  
- Tesseract OCR  
- FFmpeg  
- All Python packages  
- uv (required by your tools)  
- FastAPI startup  

---

## 🔍 How It Works

1. Receive and validate the `/solve` request  
2. Check the `secret`  
3. Launch the agent in the background  
4. Agent loads the quiz URL  
5. Extracts instructions from the rendered page  
6. Uses the appropriate tools to:
   - Scrape HTML  
   - Download files  
   - Parse PDFs  
   - OCR images  
   - Transcribe audio  
   - Run Python code dynamically  
7. Submits the answer to the endpoint on the quiz page  
8. If a new URL is returned → continue solving  
9. If no new URL is returned → output **END**  

---

## 📄 License

Licensed under the MIT License.








