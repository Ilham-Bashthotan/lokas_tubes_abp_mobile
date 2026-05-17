# Categories

**Base URL:** `http://api.lokas-tubes-abp.test/api`

> Semua endpoint memerlukan Bearer Token. Endpoint yang bertanda *(Admin only)* hanya bisa diakses oleh pengguna dengan role `admin`.

---

## Skema Category

```json
{
  "id": 1,
  "name": "Elektronik",
  "description": "Perangkat elektronik kantor"
}
```

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | integer | |
| `name` | string | |
| `description` | string \| null | |

---

## `GET /categories`

Daftar semua kategori.

**Query Parameters:**

| Parameter | Tipe | Keterangan |
|---|---|---|
| `search` | string | Cari berdasarkan name atau description |
| `sort_by` | enum | `name` \| `created_at` \| `updated_at` |
| `sort_dir` | enum | `asc` \| `desc` (default: `desc`) |

**Response `200`:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Elektronik",
      "description": "Perangkat elektronik kantor",
      "created_at": "2026-03-26T19:25:19.000000Z",
      "updated_at": "2026-03-26T19:25:19.000000Z"
    }
  ]
}
```

---

## `GET /categories/{id}`

Detail kategori.

**Response `200`:**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Elektronik",
    "description": "Perangkat elektronik kantor",
    "created_at": "2026-03-26T19:25:19.000000Z",
    "updated_at": "2026-03-26T19:25:19.000000Z"
  }
}
```

**Response `404`:** Kategori tidak ditemukan.

---

## `POST /categories`

Tambah kategori baru. *(Admin only)*

**Request Body:**

```json
{
  "name": "Peralatan Kantor",
  "description": "Kursi, meja, lemari, dll"
}
```

| Field | Wajib | Keterangan |
|---|---|---|
| `name` | ✅ | |
| `description` | ❌ | |

**Response `201`:**

```json
{
  "success": true,
  "message": "Category created successfully",
  "data": {
    "id": 2,
    "name": "Peralatan Kantor",
    "description": "Kursi, meja, lemari, dll",
    "created_at": "2026-04-06T12:30:00.000000Z",
    "updated_at": "2026-04-06T12:30:00.000000Z"
  }
}
```

**Response `422`:** Validasi gagal.

```json
{
  "success": false,
  "errors": {
    "name": ["The name field is required."]
  }
}
```

---

## `PUT /categories/{id}`

Update kategori. *(Admin only)*

**Request Body (semua field opsional):**

```json
{
  "name": "Peralatan Kantor Updated",
  "description": "Deskripsi baru"
}
```

**Response `200`:**

```json
{
  "success": true,
  "message": "Category updated successfully",
  "data": {
    "id": 2,
    "name": "Peralatan Kantor Updated",
    "description": "Deskripsi baru",
    "created_at": "2026-04-06T12:30:00.000000Z",
    "updated_at": "2026-04-06T13:00:00.000000Z"
  }
}
```

**Response `404`:** Kategori tidak ditemukan.

**Response `422`:** Validasi gagal.

---

## `DELETE /categories/{id}`

Hapus kategori. *(Admin only)*

**Response `200`:**

```json
{
  "success": true,
  "message": "Category deleted successfully"
}
```

**Response `404`:** Kategori tidak ditemukan.

**Response `422`:** Kategori masih dipakai item.

```json
{
  "success": false,
  "message": "Cannot delete category that is still used by items"
}
```
