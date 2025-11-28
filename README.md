# 🧠 LLM Analysis — Autonomous Quiz Solver Agent

An autonomous multi-tool agent built with **LangGraph**, **LangChain**, and **Google Gemini 2.5 Flash** to solve multi-step data-science quizzes.
The agent scrapes quiz pages, downloads files, processes data, executes Python code, and submits answers—fully autonomously.

---

## 🚀 Overview

This project was developed for the **Tools in Data Science (TDS)** course at IIT Madras.

The agent performs:

- Scraping JavaScript-rendered pages via Playwright
- Downloading and processing PDFs, CSVs, images
- Running dynamically generated Python code
- Automatically installing missing Python packages
- Navigating multi-step quiz chains
- Submitting answers via POST requests
- Running locally or via Docker

---

## 🏗️ Architecture
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
│   ├── run_code.py
│   ├── download_file.py
│   ├── send_request.py
│   ├── add_dependencies.py
│   └── __init__.py
├── Dockerfile
├── pyproject.toml
├── README.md
└── .env.example
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

### 3. Install Dependencies
```
pip install -r requirements.txt
 ```

### 4. Install Playwright Browser
``` 
playwright install chromium
```

### 5. Install uv (required)
```
pip install uv
```

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


## 🛠️ Tools Overview

| Tool | Description |
|------|-------------|
| `get_rendered_html` | JS-rendered HTML scraping using Playwright |
| `run_code` | Executes generated Python scripts |
| `download_file` | Saves PDFs, CSVs, images |
| `post_request` | Submits quiz answers |
| `add_dependencies` | Installs missing Python dependencies dynamically |


## 🐳 Docker Deployment (Optional)

Build image:
```
docker build -t llm-analysis-agent .
```


Run container:
```
docker run -p 7860:7860 \
  -e EMAIL="your.email@example.com" \
  -e SECRET="your_secret_string" \
  -e GOOGLE_API_KEY="your_api_key" \
  llm-analysis-agent
```

## 🔎 How It Works

1. FastAPI receives a quiz URL
2. LangGraph agent analyzes the page
3. The LLM chooses tools (scraper, runner, downloader, etc.)
4. Tools collect and process quiz data
5. Agent submits answer
6. If next URL exists → continues
7. Ends when quiz chain is complete

Everything runs fully autonomously.

## 📄 License

Licensed under the MIT License.






