# Real-World Work Simulation

My other work in this repo answers specific business questions on the Olist e-commerce dataset. This folder is different. Here I try to show what the day-to-day of a junior data analyst actually looks like: messy data, vague requests, a mentor reviewing my thinking, and decisions that need to be explained, not just coded.

## How it works

I set up a simulated job at a mid-size e-commerce company ("Loja"). A senior analyst (Priya) acts as my mentor and gives me tasks the way a real team would. I work through them, report back, get pushed on my reasoning, and fix things. Each case study here is written up from one of those task threads, including the wrong turns and the corrections.

## Setup

- **Data:** Olist Brazilian E-Commerce public dataset (Kaggle)
- **Database:** PostgreSQL + pgAdmin, running locally
- **Other tools:** Excel, Power BI, Python (as the simulation moves forward)

## Case studies

| Case study | What it covers | Skills shown |
|---|---|---|
| [Category translation and the `products_enriched` view](case-study-category-translation-view.md) | Found product categories with no English translation, made a documented decision on them, and packaged the fix as a reusable view | Data validation, LEFT JOIN checks, SQL views, documentation habits |
| [Investigating null product categories](case-study-null-category-investigation.md) | Traced 610 null-category products back to one seller with a near-empty catalog, and tied it to about 1.32% of revenue | Root-cause analysis, segmentation, business impact sizing, recommendations |

## What I'm trying to show

- Checking the data before building on top of it
- Not stopping at the first answer, and going back when something doesn't add up
- Connecting a data issue to a business number
- Documenting decisions so someone else can follow them later

More case studies will be added as the simulation continues.
