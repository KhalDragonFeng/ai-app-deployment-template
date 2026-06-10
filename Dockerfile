# =============================================================================
# Multi-stage Dockerfile for AI-generated Node.js / Next.js applications
# =============================================================================
# Stage 1: Install dependencies
# Stage 2: Build the application
# Stage 3: Production runtime (minimal image)
# =============================================================================

# ------- Stage 1: Dependencies -------
FROM node:20-alpine AS deps

# Add libc6-compat for Alpine compatibility with some npm packages
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copy package manager lock files
# Supports npm, yarn, and pnpm
COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./

# Install dependencies based on the available lock file
RUN \
  if [ -f pnpm-lock.yaml ]; then \
    corepack enable pnpm && pnpm install --frozen-lockfile; \
  elif [ -f yarn.lock ]; then \
    yarn install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then \
    npm ci; \
  else \
    echo "No lock file found. Running npm install..." && npm install; \
  fi


# ------- Stage 2: Build -------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependencies from previous stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Set build-time environment variables
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# Build the application
RUN \
  if [ -f pnpm-lock.yaml ]; then \
    corepack enable pnpm && pnpm run build; \
  elif [ -f yarn.lock ]; then \
    yarn build; \
  else \
    npm run build; \
  fi


# ------- Stage 3: Production Runtime -------
FROM node:20-alpine AS runner

WORKDIR /app

# Security: run as non-root user
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 appuser

# Set production environment
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Copy built application
# --- For Next.js standalone mode (recommended) ---
COPY --from=builder /app/public ./public
COPY --from=builder --chown=appuser:appgroup /app/.next/standalone ./
COPY --from=builder --chown=appuser:appgroup /app/.next/static ./.next/static

# --- For non-Next.js or non-standalone builds, uncomment below instead ---
# COPY --from=builder --chown=appuser:appgroup /app/package.json ./
# COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
# COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
# COPY --from=builder --chown=appuser:appgroup /app/.next ./.next
# COPY --from=builder --chown=appuser:appgroup /app/public ./public

USER appuser

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# --- For Next.js standalone mode ---
CMD ["node", "server.js"]

# --- For standard Next.js, uncomment below ---
# CMD ["npx", "next", "start"]

# --- For Express / Fastify / custom server, uncomment below ---
# CMD ["node", "dist/index.js"]
