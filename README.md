# Gap AI Prototype (VS Code)

A runnable interactive prototype of the requested Gap AI student growth platform. This is a new prototype build, not the earlier landing-page-only ZIP. It includes demo role access, student/mentor/admin workspaces, a learning dashboard, skill mastery, leaderboards, quests/XP, assignments, assessments, intervention workflows, timetable/resources, a stack simulation, local persistence, and an optional server-side Groq tutor endpoint.

## Run on Windows

1. Install Node.js 18 or newer.
2. Extract the ZIP.
3. Open the `GAP-AI-Prototype` folder in VS Code.
4. Open **Terminal → New Terminal** and run:

```powershell
npm start
```

5. Open `http://localhost:5173` in your browser.
6. Choose Student, Mentor / Teacher, or Administrator. Demo access requires no password.

Run `npm install` once after extracting the project to install the browser OCR dependency. Then start the app with `npm start`.

## Enable Groq AI tutor (optional)

1. Create a Groq API key in your Groq console. Do not paste it into chat or frontend files.
2. Copy `.env.example` to `.env` in this folder.
3. Edit `.env` and set `GROQ_API_KEY=your_key_here` (keep the key private; `.env` is gitignored).
4. Stop the server with `Ctrl+C`, then run `npm start` again.
5. Open AI tutor inside the app. The backend sends requests to Groq; the browser never receives the key. The Skills page also uses Groq to generate a fresh four-question test tailored to the selected concept and the learner's current mastery.

The default model is `openai/gpt-oss-120b`. If your account does not offer that model, set `GROQ_MODEL` in `.env` to a chat model available to your Groq account. Direct answer-image analysis uses `qwen/qwen3.8-27b` by default; set `GROQ_VISION_MODEL` if you need a different vision-capable model. Free-tier quotas and availability are controlled by Groq.

## Shared ML subject notes

The Resources page supports shared PDF, TXT, Markdown, CSV, DOC, DOCX, PPT, and PPTX notes. Uploaded files (up to 5 MB each) and their metadata are stored in the `public.ml_notes` PostgreSQL table; learners can list and download them. Configure `DATABASE_URL` in the local `.env` with the Neon connection string and apply [`migrations/001_ml_notes.sql`](./migrations/001_ml_notes.sql) before using the shared notes feature. Files are stored in PostgreSQL `bytea`, not object storage.

The prototype's role picker is not real authentication. Do not expose its upload API publicly or upload private/student files until production authentication, authorization, and storage controls are implemented.

## Prototype boundaries (important)

- Demo login is role selection, not production authentication.
- User and learning data are stored in the current browser's `localStorage`; this is not multi-device or institution-grade database persistence.
- The general resource page still records selected filenames only. Shared ML notes are stored separately in PostgreSQL; this feature does not index documents for RAG.
- Grading review can extract English text from JPG, PNG, and WebP answer images using Tesseract.js in the browser. The image stays in the browser; English recognition data is downloaded from the Tesseract data host on first use. Printed text generally works best; handwritten recognition may be inaccurate and must be checked. Alternatively, teachers can explicitly opt in to send an answer image (up to 8 MB) to the server for Groq vision transcription and analysis. The server sends the image, question, and marking guide to Groq; the Groq API key is not sent to the browser. The transcription is editable for review. Without image opt-in, only the manually reviewed answer text, question, and marking guide are sent to Groq. Do not include student-identifying information. OCR and AI suggestions can be wrong; scores are not final grades and require teacher review.
- Student metrics and cohort records are seeded demo data. Do not use them for real academic decisions.
- For production: add real authentication, tenant isolation, private object storage, background jobs, document indexing, calibrated grading, audit trails, and automated tests.

## Checks

Run `npm run check` to check the server's JavaScript syntax. Run `node server.js` / `npm start` and visit `/api/health` to check the local API. Groq itself requires a valid private key and internet access.
