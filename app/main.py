from fastapi import FastAPI

app = FastAPI(title="Resume Analyzer")


@app.get("/health")
def health():
    return {"status": "healthy"}
