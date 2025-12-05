FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci

FROM deps AS build
WORKDIR /app
COPY nx.json tsconfig.base.json eslint.config.mjs jest.preset.cjs jest.config.ts ./
COPY apps/learning-platform ./apps/learning-platform
COPY libs ./libs
RUN npx nx run learning-platform:build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev
# Copy built app assets
COPY --from=build /app/apps/learning-platform/.next ./apps/learning-platform/.next
COPY --from=build /app/apps/learning-platform/public ./apps/learning-platform/public
# Start from app directory using root node_modules
WORKDIR /app/apps/learning-platform
EXPOSE 3000
CMD ["node", "../../node_modules/next/dist/bin/next", "start", "-p", "3000"]

