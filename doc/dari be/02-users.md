# Users

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Semua endpoint memerlukan Bearer Token. Endpoint yang bertanda *(Admin only)* hanya bisa diakses oleh pengguna dengan role `admin`.

---

## Skema User

```json
{
  "id": 1,
  "name": "Budi Santoso",
  "email": "budi@example.com",
  "role": "staff"
}
```

> Kolom `password` tidak dikembalikan dalam response API.

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | PK | Primary key |
| `name` | varchar | Nama pengguna |
| `email` | varchar | Email unik |
| `password` | varchar | Disimpan ter-hash |
| `role` | enum | `admin` \| `staff` |

---

## `GET /users`

Daftar semua pengguna. *(Admin only)*

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `role` | enum | `admin` \| `staff` |
| `search` | string | Cari berdasarkan nama atau email |
| `sort_by` | enum | `name` \| `email` \| `role` \| `created_at` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |
| `page` | integer | Default: `1` |
| `per_page` | integer | Default: `15` |

**Response `200`:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Administrator",
      "email": "admin@inventorytrack.com",
      "role": "admin"
    },
    {
      "id": 2,
      "name": "Budi Santoso",
      "email": "budi@example.com",
      "role": "staff"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 15,
    "total": 2,
    "last_page": 1
  }
}
```

**Response `403`:** Forbidden – hanya admin.

---

## `POST /users`

Tambah pengguna baru. *(Admin only)*

**Request Body:**

```json
{
  "name": "Andi Wijaya",
  "email": "andi@example.com",
  "password": "password123",
  "role": "staff"
}
```

| Field | Wajib | Keterangan |
|---|---|---|
| `name` | ✅ | |
| `email` | ✅ | |
| `password` | ✅ | Minimal 8 karakter |
| `role` | ✅ | `admin` \| `staff` |

**Response `201`:**

```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "id": 3,
    "name": "Andi Wijaya",
    "email": "andi@example.com",
    "role": "staff"
  }
}
```

**Response `422`:** Validasi gagal.

---

## `GET /users/{id}`

Detail pengguna.

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 2,
    "name": "Budi Santoso",
    "email": "budi@example.com",
    "role": "staff"
  }
}
```

**Response `404`:** Pengguna tidak ditemukan.

**Response `401`:** Unauthorized (token tidak valid/tidak ada).

---

## `PUT /users/{id}`

Update pengguna. *(Admin only)*

**Request Body (semua field opsional):**

```json
{
  "name": "Andi Wijaya Updated",
  "email": "andi@example.com",
  "password": "newpassword123",
  "role": "admin"
}
```

**Response `200`:**

```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "id": 3,
    "name": "Andi Wijaya Updated",
    "email": "andi@example.com",
    "role": "admin"
  }
}
```

**Response `404`:** Pengguna tidak ditemukan.

**Response `401`:** Unauthorized (token tidak valid/tidak ada).

---

## `DELETE /users/{id}`

Hapus pengguna. *(Admin only)*

**Response `200`:**

```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

**Response `404`:** Pengguna tidak ditemukan.

**Response `401`:** Unauthorized (token tidak valid/tidak ada).

**Response `403`:** Forbidden – Anda tidak diperbolehkan menghapus akun sendiri.
