## Phạm Vi
- Đánh giá – chỉnh lý kiến trúc monorepo Nx, App Next.js, libs dùng chung.
- Chuẩn hóa tầng API client, mô hình dữ liệu, state management, và kiểm thử.

## Việc Cần Làm Ngay
1. Sửa unit test hỏng ở `libs/api-client` để khớp `getHello(...)`.
2. Chuẩn hóa resolve `baseUrl` (hỗ trợ proxy: `x-forwarded-host`, `x-forwarded-proto`).
3. Thêm mô-đun domain `libs/types` với kiểu dữ liệu thật cho nghiệp vụ.
4. Thiết lập boundary tags trong ESLint để kiểm soát phụ thuộc giữa libs.
5. Bố trí `Redux Toolkit` (store, slice, `Provider`) nếu cần client state.

## Kiến Trúc Libs (Đề Xuất)
- `libs/types`: mô hình domain (User, Course, Lesson, Enrollment, ...), DTO, enums.
- `libs/api-client`: wrapper HTTP typed, error handling thống nhất; tách `hello` thành module mẫu.
- `libs/ui-components`: atomic design (atoms/molecules/organisms), theme tokens; dùng `class-variance-authority`/`tailwind-merge`.
- (Tùy chọn) `libs/data-access`: adapter MongoDB/Redis (server-only), repository pattern.

## Tầng Ứng Dụng (Next.js)
- App Router: tách route theo feature (ví dụ `app/courses`, `app/lessons`).
- Server Actions/Route Handlers: xác thực input/output bằng `zod`.
- Env: dùng `apps/learning-platform/env.ts` làm nguồn duy nhất cho biến môi trường.
- SSR vs CSR: quy ước rõ page/layout server/client; dùng API client tương thích cả hai.

## Kiểm Thử
- Unit: libs (`api-client`, `types`, `ui-components`).
- Integration: route handlers `app/api/*` với `next/jest`/`jest-environment-node`.
- Component: Testing Library cho UI components; tránh render trực tiếp server component `page.tsx`.

## Chất Lượng & CI
- ESLint + Prettier giữ nguyên; bổ sung rule cho module boundaries theo tag.
- Jest projects đã có; thêm coverage thresholds theo thư viện.
- (Tùy chọn) Nx Cloud cho cache/distribute.

## Bảo Mật
- Tuyệt đối không log secret; tách `server` và `public` env bằng `zod`.
- Hardening fetch: timeout, retry có kiểm soát, phân loại lỗi.

## Lộ Trình Triển Khai
1. Fix tests và `baseUrl` (nhanh).
2. Khởi tạo kiểu `types` cho 1–2 thực thể chính.
3. Chuẩn hóa API client + error model.
4. Áp dụng ESLint boundary tags.
5. Tích hợp Redux nếu có yêu cầu state client.
6. Viết thêm integration tests cho `app/api/*`.

## Kết Quả Kỳ Vọng
- Kiến trúc rõ ràng, libs có ranh giới, test xanh.
- API client ổn định cho SSR/CSR, sẵn sàng mở rộng nghiệp vụ.
- Cơ sở cho mở rộng tính năng học tập (courses/lessons/users).