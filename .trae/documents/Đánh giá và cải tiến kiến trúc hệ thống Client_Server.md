## Tổng Quan Hiện Trạng
- Client: Nx monorepo với Next.js (App Router, thư mục `app/`), TypeScript, Tailwind, Redux Toolkit. Thư viện dùng chung: `libs/api-client`, `libs/types`, `libs/ui-components`. Kiểm thử bằng Jest, lint bằng ESLint (module boundaries Nx).
- Server: chưa thể truy cập từ workspace hiện tại. Dấu hiệu `.env` cho thấy tích hợp CoinMarketCap API cho dữ liệu dominance/market cap. Sẽ đánh giá chi tiết khi chuyển workspace sang `f:\Personal\big-problem-server`.

## Kiến Trúc Client (đã khảo sát)
- Entry & Routing: `apps/learning-platform/app/layout.tsx`, `app/page.tsx`, API route mẫu `app/api/hello/route.ts` (SSR hợp lý).
- State: Redux Toolkit với Provider tại `app/providers.tsx`; chưa có data fetching layer (RTK Query/TanStack Query/SWR).
- API Client: `libs/api-client` với `getHello({ baseUrl })`; logic suy `baseUrl` từ `headers()`/`NODE_ENV` (cần chuẩn hoá). Có `ApiError` cơ bản.
- Env: `.env.example` gồm biến public (`NEXT_PUBLIC_*`) và server-only (`MONGODB_URI`, `REDIS_URL`) nhưng chưa dùng trong code.
- Build/Test/Lint: Next + Nx plugins, Jest (cấu hình workspace và app), ESLint enforce boundaries.

## Kiến Trúc Server (dự kiến đánh giá)
- Xác định framework (Express/Nest/Fastify), entry (ví dụ `src/main.ts`/`server.ts`), routing/controllers, data layer (ORM/DB), middleware/security, tích hợp CMC API, caching và jobs.
- Chuẩn hoá env/config, logging, quan trắc (metrics/traces), OpenAPI.

## Phân Tích Nghiệp Vụ Hệ Thống
- Bối cảnh: Nền tảng học trực tuyến (suy từ `libs/types`: `User`, `Course`, `Lesson`, `Enrollment`).
- Quy trình chính: đăng ký/đăng nhập; ghi danh khoá học; theo dõi bài học; tính tiến độ; quản lý nội dung; (tuỳ chọn) hiển thị dữ liệu thị trường crypto để minh hoạ/bổ trợ nội dung.
- Đối tượng: học viên, giảng viên, quản trị; phân quyền theo vai trò.

## Khoảng Trống/Rủi Ro
- Client: chưa có data fetching/caching chuẩn; error handling/thông báo còn tối giản; chưa có Error Boundary; cấu hình Tailwind thiếu rõ ràng; biến môi trường chưa được validate; phụ thuộc `mongodb`/`ioredis` chưa dùng; thiếu bảo mật header (CSP), thiếu quan trắc.
- Server: chưa xác nhận bảo mật (CORS/Helmet), rate limiting, chuẩn hoá env; chưa rõ data layer, caching; tích hợp CMC cần chống giới hạn rate và sai số.

## Đề Xuất Cải Tiến
### Client
- Chuẩn hoá API client: wrapper `fetch` với timeout, retry, phân loại lỗi, typed response (zod); chuẩn `baseUrl` dùng `NEXT_PUBLIC_API_BASE_URL` + fallback SSR; tracking request.
- Data layer: áp dụng RTK Query hoặc TanStack Query cho caching/invalidations/SSR; xác định chính sách revalidation (`fetchCache`, `revalidate`), tối ưu hydration.
- Tổ chức module: nhóm theo feature dưới `app/(feature)/...`; tách UI vào `libs/ui-components`; sử dụng Server Actions cho thao tác ghi.
- UI/UX: cấu hình `tailwind.config` + design tokens; Skeleton/Loading/Error states; i18n nếu cần.
- Bảo mật: CSP, X-Frame-Options, Referrer-Policy qua middleware hoặc `next.config.js`; sanitize đầu vào client.
- Kiểm thử: thêm unit test cho `api-client`, component tests (RTL), integration tests cho routes; đặt ngưỡng coverage.
- Quan trắc: logging cơ bản, báo lỗi (Sentry/OpenTelemetry exporter sau).
- Hiệu năng: code-splitting, giảm bundle, Image Optimization, loại bỏ phụ thuộc chưa dùng.

### Server
- Kiến trúc: nếu Express → chuẩn hoá layer (controllers/services/repos/middlewares); nếu Nest → modules/controllers/services.
- Bảo mật: `helmet`, CORS whitelist theo `SITE_URL`, rate limiting, validation (zod/class-validator).
- Env/Config: module cấu hình với schema validate; tách `config/` cho DB/Redis/CMC.
- Data layer: chọn ORM (Prisma/TypeORM/Mongoose) theo DB hiện hữu; migrations, seed.
- Caching & Jobs: Redis (cache CMC, cache responses), BullMQ cho background fetch/sync.
- Tích hợp CMC: service riêng với backoff, circuit breaker, caching, chuẩn hoá DTO.
- API: versioning `/api/v1`, OpenAPI (Swagger), thống nhất contract với `libs/types` client.
- Quan trắc: logger (pino/winston), request ID, metrics (Prometheus), tracing (OTel).
- Kiểm thử: Jest + Supertest, test integration cho controllers/services.
- DevOps: Dockerfile, docker-compose (DB/Redis), CI (lint/test/build), secrets quản lý ngoài repo.

## Lộ Trình Thực Hiện
1) Quick wins Client: chuẩn hoá `api-client`, Error Boundary, cấu hình Tailwind, validate env.
2) Data fetching: tích hợp RTK Query/TanStack Query, chính sách SSR/ISR.
3) Bảo mật & Quan trắc Client: CSP/middleware, logging/error tracking.
4) Đánh giá Server chi tiết: chuyển workspace, audit framework, data layer, bảo mật.
5) Kiến trúc Server: thiết lập modules, config, auth, DB, caching, CMC service, OpenAPI.
6) Đồng bộ contract: sinh types từ OpenAPI hoặc chia sẻ `libs/types`.
7) Kiểm thử & CI/CD: thêm tests, thiết lập pipeline.

## Yêu Cầu Tiếp Theo
- Cho phép truy cập repo server (chuyển workspace) để hoàn thiện đánh giá và kế hoạch chi tiết các hạng mục backend.
- Sau khi xác nhận kế hoạch, tôi sẽ bắt đầu triển khai theo lộ trình trên (ưu tiên các quick wins ở client).