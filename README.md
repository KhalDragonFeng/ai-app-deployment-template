# Qifan Feng — Senior Full-Stack Architect Portfolio

> Production Systems Engineering • Scalable Cloud Architectures • High-Concurrency SaaS Platforms

Welcome to my personal engineering portfolio repository. This repository hosts my interactive architect dashboard, comprehensive career timeline, and detailed technical case studies documenting production systems I have built, migrated, or optimized.

## 🔗 Live Portals & Demo Projects

*   🏠 **Main Gateway Hub:** [https://khaldragonfeng.github.io/portfolio/](https://khaldragonfeng.github.io/portfolio/)
*   💼 **Interactive Resume & Full Portfolio:** [https://khaldragonfeng.github.io/portfolio/portfolio.html](https://khaldragonfeng.github.io/portfolio/portfolio.html)
*   🛡️ **B2B Financial Portal Takeover (AWS DevOps):** [https://khaldragonfeng.github.io/portfolio/project-takeover.html](https://khaldragonfeng.github.io/portfolio/project-takeover.html)
*   🚀 **AI SaaS Marketing Monorepo Case Study:** [https://khaldragonfeng.github.io/portfolio/saas-marketing.html](https://khaldragonfeng.github.io/portfolio/saas-marketing.html)
*   🎮 **WeChat Mini Game Cocos systems case study:** [https://khaldragonfeng.github.io/portfolio/game-showcase.html](https://khaldragonfeng.github.io/portfolio/game-showcase.html)
*   🌐 **Next.js Full-Stack SaaS Starter Codebase:** [https://github.com/KhalDragonFeng/nextjs-saas-starter](https://github.com/KhalDragonFeng/nextjs-saas-starter)
*   ⚙️ **Spring Boot KOL Match Engine Codebase:** [https://github.com/KhalDragonFeng/spring-kol-match-engine](https://github.com/KhalDragonFeng/spring-kol-match-engine)

---

## 📂 Repository Topology

This repository is designed using high-performance vanilla HTML, CSS, and modular ES6 JavaScript. It features zero build overhead, glassmorphic UI design tokens, custom keyframe animations, and custom interactive components (like画廊 tabs and lightbox sliders) coded from scratch to guarantee fast rendering speed and zero dependency bloat.

```
portfolio/
├── index.html                  # Interactive landing portal and entry gateway
├── portfolio.html              # Core portfolio resume (8-yr work history, skills grid)
├── saas-marketing.html         # Case study: Turborepo, 55 data models, multi-LLM router
├── project-takeover.html       # Case study: AWS ECS Fargate, RDS, Caching, CI/CD
├── game-showcase.html          # Case study: Cocos Creator 3.8 decoupled loops, WeChat SDK
│
├── images/                     # Structured telemetries and UI mockups
│   ├── project-game/           # Cocos Creator / WeChat DevTools screen assets
│   ├── project-takeover/       # AWS Console and architecture topologies
│   └── saas-marketing/         # SaaS database schemas and dashboard views
│
└── blueprints/                 # Live DevOps configurations (From B2B Cloud Migration)
    ├── Dockerfile              # Multi-stage production container build configuration
    ├── docker-compose.yml      # Orchestration file mapping app + Nginx + Certbot auto-SSL
    ├── nginx.conf              # Reverse proxy server configuration (security, gzip, SSL)
    ├── DEPLOYMENT.md           # Step-by-step EC2/VPS migration deployment blueprint
    └── .github/workflows/      # CI/CD automation workflow YAML
```

---

## 🛠️ Featured System Highlights

### 1. B2B Financial Data Portal — AWS Production Takeover & Cost Optimization
*   **Implication:** Took over a fragile financial portal running on local SQLite databases and manual FTP deployments. Migrated schemas to AWS RDS PostgreSQL, dockerized runtime services, set up autoscaling ECS Fargate containers behind an Application Load Balancer (ALB), and designed a robust query cache system.
*   **Result:** Handled 100+ concurrent trade-show visitors under a strict **$100/month AWS budget** with >90% cache hit rate. Set up OIDC-authenticated secure GitHub Actions CI/CD.

### 2. AI-Powered SaaS Marketing Monorepo
*   **Implication:** Architected a multi-tenant marketing automation platform composed of 6 applications and 55 relational data models managed via Prisma.
*   **Result:** Designed tRPC-based type-safe endpoints, dual international/domestic billing lines (Stripe + WeChat Pay), and an asynchronous worker queue (BullMQ + Redis) routing tasks through a custom multi-LLM selector interface (OpenAI, Claude, DeepSeek, Gemini).

### 3. WeChat Mini Game — Decoupled TS systems engine
*   **Implication:** Solo-engineered a comedic RPG guild management game (*This Guild is Paying Off Debt*) using Cocos Creator 3.8 and TypeScript.
*   **Result:** Decoupled game core logic state machines from physical coordinate layout positions (allowing artists to update UI coordinates in Cocos without breaking TypeScript schemas). Designed remote asset sub-packaging to bypass WeChat's 4MB startup boundary and programmed Serverless WeChat CloudBase billing endpoints.

---

## ✉️ Contact & Inquiries

Available for full-time architectural positions, systems consulting, and DevOps contract work.

*   **Email:** [outprintfeng@gmail.com](mailto:outprintfeng@gmail.com)
*   **Upwork / GitHub:** Inquiries can be initiated via direct email or the contact forms in the portfolio gateways.
