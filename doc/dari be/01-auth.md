# Auth

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Endpoint login tidak memerlukan autentikasi. Semua endpoint lain wajib menyertakan token di header setiap request.

## Mekanisme Autentikasi

Proyek ini menggunakan **Laravel Sanctum personal access token**. Setelah login, server membuat token baru dan mengembalikannya pada response. Token wajib dikirim di setiap request berikutnya via header:

```
Authorization: Bearer <token>
```

Saat login, token lama user akan dihapus lalu diganti token baru. Saat logout, token aktif saat ini akan dihapus (revoke).

Autentikasi endpoint API dilakukan oleh middleware `auth:sanctum`, sedangkan pembatasan role admin ditangani oleh middleware `ApiAuthMiddleware`.

---

## `POST /auth/login`

Login pengguna. Token Sanctum baru akan dibuat dan dikembalikan.

**Request Body:**

```json
{
  "email": "admin@inventorytrack.com",
  "password": "secret123"
}
```

**Response `200`:**

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "lokas_a1b2c3d4e5f6...",
    "user": {
      "id": 1,
      "name": "Administrator",
      "email": "admin@inventorytrack.com",
      "role": "admin"
    }
  }
}
```

**Response `401`:**

```json
{
  "errors": {
    "message": ["Unauthorized"]
  }
}
```

---

## `POST /auth/logout`

Logout pengguna. Token aktif saat request ini akan dihapus/revoke.

**Header:**
```
Authorization: Bearer <token>
```

**Response `200`:**

```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## `GET /auth/me`

Mendapatkan data pengguna yang sedang login berdasarkan token.

**Header:**
```
Authorization: Bearer <token>
```

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Administrator",
    "email": "admin@inventorytrack.com",
    "role": "admin"
  }
}
```

