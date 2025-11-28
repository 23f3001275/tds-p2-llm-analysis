FROM python:3.10-slim

# -----------------------------------------
# 1. Install system dependencies + binaries
# -----------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg ca-certificates curl unzip \
    # Playwright browser dependencies
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 \
    libgtk-3-0 libgbm1 libasound2 libxcomposite1 libxdamage1 libxrandr2 \
    libxfixes3 libpango-1.0-0 libcairo2 \
    # Tesseract OCR + dev headers
    tesseract-ocr libtesseract-dev \
    # ffmpeg for audio processing (pydub, speech_recognition)
    ffmpeg \
    # Extra libs used by image / video / sklearn
    libgl1 libsm6 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------
# 2. Install Playwright and Chromium
# -----------------------------------------
RUN pip install playwright && playwright install --with-deps chromium

# -----------------------------------------
# 3. Install uv (your tools require it)
# -----------------------------------------
RUN pip install uv

# -----------------------------------------
# 4. Prepare app directory
# -----------------------------------------
WORKDIR /app
COPY . .

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8

# -----------------------------------------
# 5. Install Python packages (requirements.txt)
# -----------------------------------------
RUN pip install --no-cache-dir -r requirements.txt

# -----------------------------------------
# 6. Expose port for HuggingFace Spaces
# -----------------------------------------
EXPOSE 7860

# -----------------------------------------
# 7. Run your FastAPI app using uv (required by your tools)
# -----------------------------------------
CMD ["uv", "run", "main.py"]
